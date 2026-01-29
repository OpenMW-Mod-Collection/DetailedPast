import re
import yaml
import os

import utils

INPUT_LUA = os.path.join(os.path.dirname(__file__), "beliefsList.lua")
OUTPUT_YAML = os.path.join(os.path.dirname(__file__), "output.yaml")

with open(INPUT_LUA, "r", encoding="utf-8") as f:
    lua = f.read()

entries = []

# Match tables like: this.dragon = { ... }
blocks = utils.extract_this_blocks(lua)

ignored_sentences = [
    "Admixture of",
    "Your pure",
    "Adherence to",
]

ignored_detail_ids = "sheogorath"

for block_name, block in blocks:

    detail_id = utils.extract_one(r'id\s*=\s*"([^"]+)"', block)
    name = utils.extract_one(r'name\s*=\s*"([^"]+)"', block)

    if detail_id in ignored_detail_ids:
        print(f"Skipping {detail_id = }!!!")
        continue

    description = utils.extract_one(r'description\s*=\s*\(\s*"(.+?)"\s*\)', block)

    if description:
        description = description.replace("\\n", "\n")
        parts = description.split("\n\n")
        if len(parts) > 1:
            description = "\n\n".join(parts[:-1])
        for sentence_beginning in ignored_sentences:
            # -2 for Lineage
            # -1 for Culture
            idx = -1
            if parts[idx].startswith(sentence_beginning):
                description = "\n\n".join(parts[:idx])
                break
        description = description.replace("\n", "\\n")

    # --- Multiple spells (order-independent) ---
    spell_blocks = utils.extract_function_blocks(block, "mwscript.addSpell")

    spells = []
    for sb in spell_blocks:
        m = re.search(r'spell\s*=\s*"([^"]+)"', sb)
        if m:
            spells.append(m.group(1))

    # --- Multiple stat changes ---
    stats = utils.extract_all(
        r"tes3\.modStatistic\s*\(\s*{.*?"
        r"(attribute|skill)\s*=\s*tes3\.(?:attribute|skill)\.(\w+).*?"
        r"value\s*=\s*([-]?\d+)",
        block,
    )

    # --- Disabled for races ---
    disabled_for = utils.extract_all(
        r"checkDisabled\s*=\s*function\s*\(.*?\)" r'.*?return\s+race\s*~=\s*"([^"]+)"',
        block,
    )

    entry = {
        "id": detail_id,
        "name": name,
        "description": description,
    }

    if spells:
        entry["abilities"] = spells

    if stats:
        entry["statsToAlter"] = [
            {
                "type": stat_type,
                "stat": stat_name,
                "value": int(value),
            }
            for stat_type, stat_name, value in stats
        ]

    if disabled_for:
        entry["whitelistedRaces"] = disabled_for

    entries.append(entry)

# Write YAML
with open(OUTPUT_YAML, "w", encoding="utf-8") as f:
    yaml.dump(entries, f, sort_keys=False, allow_unicode=True)

print(f"YAML written to {OUTPUT_YAML}")
