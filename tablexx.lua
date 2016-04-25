local merge = require "pl.tablex".merge
local pairmap = require "pl.tablex".pairmap

local tablexx = {}

function tablexx.union(t1, t2)
        return merge(t1, t2, true)
end

function tablexx.intersection(t1, t2)
        return merge(t1, t2, false)
end

function tablexx.makelist(t)
	return pairmap(function(k,v) return k end, t)
end

return tablexx
