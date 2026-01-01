# Radio Animation Menu

FiveM resource that adds a customizable radio animation menu with four animation styles.

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
3. If using any radio script, make sure to disable its default animations to prevent conflicts

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

