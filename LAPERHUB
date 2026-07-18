local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

local function makeDraggable(gui, dragHandle)
	local dragging, dragInput, dragStart, startPos
	
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaperGankTeleportGui"
screenGui.ResetOnSpawn = false

local success, err = pcall(function() screenGui.Parent = CoreGui end)
if not success then screenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.8, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCornerMain = Instance.new("UICorner")
uiCornerMain.CornerRadius = UDim.new(0, 12)
uiCornerMain.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local uiCornerTop = Instance.new("UICorner")
uiCornerTop.CornerRadius = UDim.new(0, 12)
uiCornerTop.Parent = topBar

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 10)
topBarCover.Position = UDim2.new(0, 0, 1, -10)
topBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

makeDraggable(mainFrame, topBar)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LAPER GANK"
title.TextColor3 = Color3.fromRGB(255, 60, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = topBar
local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(1, 0)
uiCornerClose.Parent = closeBtn
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
minBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = topBar
local uiCornerMin = Instance.new("UICorner")
uiCornerMin.CornerRadius = UDim.new(1, 0)
uiCornerMin.Parent = minBtn

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0.9, 0, 0, 35)
dropdownBtn.Position = UDim2.new(0.05, 0, 0, 55)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
dropdownBtn.Text = "Pilih Target..."
dropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
dropdownBtn.Font = Enum.Font.GothamMedium
dropdownBtn.TextSize = 14
dropdownBtn.Parent = mainFrame
local uiCornerDrop = Instance.new("UICorner")
uiCornerDrop.CornerRadius = UDim.new(0, 8)
uiCornerDrop.Parent = dropdownBtn

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
teleportBtn.Position = UDim2.new(0.05, 0, 0, 100)
teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
teleportBtn.Text = "EXECUTE TELEPORT"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14
teleportBtn.Parent = mainFrame
local uiCornerTel = Instance.new("UICorner")
uiCornerTel.CornerRadius = UDim.new(0, 8)
uiCornerTel.Parent = teleportBtn

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0, 120)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 95)
scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.Visible = false
scrollFrame.ZIndex = 5
scrollFrame.Parent = mainFrame
local uiCornerScroll = Instance.new("UICorner")
uiCornerScroll.CornerRadius = UDim.new(0, 8)
uiCornerScroll.Parent = scrollFrame
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.Name
uiListLayout.Padding = UDim.new(0, 3)
uiListLayout.Parent = scrollFrame

local minIcon = Instance.new("ImageButton")
minIcon.Size = UDim2.new(0, 50, 0, 50)
minIcon.Position = UDim2.new(0.5, -25, 0.8, -25)
minIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
minIcon.Image = "rbxassetid://128042443413755"
minIcon.ScaleType = Enum.ScaleType.Fit
minIcon.Visible = false
minIcon.Parent = screenGui

local uiCornerIcon = Instance.new("UICorner")
uiCornerIcon.CornerRadius = UDim.new(0, 10)
uiCornerIcon.Parent = minIcon

makeDraggable(minIcon, minIcon)

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Visible = false
loadingFrame.ZIndex = 10
loadingFrame.Parent = screenGui

local skeletonImage = Instance.new("ImageLabel")
skeletonImage.Size = UDim2.new(0, 160, 0, 160)
skeletonImage.Position = UDim2.new(0.5, -80, 0.45, -80)
skeletonImage.BackgroundTransparency = 1
skeletonImage.Image = "rbxassetid://128042443413755"
skeletonImage.ImageTransparency = 1
skeletonImage.ScaleType = Enum.ScaleType.Fit
skeletonImage.ZIndex = 11
skeletonImage.Parent = loadingFrame

local loadingCircle = Instance.new("ImageLabel")
loadingCircle.Size = UDim2.new(0, 210, 0, 210)
loadingCircle.Position = UDim2.new(0.5, -105, 0.45, -105)
loadingCircle.BackgroundTransparency = 1
loadingCircle.Image = "rbxassetid://128042443413755"
loadingCircle.ImageTransparency = 1
loadingCircle.ZIndex = 12
loadingCircle.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 40)
loadingText.Position = UDim2.new(0, 0, 0.45, 120)
loadingText.BackgroundTransparency = 1
loadingText.Text = "LAPER GANK"
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.Font = Enum.Font.GothamBlack
loadingText.TextSize = 32
loadingText.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
loadingText.TextStrokeTransparency = 0.3
loadingText.TextTransparency = 1
loadingText.ZIndex = 13
loadingText.Parent = loadingFrame

local rotationTweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
local rotateTween = TweenService:Create(loadingCircle, rotationTweenInfo, {Rotation = 360})

local selectedPlayer = nil

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	minIcon.Visible = true
	minIcon.Position = mainFrame.Position
end)

minIcon.MouseButton1Click:Connect(function()
	minIcon.Visible = false
	mainFrame.Visible = true
	mainFrame.Position = minIcon.Position
end)

local function updatePlayerList()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			btn.Text = player.Name
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			btn.ZIndex = 6
			btn.Parent = scrollFrame
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 6)
			btnCorner.Parent = btn
			
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = player
				dropdownBtn.Text = player.Name
				scrollFrame.Visible = false
			end)
		end
	end
end

dropdownBtn.MouseButton1Click:Connect(function()
	scrollFrame.Visible = not scrollFrame.Visible
	if scrollFrame.Visible then
		updatePlayerList()
	end
end)

teleportBtn.MouseButton1Click:Connect(function()
	if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		dropdownBtn.Text = "Target Tidak Ditemukan!"
		task.wait(1)
		dropdownBtn.Text = "Pilih Target..."
		return
	end
	
	local myChar = localPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	
	loadingFrame.Visible = true
	rotateTween:Play()
	
	local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(loadingFrame, fadeInfo, {BackgroundTransparency = 0.25}):Play()
	TweenService:Create(skeletonImage, fadeInfo, {ImageTransparency = 0}):Play()
	TweenService:Create(loadingCircle, fadeInfo, {ImageTransparency = 0}):Play()
	TweenService:Create(loadingText, fadeInfo, {TextTransparency = 0, TextStrokeTransparency = 0.3}):Play()
	
	task.wait(2.5) 
	
	local targetCFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
	myChar.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 0, 3) 
	
	local fadeOutInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	TweenService:Create(loadingFrame, fadeOutInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(skeletonImage, fadeOutInfo, {ImageTransparency = 1}):Play()
	TweenService:Create(loadingCircle, fadeOutInfo, {ImageTransparency = 1}):Play()
	TweenService:Create(loadingText, fadeOutInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	
	task.wait(0.4)
	
	rotateTween:Cancel()
	loadingCircle.Rotation = 0
	loadingFrame.Visible = false
	
	dropdownBtn.Text = "Pilih Target..."
	selectedPlayer = nil
end)
