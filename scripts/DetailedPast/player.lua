local self = require("openmw.self")
local I = require("openmw.interfaces")

require("scripts.TargetTheLeader.utils.dependencies")

CheckDependencies(self, {
    ["FollowerDetectionUtil.omwscripts"] = I.FollowerDetectionUtil == nil
})
