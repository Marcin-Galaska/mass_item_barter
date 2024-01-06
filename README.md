# mass_item_barter
A Warhammer 40K: Darktide mod that lets the player barter weapons and curios en masse.

### Darktide Mod Framework
This mod utilizes DMF, a monkey patching framework for Darktide's Autodesk Stringray engine, and is structured accordingly - a *.mod* file and 3 *.lua* files:
- mass_item_barter.lua - main logic of the modification.

- mass_item_barter_data.lua - in-game configurable variables used in the logic.

- mass_item_barter_localization.lua - localization strings used in UI.

**Make sure you are familiar with the [DMF mod installation procedure](https://dmf-docs.darkti.de/#/installing-mods) before attempting to install or modify this repository.**

### Concept
This mod allows you to barter (sell) all low-rating weapons and curios in your inventory with a press of a button. Set your preferences in the mod settings, open your inventory and sell unwanted equipment for its money's worth.

### Usage
Upon installing this mod, you are ready to go. This mod lets you sell items, accordingly to the preferences you set inside DMF's mod settings:

![Zrzut ekranu 2024-01-05 000016](https://github.com/Marcin-Galaska/mass_item_barter/assets/106023363/eba0d824-1011-4c73-a03c-1e143b42d199)

You do so with a simple keybind available inside the inventory:

![Zrzut ekranu 2024-01-05 000017](https://github.com/Marcin-Galaska/mass_item_barter/assets/106023363/87578322-f176-47f2-8aa8-0b0341d2acc7)

![Zrzut ekranu 2024-01-05 000501](https://github.com/Marcin-Galaska/mass_item_barter/assets/106023363/03940137-a6c9-407b-b62a-7100d8d67618)

This option is available when previewing melee weapons, ranged weapons and curios. If no unsatisfactory items were found, you will be notified:

![Zrzut ekranu 2024-01-05 000742](https://github.com/Marcin-Galaska/mass_item_barter/assets/106023363/42ca8060-207f-45a8-8d88-8523bf78f402)

## Thanks to Zombine, Redbeardt and others for their input into the Darktide modding community. Their work helped me a lot in the process of creating this mod. The Emperor protects.

### License
BSD 2-Clause License

Copyright (c) 2023, Marcin Gałąska <br>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
