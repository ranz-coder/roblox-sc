-- =============================================================================
-- PROJECT: LAPER GANK ADMIN - ANDROID SWITCH SLIDER SPEED HUD
-- TEMA: Android Mobile App (Abu-abu Gelap, Ungu & Biru Neon)
-- UTILITY: Number TextBox Input + Slider Toggle Switch Switch (ON/OFF)
-- =============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local function showNotification(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 5
		})
	end)
end

local targetParent = type(gethui) == "function" and gethui() or CoreGui
if not targetParent or not pcall(function() return targetParent.Name end) then
	targetParent = localPlayer:WaitForChild("PlayerGui")
end

local oldGui = targetParent:FindFirstChild("LaperGankAdminTeleport")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaperGankAdminTeleport"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = targetParent

showNotification("LaperGank", "Dasbor Switch Premium Siap", 5)

-- -----------------------------------------------------------------------------
-- GLOBAL STATE MAPPING
-- -----------------------------------------------------------------------------
local selectedPlayer = nil
local isTeleporting = false
local speedSettings = {
	Enabled = false,
	TargetSpeed = 50 -- Angka Speed Bawaan
}

-- -----------------------------------------------------------------------------
-- ADVANCED DYNAMIC DRAG MODULE
-- -----------------------------------------------------------------------------
local function makeDraggable(gui, dragHandle)
	local dragging, dragInput, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- -----------------------------------------------------------------------------
-- VISUAL RENDER ENGINE: LUXURY FLOATING DASHBOARD
-- -----------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 290, 0, 300)
mainFrame.Position = UDim2.new(0.5, -145, 0.4, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(138, 43, 226)
mainStroke.Thickness = 2.5
mainStroke.Parent = mainFrame

local lineGlow = Instance.new("Frame")
lineGlow.Size = UDim2.new(1, 0, 0, 2)
lineGlow.Position = UDim2.new(0, 0, 0, 42)
lineGlow.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
lineGlow.BorderSizePixel = 0
lineGlow.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 12)
topBarCover.Position = UDim2.new(0, 0, 1, -12)
topBarCover.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

makeDraggable(mainFrame, topBar)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LAPER GANK HUB v2"
title.TextColor3 = Color3.fromRGB(0, 191, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = topBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -64, 0.5, -13)
minBtn.BackgroundTransparency = 1
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Parent = topBar

local contentGrid = Instance.new("Frame")
contentGrid.Size = UDim2.new(0.92, 0, 0, 230)
contentGrid.Position = UDim2.new(0.04, 0, 0, 52)
contentGrid.BackgroundTransparency = 1
contentGrid.Parent = mainFrame

local gridLayout = Instance.new("UIListLayout")
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Padding = UDim.new(0, 10)
gridLayout.Parent = contentGrid

-- CARD 1: TELEPORT SECTOR
local cardTP = Instance.new("Frame")
cardTP.Size = UDim2.new(1, 0, 0, 95)
cardTP.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
cardTP.BorderSizePixel = 0
cardTP.LayoutOrder = 1
cardTP.Parent = contentGrid
Instance.new("UICorner", cardTP).CornerRadius = UDim.new(0, 8)
local strokeTP = Instance.new("UIStroke")
strokeTP.Color = Color3.fromRGB(45, 45, 55)
strokeTP.Parent = cardTP

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0.9, 0, 0, 36)
dropdownBtn.Position = UDim2.new(0.05, 0, 0, 10)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
dropdownBtn.Text = "Pilih Target Player..."
dropdownBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
dropdownBtn.Font = Enum.Font.GothamMedium
dropdownBtn.TextSize = 13
dropdownBtn.Parent = cardTP
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)
local dropStroke = Instance.new("UIStroke")
dropStroke.Color = Color3.fromRGB(0, 191, 255)
dropStroke.Parent = dropdownBtn

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.9, 0, 0, 36)
teleportBtn.Position = UDim2.new(0.05, 0, 0, 50)
teleportBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
teleportBtn.Text = "EXECUTE INSTAN TP"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBlack
teleportBtn.TextSize = 13
teleportBtn.Parent = cardTP
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)
local telStroke = Instance.new("UIStroke")
telStroke.Color = Color3.fromRGB(138, 43, 226)
telStroke.Parent = teleportBtn

-- CARD 2: SPEED INPUT + SLIDER SWITCH TOGGLE ON/OFF
local cardSpeed = Instance.new("Frame")
cardSpeed.Size = UDim2.new(1, 0, 0, 65)
cardSpeed.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
cardSpeed.BorderSizePixel = 0
cardSpeed.LayoutOrder = 2
cardSpeed.Parent = contentGrid
Instance.new("UICorner", cardSpeed).CornerRadius = UDim.new(0, 8)
local strokeSpeed = Instance.new("UIStroke")
strokeSpeed.Color = Color3.fromRGB(45, 45, 55)
strokeSpeed.Parent = cardSpeed

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 6)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "MASUKKAN SPEED:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 10
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = cardSpeed

-- Kolom Angka (Number Input Box)
local inputSpeed = Instance.new("TextBox")
inputSpeed.Size = UDim2.new(0.45, 0, 0, 30)
inputSpeed.Position = UDim2.new(0.05, 0, 0, 26)
inputSpeed.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
inputSpeed.Text = "50"
inputSpeed.TextColor3 = Color3.fromRGB(0, 191, 255)
inputSpeed.PlaceholderText = "Angka..."
inputSpeed.Font = Enum.Font.GothamBold
inputSpeed.TextSize = 14
inputSpeed.ClearTextOnFocus = false
inputSpeed.Parent = cardSpeed
Instance.new("UICorner", inputSpeed).CornerRadius = UDim.new(0, 6)
local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(45, 45, 55)
inputStroke.Parent = inputSpeed

-- Komponen Slider Switch (Garis Trek Belakang Sakelar)
local switchTrack = Instance.new("TextButton")
switchTrack.Size = UDim2.new(0, 45, 0, 22)
switchTrack.Position = UDim2.new(0.95, -45, 0.5, -11)
switchTrack.BackgroundColor3 = Color3.fromRGB(40, 20, 20) -- Merah Redup saat OFF
switchTrack.Text = ""
switchTrack.Parent = cardSpeed
Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
local switchStroke = Instance.new("UIStroke")
switchStroke.Color = Color3.fromRGB(255, 70, 70)
switchStroke.Parent = switchTrack

-- Bulatan Slider yang Bergeser Kanan-Kiri
local switchBall = Instance.new("Frame")
switchBall.Size = UDim2.new(0, 16, 0, 16)
switchBall.Position = UDim2.new(0, 3, 0.5, -8) -- Posisi kiri (OFF)
switchBall.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
switchBall.BorderSizePixel = 0
switchBall.Parent = switchTrack
Instance.new("UICorner", switchBall).CornerRadius = UDim.new(1, 0)

-- Text Status ON/OFF Kecil di sebelah Switch
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 40, 0, 20)
statusLabel.Position = UDim2.new(0.95, -95, 0.5, -10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.GothamBlack
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Parent = cardSpeed

-- DROPDOWN OVERLAY LIST ELEMENT
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0, 140)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 95)
scrollFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.Visible = false
scrollFrame.ZIndex = 20
scrollFrame.Active = true
scrollFrame.Parent = mainFrame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)
local scrollStroke = Instance.new("UIStroke")
scrollStroke.Color = Color3.fromRGB(0, 191, 255)
scrollStroke.Parent = scrollFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.Name
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.Parent = scrollFrame
Instance.new("UIPadding", scrollFrame).PaddingTop = UDim.new(0, 5)

-- Floating Minimize Icon
local minIcon = Instance.new("ImageButton")
minIcon.Size = UDim2.new(0, 54, 0, 54)
minIcon.Position = UDim2.new(0.5, -27, 0.2, 0)
minIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
minIcon.Image = "rbxassetid://128042443413755"
minIcon.ScaleType = Enum.ScaleType.Fit
minIcon.Visible = false
minIcon.Active = true
minIcon.Parent = screenGui
Instance.new("UICorner", minIcon).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(0, 191, 255)
iconStroke.Thickness = 2.5
iconStroke.Parent = minIcon

makeDraggable(minIcon, minIcon)

-- -----------------------------------------------------------------------------
-- MECHANIC OPERATIONAL BINDINGS
-- -----------------------------------------------------------------------------
closeBtn.Activated:Connect(function()
	speedSettings.Enabled = false
	screenGui:Destroy()
end)

minBtn.Activated:Connect(function()
	mainFrame.Visible = false
	minIcon.Position = mainFrame.Position
	minIcon.Visible = true
end)

minIcon.Activated:Connect(function()
	minIcon.Visible = false
	mainFrame.Position = minIcon.Position
	mainFrame.Visible = true
end)

local function updatePlayerList()
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0.95, 0, 0, 32)
			btn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
			btn.Text = "  " .. player.Name
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.GothamMedium
			btn.TextSize = 12
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.ZIndex = 21
			btn.Parent = scrollFrame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			
			btn.Activated:Connect(function()
				selectedPlayer = player
				dropdownBtn.Text = player.Name
				scrollFrame.Visible = false
			end)
		end
	end
end

dropdownBtn.Activated:Connect(function()
	scrollFrame.Visible = not scrollFrame.Visible
	if scrollFrame.Visible then updatePlayerList() end
end)

teleportBtn.Activated:Connect(function()
	if isTeleporting then return end
	if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		dropdownBtn.Text = "Target Tidak Ditemukan!"
		task.wait(1.5)
		dropdownBtn.Text = "Pilih Target Player..."
		return
	end
	
	local myChar = localPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	isTeleporting = true
	scrollFrame.Visible = false
	
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then
		myChar.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
	end
	
	dropdownBtn.Text = "Pilih Target Player..."
	selectedPlayer = nil
	isTeleporting = false
end)

-- -----------------------------------------------------------------------------
-- LOGIKA TEXTBOX INPUT CONTROL
-- -----------------------------------------------------------------------------
inputSpeed.FocusLost:Connect(function()
	local numericValue = tonumber(inputSpeed.Text)
	if numericValue then
		speedSettings.TargetSpeed = numericValue
	else
		inputSpeed.Text = tostring(speedSettings.TargetSpeed)
	end
end)

-- -----------------------------------------------------------------------------
-- INTERAKSI SLIDER SWITCH TOGGLE (ANIMASI GESER ON/OFF)
-- -----------------------------------------------------------------------------
switchTrack.Activated:Connect(function()
	speedSettings.Enabled = not speedSettings.Enabled
	
	local numericValue = tonumber(inputSpeed.Text)
	if numericValue then speedSettings.TargetSpeed = numericValue end
	
	if speedSettings.Enabled then
		-- Animasi Geser ke Kanan [ON] (Aksen Hijau / Ungu)
		TweenService:Create(switchBall, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
		switchTrack.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
		switchStroke.Color = Color3.fromRGB(70, 255, 70)
		statusLabel.Text = "ON"
		statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	else
		-- Animasi Geser Balik ke Kiri [OFF] (Aksen Merah)
		TweenService:Create(switchBall, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
		switchTrack.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
		switchStroke.Color = Color3.fromRGB(255, 70, 70)
		statusLabel.Text = "OFF"
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
	end
end)

-- -----------------------------------------------------------------------------
-- EMULATOR BYPASS FISIKA MOVEMENT (Konversi Angka Roblox ke Delta Stud)
-- -----------------------------------------------------------------------------
RunService.Heartbeat:Connect(function(deltaTime)
	if speedSettings.Enabled and speedSettings.TargetSpeed > 16 then
		pcall(function()
			local char = localPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChild("Humanoid")
			
			if hrp and hum and hum.MoveDirection.Magnitude > 0 then
				-- Mengonversi angka WalkSpeed Roblox murni ke kalkulasi delta fisik
				local extraStuds = (speedSettings.TargetSpeed - 16) * deltaTime
				hrp.CFrame = hrp.CFrame + (hum.MoveDirection * extraStuds)
			end
		end)
	end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()
