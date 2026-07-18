-- =============================================================================
-- SCRIPT UJI COBA: TELEPORT ONLY (DELTA EXECUTOR OPTIMIZED)
-- Fungsi: Kompatibel penuh dengan Touch Screen / Mobile & Delta API
-- =============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- [DELTA BYPASS] Mencari parent UI yang aman untuk Delta
local targetParent = CoreGui
if type(gethui) == "function" then
    pcall(function() targetParent = gethui() end)
end

-- Hapus UI lama jika ada
local oldGui = targetParent:FindFirstChild("DeltaTeleportTest")
if oldGui then oldGui:Destroy() end

-- Buat UI Dasar
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaTeleportTest"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = targetParent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header/TopBar (Untuk area geser/drag)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
topBar.BorderSizePixel = 0
topBar.Parent = frame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DELTA TELEPORT TEST"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- [DELTA FIX] Logika Geser yang Mendukung Layar Sentuh Mobile
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topBar

-- Kolom Ketik Nama
local inputName = Instance.new("TextBox")
inputName.Size = UDim2.new(0.9, 0, 0, 35)
inputName.Position = UDim2.new(0.05, 0, 0, 40)
inputName.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
inputName.PlaceholderText = "Ketik awalan nama target..."
inputName.Font = Enum.Font.GothamMedium
inputName.TextSize = 13
inputName.Text = ""
inputName.ClearTextOnFocus = false
inputName.Parent = frame
Instance.new("UICorner", inputName).CornerRadius = UDim.new(0, 5)

-- Tombol Teleport
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Position = UDim2.new(0.05, 0, 0, 85)
tpBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
tpBtn.Text = "EXECUTE TELEPORT"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
tpBtn.Parent = frame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)

-- =============================================================================
-- LOGIKA TELEPORT (MENGGUNAKAN .ACTIVATED KHUSUS DELTA/MOBILE)
-- =============================================================================
tpBtn.Activated:Connect(function()
    local searchText = string.lower(inputName.Text)
    if searchText == "" or searchText == " " then
        tpBtn.Text = "NAMA KOSONG!"
        task.wait(1)
        tpBtn.Text = "EXECUTE TELEPORT"
        return
    end

    local targetPlayer = nil
    
    -- Auto-Complete: Cari pemain yang namanya cocok dengan ketikan
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            if string.sub(string.lower(p.Name), 1, #searchText) == searchText or string.sub(string.lower(p.DisplayName), 1, #searchText) == searchText then
                targetPlayer = p
                break
            end
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = localPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            -- Bypass Teleport (Pindah ke 3 Studs di belakang target)
            myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            
            tpBtn.Text = "SUKSES TP!"
            tpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    else
        tpBtn.Text = "TIDAK DITEMUKAN!"
        tpBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    end

    task.wait(1.5)
    tpBtn.Text = "EXECUTE TELEPORT"
    tpBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

closeBtn.Activated:Connect(function()
    gui:Destroy()
end)
