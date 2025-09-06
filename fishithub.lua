local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({Name = "Test UI | Fish It Hub", IntroText = "Test Loaded"})

local Tab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})

Tab:AddButton({
    Name = "Test Button",
    Callback = function()
        OrionLib:MakeNotification({Name="FishItHub", Content="UI Works!", Time=5})
    end
})

OrionLib:Init()
