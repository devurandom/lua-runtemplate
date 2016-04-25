local merge = require "pl.tablex".merge
local pairmap = require "pl.tablex".pairmap
local makeset = require "pl.tablex".makeset

local tablexx = {}

function tablexx.union(t1, t2)
        return merge(t1, t2, true)
end

local union = tablexx.union

function tablexx.intersection(t1, t2)
        return merge(t1, t2, false)
end

function tablexx.makelist(t)
	return pairmap(function(k,v) return k end, t)
end

local makelist = tablexx.makelist

function tablexx.iunion(t1, t2)
	return makelist(union(makeset(t1), makeset(t2)))
end

return tablexx
