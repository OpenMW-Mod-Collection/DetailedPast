function TableToString(value, indent, seen)
    indent = indent or 0
    seen = seen or {}

    local t = type(value)

    if t ~= "table" then
        if t == "string" then
            return string.format("%q", value)
        else
            return tostring(value)
        end
    end

    if seen[value] then
        return "<cycle>"
    end
    seen[value] = true

    local pad = string.rep("  ", indent)
    local padInner = string.rep("  ", indent + 1)

    local parts = { "{\n" }

    for k, v in pairs(value) do
        local key
        if type(k) == "string" then
            key = k
        else
            key = "[" .. tostring(k) .. "]"
        end

        table.insert(parts,
            padInner .. key .. " = " ..
            TableToString(v, indent + 2, seen) .. ",\n"
        )
    end

    table.insert(parts, pad .. "}")
    return table.concat(parts)
end
