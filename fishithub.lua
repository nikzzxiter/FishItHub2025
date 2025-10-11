-- NIKZZ FISH IT - NEW VERSION UPGRADED
-- DEVELOPER BY NIKZZ
-- Updated: 11 Oct 2025

print("Loading NIKZZ FISH IT - V1 UPGRADED...")

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

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Rayfield Setup
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "NIKZZ FISH IT - V1 UPGRADED",
    LoadingTitle = "NIKZZ FISH IT - NEW VERSION",
    LoadingSubtitle = "DEVELOPER BY NIKZZ",
    ConfigurationSaving = { Enabled = true, FileName = "NikzzFishConfig" },
})

-- Configuration
local Config = {
    AutoFishingV1 = false,
    AutoFishingV2 = false,
    FishingDelay = 0.5,
    PerfectCatch = false,
    AntiAFK = false,
    AutoJump = false,
    AutoJumpDelay = 5,
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
    AutoRejoinOnDisconnect = false,
    AutoSaveSettings = true,
    AutoLoadSettings = true
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
local ActivateEnchant = GetRemote("RE/ActivateEnchantingAltar")
local UpdateAutoFishing = GetRemote("RF/UpdateAutoFishingState")
local PurchaseWeather = GetRemote("RF/PurchaseWeatherEvent")
local AwaitTradeResponse = GetRemote("RF/AwaitTradeResponse")
local CanSendTrade = GetRemote("RF/CanSendTrade")

-- Anti-Stuck System
local LastFishingTime = tick()
local FishingStuckTimeout = 15

local function ResetCharacter()
    if HumanoidRootPart then
        local currentPos = HumanoidRootPart.CFrame
        Character:BreakJoints()
        repeat task.wait() until LocalPlayer.Character
        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        Humanoid = Character:WaitForChild("Humanoid")
        task.wait(0.5)
        HumanoidRootPart.CFrame = currentPos
    end
end

-- ===== AUTO FISHING V1 ULTRA FAST & STABLE =====
local function AutoFishingV1()
    task.spawn(function()
        print("[AutoFishingV1] Started - Ultra Fast Mode")
        while Config.AutoFishingV1 do
            local success = pcall(function()
                if not LocalPlayer.Character or not HumanoidRootPart then
                    repeat task.wait(0.5) until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    Character = LocalPlayer.Character
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                end

                -- Anti-Stuck Check
                if tick() - LastFishingTime > FishingStuckTimeout then
                    warn("[AutoFishingV1] Stuck detected! Resetting character...")
                    ResetCharacter()
                    LastFishingTime = tick()
                    return
                end

                -- Equip Rod
                EquipTool:FireServer(1)
                task.wait(0.1)

                -- Charge Rod (Perfect)
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

                -- Start Minigame (Perfect -1.2, 0.99)
                local miniSuccess = false
                for i = 1, 3 do
                    local ok = pcall(function()
                        StartMini:InvokeServer(-1.2, 0.99)
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

                -- Ultra Fast Delay
                task.wait(math.clamp(Config.FishingDelay, 0.1, 5))

                -- Finish Fishing
                FinishFish:FireServer()
                LastFishingTime = tick()

                -- Minimal delay untuk stabilitas
                task.wait(0.05)
            end)

            if not success then
                warn("[AutoFishingV1] Error detected, restarting...")
                task.wait(0.5)
            end
        end
        print("[AutoFishingV1] Stopped")
    end)
end

-- ===== AUTO FISHING V2 (USING GAME AUTO) =====
local function AutoFishingV2()
    task.spawn(function()
        print("[AutoFishingV2] Started - Using Game Auto System")
        
        -- Activate game's auto fishing
        pcall(function()
            UpdateAutoFishing:InvokeServer(true)
        end)
        
        while Config.AutoFishingV2 do
            pcall(function()
                -- Perfect charge override
                EquipTool:FireServer(1)
                task.wait(0.2)
                
                ChargeRod:InvokeServer(tick())
                StartMini:InvokeServer(-1.2, 0.99)
                task.wait(0.8)
                
                FinishFish:FireServer()
                task.wait(0.5)
            end)
        end
        
        -- Deactivate when stopped
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
        if PerfectCatchConn then PerfectCatchConn:Disconnect() end

        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "InvokeServer" and self == StartMini then
                if Config.PerfectCatch then
                    return old(self, -1.2, 0.99)
                end
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    else
        if PerfectCatchConn then
            PerfectCatchConn:Disconnect()
            PerfectCatchConn = nil
        end
    end
end

-- ===== AUTO ENCHANT =====
local function GetEnchantStones()
    local count = 0
    local stoneId = nil
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Enchant") and item.Name:find("Stone") then
                count = count + 1
                if item:FindFirstChild("ItemId") then
                    stoneId = item.ItemId.Value
                end
            end
        end
    end
    
    return count, stoneId
end

local function AutoEnchant()
    task.spawn(function()
        while Config.AutoEnchant do
            pcall(function()
                local stoneCount, stoneId = GetEnchantStones()
                
                if stoneCount > 0 and stoneId then
                    -- Activate enchanting altar without equipping
                    ActivateEnchant:FireServer()
                    task.wait(0.5)
                    
                    Rayfield:Notify({
                        Title = "Auto Enchant",
                        Content = "Enchanted! Stones left: " .. (stoneCount - 1),
                        Duration = 2
                    })
                    
                    task.wait(1)
                else
                    Rayfield:Notify({
                        Title = "Auto Enchant",
                        Content = "No enchant stones available!",
                        Duration = 3
                    })
                    Config.AutoEnchant = false
                    break
                end
            end)
            task.wait(2)
        end
    end)
end

-- ===== AUTO BUY WEATHER =====
local WeatherList = {"Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"}

local function AutoBuyWeather()
    task.spawn(function()
        while Config.AutoBuyWeather do
            for _, weather in pairs(Config.SelectedWeathers) do
                pcall(function()
                    PurchaseWeather:InvokeServer(weather)
                    Rayfield:Notify({
                        Title = "Auto Buy Weather",
                        Content = "Purchased: " .. weather,
                        Duration = 2
                    })
                end)
                task.wait(1)
            end
            task.wait(5)
        end
    end)
end

-- ===== AUTO ACCEPT TRADE =====
local function AutoAcceptTrade()
    if Config.AutoAcceptTrade then
        task.spawn(function()
            while Config.AutoAcceptTrade do
                pcall(function()
                    -- Auto accept trade requests
                    AwaitTradeResponse:InvokeServer(true)
                end)
                task.wait(0.1)
            end
        end)
    end
end

-- ===== AUTO REJOIN ON DISCONNECT =====
game:GetService("CoreGui").RobloxPromptGui.DescendantAdded:Connect(function(prompt)
    if Config.AutoRejoinOnDisconnect then
        if prompt.Name == "ErrorPrompt" or prompt.Name == "DisconnectPrompt" then
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end
end)

-- ===== AUTO JUMP FIXED =====
local function StartAutoJump()
    task.spawn(function()
        while Config.AutoJump do
            if Humanoid and Humanoid.Health > 0 and Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            task.wait(Config.AutoJumpDelay)
        end
    end)
end

-- ===== ANTI AFK =====
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

-- ===== AUTO SELL =====
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

-- ===== VISUAL FIXES (PERMANENT) =====
local VisualConnections = {}

local function ApplyFullbright()
    if VisualConnections.Fullbright then VisualConnections.Fullbright:Disconnect() end
    
    VisualConnections.Fullbright = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    end)
end

local function SetBrightness(value)
    if VisualConnections.Brightness then VisualConnections.Brightness:Disconnect() end
    
    VisualConnections.Brightness = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = value
    end)
end

local function SetTimeOfDay(value)
    if VisualConnections.TimeOfDay then VisualConnections.TimeOfDay:Disconnect() end
    
    VisualConnections.TimeOfDay = RunService.RenderStepped:Connect(function()
        Lighting.ClockTime = value
    end)
end

local function Enable8BitModeEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.Transparency = math.clamp(obj.Transparency, 0, 0.95)
        elseif obj:IsA("MeshPart") then
            obj.TextureID = ""
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("SpecialMesh") then
            obj.TextureId = ""
        end
    end
end

local function RemoveAllParticles()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
           obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj:Destroy()
        end
    end
end

local function RemoveSeaweedEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("seaweed") or name:find("kelp") or name:find("coral") or
           name:find("plant") or name:find("weed") then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function OptimizeWaterEnhanced()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Terrain") then
            obj.WaterReflectance = 0
            obj.WaterTransparency = 1
            obj.WaterWaveSize = 0
            obj.WaterWaveSpeed = 0
        elseif obj:IsA("Part") and obj.Material == Enum.Material.Water then
            obj.Reflectance = 0
            obj.Transparency = 0.9
        end
    end
end

local function PerformanceModeEnhanced()
    -- Remove fog
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    
    -- Disable shadows
    Lighting.GlobalShadows = false
    Lighting.EnvironmentSpecularScale = 0
    Lighting.EnvironmentDiffuseScale = 0
    
    -- Set lowest quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Remove all effects
    RemoveAllParticles()
    
    -- Optimize materials
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
end

-- ===== SAVED ISLANDS DATA =====
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

-- ===== TELEPORT SYSTEM =====
local function TeleportToPosition(pos)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(pos)
        return true
    end
    return false
end

-- ===== LOCK POSITION =====
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

-- ===== EVENT SCANNER =====
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

-- ===== GOD MODE =====
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

-- ===== FLY SYSTEM =====
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

-- ===== WALK ON WATER =====
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

-- ===== NOCLIP =====
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

-- ===== XRAY =====
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

-- ===== ESP DISTANCE =====
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

-- ===== INFINITE ZOOM =====
local function EnableInfiniteZoom()
    Config.InfiniteZoom = true
    LocalPlayer.CameraMaxZoomDistance = 9999
    LocalPlayer.CameraMinZoomDistance = 0.5
end

-- ===== TOGGLE RADAR =====
local function ToggleRadar(state)
    pcall(function()
        Radar:InvokeServer(state)
    end)
end

-- ===== TOGGLE DIVING GEAR =====
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

-- ===== SAVE & LOAD SETTINGS =====
local function SaveSettings()
    if Config.AutoSaveSettings then
        local settings = {
            AutoFishingV1 = Config.AutoFishingV1,
            AutoFishingV2 = Config.AutoFishingV2,
            FishingDelay = Config.FishingDelay,
            PerfectCatch = Config.PerfectCatch,
            AntiAFK = Config.AntiAFK,
            AutoJump = Config.AutoJump,
            AutoJumpDelay = Config.AutoJumpDelay,
            AutoSell = Config.AutoSell,
            GodMode = Config.GodMode,
            FlyEnabled = Config.FlyEnabled,
            FlySpeed = Config.FlySpeed,
            WalkSpeed = Config.WalkSpeed,
            JumpPower = Config.JumpPower,
            WalkOnWater = Config.WalkOnWater,
            NoClip = Config.NoClip,
            XRay = Config.XRay,
            ESPEnabled = Config.ESPEnabled,
            AutoEnchant = Config.AutoEnchant,
            AutoBuyWeather = Config.AutoBuyWeather,
            SelectedWeathers = Config.SelectedWeathers,
            AutoAcceptTrade = Config.AutoAcceptTrade,
            AutoRejoinOnDisconnect = Config.AutoRejoinOnDisconnect
        }
        
        writefile("NikzzFishSettings.json", game:GetService("HttpService"):JSONEncode(settings))
        print("[Config] Settings saved!")
    end
end

local function LoadSettings()
    if Config.AutoLoadSettings and isfile("NikzzFishSettings.json") then
        local success, settings = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("NikzzFishSettings.json"))
        end)
        
        if success and settings then
            for key, value in pairs(settings) do
                Config[key] = value
            end
            print("[Config] Settings loaded!")
            return true
        end
    end
    return false
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
        Name = "Auto Fishing V1 (Ultra Fast)",
        CurrentValue = Config.AutoFishingV1,
        Callback = function(Value)
            Config.AutoFishingV1 = Value
            if Value then
                Config.AutoFishingV2 = false
                AutoFishingV1()
                Rayfield:Notify({Title = "Auto Fishing V1", Content = "Ultra Fast Mode Started!", Duration = 3})
            end
            SaveSettings()
        end
    })
    
    Tab1:CreateToggle({
        Name = "Auto Fishing V2 (Game Auto)",
        CurrentValue = Config.AutoFishingV2,
        Callback = function(Value)
            Config.AutoFishingV2 = Value
            if Value then
                Config.AutoFishingV1 = false
                AutoFishingV2()
                Rayfield:Notify({Title = "Auto Fishing V2", Content = "Game Auto System Started!", Duration = 3})
            end
            SaveSettings()
        end
    })
    
    Tab1:CreateSlider({
        Name = "Fishing Delay (V1 Only)",
        Range = {0.1, 5},
        Increment = 0.1,
        CurrentValue = Config.FishingDelay,
        Callback = function(Value)
            Config.FishingDelay = Value
            SaveSettings()
        end
    })
    
    Tab1:CreateToggle({
        Name = "Anti AFK",
        CurrentValue = Config.AntiAFK,
        Callback = function(Value)
            Config.AntiAFK = Value
            if Value then StartAntiAFK() end
            SaveSettings()
        end
    })
    
    Tab1:CreateToggle({
        Name = "Auto Sell Fish",
        CurrentValue = Config.AutoSell,
        Callback = function(Value)
            Config.AutoSell = Value
            if Value then StartAutoSell() end
            SaveSettings()
        end
    })
    
    Tab1:CreateSection("Extra Fishing")
    
    Tab1:CreateToggle({
        Name = "Perfect Catch",
        CurrentValue = Config.PerfectCatch,
        Callback = function(Value)
            TogglePerfectCatch(Value)
            Rayfield:Notify({
                Title = "Perfect Catch",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab1:CreateToggle({
        Name = "Enable Radar",
        CurrentValue = false,
        Callback = function(Value)
            ToggleRadar(Value)
            Rayfield:Notify({
                Title = "Fishing Radar",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
        end
    })
    
    Tab1:CreateToggle({
        Name = "Enable Diving Gear",
        CurrentValue = false,
        Callback = function(Value)
            ToggleDivingGear(Value)
            Rayfield:Notify({
                Title = "Diving Gear",
                Content = Value and "Activated!" or "Deactivated!",
                Duration = 2
            })
        end
    })
    
    Tab1:CreateSection("Auto Enchant")
    
    Tab1:CreateToggle({
        Name = "Auto Enchant",
        CurrentValue = Config.AutoEnchant,
        Callback = function(Value)
            Config.AutoEnchant = Value
            if Value then 
                AutoEnchant()
                Rayfield:Notify({Title = "Auto Enchant", Content = "Started!", Duration = 2})
            end
            SaveSettings()
        end
    })
    
    Tab1:CreateSection("Settings")
    
    Tab1:CreateToggle({
        Name = "Auto Jump (Fixed)",
        CurrentValue = Config.AutoJump,
        Callback = function(Value)
            Config.AutoJump = Value
            if Value then StartAutoJump() end
            SaveSettings()
        end
    })
    
    Tab1:CreateSlider({
        Name = "Jump Delay",
        Range = {1, 10},
        Increment = 0.5,
        CurrentValue = Config.AutoJumpDelay,
        Callback = function(Value)
            Config.AutoJumpDelay = Value
            SaveSettings()
        end
    })
    
    -- ===== TELEPORT TAB =====
    local Tab2 = Window:CreateTab("📍 Teleport", 4483362458)
    
    Tab2:CreateSection("Islands")
    
    local IslandOptions = {}
    for i, island in ipairs(IslandsData) do
        table.insert(IslandOptions, string.format("%d. %s", i, island.Name))
    end
    
    local IslandDrop = Tab2:CreateDropdown({
        Name = "Select Island",
        Options = IslandOptions,
        CurrentOption = {IslandOptions[1]},
        Callback = function(Option) end
    })
    
    Tab2:CreateButton({
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
    
    Tab2:CreateToggle({
        Name = "Lock Position",
        CurrentValue = Config.LockedPosition,
        Callback = function(Value)
            ToggleLockPosition(Value)
            Rayfield:Notify({
                Title = "Lock Position",
                Content = Value and "Position Locked!" or "Position Unlocked!",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab2:CreateSection("Players")
    
    local PlayerDrop = Tab2:CreateDropdown({
        Name = "Select Player",
        Options = {"Load players first"},
        CurrentOption = {"Load players first"},
        Callback = function(Option) end
    })
    
    Tab2:CreateButton({
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
    
    Tab2:CreateButton({
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
    
    Tab2:CreateSection("Events")
    
    local EventDrop = Tab2:CreateDropdown({
        Name = "Select Event",
        Options = {"Load events first"},
        CurrentOption = {"Load events first"},
        Callback = function(Option) end
    })
    
    Tab2:CreateButton({
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
    
    Tab2:CreateButton({
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
    
    Tab2:CreateSection("Position Manager")
    
    Tab2:CreateButton({
        Name = "Save Current Position",
        Callback = function()
            Config.SavedPosition = HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Saved", Content = "Position saved", Duration = 2})
        end
    })
    
    Tab2:CreateButton({
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
    
    Tab2:CreateButton({
        Name = "Teleport to Checkpoint",
        Callback = function()
            if Config.CheckpointPosition then
                HumanoidRootPart.CFrame = Config.CheckpointPosition
                Rayfield:Notify({Title = "Teleported", Content = "Back to checkpoint", Duration = 2})
            end
        end
    })
    
    -- ===== UTILITY TAB =====
    local Tab3 = Window:CreateTab("⚡ Utility", 4483362458)
    
    Tab3:CreateSection("Speed Settings")
    
    Tab3:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 500},
        Increment = 1,
        CurrentValue = Config.WalkSpeed,
        Callback = function(Value)
            Config.WalkSpeed = Value
            if Humanoid then
                Humanoid.WalkSpeed = Value
            end
            SaveSettings()
        end
    })
    
    Tab3:CreateSlider({
        Name = "Jump Power",
        Range = {50, 500},
        Increment = 5,
        CurrentValue = Config.JumpPower,
        Callback = function(Value)
            Config.JumpPower = Value
            if Humanoid then
                Humanoid.JumpPower = Value
            end
            SaveSettings()
        end
    })
    
    Tab3:CreateInput({
        Name = "Custom Speed (Default: 16)",
        PlaceholderText = "Enter any speed value",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            local speed = tonumber(Text)
            if speed and speed >= 1 then
                if Humanoid then
                    Humanoid.WalkSpeed = speed
                    Config.WalkSpeed = speed
                    Rayfield:Notify({Title = "Speed Set", Content = "Speed: " .. speed, Duration = 2})
                    SaveSettings()
                end
            end
        end
    })
    
    Tab3:CreateSection("Extra Utility")
    
    Tab3:CreateToggle({
        Name = "Fly Mode",
        CurrentValue = Config.FlyEnabled,
        Callback = function(Value)
            Config.FlyEnabled = Value
            if Value then
                StartFly()
                Rayfield:Notify({Title = "Fly Enabled", Content = "Use WASD + Space/Shift", Duration = 3})
            else
                StopFly()
            end
            SaveSettings()
        end
    })
    
    Tab3:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 300},
        Increment = 5,
        CurrentValue = Config.FlySpeed,
        Callback = function(Value)
            Config.FlySpeed = Value
            SaveSettings()
        end
    })
    
    Tab3:CreateToggle({
        Name = "Walk on Water",
        CurrentValue = Config.WalkOnWater,
        Callback = function(Value)
            ToggleWalkOnWater(Value)
            Rayfield:Notify({
                Title = "Walk on Water",
                Content = Value and "Enabled" or "Disabled",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab3:CreateToggle({
        Name = "NoClip",
        CurrentValue = Config.NoClip,
        Callback = function(Value)
            ToggleNoClip(Value)
            Rayfield:Notify({
                Title = "NoClip",
                Content = Value and "Enabled" or "Disabled",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab3:CreateToggle({
        Name = "XRay (Transparent Walls)",
        CurrentValue = Config.XRay,
        Callback = function(Value)
            ToggleXRay(Value)
            Rayfield:Notify({
                Title = "XRay Mode",
                Content = Value and "Enabled" or "Disabled",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab3:CreateButton({
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
    
    Tab3:CreateButton({
        Name = "Reset Speed to Normal",
        Callback = function()
            if Humanoid then
                Humanoid.WalkSpeed = 16
                Humanoid.JumpPower = 50
                Config.WalkSpeed = 16
                Config.JumpPower = 50
                Rayfield:Notify({Title = "Speed Reset", Content = "Back to normal", Duration = 2})
                SaveSettings()
            end
        end
    })
    
    -- ===== UTILITY II TAB =====
    local Tab4 = Window:CreateTab("⚡ Utility II", 4483362458)
    
    Tab4:CreateSection("Protection")
    
    Tab4:CreateToggle({
        Name = "God Mode",
        CurrentValue = Config.GodMode,
        Callback = function(Value)
            ToggleGodMode(Value)
            if Value then
                Rayfield:Notify({Title = "God Mode", Content = "You are immortal", Duration = 3})
            else
                Rayfield:Notify({Title = "God Mode", Content = "Disabled", Duration = 2})
            end
            SaveSettings()
        end
    })
    
    Tab4:CreateButton({
        Name = "Full Health",
        Callback = function()
            if Humanoid then
                Humanoid.Health = Humanoid.MaxHealth
                Rayfield:Notify({Title = "Healed", Content = "Full health restored", Duration = 2})
            end
        end
    })
    
    Tab4:CreateButton({
        Name = "Remove All Damage",
        Callback = function()
            if Character then
                for _, obj in pairs(Character:GetDescendants()) do
                    if obj:IsA("Fire") or obj:IsA("Smoke") then
                        obj:Destroy()
                    end
                end
                Rayfield:Notify({Title = "Cleaned", Content = "All damage effects removed", Duration = 2})
            end
        end
    })
    
    Tab4:CreateSection("Player ESP")
    
    Tab4:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = Config.ESPEnabled,
        Callback = function(Value)
            ToggleESP(Value)
            Rayfield:Notify({
                Title = "ESP",
                Content = Value and "Enabled" or "Disabled",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    Tab4:CreateSlider({
        Name = "ESP Text Size",
        Range = {10, 50},
        Increment = 1,
        CurrentValue = Config.ESPDistance,
        Callback = function(Value)
            Config.ESPDistance = Value
            SaveSettings()
        end
    })
    
    Tab4:CreateButton({
        Name = "Highlight All Players",
        Callback = function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight", player.Character)
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                end
            end
            Rayfield:Notify({Title = "ESP Enabled", Content = "All players highlighted", Duration = 2})
        end
    })
    
    Tab4:CreateButton({
        Name = "Remove All Highlights",
        Callback = function()
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, obj in pairs(player.Character:GetChildren()) do
                        if obj:IsA("Highlight") then
                            obj:Destroy()
                        end
                    end
                end
            end
            Rayfield:Notify({Title = "ESP Disabled", Content = "Highlights removed", Duration = 2})
        end
    })
    
    Tab4:CreateSection("Trade System")
    
    Tab4:CreateToggle({
        Name = "Auto Accept Trade",
        CurrentValue = Config.AutoAcceptTrade,
        Callback = function(Value)
            Config.AutoAcceptTrade = Value
            if Value then
                AutoAcceptTrade()
                Rayfield:Notify({Title = "Auto Accept Trade", Content = "Enabled!", Duration = 2})
            end
            SaveSettings()
        end
    })
    
    -- ===== WEATHER TAB =====
    local Tab5 = Window:CreateTab("🌤️ Weather", 4483362458)
    
    Tab5:CreateSection("Auto Buy Weather")
    
    local SelectedWeatherList = {}
    
    local WeatherDrop = Tab5:CreateDropdown({
        Name = "Select Weather (Max 3)",
        Options = WeatherList,
        CurrentOption = {WeatherList[1]},
        Callback = function(Option) end
    })
    
    Tab5:CreateButton({
        Name = "Add Weather to List",
        Callback = function()
            if #SelectedWeatherList < 3 then
                local weather = WeatherDrop.CurrentOption[1]
                table.insert(SelectedWeatherList, weather)
                Config.SelectedWeathers = SelectedWeatherList
                Rayfield:Notify({
                    Title = "Weather Added",
                    Content = weather .. " added! Total: " .. #SelectedWeatherList,
                    Duration = 2
                })
                SaveSettings()
            else
                Rayfield:Notify({
                    Title = "Limit Reached",
                    Content = "Maximum 3 weathers allowed!",
                    Duration = 2
                })
            end
        end
    })
    
    Tab5:CreateButton({
        Name = "Clear Weather List",
        Callback = function()
            SelectedWeatherList = {}
            Config.SelectedWeathers = {}
            Rayfield:Notify({Title = "Cleared", Content = "Weather list cleared!", Duration = 2})
            SaveSettings()
        end
    })
    
    Tab5:CreateButton({
        Name = "Show Selected Weathers",
        Callback = function()
            if #SelectedWeatherList > 0 then
                local list = table.concat(SelectedWeatherList, ", ")
                Rayfield:Notify({
                    Title = "Selected Weathers",
                    Content = list,
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "No Weathers",
                    Content = "No weathers selected!",
                    Duration = 2
                })
            end
        end
    })
    
    Tab5:CreateToggle({
        Name = "Auto Buy Weather",
        CurrentValue = Config.AutoBuyWeather,
        Callback = function(Value)
            Config.AutoBuyWeather = Value
            if Value then
                if #SelectedWeatherList > 0 then
                    AutoBuyWeather()
                    Rayfield:Notify({Title = "Auto Buy Weather", Content = "Started!", Duration = 2})
                else
                    Config.AutoBuyWeather = false
                    Rayfield:Notify({Title = "Error", Content = "Please add weathers first!", Duration = 3})
                end
            end
            SaveSettings()
        end
    })
    
    Tab5:CreateSection("Manual Purchase")
    
    Tab5:CreateButton({
        Name = "Buy Selected Weather Now",
        Callback = function()
            if #SelectedWeatherList > 0 then
                for _, weather in pairs(SelectedWeatherList) do
                    pcall(function()
                        PurchaseWeather:InvokeServer(weather)
                        Rayfield:Notify({
                            Title = "Purchased",
                            Content = weather .. " purchased!",
                            Duration = 2
                        })
                    end)
                    task.wait(0.5)
                end
            else
                Rayfield:Notify({Title = "Error", Content = "No weathers selected!", Duration = 2})
            end
        end
    })
    
    -- ===== VISUALS TAB (FIXED) =====
    local Tab6 = Window:CreateTab("👁️ Visuals", 4483362458)
    
    Tab6:CreateSection("Lighting (Permanent)")
    
    Tab6:CreateButton({
        Name = "Fullbright (Permanent)",
        Callback = function()
            ApplyFullbright()
            Rayfield:Notify({Title = "Fullbright", Content = "Permanent fullbright enabled", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Remove Fog",
        Callback = function()
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("Atmosphere") then
                    effect.Density = 0
                end
            end
            Rayfield:Notify({Title = "Fog Removed", Content = "Fog disabled", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "8-Bit Mode (Enhanced 5x)",
        Callback = function()
            Enable8BitModeEnhanced()
            Rayfield:Notify({Title = "8-Bit Mode", Content = "Enhanced retro graphics enabled", Duration = 2})
        end
    })
    
    Tab6:CreateSlider({
        Name = "Brightness (Permanent)",
        Range = {0, 10},
        Increment = 0.5,
        CurrentValue = 2,
        Callback = function(Value)
            SetBrightness(Value)
        end
    })
    
    Tab6:CreateSlider({
        Name = "Time of Day (Permanent)",
        Range = {0, 24},
        Increment = 0.5,
        CurrentValue = 14,
        Callback = function(Value)
            SetTimeOfDay(Value)
        end
    })
    
    Tab6:CreateSection("Effects (Enhanced)")
    
    Tab6:CreateButton({
        Name = "Remove Particles (Enhanced)",
        Callback = function()
            RemoveAllParticles()
            Rayfield:Notify({Title = "Particles Removed", Content = "All effects disabled", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Remove Seaweed (Enhanced)",
        Callback = function()
            RemoveSeaweedEnhanced()
            Rayfield:Notify({Title = "Seaweed Removed", Content = "Water cleared completely", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Optimize Water (Enhanced)",
        Callback = function()
            OptimizeWaterEnhanced()
            Rayfield:Notify({Title = "Water Optimized", Content = "Water fully optimized", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Performance Mode (Enhanced)",
        Callback = function()
            PerformanceModeEnhanced()
            Rayfield:Notify({Title = "Performance Mode", Content = "Maximum FPS optimization applied", Duration = 3})
        end
    })
    
    Tab6:CreateButton({
        Name = "Reset Graphics",
        Callback = function()
            -- Stop all visual connections
            for _, conn in pairs(VisualConnections) do
                if conn then conn:Disconnect() end
            end
            VisualConnections = {}
            
            Lighting.Brightness = 2
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Rayfield:Notify({Title = "Graphics Reset", Content = "Back to normal", Duration = 2})
        end
    })
    
    Tab6:CreateSection("Camera")
    
    Tab6:CreateButton({
        Name = "Infinite Zoom",
        Callback = function()
            EnableInfiniteZoom()
            Rayfield:Notify({Title = "Infinite Zoom", Content = "Zoom limits removed", Duration = 2})
        end
    })
    
    Tab6:CreateButton({
        Name = "Remove Camera Shake",
        Callback = function()
            local cam = Workspace.CurrentCamera
            if cam then
                cam.FieldOfView = 70
            end
            Rayfield:Notify({Title = "Camera Fixed", Content = "Shake removed", Duration = 2})
        end
    })
    
    -- ===== MISC TAB =====
    local Tab7 = Window:CreateTab("🔧 Misc", 4483362458)
    
    Tab7:CreateSection("Character")
    
    Tab7:CreateButton({
        Name = "Reset Character",
        Callback = function()
            Character:BreakJoints()
            Rayfield:Notify({Title = "Resetting", Content = "Character respawning", Duration = 2})
        end
    })
    
    Tab7:CreateButton({
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
    
    Tab7:CreateButton({
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
    
    Tab7:CreateSection("Audio")
    
    Tab7:CreateButton({
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
    
    Tab7:CreateButton({
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
    
    Tab7:CreateSection("Server")
    
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
                LocalPlayer:GetNetworkPing() * 1000,
                workspace:GetRealPhysicsFPS(),
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
            Rayfield:Notify({Title = "Copied", Content = "Job ID copied to clipboard", Duration = 2})
        end
    })
    
    Tab7:CreateButton({
        Name = "Rejoin Server (Random)",
        Callback = function()
            Rayfield:Notify({Title = "Rejoining", Content = "Rejoining random server...", Duration = 2})
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    })
    
    Tab7:CreateToggle({
        Name = "Auto Rejoin on Disconnect",
        CurrentValue = Config.AutoRejoinOnDisconnect,
        Callback = function(Value)
            Config.AutoRejoinOnDisconnect = Value
            Rayfield:Notify({
                Title = "Auto Rejoin",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
            SaveSettings()
        end
    })
    
    -- ===== SETTINGS TAB =====
    local Tab8 = Window:CreateTab("⚙️ Settings", 4483362458)
    
    Tab8:CreateSection("Configuration")
    
    Tab8:CreateToggle({
        Name = "Auto Save Settings",
        CurrentValue = Config.AutoSaveSettings,
        Callback = function(Value)
            Config.AutoSaveSettings = Value
            Rayfield:Notify({
                Title = "Auto Save",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
        end
    })
    
    Tab8:CreateToggle({
        Name = "Auto Load Settings",
        CurrentValue = Config.AutoLoadSettings,
        Callback = function(Value)
            Config.AutoLoadSettings = Value
            Rayfield:Notify({
                Title = "Auto Load",
                Content = Value and "Enabled!" or "Disabled!",
                Duration = 2
            })
        end
    })
    
    Tab8:CreateButton({
        Name = "Save Settings Now",
        Callback = function()
            SaveSettings()
            Rayfield:Notify({Title = "Saved", Content = "All settings saved!", Duration = 2})
        end
    })
    
    Tab8:CreateButton({
        Name = "Load Settings Now",
        Callback = function()
            local loaded = LoadSettings()
            if loaded then
                Rayfield:Notify({Title = "Loaded", Content = "Settings loaded successfully!", Duration = 2})
            else
                Rayfield:Notify({Title = "Error", Content = "No saved settings found!", Duration = 2})
            end
        end
    })
    
    Tab8:CreateButton({
        Name = "Reset All Settings",
        Callback = function()
            if isfile("NikzzFishSettings.json") then
                delfile("NikzzFishSettings.json")
            end
            
            Config = {
                AutoFishingV1 = false,
                AutoFishingV2 = false,
                FishingDelay = 0.5,
                PerfectCatch = false,
                AntiAFK = false,
                AutoJump = false,
                AutoJumpDelay = 5,
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
                AutoRejoinOnDisconnect = false,
                AutoSaveSettings = true,
                AutoLoadSettings = true
            }
            
            Rayfield:Notify({Title = "Reset", Content = "All settings reset to default!", Duration = 2})
        end
    })
    
    Tab8:CreateSection("Script Control")
    
    Tab8:CreateButton({
        Name = "Show Active Features",
        Callback = function()
            local active = {}
            if Config.AutoFishingV1 then table.insert(active, "Auto Fish V1") end
            if Config.AutoFishingV2 then table.insert(active, "Auto Fish V2") end
            if Config.AntiAFK then table.insert(active, "Anti AFK") end
            if Config.AutoSell then table.insert(active, "Auto Sell") end
            if Config.GodMode then table.insert(active, "God Mode") end
            if Config.FlyEnabled then table.insert(active, "Fly Mode") end
            if Config.AutoEnchant then table.insert(active, "Auto Enchant") end
            if Config.AutoBuyWeather then table.insert(active, "Auto Buy Weather") end
            if Config.AutoAcceptTrade then table.insert(active, "Auto Accept Trade") end
            
            local message = #active > 0 and table.concat(active, ", ") or "No features active"
            
            Rayfield:Notify({
                Title = "Active Features",
                Content = message,
                Duration = 5
            })
        end
    })
    
    -- ===== INFO TAB =====
    local Tab9 = Window:CreateTab("ℹ️ Info", 4483362458)
    
    Tab9:CreateSection("Script Information")
    
    Tab9:CreateParagraph({
        Title = "NIKZZ FISH IT - V1 UPGRADED",
        Content = "New Version - Perfect Edition\nDeveloper: Nikzz\nRelease Date: 11 Oct 2025\nStatus: ALL FEATURES WORKING + UPGRADED"
    })
    
    Tab9:CreateSection("What's New in This Version")
    
    Tab9:CreateParagraph({
        Title = "🔧 FIXES",
        Content = "• Auto Fishing V1: Ultra fast, no stuck, anti-stuck system\n• Auto Fishing V2: Perfect charge with game auto\n• Auto Jump: Fixed, now works properly\n• Visual Effects: All permanent (Fullbright, Brightness, Time)\n• 8-Bit Mode: Enhanced 5x smoother\n• Particles/Seaweed/Water: Enhanced removal"
    })
    
    Tab9:CreateParagraph({
        Title = "✨ NEW FEATURES",
        Content = "• Auto Enchant: Automatic enchanting without equipping\n• Auto Buy Weather: Buy up to 3 weathers automatically\n• Auto Accept Trade: Instant trade acceptance\n• Auto Rejoin: Rejoin on disconnect\n• Auto Save/Load: Remember your settings\n• Rejoin Button: Manual rejoin to random server"
    })
    
    Tab9:CreateSection("Features Overview")
    
    Tab9:CreateParagraph({
        Title = "🎣 Fishing System",
        Content = "• Auto Fishing V1 & V2 (Ultra Fast)\n• Perfect Catch Mode\n• Auto Sell Fish\n• Auto Enchant (NEW)\n• Radar & Diving Gear\n• Adjustable Fishing Delay\n• Anti-Stuck System (NEW)"
    })
    
    Tab9:CreateParagraph({
        Title = "📍 Teleport System",
        Content = "• 21 Island Locations\n• Player Teleport\n• Event Detection\n• Position Lock Feature\n• Checkpoint System\n• Save/Load Position"
    })
    
    Tab9:CreateParagraph({
        Title = "⚡ Utility Features",
        Content = "• Custom Speed (Unlimited)\n• Fly Mode\n• Walk on Water\n• NoClip & XRay\n• Infinite Jump (NEW)\n• God Mode\n• Player ESP\n• Auto Accept Trade (NEW)"
    })
    
    Tab9:CreateParagraph({
        Title = "🌤️ Weather System (NEW)",
        Content = "• Auto Buy Weather\n• Select up to 3 weathers\n• Wind, Cloudy, Snow, Storm, Radiant, Shark Hunt\n• Manual purchase option\n• Auto-loop buying"
    })
    
    Tab9:CreateParagraph({
        Title = "👁️ Visual Features (FIXED)",
        Content = "• Permanent Fullbright\n• Permanent Brightness Control\n• Permanent Time of Day\n• Enhanced 8-Bit Mode (5x)\n• Enhanced Remove Particles\n• Enhanced Remove Seaweed\n• Enhanced Water Optimization\n• Enhanced Performance Mode"
    })
    
    Tab9:CreateParagraph({
        Title = "⚙️ Settings System (NEW)",
        Content = "• Auto Save Settings\n• Auto Load Settings\n• Manual Save/Load\n• Reset to Default\n• Active Features Display\n• Configuration Persistence"
    })
    
    Tab9:CreateSection("Usage Guide")
    
    Tab9:CreateParagraph({
        Title = "⚡ Quick Start Guide",
        Content = "1. Enable Auto Fishing V1 or V2\n2. Adjust Fishing Delay (V1 only)\n3. Select Island and Teleport\n4. Enable Auto Sell for automation\n5. Use Auto Enchant for rods\n6. Setup Auto Buy Weather\n7. Enable Auto Save to keep settings"
    })
    
    Tab9:CreateParagraph({
        Title = "⚠️ Important Notes",
        Content = "• Auto Fishing V1: Ultra fast with anti-stuck\n• Auto Fishing V2: Uses game's auto system\n• Fishing Delay: 0.1s = Ultra Fast\n• Auto Enchant: Works without equipping stones\n• Weather: Max 3 selections at once\n• Settings: Auto-saved when changed\n• Anti-Stuck: Auto respawns if stuck > 15s"
    })
    
    Tab9:CreateSection("Script Control")
    
    Tab9:CreateButton({
        Name = "Show Statistics",
        Callback = function()
            local stats = string.format(
                "=== NIKZZ STATISTICS ===\n" ..
                "Version: V1 UPGRADED\n" ..
                "Islands Available: %d\n" ..
                "Players Online: %d\n" ..
                "Auto Fishing V1: %s\n" ..
                "Auto Fishing V2: %s\n" ..
                "God Mode: %s\n" ..
                "Fly Mode: %s\n" ..
                "Walk Speed: %d\n" ..
                "Auto Enchant: %s\n" ..
                "Auto Buy Weather: %s\n" ..
                "Auto Accept Trade: %s\n" ..
                "=== END ===",
                #IslandsData,
                #Players:GetPlayers() - 1,
                Config.AutoFishingV1 and "ON" or "OFF",
                Config.AutoFishingV2 and "ON" or "OFF",
                Config.GodMode and "ON" or "OFF",
                Config.FlyEnabled and "ON" or "OFF",
                Config.WalkSpeed,
                Config.AutoEnchant and "ON" or "OFF",
                Config.AutoBuyWeather and "ON" or "OFF",
                Config.AutoAcceptTrade and "ON" or "OFF"
            )
            print(stats)
            Rayfield:Notify({Title = "Statistics", Content = "Check console (F9)", Duration = 3})
        end
    })
    
    Tab9:CreateButton({
        Name = "Close Script",
        Callback = function()
            Rayfield:Notify({Title = "Closing Script", Content = "Shutting down in 2 seconds...", Duration = 2})
            
            -- Save settings before closing
            SaveSettings()
            
            -- Stop all active features
            Config.AutoFishingV1 = false
            Config.AutoFishingV2 = false
            Config.AntiAFK = false
            Config.AutoJump = false
            Config.AutoSell = false
            Config.AutoEnchant = false
            Config.AutoBuyWeather = false
            Config.AutoAcceptTrade = false
            
            if GodConnection then GodConnection:Disconnect() end
            if PerfectCatchConn then PerfectCatchConn:Disconnect() end
            if LockConn then LockConn:Disconnect() end
            if WaterConn then WaterConn:Disconnect() end
            if NoClipConn then NoClipConn:Disconnect() end
            if FlyConn then FlyConn:Disconnect() end
            
            for _, conn in pairs(VisualConnections) do
                if conn then conn:Disconnect() end
            end
            
            StopFly()
            ToggleGodMode(false)
            ToggleLockPosition(false)
            ToggleWalkOnWater(false)
            ToggleNoClip(false)
            ToggleXRay(false)
            ToggleESP(false)
            
            task.wait(2)
            Rayfield:Destroy()
            
            print("=======================================")
            print("  NIKZZ FISH IT - V1 UPGRADED CLOSED")
            print("  All Features Stopped & Settings Saved")
            print("  Thank you for using!")
            print("=======================================")
        end
    })
    
    -- Load saved settings on startup
    task.wait(1)
    if LoadSettings() then
        Rayfield:Notify({
            Title = "Settings Loaded",
            Content = "Previous settings restored!",
            Duration = 3
        })
        
        -- Reapply loaded settings
        if Config.AutoFishingV1 then AutoFishingV1() end
        if Config.AutoFishingV2 then AutoFishingV2() end
        if Config.AntiAFK then StartAntiAFK() end
        if Config.AutoJump then StartAutoJump() end
        if Config.AutoSell then StartAutoSell() end
        if Config.GodMode then ToggleGodMode(true) end
        if Config.FlyEnabled then StartFly() end
        if Config.WalkOnWater then ToggleWalkOnWater(true) end
        if Config.NoClip then ToggleNoClip(true) end
        if Config.PerfectCatch then TogglePerfectCatch(true) end
        if Config.LockedPosition then ToggleLockPosition(true) end
        if Config.AutoEnchant then AutoEnchant() end
        if Config.AutoBuyWeather then AutoBuyWeather() end
        if Config.AutoAcceptTrade then AutoAcceptTrade() end
        if Config.XRay then ToggleXRay(true) end
        if Config.ESPEnabled then ToggleESP(true) end
        
        if Humanoid then
            Humanoid.WalkSpeed = Config.WalkSpeed
            Humanoid.JumpPower = Config.JumpPower
        end
    end
    
    -- Final Notification
    Rayfield:Notify({
        Title = "NIKZZ FISH IT - V1 UPGRADED",
        Content = "All systems ready - Developed by Nikzz",
        Duration = 5
    })
    
    print("=======================================")
    print("  NIKZZ FISH IT - V1 UPGRADED LOADED")
    print("  Status: ALL FEATURES WORKING")
    print("  Developer: Nikzz")
    print("  Release: 11 Oct 2025")
    print("  New Features: Auto Enchant, Weather, Trade")
    print("  Fixes: Ultra Fast Fishing, Visual Permanent")
    print("=======================================")
    
    return Window
end

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(2)
    
    -- Reapply settings
    if Config.AutoFishingV1 then AutoFishingV1() end
    if Config.AutoFishingV2 then AutoFishingV2() end
    if Config.AntiAFK then StartAntiAFK() end
    if Config.AutoJump then StartAutoJump() end
    if Config.AutoSell then StartAutoSell() end
    if Config.GodMode then ToggleGodMode(true) end
    if Config.FlyEnabled then StartFly() end
    if Config.WalkOnWater then ToggleWalkOnWater(true) end
    if Config.NoClip then ToggleNoClip(true) end
    if Config.PerfectCatch then TogglePerfectCatch(true) end
    if Config.LockedPosition then ToggleLockPosition(true) end
    if Config.AutoEnchant then AutoEnchant() end
    if Config.AutoBuyWeather then AutoBuyWeather() end
    if Config.AutoAcceptTrade then AutoAcceptTrade() end
    if Config.XRay then ToggleXRay(true) end
    if Config.ESPEnabled then ToggleESP(true) end
    
    if Humanoid then
        Humanoid.WalkSpeed = Config.WalkSpeed
        Humanoid.JumpPower = Config.JumpPower
    end
    
    Rayfield:Notify({
        Title = "Character Respawned",
        Content = "All features reapplied!",
        Duration = 2
    })
end)

-- Main Execution
print("Initializing NIKZZ FISH IT - V1 UPGRADED...")

task.wait(1)
Config.CheckpointPosition = HumanoidRootPart.CFrame
print("Checkpoint position saved")

local success, err = pcall(function()
    CreateUI()
end)

if not success then
    warn("ERROR: " .. tostring(err))
else
    print("NIKZZ FISH IT - V1 UPGRADED LOADED SUCCESSFULLY")
    print("New Version - All Features Working + Enhanced")
    print("Developer by Nikzz")
    print("Ready to use!")
end
