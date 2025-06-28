
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- 🌫️ สร้าง Blur พื้นหลัง
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(1), {Size = 24}):Play()

-- 🖼️ สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "iOSNotificationUI"

-- 🖼️ Frame หลัก (โปร่งใส)
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromScale(0.5, 0.3)
Frame.Position = UDim2.fromScale(0.25, 0.35)
Frame.ClipsDescendants = true

-- 🏷️ Title: Notification
local Title = Instance.new("TextLabel", Frame)
Title.Text = "Notification"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Size = UDim2.fromScale(1, 0.3)
Title.Position = UDim2.fromScale(0, 0)
Title.BackgroundTransparency = 1
Title.TextTransparency = 1

-- ━━━ เส้นขีดสีขาว ปลายมน
local Line = Instance.new("Frame", Frame)
Line.BackgroundColor3 = Color3.new(1, 1, 1)
Line.BackgroundTransparency = 0
Line.Size = UDim2.new(0, 0, 0, 2) -- เริ่มเล็ก
Line.Position = UDim2.new(0.5, 0, 0.35, 0)
Line.AnchorPoint = Vector2.new(0.5, 0)
Line.BorderSizePixel = 0
local corner = Instance.new("UICorner", Line)
corner.CornerRadius = UDim.new(1, 0) -- ปลายมนสุด

-- 📝 ข้อความหลัก
local Body = Instance.new("TextLabel", Frame)
Body.Text = "The Auto Execute have some issues bug\nif you Set Antikick = true\nYou Can't use Auto Execute \n sorry for issues bug"
Body.TextColor3 = Color3.new(1, 1, 1)
Body.Font = Enum.Font.Gotham
Body.TextScaled = true
Body.Size = UDim2.fromScale(1, 0.4)
Body.Position = UDim2.fromScale(0, 0.5)
Body.BackgroundTransparency = 1
Body.TextTransparency = 1

-- ▶️ เริ่มอนิเมชัน
TweenService:Create(Frame, TweenInfo.new(0.2), {}):Play()
task.wait(0.2)

TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0}):Play()

task.wait(0.5)
TweenService:Create(Line, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0.8, 0, 0, 2)
}):Play()

task.delay(1.5, function()
	TweenService:Create(Body, TweenInfo.new(1), {TextTransparency = 0}):Play()
end)

-- ⏳ ปิดทุกอย่างพร้อมกัน หลัง 12 วิ
task.delay(12, function()
	local titleFadeOut = TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 1})
	local bodyFadeOut = TweenService:Create(Body, TweenInfo.new(1), {TextTransparency = 1})
	local lineShrink = TweenService:Create(Line, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 2)
	})
	local blurFadeOut = TweenService:Create(blur, TweenInfo.new(1), {Size = 0})

	titleFadeOut:Play()
	bodyFadeOut:Play()
	lineShrink:Play()
	blurFadeOut:Play()

	-- รออนิเมชันจบก่อนลบทิ้งทั้งหมด
	titleFadeOut.Completed:Wait()

	blur:Destroy()
	ScreenGui:Destroy()
end)




--[[
-- ✅ External toggle (set before loadstring)
if Antikick == nil then
    Antikick = true
end

-- ⚙️ Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- ✅ AntiKick Master System
if Antikick then
    -- === Fast Anti-Cheat Scanner ===
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
                if count >= 2 then return count end
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
    print("✅ Fast Scan complete. Removed " .. removed .. " suspicious script(s).") 

    -- === Anti-Kick & Teleport Protection ===
    if hookfunction then
        pcall(function() hookfunction(LocalPlayer.Kick, function() return nil end) end)
        pcall(function() hookfunction(TeleportService.Teleport, function() return nil end) end)
        pcall(function() hookfunction(TeleportService.TeleportAsync, function() return nil end) end)
        pcall(function() hookfunction(LocalPlayer.LoadCharacter, function() return nil end) end)
        print("🛡️ Kick/Teleport protection active")
    end
end

task.wait(2)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/Delnoti"))()
--]]
