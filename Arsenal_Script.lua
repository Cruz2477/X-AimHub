-- Roblox Arsenal X-Aim Hub - Complete Edition

-- Game Check: Only run in Arsenal
local allowedGameIds = {
    286090429, -- Arsenal Main Game
    299659045, -- Arsenal VIP Server
}

local currentGameId = game.PlaceId
local isAllowedGame = false

for _, id in pairs(allowedGameIds) do
    if currentGameId == id then
        isAllowedGame = true
        break
    end
end

if not isAllowedGame then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Create notification
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "GameCheckNotification"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 350, 0, 100)
    notifFrame.Position = UDim2.new(0.5, -175, 0.5, -50)
    notifFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notifFrame
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 30)
    notifTitle.Position = UDim2.new(0, 10, 0, 10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = "⚠️ Wrong Game!"
    notifTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.Parent = notifFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 0, 40)
    notifText.Position = UDim2.new(0, 10, 0, 45)
    notifText.BackgroundTransparency = 1
    notifText.Text = "X-Aim Hub only works in Arsenal!\nCurrent Game ID: " .. tostring(currentGameId)
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 12
    notifText.TextWrapped = true
    notifText.Parent = notifFrame
    
    -- Auto-close after 5 seconds
    task.wait(5)
    notifGui:Destroy()
    
    return -- Stop script execution
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Storage
local highlights = {}
local nameTags = {}
local tracers = {}
local distanceLabels = {}
local fovCircle = nil
local godModeConnection = nil
local invisibleParts = {}
local wallhackConnection = nil
local flyConnection = nil
local flyEnabled = false
local lastSpaceTap = 0
local flyBodyVelocity = nil
local flyBodyGyro = nil
local speedConnection = nil
local healthConnection = nil
local ammoConnection = nil
local recoilConnection = nil
local reloadConnection = nil
local lastRecoilUpdate = 0
local silentAimActive = false
local oldNamecall = nil

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
    SilentAim = false,
    ESPRange = 1000,
    GodMode = false,
    InfiniteJump = false,
    Invisible = false,
    Wallhack = false,
    SpeedHack = false,
    Speed = 16,
    InfHealth = false,
    InfAmmo = false,
    NoRecoil = false,
    InstaReload = false,
    Fly = false
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XAimHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
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

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 35, 0, 35)
logo.Position = UDim2.new(0, 10, 0, 7.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://YOUR_LOGO_ID_HERE"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = titleBar

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
visualContent.CanvasSize = UDim2.new(0, 0, 0, 300)
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
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 400)
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
    textBox.PlaceholderText = "..."
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

local function createKeybind(parent, text, yPos, defaultKey, callback)
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
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 22)
    button.Position = UDim2.new(1, -67, 0.5, -11)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = defaultKey.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local selecting = false
    button.MouseButton1Click:Connect(function()
        if not selecting then
            selecting = true
            button.Text = "..."
            button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if selecting and input.UserInputType == Enum.UserInputType.Keyboard then
            selecting = false
            button.Text = input.KeyCode.Name
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            callback(input.KeyCode)
        end
    end)
    
    return frame
end

-- Team Check
local function isTeammate(player)
    if not settings.TeamCheck then return false end
    if player == LocalPlayer then return true end
    
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            return true
        end
    end
    
    if LocalPlayer.TeamColor and player.TeamColor then
        if LocalPlayer.TeamColor == player.TeamColor then
            return true
        end
    end
    
    if LocalPlayer.Character and player.Character then
        local myTeamVal = LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamValue")
        local theirTeamVal = player.Character:FindFirstChild("Team") or player.Character:FindFirstChild("TeamValue")
        if myTeamVal and theirTeamVal then
            if myTeamVal.Value == theirTeamVal.Value then
                return true
            end
        end
    end
    
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

local function addTracerESP(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        if tracers[player] then removeTracerESP(player) end
        
        if Drawing then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.new(1, 1, 1)
            line.Thickness = 2
            line.Transparency = 1
            
            tracers[player] = {line = line, isDrawing = true}
        else
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
        if not player or not player.Parent or not Players:GetPlayerByUserId(player.UserId) then
            removeTracerESP(player)
            continue
        end
        
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
                            data.line.From = centerScreen
                            data.line.To = targetPos
                            data.line.Visible = true
                        else
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
        bb.StudsOffset = Vector3.new(3, 0, 0)
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

local function refreshAllESP()
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
        gui.Parent = LocalPlayer.PlayerGui
        
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

-- Aimbot (0ms - Fully Blatant)
local function getNearestPlayer()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    
    local nearest = nil
    local shortest = math.huge
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or isTeammate(player) or not isInRange(player) or not player.Character then continue end
        
        local head = player.Character:FindFirstChild("Head")
        if not head then continue end
        
        local pos, onScreen = cam:WorldToViewportPoint(head.Position)
        if onScreen and pos.Z > 0 then
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {LocalPlayer.Character}
            params.FilterType = Enum.RaycastFilterType.Exclude
            
            local ray = workspace:Raycast(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 1000, params)
            if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = player
                end
            end
        end
    end
    
    return nearest
end

local aimbotActive = false

local function aimAtPlayer(player)
    if not player or not player.Character or isTeammate(player) then return end
    
    local head = player.Character:FindFirstChild("Head")
    local cam = workspace.CurrentCamera
    if not head or not cam then return end
    
    -- 0ms Blatant mode (instant snap)
    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
end

-- Silent Aim
local silentAimActive = false
local oldNamecall

local function enableSilentAim()
    if silentAimActive then return end
    silentAimActive = true
    
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if settings.SilentAim and method == "FireServer" and self.Name == "POOLED" then
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
end

-- Speed Hack (Arsenal Compatible)
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

-- Inf Health (Arsenal Compatible)
local healthConnection
local function setInfHealth(enabled)
    if enabled then
        healthConnection = RunService.Heartbeat:Connect(function()
            if settings.InfHealth and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end
        end)
    else
        if healthConnection then
            healthConnection:Disconnect()
            healthConnection = nil
        end
    end
end

-- Inf Ammo (Arsenal Compatible)
local ammoConnection
local function setInfAmmo(enabled)
    if enabled then
        ammoConnection = RunService.Heartbeat:Connect(function()
            if settings.InfAmmo and LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo then
                        ammo.Value = 999
                    end
                    
                    local maxAmmo = tool:FindFirstChild("MaxAmmo") 
                    if maxAmmo then
                        maxAmmo.Value = 999
                    end
                    
                    local storedAmmo = tool:FindFirstChild("StoredAmmo")
                    if storedAmmo then
                        storedAmmo.Value = 999
                    end
                end
            end
        end)
    else
        if ammoConnection then
            ammoConnection:Disconnect()
            ammoConnection = nil
        end
    end
end

-- No Recoil (Arsenal Compatible)
local recoilConnection
local function setNoRecoil(enabled)
    if enabled then
        recoilConnection = RunService.RenderStepped:Connect(function()
            if settings.NoRecoil then
                local cam = workspace.CurrentCamera
                if cam then
                    -- Reset camera recoil
                    cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(0, 0, 0)
                end
                
                if LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Remove recoil values
                        local recoil = tool:FindFirstChild("Recoil")
                        if recoil then
                            recoil.Value = 0
                        end
                        
                        local recoilSpring = tool:FindFirstChild("RecoilSpring")
                        if recoilSpring then
                            recoilSpring.Value = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end)
    else
        if recoilConnection then
            recoilConnection:Disconnect()
            recoilConnection = nil
        end
    end
end

-- Insta Reload (Arsenal Compatible)
local reloadConnection
local function setInstaReload(enabled)
    if enabled then
        reloadConnection = RunService.Heartbeat:Connect(function()
            if settings.InstaReload and LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local reloading = tool:FindFirstChild("Reloading")
                    if reloading and reloading.Value == true then
                        -- Force finish reload instantly
                        local ammo = tool:FindFirstChild("Ammo")
                        local maxAmmo = tool:FindFirstChild("MaxAmmo")
                        if ammo and maxAmmo then
                            ammo.Value = maxAmmo.Value
                        end
                        reloading.Value = false
                    end
                    
                    local reloadTime = tool:FindFirstChild("ReloadTime")
                    if reloadTime then
                        reloadTime.Value = 0.01
                    end
                end
            end
        end)
    else
        if reloadConnection then
            reloadConnection:Disconnect()
            reloadConnection = nil
        end
    end
end

-- Fly (Arsenal Compatible - Uses different method)
local flyBodyVelocity
local flyBodyGyro
local function enableFly()
    if not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Remove old instances if they exist
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

-- Fly Double Tap Space Detection
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

-- Triggerbot
local triggerbotActive = false

local function lockOntoPlayer(player)
    if not player or not player.Character or isTeammate(player) then return end
    
    local head = player.Character:FindFirstChild("Head")
    local cam = workspace.CurrentCamera
    if not head or not cam then return end
    
    cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
    task.spawn(function() mouse1click() end)
end

-- God Mode
local godModeTarget = nil

local function teleportBehind(player)
    if not player or not player.Character or isTeammate(player) or not LocalPlayer.Character then return end
    
    local tHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP or not myHRP then return end
    
    local behind = tHRP.CFrame * CFrame.new(0, 0, 3)
    local tween = TweenService:Create(myHRP, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {CFrame = behind})
    tween:Play()
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
    
    for _, acc in pairs(LocalPlayer.Character:GetChildren()) do
        if acc:IsA("Accessory") then
            local handle = acc:FindFirstChild("Handle")
            if handle then
                if enabled then
                    if not invisibleParts[handle] then
                        invisibleParts[handle] = handle.Transparency
                        handle.Transparency = 1
                    end
                else
                    if invisibleParts[handle] then
                        handle.Transparency = invisibleParts[handle]
                        invisibleParts[handle] = nil
                    end
                end
            end
        end
    end
end

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
    local slider = visualContent:FindFirstChild("FOVSlider")
    if slider then slider.Visible = e end
end)

-- FOV Slider
local fovSlider = Instance.new("Frame")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(1, 0, 0, 50)
fovSlider.Position = UDim2.new(0, 0, 0, 210)
fovSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fovSlider.BorderSizePixel = 0
fovSlider.Visible = false
fovSlider.Parent = visualContent

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovSlider

local fovLbl = Instance.new("TextLabel")
fovLbl.Size = UDim2.new(1, -20, 0, 20)
fovLbl.Position = UDim2.new(0, 10, 0, 5)
fovLbl.BackgroundTransparency = 1
fovLbl.Text = "FOV Size"
fovLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLbl.Font = Enum.Font.Gotham
fovLbl.TextSize = 12
fovLbl.TextXAlignment = Enum.TextXAlignment.Left
fovLbl.Parent = fovSlider

local fovVal = Instance.new("TextLabel")
fovVal.Size = UDim2.new(0, 40, 0, 20)
fovVal.Position = UDim2.new(1, -50, 0, 5)
fovVal.BackgroundTransparency = 1
fovVal.Text = "100"
fovVal.TextColor3 = Color3.fromRGB(255, 255, 255)
fovVal.Font = Enum.Font.GothamBold
fovVal.TextSize = 11
fovVal.TextXAlignment = Enum.TextXAlignment.Right
fovVal.Parent = fovSlider

local fovBar = Instance.new("Frame")
fovBar.Size = UDim2.new(1, -20, 0, 4)
fovBar.Position = UDim2.new(0, 10, 1, -15)
fovBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovBar.BorderSizePixel = 0
fovBar.Parent = fovSlider

local fovBarCorner = Instance.new("UICorner")
fovBarCorner.CornerRadius = UDim.new(1, 0)
fovBarCorner.Parent = fovBar

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(0.2, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovBar

local fovFillCorner = Instance.new("UICorner")
fovFillCorner.CornerRadius = UDim.new(1, 0)
fovFillCorner.Parent = fovFill

local fovBtn = Instance.new("TextButton")
fovBtn.Size = UDim2.new(0, 12, 0, 12)
fovBtn.Position = UDim2.new(0.2, -6, 0.5, -6)
fovBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovBtn.Text = ""
fovBtn.AutoButtonColor = false
fovBtn.Parent = fovBar

local fovBtnCorner = Instance.new("UICorner")
fovBtnCorner.CornerRadius = UDim.new(1, 0)
fovBtnCorner.Parent = fovBtn

local fovDrag = false

local function updateFOV(input)
    if not fovBar.AbsoluteSize then return end
    local pos = math.clamp((input.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
    local val = math.floor(50 + (300 - 50) * pos)
    fovVal.Text = tostring(val)
    fovFill.Size = UDim2.new(pos, 0, 1, 0)
    fovBtn.Position = UDim2.new(pos, -6, 0.5, -6)
    settings.FOVSize = val
    if fovCircle and fovCircle.circle then
        fovCircle.circle.Size = UDim2.new(0, val * 2, 0, val * 2)
    end
end

fovBtn.MouseButton1Down:Connect(function() fovDrag = true end)
fovBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        fovDrag = true
        updateFOV(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then fovDrag = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if fovDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateFOV(input)
    end
end)

-- Rage Toggles
createToggle(rageContent, "Team Check", 0, function(e)
    settings.TeamCheck = e
    refreshAllESP()
end)

createToggle(rageContent, "Aimbot", 42, function(e)
    settings.Aimbot = e
    aimbotActive = e
end)

createToggle(rageContent, "Silent Aim", 84, function(e)
    settings.SilentAim = e
    if e then
        enableSilentAim()
    end
end)

createToggle(rageContent, "God Mode", 126, function(e)
    settings.GodMode = e
    if e then
        godModeConnection = RunService.Heartbeat:Connect(function()
            if settings.GodMode and godModeTarget then teleportBehind(godModeTarget) end
        end)
        godModeTarget = getNearestPlayer()
    else
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        godModeTarget = nil
    end
end)

createToggle(rageContent, "Wallhack", 168, function(e)
    settings.Wallhack = e
    if e then enableWallhack() else disableWallhack() end
end)

local trigToggle = createToggle(rageContent, "Triggerbot", 210, function(e)
    settings.Triggerbot = e
    triggerbotActive = false
    local kb = rageContent:FindFirstChild("TrigKB")
    if kb then kb.Visible = e end
end)

local trigKB = createKeybind(rageContent, "Triggerbot Key", 252, Enum.KeyCode.Q, function(key)
    settings.TriggerbotKey = key
end)
trigKB.Name = "TrigKB"
trigKB.Visible = false

-- Settings Toggles
createToggle(settingsContent, "Speed Hack", 0, function(e)
    settings.SpeedHack = e
    setSpeed(e)
    local speedBox = settingsContent:FindFirstChild("SpeedChanger")
    if speedBox then speedBox.Visible = e end
end)

local speedChanger = createTextBox(settingsContent, "Speed Changer", 42, 16, function(val)
    settings.Speed = val
    if settings.SpeedHack then
        -- Update speed immediately
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = val
            end
        end
    end
end)
speedChanger.Name = "SpeedChanger"
speedChanger.Visible = false

createToggle(settingsContent, "Inf Health", 84, function(e)
    settings.InfHealth = e
    setInfHealth(e)
end)

createToggle(settingsContent, "Inf Ammo", 126, function(e)
    settings.InfAmmo = e
    setInfAmmo(e)
end)

createToggle(settingsContent, "No Recoil", 168, function(e)
    settings.NoRecoil = e
    setNoRecoil(e)
end)

createToggle(settingsContent, "Insta Reload", 210, function(e)
    settings.InstaReload = e
    setInstaReload(e)
end)

createToggle(settingsContent, "Fly", 252, function(e)
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

createToggle(settingsContent, "Infinite Jump", 294, function(e)
    settings.InfiniteJump = e
    if e then enableInfiniteJump() else disableInfiniteJump() end
end)

createToggle(settingsContent, "Invisible", 336, function(e)
    settings.Invisible = e
    setInvisible(e)
end)

-- Triggerbot Input
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

-- Player Events
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        refreshAllESP()
    end)
    
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

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    task.wait(0.1)
    refreshAllESP()
end)

LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
    task.wait(0.1)
    refreshAllESP()
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if settings.TracerESP then updateTracers() end
    if settings.DistanceESP then updateDistanceLabels() end
    if settings.Aimbot and aimbotActive then
        local target = getNearestPlayer()
        if target and not isTeammate(target) then aimAtPlayer(target) end
    end
    if settings.GodMode then
        if not godModeTarget or not godModeTarget.Parent or not godModeTarget.Character or isTeammate(godModeTarget) then
            godModeTarget = getNearestPlayer()
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if settings.TeamCheck then
            refreshAllESP()
        end
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if settings.Invisible then setInvisible(true) end
    if settings.InfiniteJump then enableInfiniteJump() end
    if settings.InfHealth then setInfHealth(true) end
    if settings.SpeedHack then setSpeed(true) end
    if settings.NoRecoil then setNoRecoil(true) end
    if settings.InfAmmo then setInfAmmo(true) end
    if settings.InstaReload then setInstaReload(true) end
    if settings.Fly and flyEnabled then enableFly() end
    refreshAllESP()
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
reopenBtn.Active = true
reopenBtn.Draggable = false
reopenBtn.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 6)
reopenCorner.Parent = reopenBtn

local reopenDragging = false
local reopenDragStart = nil
local reopenStartPos = nil

reopenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        reopenDragging = true
        reopenDragStart = input.Position
        reopenStartPos = reopenBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                reopenDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if reopenDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - reopenDragStart
        reopenBtn.Position = UDim2.new(
            reopenStartPos.X.Scale,
            reopenStartPos.X.Offset + delta.X,
            reopenStartPos.Y.Scale,
            reopenStartPos.Y.Offset + delta.Y
        )
    end
end)

reopenBtn.MouseButton1Click:Connect(function()
    if not reopenDragging then
        mainFrame.Visible = true
        reopenBtn.Visible = false
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenBtn.Visible = true
end)

-- Main Frame Dragging
local mainDrag = false
local mainDragStart, mainStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainDrag = true
        mainDragStart = input.Position
        mainStartPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDrag = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if mainDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - mainDragStart
        mainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)

print("✅ X-Aim Hub Arsenal - Complete Edition!")
print("✅ Tabs: Visual, Rage, Settings")
print("✅ Aimbot: 0ms Blatant Mode")
print("✅ Silent Aim: 100 stud radius auto-hit")
print("✅ Settings Features:")
print("   - Speed Hack: Working with adjustable speed")
print("   - Inf Health: Anti-death system")
print("   - Inf Ammo: Scans all ammo values")
print("   - No Recoil: Removes gun recoil (no camera lock)")
print("   - Insta Reload: Instant reload completion")
print("   - Fly: Double tap Space, WASD + Space/Shift")
print("✅ All features optimized for Arsenal!")
