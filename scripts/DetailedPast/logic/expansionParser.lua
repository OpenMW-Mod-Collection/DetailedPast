local vfs = require("openmw.vfs")
local markup = require('openmw.markup')

local CharStat = require("scripts.LineageAndCulture.model.charStat")

local lineages = {}
local cultures = {}

local statTypeToTable = {
    lineages = lineages,
    cultures = cultures
}

local function parseExpansions()
    for fileName in vfs.pathsWithPrefix("DP_Expansions") do
        local file = vfs.open(fileName)

        if not file then
            error("Can't open the " .. fileName .. " file.")
        end

        local expansion = markup.decodeYaml(file:read("*all"))
        file:close()

        for statType, stats in pairs(expansion) do
            for _, statData in ipairs(stats) do
                local charStat = CharStat:new(statData)

                if statTypeToTable[statType] then
                    table.insert(statTypeToTable[statType], charStat)
                else
                    error("Unknown stat type '" .. tostring(statType) .. "' in file: " .. fileName)
                end
            end
        end

    end
end
