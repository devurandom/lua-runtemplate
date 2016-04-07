#!/usr/bin/lua

local function script_path()
  local source = debug.getinfo(2, "S").source
  if source:sub(1,1) == "@" then
    source = source:sub(2)
  end
  local source_directory = source:match("(.*/)")
  return source_directory
end

package.path = script_path() .. "?.lua;" .. package.path

local tsub = require "pl.template".substitute
local copy = require "pl.tablex".copy
local stropen = require "pl.stringio".open
local lapp = require "pl.lapp"
local lfs = require "lfs"
local union = require "tablexx".union
local unpack = require "table".unpack

local template_config = {
	_escape = ">",
	_inline_escape = "$",
	_brackets = "<>",
}

local function include(file, indent)
	if type(file) == "string" then
		file = assert(io.open(file))
	end

	if not indent then
		indent = ""
	end

	local lines = file:lines()

	local text = ""
	line_number = 1
	for line in lines do
		if line_number == 1 then
			text = text .. line .. "\n"
		else
			text = text .. indent .. line .. "\n"
		end
		line_number = line_number + 1
	end

	return text
end

local function include_template(template_filename, indent, env)
	local template_file = assert(io.open(template_filename, "r"))
	local template = template_file:read("*a")
	template_file:close()

	if not env then
		env = indent
		indent = nil
	end

	local env = copy(env)
	env = union(env, template_config)
	env = union(env, {_filename = template_filename})

	local text = assert(tsub(template, env))
	local file = assert(stropen(text))

	return include(file, indent)
end

local function runtemplate(script_filename, ...)
	local arg = ...

	local args = lapp(assert(tsub([[
Parse file as a template, reading template parameters from another file
	<config> (file-in default $<script_filename:gsub(".lua$", ".cfg")>) Configuration file
	<template> (file-in default stdin) Template file
	<output> (file-out default stdout) Output file
]], union(template_config, {script_filename = script_filename}))))

	if type(args.config) == "string" then
		args.config_name = args.config
	end

	if args.template == io.stdin then
		args.template_name = "STDIN"
	end

	if args.output == io.stdout then
		args.output_name = "STDOUT"
	end

	-- We need to pass the filename to dofile() and use LAPP only for the nice error messages
	args.config:close()

	local config = assert(dofile(args.config_name))

	if config._preprocess then
		config = config:_preprocess(args)
	end

	local env = copy(template_config)
	env = union(env, {
		-- functions
		include = include,
		template = include_template,
		pairs = pairs,
		ipairs = ipairs,
		string = string,
		-- internal info
		_filename = args.template_name,
	})
	env = union(env, config)

	local template_file = args.template
	local template = template_file:read("*a")
	template_file:close()

	local text = assert(tsub(template, env))

	local output_file = args.output
	assert(output_file:write(text))
	output_file:close()
end

local script_filename = arg[0]
runtemplate(script_filename, unpack(arg))
