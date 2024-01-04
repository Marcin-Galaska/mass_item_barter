-- Mass Item Barter mod by mroużon. Ver. 1.0.0
-- Thanks to Zombine, Redbeardt and others for their input into the community. Their work helped me a lot in the process of creating this mod.

local mod = get_mod("mass_item_barter")

-- ##################################################
-- Requires
-- ##################################################

local ItemUtils = require("scripts/utilities/items")
local UISettings = require("scripts/settings/ui/ui_settings")
local InventoryWeaponsView = require("scripts/ui/views/inventory_weapons_view/inventory_weapons_view")

-- ##################################################
-- Mod variables
-- ##################################################

local init = function(func, ...)
    mod._max_rating = mod:get("max_rating")                                     -- Mass barter item rating threshold. Only items at this rating or below will be bartered.
    mod._mass_barter_key = mod:get("mass_barter_key")                           -- Keybind.
    mod._barterable_rarities = mod:get("barterable_rarities")                   -- Rarities that can be bartered (grey, green, blue, purple, yellow).

    mod._items_to_discard = {}                                                  -- Items that will be bartered.
    mod._weapon_category = ""                                                   -- Category of items that the player is viewing and that will potentially be bartered.
    mod._mass_barter_action_confirmed = false                                   -- Whether player pressed 'Confirm' on the warning pop-up.
    mod._mass_barter_action_completed = false                                   -- Whether mass bartering was completed.
    mod._barterable_items_present = true                                        -- Whether player has items that fulfill the requirements to be mass barterable in inventory.
    mod._equipped_item_gear_id = 0                                              -- Gear ID of equipped item
    mod._confirm_desc_table = {                                                 -- Item categories.
        WEAPON_MELEE = "loc_popup_desc_melee_mass_barter_confirmation",
        WEAPON_RANGED = "loc_popup_desc_ranged_mass_barter_confirmation",
        GADGET = "loc_popup_desc_curio_mass_barter_confirmation"
    }

    if func then
        func(...)
    end
end

mod.on_all_mods_loaded = function()
    init()
end

-- ##################################################
-- Custom functions
-- ##################################################

local _on_mass_barter_confirmed = function()
    mod._mass_barter_action_confirmed = true
end

local _on_mass_barter_cancelled = function()
    mod._mass_barter_action_confirmed = false
end

local _add_pressed_callback = function(obj)
    function obj:cb_on_mass_barter_pressed()
        local context = {
            title_text = "loc_popup_title_mass_barter_confirmation",
            description_text = mod._confirm_desc_table[mod._weapon_category],
            options = {
                {
                    text = "loc_popup_button_confirm_mass_barter_confirmation",
                    close_on_pressed = true,
                    callback = _on_mass_barter_confirmed
                },
                {
                    text = "loc_popup_button_cancel_mass_barter_confirmation",
                    template_type = "terminal_button_small",
                    close_on_pressed = true,
                    hotkey = "back",
                    callback = _on_mass_barter_cancelled
                }
            }
        }

        Managers.event:trigger("event_show_ui_popup", context)
    end
end

local _add_input_legend = function(legend_inputs)
    local hotkey_mass_barter = mod:get("mass_barter_key")

    if hotkey_mass_barter ~= "Off" then
        legend_inputs[#legend_inputs + 1] = {
            input_action = hotkey_mass_barter,
            display_name = "loc_legend_mass_barter",
            alignment = "right_alignment",
            on_pressed_callback = "cb_on_mass_barter_pressed",
            visibility_function = function (parent)
                local is_previewing_item = parent:is_previewing_item()

                if is_previewing_item then
                    local previewed_item = parent:previewed_item()
                    local item_type = previewed_item.item_type
                    local ITEM_TYPES = UISettings.ITEM_TYPES

                    mod._weapon_category = item_type

                    if item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED or item_type == ITEM_TYPES.GADGET then
                        return true
                    end
                end

                return true
            end
        }
    end
end

local _is_item_barterable_based_on_rarity = function(item)
    local item_rarity = ItemUtils.rarity_display_name(item)

    if mod._barterable_rarities == 1 then
        if item_rarity == "Profane" then
            return true
        end
        return false

    elseif mod._barterable_rarities == 2 then
        if item_rarity == "Profane" or item_rarity == "Redeemed" then
            return true
        end
        return false

    elseif mod._barterable_rarities == 3 then
        if item_rarity == "Profane" or item_rarity == "Redeemed" or item_rarity == "Anointed" then
            return true
        end
        return false

    elseif mod._barterable_rarities == 4 then
        if item_rarity == "Profane" or item_rarity == "Redeemed" or item_rarity == "Anointed" or item_rarity == "Exalted" then
            return true
        end
        return false

    elseif mod._barterable_rarities == 5 then
        return true

    else
        mod:notify("mass_item_barter mod _is_item_barterable_based_on_rarity() function error: cannot identify item rarity.")
        return false
    end
end

local _get_items_to_discard = function(items)
    mod._items_to_discard = {}
    for _, item in ipairs(items) do
        local rating = ItemUtils.item_level(item)       -- String with the rating symbol
        rating = string.sub(rating, 5)                  -- Get rid of the rating symbol
        rating = tonumber(rating)                       -- Cast to number

        if rating <= mod._max_rating and item.gear_id ~= mod._equipped_item_gear_id and _is_item_barterable_based_on_rarity(item) then
            table.insert(mod._items_to_discard, item)
        end
    end
end

-- ##################################################
-- Hooks
-- ##################################################

mod:hook("InventoryWeaponsView", "init", function(func, self, ...)
    init(func, self, ...)
    _add_pressed_callback(self)
end)

mod:hook("InventoryWeaponsView", "_setup_input_legend", function(func, self)
    local legend_inputs = self._definitions.legend_inputs
    _add_input_legend(legend_inputs)
    func(self)
end)

mod:hook_safe("InventoryWeaponsView", "_handle_input", function(self, input_service)
    local items = self._inventory_items

    -- Get undesirable items, except the currently equipped one
    if items and #mod._items_to_discard == 0 and mod._barterable_items_present == true then
        -- When the player opens InventoryWeaponsView, the equipped item is previewed by default
        mod._equipped_item_gear_id = self._previewed_item.gear_id
        _get_items_to_discard(items)

        if #mod._items_to_discard == 0 then
            mod._barterable_items_present = false
        end
    end

    if mod._mass_barter_action_confirmed then
        mod._mass_barter_action_confirmed = false
        if mod._barterable_items_present == false then
            mod:notify("No items meeting the requirements present in this section of the inventory.")

        else
            -- Barter every undesirable item
            for _, item in pairs(mod._items_to_discard) do
                local gear_id = item.gear_id
                Managers.data_service.gear:delete_gear(gear_id):next(function(result)
                    self._inventory_items[gear_id] = nil
                    local rewards = result and result.rewards

                    -- Earn ordo dockets
                    if rewards then
                        local creds = rewards[1] and rewards[1].amount or 0
                        Managers.event:trigger("event_force_wallet_update")
                        Managers.event:trigger("event_add_notification_message", "currency", {
                            currency = "credits",
                            amount = creds
                        })
                    end

                    -- Sync profile
                    if self._profile_presets_element then
                        self._profile_presets_element:sync_profiles_states()
                    end

                    -- Mark bartered item's widget to be removed
                    for widget_index, widget in pairs(self:grid_widgets()) do
                        local widget_item_gear_id = widget.content.element.item.gear_id
                        if widget_item_gear_id == gear_id then
                            -- Discard item
                            self:focus_on_item(self:grid_widgets()[widget_index].content.element.item)
                            InventoryWeaponsView._mark_item_for_discard(self, widget_index)
                            self:update_grid_widgets_visibility()

                            -- If removed widget is above previewed widget, move previewed widget up
                            local previewed_element_index = (widget_index or 1) - 1
                            local previewed_element = widget_index > 0 and self:element_by_index(previewed_element_index)

                            if previewed_element then
                                self:focus_on_item(previewed_element)

                            else
                                self:_stop_previewing()
                            end
                            break
                        end
                    end
                end)
            end
        end
    end
end)

mod:hook_safe("InventoryWeaponsView", "on_exit", function(self)
    mod._items_to_discard = {}
    mod._barterable_items_present = true
end)

mod:hook_safe("InventoryWeaponsView", "_equip_item", function(self, slot_name, item)
    local items = self._inventory_items

    mod._equipped_item_gear_id = item.gear_id
    _get_items_to_discard(items)
end)
