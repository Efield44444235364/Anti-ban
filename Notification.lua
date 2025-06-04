loadstring([[
setfpscap(120)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local function showNotification(titleText, descriptionText, duration)
    duration = duration or 6

    local gui = Instance.new("ScreenGui")
    gui.Name = "TouchDismissNotification"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui

    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(0, 300, 0, 120)
    frame.Position = UDim2.new(1, -310, 0, -150)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 0
    frame.AutoButtonColor = false
    frame.Text = ""
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 22)

    local title = Instance.new("TextLabel", frame)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.Size = UDim2.new(1, -28, 0, 24)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(30, 30, 30)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = titleText

    local desc = Instance.new("TextLabel", frame)
    desc.Position = UDim2.new(0, 14, 0, 36)
    desc.Size = UDim2.new(1, -28, 1, -46)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 14
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextColor3 = Color3.fromRGB(70, 70, 70)
    desc.Text = descriptionText

    local tweenTime = 0.4
    local easing = Enum.EasingStyle.Sine
    local targetY = 40

    -- Slide in
    TweenService:Create(frame, TweenInfo.new(tweenTime, easing), {
        Position = UDim2.new(1, -310, 0, targetY)
    }):Play()

    -- Dismiss on click
    frame.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(tweenTime, easing), {
            Position = UDim2.new(1, 20, 0, targetY),
            BackgroundTransparency = 1
        }):Play()
        title.TextTransparency = 1
        desc.TextTransparency = 1
        wait(tweenTime + 0.1)
        gui:Destroy()
        setfpscap(60)
    end)

    -- Auto dismiss
    task.spawn(function()
        wait(duration)
        if gui and gui.Parent then
            TweenService:Create(frame, TweenInfo.new(tweenTime, easing), {
                Position = UDim2.new(1, 20, 0, targetY),
                BackgroundTransparency = 1
            }):Play()
            title.TextTransparency = 1
            desc.TextTransparency = 1
            wait(tweenTime + 0.1)
            gui:Destroy()
            setfpscap(60)
        end
    end)
end

showNotification(
    "❌ Bypass Not Active",
    "These bypass methods are specifically designed and optimized for the \"Blox Fruits\" map only. Using them outside of this context may result in instability or detection, and is not recommended!!",
    7
)
]])()
