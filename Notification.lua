loadstring([[
    setfpscap(75)
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
    frame.Size = UDim2.new(0, 260, 0, 96) -- ขนาดกรอบเหมือนเดิม
    frame.Position = UDim2.new(1, -270, 0, -150)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 0
    frame.AutoButtonColor = false
    frame.Text = ""
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local title = Instance.new("TextLabel", frame)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.Size = UDim2.new(1, -24, 0, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14 -- ลดขนาดตัวหนังสือจาก 16 เป็น 14
    title.TextColor3 = Color3.fromRGB(30, 30, 30)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = titleText

    local desc = Instance.new("TextLabel", frame)
    desc.Position = UDim2.new(0, 12, 0, 28)
    desc.Size = UDim2.new(1, -24, 0, 60) -- ขนาดเหมือนเดิม
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11 -- ลดขนาดตัวหนังสือจาก 13 เป็น 11
    desc.TextWrapped = true
    desc.TextTruncate = Enum.TextTruncate.AtEnd
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.LineHeight = 1.15
    desc.TextColor3 = Color3.fromRGB(70, 70, 70)
    desc.Text = descriptionText

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(0, 120, 0, 16)
    hint.Position = UDim2.new(1, -270 + (260 - 120)/2, 0, -34)
    hint.BackgroundTransparency = 1
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 12
    hint.TextColor3 = Color3.fromRGB(160, 160, 160)
    hint.Text = "Click to close UI"
    hint.TextTransparency = 0.15
    hint.TextStrokeTransparency = 1
    hint.Parent = gui

    local tweenTime = 0.4
    local easing = Enum.EasingStyle.Sine
    local targetY = 30

    -- Slide in
    TweenService:Create(frame, TweenInfo.new(tweenTime, easing), {
        Position = UDim2.new(1, -270, 0, targetY)
    }):Play()
    TweenService:Create(hint, TweenInfo.new(tweenTime, easing), {
        Position = UDim2.new(1, -270 + (260 - 120)/2, 0, targetY + 100)
    }):Play()

    -- Click to close
    frame.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(tweenTime, easing), {
            Position = UDim2.new(1, 20, 0, targetY),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(hint, TweenInfo.new(tweenTime, easing), {
            Position = UDim2.new(1, 20, 0, targetY + 100),
            TextTransparency = 1
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
            TweenService:Create(hint, TweenInfo.new(tweenTime, easing), {
                Position = UDim2.new(1, 20, 0, targetY + 100),
                TextTransparency = 1
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
    "These bypass methods are specifically designed and optimized for the \"Blox Fruits , Grow a Garden\" map only Using them outside of this context may result in a detection or unstable we not recommend to use other map for this ok??????????????????????",
    7
)
]])()
