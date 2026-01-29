import re

def extract_this_blocks(lua_source):
    blocks = []
    pattern = re.compile(r"this\.(\w+)\s*=\s*{")

    for match in pattern.finditer(lua_source):
        name = match.group(1)
        start = match.end()

        depth = 1
        i = start

        while i < len(lua_source) and depth > 0:
            if lua_source[i] == "{":
                depth += 1
            elif lua_source[i] == "}":
                depth -= 1
            i += 1

        body = lua_source[start : i - 1]
        blocks.append((name, body))

    return blocks

def extract_function_blocks(source, function_name):
    blocks = []
    pattern = re.compile(rf"{function_name}\s*{{")

    for match in pattern.finditer(source):
        start = match.end()
        depth = 1
        i = start

        while i < len(source) and depth > 0:
            if source[i] == "{":
                depth += 1
            elif source[i] == "}":
                depth -= 1
            i += 1
        blocks.append(source[start : i - 1])

    return blocks

def extract_one(pattern, block):
    m = re.search(pattern, block, re.DOTALL)
    return m.group(1).strip() if m else None

def extract_all(pattern, block):
    return re.findall(pattern, block, re.DOTALL)