local merge = require "pl.tablex".merge
local keys = require "pl.tablex".keys
local makeset = require "pl.tablex".makeset

local tablexx = {}

function tablexx.union(t1, t2)
        return merge(t1, t2, true)
end

local union = tablexx.union

function tablexx.intersection(t1, t2)
        return merge(t1, t2, false)
end

function tablexx.iunion(t1, t2)
	return keys(union(makeset(t1), makeset(t2)))
end

return tablexx
