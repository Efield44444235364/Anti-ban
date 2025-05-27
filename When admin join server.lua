
local allowedPlaces = {
    [2753915549] = true,
    [7449423635] = true,
    [4442272183] = true
}

if not allowedPlaces[game.PlaceId] then
    warn("Anti Banned not active!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Notification = require(ReplicatedStorage.Notification)

-- ลูปตรวจสอบว่าเลือกทีมแล้วหรือยัง (แสดงเตือนครั้งเดียว)
task.spawn(function()
    local shownWarning = false

    while player.Team == nil do
        if not shownWarning then
            Notification.new("<Color=White> Choose Some team for Anti Banned active! <Color=/>"):Display()
            shownWarning = true
        end
        task.wait(1.5)
    end

    -- เมื่อเลือกทีมแล้ว แสดง Notification
    Notification.new("<Color=White> Inject Script<Color=/> <Color=Red> Bitchh! <Color=/>"):Display()
    wait(1)
    Notification.new("<Color=White> It may take <Color=Yellow>2 - 17<Color=/> seconds.<Color=/>"):Display()
    task.wait(2.5)

    -- แสดง Anti Banned Active แบบสุ่มเวลา (2 - 17 วิ)
    local duration = math.random(2, 17)
    local notif = Notification.new("<Color=White> Anti Banned forme admins <Color=/> <Color=Green>Active! <Color=/>"):Display()
    notif:Display()
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

-- ฟังก์ชันเช็คชื่อผู้เล่น
local function checkPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if blacklist[p.Name] then
            Notification.new("<Color=Yellow> The Admin " .. p.Name .. " Has Joined the servers!!<Color=/>"):Display()
            task.wait(1.9)
            game:Shutdown()
            break
        end
    end
end

-- ลูปเช็คชื่อทุก 1.5 วินาที
task.spawn(function()
    while true do
        checkPlayers()
        task.wait(1.5)
    end
end)
