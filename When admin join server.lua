if not _G.efield_loader then
    game.Players.LocalPlayer:Kick("This is a fucking old script pls get new from Dev!!!!. End of story🥰😘 \n in 4sec game gonnabe shutdown!")
    wait(4)
    game:Shutdown()
    return
end

-- ✅ แก้ syntax table
local allowedPlaces = {
    [2753915549] = true,
    [7449423635] = true,
    [4442272183] = true
}

if not allowedPlaces[game.PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/Notification.lua"))()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ✅ เพิ่มความปลอดภัยในการเรียก Notification module
local success, NotificationModule = pcall(function()
    return require(ReplicatedStorage:WaitForChild("Notification"))
end)

local Notification = success and NotificationModule or {
    new = function()
        return {
            Display = function() warn("[Fallback] Notification module failed to load.") end
        }
    end
}

--// ========== Anti-Kick ==========
if not getgenv().ED_AntiKick then
    local getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, gsub =
    getgenv, getnamecallmethod, hookmetamethod, hookfunction, newcclosure, checkcaller, string.gsub

    local cloneref = cloneref or function(...) return ... end  
    local clonefunction = clonefunction or function(...) return ... end  

    local LocalPlayer = cloneref(Players.LocalPlayer)  
    local FindFirstChild = clonefunction(game.FindFirstChild)  

    local CompareInstances = function(i1, i2)  
        return typeof(i1) == "Instance" and typeof(i2) == "Instance"  
    end  

    local CanCastToSTDString = function(...)  
        return pcall(FindFirstChild, game, ...)  
    end  

    getgenv().ED_AntiKick = {  
        Enabled = true,  
        SendNotifications = true,  
        CheckCaller = true  
    }  

    local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)  
        local self, message = ...  
        local method = getnamecallmethod()  

        if ((getgenv().ED_AntiKick.CheckCaller and not checkcaller()) or true)  
            and CompareInstances(self, LocalPlayer)  
            and gsub(method, "^%l", string.upper) == "Kick"  
            and getgenv().ED_AntiKick.Enabled then  

            if CanCastToSTDString(message) and getgenv().ED_AntiKick.SendNotifications then  
                Notification.new("<Color=Green>Intercepted a Kick attempt!<Color=/>"):Display()  
            end  
            return  
        end  

        return OldNamecall(...)  
    end))  

    local OldFunction; OldFunction = hookfunction(LocalPlayer.Kick, function(...)  
        local self, message = ...  

        if ((getgenv().ED_AntiKick.CheckCaller and not checkcaller()) or true)  
            and CompareInstances(self, LocalPlayer)  
            and getgenv().ED_AntiKick.Enabled then  

            if CanCastToSTDString(message) and getgenv().ED_AntiKick.SendNotifications then  
                Notification.new("<Color=Green>Intercepted a Kick attempt!<Color=/>"):Display()  
            end  
            return  
        end  
    end)
end
--// ========== End Anti-Kick ==========

-- เตือนให้เลือกทีม
task.spawn(function()
    local shownWarning = false
    while player.Team == nil do
        if not shownWarning then
            Notification.new("<Color=White>Choose a team to activate Anti-Banned!<Color=/>"):Display()
            shownWarning = true
        end
        task.wait(1.5)
    end

    Notification.new("<Color=White>Inject Script<Color=/> <Color=Red>Bitchh!<Color=/>"):Display()
    wait(1)
    Notification.new("<Color=White>It may take <Color=Yellow>2 - 17<Color=/> seconds.<Color=/>"):Display()
    task.wait(2.5)

    if getgenv().ED_AntiKick and getgenv().ED_AntiKick.Enabled then
        task.wait(3)
        warn("testing anti kick")
        Notification.new("<Color=White>Testing Anti-kick<Color=/>"):Display()
        game.Players.LocalPlayer:Kick("Testing anti kick bypass!!!")
        task.wait(0.5)
        Notification.new("<Color=White> Anti Kick protection<Color=/> <Color=Green> Active!<Color=/>"):Display()
    end

    local duration = math.random(2, 17)
    Notification.new("<Color=White>Anti Banned from admins <Color=/> <Color=Green>Active!<Color=/>"):Display()
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

task.spawn(function()
    while true do
        checkPlayers()
        task.wait(1.5)
    end
end)

game:GetService('TestService'):Message("This is a Beta Test. Maybe you got banned from system \n or in bloxfruit you got like 'Security kick please rejoin' yaaaaaaa")

-- Anti-AFK
local VirtualUser = game:service("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

warn("Anti AFK Active")
warn("Anti Kick load safely")
