-- Mass Item Barter mod by mroużon. Ver. 1.0.0
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("mass_item_barter")
local InputUtils = require("scripts/managers/input/input_utils")

-- ##################################################
-- Weapon Inventory Interface
-- ##################################################
mod:add_global_localize_strings({
    loc_legend_mass_barter = {
        en = "Mass Barter Items"
    },
    loc_popup_title_mass_barter_confirmation = {
        en = "Mass Item Barter"
    },
    loc_popup_desc_ranged_mass_barter_confirmation = {
        en = "Are you sure you want to barter all unsatisfactory ranged weapons?"
    },
    loc_popup_desc_melee_mass_barter_confirmation = {
        en = "Are you sure you want to barter all unsatisfactory melee weapons?"
    },
    loc_popup_desc_curio_mass_barter_confirmation = {
        en = "Are you sure you want to barter all unsatisfactory curios?"
    },
    loc_popup_button_cancel_mass_barter_confirmation = {
        en = "Cancel"
    },
    loc_popup_button_confirm_mass_barter_confirmation = {
        en = "Confirm"
    }
})

-- ##################################################
-- Settings
-- ##################################################
local localization = {
    mod_name = {
        en = "Mass Item Barter"
    },
    mod_description = {
        en = "Barter all weapons and curios in your inventory below given score and rarity.\n\nAuthor: mroużon"
    },
    max_rating = {
        en = "Max Weapon Rating"
    },
    mass_barter_key = {
        en = "Mass Barter Key"
    },
    barterable_rarities = {
        en = "Barterable Rarities"
    },
    barterable_grey = {
        en = "Profane Only"
    },
    barterable_green = {
        en = "Redeemed And Below"
    },
    barterable_blue = {
        en = "Anointed And Below"
    },
    barterable_purple = {
        en = "Exalted And Below"
    },
    barterable_yellow = {
        en = "All"
    },
}

mod._available_aliases = {
    "hotkey_menu_special_1",      -- e
    "hotkey_inventory",           -- i
    "hotkey_loadout",             -- l
    "toggle_private_match",       -- p
    "hotkey_menu_special_2",      -- q
    "toggle_solo_play",           -- s
    "toggle_filter",              -- t
    "hotkey_start_game",          -- enter
    "next_hint",                  -- space
    "cycle_list_secondary",       -- tab
    "notification_option_a",      -- f9
    "notification_option_b",      -- f10      
    "talent_unequip",             -- mouse_right
}

for _, gamepad_action in ipairs(mod._available_aliases) do
    local service_type = "View"
    local alias_key = Managers.ui:get_input_alias_key(gamepad_action, service_type)
    local input_text = InputUtils.input_text_for_current_input_device(service_type, alias_key)

    localization[gamepad_action] = {
        en = input_text
    }
end

return localization