local self = require("openmw.self")
local I = require("openmw.interfaces")

require("scripts.DetailedPast.utils.dependencies")

CheckDependency(
    self,
    "Detailed Past",
    "StatsWindow.omwscripts",
    I.StatsWindow,
    1,
    I.StatsWindow and I.StatsWindow.VERSION or -1)
