local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local function sendSystemNotification(title, msg, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = duration or 5,
            Button1 = "OK"
        })
    end)
end

local GitHubRawURL = "https://raw.githubusercontent.com/ranz-coder/roblox-sc/LaPer-HUB.lua"

local isSupportedMap = true 

if not isSupportedMap then
    sendSystemNotification("LaperGank System", "Peta tidak didukung! System dihentikan.", 5)
    return
else
    sendSystemNotification("LaperGank Ready", "Menghubungkan ke Server...", 3)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(GitHubRawURL)
    end)
    
    if success and scriptContent then
        sendSystemNotification("Laper Gank Panel", "Script berhasil diunduh. Memulai UI...", 3)
        
        local executeScript, err = loadstring(scriptContent)
        if executeScript then
            executeScript()
        else
            sendSystemNotification("Loader Error", "Gagal memproses kode: " .. tostring(err), 5)
        end
    else
        sendSystemNotification("Connection Error", "Gagal mengambil script dari GitHub! Periksa internet/link.", 5)
    end
end
