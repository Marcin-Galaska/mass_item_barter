-- Mass Item Barter mod by mroużon. Ver. 1.0.0
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("mass_item_barter")

local _get_keybinds = function()
    local keybind_list = {
        { text = "Off", value = "Off" }
    }

    for _, gamepad_action in ipairs(mod._available_aliases) do
        keybind_list[#keybind_list + 1] = {
            text = gamepad_action,
            value = gamepad_action
        }
    end

    return keybind_list
end

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "max_rating",
                type = "numeric",
                default_value = 359,
                range = {10, 379}
            },
            {
                setting_id = "mass_barter_key",
                type = "dropdown",
                default_value = "toggle_solo_play",
                options = _get_keybinds()
            },
            {
                setting_id = "barterable_rarities",
				type = "dropdown",
				default_value = 4,
				options = {
					{text = "barterable_grey", value = 1, show_widgets = {}},
					{text = "barterable_green", value = 2, show_widgets = {}},
                    {text = "barterable_blue", value = 3, show_widgets = {}},
                    {text = "barterable_purple", value = 4, show_widgets = {}},
                    {text = "barterable_yellow", value = 5, show_widgets = {}}
				}
			}
        }
    }
}
