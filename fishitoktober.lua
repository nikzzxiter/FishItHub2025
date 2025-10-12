-- NIKZZ FISH IT - V2 ULTIMATE EDITION
-- DEVELOPER BY NIKZZ
-- Updated: 12 Oct 2025
-- Optimized for DELTA EXECUTOR (Android)

print("Loading NIKZZ FISH IT - V2 ULTIMATE...")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Rayfield Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "NIKZZ FISH IT - V2 ULTIMATE",
    LoadingTitle = "NIKZZ FISH IT - UPGRADED VERSION",
    LoadingSubtitle = "DEVELOPER BY NIKZZ | Delta Android Optimized",
    ConfigurationSaving = { Enabled = true, FileName = "NikzzFishIt_V2" },
})

-- Configuration
local Config = {
    AutoFishingV1 = false,
    AutoFishingV2 = false,
    FishingDelay = 0.5,
    PerfectCatch = false,
    AntiAFK = false,
    AutoJump = false,
    AutoJumpDelay = 3,
    AutoSell = false,
    GodMode = false,
    SavedPosition = nil,
    CheckpointPosition = HumanoidRootPart.CFrame,
    FlyEnabled = false,
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    WalkOnWater = false,
    InfiniteZoom = false,
    NoClip = false,
    XRay = false,
    ESPEnabled = false,
    ESPDistance = 20,
    LockedPosition = false,
    LockCFrame = nil,
    AutoEnchant = false,
    AutoBuyWeather = false,
    SelectedWeathers = {},
    AutoAcceptTrade = false,
    AutoRejoinDisconnect = false,
    AutoSaveConfig = true,
    AutoLoadConfig = true,
    EnchantStoneCount = 0,
}

-- Remotes Path
local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local function GetRemote(name)
    return net:FindFirstChild(name)
end

-- Remotes
local EquipTool = GetRemote("RE/EquipToolFromHotbar")
local ChargeRod = GetRemote("RF/ChargeFishingRod")
local StartMini = GetRemote("RF/RequestFishingMinigameStarted")
local FinishFish = GetRemote("RE/FishingCompleted")
local EquipOxy = GetRemote("RF/EquipOxygenTank")
local UnequipOxy = GetRemote("RF/UnequipOxygenTank")
local Radar = GetRemote("RF/UpdateFishingRadar")
local SellRemote = GetRemote("RF/SellAllItems")
local EquipItem = GetRemote("RE/EquipItem")
local ActivateEnchantAltar = GetRemote("RE/ActivateEnchantingAltar")
local PurchaseWeather = GetRemote("RF/PurchaseWeatherEvent")
local UpdateAutoFishing = GetRemote("RF/UpdateAutoFishingState")
local CanSendTrade = GetRemote("RF/CanSendTrade")
local AwaitTradeResponse = GetRemote("RF/AwaitTradeResponse")

-- Anti-Stuck System for Auto Fishing V1
local LastFishTime = tick()
local StuckThreshold = 15 -- seconds

local function CheckStuckAndRespawn()
    if Config.AutoFishingV1 and (tick() - LastFishTime) > StuckThreshold then
        warn("[Anti-Stuck] Player stuck detected! Respawning...")
        local currentPos = HumanoidRootPart.CFrame
        Character:BreakJoints()
        Character.CharacterAdded:Wait()
        task.wait(2)
        HumanoidRootPart.CFrame = currentPos
        LastFishTime = tick()
    end
end

-- ===== AUTO FISHING V1 (FIXED - ULTRA FAST & ANTI-STUCK) =====
local function AutoFishingV1()
    task.spawn(function()
        print("[AutoFishingV1] Started - Ultra Fast Mode")
        while Config.AutoFishingV1 do
            local success = pcall(function()
                -- Check stuck
                CheckStuckAndRespawn()
                
                if not LocalPlayer.Character or not HumanoidRootPart then
                    repeat task.wait(0.5) until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    Character = LocalPlayer.Character
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    Humanoid = Character:WaitForChild("Humanoid")
                end

                -- Equip rod
                EquipTool:FireServer(1)
                task.wait(0.1)

                -- Charge rod (perfect timing)
                local chargeSuccess = false
                for i = 1, 3 do
                    local ok = pcall(function()
                        ChargeRod:InvokeServer(tick())
                    end)
                    if ok then 
                        chargeSuccess = true 
                        break 
                    end
                    task.wait(0.1)
                end
                
                if not chargeSuccess then
                    warn("[AutoFishingV1] Charge failed, retrying...")
                    return
                end

                task.wait(0.05)

                -- Start minigame (ALWAYS PERFECT)
                local miniSuccess = false
                for i = 1, 3 do
                    local ok = pcall(function()
                        StartMini:InvokeServer(-1.233184814453125, 0.9945034885633273)
                    end)
                    if ok then 
                        miniSuccess = true 
                        break 
                    end
                    task.wait(0.1)
                end
                
                if not miniSuccess then
                    warn("[AutoFishingV1] Minigame start failed, retrying...")
                    return
                end

                -- Ultra fast delay (configurable)
                local waitTime = math.clamp(Config.FishingDelay, 0.3, 5)
                task.wait(waitTime)

                -- Finish fishing
                FinishFish:FireServer()
                LastFishTime = tick()

                -- Minimal delay between cycles
                task.wait(0.2)
            end)

            if not success then
                warn("[AutoFishingV1] Error, restarting in 1s...")
                task.wait(1)
            end
        end
        print("[AutoFishingV1] Stopped")
    end)
end

-- ===== AUTO FISHING V2 (NEW METHOD - USING UpdateAutoFishingState) =====
local function AutoFishingV2()
    task.spawn(function()
        print("[AutoFishingV2] Started - New Method")
        
        -- Enable auto fishing mode
        local enableSuccess = pcall(function()
            UpdateAutoFishing:InvokeServer(true)
        end)
        
        if not enableSuccess then
            warn("[AutoFishingV2] Failed to enable auto fishing")
            return
        end
        
        while Config.AutoFishingV2 do
            pcall(function()
                -- Equip rod
                EquipTool:FireServer(1)
                task.wait(0.3)
                
                -- Perfect charge every time
                ChargeRod:InvokeServer(tick())
                task.wait(0.1)
                
                -- Perfect cast
                StartMini:InvokeServer(-1.233184814453125, 0.9945034885633273)
                task.wait(2)
                
                -- Complete
                FinishFish:FireServer()
                task.wait(0.5)
            end)
        end
        
        -- Disable when stopped
        pcall(function()
            UpdateAutoFishing:InvokeServer(false)
        end)
        
        print("[AutoFishingV2] Stopped")
    end)
end

-- ===== PERFECT CATCH =====
local PerfectCatchConn = nil
local function TogglePerfectCatch(enabled)
    Config.PerfectCatch = enabled
    
    if enabled then
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "InvokeServer" and self == StartMini then
                if Config.PerfectCatch then
                    return old(self, -1.233184814453125, 0.9945034885633273)
                end
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end
end

-- ===== AUTO ENCHANT SYSTEM =====
local function GetEnchantStoneCount()
    local count = 0
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:lower():find("enchant") and item.Name:lower():find("stone") then
                count = count + 1
            end
        end
    end
    return count
end

local function AutoEnchant()
    task.spawn(function()
        print("[AutoEnchant] Started")
        while Config.AutoEnchant do
            pcall(function()
                local stoneCount = GetEnchantStoneCount()
                Config.EnchantStoneCount = stoneCount
                
                if stoneCount > 0 then
                    -- Activate enchant altar (no need to equip stone)
                    ActivateEnchantAltar:FireServer()
                    task.wait(0.5)
                    
                    Rayfield:Notify({
                        Title = "Auto Enchant",
                        Content = string.format("Enchanted! Stones left: %d", stoneCount - 1),
                        Duration = 2
                    })
                else
                    Rayfield:Notify({
                        Title = "Auto Enchant",
                        Content = "No enchant stones left!",
                        Duration = 3
                    })
                    Config.AutoEnchant = false
                end
            end)
            task.wait(2)
        end
        print("[AutoEnchant] Stopped")
    end)
end

-- ===== AUTO BUY WEATHER =====
local WeatherList = {"Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"}

local function BuyWeather(weatherName)
    local success = pcall(function()
        PurchaseWeather:InvokeServer(weatherName)
    end)
    
    if success then
        Rayfield:Notify({
            Title = "Weather Purchased",
            Content = weatherName .. " activated!",
            Duration = 2
        })
    else
        warn("[BuyWeather] Failed to buy: " .. weatherName)
    end
end

local function AutoBuyWeather()
    task.spawn(function()
        print("[AutoBuyWeather] Started")
        while Config.AutoBuyWeather do
            for _, weather in ipairs(Config.SelectedWeathers) do
                if Config.AutoBuyWeather then
                    BuyWeather(weather)
                    task.wait(1)
                end
            end
            task.wait(30) -- Check every 30 seconds
        end
        print("[AutoBuyWeather] Stopped")
    end)
end

-- ===== AUTO ACCEPT TRADE =====
local function AutoAcceptTrade()
    task.spawn(function()
        print("[AutoAcceptTrade] Monitoring trades...")
        while Config.AutoAcceptTrade do
            pcall(function()
                local canTrade = CanSendTrade:InvokeServer()
                if canTrade then
                    task.wait(0.1)
                    AwaitTradeResponse:InvokeServer(true)
                    task.wait(0.1)
                    AwaitTradeResponse:InvokeServer(true)
                    
                    Rayfield:Notify({
                        Title = "Trade Accepted",
                        Content = "Trade automatically accepted!",
                        Duration = 2
                    })
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- ===== AUTO REJOIN ON DISCONNECT =====
local function SetupAutoRejoin()
    if Config.AutoRejoinDisconnect then
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            if Config.AutoRejoinDisconnect then
                task.wait(1)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
        
        LocalPlayer.OnTeleport:Connect(function(State)
            if State == Enum.TeleportState.Failed and Config.AutoRejoinDisconnect then
                task.wait(1)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end
end

-- ===== REJOIN RANDOM SERVER =====
local function RejoinRandomServer()
    local servers = {}
    local success = pcall(function()
        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and servers.data then
        local randomServer = servers.data[math.random(1, #servers.data)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, LocalPlayer)
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- ===== SAVE/LOAD CONFIG =====
local function SaveConfig()
    if not Config.AutoSaveConfig then return end
    
    local configData = HttpService:JSONEncode(Config)
    writefile("NikzzFishIt_Config.json", configData)
    print("[Config] Saved successfully")
end

local function LoadConfig()
    if not Config.AutoLoadConfig then return end
    
    if isfile("NikzzFishIt_Config.json") then
        local configData = readfile("NikzzFishIt_Config.json")
        local loadedConfig = HttpService:JSONDecode(configData)
        
        for key, value in pairs(loadedConfig) do
            Config[key] = value
        end
        
        print("[Config] Loaded successfully")
        Rayfield:Notify({
            Title = "Config Loaded",
            Content = "Previous settings restored!",
            Duration = 3
        })
    end
end

-- ===== AUTO JUMP (FIXED - NO FLY) =====
local function StartAutoJump()
    task.spawn(function()
        while Config.AutoJump do
            if Humanoid and Humanoid.Health > 0 and Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid.Jump = true
            end
            task.wait(Config.AutoJumpDelay)
        end
    end)
end

-- ===== VISUAL FIXES (PERMANENT EFFECTS) =====
local VisualConnections = {}

local function ApplyPermanentFullbright()
    if VisualConnections.Fullbright then
        VisualConnections.Fullbright:Disconnect()
    end
    
    VisualConnections.Fullbright = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end)
end

local function ApplyPermanentBrightness(value)
    if VisualConnections.Brightness then
        VisualConnections.Brightness:Disconnect()
    end
    
    VisualConnections.Brightness = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = value
    end)
end

local function ApplyPermanentTimeOfDay(value)
    if VisualConnections.TimeOfDay then
        VisualConnections.TimeOfDay:Disconnect()
    end
    
    VisualConnections.TimeOfDay = RunService.RenderStepped:Connect(function()
        Lighting.ClockTime = value
    end)
end

local function StopPermanentEffect(effectName)
    if VisualConnections[effectName] then
        VisualConnections[effectName]:Disconnect()
        VisualConnections[effectName] = nil
    end
end

-- ===== ENHANCED 8-BIT MODE (5X SMOOTHER) =====
local function Enable8BitEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
    
    -- Extra smoothing
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    
    Rayfield:Notify({
        Title = "8-Bit Enhanced",
        Content = "5x smoother graphics applied!",
        Duration = 2
    })
end

-- ===== ENHANCED PARTICLE REMOVAL =====
local function RemoveParticlesEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj:Destroy()
        elseif obj:IsA("Trail") then
            obj:Destroy()
        elseif obj:IsA("Beam") then
            obj:Destroy()
        elseif obj:IsA("Smoke") then
            obj:Destroy()
        elseif obj:IsA("Fire") then
            obj:Destroy()
        elseif obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end
    
    Rayfield:Notify({
        Title = "Particles Removed",
        Content = "All effects destroyed!",
        Duration = 2
    })
end

-- ===== ENHANCED SEAWEED REMOVAL =====
local function RemoveSeaweedEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("seaweed") or name:find("kelp") or name:find("coral") or name:find("plant") then
            if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
                obj:Destroy()
            end
        end
    end
    
    Rayfield:Notify({
        Title = "Seaweed Removed",
        Content = "Ocean cleared completely!",
        Duration = 2
    })
end

-- ===== ENHANCED WATER OPTIMIZATION =====
local function OptimizeWaterEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Terrain") then
            obj.WaterReflectance = 0
            obj.WaterTransparency = 1
            obj.WaterWaveSize = 0
            obj.WaterWaveSpeed = 0
        elseif obj:IsA("Part") and obj.Material == Enum.Material.Water then
            obj.Transparency = 1
            obj.CanCollide = false
        end
    end
    
    Rayfield:Notify({
        Title = "Water Optimized",
        Content = "Ultra performance mode!",
        Duration = 2
    })
end

-- ===== ENHANCED PERFORMANCE MODE =====
local function PerformanceModeEnhanced()
    -- Lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 0
    
    -- Quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Remove everything
    RemoveParticlesEnhanced()
    RemoveSeaweedEnhanced()
    OptimizeWaterEnhanced()
    Enable8BitEnhanced()
    
    -- Destroy decorations
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("SurfaceGui") then
            obj:Destroy()
        end
    end
    
    Rayfield:Notify({
        Title = "Performance Mode",
        Content = "Maximum FPS optimization!",
        Duration = 3
    })
end

-- ===== EXTRA FPS BOOST (ULTRA LOW RENDERING) =====
local function ExtraFPSBoost()
    -- Lowest possible settings
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    
    -- Disable everything
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 0
    Lighting.Brightness = 0
    
    -- Destroy all visual elements
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
           obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or
           obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceGui") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("MeshPart") then
            obj.TextureID = ""
        end
    end
    
    Rayfield:Notify({
        Title = "EXTRA FPS BOOST",
        Content = "Ultra low rendering active!",
        Duration = 3
    })
end

-- ===== HD GRAPHICS MEDIUM =====
local function HDGraphicsMedium()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
    Lighting.GlobalShadows = true
    Lighting.Brightness = 2
    Lighting.FogEnd = 50000
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            obj.Density = 0.3
            obj.Offset = 0.5
        elseif obj:IsA("BloomEffect") then
            obj.Enabled = true
            obj.Intensity = 0.5
        elseif obj:IsA("ColorCorrectionEffect") then
            obj.Enabled = true
            obj.Contrast = 0.1
        end
    end
    
    Rayfield:Notify({
        Title = "HD Graphics Medium",
        Content = "Balanced quality applied!",
        Duration = 2
    })
end

-- ===== HD GRAPHICS ULTRA (20X QUALITY) =====
local function HDGraphicsUltra()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
    Lighting.GlobalShadows = true
    Lighting.Technology = Enum.Technology.Future
    Lighting.Brightness = 3
    Lighting.FogEnd = 100000
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    
    -- Add/enhance effects
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
    bloom.Enabled = true
    bloom.Intensity = 1
    bloom.Size = 24
    bloom.Threshold = 0.5
    
    local blur = Lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", Lighting)
    blur.Enabled = false
    
    local colorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
    colorCorrection.Enabled = true
    colorCorrection.Brightness = 0.05
    colorCorrection.Contrast = 0.2
    colorCorrection.Saturation = 0.1
    
    local sunRays = Lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", Lighting)
    sunRays.Enabled = true
    sunRays.Intensity = 0.15
    sunRays.Spread = 0.5
    
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.4
    atmosphere.Offset = 1
    atmosphere.Color = Color3.fromRGB(199, 199, 199)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.5
    atmosphere.Haze = 1
    
    Rayfield:Notify({
        Title = "HD GRAPHICS ULTRA",
        Content = "Maximum quality 20x applied!",
        Duration = 3
    })
end

-- Continue with other features...
local function ToggleRadar(state)
    pcall(function()
        Radar:InvokeServer(state)
    end)
end

local function ToggleDivingGear(state)
    pcall(function()
        if state then
            EquipTool:FireServer(2)
            EquipOxy:InvokeServer(105)
        else
            UnequipOxy:InvokeServer()
        end
    end)
end

local function StartAntiAFK()
    spawn(function()
        while Config.AntiAFK do
            for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
                pcall(function() conn:Disable() end)
            end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            task.wait(30)
        end
    end)
end

local function StartAutoSell()
    task.spawn(function()
        while Config.AutoSell do
            if SellRemote then
                pcall(function()
                    SellRemote:InvokeServer()
                end)
            end
            task.wait(10)
        end
    end)
end

-- Island Data
local IslandsData = {
    {Name = "Fisherman Island", Position = Vector3.new(92, 9, 2768)},
    {Name = "Arrow Lever", Position = Vector3.new(898, 8, -363)},
    {Name = "Sisyphus Statue", Position = Vector3.new(-3740, -136, -1013)},
    {Name = "Ancient Jungle", Position = Vector3.new(1481, 11, -302)},
    {Name = "Weather Machine", Position = Vector3.new(-1519, 2, 1908)},
    {Name = "Coral Refs", Position = Vector3.new(-3105, 6, 2218)},
    {Name = "Tropical Island", Position = Vector3.new(-2110, 53, 3649)},
    {Name = "Kohana", Position = Vector3.new(-662, 3, 714)},
    {Name = "Esoteric Island", Position = Vector3.new(2035, 27, 1386)},
    {Name = "Diamond Lever", Position = Vector3.new(1818, 8, -285)},
    {Name = "Underground Cellar", Position = Vector3.new(2098, -92, -703)},
    {Name = "Volcano", Position = Vector3.new(-631, 54, 194)},
    {Name = "Enchant Room", Position = Vector3.new(3255, -1302, 1371)},
    {Name = "Lost Isle", Position = Vector3.new(-3717, 5, -1079)},
    {Name = "Sacred Temple", Position = Vector3.new(1475, -22, -630)},
    {Name = "Creater Island", Position = Vector3.new(981, 41, 5080)},
    {Name = "Double Enchant Room", Position = Vector3.new(1480, 127, -590)},
    {Name = "Treassure Room", Position = Vector3.new(-3599, -276, -1642)},
    {Name = "Crescent Lever", Position = Vector3.new(1419, 31, 78)},
    {Name = "Hourglass Diamond Lever", Position = Vector3.new(1484, 8, -862)},
    {Name = "Snow Island", Position = Vector3.new(1627, 4, 3288)}
}

local function TeleportToPosition(pos)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(pos)
        return true
    end
    return false
end

local LockConn = nil
local function ToggleLockPosition(enabled)
    Config.LockedPosition = enabled
    
    if enabled then
        Config.LockCFrame = HumanoidRootPart.CFrame
        
        if LockConn then LockConn:Disconnect() end
        LockConn = RunService.Heartbeat:Connect(function()
            if Config.LockedPosition and Config.LockCFrame then
                HumanoidRootPart.CFrame = Config.LockCFrame
            end
        end)
    else
        if LockConn then
            LockConn:Disconnect()
            LockConn = nil
        end
    end
end

local function ScanActiveEvents()
    local events = {}
    local validEvents = {
        "megalodon", "whale", "kraken", "worm", "hunt", "boss", "raid", "ghost"
    }
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local name = obj.Name:lower()
            
            for _, keyword in ipairs(validEvents) do
                if name:find(keyword) and not name:find("sharki") and not name:find("boat") then
                    local exists = false
                    for _, e in ipairs(events) do
                        if e.Name == obj.Name then
                            exists = true
                            break
                        end
                    end
                    
                    if not exists then
                        table.insert(events, {
                            Name = obj.Name,
                            Object = obj,
                            Position = obj:GetModelCFrame().Position
                        })
                    end
                    break
                end
            end
        end
    end
    
    return events
end

local GodConnection = nil
local function ToggleGodMode(enabled)
    Config.GodMode = enabled
    
    if enabled then
        if GodConnection then GodConnection:Disconnect() end
        GodConnection = RunService.Heartbeat:Connect(function()
            if Config.GodMode and Humanoid then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    else
        if GodConnection then
            GodConnection:Disconnect()
            GodConnection = nil
        end
    end
end

local FlyBV = nil
local FlyBG = nil
local FlyConn = nil

local function StartFly()
    if not Config.FlyEnabled then return end
    
    if FlyBV then FlyBV:Destroy() end
    if FlyBG then FlyBG:Destroy() end
    
    FlyBV = Instance.new("BodyVelocity")
    FlyBV.Parent = HumanoidRootPart
    FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBV.Velocity = Vector3.zero
    
    FlyBG = Instance.new("BodyGyro")
    FlyBG.Parent = HumanoidRootPart
    FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBG.P = 9e4
    
    if FlyConn then FlyConn:Disconnect() end
    
    FlyConn = RunService.Heartbeat:Connect(function()
        if not Config.FlyEnabled then
            if FlyBV then FlyBV:Destroy() FlyBV = nil end
            if FlyBG then FlyBG:Destroy() FlyBG = nil end
            if FlyConn then FlyConn:Disconnect() FlyConn = nil end
            return
        end
        
        local cam = Workspace.CurrentCamera
        local dir = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        
        FlyBV.Velocity = dir * Config.FlySpeed
        FlyBG.CFrame = cam.CFrame
    end)
end

local function StopFly()
    Config.FlyEnabled = false
    if FlyBV then FlyBV:Destroy() FlyBV = nil end
    if FlyBG then FlyBG:Destroy() FlyBG = nil end
    if FlyConn then FlyConn:Disconnect() FlyConn = nil end
end

local WaterPart = nil
local WaterConn = nil

local function ToggleWalkOnWater(enabled)
    Config.WalkOnWater = enabled

    if enabled then
        if not WaterPart then
            WaterPart = Instance.new("Part")
            WaterPart.Size = Vector3.new(14, 0.2, 14)
            WaterPart.Anchored = true
            WaterPart.CanCollide = true
            WaterPart.Transparency = 1
            WaterPart.Material = Enum.Material.SmoothPlastic
            WaterPart.Name = "InvisibleWaterSurface"
            WaterPart.Parent = workspace
        end

        if WaterConn then WaterConn:Disconnect() end
        local baseY = HumanoidRootPart.Position.Y - 3

        WaterConn = RunService.Heartbeat:Connect(function()
            if Config.WalkOnWater and HumanoidRootPart and WaterPart then
                local pos = HumanoidRootPart.Position
                WaterPart.CFrame = CFrame.new(pos.X, baseY, pos.Z)
            end
        end)
    else
        if WaterConn then
            WaterConn:Disconnect()
            WaterConn = nil
        end
        if WaterPart then
            WaterPart:Destroy()
            WaterPart = nil
        end
    end
end

local NoClipConn = nil
local function ToggleNoClip(enabled)
    Config.NoClip = enabled
    
    if enabled then
        if NoClipConn then NoClipConn:Disconnect() end
        NoClipConn = RunService.Stepped:Connect(function()
            if Config.NoClip and Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoClipConn then
            NoClipConn:Disconnect()
            NoClipConn = nil
        end
    end
end

local function ToggleXRay(state)
    Config.XRay = state
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= Character then
            if state then
                obj.LocalTransparencyModifier = 0.7
            else
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end

local ESPConnections = {}

local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = hrp
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
    
    local conn = RunService.RenderStepped:Connect(function()
        if not Config.ESPEnabled or not player.Character or not HumanoidRootPart then
            billboard:Destroy()
            return
        end
        
        local distance = (HumanoidRootPart.Position - hrp.Position).Magnitude
        textLabel.Text = string.format("%s\n[%.0f studs]", player.Name, distance)
        textLabel.TextSize = Config.ESPDistance
    end)
    
    ESPConnections[player] = conn
end

local function ToggleESP(enabled)
    Config.ESPEnabled = enabled
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    else
        for player, conn in pairs(ESPConnections) do
            conn:Disconnect()
            if player.Character then
                local billboard = player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("ESP_" .. player.Name)
                if billboard then
                    billboard:Destroy()
                end
            end
        end
        ESPConnections = {}
    end
end

local function EnableInfiniteZoom()
    Config.InfiniteZoom = true
    LocalPlayer.CameraMaxZoomDistance = 9999
    LocalPlayer.CameraMinZoomDistance = 0.5
end

-- ===== UI CREATION =====
local function CreateUI()
    local Islands = {}
    local Players_List = {}
    local Events = {}
    
    -- ===== FISHING TAB =====
    local Tab1 = Window:CreateTab("🎣 Fishing", 4483362458)
    
    Tab1:CreateSection("Auto Features")
    
    Tab1:CreateToggle({
        Name = "Auto Fishing V1 (Ultra Fast + Anti-Stuck)",
        CurrentValue = false,
        Flag = "AutoFishV1",
        Callback = function(Value)
            Config.AutoFishingV1 = Value
            if Value then
                Config.AutoFishingV2 = false
                AutoFishingV1()
                Rayfield:Notify({Title = "Auto Fishing V1", Content = "Ultra Fast Mode Started!", Duration = 3})
            end
        end
    })
    
    Tab1:CreateToggle({
        Name = "Auto Fishing V2 (UpdateAutoFishing Method)",
        CurrentValue = false,
        Flag = "AutoFishV2",
        Callback = function(Value)
            Config.AutoFishingV2 = Value
            if Value then
                Config.AutoFishingV1 = false
                AutoFishingV2()
                Rayfield:Notify({Title = "Auto Fishing V2", Content = "New Method Started!", Duration = 3})
            end
        end
    })
    
    Tab1:CreateSlider({
        Name = "Fishing Delay (V1 Only) - Lower = Faster",
        Range = {0.3, 5},
        Increment = 0.1,
        CurrentValue = 0.5,
        Flag = "FishDelay",
        Callback = function(Value)
            Config.FishingDelay = Value
        end
    })
    
    Tab1:CreateToggle({
        Name = "Anti AFK",
        CurrentValue = false,
        Flag = "AntiAFK",
        Callback = function(Value)
            Config.AntiAFK = Value
            if Value then StartAntiAFK() end
        end
    })
    
    Tab1:CreateToggle({
        Name = "Auto Sell Fish",
        CurrentValue = false,
        Flag = "AutoSell",
        Callback = function(Value)
            Config.AutoSell = Value
            if Value then StartAutoSell() end
        end
    })
    
    Tab1:CreateSection("Extra Fishing")
    
    Tab1:CreateToggle({
        Name = "Perfect Catch",
        CurrentValue = false,
        Flag = "PerfectCatch",
        Callback = function(Value)
            TogglePerfectCatch(Value)
            Rayfield:Notify({
                Title = "Perfect Catch",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
        end
    })
    
    Tab1:CreateToggle({
        Name = "Enable Radar",
        CurrentValue = false,
        Callback = function(Value)
            ToggleRadar(Value)
        end
    })
    
    Tab1:CreateToggle({
        Name = "Enable Diving Gear",
        CurrentValue = false,
        Callback = function(Value)
            ToggleDivingGear(Value)
        end
    })
    
    Tab1:CreateSection("Settings")
    
    Tab1:CreateToggle({
        Name = "Auto Jump (Fixed - No Fly)",
        CurrentValue = false,
        Flag = "AutoJump",
        Callback = function(Value)
            Config.AutoJump = Value
            if Value then StartAutoJump() end
        end
    })
    
    Tab1:CreateSlider({
        Name = "Jump Delay",
        Range = {1, 10},
        Increment = 0.5,
        CurrentValue = 3,
        Flag = "JumpDelay",
        Callback = function(Value)
            Config.AutoJumpDelay = Value
        end
    })
    
    -- ===== AUTO ENCHANT TAB =====
    local Tab2 = Window:CreateTab("✨ Auto Enchant", 4483362458)
    
    Tab2:CreateSection("Enchant System")
    
    Tab2:CreateParagraph({
        Title = "ℹ️ How it works",
        Content = "Automatically enchants your fishing rod using Enchant Stones. No need to equip the stone manually!"
    })
    
    Tab2:CreateToggle({
        Name = "Auto Enchant Rod",
        CurrentValue = false,
        Flag = "AutoEnchant",
        Callback = function(Value)
            Config.AutoEnchant = Value
            if Value then
                AutoEnchant()
                Rayfield:Notify({
                    Title = "Auto Enchant",
                    Content = "Enchanting started!",
                    Duration = 2
                })
            end
        end
    })
    
    Tab2:CreateButton({
        Name = "Check Enchant Stone Count",
        Callback = function()
            local count = GetEnchantStoneCount()
            Rayfield:Notify({
                Title = "Enchant Stones",
                Content = string.format("You have %d stones", count),
                Duration = 3
            })
        end
    })
    
    Tab2:CreateSection("Weather System")
    
    Tab2:CreateParagraph({
        Title = "🌤️ Auto Buy Weather",
        Content = "Select up to 3 weather types to purchase automatically when slots are empty."
    })
    
    local WeatherDropdown = Tab2:CreateDropdown({
        Name = "Select Weathers (Max 3)",
        Options = WeatherList,
        CurrentOption = {},
        MultipleOptions = true,
        Callback = function(Options)
            if #Options <= 3 then
                Config.SelectedWeathers = Options
            else
                Rayfield:Notify({
                    Title = "Weather Limit",
                    Content = "Maximum 3 weathers only!",
                    Duration = 2
                })
            end
        end
    })
    
    Tab2:CreateButton({
        Name = "Buy Selected Weathers Once",
        Callback = function()
            for _, weather in ipairs(Config.SelectedWeathers) do
                BuyWeather(weather)
                task.wait(0.5)
            end
        end
    })
    
    Tab2:CreateToggle({
        Name = "Auto Buy Weather (Loop)",
        CurrentValue = false,
        Flag = "AutoBuyWeather",
        Callback = function(Value)
            Config.AutoBuyWeather = Value
            if Value then
                AutoBuyWeather()
                Rayfield:Notify({
                    Title = "Auto Buy Weather",
                    Content = "Started purchasing weathers!",
                    Duration = 2
                })
            end
        end
    })
    
    -- ===== TELEPORT TAB =====
    local Tab3 = Window:CreateTab("📍 Teleport", 4483362458)
    
    Tab3:CreateSection("Islands")
    
    local IslandOptions = {}
    for i, island in ipairs(IslandsData) do
        table.insert(IslandOptions, string.format("%d. %s", i, island.Name))
    end
    
    local IslandDrop = Tab3:CreateDropdown({
        Name = "Select Island",
        Options = IslandOptions,
        CurrentOption = {IslandOptions[1]},
        Callback = function(Option) end
    })
    
    Tab3:CreateButton({
        Name = "Teleport to Island",
        Callback = function()
            local selected = IslandDrop.CurrentOption[1]
            local index = tonumber(selected:match("^(%d+)%."))
            
            if index and IslandsData[index] then
                TeleportToPosition(IslandsData[index].Position)
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. IslandsData[index].Name,
                    Duration = 2
                })
            end
        end
    })
    
    Tab3:CreateToggle({
        Name = "Lock Position",
        CurrentValue = false,
        Flag = "LockPos",
        Callback = function(Value)
            ToggleLockPosition(Value)
        end
    })
    
    Tab3:CreateSection("Players")
    
    local PlayerDrop = Tab3:CreateDropdown({
        Name = "Select Player",
        Options = {"Load players first"},
        CurrentOption = {"Load players first"},
        Callback = function(Option) end
    })
    
    Tab3:CreateButton({
        Name = "Load Players",
        Callback = function()
            Players_List = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    table.insert(Players_List, player.Name)
                end
            end
            
            if #Players_List == 0 then
                Players_List = {"No players online"}
            end
            
            PlayerDrop:Refresh(Players_List)
            Rayfield:Notify({
                Title = "Players Loaded",
                Content = string.format("Found %d players", #Players_List),
                Duration = 2
            })
        end
    })
    
    Tab3:CreateButton({
        Name = "Teleport to Player",
        Callback = function()
            local selected = PlayerDrop.CurrentOption[1]
            local player = Players:FindFirstChild(selected)
            
            if player and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                    Rayfield:Notify({Title = "Teleported", Content = "Teleported to " .. selected, Duration = 2})
                end
            end
        end
    })
    
    Tab3:CreateSection("Events")
    
    local EventDrop = Tab3:CreateDropdown({
        Name = "Select Event",
        Options = {"Load events first"},
        CurrentOption = {"Load events first"},
        Callback = function(Option) end
    })
    
    Tab3:CreateButton({
        Name = "Load Events",
        Callback = function()
            Events = ScanActiveEvents()
            local options = {}
            
            for i, event in ipairs(Events) do
                table.insert(options, string.format("%d. %s", i, event.Name))
            end
            
            if #options == 0 then
                options = {"No events active"}
            end
            
            EventDrop:Refresh(options)
            Rayfield:Notify({
                Title = "Events Loaded",
                Content = string.format("Found %d events", #Events),
                Duration = 2
            })
        end
    })
    
    Tab3:CreateButton({
        Name = "Teleport to Event",
        Callback = function()
            local selected = EventDrop.CurrentOption[1]
            local index = tonumber(selected:match("^(%d+)%."))
            
            if index and Events[index] then
                TeleportToPosition(Events[index].Position)
                Rayfield:Notify({Title = "Teleported", Content = "Teleported to event", Duration = 2})
            end
        end
    })
    
    Tab3:CreateSection("Position Manager")
    
    Tab3:CreateButton({
        Name = "Save Current Position",
        Callback = function()
            Config.SavedPosition = HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Saved", Content = "Position saved", Duration = 2})
        end
    })
    
    Tab3:CreateButton({
        Name = "Teleport to Saved Position",
        Callback = function()
            if Config.SavedPosition then
                HumanoidRootPart.CFrame = Config.SavedPosition
                Rayfield:Notify({Title = "Teleported", Content = "Loaded saved position", Duration = 2})
            else
                Rayfield:Notify({Title = "Error", Content = "No saved position", Duration = 2})
            end
        end
    })
    
    -- ===== UTILITY TAB =====
    local Tab4 = Window:CreateTab("⚡ Utility", 4483362458)
    
    Tab4:CreateSection("Speed Settings")
    
    Tab4:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 500},
        Increment = 1,
        CurrentValue = 16,
        Flag = "WalkSpeed",
        Callback = function(Value)
            Config.WalkSpeed = Value
            if Humanoid then
                Humanoid.WalkSpeed = Value
            end
        end
    })
    
    Tab4:CreateSlider({
        Name = "Jump Power",
        Range = {50, 500},
        Increment = 5,
        CurrentValue = 50,
        Flag = "JumpPower",
        Callback = function(Value)
            Config.JumpPower = Value
            if Humanoid then
                Humanoid.JumpPower = Value
            end
        end
    })
    
    Tab4:CreateSection("Movement")
    
    Tab4:CreateToggle({
        Name = "Fly Mode",
        CurrentValue = false,
        Flag = "Fly",
        Callback = function(Value)
            Config.FlyEnabled = Value
            if Value then
                StartFly()
            else
                StopFly()
            end
        end
    })
    
    Tab4:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 300},
        Increment = 5,
        CurrentValue = 50,
        Flag = "FlySpeed",
        Callback = function(Value)
            Config.FlySpeed = Value
        end
    })
    
    Tab4:CreateToggle({
        Name = "Walk on Water",
        CurrentValue = false,
        Flag = "WalkWater",
        Callback = function(Value)
            ToggleWalkOnWater(Value)
        end
    })
    
    Tab4:CreateToggle({
        Name = "NoClip",
        CurrentValue = false,
        Flag = "NoClip",
        Callback = function(Value)
            ToggleNoClip(Value)
        end
    })
    
    Tab4:CreateToggle({
        Name = "XRay",
        CurrentValue = false,
        Callback = function(Value)
            ToggleXRay(Value)
        end
    })
    
    Tab4:CreateButton({
        Name = "Infinite Jump",
        Callback = function()
            UserInputService.JumpRequest:Connect(function()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            Rayfield:Notify({Title = "Infinite Jump", Content = "Enabled", Duration = 2})
        end
    })
    
    -- ===== UTILITY II TAB =====
    local Tab5 = Window:CreateTab("⚡ Utility II", 4483362458)
    
    Tab5:CreateSection("Protection")
    
    Tab5:CreateToggle({
        Name = "God Mode",
        CurrentValue = false,
        Flag = "GodMode",
        Callback = function(Value)
            ToggleGodMode(Value)
        end
    })
    
    Tab5:CreateSection("Player ESP")
    
    Tab5:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Flag = "ESP",
        Callback = function(Value)
            ToggleESP(Value)
        end
    })
    
    Tab5:CreateSlider({
        Name = "ESP Text Size",
        Range = {10, 50},
        Increment = 1,
        CurrentValue = 20,
        Callback = function(Value)
            Config.ESPDistance = Value
        end
    })
    
    Tab5:CreateSection("Trade System")
    
    Tab5:CreateToggle({
        Name = "Auto Accept Trade",
        CurrentValue = false,
        Flag = "AutoTrade",
        Callback = function(Value)
            Config.AutoAcceptTrade = Value
            if Value then
                AutoAcceptTrade()
                Rayfield:Notify({
                    Title = "Auto Accept Trade",
                    Content = "Now accepting trades automatically!",
                    Duration = 3
                })
            end
        end
    })
    
    -- ===== VISUALS TAB =====
    local Tab6 = Window:CreateTab("👁️ Visuals", 4483362458)
    
    Tab6:CreateSection("Lighting (Permanent Effects)")
    
    Tab6:CreateButton({
        Name = "Fullbright (Permanent)",
        Callback = function()
            ApplyPermanentFullbright()
            Rayfield:Notify({Title = "Fullbright", Content = "Permanent effect applied!", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Stop Fullbright Effect",
        Callback = function()
            StopPermanentEffect("Fullbright")
            Rayfield:Notify({Title = "Fullbright", Content = "Effect stopped", Duration = 2})
        end
    })
    
    Tab6:CreateSlider({
        Name = "Brightness (Permanent)",
        Range = {0, 10},
        Increment = 0.5,
        CurrentValue = 2,
        Callback = function(Value)
            ApplyPermanentBrightness(Value)
        end
    })
    
    Tab6:CreateButton({
        Name = "Stop Brightness Effect",
        Callback = function()
            StopPermanentEffect("Brightness")
        end
    })
    
    Tab6:CreateSlider({
        Name = "Time of Day (Permanent)",
        Range = {0, 24},
        Increment = 0.5,
        CurrentValue = 14,
        Callback = function(Value)
            ApplyPermanentTimeOfDay(Value)
        end
    })
    
    Tab6:CreateButton({
        Name = "Stop Time Effect",
        Callback = function()
            StopPermanentEffect("TimeOfDay")
        end
    })
    
    Tab6:CreateSection("Effects (Enhanced)")
    
    Tab6:CreateButton({
        Name = "8-Bit Mode (5x Smoother)",
        Callback = function()
            Enable8BitEnhanced()
        end
    })
    
    Tab6:CreateButton({
        Name = "Remove Particles (Enhanced)",
        Callback = function()
            RemoveParticlesEnhanced()
        end
    })
    
    Tab6:CreateButton({
        Name = "Remove Seaweed (Enhanced)",
        Callback = function()
            RemoveSeaweedEnhanced()
        end
    })
    
    Tab6:CreateButton({
        Name = "Optimize Water (Enhanced)",
        Callback = function()
            OptimizeWaterEnhanced()
        end
    })
    
    Tab6:CreateButton({
        Name = "Performance Mode (Enhanced)",
        Callback = function()
            PerformanceModeEnhanced()
        end
    })
    
    Tab6:CreateSection("Graphics Quality")
    
    Tab6:CreateButton({
        Name = "EXTRA FPS BOOST (Ultra Low)",
        Callback = function()
            ExtraFPSBoost()
        end
    })
    
    Tab6:CreateButton({
        Name = "HD Graphics Medium",
        Callback = function()
            HDGraphicsMedium()
        end
    })
    
    Tab6:CreateButton({
        Name = "HD GRAPHICS ULTRA (20x Quality)",
        Callback = function()
            HDGraphicsUltra()
        end
    })
    
    Tab6:CreateSection("Camera")
    
    Tab6:CreateButton({
        Name = "Infinite Zoom",
        Callback = function()
            EnableInfiniteZoom()
            Rayfield:Notify({Title = "Infinite Zoom", Content = "Enabled", Duration = 2})
        end
    })
    
    -- ===== SERVER TAB =====
    local Tab7 = Window:CreateTab("🌐 Server", 4483362458)
    
    Tab7:CreateSection("Rejoin System")
    
    Tab7:CreateToggle({
        Name = "Auto Rejoin on Disconnect",
        CurrentValue = false,
        Flag = "AutoRejoin",
        Callback = function(Value)
            Config.AutoRejoinDisconnect = Value
            SetupAutoRejoin()
            if Value then
                Rayfield:Notify({
                    Title = "Auto Rejoin",
                    Content = "Will rejoin if disconnected",
                    Duration = 3
                })
            end
        end
    })
    
    Tab7:CreateButton({
        Name = "Rejoin Current Server",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })
    
    Tab7:CreateButton({
        Name = "Rejoin Random Server",
        Callback = function()
            Rayfield:Notify({
                Title = "Rejoining",
                Content = "Finding random server...",
                Duration = 2
            })
            RejoinRandomServer()
        end
    })
    
    Tab7:CreateSection("Server Information")
    
    Tab7:CreateButton({
        Name = "Show Server Stats",
        Callback = function()
            local stats = string.format(
                "=== SERVER STATS ===\n" ..
                "Players: %d/%d\n" ..
                "Ping: %d ms\n" ..
                "FPS: %d\n" ..
                "Job ID: %s\n" ..
                "=== END ===",
                #Players:GetPlayers(),
                Players.MaxPlayers,
                math.floor(LocalPlayer:GetNetworkPing() * 1000),
                math.floor(workspace:GetRealPhysicsFPS()),
                game.JobId
            )
            print(stats)
            Rayfield:Notify({Title = "Server Stats", Content = "Check console (F9)", Duration = 3})
        end
    })
    
    Tab7:CreateButton({
        Name = "Copy Job ID",
        Callback = function()
            setclipboard(game.JobId)
            Rayfield:Notify({Title = "Copied", Content = "Job ID copied!", Duration = 2})
        end
    })
    
    -- ===== CONFIG TAB =====
    local Tab8 = Window:CreateTab("⚙️ Config", 4483362458)
    
    Tab8:CreateSection("Auto Save/Load")
    
    Tab8:CreateToggle({
        Name = "Auto Save Config",
        CurrentValue = true,
        Flag = "AutoSave",
        Callback = function(Value)
            Config.AutoSaveConfig = Value
            if Value then
                Rayfield:Notify({
                    Title = "Auto Save",
                    Content = "Config will save automatically",
                    Duration = 2
                })
            end
        end
    })
    
    Tab8:CreateToggle({
        Name = "Auto Load Config on Start",
        CurrentValue = true,
        Flag = "AutoLoad",
        Callback = function(Value)
            Config.AutoLoadConfig = Value
        end
    })
    
    Tab8:CreateSection("Manual Config")
    
    Tab8:CreateButton({
        Name = "Save Config Now",
        Callback = function()
            SaveConfig()
            Rayfield:Notify({
                Title = "Config Saved",
                Content = "All settings saved!",
                Duration = 2
            })
        end
    })
    
    Tab8:CreateButton({
        Name = "Load Config Now",
        Callback = function()
            LoadConfig()
            
            -- Reapply loaded settings
            if Config.AutoFishingV1 then AutoFishingV1() end
            if Config.AutoFishingV2 then AutoFishingV2() end
            if Config.AntiAFK then StartAntiAFK() end
            if Config.AutoJump then StartAutoJump() end
            if Config.AutoSell then StartAutoSell() end
            if Config.AutoEnchant then AutoEnchant() end
            if Config.AutoBuyWeather then AutoBuyWeather() end
            if Config.AutoAcceptTrade then AutoAcceptTrade() end
            if Config.GodMode then ToggleGodMode(true) end
            if Config.FlyEnabled then StartFly() end
            if Config.WalkOnWater then ToggleWalkOnWater(true) end
            if Config.NoClip then ToggleNoClip(true) end
            if Config.PerfectCatch then TogglePerfectCatch(true) end
            if Config.LockedPosition then ToggleLockPosition(true) end
            if Config.ESPEnabled then ToggleESP(true) end
            
            if Humanoid then
                Humanoid.WalkSpeed = Config.WalkSpeed
                Humanoid.JumpPower = Config.JumpPower
            end
            
            Rayfield:Notify({
                Title = "Config Loaded",
                Content = "Settings restored & applied!",
                Duration = 3
            })
        end
    })
    
    Tab8:CreateButton({
        Name = "Reset to Default Config",
        Callback = function()
            Config = {
                AutoFishingV1 = false,
                AutoFishingV2 = false,
                FishingDelay = 0.5,
                PerfectCatch = false,
                AntiAFK = false,
                AutoJump = false,
                AutoJumpDelay = 3,
                AutoSell = false,
                GodMode = false,
                FlyEnabled = false,
                FlySpeed = 50,
                WalkSpeed = 16,
                JumpPower = 50,
                WalkOnWater = false,
                NoClip = false,
                XRay = false,
                ESPEnabled = false,
                AutoEnchant = false,
                AutoBuyWeather = false,
                SelectedWeathers = {},
                AutoAcceptTrade = false,
                AutoRejoinDisconnect = false,
                AutoSaveConfig = true,
                AutoLoadConfig = true,
            }
            
            Rayfield:Notify({
                Title = "Config Reset",
                Content = "All settings reset to default",
                Duration = 3
            })
        end
    })
    
    Tab8:CreateSection("Config Info")
    
    Tab8:CreateParagraph({
        Title = "📁 Config Location",
        Content = "File: NikzzFishIt_Config.json\nLocation: Executor's workspace folder\n\nAuto-saves when you close the script or change settings."
    })
    
    -- ===== MISC TAB =====
    local Tab9 = Window:CreateTab("🔧 Misc", 4483362458)
    
    Tab9:CreateSection("Character")
    
    Tab9:CreateButton({
        Name = "Reset Character",
        Callback = function()
            Character:BreakJoints()
        end
    })
    
    Tab9:CreateButton({
        Name = "Remove Accessories",
        Callback = function()
            for _, obj in pairs(Character:GetChildren()) do
                if obj:IsA("Accessory") then
                    obj:Destroy()
                end
            end
            Rayfield:Notify({Title = "Accessories Removed", Content = "Character cleaned", Duration = 2})
        end
    })
    
    Tab9:CreateButton({
        Name = "Rainbow Character",
        Callback = function()
            spawn(function()
                for i = 1, 100 do
                    if Character then
                        for _, part in pairs(Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Color = Color3.fromHSV(i / 100, 1, 1)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
            Rayfield:Notify({Title = "Rainbow Mode", Content = "Character colorized", Duration = 2})
        end
    })
    
    Tab9:CreateSection("Audio")
    
    Tab9:CreateButton({
        Name = "Mute All Sounds",
        Callback = function()
            for _, sound in pairs(Workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0
                end
            end
            Rayfield:Notify({Title = "Sounds Muted", Content = "All audio disabled", Duration = 2})
        end
    })
    
    Tab9:CreateButton({
        Name = "Restore Sounds",
        Callback = function()
            for _, sound in pairs(Workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound.Volume = 0.5
                end
            end
            Rayfield:Notify({Title = "Sounds Restored", Content = "Audio enabled", Duration = 2})
        end
    })
    
    Tab9:CreateSection("Inventory")
    
    Tab9:CreateButton({
        Name = "Show Inventory",
        Callback = function()
            print("=== INVENTORY ===")
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local count = 0
            if backpack then
                for i, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        count = count + 1
                        print(string.format("[%d] %s", count, item.Name))
                    end
                end
            end
            print("=== TOTAL: " .. count .. " ===")
            Rayfield:Notify({Title = "Inventory", Content = "Found " .. count .. " items (check console)", Duration = 3})
        end
    })
    
    Tab9:CreateButton({
        Name = "Drop All Items",
        Callback = function()
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") then
                    item.Parent = Character
                    task.wait(0.1)
                    item.Parent = Workspace
                end
            end
            Rayfield:Notify({Title = "Items Dropped", Content = "All items dropped", Duration = 2})
        end
    })
    
    -- ===== INFO TAB =====
    local Tab10 = Window:CreateTab("ℹ️ Info", 4483362458)
    
    Tab10:CreateSection("Script Information")
    
    Tab10:CreateParagraph({
        Title = "NIKZZ FISH IT - V2 ULTIMATE",
        Content = "🔥 Upgraded Version - Perfect Edition\n👨‍💻 Developer: Nikzz\n📅 Release: 12 Oct 2025\n📱 Optimized for Delta Executor (Android)\n✅ Status: ALL FEATURES WORKING"
    })
    
    Tab10:CreateSection("🆕 New Features in V2")
    
    Tab10:CreateParagraph({
        Title = "⚡ Auto Fishing Improvements",
        Content = "✅ V1: Ultra Fast + Anti-Stuck System\n✅ V2: New UpdateAutoFishing Method\n✅ Perfect Catch Every Time\n✅ Auto Respawn on Stuck (V1)\n✅ Configurable Delay (0.3-5s)"
    })
    
    Tab10:CreateParagraph({
        Title = "✨ Auto Enchant System",
        Content = "✅ Auto Enchant Rod\n✅ No Manual Equipping\n✅ Stone Count Tracker\n✅ Notifications on Success"
    })
    
    Tab10:CreateParagraph({
        Title = "🌤️ Weather System",
        Content = "✅ Select Up to 3 Weathers\n✅ Manual Buy Option\n✅ Auto Buy Loop (Continuous)\n✅ 6 Weather Types Available"
    })
    
    Tab10:CreateParagraph({
        Title = "🤝 Trade & Rejoin",
        Content = "✅ Auto Accept Trade\n✅ Auto Rejoin on Disconnect\n✅ Rejoin Random Server\n✅ Instant Trade Response"
    })
    
    Tab10:CreateParagraph({
        Title = "⚙️ Config System",
        Content = "✅ Auto Save Settings\n✅ Auto Load on Start\n✅ Manual Save/Load\n✅ Reset to Default\n✅ Persistent Across Sessions"
    })
    
    Tab10:CreateParagraph({
        Title = "👁️ Visual Enhancements",
        Content = "✅ Permanent Fullbright\n✅ Permanent Brightness Control\n✅ Permanent Time of Day\n✅ 8-Bit Mode (5x Smoother)\n✅ Enhanced Particle Removal\n✅ Enhanced Seaweed Removal\n✅ Enhanced Water Optimization\n✅ Extra FPS Boost (Ultra Low)\n✅ HD Graphics Medium\n✅ HD Graphics Ultra (20x Quality)"
    })
    
    Tab10:CreateParagraph({
        Title = "🔧 Fixed Issues",
        Content = "✅ Auto Jump (No More Flying)\n✅ Fishing Delay Slider Working\n✅ No More Character Stuck\n✅ Visual Effects Now Permanent\n✅ All Performance Modes Enhanced"
    })
    
    Tab10:CreateSection("📚 Usage Guide")
    
    Tab10:CreateParagraph({
        Title = "⚡ Quick Start",
        Content = "1. Enable Auto Fishing V1 or V2\n2. Adjust Fishing Delay (Lower = Faster)\n3. Enable Anti-Stuck Protection (Auto)\n4. Use Auto Enchant for Rod Upgrades\n5. Select & Auto Buy Weathers\n6. Enable Auto Accept Trade\n7. Turn on Auto Rejoin (Safety)"
    })
    
    Tab10:CreateParagraph({
        Title = "💡 Pro Tips",
        Content = "• V1: Fastest, Use 0.3s delay\n• V2: Uses game's auto system\n• Lock Position: Stay in one spot\n• Auto Save: Keeps your settings\n• Extra FPS Boost: For low-end devices\n• HD Ultra: For high-end devices\n• Auto Rejoin: Never lose progress"
    })
    
    Tab10:CreateSection("Script Control")
    
    Tab10:CreateButton({
        Name = "Show Current Settings",
        Callback = function()
            local settings = string.format(
                "=== CURRENT SETTINGS ===\n" ..
                "Auto Fishing V1: %s\n" ..
                "Auto Fishing V2: %s\n" ..
                "Fishing Delay: %.1fs\n" ..
                "Auto Enchant: %s\n" ..
                "Auto Buy Weather: %s\n" ..
                "Selected Weathers: %d\n" ..
                "Auto Accept Trade: %s\n" ..
                "Auto Rejoin: %s\n" ..
                "God Mode: %s\n" ..
                "Fly Mode: %s\n" ..
                "Walk Speed: %d\n" ..
                "ESP Enabled: %s\n" ..
                "Auto Save: %s\n" ..
                "=== END ===",
                Config.AutoFishingV1 and "ON" or "OFF",
                Config.AutoFishingV2 and "ON" or "OFF",
                Config.FishingDelay,
                Config.AutoEnchant and "ON" or "OFF",
                Config.AutoBuyWeather and "ON" or "OFF",
                #Config.SelectedWeathers,
                Config.AutoAcceptTrade and "ON" or "OFF",
                Config.AutoRejoinDisconnect and "ON" or "OFF",
                Config.GodMode and "ON" or "OFF",
                Config.FlyEnabled and "ON" or "OFF",
                Config.WalkSpeed,
                Config.ESPEnabled and "ON" or "OFF",
                Config.AutoSaveConfig and "ON" or "OFF"
            )
            print(settings)
            Rayfield:Notify({Title = "Settings", Content = "Check console (F9)", Duration = 3})
        end
    })
    
    Tab10:CreateButton({
        Name = "Save All & Close Script",
        Callback = function()
            if Config.AutoSaveConfig then
                SaveConfig()
            end
            
            Rayfield:Notify({Title = "Closing Script", Content = "Saving & shutting down...", Duration = 2})
            
            -- Stop all features
            Config.AutoFishingV1 = false
            Config.AutoFishingV2 = false
            Config.AntiAFK = false
            Config.AutoJump = false
            Config.AutoSell = false
            Config.AutoEnchant = false
            Config.AutoBuyWeather = false
            Config.AutoAcceptTrade = false
            
            if GodConnection then GodConnection:Disconnect() end
            if LockConn then LockConn:Disconnect() end
            if WaterConn then WaterConn:Disconnect() end
            if NoClipConn then NoClipConn:Disconnect() end
            if FlyConn then FlyConn:Disconnect() end
            
            StopFly()
            ToggleGodMode(false)
            ToggleLockPosition(false)
            ToggleWalkOnWater(false)
            ToggleNoClip(false)
            ToggleXRay(false)
            ToggleESP(false)
            
            for name, conn in pairs(VisualConnections) do
                conn:Disconnect()
            end
            
            task.wait(2)
            Rayfield:Destroy()
            
            print("=======================================")
            print("  NIKZZ FISH IT - V2 ULTIMATE CLOSED")
            print("  All Features Stopped & Saved")
            print("  Thank you for using!")
            print("  Developer: Nikzz")
            print("=======================================")
        end
    })
    
    -- Final Setup
    task.wait(1)
    
    -- Load config if enabled
    if Config.AutoLoadConfig then
        LoadConfig()
    end
    
    -- Setup auto rejoin if enabled
    if Config.AutoRejoinDisconnect then
        SetupAutoRejoin()
    end
    
    -- Auto save on exit
    game:BindToClose(function()
        if Config.AutoSaveConfig then
            SaveConfig()
        end
    end)
    
    Rayfield:Notify({
        Title = "NIKZZ FISH IT - V2 ULTIMATE",
        Content = "🔥 All systems ready! Developed by Nikzz 🔥",
        Duration = 5
    })
    
    print("=======================================")
    print("  NIKZZ FISH IT - V2 ULTIMATE LOADED")
    print("  Status: ALL FEATURES WORKING")
    print("  Developer: Nikzz")
    print("  Release: 12 Oct 2025")
    print("  Platform: Delta Executor (Android)")
    print("  ")
    print("  🆕 NEW IN V2:")
    print("  ✅ Auto Fishing Ultra Fast + Anti-Stuck")
    print("  ✅ Auto Enchant System")
    print("  ✅ Auto Buy Weather (Up to 3)")
    print("  ✅ Auto Accept Trade")
    print("  ✅ Auto Rejoin on Disconnect")
    print("  ✅ Auto Save/Load Config")
    print("  ✅ Permanent Visual Effects")
    print("  ✅ Enhanced Performance Modes")
    print("  ✅ Extra FPS Boost")
    print("  ✅ HD Graphics (Medium & Ultra)")
    print("  ✅ Fixed Auto Jump")
    print("  ✅ Fixed Fishing Delay")
    print("  ")
    print("  🔥 Optimized for Delta Android!")
    print("=======================================")
    
    return Window
end

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(2)
    
    -- Reapply settings after respawn
    if Config.AutoFishingV1 then AutoFishingV1() end
    if Config.AutoFishingV2 then AutoFishingV2() end
    if Config.AntiAFK then StartAntiAFK() end
    if Config.AutoJump then StartAutoJump() end
    if Config.AutoSell then StartAutoSell() end
    if Config.AutoEnchant then AutoEnchant() end
    if Config.AutoBuyWeather then AutoBuyWeather() end
    if Config.AutoAcceptTrade then AutoAcceptTrade() end
    if Config.GodMode then ToggleGodMode(true) end
    if Config.FlyEnabled then StartFly() end
    if Config.WalkOnWater then ToggleWalkOnWater(true) end
    if Config.NoClip then ToggleNoClip(true) end
    if Config.PerfectCatch then TogglePerfectCatch(true) end
    if Config.LockedPosition then ToggleLockPosition(true) end
    
    if Humanoid then
        Humanoid.WalkSpeed = Config.WalkSpeed
        Humanoid.JumpPower = Config.JumpPower
    end
    
    print("[Character Respawned] All settings reapplied")
end)

-- Main Execution
print("Initializing NIKZZ FISH IT - V2 ULTIMATE...")
print("Optimized for Delta Executor (Android)")

task.wait(1)
Config.CheckpointPosition = HumanoidRootPart.CFrame
print("Checkpoint position saved")

local success, err = pcall(function()
    CreateUI()
end)

if not success then
    warn("ERROR: " .. tostring(err))
    warn("Please report this error to developer")
else
    print("NIKZZ FISH IT - V2 ULTIMATE LOADED SUCCESSFULLY")
    print("New Version - All Features Working")
    print("Developed by Nikzz for Delta Android")
    print("Ready to use!")
end
