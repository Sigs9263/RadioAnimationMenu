# Radio Animation Menu (Completely Standalone)

FiveM resource that adds a customizable radio animation menu with four animation styles.

## Showcase & Resmon
https://youtu.be/t2X1iiDhGso

<img width="736" height="22" alt="image" src="https://github.com/user-attachments/assets/4e5b3626-d7a6-4965-be0d-98fede7e6cc0" />

## Features

- **4 Animation Styles**: Shoulder, Chest, Handheld (with walkie-talkie prop), Earpiece
- **Built-in Animations**: Uses native GTA V animation dictionaries
- **Sound Effects**: Optional radio on/off click sounds
- **Vehicle Overrides**: Auto-use handheld animation in emergency vehicles
- **Persistent Settings**: Your preferences save between sessions
- **Low Performance Impact**: Optimized (0.00-0.02 resmon)

## Installation

1. Place the folder in your server's `resources` directory
2. Add to `server.cfg`:
   ```
   ensure RadioAnimationMenu
   ```
3. If using Zerio-Radio, disable its default animations to prevent conflicts

## Usage

- `/radioanim` - Open/close the animation menu
- `/radioclicks [on/off]` - Toggle radio click sounds
- **Keybinding**: Set the radio animation keybind (default: CAPS) to match your radio PTT key

Use the menu to select your preferred animation style. Your choice is saved automatically.

## Configuration

Edit `config.lua` to customize:
- Default animation style
- Keybind settings
- Vehicle override list
- Sound settings

## Animation Styles

1. **Shoulder Radio** - Classic shoulder-mounted radio
2. **Chest Radio** - Police-style chest-mounted radio
3. **Handheld Radio** - Walkie-talkie with prop
4. **Earpiece Radio** - Earpiece/headset style

## Support

For support, DM sigs9263 on Discord.

## Credits

- **Sigs9263** – Development and implementation of the Radio Animation Menu  
- **Alberttheprince** – Animations and props from **rpemotes-reborn** (https://github.com/alberttheprince/rpemotes-reborn)
- **Unknown** – Original radio prop source  (I forgot who I got the radio prop from, but credits to you)
