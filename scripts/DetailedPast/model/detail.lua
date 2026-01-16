---@class CharStat
---@field id string
---@field name string
---@field description string
---@field ability string
local Detail = {}
Detail.__index = Detail

function Detail:new(yamlData)
    local obj = setmetatable({}, Detail)
    obj.id = yamlData.id
    obj.name = yamlData.name
    obj.description = yamlData.description
    obj.ability = yamlData.ability

    if not obj.id or not obj.name or not obj.description or not obj.ability then
        error("Invalid Detail data: missing required fields.\n" ..
            "Present fields:\n" ..
            "id: " .. tostring(obj.id) .. "\n" ..
            "name: " .. tostring(obj.name) .. "\n" ..
            "description: " .. tostring(obj.description) .. "\n" ..
            "ability: " .. tostring(obj.ability))
    end

    return obj
end
