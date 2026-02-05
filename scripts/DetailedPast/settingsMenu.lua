local I = require('openmw.interfaces')

I.Settings.registerPage {
    key = 'DetailedPast',
    l10n = 'DetailedPast',
    name = 'page_name',
    description = 'page_description',
}

I.Settings.registerGroup {
    key = 'SettingsDetailedPast_settings',
    page = 'DetailedPast',
    l10n = 'DetailedPast',
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