import re
import yaml
import os

import utils

INPUT_LUA = os.path.join(os.path.dirname(__file__), "culturesExpansionList.lua")
OUTPUT_YAML = os.path.join(os.path.dirname(__file__), "output.yaml")

with open(INPUT_LUA, "r", encoding="utf-8") as f:
    lua = f.read()

entries = []

# Match local culture tables like: local cantemiric = { ... }
pattern = re.compile(r"local\s+(\w+)\s*=\s*{")

for match in pattern.finditer(lua):
    name_var = match.group(1)
    start = match.end()

    # Find matching closing brace
    depth = 1
    i = start
    while i < len(lua) and depth > 0:
        if lua[i] == "{":
            depth += 1
        elif lua[i] == "}":
            depth -= 1
        i += 1

    block = lua[start : i - 1]

    # Extract fields
    detail_id = utils.extract_one(r'id\s*=\s*"([^"]+)"', block)
    name = utils.extract_one(r'name\s*=\s*"([^"]+)"', block)
    description = utils.extract_one(r'description\s*=\s*\(\s*"(.+?)"\s*\)', block)

    if not detail_id or not name:
        continue

    if description:
        description = description.replace("\\n", "\n")
        # Remove trailing single-quoted comments if present
        description = re.sub(r"\s*--.*$", "", description, flags=re.MULTILINE)
        parts = description.split("\n\n")
        if len(parts) > 1:
            if parts[-1].startswith("Adherence to"):
                description = "\n\n".join(parts[:-1])

        description = description.replace("\n", "\\n")

    # Extract spell from doOnce function
    spells = []
    doonce_match = re.search(
        r"doOnce\s*=\s*function\s*\(\s*\)(.+?)end", block, re.DOTALL
    )
    if doonce_match:
        doonce_body = doonce_match.group(1)
        spell_match = re.search(r'spell\s*=\s*"([^"]+)"', doonce_body)
        if spell_match:
            spells.append(spell_match.group(1))

    # Extract checkDisabled (whitelisted races)
    disabled_for = utils.extract_all(r'return\s+race\s*~=\s*"([^"]+)"', block)

    entry = {
        "id": detail_id,
        "name": name,
        "description": description,
    }

    if spells:
        entry["abilities"] = spells

    if disabled_for:
        entry["whitelistedRaces"] = disabled_for

    entries.append(entry)

# Write YAML
with open(OUTPUT_YAML, "w", encoding="utf-8") as f:
    yaml.dump(entries, f, sort_keys=False, allow_unicode=True)

print(f"YAML written to {OUTPUT_YAML}")
