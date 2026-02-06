local types = require("openmw.types")
local core = require("openmw.core")

local StatToAlter = require("scripts.DetailedPast.model.statToAlter")
require("scripts.DetailedPast.utils.table")

---@class Detail
---@field id string
---@field name string
---@field description string
---@field abilities table<string>|nil
---@field statsToAlter table<StatToAlter>|nil
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
    if detail.abilities then
        for _, ability in ipairs(detail.abilities) do
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
    local obj = setmetatable({}, Detail)

    obj.id               = tostring(yamlData.id)
    obj.name             = yamlData.name
    obj.description      = yamlData.description
    obj.abilities        = yamlData.abilities
    obj.whitelistedRaces = nil
    obj.statsToAlter     = nil

    if yamlData.statsToAlter then
        obj.statsToAlter = {}
        for i, data in ipairs(yamlData.statsToAlter) do
            obj.statsToAlter[i] = StatToAlter:new(data)
        end
    end

    if yamlData.whitelistedRaces then
        obj.whitelistedRaces = {}
        for i, race in ipairs(yamlData.whitelistedRaces) do
            obj.whitelistedRaces[i] = raceMap[string.lower(race)] or string.lower(race)
        end
    end

    validate(obj)

    return obj
end

function Detail:__tostring()
    return "{" ..
        "\n  id: " .. self.id ..
        "\n  name: " .. self.name ..
        "\n  description: " .. self.description ..
        "\n  abilities: " .. (self.abilities and TableToString(self.abilities, 2) or "nil") ..
        "\n  statsToAlter: " .. (self.statsToAlter and tostring(self.statsToAlter) or "nil") ..
        "\n  whitelistedRaces: " .. (self.whitelistedRaces and TableToString(self.whitelistedRaces, 2) or "nil") ..
        "\n}"
end

function Detail:raceIsWhitelisted(player)
    if not self.whitelistedRaces then return true end

    for _, race in ipairs(self.whitelistedRaces) do
        local playerRecord = player.type.records[player.recordId]
        if player.type.races.records[playerRecord.race].id == race then
            return true
        end
    end

    return false
end

-- TODO
local function getChargenAttribute(player, sal)
    local playerRecord = player.type.records[player.recordId]
    
    local raceRecord = player.type.races.records[playerRecord.race]
    local racialAttr = 0
    if type(raceRecord[sal.type][sal.stat]) == "number" then
        racialAttr = raceRecord[sal.type][sal.stat]
    else
        local gender = playerRecord.isMale and "male" or "female"
        racialAttr = raceRecord[sal.type][sal.stat][gender]
    end
    
    local classAttr = 0
    
    return racialAttr + classAttr
end

-- TODO 
local function getChargenSkill(player, sal)
    
end

function Detail:removeBonuses(player)
    -- remove abilities
    if self.abilities then
        for _, ability in ipairs(self.abilities) do
            player.type.spells(player):remove(ability)
        end
    end
    -- discard changes to stats
    if self.statsToAlter then
        local stats = player.type.stats
        for _, sal in ipairs(self.statsToAlter) do
            local stat = stats[sal.type][sal.stat](player)
            -- edge case when the stat is supposed to be 0
            if sal.value == -100 then
                local chargenStat = sal.type == "skills"
                    and getChargenSkill(player, sal)
                    or getChargenAttribute(player, sal)
                stat.base = stat.base + chargenStat
            else
                stat.base = stat.base - sal.value
            end
        end
    end
end

function Detail:addBonuses(player)
    -- add abilities
    if self.abilities then
        for _, ability in ipairs(self.abilities) do
            player.type.spells(player):add(ability)
        end
    end
    -- apply changes to stats
    if self.statsToAlter then
        local stats = player.type.stats
        for _, sal in ipairs(self.statsToAlter) do
            local stat = stats[sal.type][sal.stat](player)
            stat.base = math.max(stat.base + sal.value, 0)
        end
    end
end

return Detail
