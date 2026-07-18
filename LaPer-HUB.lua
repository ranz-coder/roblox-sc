-- =============================================================================
-- VIOLENCE DISTRICT — ADMIN GUI (Client)
-- Taruh di: StarterPlayerScripts (sebagai LocalScript)
-- GUI ini TIDAK punya hak eksekusi apa pun — semua aksi lewat Remote ke server,
-- yang akan menolak siapa pun yang belum lolos password.
-- =============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local remoteFolder = ReplicatedStorage:WaitForChild("AdminRemotes")
local SubmitPasswordRemote = remoteFolder:WaitForChild("SubmitPassword")
local CheckAdminRemote = remoteFolder:WaitForChild("CheckAdminStatus")
local TeleportRemote = remoteFolder:WaitForChild("TeleportToPlayer")
local ESPRemote = remoteFolder:WaitForChild("ToggleESP")
local GetPlayerListRemote = remoteFolder:WaitForChild("GetPlayerList")
local ESPStateEvent = remoteFolder:WaitForChild("ESPStateChanged")

-- -----------------------------------------------------------------------------
-- PALET WARNA
-- -----------------------------------------------------------------------------
local COLOR_BG        = Color3.fromRGB(24, 24, 28)
local COLOR_CARD      = Color3.fromRGB(34, 34, 40)
local COLOR_CARD_HOVER= Color3.fromRGB(44, 42, 54)
local COLOR_PURPLE    = Color3.fromRGB(139, 92, 246)
local COLOR_BLUE      = Color3.fromRGB(59, 130, 246)
local COLOR_TEXT      = Color3.fromRGB(235, 235, 240)
local COLOR_SUBTEXT   = Color3.fromRGB(150, 150, 160)
local COLOR_DANGER    = Color3.fromRGB(239, 68, 68)

-- -----------------------------------------------------------------------------
-- ROOT GUI
-- -----------------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "VD_AdminGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- -----------------------------------------------------------------------------
-- HELPER: rounded corner + drag (dipakai berulang, ini yang memperbaiki bug "tidak bisa digeser")
-- -----------------------------------------------------------------------------
local function corner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = inst
    return c
end

local function enableDrag(dragHandle, moveFrame)
    local dragging = false
    local dragStart, startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        moveFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    -- Fallback global (penting untuk touch di sebagian executor/device — ini yang
    -- sering jadi penyebab "tidak bisa digeser" kalau cuma pakai listener lokal)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)
end

-- =============================================================================
-- 1. PASSWORD GATE — tampil untuk SEMUA pemain saat join
-- =============================================================================
local gateFrame = Instance.new("Frame")
gateFrame.Name = "PasswordGate"
gateFrame.Size = UDim2.new(0, 240, 0, 130)
gateFrame.Position = UDim2.new(1, -256, 1, -146)
gateFrame.AnchorPoint = Vector2.new(0, 0)
gateFrame.BackgroundColor3 = COLOR_BG
gateFrame.BackgroundTransparency = 0.05
gateFrame.BorderSizePixel = 0
gateFrame.Active = true
gateFrame.Parent = gui
corner(gateFrame, 14)

local gateStroke = Instance.new("UIStroke")
gateStroke.Color = COLOR_PURPLE
gateStroke.Thickness = 1
gateStroke.Transparency = 0.4
gateStroke.Parent = gateFrame

local gateTitle = Instance.new("TextLabel")
gateTitle.Size = UDim2.new(1, -20, 0, 24)
gateTitle.Position = UDim2.new(0, 10, 0, 10)
gateTitle.BackgroundTransparency = 1
gateTitle.Text = "ADMIN ACCESS"
gateTitle.Font = Enum.Font.GothamBold
gateTitle.TextSize = 13
gateTitle.TextColor3 = COLOR_TEXT
gateTitle.TextXAlignment = Enum.TextXAlignment.Left
gateTitle.Parent = gateFrame

local gateBox = Instance.new("TextBox")
gateBox.Size = UDim2.new(1, -20, 0, 34)
gateBox.Position = UDim2.new(0, 10, 0, 42)
gateBox.BackgroundColor3 = COLOR_CARD
gateBox.TextColor3 = COLOR_TEXT
gateBox.PlaceholderText = "Enter password"
gateBox.PlaceholderColor3 = COLOR_SUBTEXT
gateBox.Text = ""
gateBox.ClearTextOnFocus = false
gateBox.TextSize = 13
gateBox.Font = Enum.Font.Gotham
gateBox.Parent = gateFrame
corner(gateBox, 8)

local gateBtn = Instance.new("TextButton")
gateBtn.Size = UDim2.new(1, -20, 0, 32)
gateBtn.Position = UDim2.new(0, 10, 0, 84)
gateBtn.BackgroundColor3 = COLOR_PURPLE
gateBtn.Text = "SUBMIT"
gateBtn.Font = Enum.Font.GothamBold
gateBtn.TextSize = 12
gateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
gateBtn.Parent = gateFrame
corner(gateBtn, 8)

enableDrag(gateFrame, gateFrame)

-- =============================================================================
-- 2. ADMIN PANEL — dibuat sekali, tersembunyi sampai password benar
-- =============================================================================
local panel = Instance.new("Frame")
panel.Name = "AdminPanel"
panel.Size = UDim2.new(0, 260, 0, 380)
panel.Position = UDim2.new(0.5, -130, 0.5, -190)
panel.BackgroundColor3 = COLOR_BG
panel.BorderSizePixel = 0
panel.Active = true
panel.Visible = false
panel.Parent = gui
corner(panel, 16)

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = COLOR_BLUE
panelStroke.Thickness = 1
panelStroke.Transparency = 0.5
panelStroke.Parent = panel

-- TOP BAR (drag handle)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = COLOR_CARD
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.Parent = panel
corner(topBar, 16)

local topBarCover = Instance.new("Frame") -- menutup sudut bawah topbar
topBarCover.Size = UDim2.new(1, 0, 0, 12)
topBarCover.Position = UDim2.new(0, 0, 1, -12)
topBarCover.BackgroundColor3 = COLOR_CARD
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new(COLOR_PURPLE, COLOR_BLUE)
titleGradient.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -76, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "VD ADMIN PANEL"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0.5, -15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = topBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -68, 0.5, -15)
minBtn.BackgroundTransparency = 1
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Parent = topBar

enableDrag(topBar, panel)

-- SECTION LABEL
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, -28, 0, 18)
listLabel.Position = UDim2.new(0, 14, 0, 50)
listLabel.BackgroundTransparency = 1
listLabel.Text = "PLAYERS"
listLabel.Font = Enum.Font.GothamBold
listLabel.TextSize = 11
listLabel.TextColor3 = COLOR_SUBTEXT
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = panel

-- SCROLLING PLAYER LIST (kartu)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -28, 0, 140)
scrollFrame.Position = UDim2.new(0, 14, 0, 72)
scrollFrame.BackgroundColor3 = COLOR_CARD
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = COLOR_PURPLE
scrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Active = true
scrollFrame.Parent = panel
corner(scrollFrame, 10)

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = scrollFrame

-- TELEPORT BUTTON
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(1, -28, 0, 40)
teleportBtn.Position = UDim2.new(0, 14, 0, 222)
teleportBtn.BackgroundColor3 = COLOR_CARD
teleportBtn.Text = "SELECT A PLAYER"
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 12
teleportBtn.TextColor3 = COLOR_SUBTEXT
teleportBtn.Parent = panel
corner(teleportBtn, 10)

-- ESP TOGGLES
local espBoxBtn = Instance.new("TextButton")
espBoxBtn.Size = UDim2.new(1, -28, 0, 38)
espBoxBtn.Position = UDim2.new(0, 14, 0, 270)
espBoxBtn.BackgroundColor3 = COLOR_CARD
espBoxBtn.Text = "ESP BOX: OFF"
espBoxBtn.Font = Enum.Font.GothamBold
espBoxBtn.TextSize = 12
espBoxBtn.TextColor3 = COLOR_SUBTEXT
espBoxBtn.Parent = panel
corner(espBoxBtn, 10)

local espNameBtn = Instance.new("TextButton")
espNameBtn.Size = UDim2.new(1, -28, 0, 38)
espNameBtn.Position = UDim2.new(0, 14, 0, 314)
espNameBtn.BackgroundColor3 = COLOR_CARD
espNameBtn.Text = "ESP NAME: OFF"
espNameBtn.Font = Enum.Font.GothamBold
espNameBtn.TextSize = 12
espNameBtn.TextColor3 = COLOR_SUBTEXT
espNameBtn.Parent = panel
corner(espNameBtn, 10)

-- FLOATING MINIMIZE ICON
local minIcon = Instance.new("ImageButton")
minIcon.Size = UDim2.new(0, 52, 0, 52)
minIcon.Position = UDim2.new(0, 20, 1, -90)
minIcon.BackgroundColor3 = COLOR_BG
minIcon.Image = "" -- taruh assetid ikon kamu sendiri di sini
minIcon.ScaleType = Enum.ScaleType.Fit
minIcon.Visible = false
minIcon.Active = true
minIcon.Parent = gui
corner(minIcon, 26)

local minIconStroke = Instance.new("UIStroke")
minIconStroke.Color = COLOR_PURPLE
minIconStroke.Thickness = 2
minIconStroke.Parent = minIcon

local minIconLabel = Instance.new("TextLabel") -- fallback kalau Image kosong
minIconLabel.Size = UDim2.new(1, 0, 1, 0)
minIconLabel.BackgroundTransparency = 1
minIconLabel.Text = "VD"
minIconLabel.Font = Enum.Font.GothamBold
minIconLabel.TextSize = 14
minIconLabel.TextColor3 = COLOR_TEXT
minIconLabel.Parent = minIcon

enableDrag(minIcon, minIcon)

-- -----------------------------------------------------------------------------
-- STATE
-- -----------------------------------------------------------------------------
local selectedPlayer = nil
local espBoxOn, espNameOn = false, false
local playerCards = {}

-- -----------------------------------------------------------------------------
-- REFRESH PLAYER LIST (dari server — memperbaiki bug "tidak muncul apa apa")
-- -----------------------------------------------------------------------------
local function refreshPlayerList()
    for _, card in pairs(playerCards) do
        card:Destroy()
    end
    playerCards = {}

    local ok, list = pcall(function()
        return GetPlayerListRemote:InvokeServer()
    end)
    if not ok or type(list) ~= "table" then return end

    for _, entry in ipairs(list) do
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(1, 0, 0, 32)
        card.BackgroundColor3 = COLOR_CARD_HOVER
        card.Text = "  " .. entry.Name
        card.TextColor3 = COLOR_TEXT
        card.Font = Enum.Font.GothamMedium
        card.TextSize = 12
        card.TextXAlignment = Enum.TextXAlignment.Left
        card.AutoButtonColor = false
        card.Parent = scrollFrame
        corner(card, 8)

        card.Activated:Connect(function()
            selectedPlayer = entry.Name
            for _, c in pairs(playerCards) do
                c.BackgroundColor3 = COLOR_CARD_HOVER
            end
            card.BackgroundColor3 = COLOR_PURPLE
            teleportBtn.Text = "TELEPORT TO " .. entry.Name
            teleportBtn.BackgroundColor3 = COLOR_PURPLE
            teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(playerCards, card)
    end
end

Players.PlayerAdded:Connect(function()
    if panel.Visible then refreshPlayerList() end
end)
Players.PlayerRemoving:Connect(function()
    if panel.Visible then refreshPlayerList() end
end)

-- -----------------------------------------------------------------------------
-- UNLOCK PANEL setelah password benar
-- -----------------------------------------------------------------------------
local function unlockPanel()
    gateFrame:Destroy()
    panel.Visible = true
    refreshPlayerList()
end

gateBtn.Activated:Connect(function()
    local password = gateBox.Text
    if password == "" then return end

    gateBtn.Text = "CHECKING..."
    local ok, success, message = pcall(function()
        return SubmitPasswordRemote:InvokeServer(password)
    end)

    if ok and success then
        unlockPanel()
    else
        gateBtn.Text = "WRONG PASSWORD"
        gateBtn.BackgroundColor3 = COLOR_DANGER
        task.wait(1.2)
        gateBtn.Text = "SUBMIT"
        gateBtn.BackgroundColor3 = COLOR_PURPLE
        gateBox.Text = ""
    end
end)

-- Cek kalau player ini sudah pernah jadi admin sebelumnya (dari DataStore) → langsung buka
task.spawn(function()
    local ok, alreadyAdmin = pcall(function()
        return CheckAdminRemote:InvokeServer()
    end)
    if ok and alreadyAdmin then
        unlockPanel()
    end
end)

-- -----------------------------------------------------------------------------
-- CLOSE / MINIMIZE
-- -----------------------------------------------------------------------------
closeBtn.Activated:Connect(function()
    if espBoxOn then ESPRemote:FireServer("Box", false) end
    if espNameOn then ESPRemote:FireServer("Name", false) end
    panel.Visible = false
    minIcon.Visible = false
end)

minBtn.Activated:Connect(function()
    panel.Visible = false
    minIcon.Visible = true
end)

minIcon.Activated:Connect(function()
    minIcon.Visible = false
    panel.Visible = true
end)

-- -----------------------------------------------------------------------------
-- ESP TOGGLES
-- -----------------------------------------------------------------------------
espBoxBtn.Activated:Connect(function()
    espBoxOn = not espBoxOn
    ESPRemote:FireServer("Box", espBoxOn)
    if espBoxOn then
        espBoxBtn.Text = "ESP BOX: ON"
        espBoxBtn.BackgroundColor3 = COLOR_BLUE
        espBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espBoxBtn.Text = "ESP BOX: OFF"
        espBoxBtn.BackgroundColor3 = COLOR_CARD
        espBoxBtn.TextColor3 = COLOR_SUBTEXT
    end
end)

espNameBtn.Activated:Connect(function()
    espNameOn = not espNameOn
    ESPRemote:FireServer("Name", espNameOn)
    if espNameOn then
        espNameBtn.Text = "ESP NAME: ON"
        espNameBtn.BackgroundColor3 = COLOR_BLUE
        espNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espNameBtn.Text = "ESP NAME: OFF"
        espNameBtn.BackgroundColor3 = COLOR_CARD
        espNameBtn.TextColor3 = COLOR_SUBTEXT
    end
end)

-- -----------------------------------------------------------------------------
-- TELEPORT
-- -----------------------------------------------------------------------------
teleportBtn.Activated:Connect(function()
    if not selectedPlayer then return end
    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    if not targetPlayer then
        teleportBtn.Text = "PLAYER LEFT"
        teleportBtn.BackgroundColor3 = COLOR_DANGER
        task.wait(1.2)
        teleportBtn.Text = "SELECT A PLAYER"
        teleportBtn.BackgroundColor3 = COLOR_CARD
        teleportBtn.TextColor3 = COLOR_SUBTEXT
        selectedPlayer = nil
        return
    end
    TeleportRemote:FireServer(targetPlayer)
end)
