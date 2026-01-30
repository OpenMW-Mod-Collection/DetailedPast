local types = require("openmw.types")
local core = require("openmw.core")

local StatsToAlter = require("scripts.DetailedPast.model.statsToAlter")
require("scripts.DetailedPast.utils.table")

---@class Detail
---@field id string
---@field name string
---@field description string
---@field abilies table<string>|nil
---@field statsToAlter StatsToAlter|nil
---@field whitelistedRaces table<string>|nil
local Detail = {}
Detail.__index = Detail

local raceMap = {
    dunmer = "dark elf",
    altmer = "high elf",
    bosmer = "wood elf",
}

local errorTemplate = "Couldn't validate the Detail.\n" ..
    "%s\n" ..
    "\n" ..
    "Detail:\n" ..
    "%s"

---@param detail Detail
local function validate(detail)
    local detailString = tostring(detail)
    -- required fields
    assert(detail.id,
        string.format(errorTemplate,
            "Detail.id is required.",
            detailString
        )
    )
    assert(detail.name,
        string.format(errorTemplate,
            "Detail.name is required.",
            detailString
        )
    )
    assert(detail.description,
        string.format(errorTemplate,
            "Detail.description is required.",
            detailString
        )
    )

    -- ability spell validation
    if detail.abilies then
        for _, ability in ipairs(detail.abilies) do
            assert(core.magic.spells.records[ability],
                string.format(errorTemplate,
                    "Unknown ability: " .. ability,
                    detailString
                )
            )
        end
    end

    -- race validation
    if detail.whitelistedRaces then
        for _, race in ipairs(detail.whitelistedRaces) do
            assert(types.NPC.races.records[race],
                string.format(errorTemplate,
                    "Unknown race: " .. race,
                    detailString
                )
            )
        end
    end
end

function Detail:new(yamlData)
    local obj            = setmetatable({}, Detail)
    obj.id               = tostring(yamlData.id)
    obj.name             = yamlData.name
    obj.description      = yamlData.description
    obj.abilies          = yamlData.abilities
    obj.statsToAlter     = yamlData.statsToAlter
        and StatsToAlter:new(yamlData.statsToAlter) or nil
    obj.whitelistedRaces = yamlData.whitelistedRaces

    if obj.whitelistedRaces then
        for i, race in ipairs(obj.whitelistedRaces) do
            obj.whitelistedRaces[i] = raceMap[string.lower(race)] or string.lower(race)
        end
    end

    validate(obj)

    return obj
end

function Detail:__tostring()
    return "{" ..
    "\n  id:               " .. self.id ..
    "\n  name:             " .. self.name ..
    "\n  description:      " .. self.description ..
    "\n  abilies:          " .. self.abilies and TableToString(self.abilies, 2) or "nil" ..
    "\n  statsToAlter:     " .. self.statsToAlter and tostring(self.statsToAlter) or "nil"..
    "\n  whitelistedRaces: " .. self.whitelistedRaces and TableToString(self.whitelistedRaces, 2) or "nil" ..
    "\n}"
end