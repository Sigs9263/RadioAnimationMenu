local selectedRadioAnim = Config.DefaultAnimation or "shoulder"
local soundsEnabled = Config.DefaultSoundsEnabled or true
local isRadioActive = false
local currentAnimDict = nil
local currentAnimName = nil
local currentProp = nil
local isPlayingAnimation = false
local _menuPool = nil
local menu = nil
local loadedAnimDicts = {}

local EnableSounds = Config.EnableSounds
local EnableVehicleOverrides = Config.EnableVehicleOverrides
local VehicleOverrideAnimation = Config.VehicleOverrideAnimation
local Animations = Config.Animations
local VehicleOverrideList = Config.VehicleOverrideList

local propModelHash = nil
local propModelPreloaded = false

--  Helper Functions
local vehicleHashCache = {}
if EnableVehicleOverrides and VehicleOverrideList then
    for _, vehicleName in ipairs(VehicleOverrideList) do
        vehicleHashCache[GetHashKey(vehicleName)] = true
    end
end

function IsVehicleInOverrideList(vehicle)
    if not EnableVehicleOverrides or not vehicle or vehicle == 0 then
        return false
    end
    return vehicleHashCache[GetEntityModel(vehicle)] == true
end

--  Animation Functions (Optimized)
function LoadAnimation(dict)
    if loadedAnimDicts[dict] then return end
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 2000 then return end
    end
    loadedAnimDicts[dict] = true
end

function PlayCustomAnimation(animConfig)
    local ped = PlayerPedId()
    
    LoadAnimation(animConfig.dict)
    StopAnimation()
    
    TaskPlayAnim(
        ped,
        animConfig.dict,
        animConfig.name,
        8.0,
        -8.0,
        -1,
        (animConfig.loop and 49 or 0) | (animConfig.moving and 1 or 0),
        0.0,
        false,
        false,
        false
    )

    currentAnimDict = animConfig.dict
    currentAnimName = animConfig.name
    isPlayingAnimation = true

    -- Attach prop if needed (optimized and improved)
    if animConfig.prop then
        if not propModelHash then
            propModelHash = GetHashKey(animConfig.prop.model)
        end
        local propModel = propModelHash
        
        if propModel == 0 or propModel == nil then
            print("^1[RadioAnimationMenu] ERROR: Invalid prop model hash for: " .. tostring(animConfig.prop.model) .. "^7")
            return
        end
        
        if not HasModelLoaded(propModel) then
            RequestModel(propModel)
            local attempts = 0
            local maxAttempts = 20
            
            while not HasModelLoaded(propModel) and attempts < maxAttempts do
                Wait(50)
                attempts = attempts + 1
                if attempts % 10 == 0 then
                    RequestModel(propModel)
                end
            end
        end

        if HasModelLoaded(propModel) then
            local boneIndex = GetPedBoneIndex(ped, animConfig.prop.bone)
            if boneIndex ~= -1 then
                if currentProp and DoesEntityExist(currentProp) then
                    DeleteObject(currentProp)
                    currentProp = nil
                end
                
                currentProp = CreateObject(propModel, 0.0, 0.0, 0.0, true, true, true)
                SetEntityAsMissionEntity(currentProp, true, true)
                SetEntityCollision(currentProp, false, false)
                SetEntityCompletelyDisableCollision(currentProp, false, false)
                
                if DoesEntityExist(currentProp) then
                    AttachEntityToEntity(
                        currentProp,
                        ped,
                        boneIndex,
                        animConfig.prop.placement[1],
                        animConfig.prop.placement[2],
                        animConfig.prop.placement[3],
                        animConfig.prop.placement[4],
                        animConfig.prop.placement[5],
                        animConfig.prop.placement[6],
                        true,
                        true,
                        false,
                        true,
                        1,
                        true
                    )
                    SetEntityAsMissionEntity(currentProp, true, true)
                else
                    print("^1[RadioAnimationMenu] ERROR: Failed to create prop object^7")
                end
            else
                print("^1[RadioAnimationMenu] ERROR: Invalid bone index: " .. tostring(animConfig.prop.bone) .. "^7")
            end
        else
            print("^3[RadioAnimationMenu] Warning: Prop model failed to load after " .. (maxAttempts * 50) .. "ms. Model: " .. tostring(animConfig.prop.model) .. " (Hash: " .. tostring(propModel) .. ")^7")
        end
    end
end

function StopAnimation()
    local ped = PlayerPedId()
    
    if currentProp then
        if DoesEntityExist(currentProp) then
            DeleteObject(currentProp)
            SetEntityAsMissionEntity(currentProp, false, true)
        end
        currentProp = nil
    end

    if currentAnimDict and currentAnimName then
        StopAnimTask(ped, currentAnimDict, currentAnimName, 1.0)
        ClearPedTasks(ped)
    end

    currentAnimDict = nil
    currentAnimName = nil
    isPlayingAnimation = false
end

--  NativeUI Menu Functions
function CreateMenu()
    if not NativeUI then return end
    
    local menuX = 1430
    local menuY = 50
    if GetAspectRatio() > 2.0 then
        menuX = 1200
        menuY = 30
    end
    
    _menuPool = NativeUI.CreatePool()
    menu = NativeUI.CreateMenu("Radio Animation", "RADIO ANIMATION CONTROLS", menuX, menuY)
    _menuPool:Add(menu)
    
    menu.Settings.MouseControlsEnabled = true
    menu.Settings.ControlDisablingEnabled = false
    
    local animOrder = {"shoulder", "chest", "handheld", "earpiece"}
    
    for _, animKey in ipairs(animOrder) do
        local animConfig = Animations[animKey]
        if animConfig then
            menu:AddItem(NativeUI.CreateItem(animConfig.displayName, "Select this radio animation style"))
        end
    end
    
    local soundsItem = NativeUI.CreateItem("Toggle Radio Clicks", soundsEnabled and "Radio Clicks: ON" or "Radio Clicks: OFF")
    soundsItem:RightLabel(soundsEnabled and "ON" or "OFF")
    menu:AddItem(soundsItem)
    
    menu.OnItemSelect = function(sender, item, index)
        local itemCount = #animOrder
        
        if index <= itemCount then
            selectedRadioAnim = animOrder[index]
            SetResourceKvp("ram_selected_anim", selectedRadioAnim)
            menu:Visible(false)
            return
        end
        
        if index == itemCount + 1 then
            soundsEnabled = not soundsEnabled
            SetResourceKvp("ram_sounds_enabled", tostring(soundsEnabled))
            item:RightLabel(soundsEnabled and "ON" or "OFF")
            item:Description(soundsEnabled and "Radio Clicks: ON" or "Radio Clicks: OFF")
        end
    end
end

--  Core Script Logic (Optimized)
CreateThread(function()
    local handheldAnim = Animations.handheld
    if handheldAnim and handheldAnim.prop then
        propModelHash = GetHashKey(handheldAnim.prop.model)
        if propModelHash and propModelHash ~= 0 then
            RequestModel(propModelHash)
            local timeout = 0
            while not HasModelLoaded(propModelHash) do
                Wait(10)
                timeout = timeout + 10
                if timeout > 5000 then
                    print("^3[RadioAnimationMenu] Warning: Prop model preload timeout^7")
                    break
                end
            end
            if HasModelLoaded(propModelHash) then
                propModelPreloaded = true
            end
        end
    end
    
    if handheldAnim and handheldAnim.dict then
        RequestAnimDict(handheldAnim.dict)
        local timeout = 0
        while not HasAnimDictLoaded(handheldAnim.dict) do
            Wait(10)
            timeout = timeout + 10
            if timeout > 5000 then
                print("^3[RadioAnimationMenu] Warning: Animation dict preload timeout^7")
                break
            end
        end
        if HasAnimDictLoaded(handheldAnim.dict) then
            loadedAnimDicts[handheldAnim.dict] = true
        end
    end
end)

CreateThread(function()
    while true do
        Wait(30000)
        if propModelHash and propModelHash ~= 0 and not HasModelLoaded(propModelHash) then
            RequestModel(propModelHash)
        end
    end
end)

CreateThread(function()
    local attempts = 0
    while not NativeUI and attempts < 50 do
        Wait(100)
        attempts = attempts + 1
    end
    
    if not NativeUI then
        print("^1[RadioAnimationMenu] ERROR: NativeUI failed to load!^7")
        return
    end
    
    Wait(200)
    
    local savedAnim = GetResourceKvpString("ram_selected_anim")
    if savedAnim and savedAnim ~= "" then
        selectedRadioAnim = savedAnim
    end
    
    local savedSounds = GetResourceKvpString("ram_sounds_enabled")
    if savedSounds ~= nil then
        soundsEnabled = savedSounds == "true"
    end
    
    CreateMenu()
end)

CreateThread(function()
    while true do
        if _menuPool and menu and menu:Visible() then
            _menuPool:ProcessMenus()
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            Wait(0)
        else
            Wait(100)
        end
    end
end)

RegisterCommand(Config.MenuCommand, function()
    if not NativeUI then return end
    if not menu then CreateMenu() end
    if menu then
        local isOpening = not menu:Visible()
        menu:Visible(isOpening)
        if isOpening and #menu.Items > 0 then
            menu:CurrentSelection(1)
        end
    end
end, false)
TriggerEvent('chat:addSuggestion', '/' .. Config.MenuCommand, 'Open Radio Animation Menu')

RegisterCommand(Config.SoundsCommand, function(source, args, rawCommand)
    local arg = args[1] and string.lower(args[1]) or nil
    
    if arg == "on" then
        soundsEnabled = true
    elseif arg == "off" then
        soundsEnabled = false
    else
        soundsEnabled = not soundsEnabled
    end
    
    SetResourceKvp("ram_sounds_enabled", tostring(soundsEnabled))
    
    if menu then
        local menuItems = menu.Items
        local soundsItemIndex = #menuItems
        if menuItems[soundsItemIndex] then
            menuItems[soundsItemIndex]:RightLabel(soundsEnabled and "ON" or "OFF")
            menuItems[soundsItemIndex]:Description(soundsEnabled and "Radio Clicks: ON" or "Radio Clicks: OFF")
        end
    end
end, false)
TriggerEvent('chat:addSuggestion', '/' .. Config.SoundsCommand, 'Toggle Radio Clicks', {
    { name = "state", help = "on or off (optional - toggles if not provided)" }
})

-- Radio Animation Commands (Optimized)

RegisterCommand("+radioanim", function()
    if (menu and menu:Visible()) or isRadioActive then return end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local inVehicle = vehicle ~= 0
    
    isRadioActive = true
    
    if EnableSounds and soundsEnabled then
        SendNUIMessage({ type = "playSound", sound = "on" })
    end
    
    local animToUse = selectedRadioAnim
    if EnableVehicleOverrides and inVehicle and IsVehicleInOverrideList(vehicle) then
        animToUse = VehicleOverrideAnimation
    end
    
    if Animations[animToUse] then
        PlayCustomAnimation(Animations[animToUse])
    end
end, false)

RegisterCommand("-radioanim", function()
    if not isRadioActive then return end
    
    isRadioActive = false
    
    if EnableSounds and soundsEnabled then
        SendNUIMessage({ type = "playSound", sound = "off" })
    end
    
    StopAnimation()
end, false)

RegisterKeyMapping("+radioanim", Config.RadioKeybindDescription, "keyboard", Config.RadioKeybind)
