local self = require("openmw.self")
local I = require("openmw.interfaces")

require("scripts.DetailedPast.utils.dependencies")
require("scripts.DetailedPast.utils.consts")
require("scripts.DetailedPast.ui.statWindow")
local allDetails = require("scripts.DetailedPast.logic.expansionParser")

CheckDependency(
    self,
    "Detailed Past",
    "StatsWindow.omwscripts",
    I.StatsWindow,
    1,
    I.StatsWindow and I.StatsWindow.VERSION or -1
)

local currDetails = {
    culture = allDetails["culture"].none,
    lineage = allDetails["lineage"].none,
    deity = allDetails["deity"].none
}
for detailType, detail in pairs(currDetails) do
    InitDetailLine(detail, detailType)
end

local function onSave()
    return currDetails
end

local function onLoad(saveData)
    currDetails = saveData
end

local function setDetail(detailType, detailId)
    if not (allDetails[detailType] and allDetails[detailType][detailId]) then
        return
    end

    local newDetail = allDetails[detailType][detailId]
    if newDetail == currDetails[detailType]
        or not newDetail:raceIsWhitelisted(self)
    then
        return
    end

    currDetails[detailType]:removeBonuses(self)
    currDetails[detailType] = newDetail
    currDetails[detailType]:addBonuses(self)
    UpdateDetailLine(currDetails[detailType], detailType)
end

-- setDetail("deity", "allmaker")
-- setDetail("deity", "akatosh")

return {
    engineHandlers = {
        onSave = onSave,
        onLoad = onLoad,
    },
    interfaceName = "DetailedPast",
    interface = {
        setDetail = setDetail,
    },
}
