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

-- ลูปตรวจสอบว่าเลือกทีมแล้วหรือยัง
task.spawn(function()
    while player.Team == nil do
        print("setteam")
        -- หรือจะใส่คำสั่งเปลี่ยนทีมอัตโนมัติก็ได้ เช่น:
        -- ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        task.wait(1)
    end

    -- เมื่อเลือกทีมแล้ว แสดง Notification
    local Notification = require(ReplicatedStorage.Notification)
    Notification.new("<Color=White> Inject Script<Color=/> <Color=Red> Bitchh! <Color=/>"):Display()
   task.wait(2.5)
    local Notification = require(ReplicatedStorage.Notification)
    Notification.new("<Color=White> Anti Banned forme admins <Color=/> <Color=Green>Active! <Color=/>"):Display()
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
            game:Shutdown()
            break
        end
    end
end

-- ลูปเช็คชื่อทุก 2.5 วินาที
task.spawn(function()
    while true do
        checkPlayers()
        task.wait(1.5)
    end
end)
