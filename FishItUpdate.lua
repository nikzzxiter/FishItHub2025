-- Fish It Hub 2025 by Nikzz Xit
-- Rayfield Interface Suite Implementation
-- Untuk game Fish It September 2025

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

-- Player
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game Variables
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- Configuration
local Settings = {
    AutoFish = false,
    AutoCast = false,
    AutoCatch = false,
    AutoPerfectCatch = false,
    AutoSell = false,
    AutoBaitSelect = false,
    FishingDelay = 1,
    AutoRepairRod = false,
    AutoCollectChests = false,
    AutoUpgradeRod = false,
    AutoRepairBoat = false,
    InfiniteOxygen = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    Fly = false,
    ESPFish = false,
    ESPPlayers = false,
    ESPChests = false,
    AutoBuyBait = false,
    AutoEquipRod = false,
    AutoCollectDailyReward = false,
    AutoRankClaim = false,
    AutoUpgradeBackpack = false,
    AutoBuyRod = false,
    AutoEquipBestRod = false,
    AutoEquipBestBait = false,
    AntiAFK = false,
    LowGraphicsMode = false,
    FPSUnlocker = false,
    AccentColor = Color3.fromRGB(0, 170, 255),
    SavedLocations = {},
    TeleportRoute = {},
    TeleportRouteIndex = 1,
    TeleportRouteLoop = false,
    ChestSpotsLoop = false,
    ChestSpotsIndex = 1
}

-- Game Specific Variables
local FishingModule
local PlayerData
local RodDurability = 100
local CurrentRod
local CurrentBait
local FishESP = {}
local PlayerESP = {}
local ChestESP = {}
local ChestSpots = {}
local FishingSpots = {}
local Boat
local Market
local UpgradeShop
local SpawnLocation

-- Utility Functions
function GetPlayerData()
    local success, result = pcall(function()
        return Player:FindFirstChild("PlayerData") and require(Player.PlayerData) or nil
    end)
    return success and result or nil
end

function GetFishingModule()
    local success, result = pcall(function()
        return require(Modules:WaitForChild("FishingModule"))
    end)
    return success and result or nil
end

function GetRodDurability()
    if PlayerData then
        local rods = PlayerData.getRods()
        if rods and CurrentRod and rods[CurrentRod] then
            return rods[CurrentRod].durability or 100
        end
    end
    return 100
end

function GetBestRod()
    if PlayerData then
        local rods = PlayerData.getRods()
        local bestRod = nil
        local bestValue = 0
        
        for rodName, rodData in pairs(rods) do
            if rodData.level > bestValue then
                bestValue = rodData.level
                bestRod = rodName
            end
        end
        
        return bestRod
    end
    return nil
end

function GetBestBait()
    if PlayerData then
        local baits = PlayerData.getBaits()
        local bestBait = nil
        local bestValue = 0
        
        for baitName, baitData in pairs(baits) do
            if baitData.attraction > bestValue then
                bestValue = baitData.attraction
                bestBait = baitName
            end
        end
        
        return bestBait
    end
    return nil
end

function CastLine()
    local args = {
        [1] = Workspace:FindFirstChild("Ocean") or Workspace
    }
    Remotes.CastLine:FireServer(unpack(args))
end

function CatchFish()
    Remotes.CatchFish:FireServer()
end

function SellFish()
    Events.SellFish:FireServer()
end

function RepairRod()
    if CurrentRod then
        Events.RepairRod:FireServer(CurrentRod)
    end
end

function BuyBait(baitName, amount)
    Events.BuyBait:FireServer(baitName, amount)
end

function EquipRod(rodName)
    Events.EquipRod:FireServer(rodName)
    CurrentRod = rodName
end

function EquipBait(baitName)
    Events.EquipBait:FireServer(baitName)
    CurrentBait = baitName
end

function UpgradeRod(rodName)
    Events.UpgradeRod:FireServer(rodName)
end

function RepairBoat()
    Events.RepairBoat:FireServer()
end

function CollectDailyReward()
    Events.CollectDailyReward:FireServer()
end

function ClaimRankReward(rank)
    Events.ClaimRankReward:FireServer(rank)
end

function UpgradeBackpack()
    Events.UpgradeBackpack:FireServer()
end

function BuyRod(rodName)
    Events.BuyRod:FireServer(rodName)
end

function CollectChest(chest)
    Events.CollectChest:FireServer(chest)
end

-- Teleport Functions
function TeleportTo(position)
    if typeof(position) == "Vector3" then
        HumanoidRootPart.CFrame = CFrame.new(position)
    elseif position:IsA("BasePart") then
        HumanoidRootPart.CFrame = position.CFrame
    end
end

function FindLocation(name)
    local locations = {
        Spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn"),
        Market = Workspace:FindFirstChild("Market") or Workspace:FindFirstChild("Shop"),
        UpgradeShop = Workspace:FindFirstChild("UpgradeShop") or Workspace:FindFirstChild("Upgrade"),
        Boat = Workspace:FindFirstChild("Boat") or Workspace:FindFirstChild("PlayerBoat")
    }
    
    for spotName, spot in pairs(Workspace:GetChildren()) do
        if string.find(spotName:lower(), "fishing") and spot:IsA("Part") then
            table.insert(FishingSpots, spot)
        end
        
        if string.find(spotName:lower(), "chest") and spot:IsA("Part") then
            table.insert(ChestSpots, spot)
        end
    end
    
    return locations[name] or nil
end

-- ESP Functions
function CreateESP(object, color, name)
    if object:FindFirstChild("ESP") then
        object.ESP:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = object
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Adornee = object
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = object
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = color
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    return highlight
end

function RemoveESP(object)
    if object:FindFirstChild("ESP") then
        object.ESP:Destroy()
    end
    if object:FindFirstChild("ESPLabel") then
        object.ESPLabel:Destroy()
    end
end

function UpdateFishESP()
    for _, fish in pairs(Workspace:GetChildren()) do
        if string.find(fish.Name:lower(), "fish") and fish:IsA("Model") and fish:FindFirstChild("Head") then
            if Settings.ESPFish and not FishESP[fish] then
                FishESP[fish] = CreateESP(fish.Head, Color3.fromRGB(0, 255, 0), fish.Name)
            elseif not Settings.ESPFish and FishESP[fish] then
                RemoveESP(fish.Head)
                FishESP[fish] = nil
            end
        end
    end
end

function UpdatePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("Head") then
            if Settings.ESPPlayers and not PlayerESP[player] then
                PlayerESP[player] = CreateESP(player.Character.Head, Color3.fromRGB(255, 0, 0), player.Name)
            elseif not Settings.ESPPlayers and PlayerESP[player] then
                RemoveESP(player.Character.Head)
                PlayerESP[player] = nil
            end
        end
    end
end

function UpdateChestESP()
    for _, chest in pairs(Workspace:GetChildren()) do
        if string.find(chest.Name:lower(), "chest") and chest:IsA("Model") and chest:FindFirstChild("Chest") then
            if Settings.ESPChests and not ChestESP[chest] then
                ChestESP[chest] = CreateESP(chest.Chest, Color3.fromRGB(255, 215, 0), chest.Name)
            elseif not Settings.ESPChests and ChestESP[chest] then
                RemoveESP(chest.Chest)
                ChestESP[chest] = nil
            end
        end
    end
end

-- Auto Functions
function AutoFish()
    while Settings.AutoFish do
        if Settings.AutoCast then
            CastLine()
        end
        
        if Settings.AutoCatch then
            wait(Settings.FishingDelay)
            CatchFish()
        end
        
        if Settings.AutoSell then
            SellFish()
        end
        
        if Settings.AutoRepairRod and RodDurability < 20 then
            RepairRod()
        end
        
        wait(Settings.FishingDelay)
    end
end

function AutoCollectChests()
    while Settings.AutoCollectChests do
        for _, chest in pairs(Workspace:GetChildren()) do
            if string.find(chest.Name:lower(), "chest") and chest:IsA("Model") then
                TeleportTo(chest:GetPivot().Position)
                CollectChest(chest)
                wait(0.5)
            end
        end
        wait(5)
    end
end

function AutoUpgradeRod()
    while Settings.AutoUpgradeRod do
        if CurrentRod then
            UpgradeRod(CurrentRod)
        end
        wait(1)
    end
end

function AutoRepairBoatFunc()
    while Settings.AutoRepairBoat do
        RepairBoat()
        wait(30)
    end
end

function AutoBuyBaitFunc()
    while Settings.AutoBuyBait do
        local bestBait = GetBestBait()
        if bestBait then
            BuyBait(bestBait, 10)
        end
        wait(10)
    end
end

function AutoEquipBestRodFunc()
    while Settings.AutoEquipBestRod do
        local bestRod = GetBestRod()
        if bestRod and bestRod ~= CurrentRod then
            EquipRod(bestRod)
        end
        wait(5)
    end
end

function AutoEquipBestBaitFunc()
    while Settings.AutoEquipBestBait do
        local bestBait = GetBestBait()
        if bestBait and bestBait ~= CurrentBait then
            EquipBait(bestBait)
        end
        wait(5)
    end
end

function AutoCollectDailyRewardFunc()
    while Settings.AutoCollectDailyReward do
        CollectDailyReward()
        wait(86400) -- 24 hours
    end
end

function AutoRankClaimFunc()
    while Settings.AutoRankClaim do
        if PlayerData then
            local ranks = PlayerData.getUnclaimedRanks()
            for rank, _ in pairs(ranks) do
                ClaimRankReward(rank)
            end
        end
        wait(60)
    end
end

function AutoUpgradeBackpackFunc()
    while Settings.AutoUpgradeBackpack do
        UpgradeBackpack()
        wait(10)
    end
end

function AutoBuyRodFunc()
    while Settings.AutoBuyRod do
        if PlayerData then
            local availableRods = PlayerData.getAvailableRods()
            for rodName, _ in pairs(availableRods) do
                BuyRod(rodName)
            end
        end
        wait(30)
    end
end

-- Noclip Function
function NoclipLoop()
    if Settings.Noclip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Fly Function
function Fly()
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.Parent = HumanoidRootPart
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = HumanoidRootPart.CFrame
    
    bodyVelocity.Parent = HumanoidRootPart
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    while Settings.Fly do
        if not Settings.Fly then break end
        
        local camera = Workspace.CurrentCamera
        local direction = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * 50
            bodyVelocity.velocity = direction
        else
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
        
        bodyGyro.cframe = camera.CFrame
        RunService.RenderStepped:Wait()
    end
    
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
end

-- Anti AFK
function AntiAFK()
    local virtualUser = game:GetService("VirtualUser")
    Player.Idled:connect(function()
        if Settings.AntiAFK then
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- Low Graphics Mode
function LowGraphicsMode()
    if Settings.LowGraphicsMode then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and not obj.Parent:FindFirstChild("Humanoid") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") then
                obj.Texture = ""
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
    end
end

-- FPS Unlocker
function FPSUnlocker()
    if Settings.FPSUnlocker then
        setfpscap(999)
    else
        setfpscap(60)
    end
end

-- Initialize Game Variables
spawn(function()
    while true do
        FishingModule = GetFishingModule()
        PlayerData = GetPlayerData()
        RodDurability = GetRodDurability()
        wait(1)
    end
end)

-- Find important locations
spawn(function()
    while true do
        SpawnLocation = FindLocation("Spawn")
        Market = FindLocation("Market")
        UpgradeShop = FindLocation("UpgradeShop")
        Boat = FindLocation("Boat")
        wait(5)
    end
end)

-- Initialize Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Hub 2025 | Nikzz Xit",
    LoadingTitle = "Fish It Hub 2025",
    LoadingSubtitle = "by Nikzz Xit",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishItHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "sirius",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Main Tabs
local FishingTab = Window:CreateTab("🎣 Fishing", 4483362458)
local ToolsTab = Window:CreateTab("🛠 Tools", 4483362458)
local TeleportTab = Window:CreateTab("🚀 Teleport", 4483362458)
local ExtraTab = Window:CreateTab("💎 Extra", 4483362458)
local SettingsTab = Window:CreateTab("⚙ Settings", 4483362458)

-- Fishing Section
local AutoFishingSection = FishingTab:CreateSection("Auto Fishing")
local FishingControlsSection = FishingTab:CreateSection("Fishing Controls")
local FishingStatsSection = FishingTab:CreateSection("Fishing Stats")

-- Auto Fishing Toggles
local AutoFishToggle = FishingTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(Value)
        Settings.AutoFish = Value
        if Value then
            spawn(AutoFish)
        end
    end,
})

local AutoCastToggle = FishingTab:CreateToggle({
    Name = "Auto Cast",
    CurrentValue = false,
    Flag = "AutoCast",
    Callback = function(Value)
        Settings.AutoCast = Value
    end,
})

local AutoCatchToggle = FishingTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Flag = "AutoCatch",
    Callback = function(Value)
        Settings.AutoCatch = Value
    end,
})

local AutoPerfectCatchToggle = FishingTab:CreateToggle({
    Name = "Auto Perfect Catch",
    CurrentValue = false,
    Flag = "AutoPerfectCatch",
    Callback = function(Value)
        Settings.AutoPerfectCatch = Value
    end,
})

local AutoSellToggle = FishingTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(Value)
        Settings.AutoSell = Value
    end,
})

local AutoBaitSelectToggle = FishingTab:CreateToggle({
    Name = "Auto Bait Select",
    CurrentValue = false,
    Flag = "AutoBaitSelect",
    Callback = function(Value)
        Settings.AutoBaitSelect = Value
    end,
})

-- Fishing Controls
local CastButton = FishingTab:CreateButton({
    Name = "Manual Cast",
    Callback = function()
        CastLine()
    end,
})

local SellButton = FishingTab:CreateButton({
    Name = "Manual Sell",
    Callback = function()
        SellFish()
    end,
})

local FishingDelaySlider = FishingTab:CreateSlider({
    Name = "Fishing Delay",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 1,
    Flag = "FishingDelay",
    Callback = function(Value)
        Settings.FishingDelay = Value
    end,
})

-- Fishing Stats
local DurabilityLabel = FishingTab:CreateLabel("Rod Durability: 100%")
local CurrentRodLabel = FishingTab:CreateLabel("Current Rod: None")
local CurrentBaitLabel = FishingTab:CreateLabel("Current Bait: None")

spawn(function()
    while true do
        DurabilityLabel:Set("Rod Durability: " .. tostring(RodDurability) .. "%")
        CurrentRodLabel:Set("Current Rod: " .. tostring(CurrentRod or "None"))
        CurrentBaitLabel:Set("Current Bait: " .. tostring(CurrentBait or "None"))
        wait(1)
    end
end)

-- Tools Section
local AutoToolsSection = ToolsTab:CreateSection("Auto Tools")
local MovementSection = ToolsTab:CreateSection("Movement")
local ESPSection = ToolsTab:CreateSection("ESP")

-- Auto Tools
local AutoCollectChestsToggle = ToolsTab:CreateToggle({
    Name = "Auto Collect Chests",
    CurrentValue = false,
    Flag = "AutoCollectChests",
    Callback = function(Value)
        Settings.AutoCollectChests = Value
        if Value then
            spawn(AutoCollectChests)
        end
    end,
})

local AutoUpgradeRodToggle = ToolsTab:CreateToggle({
    Name = "Auto Upgrade Rod",
    CurrentValue = false,
    Flag = "AutoUpgradeRod",
    Callback = function(Value)
        Settings.AutoUpgradeRod = Value
        if Value then
            spawn(AutoUpgradeRod)
        end
    end,
})

local AutoRepairBoatToggle = ToolsTab:CreateToggle({
    Name = "Auto Repair Boat",
    CurrentValue = false,
    Flag = "AutoRepairBoat",
    Callback = function(Value)
        Settings.AutoRepairBoat = Value
        if Value then
            spawn(AutoRepairBoatFunc)
        end
    end,
})

local InfiniteOxygenToggle = ToolsTab:CreateToggle({
    Name = "Infinite Oxygen",
    CurrentValue = false,
    Flag = "InfiniteOxygen",
    Callback = function(Value)
        Settings.InfiniteOxygen = Value
        if Value and Character:FindFirstChild("Oxygen") then
            Character.Oxygen:Destroy()
        end
    end,
})

local AutoBuyBaitToggle = ToolsTab:CreateToggle({
    Name = "Auto Buy Bait",
    CurrentValue = false,
    Flag = "AutoBuyBait",
    Callback = function(Value)
        Settings.AutoBuyBait = Value
        if Value then
            spawn(AutoBuyBaitFunc)
        end
    end,
})

local AutoEquipRodToggle = ToolsTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = false,
    Flag = "AutoEquipRod",
    Callback = function(Value)
        Settings.AutoEquipRod = Value
    end,
})

-- Movement
local WalkSpeedSlider = ToolsTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Settings.WalkSpeed = Value
        Humanoid.WalkSpeed = Value
    end,
})

local JumpPowerSlider = ToolsTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Settings.JumpPower = Value
        Humanoid.JumpPower = Value
    end,
})

local NoclipToggle = ToolsTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        Settings.Noclip = Value
        if Value then
            spawn(function()
                while Settings.Noclip do
                    NoclipLoop()
                    wait(0.1)
                end
            end)
        end
    end,
})

local FlyToggle = ToolsTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        Settings.Fly = Value
        if Value then
            spawn(Fly)
        end
    end,
})

-- ESP
local ESPFishToggle = ToolsTab:CreateToggle({
    Name = "ESP Fish",
    CurrentValue = false,
    Flag = "ESPFish",
    Callback = function(Value)
        Settings.ESPFish = Value
        if not Value then
            for fish, esp in pairs(FishESP) do
                RemoveESP(fish.Head)
            end
            FishESP = {}
        end
    end,
})

local ESPPlayersToggle = ToolsTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "ESPPlayers",
    Callback = function(Value)
        Settings.ESPPlayers = Value
        if not Value then
            for player, esp in pairs(PlayerESP) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    RemoveESP(player.Character.Head)
                end
            end
            PlayerESP = {}
        end
    end,
})

local ESPChestsToggle = ToolsTab:CreateToggle({
    Name = "ESP Chests",
    CurrentValue = false,
    Flag = "ESPChests",
    Callback = function(Value)
        Settings.ESPChests = Value
        if not Value then
            for chest, esp in pairs(ChestESP) do
                if chest:FindFirstChild("Chest") then
                    RemoveESP(chest.Chest)
                end
            end
            ChestESP = {}
        end
    end,
})

-- ESP Update Loop
spawn(function()
    while true do
        if Settings.ESPFish then
            UpdateFishESP()
        end
        if Settings.ESPPlayers then
            UpdatePlayerESP()
        end
        if Settings.ESPChests then
            UpdateChestESP()
        end
        wait(1)
    end
end)

-- Teleport Section
local LocationsSection = TeleportTab:CreateSection("Locations")
local CustomLocationSection = TeleportTab:CreateSection("Custom Locations")
local AutoTeleportSection = TeleportTab:CreateSection("Auto Teleport")

-- Locations
TeleportTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        if SpawnLocation then
            TeleportTo(SpawnLocation.Position)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Market",
    Callback = function()
        if Market then
            TeleportTo(Market.Position)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Upgrade Shop",
    Callback = function()
        if UpgradeShop then
            TeleportTo(UpgradeShop.Position)
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Boat",
    Callback = function()
        if Boat then
            TeleportTo(Boat.Position)
        end
    end,
})

-- Fishing Spots
local FishingSpotDropdown = TeleportTab:CreateDropdown({
    Name = "Fishing Spots",
    Options = {"Loading..."},
    CurrentOption = "Select Spot",
    Flag = "FishingSpot",
    Callback = function(Option)
        for _, spot in pairs(FishingSpots) do
            if spot.Name == Option then
                TeleportTo(spot.Position)
                break
            end
        end
    end,
})

spawn(function()
    while true do
        local options = {}
        for _, spot in pairs(FishingSpots) do
            table.insert(options, spot.Name)
        end
        if #options > 0 then
            FishingSpotDropdown:Refresh(options, true)
        else
            FishingSpotDropdown:Refresh({"No spots found"}, true)
        end
        wait(5)
    end
end)

-- Custom Locations
local SaveLocationButton = TeleportTab:CreateButton({
    Name = "Save Current Location",
    Callback = function()
        local locationName = "Location " .. #Settings.SavedLocations + 1
        table.insert(Settings.SavedLocations, {
            Name = locationName,
            Position = HumanoidRootPart.Position
        })
        Rayfield:Notify({
            Title = "Location Saved",
            Content = "Saved as " .. locationName,
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local CustomLocationDropdown = TeleportTab:CreateDropdown({
    Name = "Custom Locations",
    Options = {"No locations saved"},
    CurrentOption = "Select Location",
    Flag = "CustomLocation",
    Callback = function(Option)
        for _, loc in pairs(Settings.SavedLocations) do
            if loc.Name == Option then
                TeleportTo(loc.Position)
                break
            end
        end
    end,
})

spawn(function()
    while true do
        local options = {}
        for _, loc in pairs(Settings.SavedLocations) do
            table.insert(options, loc.Name)
        end
        if #options > 0 then
            CustomLocationDropdown:Refresh(options, true)
        else
            CustomLocationDropdown:Refresh({"No locations saved"}, true)
        end
        wait(1)
    end
end)

-- Auto Teleport
local TeleportRouteToggle = TeleportTab:CreateToggle({
    Name = "Auto Farm Teleport Route",
    CurrentValue = false,
    Flag = "TeleportRoute",
    Callback = function(Value)
        if Value and #Settings.TeleportRoute > 0 then
            spawn(function()
                while Settings.TeleportRouteLoop do
                    local location = Settings.TeleportRoute[Settings.TeleportRouteIndex]
                    TeleportTo(location.Position)
                    
                    Settings.TeleportRouteIndex = Settings.TeleportRouteIndex + 1
                    if Settings.TeleportRouteIndex > #Settings.TeleportRoute then
                        Settings.TeleportRouteIndex = 1
                    end
                    
                    wait(5)
                end
            end)
        else
            Settings.TeleportRouteLoop = false
        end
    end,
})

local AddToRouteButton = TeleportTab:CreateButton({
    Name = "Add Current to Route",
    Callback = function()
        table.insert(Settings.TeleportRoute, {
            Name = "Point " .. #Settings.TeleportRoute + 1,
            Position = HumanoidRootPart.Position
        })
        Rayfield:Notify({
            Title = "Added to Route",
            Content = "Point " .. #Settings.TeleportRoute .. " added",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local ClearRouteButton = TeleportTab:CreateButton({
    Name = "Clear Route",
    Callback = function()
        Settings.TeleportRoute = {}
        Settings.TeleportRouteIndex = 1
        Rayfield:Notify({
            Title = "Route Cleared",
            Content = "All points removed",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local ChestSpotsToggle = TeleportTab:CreateToggle({
    Name = "Loop Teleport Chest Spots",
    CurrentValue = false,
    Flag = "ChestSpotsLoop",
    Callback = function(Value)
        Settings.ChestSpotsLoop = Value
        if Value and #ChestSpots > 0 then
            spawn(function()
                while Settings.ChestSpotsLoop do
                    local spot = ChestSpots[Settings.ChestSpotsIndex]
                    TeleportTo(spot.Position)
                    
                    Settings.ChestSpotsIndex = Settings.ChestSpotsIndex + 1
                    if Settings.ChestSpotsIndex > #ChestSpots then
                        Settings.ChestSpotsIndex = 1
                    end
                    
                    wait(5)
                end
            end)
        end
    end,
})

-- Extra Section
local AutoFeaturesSection = ExtraTab:CreateSection("Auto Features")
local PlayerInfoSection = ExtraTab:CreateSection("Player Info")

-- Auto Features
local AutoCollectDailyRewardToggle = ExtraTab:CreateToggle({
    Name = "Auto Collect Daily Reward",
    CurrentValue = false,
    Flag = "AutoCollectDailyReward",
    Callback = function(Value)
        Settings.AutoCollectDailyReward = Value
        if Value then
            spawn(AutoCollectDailyRewardFunc)
        end
    end,
})

local AutoRankClaimToggle = ExtraTab:CreateToggle({
    Name = "Auto Rank Claim",
    CurrentValue = false,
    Flag = "AutoRankClaim",
    Callback = function(Value)
        Settings.AutoRankClaim = Value
        if Value then
            spawn(AutoRankClaimFunc)
        end
    end,
})

local AutoUpgradeBackpackToggle = ExtraTab:CreateToggle({
    Name = "Auto Upgrade Backpack",
    CurrentValue = false,
    Flag = "AutoUpgradeBackpack",
    Callback = function(Value)
        Settings.AutoUpgradeBackpack = Value
        if Value then
            spawn(AutoUpgradeBackpackFunc)
        end
    end,
})

local AutoBuyRodToggle = ExtraTab:CreateToggle({
    Name = "Auto Buy Rod",
    CurrentValue = false,
    Flag = "AutoBuyRod",
    Callback = function(Value)
        Settings.AutoBuyRod = Value
        if Value then
            spawn(AutoBuyRodFunc)
        end
    end,
})

local AutoEquipBestRodToggle = ExtraTab:CreateToggle({
    Name = "Auto Equip Best Rod",
    CurrentValue = false,
    Flag = "AutoEquipBestRod",
    Callback = function(Value)
        Settings.AutoEquipBestRod = Value
        if Value then
            spawn(AutoEquipBestRodFunc)
        end
    end,
})

local AutoEquipBestBaitToggle = ExtraTab:CreateToggle({
    Name = "Auto Equip Best Bait",
    CurrentValue = false,
    Flag = "AutoEquipBestBait",
    Callback = function(Value)
        Settings.AutoEquipBestBait = Value
        if Value then
            spawn(AutoEquipBestBaitFunc)
        end
    end,
})

-- Player Info
local PlayerNameLabel = ExtraTab:CreateLabel("Player: " .. Player.Name)
local PlayerLevelLabel = ExtraTab:CreateLabel("Level: Loading...")
local PlayerMoneyLabel = ExtraTab:CreateLabel("Money: Loading...")
local PlayerRankLabel = ExtraTab:CreateLabel("Rank: Loading...")
local ServerPlayersLabel = ExtraTab:CreateLabel("Server Players: " .. #Players:GetPlayers())
local ServerTimeLabel = ExtraTab:CreateLabel("Server Time: Loading...")

spawn(function()
    while true do
        if PlayerData then
            PlayerLevelLabel:Set("Level: " .. tostring(PlayerData.getLevel() or "N/A"))
            PlayerMoneyLabel:Set("Money: " .. tostring(PlayerData.getMoney() or "N/A"))
            PlayerRankLabel:Set("Rank: " .. tostring(PlayerData.getRank() or "N/A"))
        end
        ServerPlayersLabel:Set("Server Players: " .. #Players:GetPlayers())
        ServerTimeLabel:Set("Server Time: " .. os.date("%X"))
        wait(1)
    end
end)

-- Settings Section
local UISettingsSection = SettingsTab:CreateSection("UI Settings")
local GameSettingsSection = SettingsTab:CreateSection("Game Settings")
local CommandsSection = SettingsTab:CreateSection("Commands")
local MiscSection = SettingsTab:CreateSection("Miscellaneous")

-- UI Settings
local AccentColorPicker = SettingsTab:CreateColorPicker({
    Name = "Accent Color",
    Color = Settings.AccentColor,
    Flag = "AccentColor",
    Callback = function(Value)
        Settings.AccentColor = Value
        Rayfield:SetAcrylic(true)
    end,
})

local HideUIKeybind = SettingsTab:CreateKeybind({
    Name = "Hide/Show UI",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Flag = "HideUIKeybind",
    Callback = function(Keybind)
        Rayfield:Toggle()
    end,
})

-- Game Settings
local AntiAFKToggle = SettingsTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        Settings.AntiAFK = Value
        if Value then
            AntiAFK()
        end
    end,
})

local LowGraphicsToggle = SettingsTab:CreateToggle({
    Name = "Low Graphics Mode",
    CurrentValue = false,
    Flag = "LowGraphicsMode",
    Callback = function(Value)
        Settings.LowGraphicsMode = Value
        LowGraphicsMode()
    end,
})

local FPSUnlockerToggle = SettingsTab:CreateToggle({
    Name = "FPS Unlocker",
    CurrentValue = false,
    Flag = "FPSUnlocker",
    Callback = function(Value)
        Settings.FPSUnlocker = Value
        FPSUnlocker()
    end,
})

-- Commands
local CommandInput = SettingsTab:CreateInput({
    Name = "Command Executor",
    PlaceholderText = "Enter command",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        loadstring(Text)()
    end,
})

-- Miscellaneous
local ResetCharacterButton = SettingsTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        Player.Character:BreakJoints()
    end,
})

local ServerHopButton = SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Player)
    end,
})

local RejoinServerButton = SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end,
})

-- Initialize features
Humanoid.WalkSpeed = Settings.WalkSpeed
Humanoid.JumpPower = Settings.JumpPower

-- Notify on load
Rayfield:Notify({
    Title = "Fish It Hub 2025 Loaded",
    Content = "by Nikzz Xit",
    Duration = 6,
    Image = 4483362458
})

-- Main loop
spawn(function()
    while true do
        -- Update durability
        RodDurability = GetRodDurability()
        
        -- Infinite oxygen
        if Settings.InfiniteOxygen and Character:FindFirstChild("Oxygen") then
            Character.Oxygen:Destroy()
        end
        
        -- Noclip
        if Settings.Noclip then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
        
        wait(0.1)
    end
end)

-- Auto save settings
spawn(function()
    while true do
        Rayfield:SaveConfiguration()
        wait(30)
    end
end)
