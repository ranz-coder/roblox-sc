local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local CoreGui = game:GetService("CoreGui")

local UserInputService = game:GetService("UserInputService")

local StarterGui = game:GetService("StarterGui")



local localPlayer = Players.LocalPlayer



-- Fungsi Notifikasi Bawaan Roblox

local function showNotification(title, text, duration)

pcall(function()

StarterGui:SetCore("SendNotification", {

Title = title,

Text = text,

Duration = duration or 5

})

end)

end



-- Proteksi & Cek Map/Support (Sistem Admin Teleport Anda)

local isSupported = true -- Ubah ke false jika ingin test kondisi "tidak mendukung"

if not isSupported then

showNotification("LaperGank", "LaperGank gak mendukung", 5)

return

end



-- Fungsi Drag UI Moderen

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



-- Inisialisasi GUI utama

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "LaperGankAdminTeleport"

screenGui.ResetOnSpawn = false



-- Mengamankan UI ke CoreGui/PlayerGui

local success, err = pcall(function() screenGui.Parent = CoreGui end)

if not success then 

local pguiSuccess = pcall(function() screenGui.Parent = localPlayer:WaitForChild("PlayerGui") end)

if not pguiSuccess then

showNotification("LaperGank", "Sory!! LaperGank lagi kenyang", 5)

return

end

end



-- Notifikasi Berhasil Di-load

showNotification("LaperGank", "LaperGank mendukung", 5)



-- Frame Utama UI (Dibuat Lebih Tipis & Clean)

local mainFrame = Instance.new("Frame")

mainFrame.Size = UDim2.new(0, 260, 0, 150)

mainFrame.Position = UDim2.new(0.5, -130, 0.5, -75)

mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

mainFrame.BorderSizePixel = 0

mainFrame.Parent = screenGui



local uiCornerMain = Instance.new("UICorner")

uiCornerMain.CornerRadius = UDim.new(0, 10)

uiCornerMain.Parent = mainFrame



-- Top Bar (Header)

local topBar = Instance.new("Frame")

topBar.Size = UDim2.new(1, 0, 0, 35)

topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

topBar.BorderSizePixel = 0

topBar.Parent = mainFrame



local uiCornerTop = Instance.new("UICorner")

uiCornerTop.CornerRadius = UDim.new(0, 10)

uiCornerTop.Parent = topBar



local topBarCover = Instance.new("Frame")

topBarCover.Size = UDim2.new(1, 0, 0, 10)

topBarCover.Position = UDim2.new(0, 0, 1, -10)

topBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

topBarCover.BorderSizePixel = 0

topBarCover.Parent = topBar



makeDraggable(mainFrame, topBar)



-- Judul UI

local title = Instance.new("TextLabel")

title.Size = UDim2.new(0.6, 0, 1, 0)

title.Position = UDim2.new(0.05, 0, 0, 0)

title.BackgroundTransparency = 1

title.Text = "LAPER GANK ADMIN"

title.TextColor3 = Color3.fromRGB(255, 60, 60)

title.Font = Enum.Font.GothamBold

title.TextSize = 14

title.TextXAlignment = Enum.TextXAlignment.Left

title.Parent = topBar



-- Tombol Close

local closeBtn = Instance.new("TextButton")

closeBtn.Size = UDim2.new(0, 22, 0, 22)

closeBtn.Position = UDim2.new(1, -27, 0.5, -11)

closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

closeBtn.Text = "×"

closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

closeBtn.Font = Enum.Font.GothamBold

closeBtn.TextSize = 16

closeBtn.Parent = topBar

local uiCornerClose = Instance.new("UICorner")

uiCornerClose.CornerRadius = UDim.new(1, 0)

uiCornerClose.Parent = closeBtn



-- Tombol Minimize

local minBtn = Instance.new("TextButton")

minBtn.Size = UDim2.new(0, 22, 0, 22)

minBtn.Position = UDim2.new(1, -54, 0.5, -11)

minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

minBtn.Text = "-"

minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

minBtn.Font = Enum.Font.GothamBold

minBtn.TextSize = 16

minBtn.Parent = topBar

local uiCornerMin = Instance.new("UICorner")

uiCornerMin.CornerRadius = UDim.new(1, 0)

uiCornerMin.Parent = minBtn



-- Dropdown Pilihan Player

local dropdownBtn = Instance.new("TextButton")

dropdownBtn.Size = UDim2.new(0.9, 0, 0, 35)

dropdownBtn.Position = UDim2.new(0.05, 0, 0, 50)

dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)

dropdownBtn.Text = "Pilih Target..."

dropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

dropdownBtn.Font = Enum.Font.GothamMedium

dropdownBtn.TextSize = 13

dropdownBtn.Parent = mainFrame

local uiCornerDrop = Instance.new("UICorner")

uiCornerDrop.CornerRadius = UDim.new(0, 6)

uiCornerDrop.Parent = dropdownBtn



-- Tombol Teleport Utama

local teleportBtn = Instance.new("TextButton")

teleportBtn.Size = UDim2.new(0.9, 0, 0, 35)

teleportBtn.Position = UDim2.new(0.05, 0, 0, 95)

teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

teleportBtn.Text = "EXECUTE TELEPORT"

teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

teleportBtn.Font = Enum.Font.GothamBold

teleportBtn.TextSize = 13

teleportBtn.Parent = mainFrame

local uiCornerTel = Instance.new("UICorner")

uiCornerTel.CornerRadius = UDim.new(0, 6)

uiCornerTel.Parent = teleportBtn



-- Scrolling Frame Daftar Player

local scrollFrame = Instance.new("ScrollingFrame")

scrollFrame.Size = UDim2.new(0.9, 0, 0, 100)

scrollFrame.Position = UDim2.new(0.05, 0, 0, 90)

scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)

scrollFrame.BorderSizePixel = 0

scrollFrame.ScrollBarThickness = 4

scrollFrame.Visible = false

scrollFrame.ZIndex = 5

scrollFrame.Parent = mainFrame

local uiCornerScroll = Instance.new("UICorner")

uiCornerScroll.CornerRadius = UDim.new(0, 6)

uiCornerScroll.Parent = scrollFrame

local uiListLayout = Instance.new("UIListLayout")

uiListLayout.SortOrder = Enum.SortOrder.Name

uiListLayout.Padding = UDim.new(0, 3)

uiListLayout.Parent = scrollFrame



-- Icon Perkecil/Minimize (Bentuk Bundar)

local minIcon = Instance.new("TextButton")

minIcon.Size = UDim2.new(0, 45, 0, 45)

minIcon.Position = UDim2.new(0.5, -22.5, 0.8, -22.5)

minIcon.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

minIcon.Text = "LG"

minIcon.TextColor3 = Color3.fromRGB(255, 255, 255)

minIcon.Font = Enum.Font.GothamBold

minIcon.TextSize = 14

minIcon.Visible = false

minIcon.Parent = screenGui

local uiCornerIcon = Instance.new("UICorner")

uiCornerIcon.CornerRadius = UDim.new(1, 0)

uiCornerIcon.Parent = minIcon



makeDraggable(minIcon, minIcon)



local selectedPlayer = nil

local isTeleporting = false



-- Logika Tombol Keluar & Perkecil

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

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



-- Update List Player Aktif

local function updatePlayerList()

for _, child in ipairs(scrollFrame:GetChildren()) do

if child:IsA("TextButton") then child:Destroy() end

end

for _, player in ipairs(Players:GetPlayers()) do

if player ~= localPlayer then

local btn = Instance.new("TextButton")

btn.Size = UDim2.new(1, 0, 0, 28)

btn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)

btn.Text = player.Name

btn.TextColor3 = Color3.fromRGB(255, 255, 255)

btn.Font = Enum.Font.Gotham

btn.TextSize = 12

btn.ZIndex = 6

btn.Parent = scrollFrame


local btnCorner = Instance.new("UICorner")

btnCorner.CornerRadius = UDim.new(0, 4)

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

if isTeleporting then return end

scrollFrame.Visible = not scrollFrame.Visible

if scrollFrame.Visible then updatePlayerList() end

end)



-- Sistem Eksekusi Teleport dengan Loading Detik di Button

teleportBtn.MouseButton1Click:Connect(function()

if isTeleporting then return end


if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

dropdownBtn.Text = "Target Tidak Ditemukan!"

task.wait(1.5)

dropdownBtn.Text = "Pilih Target..."

return

end


local myChar = localPlayer.Character

if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end


isTeleporting = true

scrollFrame.Visible = false

teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)


-- Loading Detik Membaca Data Player Target

for i = 3, 1, -1 do

teleportBtn.Text = "TELEPORTING IN " .. i .. "s..."

task.wait(1)

end


-- Proses Instan Teleport setelah Loading Detik Selesai

if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then

local targetCFrame = selectedPlayer.Character.HumanoidRootPart.CFrame

myChar.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 0, 3)

else

showNotification("LaperGank Error", "Gagal memuat koordinat target!", 3)

end


-- Reset State Tombol

teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

teleportBtn.Text = "EXECUTE TELEPORT"

dropdownBtn.Text = "Pilih Target..."

selectedPlayer = nil

isTeleporting = false

end) 

