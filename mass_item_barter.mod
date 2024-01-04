return {
    run = function()
        fassert(rawget(_G, "new_mod"), "`mass_item_barter` encountered an error loading the Darktide Mod Framework.")

        new_mod("mass_item_barter", {
            mod_script       = "mass_item_barter/scripts/mods/mass_item_barter/mass_item_barter",
            mod_data         = "mass_item_barter/scripts/mods/mass_item_barter/mass_item_barter_data",
            mod_localization = "mass_item_barter/scripts/mods/mass_item_barter/mass_item_barter_localization",
        })
    end,
    packages = {},
}
