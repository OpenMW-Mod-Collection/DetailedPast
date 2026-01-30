local vfs = require("openmw.vfs")
local markup = require('openmw.markup')

local Detail = require("scripts.LineageAndCulture.model.detail")

local details = {
    lineages = {
        none = Detail:new({
            id = "none",
            name = "-None-",
            description = "No lineage."
        })
    },
    cultures = {
        none = Detail:new({
            id = "none",
            name = "-None-",
            description = "No culture."
        })
    },
    deities  = {
        none = Detail:new({
            id = "none",
            name = "-None-",
            description = "No worshipped deity."
        })
    },
}

local function parseExpansions()
    for fileName in vfs.pathsWithPrefix("DP_Expansions") do
        local file = vfs.open(fileName)

        assert(file, "Can't open the " .. fileName .. " file.")

        local expansion = markup.decodeYaml(file:read("*all"))
        file:close()

        for detailType, expansionDetails in pairs(expansion) do
            assert(details[detailType],
                "Unkown detail type.\n"..
                "Detail type: " .. detailType .. "\n" ..
                "File name: " .. fileName)
            for _, detailData in ipairs(expansionDetails) do
                table.insert(details[detailType], Detail:new(detailData))
            end
        end
    end
end

parseExpansions()
return details
