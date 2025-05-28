-- รอเกมโหลดให้เสร็จ
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Notification = require(ReplicatedStorage:WaitForChild("Notification"))

-- ระบบแจ้งเตือน
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- จำกัดเกมที่อนุญาต
local allowedPlaces = {
    [2753915549] = true,
    [7449423635] = true,
    [4442272183] = true
}

if not allowedPlaces[game.PlaceId] then
    warn("Anti Banned from admins not active! Blox fruit only")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/Anti-Kick.lua"))()
end

-- Anti-Kick Hook ปลอดภัย
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if typeof(self) == "Instance" and type(method) == "string" then
        if self == LocalPlayer and method:lower() == "kick" then
            notify("Anti-Kick", "Blocked Kick (namecall)")
          Notification.new("Blocked Anti kick: name call"):Display()
            return nil
        end
        if (method == "FireServer" or method == "InvokeServer") and self:IsA("RemoteEvent") then
            local name = (self.Name or ""):lower()
            if name:find("kick") or name:find("ban") then
                Notification.new("Blocked suspicious remote: " .. name):Display()
                return nil
            end
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Hook Kick Function
if hookfunction then
    hookfunction(LocalPlayer.Kick, function(...)
        Notification.new("<Color=Green>Intercepted a Kick attempt!<Color=/>"):Display()
        return
    end)
end

-- Hook __index
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if self == LocalPlayer and key:lower() == "kick" then
        Notification.new("<Color=Green>You Execute This Script (Anti kick and Admins bypass) before \n Script is ready in loaded!<Color=/>"):Display()
        return function() end
    end
    return oldIndex(self, key)
end))

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

warn("Anti-Kick Active")
warn("Anti AFK Active")

-- แจ้งเตือนเลือกทีม
task.spawn(function()
    local shownWarning = false
    while LocalPlayer.Team == nil do
        if not shownWarning then
            Notification.new("<Color=White>Choose a team to activate Anti-Banned!<Color=/>"):Display()
            shownWarning = true
        end
        task.wait(1.5)
    end
    Notification.new("<Color=White>Inject Script<Color=/> <Color=Red>Active<Color=/>"):Display()
    task.wait(1)
    Notification.new("<Color=White>It may take <Color=Yellow>2 - 17<Color=/> seconds.<Color=/>"):Display()
    task.wait(2.5)

    if getgenv().ED_AntiKick and getgenv().ED_AntiKick.Enabled then
        task.wait(3)
        warn("testing anti kick")
        Notification.new("<Color=White>Testing Anti-kick<Color=/>"):Display()
        LocalPlayer:Kick("Testing anti kick bypass!!!")
        task.wait(0.5)
        Notification.new("<Color=White> Anti Kick protection<Color=/> <Color=Green> Active!<Color=/>"):Display()
    end

    local duration = math.random(2, 17)
    Notification.new("<Color=White>Anti Banned from admins <Color=/> <Color=Green>Active!<Color=/>"):Display()
    Notification.new("<Color=White>Anti Kick is <Color=/> <Color=Green>Load safely!<Color=/>"):Display()
    task.wait(duration)
end)

-- รายชื่อ blacklist
local blacklist = {
    ["mygame43"] = true,
    ["Uzoth"] = true,
    ["xonae"] = true,
    ["Onett"] = true,
    ["Uzi_London"] = true,
    ["ShafiDev"] = true,
    ["rip_indra"] = true
}

local function checkPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if blacklist[p.Name] then
            Notification.new("<Color=Yellow>The Admin " .. p.Name .. " has joined the server!!<Color=/>"):Display()
            task.wait(1.9)
            game:Shutdown()
            break
        end
    end
end

-- ตรวจผู้เล่นทุก 1.5 วิ
task.spawn(function()
    while true do
        checkPlayers()
        task.wait(1.5)
    end
end)

game:GetService('TestService'):Message("The Anti-Ban and kick is in a test version\nyou maybe get banned from system\n(Blox fruit Only)")
