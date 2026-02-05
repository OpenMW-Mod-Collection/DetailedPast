local self = require("openmw.self")
local I = require("openmw.interfaces")

require("scripts.DetailedPast.utils.dependencies")
require("scripts.DetailedPast.utils.consts")
local details = require("scripts.DetailedPast.logic.expansionParser")

CheckDependency(
    self,
    "Detailed Past",
    "StatsWindow.omwscripts",
    I.StatsWindow,
    1,
    I.StatsWindow and I.StatsWindow.VERSION or -1)

local API = I.StatsWindow
local C = API.Constants

local function pickDetail(detailType, detailId)
    if not (details[detailType] and details[detailType][detailId]) then
        return
    end

    local detail = details[detailType][detailId]

    API.addLineToSection(DetailTypes.culture, C.DefaultSections.LEVEL_STATS, {
        label = DetailNames[detailType],
        labelColor = C.Colors.DEFAULT_LIGHT,
        value = function ()
            return { string = detail.name }
        end,
        tooltip = function ()
            return API.TooltipBuilders.HEADER(detail.name, detail.description)
        end
    })
end

return {
    interfaceName = "DetailedPast",
    interface = {
        pickDetail = pickDetail
    }
}