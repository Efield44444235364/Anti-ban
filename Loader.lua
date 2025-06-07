-- Loader.lua (อันนี้คือสคริปต์ที่คุณให้ไว้ปรับใหม่)

_G.efield_loader = true  -- ตั้งตัวแปรบอกว่าโหลดผ่าน Loader

local hasFpsCap = (type(setfpscap) == "function")

if not hasFpsCap then
    warn("Your executor does not support some script")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ff/refs/heads/main/MoreUNC.lua"))()
end

-- โหลดสคริปต์หลักโดยให้สคริปต์หลักตรวจสอบ _G.efield_loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/When%20admin%20join%20server.lua"))()


if FPSOptimize == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ff/refs/heads/main/BoostFPS.lua"))()
end



-- Kick Online 
while true do
    
end
