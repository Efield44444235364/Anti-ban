-- รอเกมโหลดให้เสร็จ
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- Hook __namecall แบบปลอดภัย
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if typeof(self) == "Instance" and type(method) == "string" then
        -- จำกัดเฉพาะ LocalPlayer.Kick เท่านั้น
        if self == LocalPlayer and method:lower() == "kick" then
            notify("Anti-Kick", "Blocked Kick (namecall)")
            return nil
        end

        -- บล็อก Remote ที่ชื่อดูน่าสงสัย
        local name = (self.Name or ""):lower()
        if (method == "FireServer" or method == "InvokeServer") and (
            name:find("kick") or name:find("ban") or name:find("admin") or name:find("shutdown") or name:find("teleport")
        ) then
            notify("Anti-Kick", "Blocked suspicious remote: " .. name)
            return nil
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Hook Kick Function
if hookfunction then
    local oldKick = hookfunction(LocalPlayer.Kick, function(...)
        notify("Anti-Kick", "Blocked Kick() call")
        return
    end)
end

-- Hook __index แบบปลอดภัย
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if self == LocalPlayer and key:lower() == "kick" then
        notify("Anti-Kick", "Blocked .Kick access")
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

notify("Anti-Kick (Global Version)", "✅ Anti-Kick & Anti-AFK Loaded Safely")
