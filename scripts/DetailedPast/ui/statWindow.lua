local I = require("openmw.interfaces")

local API = I.StatsWindow
local C = API.Constants

function InitDetailLine(detail, detailType)
    API.addLineToSection(detailType, C.DefaultSections.LEVEL_STATS, {
        label = DetailNames[detailType],
        labelColor = C.Colors.DEFAULT_LIGHT,
        value = function()
            return { string = detail.name }
        end,
        tooltip = function()
            return API.TooltipBuilders.HEADER(detail.name, detail.description)
        end
    })
end

function UpdateDetailLine(detail, detailType)
    API.modifyLine(detailType, {
        value = function()
            return { string = detail.name }
        end,
        tooltip = function()
            return API.TooltipBuilders.HEADER(detail.name, detail.description)
        end
    })
end
