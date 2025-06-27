local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmoothNotificationQueue"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local notifications = {}
local MAX_NOTIFICATIONS = 3

local function removeNotification(notif, callback)
	if not notif then return end

	-- ย่อหายเข้าไปตรงกลางแบบ iOS
	local shrinkTween = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(1, -20 + 130, 0, notif.Position.Y.Offset + 35), -- shrink toward center
		BackgroundTransparency = 1
	})
	shrinkTween:Play()

	for _, child in ipairs(notif:GetChildren()) do
		if child:IsA("TextLabel") then
			TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		end
	end

	shrinkTween.Completed:Connect(function()
		notif:Destroy()
		if callback then callback() end
	end)
end

local function repositionQueue()
	for i, notif in ipairs(notifications) do
		local targetY = 20 + ((i - 1) * 80)
		TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -20, 0, targetY)
		}):Play()
	end
end

local function createNotification(titleText, messageText)
	local function build()
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 260, 0, 70)
		frame.Position = UDim2.new(1, 300, 0, 20)
		frame.AnchorPoint = Vector2.new(1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0.05
		frame.Parent = screenGui
		frame.ClipsDescendants = true

		local stroke = Instance.new("UIStroke", frame)
		stroke.Thickness = 1.2
		stroke.Transparency = 0.3
		stroke.Color = Color3.fromRGB(210, 210, 210)

		local corner = Instance.new("UICorner", frame)
		corner.CornerRadius = UDim.new(0, 12)

		local title = Instance.new("TextLabel", frame)
		title.Size = UDim2.new(1, -20, 0, 22)
		title.Position = UDim2.new(0, 10, 0, 10)
		title.Text = titleText
		title.Font = Enum.Font.GothamMedium
		title.TextSize = 16
		title.TextColor3 = Color3.fromRGB(30, 30, 30)
		title.BackgroundTransparency = 1
		title.TextXAlignment = Enum.TextXAlignment.Left

		local message = Instance.new("TextLabel", frame)
		message.Size = UDim2.new(1, -20, 0, 20)
		message.Position = UDim2.new(0, 10, 0, 36)
		message.Text = messageText
		message.Font = Enum.Font.Gotham
		message.TextSize = 14
		message.TextColor3 = Color3.fromRGB(90, 90, 90)
		message.BackgroundTransparency = 1
		message.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(notifications, 1, frame)
		repositionQueue()

		TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -20, 0, 20)
		}):Play()

		local dismissed = false
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not dismissed then
				dismissed = true
				local i = table.find(notifications, frame)
				if i then table.remove(notifications, i) end
				removeNotification(frame, repositionQueue)
			end
		end)

		task.delay(4, function()
			if not dismissed and frame and frame.Parent then
				dismissed = true
				local i = table.find(notifications, frame)
				if i then table.remove(notifications, i) end
				removeNotification(frame, repositionQueue)
			end
		end)
	end

	-- ถ้ามีเกิน 3 → ลบล่างสุดก่อนสร้างใหม่
	if #notifications >= MAX_NOTIFICATIONS then
		local oldest = table.remove(notifications, #notifications)
		removeNotification(oldest, function()
			build()
		end)
	else
		build()
	end
end

-- 🧪 ทดสอบ
createNotification("NOTIFICATION", "Loading Service")
task.wait(1)
createNotification(" [ ✅ ]Debug", "Optimize successfully!!")
