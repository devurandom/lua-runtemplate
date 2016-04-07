local merge = require "pl.tablex".merge

local tablexx = {}

function tablexx.union(t1, t2)
        return merge(t1, t2, true)
end

function tablexx.intersection(t1, t2)
        return merge(t1, t2, false)
end

return tablexx
