Add Sheogorath deity

```lua
--SHEOGORATH
this.sheogorath = {
    id = "sheogorath",
    name = "Sheogorath",
    -- this one can't be done as abilities
    description = (
        "The Mad God - is the Daedric Prince of Madness, Fourth Corner of the House of Troubles, the Skooma Cat, Lord of the Never-There, and Sovereign of the Shivering Isles. His realm has also been called the Madhouse. It's believed that those who go there lose their sanity forever. Of course, only the Mad God himself may decide who has the privilege to enter. The Golden Saints, or Aureals, and Dark Seducers, or Mazken, are his servants. The Mad God typically manifests on Nirn as a seemingly harmless, well-dressed man often carrying a cane, a guise so prevalent it has actually been coined 'Gentleman With a Cane'. 'Fearful obeisance' of Sheogorath is widespread in Tamriel, and he plays an important part in Dunmeri religious practice. \n\nBonus to Maximum Magicka (+20%) and random Attributes is bestowed upon followers of Sheogorath, but they suffer from Madness and penalty to random Attributes."
    ),
    doOnce = function()
		local madC = math.random(-5, 5)
		local madM = math.random(-5, 5)
		local madT = math.random(-5, 5)
		local madB = math.random(-5, 5)
        tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.strength,
            value = (madC - madB)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.endurance,
            value = (-madC - madC)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.intelligence,
            value = (madM + madM)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.willpower,
            value = (-madM + madB)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.agility,
            value = (madT + madC)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.speed,
            value = (-madT - madT)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.personality,
            value = (madB + madT)
        })
		tes3.modStatistic({
            reference = tes3.player,
            attribute = tes3.attribute.luck,
            value = (-madB - madM)
        })
		mwscript.addSpell{
            reference = tes3.player,
            spell = "MTR_ByTheDivines_Sheogorath"
        }
    end,
}
```
