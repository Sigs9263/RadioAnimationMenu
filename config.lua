Config = {}


-- Command to open the menu
Config.MenuCommand = "radioanim"

-- Command to toggle radio clicks
Config.SoundsCommand = "radioclicks" -- Command to toggle radio clicks ("/radioclicks on" / "/radioclicks off")

-- Keybind for radio animation
Config.RadioKeybind = "CAPITAL" -- Keybind for radio animation (CAPITAL = Caps Lock)
Config.RadioKeybindDescription = "Play Radio Animation" -- Description shown in keybind settings

-- Default animation when script starts
Config.DefaultAnimation = "shoulder" -- Options: "shoulder", "chest", "handheld", "earpiece"

-- Animation configurations - (DON'T TOUCH IF YOU DON'T KNOW WHAT YOU'RE DOING)
Config.Animations = {
    shoulder = {
        dict = "random@arrests",
        name = "generic_radio_chatter",
        loop = true,
        moving = true,
        displayName = "Use Shoulder Radio"
    },
    chest = {
        dict = "anim@cop_mic_pose_002",
        name = "chest_mic",
        loop = true,
        moving = true,
        displayName = "Use Chest Radio"
    },
    handheld = {
        dict = "anim@male@holding_radio",
        name = "holding_radio_clip",
        loop = true,
        moving = true,
        prop = {
            model = "prop_cs_walkie_talkie",
            bone = 28422,
            placement = { 0.0750, 0.0230, -0.0230, -90.0000, 0.0, -59.9999 }
        },
        displayName = "Use Handheld Radio"
    },
    earpiece = {
        dict = "cellphone@",
        name = "cellphone_call_listen_base",
        loop = true,
        moving = true,
        displayName = "Use Earpiece Radio"
    }
}

-- Enable vehicle-specific animation overrides
Config.EnableVehicleOverrides = true -- Enables Hand Held Radio if inside a emergency vehicle.

-- Vehicle spawn codes that will force handheld animation when using radio
-- Add vehicle spawn codes here ("police", "police2", "sheriff", etc.)
Config.VehicleOverrideList = {
     "police", -- Replace with your emergency vehicle spawncode
     "police2",
     "sheriff",
}

-- Animation to use when in override vehicles
Config.VehicleOverrideAnimation = "handheld"  -- Animation to force in override vehicles

-- Enable/disable radio sounds
Config.EnableSounds = true -- Enable radio on/off sounds
Config.DefaultSoundsEnabled = true -- Default state for sounds (can be toggled in menu)

-- Sound file paths (html folder)
Config.SoundFiles = {
    on = "RadioOn.ogg",
    off = "RadioOff.ogg"
}

-- Menu position
Config.MenuPosition = {
    top = "20px",
    right = "20px"
}

-- Menu styling
Config.MenuStyle = {
    headerBackground = "linear-gradient(135deg, #2c3e50 0%, #1a252f 100%)",
    menuBackground = "linear-gradient(135deg, #1a1d29 0%, #0f1117 100%)",
    itemHoverColor = "rgba(255, 255, 255, 0.1)",
    textColor = "#e0e0e0",
    selectedTextColor = "#ffffff"
}

