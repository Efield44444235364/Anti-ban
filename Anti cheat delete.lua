-- ⚡ Fast Anti-Cheat Scanner (Optimized)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local suspiciousKeywords = {
    "hookfunction", "getrawmetatable", "checkcaller", "fireserver", "invokeserver", "kick",
    "ban", "anticheat", "monitor", "exploit", "teleport", "walkspeed", "jumppower",
    "remoteevent", "remote", "getgc", "debug", "bypass", "inject", "loadstring", "require"
}

local function fastSusCheck(str)
    str = (str and str:lower()) or ""
    local count = 0
    for i = 1, #suspiciousKeywords do
        if str:find(suspiciousKeywords[i]) then
            count += 1
            if count >= 2 then return count end -- early exit
        end
    end
    return count
end

local function scanScripts()
    local removed = 0
    for _, inst in ipairs(game:GetDescendants()) do
        if inst:IsA("LocalScript") or inst:IsA("ModuleScript") or inst:IsA("Script") then
            local name = inst.Name:lower()
            if name:find("anti") or name:find("cheat") or name:find("kick") or name:find("monitor") then
                print("🗑️ Removed by name: " .. inst:GetFullName())
                inst:Destroy()
                removed += 1
            elseif typeof(decompile) == "function" then
                local ok, src = pcall(decompile, inst)
                if ok and fastSusCheck(src) >= 2 then
                    print("🗑️ Removed suspicious: " .. inst:GetFullName())
                    inst:Destroy()
                    removed += 1
                end
            end
        end
    end
    return removed
end

local function scanGC()
    local removed = 0
    if getgc and islclosure and typeof(decompile) == "function" then
        for _, f in ipairs(getgc(true)) do
            if type(f) == "function" and islclosure(f) then
                local ok, src = pcall(decompile, f)
                if ok and fastSusCheck(src) >= 2 then
                    print("⚠️ Detected suspicious GC function")
                    removed += 1
                end
            end
        end
    end
    return removed
end

local function scanRemotes()
    local flagged = 0
    for _, inst in ipairs(game:GetDescendants()) do
        if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
            local name = inst.Name:lower()
            for i = 1, #suspiciousKeywords do
                if name:find(suspiciousKeywords[i]) then
                    print("⚠️ Suspicious remote: " .. inst:GetFullName())
                    flagged += 1
                    break
                end
            end
        end
    end
    return flagged
end

print("🔍 Fast Anti-Cheat Scan started...")
local removed = scanScripts()
removed += scanGC()
scanRemotes()
print("Scan complete. Removed " .. removed .. " suspicious script(s).")

-- === Anti-Kick/Teleport Protection ===
if hookfunction then
    pcall(function() hookfunction(LocalPlayer.Kick, function() return nil end) end)
    pcall(function() hookfunction(TeleportService.Teleport, function() return nil end) end)
    pcall(function() hookfunction(TeleportService.TeleportAsync, function() return nil end) end)
    pcall(function() hookfunction(LocalPlayer.LoadCharacter, function() return nil end) end)
end
