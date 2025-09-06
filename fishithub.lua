-- Fish It Hub 2025 by Nikzz Xit
-- Version: 2.5.0
-- Last Updated: September 2025

local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Orion/main/source", true)))()
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

-- Auto Update System
local Version = "2.5.0"
local GitHubRaw = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/FishItHub.lua"
local GitHubVersion = "https://raw.githubusercontent.com/NikzzXit/FishItHub/main/version.txt"

local function CheckForUpdates()
    local success, latestVersion = pcall(function()
        return game:HttpGet(GitHubVersion)
    end)
    
    if success and latestVersion and latestVersion ~= Version then
        OrionLib:MakeNotification({
            Name = "Update Available!",
            Content = "New version " .. latestVersion .. " is available. Click to update!",
            Time = 10,
            Callback = function()
                local success, newScript = pcall(function()
                    return game:HttpGet(GitHubRaw)
                end)
                
                if success and newScript then
                    writefile("FishItHub_" .. latestVersion .. ".lua", newScript)
                    OrionLib:MakeNotification({
                        Name = "Update Complete!",
                        Content = "New version saved as FishItHub_" .. latestVersion .. ".lua",
                        Time = 5
                    })
                end
            end
        })
    end
end

spawn(CheckForUpdates)

-- Game Specific Variables
local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 10)
local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 10)

-- Try to find remote events with multiple possible names
local CastLineRemote = Remotes:FindFirstChild("CastLine") or Remotes:FindFirstChild("CastFishingLine") or Remotes:FindFirstChild("FishingCast")
local CatchFishRemote = Remotes:FindFirstChild("CatchFish") or Remotes:FindFirstChild("ReelIn") or Remotes:FindFirstChild("Catch")
local SellFishRemote = Events:FindFirstChild("SellFish") or Events:FindFirstChild("SellAllFish") or Events:FindFirstChild("Sell")
local UpgradeRodRemote = Events:FindFirstChild("UpgradeRod") or Events:FindFirstChild("Upgrade") or Events:FindFirstChild("RodUpgrade")
local BuyBaitRemote = Events:FindFirstChild("BuyBait") or Events:FindFirstChild("PurchaseBait") or Events:FindFirstChild("BaitPurchase")
local RepairRodRemote = Events:FindFirstChild("RepairRod") or Events:FindFirstChild("Repair") or Events:FindFirstChild("RodRepair")
local RepairBoatRemote = Events:FindFirstChild("RepairBoat") or Events:FindFirstChild("BoatRepair")
local CollectChestRemote = Events:FindFirstChild("CollectChest") or Events:FindFirstChild("OpenChest") or Events:FindFirstChild("ChestCollect")
local ClaimDailyRemote = Events:FindFirstChild("ClaimDaily") or Events:FindFirstChild("DailyReward") or Events:FindFirstChild("DailyClaim")
local RankClaimRemote = Events:FindFirstChild("ClaimRank") or Events:FindFirstChild("RankReward") or Events:FindFirstChild("RankClaim")
local UpgradeBackpackRemote = Events:FindFirstChild("UpgradeBackpack") or Events:FindFirstChild("BackpackUpgrade")
local BuyRodRemote = Events:FindFirstChild("BuyRod") or Events:FindFirstChild("PurchaseRod") or Events:FindFirstChild("RodPurchase")

-- UI Variables
local Window = OrionLib:MakeWindow({
    Name = "Fish It Hub 2025 | v" .. Version,
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FishItHubConfig",
    IntroEnabled = true,
    IntroText = "Fish It Hub 2025",
    IntroIcon = "rbxassetid://12584548292"
})

-- Global Variables
local FishingEnabled = false
local AutoCastEnabled = false
autoCatchEnabled = false
local AutoPerfectCatchEnabled = false
local AutoSellEnabled = false
local AutoBaitSelectEnabled = false
local AutoCollectChestsEnabled = false
local AutoUpgradeRodEnabled = false
local AutoRepairRodEnabled = false
local AutoRepairBoatEnabled = false
local InfiniteOxygenEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local ESPFishEnabled = false
local ESPPlayersEnabled = false
local ESPChestsEnabled = false
local AutoBuyBaitEnabled = false
local AutoEquipRodEnabled = false
local AutoCollectDailyEnabled = false
local AutoRankClaimEnabled = false
local AutoUpgradeBackpackEnabled = false
local AutoBuyRodEnabled = false
local AutoEquipBestRodEnabled = false
local AutoEquipBestBaitEnabled = false
local AntiAFKEnabled = false
local LowGraphicsEnabled = false
local FPSUnlockerEnabled = false

local FishingDelay = 1
local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 50
local SelectedBait = "Worm"
local SelectedRod = "Basic Rod"
local SelectedLocation = "Spawn"
local CustomLocations = {}
local TeleportRoute = {}
local ChestSpots = {}
local LoopChestSpotsEnabled = false
local AccentColor = Color3.fromRGB(0, 162, 255)
local UIHidden = false
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalGraphicsQuality = 10

local FishESP = {}
local PlayerESP = {}
local ChestESP = {}
local FishingConnection = nil
local ChestConnection = nil
local AFKConnection = nil
local NoclipConnection = nil
local FlyConnection = nil
local OxygenConnection = nil
local GraphicsConnection = nil
local FPSConnection = nil

-- Utility Functions
local function Notify(title, content, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = content,
        Time = duration or 5
    })
end

local function GetPlayer()
    return game.Players.LocalPlayer
end

local function GetCharacter()
    local player = GetPlayer()
    return player.Character or player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local character = GetCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local character = GetCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 3)
end

local function TeleportTo(position)
    local rootPart = GetRootPart()
    if rootPart then
        rootPart.CFrame = CFrame.new(position)
    end
end

local function TeleportToCFrame(cframe)
    local rootPart = GetRootPart()
    if rootPart then
        rootPart.CFrame = cframe
    end
end

local function GetPlayers()
    return game.Players:GetPlayers()
end

local function GetFishingRod()
    local character = GetCharacter()
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "rod") then
            return tool
        end
    end
    return nil
end

local function GetBait()
    local backpack = GetPlayer().Backpack
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "bait") then
            return item
        end
    end
    return nil
end

local function GetBestRod()
    local backpack = GetPlayer().Backpack
    local bestRod = nil
    local bestValue = 0
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "rod") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value")
                if durability and durability.Value > bestValue then
                    bestValue = durability.Value
                    bestRod = item
                end
            end
        end
    end
    
    return bestRod
end

local function GetBestBait()
    local backpack = GetPlayer().Backpack
    local bestBait = nil
    local bestValue = 0
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name:lower(), "bait") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local effectiveness = handle:FindFirstChild("Effectiveness") or handle:FindFirstChild("Value")
                if effectiveness and effectiveness.Value > bestValue then
                    bestValue = effectiveness.Value
                    bestBait = item
                end
            end
        end
    end
    
    return bestBait
end

local function EquipTool(tool)
    if tool then
        GetHumanoid():EquipTool(tool)
    end
end

local function CastLine()
    if CastLineRemote then
        CastLineRemote:FireServer()
    else
        -- Fallback: Simulate click if remote not found
        local rod = GetFishingRod()
        if rod then
            rod:Activate()
        end
    end
end

local function CatchFish()
    if CatchFishRemote then
        CatchFishRemote:FireServer()
    else
        -- Fallback: Simulate key press if remote not found
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local function SellFish()
    if SellFishRemote then
        SellFishRemote:FireServer()
    end
end

local function UpgradeRod()
    if UpgradeRodRemote then
        UpgradeRodRemote:FireServer()
    end
end

local function BuyBait(baitType, amount)
    if BuyBaitRemote then
        BuyBaitRemote:FireServer(baitType, amount or 1)
    end
end

local function RepairRod()
    if RepairRodRemote then
        RepairRodRemote:FireServer()
    end
end

local function RepairBoat()
    if RepairBoatRemote then
        RepairBoatRemote:FireServer()
    end
end

local function CollectChest(chest)
    if CollectChestRemote then
        CollectChestRemote:FireServer(chest)
    end
end

local function ClaimDaily()
    if ClaimDailyRemote then
        ClaimDailyRemote:FireServer()
    end
end

local function ClaimRank()
    if RankClaimRemote then
        RankClaimRemote:FireServer()
    end
end

local function UpgradeBackpack()
    if UpgradeBackpackRemote then
        UpgradeBackpackRemote:FireServer()
    end
end

local function BuyRod(rodType)
    if BuyRodRemote then
        BuyRodRemote:FireServer(rodType)
    end
end

local function GetRodDurability()
    local rod = GetFishingRod()
    if rod then
        local handle = rod:FindFirstChild("Handle")
        if handle then
            local durability = handle:FindFirstChild("Durability") or handle:FindFirstChild("Value")
            if durability then
                return durability.Value
            end
        end
    end
    return 100
end

local function IsInWater()
    local character = GetCharacter()
    local rootPart = GetRootPart()
    if rootPart then
        local position = rootPart.Position
        return position.Y < 0 -- Simple check, might need adjustment
    end
    return false
end

local function FindChests()
    local chests = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.find(obj.Name:lower(), "chest") then
            table.insert(chests, obj)
        end
    end
    return chests
end

local function FindFishingSpots()
    local spots = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and string.find(obj.Name:lower(), "fish") then
            table.insert(spots, obj)
        end
    end
    return spots
end

local function CreateESP(object, color, name)
    local highlight = Instance.new("Highlight")
    highlight.Name = name
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = CoreGui
    
    return highlight
end

local function RemoveESP(espName)
    for _, item in ipairs(CoreGui:GetChildren()) do
        if item.Name == espName then
            item:Destroy()
        end
    end
end

local function ClearAllESP()
    for _, esp in ipairs(FishESP) do
        if esp then
            esp:Destroy()
        end
    end
    FishESP = {}
    
    for _, esp in ipairs(PlayerESP) do
        if esp then
            esp:Destroy()
        end
    end
    PlayerESP = {}
    
    for _, esp in ipairs(ChestESP) do
        if esp then
            esp:Destroy()
        end
    end
    ChestESP = {}
end

local function ToggleESP(objects, enabled, espTable, color, baseName)
    if enabled then
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then
                local esp = CreateESP(obj, color, baseName .. obj.Name)
                table.insert(espTable, esp)
            end
        end
    else
        for _, esp in ipairs(espTable) do
            if esp then
                esp:Destroy()
            end
        end
        espTable = {}
    end
end

local function UpdateFishESP()
    ToggleESP(Workspace:GetChildren(), ESPFishEnabled, FishESP, Color3.fromRGB(0, 255, 0), "FishESP_")
end

local function UpdatePlayerESP()
    ToggleESP(GetPlayers(), ESPPlayersEnabled, PlayerESP, Color3.fromRGB(255, 0, 0), "PlayerESP_")
end

local function UpdateChestESP()
    ToggleESP(FindChests(), ESPChestsEnabled, ChestESP, Color3.fromRGB(255, 215, 0), "ChestESP_")
end

local function ToggleNoclip(enabled)
    if enabled then
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
        
        NoclipConnection = RunService.Stepped:Connect(function()
            local character = GetCharacter()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
    end
end

local function ToggleFly(enabled)
    if enabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        
        local rootPart = GetRootPart()
        local velocity = Instance.new("BodyVelocity")
        velocity.Name = "FlyVelocity"
        velocity.MaxForce = Vector3.new(100000, 100000, 100000)
        velocity.Velocity = Vector3.new(0, 0, 0)
        velocity.Parent = rootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not rootPart or not rootPart.Parent then
                if FlyConnection then
                    FlyConnection:Disconnect()
                end
                return
            end
            
            local camera = Workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
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
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * FlySpeed
            end
            
            velocity.Velocity = direction
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        
        local rootPart = GetRootPart()
        if rootPart then
            local velocity = rootPart:FindFirstChild("FlyVelocity")
            if velocity then
                velocity:Destroy()
            end
        end
        
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function ToggleInfiniteOxygen(enabled)
    if enabled then
        if OxygenConnection then
            OxygenConnection:Disconnect()
        end
        
        OxygenConnection = RunService.Heartbeat:Connect(function()
            local character = GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.OxygenLevel = humanoid.MaxOxygenLevel
                end
            end
        end)
    else
        if OxygenConnection then
            OxygenConnection:Disconnect()
            OxygenConnection = nil
        end
    end
end

local function ToggleAntiAFK(enabled)
    if enabled then
        if AFKConnection then
            AFKConnection:Disconnect()
        end
        
        AFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    else
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end

local function ToggleLowGraphics(enabled)
    if enabled then
        if GraphicsConnection then
            GraphicsConnection:Disconnect()
        end
        
        -- Store original settings
        OriginalGraphicsQuality = settings().Rendering.QualityLevel
        
        -- Set low graphics
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        
        GraphicsConnection = RunService.RenderStepped:Connect(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                end
            end
        end)
    else
        if GraphicsConnection then
            GraphicsConnection:Disconnect()
            GraphicsConnection = nil
        end
        
        -- Restore original settings
        settings().Rendering.QualityLevel = OriginalGraphicsQuality
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000000
    end
end

local function ToggleFPSUnlocker(enabled)
    if enabled then
        if FPSConnection then
            FPSConnection:Disconnect()
        end
        
        setfpscap(999)
        
        FPSConnection = RunService.RenderStepped:Connect(function()
            setfpscap(999)
        end)
    else
        if FPSConnection then
            FPSConnection:Disconnect()
            FPSConnection = nil
        end
        
        setfpscap(60)
    end
end

local function ResetCharacter()
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.Health = 0
    end
end

local function ServerHop()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
    local data = game:GetService("HttpService"):JSONDecode(req)
    
    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
    else
        Notify("Server Hop", "No servers available to hop to.", 5)
    end
end

local function RejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

-- Fishing Functions
local function StartFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
    end
    
    FishingConnection = RunService.Heartbeat:Connect(function()
        if not FishingEnabled then
            FishingConnection:Disconnect()
            return
        end
        
        -- Auto Cast
        if AutoCastEnabled then
            CastLine()
        end
        
        -- Auto Catch
        if autoCatchEnabled then
            CatchFish()
        end
        
        -- Auto Perfect Catch (timing-based, needs adjustment)
        if AutoPerfectCatchEnabled then
            task.wait(0.2) -- Perfect timing delay
            CatchFish()
        end
        
        -- Auto Sell
        if AutoSellEnabled then
            SellFish()
        end
        
        -- Auto Bait Select
        if AutoBaitSelectEnabled then
            local bait = GetBait()
            if bait then
                EquipTool(bait)
            end
        end
        
        -- Auto Repair Rod
        if AutoRepairRodEnabled then
            local durability = GetRodDurability()
            if durability < 20 then -- Threshold for repair
                RepairRod()
            end
        end
        
        task.wait(FishingDelay)
    end)
end

local function StopFishing()
    if FishingConnection then
        FishingConnection:Disconnect()
        FishingConnection = nil
    end
end

-- Chest Collection Functions
local function StartChestCollection()
    if ChestConnection then
        ChestConnection:Disconnect()
    end
    
    ChestConnection = RunService.Heartbeat:Connect(function()
        if not AutoCollectChestsEnabled then
            ChestConnection:Disconnect()
            return
        end
        
        local chests = FindChests()
        for _, chest in ipairs(chests) do
            local rootPart = GetRootPart()
            if rootPart and chest:FindFirstChild("PrimaryPart") then
                local distance = (rootPart.Position - chest.PrimaryPart.Position).Magnitude
                if distance < 50 then
                    CollectChest(chest)
                end
            end
        end
        
        task.wait(1)
    end)
end

local function StopChestCollection()
    if ChestConnection then
        ChestConnection:Disconnect()
        ChestConnection = nil
    end
end

-- Auto Upgrade Functions
local function StartAutoUpgrade()
    if AutoUpgradeRodEnabled then
        UpgradeRod()
    end
    
    if AutoUpgradeBackpackEnabled then
        UpgradeBackpack()
    end
    
    if AutoBuyRodEnabled then
        BuyRod(SelectedRod)
    end
    
    if AutoBuyBaitEnabled then
        BuyBait(SelectedBait, 10)
    end
    
    if AutoEquipBestRodEnabled then
        local bestRod = GetBestRod()
        EquipTool(bestRod)
    end
    
    if AutoEquipBestBaitEnabled then
        local bestBait = GetBestBait()
        EquipTool(bestBait)
    end
    
    if AutoCollectDailyEnabled then
        ClaimDaily()
    end
    
    if AutoRankClaimEnabled then
        ClaimRank()
    end
end

-- Teleport Functions
local function TeleportToLocation(locationName)
    local locations = {
        Spawn = CFrame.new(0, 10, 0),
        Market = CFrame.new(100, 10, 0),
        UpgradeShop = CFrame.new(-100, 10, 0),
        FishingSpot1 = CFrame.new(50, 5, 50),
        FishingSpot2 = CFrame.new(-50, 5, 50),
        FishingSpot3 = CFrame.new(50, 5, -50),
        HiddenSpot1 = CFrame.new(200, 5, 200),
        HiddenSpot2 = CFrame.new(-200, 5, 200)
    }
    
    if locations[locationName] then
        TeleportToCFrame(locations[locationName])
        Notify("Teleport", "Teleported to " .. locationName, 3)
    elseif CustomLocations[locationName] then
        TeleportToCFrame(CustomLocations[locationName])
        Notify("Teleport", "Teleported to " .. locationName, 3)
    else
        Notify("Teleport", "Location not found: " .. locationName, 3)
    end
end

local function SaveCustomLocation(name)
    local rootPart = GetRootPart()
    if rootPart then
        CustomLocations[name] = rootPart.CFrame
        Notify("Location Saved", "Saved as: " .. name, 3)
    end
end

local function StartTeleportRoute()
    if #TeleportRoute == 0 then
        Notify("Teleport Route", "No locations in route", 3)
        return
    end
    
    local index = 1
    while #TeleportRoute > 0 do
        TeleportToCFrame(TeleportRoute[index])
        task.wait(3) -- Wait at each location
        
        index = index + 1
        if index > #TeleportRoute then
            index = 1
        end
    end
end

local function StartChestLoop()
    if #ChestSpots == 0 then
        Notify("Chest Loop", "No chest spots saved", 3)
        return
    end
    
    local index = 1
    while LoopChestSpotsEnabled do
        TeleportToCFrame(ChestSpots[index])
        task.wait(2) -- Wait at each chest spot
        
        index = index + 1
        if index > #ChestSpots then
            index = 1
        end
    end
end

-- UI Creation
local FishingTab = Window:MakeTab({
    Name = "🎣 Fishing",
    Icon = "rbxassetid://12584548292",
    PremiumOnly = false
})

local ToolsTab = Window:MakeTab({
    Name = "🛠 Tools",
    Icon = "rbxassetid://12584548292",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "🚀 Teleport",
    Icon = "rbxassetid://12584548292",
    PremiumOnly = false
})

local ExtraTab = Window:MakeTab({
    Name = "💎 Extra",
    Icon = "rbxassetid://12584548292",
    PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
    Name = "⚙ Settings",
    Icon = "rbxassetid://12584548292",
    PremiumOnly = false
})

-- Fishing Tab
FishingTab:AddToggle({
    Name = "Auto Fish",
    Default = false,
    Callback = function(Value)
        FishingEnabled = Value
        if Value then
            StartFishing()
            Notify("Auto Fish", "Enabled", 3)
        else
            StopFishing()
            Notify("Auto Fish", "Disabled", 3)
        end
    end
})

FishingTab:AddToggle({
    Name = "Auto Cast",
    Default = false,
    Callback = function(Value)
        AutoCastEnabled = Value
        Notify("Auto Cast", Value and "Enabled" or "Disabled", 3)
    end
})

FishingTab:AddToggle({
    Name = "Auto Catch",
    Default = false,
    Callback = function(Value)
        autoCatchEnabled = Value
        Notify("Auto Catch", Value and "Enabled" or "Disabled", 3)
    end
})

FishingTab:AddToggle({
    Name = "Auto Perfect Catch",
    Default = false,
    Callback = function(Value)
        AutoPerfectCatchEnabled = Value
        Notify("Auto Perfect Catch", Value and "Enabled" or "Disabled", 3)
    end
})

FishingTab:AddToggle({
    Name = "Auto Sell",
    Default = false,
    Callback = function(Value)
        AutoSellEnabled = Value
        Notify("Auto Sell", Value and "Enabled" or "Disabled", 3)
    end
})

FishingTab:AddToggle({
    Name = "Auto Bait Select",
    Default = false,
    Callback = function(Value)
        AutoBaitSelectEnabled = Value
        Notify("Auto Bait Select", Value and "Enabled" or "Disabled", 3)
    end
})

FishingTab:AddButton({
    Name = "Manual Cast",
    Callback = function()
        CastLine()
        Notify("Manual Cast", "Casting line...", 3)
    end
})

FishingTab:AddSlider({
    Name = "Fishing Delay",
    Min = 0.1,
    Max = 5,
    Default = 1,
    Color = AccentColor,
    Increment = 0.1,
    ValueName = "seconds",
    Callback = function(Value)
        FishingDelay = Value
    end
})

FishingTab:AddLabel("Rod Durability: " .. GetRodDurability() .. "%")
FishingTab:AddToggle({
    Name = "Auto Repair Rod",
    Default = false,
    Callback = function(Value)
        AutoRepairRodEnabled = Value
        Notify("Auto Repair Rod", Value and "Enabled" or "Disabled", 3)
    end
})

-- Tools Tab
ToolsTab:AddToggle({
    Name = "Auto Collect Chests",
    Default = false,
    Callback = function(Value)
        AutoCollectChestsEnabled = Value
        if Value then
            StartChestCollection()
            Notify("Auto Collect Chests", "Enabled", 3)
        else
            StopChestCollection()
            Notify("Auto Collect Chests", "Disabled", 3)
        end
    end
})

ToolsTab:AddToggle({
    Name = "Auto Upgrade Rod",
    Default = false,
    Callback = function(Value)
        AutoUpgradeRodEnabled = Value
        Notify("Auto Upgrade Rod", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "Auto Repair Boat",
    Default = false,
    Callback = function(Value)
        AutoRepairBoatEnabled = Value
        Notify("Auto Repair Boat", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "Infinite Oxygen",
    Default = false,
    Callback = function(Value)
        InfiniteOxygenEnabled = Value
        ToggleInfiniteOxygen(Value)
        Notify("Infinite Oxygen", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = AccentColor,
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        WalkSpeed = Value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
})

ToolsTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = AccentColor,
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        JumpPower = Value
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = Value
        end
    end
})

ToolsTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        NoclipEnabled = Value
        ToggleNoclip(Value)
        Notify("Noclip", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        ToggleFly(Value)
        Notify("Fly", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddSlider({
    Name = "Fly Speed",
    Min = 20,
    Max = 200,
    Default = 50,
    Color = AccentColor,
    Increment = 5,
    ValueName = "speed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

ToolsTab:AddToggle({
    Name = "ESP Fish",
    Default = false,
    Callback = function(Value)
        ESPFishEnabled = Value
        UpdateFishESP()
        Notify("ESP Fish", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(Value)
        ESPPlayersEnabled = Value
        UpdatePlayerESP()
        Notify("ESP Players", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "ESP Chests",
    Default = false,
    Callback = function(Value)
        ESPChestsEnabled = Value
        UpdateChestESP()
        Notify("ESP Chests", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "Auto Buy Bait",
    Default = false,
    Callback = function(Value)
        AutoBuyBaitEnabled = Value
        Notify("Auto Buy Bait", Value and "Enabled" or "Disabled", 3)
    end
})

ToolsTab:AddToggle({
    Name = "Auto Equip Rod",
    Default = false,
    Callback = function(Value)
        AutoEquipRodEnabled = Value
        Notify("Auto Equip Rod", Value and "Enabled" or "Disabled", 3)
    end
})

-- Teleport Tab
TeleportTab:AddDropdown({
    Name = "Teleport Locations",
    Default = "Spawn",
    Options = {"Spawn", "Market", "UpgradeShop", "FishingSpot1", "FishingSpot2", "FishingSpot3", "HiddenSpot1", "HiddenSpot2"},
    Callback = function(Value)
        SelectedLocation = Value
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Selected Location",
    Callback = function()
        TeleportToLocation(SelectedLocation)
    end
})

TeleportTab:AddTextbox({
    Name = "Save Custom Location",
    Default = "Location Name",
    TextDisappear = true,
    Callback = function(Value)
        SaveCustomLocation(Value)
    end
})

TeleportTab:AddTextbox({
    Name = "Teleport to Custom Location",
    Default = "Location Name",
    TextDisappear = true,
    Callback = function(Value)
        TeleportToLocation(Value)
    end
})

TeleportTab:AddTextbox({
    Name = "Add to Teleport Route",
    Default = "Location Name",
    TextDisappear = true,
    Callback = function(Value)
        if CustomLocations[Value] then
            table.insert(TeleportRoute, CustomLocations[Value])
            Notify("Teleport Route", "Added: " .. Value, 3)
        else
            Notify("Teleport Route", "Location not found: " .. Value, 3)
        end
    end
})

TeleportTab:AddButton({
    Name = "Start Teleport Route",
    Callback = function()
        StartTeleportRoute()
    end
})

TeleportTab:AddButton({
    Name = "Clear Teleport Route",
    Callback = function()
        TeleportRoute = {}
        Notify("Teleport Route", "Route cleared", 3)
    end
})

TeleportTab:AddButton({
    Name = "Save Current Chest Spot",
    Callback = function()
        local rootPart = GetRootPart()
        if rootPart then
            table.insert(ChestSpots, rootPart.CFrame)
            Notify("Chest Spots", "Spot saved", 3)
        end
    end
})

TeleportTab:AddToggle({
    Name = "Loop Chest Spots",
    Default = false,
    Callback = function(Value)
        LoopChestSpotsEnabled = Value
        if Value then
            StartChestLoop()
            Notify("Chest Loop", "Enabled", 3)
        else
            Notify("Chest Loop", "Disabled", 3)
        end
    end
})

-- Extra Tab
ExtraTab:AddToggle({
    Name = "Auto Collect Daily Reward",
    Default = false,
    Callback = function(Value)
        AutoCollectDailyEnabled = Value
        Notify("Auto Daily Reward", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddToggle({
    Name = "Auto Rank Claim",
    Default = false,
    Callback = function(Value)
        AutoRankClaimEnabled = Value
        Notify("Auto Rank Claim", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddToggle({
    Name = "Auto Upgrade Backpack",
    Default = false,
    Callback = function(Value)
        AutoUpgradeBackpackEnabled = Value
        Notify("Auto Upgrade Backpack", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddToggle({
    Name = "Auto Buy Rod",
    Default = false,
    Callback = function(Value)
        AutoBuyRodEnabled = Value
        Notify("Auto Buy Rod", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddToggle({
    Name = "Auto Equip Best Rod",
    Default = false,
    Callback = function(Value)
        AutoEquipBestRodEnabled = Value
        Notify("Auto Equip Best Rod", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddToggle({
    Name = "Auto Equip Best Bait",
    Default = false,
    Callback = function(Value)
        AutoEquipBestBaitEnabled = Value
        Notify("Auto Equip Best Bait", Value and "Enabled" or "Disabled", 3)
    end
})

ExtraTab:AddDropdown({
    Name = "Select Bait Type",
    Default = "Worm",
    Options = {"Worm", "Shrimp", "Squid", "Special", "Golden"},
    Callback = function(Value)
        SelectedBait = Value
    end
})

ExtraTab:AddDropdown({
    Name = "Select Rod Type",
    Default = "Basic Rod",
    Options = {"Basic Rod", "Wooden Rod", "Steel Rod", "Golden Rod", "Diamond Rod"},
    Callback = function(Value)
        SelectedRod = Value
    end
})

-- Settings Tab
SettingsTab:AddColorpicker({
    Name = "UI Accent Color",
    Default = AccentColor,
    Callback = function(Value)
        AccentColor = Value
        OrionLib:MakeNotification({
            Name = "Color Changed",
            Content = "UI accent color updated",
            Time = 3
        })
    end
})

SettingsTab:AddTextbox({
    Name = "Custom Command",
    Default = "Command",
    TextDisappear = true,
    Callback = function(Value)
        -- Simple command system
        if Value == "reset" then
            ResetCharacter()
        elseif Value == "hop" then
            ServerHop()
        elseif Value == "rejoin" then
            RejoinServer()
        elseif Value == "hide" then
            OrionLib:Destroy()
        end
    end
})

SettingsTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(Value)
        AntiAFKEnabled = Value
        ToggleAntiAFK(Value)
        Notify("Anti AFK", Value and "Enabled" or "Disabled", 3)
    end
})

SettingsTab:AddKeybind({
    Name = "Hide/Show UI",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function()
        UIHidden = not UIHidden
        OrionLib:MakeNotification({
            Name = "UI Toggled",
            Content = UIHidden and "UI Hidden" or "UI Visible",
            Time = 2
        })
    end
})

SettingsTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        ResetCharacter()
        Notify("Reset", "Character reset", 3)
    end
})

SettingsTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        ServerHop()
        Notify("Server Hop", "Hopping to new server...", 3)
    end
})

SettingsTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        RejoinServer()
        Notify("Rejoin", "Rejoining server...", 3)
    end
})

SettingsTab:AddToggle({
    Name = "Low Graphics Mode",
    Default = false,
    Callback = function(Value)
        LowGraphicsEnabled = Value
        ToggleLowGraphics(Value)
        Notify("Low Graphics", Value and "Enabled" or "Disabled", 3)
    end
})

SettingsTab:AddToggle({
    Name = "FPS Unlocker",
    Default = false,
    Callback = function(Value)
        FPSUnlockerEnabled = Value
        ToggleFPSUnlocker(Value)
        Notify("FPS Unlocker", Value and "Enabled" or "Disabled", 3)
    end
})

SettingsTab:AddLabel("Fish It Hub 2025 by Nikzz Xit")
SettingsTab:AddLabel("Version: " .. Version)
SettingsTab:AddLabel("Thanks for using!")

-- Initialize
local function Initialize()
    -- Set initial walk speed and jump power
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = WalkSpeed
        humanoid.JumpPower = JumpPower
    end
    
    -- Start auto features if enabled
    if FishingEnabled then
        StartFishing()
    end
    
    if AutoCollectChestsEnabled then
        StartChestCollection()
    end
    
    -- Show welcome notification
    OrionLib:MakeNotification({
        Name = "Fish It Hub 2025 Loaded",
        Content = "by Nikzz Xit | Version " .. Version,
        Time = 5,
        Image = "rbxassetid://12584548292"
    })
end

-- Character added event to reapply settings
Player.CharacterAdded:Connect(function()
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = WalkSpeed
        humanoid.JumpPower = JumpPower
    end
    
    if FlyEnabled then
        ToggleFly(true)
    end
    
    if NoclipEnabled then
        ToggleNoclip(true)
    end
end)

-- Run initialization
Initialize()

-- Close UI binding
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        OrionLib:Destroy()
    end
end)

OrionLib:Init()
