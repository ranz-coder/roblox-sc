-- =============================================================================
-- VIOLENCE DISTRICT — ADMIN PANEL (Server-Authoritative, Single Script)
-- Taruh di: ServerScriptService
-- Semua aksi (teleport, ESP) diverifikasi SERVER, bukan client.
-- =============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- -----------------------------------------------------------------------------
-- 1. DAFTAR ADMIN (isi UserId asli tim kamu)
-- -----------------------------------------------------------------------------
local ADMIN_IDS = {
    [8236212019] = true, -- ganti dengan UserId admin
    [987654321] = true,
}

local function isAdmin(player)
    return ADMIN_IDS[player.UserId] == true
end

-- -----------------------------------------------------------------------------
-- 2. REMOTE EVENTS (dibuat otomatis, tidak perlu setup manual)
-- -----------------------------------------------------------------------------
local remoteFolder = Instance.new("Folder")
remoteFolder.Name = "AdminRemotes"
remoteFolder.Parent = ReplicatedStorage

local TeleportRemote = Instance.new("RemoteEvent")
TeleportRemote.Name = "TeleportToPlayer"
TeleportRemote.Parent = remoteFolder

local ESPRemote = Instance.new("RemoteEvent")
ESPRemote.Name = "ToggleESP"
ESPRemote.Parent = remoteFolder

local PlayerListRemote = Instance.new("RemoteFunction")
PlayerListRemote.Name = "GetPlayerList"
PlayerListRemote.Parent = remoteFolder

-- -----------------------------------------------------------------------------
-- 3. VALIDASI SERVER — TELEPORT
--    Server yang eksekusi CFrame, bukan client. Non-admin ditolak otomatis.
-- -----------------------------------------------------------------------------
TeleportRemote.OnServerEvent:Connect(function(admin, targetPlayer)
    if not isAdmin(admin) then return end -- tolak jika bukan admin, walau request dipalsukan
    if typeof(targetPlayer) ~= "Instance" or not targetPlayer:IsA("Player") then return end

    local adminChar = admin.Character
    local targetChar = targetPlayer.Character
    if not adminChar or not targetChar then return end

    local adminRoot = adminChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not adminRoot or not targetRoot then return end

    adminRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
end)

-- -----------------------------------------------------------------------------
-- 4. VALIDASI SERVER — ESP (hanya admin yang bisa mengaktifkan, hanya untuk dirinya)
-- -----------------------------------------------------------------------------
local espEnabled = {} -- [admin.UserId] = {Box=bool, Name=bool}

ESPRemote.OnServerEvent:Connect(function(admin, mode, state)
    if not isAdmin(admin) then return end
    espEnabled[admin.UserId] = espEnabled[admin.UserId] or {}
    espEnabled[admin.UserId][mode] = state
end)

-- -----------------------------------------------------------------------------
-- 5. DAFTAR PLAYER (untuk diisi ke list di client)
-- -----------------------------------------------------------------------------
PlayerListRemote.OnServerInvoke = function(admin)
    if not isAdmin(admin) then return {} end
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= admin then table.insert(names, p.Name) end
    end
    return names
end

-- -----------------------------------------------------------------------------
-- 6. GENERATE GUI HANYA UNTUK ADMIN (dikirim sebagai LocalScript ke client admin saja)
-- -----------------------------------------------------------------------------
local function giveAdminGui(player)
    if not isAdmin(player) then return end

    local ls = Instance.new("LocalScript")
    ls.Name = "AdminPanelUI"
    ls.Parent = player:WaitForChild("PlayerGui")
    -- Source di-inject via loadstring alternative: gunakan ModuleScript agar lebih rapi.
    -- (Lihat catatan di bawah — Roblox tidak izinkan set .Source dari Script biasa.)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    giveAdminGui(player)
end)
