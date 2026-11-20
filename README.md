# DarkMode

DarkMode darkens or colors the World of Warcraft user interface: windows, unit frames, action bars, buffs, nameplates, tooltips, the minimap and more. Every area can get its own color mode.

## Features

- Color modes per area: **Dark**, **More Dark**, **Darker**, **More Darker**, **Black**, **Class Color**, **Custom** (own color via color picker), and **Off**.
- A **General Color Mode** that sets the main areas at once; each area can still be changed on its own afterwards.
- Areas:
  - **Interface & HUD**: UI/HUD, micro menu, bags, buttons
  - **Windows**: Blizzard windows, add-on windows, quest background
  - **Unit Frames**: frames, health bar, portrait, reputation status, dragon art, player frame dragon (elite/rare/rare elite)
  - **Action Bars**: action buttons and gryphons
  - **Buffs and Debuffs**, **Nameplates**, **Tooltips**
- Extra borders: Blizzard's minimap buttons, action buttons, and buffs have no separate border, it is part of the icon. DarkMode draws its own border on top so it can be colored, optionally thin or with an inner shadow.
- **Own Target/Focus Auras** (WoW Forever): there the target and focus auras of Blizzard are locked and cannot get a border. DarkMode hides them and shows its own aura icons in the same place, sizes and order like Blizzard's, with the extra border. The cast bar, target of target, and "Buffs on Top" keep working as before.
- **Grayscale**: removes the original colors of textures DarkMode colors, so the chosen color shows cleanly.
- Transparent name background on the target and focus frame.
- Support for other add-ons, among them Auctionator, BetterBlizzFrames, BugSack, ClassicUIForever, DragonflightUI, Leatrix Plus, and TrinketMenu.
- Settings window with sidebar, search, **What's New** window, language selection, and a minimap button.

## Usage

- Open the settings with `/dm`, `/dark`, `/darkmode`, or a left click on the minimap button. A right click on the minimap button hides it.
- The sidebar on the left jumps to an area; the search box filters all options.
- Some changes need a reload: **Save** in the footer reloads the interface once a setting that needs it was changed. `/rl` is a short form of `/reload`.
- New options are marked **[NEW]** for a few days, and the **What's New** window lists them once after login. It can be turned off in the window or under **General**.

## Notes

- With Masque installed, the border options are hidden because Masque styles the buttons.
- **Own Target/Focus Auras** only appears on clients that lock Blizzard's target auras (WoW Forever). Turning it off needs a reload.
- Supported clients: Retail, WoW Forever, Classic Era, The Burning Crusade, Wrath, Cataclysm, and Mists of Pandaria Classic.

## Localization

Locale files exist for all World of Warcraft client locales:

`deDE`, `enUS`, `esES`, `esMX`, `frFR`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN`, and `zhTW`.

The language can be changed in the settings window independently of the client language, without a reload. Translations other than English and German are machine-generated and may benefit from native-speaker review.

## Author

D4KiR
