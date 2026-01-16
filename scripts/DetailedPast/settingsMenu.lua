local I = require('openmw.interfaces')

I.Settings.registerPage {
    key = 'LuckyStrike',
    l10n = 'LuckyStrike',
    name = 'page_name',
    description = 'page_description',
}

I.Settings.registerGroup {
    key = 'LineageAndCulture_settings',
    page = 'LineageAndCulture',
    l10n = 'LineageAndCulture',
    name = 'settings_groupName',
    permanentStorage = true,
    order = 1,
    settings = {
        {
            key = 'showNil',
            name = 'showNil_name',
            renderer = 'checkbox',
            default = false,
        },
    }
}