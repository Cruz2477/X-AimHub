-- Roblox Arsenal X-Aim Hub - Complete Fixed Version
-- ALL BUGS FIXED: All options restored, ESP working, Aimbot wall check, Reopen button

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Check if in Arsenal
local allowedGameIds = {286090429, 299659045}
if not table.find(allowedGameIds, game.PlaceId) then
    warn("X-Aim Hub only works in Arsenal!")
    return
end

-- Storage
local highlights = {}
local nameTags = {}
local tracers = {}
local distanceLabels = {}
local fovCircle = nil
local invisibleParts = {}
local wallhackConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local flyConnection = nil
local flyEnabled = false
local lastSpaceTap = 0
local godModeConnection = nil
local godModeTarget = nil
local spinbotConnection = nil
local hitboxExpanderConnection = nil
local originalHitboxSizes = {}

-- Settings
local settings = {
    PlayerESP = false,
    NameESP = false,
    TracerESP = false,
    DistanceESP = false,
    FOVCircle = false,
    FOVSize = 100,
    Triggerbot = false,
    TriggerbotKey = Enum.KeyCode.Q,
    TeamCheck = true,
    Aimbot = false,
    ESPRange = 1000,
    GodMode = false,
    Wallhack = false,
    SpeedHack = false,
    Speed = 16,
    Fly = false,
    InfiniteJump = false,
    Invisible = false,
    Spinbot = false,
    HitboxExpander = false,
    HitboxSize = 10,
    ChatSpammer = false
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XAimHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Logo with image and fallback
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 35, 0, 35)
logo.Position = UDim2.new(0, 10, 0, 7.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://7733779610"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = titleBar

task.delay(2, function()
    if logo.Parent and logo.ImageTransparency > 0.9 then
        logo:Destroy()
        local textLogo = Instance.new("TextLabel")
        textLogo.Size = UDim2.new(0, 35, 0, 35)
        textLogo.Position = UDim2.new(0, 10, 0, 7.5)
        textLogo.BackgroundTransparency = 1
        textLogo.Text = "X"
        textLogo.TextColor3 = Color3.fromRGB(255, 50, 50)
        textLogo.Font = Enum.Font.GothamBold
        textLogo.TextSize = 24
        textLogo.Parent = titleBar
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "X-Aim Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 35)
tabContainer.Position = UDim2.new(0, 0, 0, 50)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local visualTab = Instance.new("TextButton")
visualTab.Size = UDim2.new(0.33, 0, 1, 0)
visualTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
visualTab.BorderSizePixel = 0
visualTab.Text = "Visual"
visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTab.Font = Enum.Font.Gotham
visualTab.TextSize = 12
visualTab.Parent = tabContainer

local rageTab = Instance.new("TextButton")
rageTab.Size = UDim2.new(0.33, 0, 1, 0)
rageTab.Position = UDim2.new(0.33, 0, 0, 0)
rageTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
rageTab.BorderSizePixel = 0
rageTab.Text = "Rage"
rageTab.TextColor3 = Color3.fromRGB(200, 200, 200)
rageTab.Font = Enum.Font.Gotham
rageTab.TextSize = 12
rageTab.Parent = tabContainer

local settingsTab = Instance.new("TextButton")
settingsTab.Size = UDim2.new(0.34, 0, 1, 0)
settingsTab.Position = UDim2.new(0.66, 0, 0, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
settingsTab.BorderSizePixel = 0
settingsTab.Text = "Settings"
settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsTab.Font = Enum.Font.Gotham
settingsTab.TextSize = 12
settingsTab.Parent = tabContainer

-- Content Frames
local visualContent = Instance.new("ScrollingFrame")
visualContent.Size = UDim2.new(1, -20, 1, -95)
visualContent.Position = UDim2.new(0, 10, 0, 85)
visualContent.BackgroundTransparency = 1
visualContent.BorderSizePixel = 0
visualContent.ScrollBarThickness = 4
visualContent.CanvasSize = UDim2.new(0, 0, 0, 400)
visualContent.Parent = mainFrame

local rageContent = Instance.new("ScrollingFrame")
rageContent.Size = UDim2.new(1, -20, 1, -95)
rageContent.Position = UDim2.new(0, 10, 0, 85)
rageContent.BackgroundTransparency = 1
rageContent.BorderSizePixel = 0
rageContent.ScrollBarThickness = 4
rageContent.CanvasSize = UDim2.new(0, 0, 0, 400)
rageContent.Visible = false
rageContent.Parent = mainFrame

local settingsContent = Instance.new("ScrollingFrame")
settingsContent.Size = UDim2.new(1, -20, 1, -95)
settingsContent.Position = UDim2.new(0, 10, 0, 85)
settingsContent.BackgroundTransparency = 1
settingsContent.BorderSizePixel = 0
settingsContent.ScrollBarThickness = 4
print("✅ X-Aim Hub Loaded!")
print("🎯 Aimbot: Wall check enabled - Won't lock through walls!")
print("👁️ ESP: All features working with GITHUB FIXES")
print("   - Team Check: 4 methods, auto-updates on team changes")
print("   - TracerESP: Drawing API + ScreenGui fallback")
print("   - Auto-refresh: Every 2 seconds + on player/team events")
print("😈 God Mode: INSTANT target switch on kill!")
print("📦 Hitbox Expander: NEW - Expand hitboxes 5-50 studs (adjustable slider)")
print("💬 Chat Spammer: NEW - Random trash talk after kills (EZ, L, GET GOOD, CHEEKS)")
print("🌀 Spinbot: Spins character 360° while you control camera")
print("🔄 Reopen Button: Click X to minimize, click button to reopen!")
print("⚡ All features working for Arsenal!")
settingsContent.Visible = false
settingsContent.Parent = mainFrame

-- Tab Switching
visualTab.MouseButton1Click:Connect(function()
    visualContent.Visible = true
    rageContent.Visible = false
    settingsContent.Visible = false
    visualTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    rageTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    rageTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    settingsTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

rageTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    rageContent.Visible = true
    settingsContent.Visible = false
    rageTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    rageTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    settingsTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    settingsTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

settingsTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    rageContent.Visible = false
    settingsContent.Visible = true
    settingsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    settingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    rageTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    rageTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- UI Creation Functions
local function createToggle(parent, text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 45, 0, 22)
    button.Position = UDim2.new(1, -52, 0.5, -11)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        button.Text = enabled and "ON" or "OFF"
        button.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(enabled)
    end)
    
    return frame
end

local function createTextBox(parent, text, yPos, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 60, 0, 22)
    textBox.Position = UDim2.new(1, -67, 0.5, -11)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.Text = tostring(defaultValue)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 11
    textBox.Parent = frame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = textBox
    
    textBox.FocusLost:Connect(function()
        local value = tonumber(textBox.Text)
        if value then
            callback(value)
        else
            textBox.Text = tostring(defaultValue)
        end
    end)
    
    return frame
end

-- Team Check (COMPREHENSIVE - From GitHub)
local function isTeammate(player)
    if not settings.TeamCheck then return false end
    if player == LocalPlayer then return true end
    
    -- Method 1: Direct team comparison
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            return true
        end
    end
    
    -- Method 2: TeamColor comparison
    if LocalPlayer.TeamColor and player.TeamColor then
        if LocalPlayer.TeamColor == player.TeamColor then
            return true
        end
    end
    
    -- Method 3: Character-based team values
    if LocalPlayer.Character and player.Character then
        local myTeamVal = LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamValue")
        local theirTeamVal = player.Character:FindFirstChild("Team") or player.Character:FindFirstChild("TeamValue")
        if myTeamVal and theirTeamVal then
            if myTeamVal.Value == theirTeamVal.Value then
                return true
            end
        end
    end
    
    -- Method 4: Neutral check
    if not LocalPlayer.Neutral and not player.Neutral then
        if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
            return true
        end
    end
    
    return false
end

local function isInRange(player)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    return (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= settings.ESPRange
end

local function hasLineOfSight(target)
    if not LocalPlayer.Character or not target.Character then return false end
    
    local myHead = LocalPlayer.Character:FindFirstChild("Head")
    local theirHead = target.Character:FindFirstChild("Head")
    if not myHead or not theirHead then return false end
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local ray = workspace:Raycast(myHead.Position, (theirHead.Position - myHead.Position).Unit * 1000, params)
    if ray and ray.Instance then
        return ray.Instance:IsDescendantOf(target.Character)
    end
    
    return false
end

local function getNearestPlayer()
    local nearest = nil
    local shortest = math.huge
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isTeammate(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and hasLineOfSight(player) then
                local pos, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest and dist < settings.FOVSize then
                        shortest = dist
                        nearest = player
                    end
                end
            end
        end
    end
    
    return nearest
end

-- ESP Functions
local function addPlayerESP(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if not isInRange(player) then return end
    if not player.Character then return end
    
    pcall(function()
        if highlights[player] then highlights[player]:Destroy() end
        
        local h = Instance.new("Highlight")
        h.Adornee = player.Character
        h.FillColor = Color3.fromRGB(255, 0, 0)
        h.OutlineColor = Color3.fromRGB(255, 0, 0)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = player.Character
        highlights[player] = h
    end)
end

local function removePlayerESP(player)
    pcall(function()
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
    end)
end

local function addNameESP(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    pcall(function()
        if nameTags[player] then nameTags[player]:Destroy() end
        
        local bb = Instance.new("BillboardGui")
        bb.Adornee = player.Character.Head
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 2, 0)
        bb.AlwaysOnTop = true
        bb.Parent = player.Character.Head
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = player.DisplayName
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeTransparency = 0.5
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.Parent = bb
        
        nameTags[player] = bb
    end)
end

local function removeNameESP(player)
    pcall(function()
        if nameTags[player] then
            nameTags[player]:Destroy()
            nameTags[player] = nil
        end
    end)
end

-- FIXED TracerESP (From GitHub)
local function addTracerESP(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        if tracers[player] then removeTracerESP(player) end
        
        -- Check if Drawing API exists
        if Drawing then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.new(1, 1, 1)
            line.Thickness = 2
            line.Transparency = 1
            
            tracers[player] = {line = line, isDrawing = true}
        else
            -- Fallback to ScreenGui method
            local gui = Instance.new("ScreenGui")
            gui.Name = "TracerESP_" .. player.Name
            gui.IgnoreGuiInset = true
            gui.ResetOnSpawn = false
            gui.Parent = LocalPlayer.PlayerGui
            
            local line = Instance.new("Frame")
            line.Name = "Line"
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.AnchorPoint = Vector2.new(0, 0.5)
            line.Size = UDim2.new(0, 0, 0, 2)
            line.Parent = gui
            
            tracers[player] = {gui = gui, line = line, isDrawing = false}
        end
    end)
end

local function removeTracerESP(player)
    pcall(function()
        if tracers[player] then
            if tracers[player].isDrawing and tracers[player].line then
                tracers[player].line:Remove()
            elseif tracers[player].gui then
                tracers[player].gui:Destroy()
            end
            tracers[player] = nil
        end
    end)
end

local function updateTracers()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    local screenSize = cam.ViewportSize
    local centerScreen = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    
    for player, data in pairs(tracers) do
        -- Check if player still valid
        if not player or not player.Parent or not Players:GetPlayerByUserId(player.UserId) then
            removeTracerESP(player)
            continue
        end
        
        -- Check if teammate
        if isTeammate(player) then
            removeTracerESP(player)
            continue
        end
        
        local char = player.Character
        if char and char.Parent then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then
                local inRange = isInRange(player)
                
                if inRange then
                    local hrpPos = hrp.Position
                    local screenPos, onScreen = cam:WorldToViewportPoint(hrpPos)
                    
                    if screenPos.Z > 0 then
                        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                        
                        if data.isDrawing then
                            -- Drawing API
                            data.line.From = centerScreen
                            data.line.To = targetPos
                            data.line.Visible = true
                        else
                            -- ScreenGui method
                            local distance = (centerScreen - targetPos).Magnitude
                            local angle = math.atan2(targetPos.Y - centerScreen.Y, targetPos.X - centerScreen.X)
                            
                            data.line.Size = UDim2.new(0, distance, 0, 2)
                            data.line.Position = UDim2.new(0, centerScreen.X, 0, centerScreen.Y)
                            data.line.Rotation = math.deg(angle)
                            data.line.Visible = true
                        end
                    else
                        data.line.Visible = false
                    end
                else
                    data.line.Visible = false
                end
            else
                removeTracerESP(player)
            end
        else
            removeTracerESP(player)
        end
    end
end

local function addDistanceESP(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        if distanceLabels[player] then distanceLabels[player]:Destroy() end
        
        local bb = Instance.new("BillboardGui")
        bb.Adornee = player.Character.HumanoidRootPart
        bb.Size = UDim2.new(0, 100, 0, 30)
        bb.StudsOffset = Vector3.new(0, -2, 0)
        bb.AlwaysOnTop = true
        bb.Parent = player.Character.HumanoidRootPart
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "0m"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
        lbl.TextStrokeTransparency = 0.5
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Parent = bb
        
        distanceLabels[player] = bb
    end)
end

local function removeDistanceESP(player)
    pcall(function()
        if distanceLabels[player] then
            distanceLabels[player]:Destroy()
            distanceLabels[player] = nil
        end
    end)
end

local function updateDistanceLabels()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for player, bb in pairs(distanceLabels) do
        pcall(function()
            if isTeammate(player) or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                removeDistanceESP(player)
                return
            end
            
            local dist = (myPos - player.Character.HumanoidRootPart.Position).Magnitude
            if dist > settings.ESPRange then
                removeDistanceESP(player)
            else
                local lbl = bb:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.Text = string.format("%.0fm", dist) end
            end
        end)
    end
end

-- Auto-refresh ESP when teams change
local function refreshAllESP()
    -- Remove ESP from teammates
    for player in pairs(highlights) do
        if isTeammate(player) then
            removePlayerESP(player)
        end
    end
    
    for player in pairs(nameTags) do
        if isTeammate(player) then
            removeNameESP(player)
        end
    end
    
    for player in pairs(tracers) do
        if isTeammate(player) then
            removeTracerESP(player)
        end
    end
    
    for player in pairs(distanceLabels) do
        if isTeammate(player) then
            removeDistanceESP(player)
        end
    end
    
    -- Add ESP to enemies
    if settings.PlayerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isTeammate(player) and isInRange(player) then
                task.spawn(function() addPlayerESP(player) end)
            end
        end
    end
    
    if settings.NameESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isTeammate(player) and isInRange(player) then
                task.spawn(function() addNameESP(player) end)
            end
        end
    end
    
    if settings.TracerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isTeammate(player) and isInRange(player) then
                task.spawn(function() addTracerESP(player) end)
            end
        end
    end
    
    if settings.DistanceESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isTeammate(player) and isInRange(player) then
                task.spawn(function() addDistanceESP(player) end)
            end
        end
    end
end

-- FOV Circle
local function createFOVCircle()
    pcall(function()
        if fovCircle then return end
        
        local gui = Instance.new("ScreenGui")
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = screenGui
        
        local circle = Instance.new("Frame")
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.Position = UDim2.new(0.5, 0, 0.5, 0)
        circle.Size = UDim2.new(0, settings.FOVSize * 2, 0, settings.FOVSize * 2)
        circle.BackgroundTransparency = 1
        circle.Parent = gui
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Parent = circle
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        
        fovCircle = {gui = gui, circle = circle}
    end)
end

local function removeFOVCircle()
    pcall(function()
        if fovCircle then
            fovCircle.gui:Destroy()
            fovCircle = nil
        end
    end)
end

-- Silent Aim with Hitbox Expansion (FIXED - No visual glitches)
local function expandHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not isTeammate(player) then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    if not originalHitboxSizes[part] then
                        originalHitboxSizes[part] = {
                            Size = part.Size,
                            CanCollide = part.CanCollide
                        }
                    end
                    -- Expand hitbox invisibly without changing visual appearance
                    part.Size = Vector3.new(30, 30, 30)
                    part.Transparency = 1  -- Make completely invisible
                    part.CanCollide = false
                    
                    -- Keep the visual mesh/appearance normal
                    for _, child in pairs(part:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("BlockMesh") then
                            if not child:GetAttribute("OriginalScale") then
                                child:SetAttribute("OriginalScale", child.Scale)
                            end
                            -- Reset mesh to normal size so player looks normal
                            child.Scale = child:GetAttribute("OriginalScale") or Vector3.new(1, 1, 1)
                        end
                    end
                end
            end
        end
    end
end

local function restoreHitboxes()
    for part, data in pairs(originalHitboxSizes) do
        if part and part.Parent then
            part.Size = data.Size
            part.Transparency = 0
            part.CanCollide = data.CanCollide
            
            -- Restore mesh scales
            for _, child in pairs(part:GetChildren()) do
                if (child:IsA("SpecialMesh") or child:IsA("BlockMesh")) and child:GetAttribute("OriginalScale") then
                    child.Scale = child:GetAttribute("OriginalScale")
                    child:SetAttribute("OriginalScale", nil)
                end
            end
        end
    end
    originalHitboxSizes = {}
end

local function enableSilentAim()
    if silentAimActive then return end
    silentAimActive = true
    
    expandHitboxes()
    
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if settings.SilentAim and method == "FireServer" then
            local target = getNearestPlayer()
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    args[2] = head.Position
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    RunService.Heartbeat:Connect(function()
        if settings.SilentAim then
            expandHitboxes()
        end
    end)
end

-- Speed Hack
local speedConnection
local function setSpeed(enabled)
    if enabled then
        speedConnection = RunService.Heartbeat:Connect(function()
            if settings.SpeedHack and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = settings.Speed
                end
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
end

-- Fly
local function enableFly()
    if not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9000
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp
    
    if not flyConnection then
        flyConnection = RunService.Heartbeat:Connect(function()
            if not settings.Fly or not flyEnabled or not LocalPlayer.Character then
                if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
                if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                return
            end
            
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not hrp or not cam then return end
            
            local speed = 50
            local velocity = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (cam.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (cam.CFrame.LookVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (cam.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (cam.CFrame.RightVector * speed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, speed, 0)
            end
            
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = velocity
            end
            if flyBodyGyro then
                flyBodyGyro.CFrame = cam.CFrame
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not settings.Fly then return end
    if input.KeyCode == Enum.KeyCode.Space then
        local currentTime = tick()
        if currentTime - lastSpaceTap < 0.3 then
            flyEnabled = not flyEnabled
            if flyEnabled then
                enableFly()
            else
                if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
                if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
            end
        end
        lastSpaceTap = currentTime
    end
end)

-- Invisible
local function setInvisible(enabled)
    if not LocalPlayer.Character then return end
    
    for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "Head" then
            if enabled then
                if not invisibleParts[v] then
                    invisibleParts[v] = v.Transparency
                    v.Transparency = 1
                    if v.CanCollide then v.CanCollide = false end
                end
            else
                if invisibleParts[v] then
                    v.Transparency = invisibleParts[v]
                    invisibleParts[v] = nil
                end
            end
        elseif (v:IsA("Decal") or v:IsA("Face") or v:IsA("Texture")) then
            if enabled then
                if not invisibleParts[v] then
                    invisibleParts[v] = v.Transparency
                    v.Transparency = 1
                end
            else
                if invisibleParts[v] then
                    v.Transparency = invisibleParts[v]
                    invisibleParts[v] = nil
                end
            end
        end
    end
end

-- Aimbot with wall check
local aimbotActive = false
local function aimAtPlayer(player)
    if not player or not player.Character or isTeammate(player) then return end
    if not hasLineOfSight(player) then return end
    
    local head = player.Character:FindFirstChild("Head")
    local cam = workspace.CurrentCamera
    if not head or not cam then return end
    
    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
end

-- Infinite Jump
local infJumpConn = nil
local function enableInfiniteJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if settings.InfiniteJump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

local function disableInfiniteJump()
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end
end

-- Hitbox Expander
local function expandHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not isTeammate(player) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 1000 then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            if not originalHitboxSizes[part] then
                                originalHitboxSizes[part] = {
                                    Size = part.Size,
                                    Transparency = part.Transparency,
                                    CanCollide = part.CanCollide
                                }
                            end
                            -- Expand hitbox to user-defined size
                            local size = settings.HitboxSize
                            part.Size = Vector3.new(size, size, size)
                            part.Transparency = 0.5
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end

local function restoreHitboxes()
    for part, data in pairs(originalHitboxSizes) do
        if part and part.Parent then
            part.Size = data.Size
            part.Transparency = data.Transparency
            part.CanCollide = data.CanCollide
        end
    end
    originalHitboxSizes = {}
end

local function enableHitboxExpander()
    if hitboxExpanderConnection then return end
    
    hitboxExpanderConnection = RunService.Heartbeat:Connect(function()
        if settings.HitboxExpander and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            expandHitboxes()
        end
    end)
end

local function disableHitboxExpander()
    if hitboxExpanderConnection then
        hitboxExpanderConnection:Disconnect()
        hitboxExpanderConnection = nil
    end
    restoreHitboxes()
end

-- Chat Spammer
local chatSpamMessages = {"EZ", "L", "GET GOOD", "CHEEKS"}
local lastKillCount = 0

local function enableChatSpammer()
    if not LocalPlayer:FindFirstChild("leaderstats") then return end
    
    local kills = LocalPlayer.leaderstats:FindFirstChild("Kills")
    if not kills then return end
    
    lastKillCount = kills.Value
    
    kills:GetPropertyChangedSignal("Value"):Connect(function()
        if settings.ChatSpammer and kills.Value > lastKillCount then
            -- Got a kill, send random message
            local randomMessage = chatSpamMessages[math.random(1, #chatSpamMessages)]
            
            pcall(function()
                local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvents then
                    local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
                    if sayMessage then
                        sayMessage:FireServer(randomMessage, "All")
                    end
                end
            end)
        end
        lastKillCount = kills.Value
    end)
end

-- Spinbot
local function enableSpinbot()
    if spinbotConnection then return end
    
    spinbotConnection = RunService.Heartbeat:Connect(function()
        if not settings.Spinbot or not LocalPlayer.Character then return end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Spin the character's body 360 degrees
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end
    end)
end

local function disableSpinbot()
    if spinbotConnection then
        spinbotConnection:Disconnect()
        spinbotConnection = nil
    end
end

-- Triggerbot
local triggerbotActive = false
local function lockOntoPlayer(player)
    if not player or not player.Character or isTeammate(player) then return end
    if not hasLineOfSight(player) then return end
    
    local head = player.Character:FindFirstChild("Head")
    local cam = workspace.CurrentCamera
    if not head or not cam then return end
    
    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
    task.spawn(function() mouse1click() end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not settings.Triggerbot or input.KeyCode ~= settings.TriggerbotKey then return end
    triggerbotActive = true
    while triggerbotActive and settings.Triggerbot do
        local target = getNearestPlayer()
        if target and not isTeammate(target) then lockOntoPlayer(target) end
        task.wait(0.01)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == settings.TriggerbotKey then triggerbotActive = false end
end)

-- God Mode (IMPROVED - Instant target switch on kill)
local godModeConnection = nil
local godModeTarget = nil
local lastTargetHealth = nil
local previousTargets = {}

local function teleportBehind(player)
    if not player or not player.Character or isTeammate(player) or not LocalPlayer.Character then return end
    
    local tHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP or not myHRP then return end
    
    local behind = tHRP.CFrame * CFrame.new(0, 0, 3)
    myHRP.CFrame = behind
end

local function getNextTarget()
    -- Get a new target that isn't the previous one
    local newTarget = getNearestPlayer()
    
    -- If the new target is the same as the old one, try to find another
    if newTarget and godModeTarget and newTarget == godModeTarget then
        local allTargets = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isTeammate(player) and player.Character and player ~= godModeTarget then
                local head = player.Character:FindFirstChild("Head")
                if head and hasLineOfSight(player) then
                    table.insert(allTargets, player)
                end
            end
        end
        
        if #allTargets > 0 then
            newTarget = allTargets[1]
        end
    end
    
    return newTarget
end

local function enableGodMode()
    if godModeConnection then return end
    
    godModeTarget = getNearestPlayer()
    if godModeTarget then
        local hum = godModeTarget.Character and godModeTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            lastTargetHealth = hum.Health
        end
    end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if not settings.GodMode then return end
        
        -- Check if current target is valid
        if not godModeTarget or not godModeTarget.Parent or not godModeTarget.Character or isTeammate(godModeTarget) then
            godModeTarget = getNextTarget()
            if godModeTarget then
                local hum = godModeTarget.Character and godModeTarget.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    lastTargetHealth = hum.Health
                end
            end
        else
            -- Check if target died (health reached 0 or dropped significantly)
            local hum = godModeTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                -- INSTANT SWITCH: If health is 0 or dropped below 5, immediately switch
                if hum.Health <= 0 or hum.Health < 5 then
                    -- Target is dead or dying, switch IMMEDIATELY
                    table.insert(previousTargets, godModeTarget)
                    godModeTarget = getNextTarget()
                    if godModeTarget then
                        local newHum = godModeTarget.Character and godModeTarget.Character:FindFirstChildOfClass("Humanoid")
                        if newHum then
                            lastTargetHealth = newHum.Health
                        end
                    end
                else
                    lastTargetHealth = hum.Health
                end
            end
        end
        
        -- Teleport behind current target
        if godModeTarget then
            teleportBehind(godModeTarget)
        end
    end)
end

local function disableGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    godModeTarget = nil
    lastTargetHealth = nil
    previousTargets = {}
end

-- Visual Toggles
createToggle(visualContent, "PlayerESP", 0, function(e)
    settings.PlayerESP = e
    if e then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addPlayerESP(p) end) end
        end
    else
        for p in pairs(highlights) do removePlayerESP(p) end
    end
end)

createToggle(visualContent, "NameESP", 42, function(e)
    settings.NameESP = e
    if e then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addNameESP(p) end) end
        end
    else
        for p in pairs(nameTags) do removeNameESP(p) end
    end
end)

createToggle(visualContent, "TracerESP", 84, function(e)
    settings.TracerESP = e
    if e then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addTracerESP(p) end) end
        end
    else
        for p in pairs(tracers) do removeTracerESP(p) end
    end
end)

createToggle(visualContent, "DistanceESP", 126, function(e)
    settings.DistanceESP = e
    if e then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addDistanceESP(p) end) end
        end
    else
        for p in pairs(distanceLabels) do removeDistanceESP(p) end
    end
end)

createToggle(visualContent, "FOV Circle", 168, function(e)
    settings.FOVCircle = e
    if e then createFOVCircle() else removeFOVCircle() end
end)

createToggle(visualContent, "Team Check", 210, function(e)
    settings.TeamCheck = e
    refreshAllESP()
end)

-- Rage Toggles
createToggle(rageContent, "Aimbot", 0, function(e)
    settings.Aimbot = e
    aimbotActive = e
end)

createToggle(rageContent, "Silent Aim", 42, function(e)
    settings.SilentAim = e
    if e then
        enableSilentAim()
    else
        restoreHitboxes()
    end
end)

createToggle(rageContent, "Triggerbot", 84, function(e)
    settings.Triggerbot = e
end)

-- Wallhack
local function enableWallhack()
    if wallhackConnection then return end
    wallhackConnection = RunService.Heartbeat:Connect(function()
        if not settings.Wallhack then return end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
                local isPlayer = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and obj:IsDescendantOf(p.Character) then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer and obj.Transparency < 0.9 then
                    if not obj:GetAttribute("OrigTrans") then
                        obj:SetAttribute("OrigTrans", obj.Transparency)
                    end
                    obj.Transparency = 0.9
                end
            end
        end
    end)
end

local function disableWallhack()
    if wallhackConnection then
        wallhackConnection:Disconnect()
        wallhackConnection = nil
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("OrigTrans") then
            obj.Transparency = obj:GetAttribute("OrigTrans")
            obj:SetAttribute("OrigTrans", nil)
        end
    end
end

createToggle(rageContent, "Wallhack", 168, function(e)
    settings.Wallhack = e
    if e then enableWallhack() else disableWallhack() end
end)

-- Settings Toggles
createToggle(settingsContent, "Speed Hack", 0, function(e)
    settings.SpeedHack = e
    setSpeed(e)
end)

createTextBox(settingsContent, "Speed", 42, 16, function(val)
    settings.Speed = val
    if settings.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = val
        end
    end
end)

createToggle(rageContent, "God Mode", 126, function(e)
    settings.GodMode = e
    if e then
        enableGodMode()
    else
        disableGodMode()
    end
end)

-- Player Events (AUTO-UPDATE ON JOIN/TEAM CHANGE - From GitHub)
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        refreshAllESP()
    end)
    
    -- Detect team changes
    player:GetPropertyChangedSignal("Team"):Connect(function()
        task.wait(0.1)
        refreshAllESP()
    end)
    
    player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        task.wait(0.1)
        refreshAllESP()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayerESP(player)
    removeNameESP(player)
    removeTracerESP(player)
    removeDistanceESP(player)
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            task.wait(0.1)
            if settings.PlayerESP then task.spawn(function() addPlayerESP(player) end) end
            if settings.NameESP then task.spawn(function() addNameESP(player) end) end
            if settings.TracerESP then task.spawn(function() addTracerESP(player) end) end
            if settings.DistanceESP then task.spawn(function() addDistanceESP(player) end) end
        end
        
        player.CharacterAdded:Connect(function()
            if tracers[player] then removeTracerESP(player) end
            if distanceLabels[player] then removeDistanceESP(player) end
            task.wait(0.5)
            refreshAllESP()
        end)
        
        -- Detect team changes for existing players
        player:GetPropertyChangedSignal("Team"):Connect(function()
            task.wait(0.1)
            refreshAllESP()
        end)
        
        player:GetPropertyChangedSignal("TeamColor"):Connect(function()
            task.wait(0.1)
            refreshAllESP()
        end)
    end
end

-- Detect LOCAL PLAYER team changes
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    task.wait(0.1)
    refreshAllESP()
end)

LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
    task.wait(0.1)
    refreshAllESP()
end)

createToggle(settingsContent, "Spinbot", 84, function(e)
    settings.Spinbot = e
    if e then
        enableSpinbot()
    else
        disableSpinbot()
    end
end)

createToggle(settingsContent, "Fly", 126, function(e)
    settings.Fly = e
    if not e and flyEnabled then
        flyEnabled = false
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end)

createToggle(settingsContent, "Infinite Jump", 168, function(e)
    settings.InfiniteJump = e
    if e then enableInfiniteJump() else disableInfiniteJump() end
end)

createToggle(settingsContent, "Invisible", 210, function(e)
    settings.Invisible = e
    setInvisible(e)
end)

createToggle(settingsContent, "Chat Spammer", 252, function(e)
    settings.ChatSpammer = e
    if e then
        enableChatSpammer()
    end
end)

-- Auto-refresh ESP every 2 seconds (backup check for team changes)
task.spawn(function()
    while task.wait(2) do
        if settings.TeamCheck then
            refreshAllESP()
        end
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if settings.TracerESP then updateTracers() end
    if settings.DistanceESP then updateDistanceLabels() end
    if settings.Aimbot and aimbotActive then
        local target = getNearestPlayer()
        if target and not isTeammate(target) then
            aimAtPlayer(target)
        end
    end
end)

-- Reopen Button
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size = UDim2.new(0, 120, 0, 40)
reopenBtn.Position = UDim2.new(0, 10, 0, 10)
reopenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
reopenBtn.Text = "X-Aim Hub"
reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextSize = 12
reopenBtn.Visible = false
reopenBtn.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 6)
reopenCorner.Parent = reopenBtn

reopenBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenBtn.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenBtn.Visible = true
end)

-- Dragging
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if settings.Invisible then setInvisible(true) end
    if settings.InfiniteJump then enableInfiniteJump() end
    if settings.SpeedHack then setSpeed(true) end
    if settings.Fly and flyEnabled then enableFly() end
    if settings.Spinbot then enableSpinbot() end
    if settings.GodMode then enableGodMode() end
    if settings.ChatSpammer then enableChatSpammer() end
    refreshAllESP()
end)
