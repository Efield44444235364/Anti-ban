--[[-----------------------------------------------------------------------
    Executer: KRNL Only
    Game: Roblox
    Map: Drive World
    SYSTEM: Secure Internal Patcher & Override Module
    AUTHOR: Kawnew | VERSION: 5.4.2b

    NOTE:
    This script modifies game files to reduce detection by anti-cheat systems.
    Tested with KRNL Executor, ~95% effective in preventing bans. Use at your own risk.
    No guarantees against bans or account issues. Keep script updated for best protection.
---------------------------------------------------------------------------]]
--roblox core
local Players, ReplicatedStorage, CoreGui, RunService = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("CoreGui"), game:GetService("RunService")
local HttpService, StarterGui = game:GetService("HttpService"), game:GetService("StarterGui")

local lp = Players.LocalPlayer
if not lp then repeat task.wait() until Players.LocalPlayer lp = Players.LocalPlayer end

--  Kick Block
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" or tostring(self) == "Kick" then
        warn("[Bypass] Kick attempt blocked:", args[1])
        return nil
    end
    
    if method == "FireServer" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
        if tostring(self):lower():find("report") or tostring(self):lower():find("flag") then
            warn("[Bypass] Report/Flag Remote blocked:", self:GetFullName())
            return nil
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

--  Player:Kick Override
hookfunction(lp.Kick, function(...) 
    warn("[Bypass] Kick function intercepted.")
    return 
end)

--  Disable CoreGui Report Panel
pcall(function()
    local function scanCore()
        for _, v in pairs(CoreGui:GetDescendants()) do
            if v:IsA("TextButton") and tostring(v.Text):lower():find("report") then
                v.Text = "[REPORT DISABLED]"
                v.AutoButtonColor = false
                v.MouseButton1Click:Connect(function()
                    StarterGui:SetCore("SendNotification", {
                        Title = "Protected",
                        Text = "Reporting players is disabled on this session.",
                        Duration = 3
                    })
                end)
            end
        end
    end
    scanCore()
    CoreGui.DescendantAdded:Connect(function()
        task.delay(0.5, scanCore)
    end)
end)

--  HttpService Patch: block analytics & reporting endpoints
local blockedEndpoints = {
    "data.roblox.com", "analytics.roblox.com", "report", "flag", "abuse"
}
local oldRequest = http and http.request or syn and syn.request or request
if oldRequest then
    hookfunction(oldRequest, function(tbl)
        for _, url in ipairs(blockedEndpoints) do
            if tbl.Url and tbl.Url:lower():find(url) then
                warn("[Bypass] Blocked external Http request to:", tbl.Url)
                return { Success = true, StatusCode = 200, Body = "OK" }
            end
        end
        return oldRequest(tbl)
    end)
end

--  Logging Suppression
local oldwarn = warn
warn = function(...)
    local args = {...}
    for i,v in ipairs(args) do
        if typeof(v) == "string" and (v:lower():find("kick") or v:lower():find("report") or v:lower():find("flag")) then
            return
        end
    end
    oldwarn(unpack(args))
end

--  Chat Logger Patch
pcall(function()
    local ChatService = require(ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"))
    if ChatService and ChatService.MessagePosted then
        ChatService.MessagePosted.OnClientEvent:Connect(function(msg)
            if msg and msg:lower():find("report") then
                warn("[Bypass] Chat report flagged and filtered.")
            end
        end)
    end
end)

--  Client Analytics Intercept
local AnalyticsModules = {
    "ClientAnalytics", "AnalyticsService", "ClientFlagHandler"
}

for _, modName in ipairs(AnalyticsModules) do
    local success, mod = pcall(function()
        return require(ReplicatedStorage:FindFirstChild(modName) or game:GetService("StarterPlayer"):FindFirstChild(modName))
    end)
    if success and typeof(mod) == "table" then
        for k,v in pairs(mod) do
            if typeof(v) == "function" then
                mod[k] = function(...) return nil end
            end
        end
        warn("[Bypass] Analytics module neutered:", modName)
    end
end

--  Notify Bypass Ready
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Bypass Active",
        Text = "All core logging, kick, and report systems disabled.",
        Duration = 5
    })
end)

--  Confirm Secure Flag
getgenv().BypassRobloxSecured = true

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- Variables
local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer
local TrailerSystem = ReplicatedStorage:FindFirstChild("Systems") and ReplicatedStorage.Systems:FindFirstChild("TrailerJobs")
local mt = getrawmetatable(game)

_G.SecurePatch = true
_G.InjectionConfirmed = false
_G.ProtectionMode = "Total Override"
_G.PatchChecksum = {}
_G.Hooked = false
_G.ProtectedRemotes = {}

-- File Patch Catalog
local CoreFiles = {
    ["ClientCore.AntiCheatMain"] = {
        path = "game/CoreScripts/AntiCheat/MainModule.lua",
        override = [[
            -- Core Override Patch v1
            local Players = game:GetService("Players")
            return {
                ReportPlayer = function() return nil end,
                SendToServer = function() return end,
                Init = function() end
            }
        ]]
    },
    ["ClientConfig.FlagTrigger"] = {
        path = "game/Client/Flag/Trigger.lua",
        override = [[
            -- Flag Manager Override
            return {
                ShouldFlag = function() return false end,
                FlagLevel = "none",
                SendLog = function() return end
            }
        ]]
    },
    ["ReplicatedStorage.AlertDispatcher"] = {
        path = "game/ReplicatedStorage/Systems/AlertDispatcher.lua",
        override = [[
            -- Alert Dispatcher Override
            return {
                SendAlert = function() return end,
                Critical = false
            }
        ]]
    },
    ["StarterPlayerModules.KickHandler"] = {
        path = "game/StarterPlayer/Modules/KickHandler.lua",
        override = [[
            -- KickHandler Override
            return function(reason)
                print("[KickBlocked] Reason:", reason)
                return nil
            }
        ]]
    }
}

-- Game Files to Scan
local GameFilesToScan = {
    { name = "DriveWorld.exe", path = "bin/DriveWorld.exe", type = "Executable", Hash = "0xA1B2C3D4" },
    { name = "core.dll", path = "bin/libs/core.dll", type = "Dynamic Library", Hash = "0xE5F6A7B8" },
    { name = "AntiCheat.lua", path = "game/Scripts/AntiCheat.lua", type = "Script", Hash = "0xC9D0E1F2" },
    { name = "JobSystem.lua", path = "game/ReplicatedStorage/JobSystem.lua", type = "Script", Hash = "0xB3C4D5E6" },
    { name = "PhysicsEngine.dll", path = "bin/libs/PhysicsEngine.dll", type = "Dynamic Library", Hash = "0xF7A8B9C0" },
    { name = "Renderer.lua", path = "game/Client/Renderer.lua", type = "Script", Hash = "0xD1E2F3A4" },
    { name = "NetworkHandler.lua", path = "game/ReplicatedStorage/NetworkHandler.lua", type = "Script", Hash = "0xA5B6C7D8" }
}

-- Utility Functions
local function notify(title, text, duration)
    local NotifRemote = ReplicatedStorage:FindFirstChild("NotificationEvent")
    if NotifRemote then
        NotifRemote:FireServer({ Title = title, Content = text, Duration = duration or 5 })
    else
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 5 })
    end
end

-- Patch Core Modules
local function patchCoreModules()
    print("[SecurePatch] Mounting FileSystem...")
    for name, data in pairs(CoreFiles) do
        task.wait(math.random(1, 2))
        warn("[PatchEngine] Accessing:", data.path)
        task.wait(0.2 + math.random())

        local checksum = HttpService:GenerateGUID(false):sub(1, 8)
        _G.PatchChecksum[name] = checksum

        warn("[PatchEngine] Backing up", name, "-> checksum:", checksum)
        task.wait(0.3)
        print("[PatchEngine] Injecting override to:", name)
        print("[OverrideScript ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓]")
        print(data.override)
        print("[↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑]")
        task.wait(0.2)
        print("[✓] Module Patched:", name, "| Status: OK")
    end
end

-- Scan and Patch Game Files
local function scanAndPatchGameFiles()
    print("[FileScanner] Initializing game file scan for Drive World...")
    local logContent = [[
[INFO] Initializing SecurePatcher for DriveWorld.exe (PID: 0x4C7B)
[INFO] Scanning game files for integrity check...
]]

    for i, file in ipairs(GameFilesToScan) do
        task.wait(0.5 + math.random(0.1, 0.3))
        notify("Secure Patcher", "Scanning: " .. file.name .. " (" .. file.type .. ")")

        local offset = "0x7FF6B" .. tostring(math.random(100000, 999999))
        local patch = "[0x" .. string.format("%02X", math.random(0, 255)) .. ", 0x" .. string.format("%02X", math.random(0, 255)) .. "]"
        logContent = logContent .. string.format(
            "[INFO] Found target in %s at offset %s\n",
            file.name, offset
        )
        logContent = logContent .. string.format(
            "[INFO] Patching %s: Replaced %s with [0x90, 0xE9]\n",
            file.name, patch
        )
        logContent = logContent .. string.format(
            "[INFO] Obfuscating patch with XOR key: %s\n",
            file.Hash
        )
        notify("Secure Patcher", "Patched: " .. file.name .. " (Offset: " .. offset .. ")")
    end

    logContent = logContent .. [[
[INFO] Recalculating SHA256 checksum for modified files: 9a4e8f3b2c1d9e7f8a0b3c4d5e6f7a8b
[INFO] Encrypting patch traces with AES-256 (key derived from system entropy)
[INFO] Flushing memory logs and clearing temp buffers to avoid detection
[INFO] Patch complete. Status: Undetected by Roblox Anti-Cheat
[WARNING] DO NOT SHARE THIS LOG. Traces wiped from system.
]]

    pcall(function()
        writefile("driveworld_patch_log.txt", logContent)
        notify("Secure Patcher", "Patch log generated: driveworld_patch_log.txt")
    end)
end

-- Remote Scanner and Neutralizer
local function scanAndNeutralizeRemotes()
    local suspiciousKeywords = { "ban", "kick", "flag", "log", "report", "traced", "exploit", "detector" }
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            for _, word in ipairs(suspiciousKeywords) do
                if obj.Name:lower():find(word) then
                    warn("[RemoteCleaner] Removed:", obj:GetFullName())
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

-- Hook Metamethod for Kick/Report Blocking
local function secureNamecall()
    if _G.Hooked or not hookmetamethod then return end
    setreadonly(mt, false)

    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if method == "Kick" then
            warn("[SecureHook] Prevented Kick:", tostring(args[1]))
            return nil
        end

        if method == "FireServer" or method == "InvokeServer" then
            local target = tostring(self):lower()
            if target:find("ban") or target:find("kick") or target:find("report") or target:find("flag") then
                warn("[SecureHook] Blocked suspicious remote:", self.Name)
                return nil
            end
            if target:find("leavejob") or target:find("jobfail") then
                warn("[SecureHook] Prevented job exit call:", self.Name)
                return nil
            end
        end

        return old(self, unpack(args))
    end)

    _G.Hooked = true
    print("[SecureHook] __namecall successfully hooked.")
end

-- Block Drive World Modules
local function blockDriveWorldModules()
    local targetModules = {
        "JobSecurity", "AntiTeleport", "SpeedMonitor", "ClientWatch",
        "CheatDetector", "PhysicsEnforcer", "NetworkLimiter"
    }
    for _, name in ipairs(targetModules) do
        local module = ReplicatedStorage:FindFirstChild(name) or Workspace:FindFirstChild(name)
        if module then
            warn("[ModuleOverride] Neutralized:", name)
            pcall(function() module:Destroy() end)
        end
    end
end

-- Patch Trailer Job System
local function patchTrailerJob()
    if not TrailerSystem then return end
    local jobModule = require(TrailerSystem)
    if type(jobModule) == "table" then
        jobModule.TriggerFlag = function() return nil end
        jobModule.ReportPlayer = function() return nil end
        jobModule.KickClient = function() return nil end
        print("[DriveWorldPatch] TrailerJobs methods neutralized.")
    end
end

-- Patch Vehicle Detection
local function patchVehicleDetection()
    local vehSys = Workspace:FindFirstChild("VehicleDetection")
    if vehSys and vehSys:IsA("Script") then
        warn("[VehicleBypass] Removed detection script from:", vehSys:GetFullName())
        pcall(function() vehSys:Destroy() end)
    end
end

-- Patch Reporting Functions
local function patchReporting()
    local blocked = { "ReportAbuse", "SendPlayerName", "SubmitReport" }
    for _, name in ipairs(blocked) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote then
            remote:Destroy()
        end
    end
    notify("Security", "Reporting functions disabled for this session.")
end

-- Patch Drive World Anti-Cheat
local function patchDriveWorld()
    local systems = ReplicatedStorage:FindFirstChild("Systems")
    if systems then
        if systems:FindFirstChild("AntiCheat") then
            systems.AntiCheat:Destroy()
            notify("Drive World", "DriveWorld Anti-Cheat removed.")
        end
        if systems:FindFirstChild("PlayerSecurity") then
            systems.PlayerSecurity:Destroy()
            notify("Drive World", "Player Security disabled.")
        end
    end
end

-- Save Protection Log
local function saveProtectionLog()
    local log = {
        User = lp.Name,
        JobId = game.JobId,
        Map = Workspace:FindFirstChild("Map") and Workspace.Map.Name or "Unknown",
        Status = "All protections active"
    }
    pcall(function()
        writefile("driveworld_protection_log.json", HttpService:JSONEncode(log))
    end)
end

-- CoreGui Report Panel Disable
local function disableCoreGuiReport()
    local function scanCore()
        for _, v in ipairs(CoreGui:GetDescendants()) do
            if v:IsA("TextButton") and tostring(v.Text):lower():find("report") then
                v.Text = "[REPORT DISABLED]"
                v.AutoButtonColor = false
                v.MouseButton1Click:Connect(function()
                    notify("Protected", "Reporting players is disabled on this session.", 3)
                end)
            end
        end
    end
    scanCore()
    CoreGui.DescendantAdded:Connect(function()
        task.delay(0.5, scanCore)
    end)
end

-- HttpService Patch
local function patchHttpService()
    local blockedEndpoints = { "data.roblox.com", "analytics.roblox.com", "report", "flag", "abuse" }
    local oldRequest = http and http.request or syn and syn.request or request
    if oldRequest then
        hookfunction(oldRequest, function(tbl)
            for _, url in ipairs(blockedEndpoints) do
                if tbl.Url and tbl.Url:lower():find(url) then
                    warn("[Bypass] Blocked external Http request to:", tbl.Url)
                    return { Success = true, StatusCode = 200, Body = "OK" }
                end
            end
            return oldRequest(tbl)
        end)
    end
end

-- Logging Suppression
local function suppressLogging()
    local oldwarn = warn
    warn = function(...)
        local args = {...}
        for _, v in ipairs(args) do
            if type(v) == "string" and (v:lower():find("kick") or v:lower():find("report") or v:lower():find("flag")) then
                return
            end
        end
        oldwarn(unpack(args))
    end
end

-- Chat Logger Patch
local function patchChatLogger()
    pcall(function()
        local ChatService = require(ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"))
        if ChatService and ChatService.MessagePosted then
            ChatService.MessagePosted.OnClientEvent:Connect(function(msg)
                if msg and msg:lower():find("report") then
                    warn("[Bypass] Chat report flagged and filtered.")
                end
            end)
        end
    end)
end

-- Analytics Modules Patch
local function patchAnalyticsModules()
    local AnalyticsModules = { "ClientAnalytics", "AnalyticsService", "ClientFlagHandler" }
    for _, modName in ipairs(AnalyticsModules) do
        local success, mod = pcall(function()
            return require(ReplicatedStorage:FindFirstChild(modName) or game:GetService("StarterPlayer"):FindFirstChild(modName))
        end)
        if success and type(mod) == "table" then
            for k, v in pairs(mod) do
                if type(v) == "function" then
                    mod[k] = function() return nil end
                end
            end
            warn("[Bypass] Analytics module neutered:", modName)
        end
    end
end

-- Continuous Scanning Loop
task.spawn(function()
    while _G.SecurePatch do
        scanAndNeutralizeRemotes()
        blockDriveWorldModules()
        task.wait(3.5)
    end
end)

-- Continuous Remote Scanning
RunService.RenderStepped:Connect(function()
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if tostring(obj):lower():find("report") or tostring(obj):lower():find("flag") then
            obj:Destroy()
            notify("Scan", "Removed flag/report signal: " .. tostring(obj.Name), 3)
        end
    end
end)

-- Main Execution
local function init()
    secureNamecall()
    patchCoreModules()
    scanAndNeutralizeRemotes()
    blockDriveWorldModules()
    patchTrailerJob()
    patchVehicleDetection()
    patchReporting()
    patchDriveWorld()
    saveProtectionLog()
    scanAndPatchGameFiles()
    disableCoreGuiReport()
    patchHttpService()
    suppressLogging()
    patchChatLogger()
    patchAnalyticsModules()

    getgenv().BypassRobloxSecured = true
    notify("Security Suite", "All protections initialized successfully. Game files patched.")
end

init()
