local types = require("openmw.types")

---@class StatToAlter
---@field type string
---@field stat string
---@field value number
local StatToAlter = {}
StatToAlter.__index = StatToAlter

local typeMap = {
    attribute = "attributes",
    skill = "skills"
}

local errorTemplate = "Couldn't validate the StatToAlter.\n" ..
    "%s\n" ..
    "\n" ..
    "StatsToAlter:\n" ..
    "%s"

---@param obj StatToAlter
local function validate(obj)
    local objString = tostring(obj)
    -- required fields
    assert(obj.type,
        string.format(errorTemplate,
            "StatsToAlter.type is required.",
            objString
        )
    )
    assert(obj.stat,
        string.format(errorTemplate,
            "StatsToAlter.stat is required.",
            objString
        )
    )
    assert(obj.value,
        string.format(errorTemplate,
            "StatsToAlter.value is required.",
            objString
        )
    )

    -- data validation
    assert(types.Player.stats[obj.type],
        string.format(errorTemplate,
            "StatsToAlter.type is not a valid stat type value. " ..
            "It has to be either 'attribute' or 'skill'.",
            objString
        )
    )
    assert(types.Player.stats[obj.type][obj.stat],
        string.format(errorTemplate,
            "StatsToAlter.stat is not a valid stat value.",
            objString
        )
    )
    assert(obj.value ~= 0,
        string.format(errorTemplate,
            "StatsToAlter.value cannot be 0.",
            objString
        )
    )
end

function StatToAlter:new(yamlStatsData)
    local obj = setmetatable({}, StatToAlter)
    obj.type  = typeMap[string.lower(yamlStatsData.type)]
    obj.stat  = string.lower(yamlStatsData.stat)
    obj.value = yamlStatsData.value

    validate(obj)

    return obj
end

function StatToAlter:__tostring()
    return "  {" ..
        "\n    type: " .. self.type ..
        "\n    stat: " .. self.stat ..
        "\n    value: " .. tostring(self.value) ..
    "  \n}"
end

return StatToAlter
