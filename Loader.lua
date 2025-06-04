local hasFpsCap = (type(setfpscap) == "function")

if not hasFpsCap then
    warn("Your executor does not support some script")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ff/refs/heads/main/MoreUNC.lua"))()
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Anti-ban/refs/heads/main/When%20admin%20join%20server.lua"))()


if FPSOptimize == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Efield44444235364/Ff/refs/heads/main/BoostFPS.lua"))()
end
