# runtemplate.lua

A standalone template instantiation script built on top of [Penlight](http://stevedonovan.github.io/Penlight) with some convenience features.

## Usage

```
./runtemplate.lua [<config filename>] [<template filename>] [<output filename>] -- <options to preprocess fn>
```

All arguments are optional, providing sensible defaults.

### Config filename

The file `config filename` is executed as a Lua script and is expected to return a table that is used as the environment within the template.

Defaults to: Name of the script (`arg[0]`) with `.lua` replaced with `.cfg`.

### Template filename

The template file to instantiate. Unlike the default Penlight configuration, we use `@{...}` to mark inline code and `#@ ...` to mark code lines.

Defaults to: stdin

### Output filename

Defaults to: stdout

### Extra arguments

Any additional arguments (after those three described above or after `--` if you want to use default values for any previous parameters) will be passed to the `config:_preprocess(args)` function, if it exists. (`config` being the table returned by the config file.)

## Available functions

### include

`include(filename[, indent])` will include `filename` at the position of the code block. There will be one additional newline after the file's contents.

If the optional `indent` argument is given, that string is used as the desired indention.

### template

`template(filename[, indent], env)` works almost like `include()`, with the difference that `filename` is itself evaluated as a template and `env` is used as the environment within that template.

Note: `env` is non-optional! If you want to keep the same environment inside `filename` as you have in your own template, you should pass `_ENV` for this argument.

## Example

### Config file (`example.cfg`)

```lua
return {
  _preprocess = function(config, args)
    config.additional = args[1]
    return config
  end,
  example = {
    value = 1,
  },
}
```

### Template (`example.yaml`)

```yaml
example:
  value: @{example.value}
  additional: @{additional}
  file: |
    @{include("example.file", "    ")}
  template: |
    @{template("example.template", "    ", _ENV)}
```

### Include file (`example.file`)

```
Multi
Line
File
```

### Nested template (`example.template`)

```
Template
With
@{additional}
Value
```

### Command line and output

The first line is the command that was run and not part of the output.

```yaml
# ./runtemplate.lua example.cfg example.yaml -- "much more"
example:
  value: 1
  additional: much more
  file: |
    Multi
    Line
    File

  template: |
    Template
    With
    much more
    Value

```

## Advanced example

### Config

```lua
local union = require "tablexx".union

return {
  _preprocess = function(config, args)
    for hostname, host in pairs(config.hosts) do
      host.hostname = hostname
    end
    local hostname = args[1]
    return union(config, config.hosts[hostname])
  end,
  hosts = {
    orange = {
      ip = "10.0.0.1",
    },
    blue = {  
      ip = "10.0.0.2",
    },
  },
}
```

### Template

```yaml
some-service:
  hostfile: @{hostname}.cfg
```

### Command line and output

The first line is the command that was run and not part of the output.

```yaml
# ./runtemplate.lua example.cfg example.yaml -- orange
some-service:
  hostfile: orange.cfg
```
