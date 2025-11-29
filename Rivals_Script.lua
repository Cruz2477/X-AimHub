-- Roblox Rivals X-Aim Hub - COMPLETE VERSION
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
local originalHitboxSizes = {}
local godModeConnection = nil
local invisibleParts = {}
local wallhackConnection = nil

-- Settings
local settings = {
    BoxESP = false,
    NameESP = false,
    TracerESP = false,
    DistanceESP = false,
    FOVCircle = false,
    FOVSize = 100,
    HitboxResize = false,
    HitboxSize = 10,
    Triggerbot = false,
    TriggerbotKey = Enum.KeyCode.Q,
    TeamCheck = true,
    Aimbot = false,
    AimbotType = "Blatant",
    ESPRange = 1000,
    GodMode = false,
    InfiniteJump = false,
    Invisible = false,
    Wallhack = false
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XAimHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "X-Aim Hub [RIVALS]"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
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

local aimTab = Instance.new("TextButton")
aimTab.Size = UDim2.new(0.33, 0, 1, 0)
aimTab.Position = UDim2.new(0.33, 0, 0, 0)
aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimTab.BorderSizePixel = 0
aimTab.Text = "Aim"
aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
aimTab.Font = Enum.Font.Gotham
aimTab.TextSize = 12
aimTab.Parent = tabContainer

local otherTab = Instance.new("TextButton")
otherTab.Size = UDim2.new(0.34, 0, 1, 0)
otherTab.Position = UDim2.new(0.66, 0, 0, 0)
otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
otherTab.BorderSizePixel = 0
otherTab.Text = "Other"
otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
otherTab.Font = Enum.Font.Gotham
otherTab.TextSize = 12
otherTab.Parent = tabContainer

-- Content Frames
local visualContent = Instance.new("ScrollingFrame")
visualContent.Size = UDim2.new(1, -20, 1, -80)
visualContent.Position = UDim2.new(0, 10, 0, 70)
visualContent.BackgroundTransparency = 1
visualContent.BorderSizePixel = 0
visualContent.ScrollBarThickness = 4
visualContent.CanvasSize = UDim2.new(0, 0, 0, 300)
visualContent.Parent = mainFrame

local aimContent = Instance.new("ScrollingFrame")
aimContent.Size = UDim2.new(1, -20, 1, -80)
aimContent.Position = UDim2.new(0, 10, 0, 70)
aimContent.BackgroundTransparency = 1
aimContent.BorderSizePixel = 0
aimContent.ScrollBarThickness = 4
aimContent.CanvasSize = UDim2.new(0, 0, 0, 400)
aimContent.Visible = false
aimContent.Parent = mainFrame

local otherContent = Instance.new("ScrollingFrame")
otherContent.Size = UDim2.new(1, -20, 1, -80)
otherContent.Position = UDim2.new(0, 10, 0, 70)
otherContent.BackgroundTransparency = 1
otherContent.BorderSizePixel = 0
otherContent.ScrollBarThickness = 4
otherContent.CanvasSize = UDim2.new(0, 0, 0, 150)
otherContent.Visible = false
otherContent.Parent = mainFrame

-- Tab Switching
visualTab.MouseButton1Click:Connect(function()
    visualContent.Visible = true
    aimContent.Visible = false
    otherContent.Visible = false
    visualTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

aimTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = true
    otherContent.Visible = false
    aimTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    aimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

otherTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = false
    otherContent.Visible = true
    otherTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    otherTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
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

local function createDropdown(parent, text, yPos, options, default, callback)
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
    button.Size = UDim2.new(0, 80, 0, 22)
    button.Position = UDim2.new(1, -87, 0.5, -11)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = default
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(0, 80, 0, #options * 25)
    list.Position = UDim2.new(1, -87, 1, 5)
    list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.Parent = frame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 4)
    listCorner.Parent = list
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -4, 0, 23)
        optBtn.Position = UDim2.new(0, 2, 0, (i - 1) * 25 + 1)
        optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 10
        optBtn.ZIndex = 11
        optBtn.Parent = list
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 3)
        optCorner.Parent = optBtn
        
        optBtn.MouseButton1Click:Connect(function()
            button.Text = opt
            list.Visible = false
            callback(opt)
        end)
    end
    
    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)
    
    return frame
end

-- RIVALS Team Check
local function isTeammate(player)
    if not settings.TeamCheck then return false end
    
    -- Method 1: Team property
    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        return true
    end
    
    -- Method 2: TeamColor
    if LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then
        return true
    end
    
    -- Method 3: Character team values
    if LocalPlayer.Character and player.Character then
        local myTeam = LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamValue")
        local theirTeam = player.Character:FindFirstChild("Team") or player.Character:FindFirstChild("TeamValue")
        if myTeam and theirTeam and myTeam.Value == theirTeam.Value then
            return true
        end
    end
    
    -- Method 4: Neutral check
    if not LocalPlayer.Neutral and not player.Neutral and LocalPlayer.Team == player.Team then
        return true
    end
    
    return false
end

local function isInRange(player)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    return (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= settings.ESPRange
end

-- ESP Functions
local function addBoxESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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

local function removeBoxESP(player)
    pcall(function()
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
    end)
end

local function addNameESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        if tracers[player] then removeTracerESP(player) end
        
        local gui = Instance.new("ScreenGui")
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer.PlayerGui
        
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Size = UDim2.new(0, 0, 0, 2)
        line.Parent = gui
        
        tracers[player] = {gui = gui, line = line}
    end)
end

local function removeTracerESP(player)
    pcall(function()
        if tracers[player] then
            tracers[player].gui:Destroy()
            tracers[player] = nil
        end
    end)
end

local function updateTracers()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    local size = cam.ViewportSize
    local center = Vector2.new(size.X / 2, size.Y / 2)
    
    for player, data in pairs(tracers) do
        pcall(function()
            if not player.Parent or isTeammate(player) or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                removeTracerESP(player)
                return
            end
            
            if not isInRange(player) then
                removeTracerESP(player)
                return
            end
            
            local pos, onScreen = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if pos.Z > 0 then
                local target = Vector2.new(pos.X, pos.Y)
                local dist = (center - target).Magnitude
                local angle = math.atan2(target.Y - center.Y, target.X - center.X)
                
                data.line.Size = UDim2.new(0, dist, 0, 2)
                data.line.Position = UDim2.new(0, center.X, 0, center.Y)
                data.line.Rotation = math.deg(angle)
                data.line.Visible = true
            else
                data.line.Visible = false
            end
        end)
    end
end

local function addDistanceESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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

local function maintainFOVCircle()
    if settings.FOVCircle and (not fovCircle or not fovCircle.gui or not fovCircle.gui.Parent) then
        createFOVCircle()
    end
end

-- Hitbox
local function resizeHitbox(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) or not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not originalHitboxSizes[player] then
        originalHitboxSizes[player] = {Size = hrp.Size, CanCollide = hrp.CanCollide}
    end
    
    hrp.Size = Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize)
    hrp.Transparency = 1
    hrp.CanCollide
hrp.Size = Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize)
    hrp.Transparency = 1
    hrp.CanCollide = false
    hrp.Massless = true
end

local function restoreHitbox(player)
    if not originalHitboxSizes[player] or not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.Size = originalHitboxSizes[player].Size
    hrp.CanCollide = originalHitboxSizes[player].CanCollide
    hrp.Massless = false
    originalHitboxSizes[player] = nil
end

local function updateAllHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if settings.HitboxResize and player ~= LocalPlayer and not isTeammate(player) and isInRange(player) then
            resizeHitbox(player)
        else
            restoreHitbox(player)
        end
    end
end

-- Aimbot
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
    
    if settings.AimbotType == "Blatant" then
        cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
    else
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, head.Position), 0.2)
    end
end

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
createToggle(visualContent, "BoxESP", 0, function(e)
    settings.BoxESP = e
    if e then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addBoxESP(p) end) end
        end
    else
        for p in pairs(highlights) do removeBoxESP(p) end
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

-- Aim Toggles
createToggle(aimContent, "Team Check", 0, function(e)
    settings.TeamCheck = e
    if settings.BoxESP then
        for p in pairs(highlights) do removeBoxESP(p) end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addBoxESP(p) end) end
        end
    end
    if settings.NameESP then
        for p in pairs(nameTags) do removeNameESP(p) end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addNameESP(p) end) end
        end
    end
    if settings.TracerESP then
        for p in pairs(tracers) do removeTracerESP(p) end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addTracerESP(p) end) end
        end
    end
    if settings.DistanceESP then
        for p in pairs(distanceLabels) do removeDistanceESP(p) end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then task.spawn(function() addDistanceESP(p) end) end
        end
    end
    updateAllHitboxes()
end)

createToggle(aimContent, "Hitbox Resize", 42, function(e)
    settings.HitboxResize = e
    updateAllHitboxes()
    local slider = aimContent:FindFirstChild("HitboxSlider")
    if slider then slider.Visible = e end
end)

-- Hitbox Slider
local hbSlider = Instance.new("Frame")
hbSlider.Name = "HitboxSlider"
hbSlider.Size = UDim2.new(1, 0, 0, 50)
hbSlider.Position = UDim2.new(0, 0, 0, 84)
hbSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hbSlider.BorderSizePixel = 0
hbSlider.Visible = false
hbSlider.Parent = aimContent

local hbCorner = Instance.new("UICorner")
hbCorner.CornerRadius = UDim.new(0, 6)
hbCorner.Parent = hbSlider

local hbLbl = Instance.new("TextLabel")
hbLbl.Size = UDim2.new(1, -20, 0, 20)
hbLbl.Position = UDim2.new(0, 10, 0, 5)
hbLbl.BackgroundTransparency = 1
hbLbl.Text = "Hitbox Size"
hbLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
hbLbl.Font = Enum.Font.Gotham
hbLbl.TextSize = 12
hbLbl.TextXAlignment = Enum.TextXAlignment.Left
hbLbl.Parent = hbSlider

local hbVal = Instance.new("TextLabel")
hbVal.Size = UDim2.new(0, 40, 0, 20)
hbVal.Position = UDim2.new(1, -50, 0, 5)
hbVal.BackgroundTransparency = 1
hbVal.Text = "10"
hbVal.TextColor3 = Color3.fromRGB(255, 255, 255)
hbVal.Font = Enum.Font.GothamBold
hbVal.TextSize = 11
hbVal.TextXAlignment = Enum.TextXAlignment.Right
hbVal.Parent = hbSlider

local hbBar = Instance.new("Frame")
hbBar.Size = UDim2.new(1, -20, 0, 4)
hbBar.Position = UDim2.new(0, 10, 1, -15)
hbBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hbBar.BorderSizePixel = 0
hbBar.Parent = hbSlider

local hbBarCorner = Instance.new("UICorner")
hbBarCorner.CornerRadius = UDim.new(1, 0)
hbBarCorner.Parent = hbBar

local hbFill = Instance.new("Frame")
hbFill.Size = UDim2.new(0.167, 0, 1, 0)
hbFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
hbFill.BorderSizePixel = 0
hbFill.Parent = hbBar

local hbFillCorner = Instance.new("UICorner")
hbFillCorner.CornerRadius = UDim.new(1, 0)
hbFillCorner.Parent = hbFill

local hbBtn = Instance.new("TextButton")
hbBtn.Size = UDim2.new(0, 12, 0, 12)
hbBtn.Position = UDim2.new(0.167, -6, 0.5, -6)
hbBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hbBtn.Text = ""
hbBtn.AutoButtonColor = false
hbBtn.Parent = hbBar

local hbBtnCorner = Instance.new("UICorner")
hbBtnCorner.CornerRadius = UDim.new(1, 0)
hbBtnCorner.Parent = hbBtn

local hbDrag = false

local function updateHB(input)
    if not hbBar.AbsoluteSize then return end
    local pos = math.clamp((input.Position.X - hbBar.AbsolutePosition.X) / hbBar.AbsoluteSize.X, 0, 1)
    local val = math.floor(2 + (50 - 2) * pos)
    hbVal.Text = tostring(val)
    hbFill.Size = UDim2.new(pos, 0, 1, 0)
    hbBtn.Position = UDim2.new(pos, -6, 0.5, -6)
    settings.HitboxSize = val
    if settings.HitboxResize then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not isTeammate(p) and p.Character and isInRange(p) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(val, val, val)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                    hrp.Massless = true
                end
            end
        end
    end
end

hbBtn.MouseButton1Down:Connect(function() hbDrag = true end)
hbBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        hbDrag = true
        updateHB(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then hbDrag = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if hbDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateHB(input)
    end
end)

local aimToggle = createToggle(aimContent, "Aimbot", 84, function(e)
    settings.Aimbot = e
    aimbotActive = e
    local dropdown = aimContent:FindFirstChild("AimbotDrop")
    if dropdown then dropdown.Visible = e end
end)

local aimbotDrop = createDropdown(aimContent, "Aimbot Type", 126, {"Blatant", "Legit"}, "Blatant", function(opt)
    settings.AimbotType = opt
end)
aimbotDrop.Name = "AimbotDrop"
aimbotDrop.Visible = false

createToggle(aimContent, "God Mode", 126, function(e)
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

createToggle(aimContent, "Wallhack", 168, function(e)
    settings.Wallhack = e
    if e then enableWallhack() else disableWallhack() end
end)

local trigToggle = createToggle(aimContent, "Triggerbot", 210, function(e)
    settings.Triggerbot = e
    triggerbotActive = false
    local kb = aimContent:FindFirstChild("TrigKB")
    if kb then kb.Visible = e end
end)

local trigKB = createKeybind(aimContent, "Triggerbot Key", 252, Enum.KeyCode.Q, function(key)
    settings.TriggerbotKey = key
end)
trigKB.Name = "TrigKB"
trigKB.Visible = false

-- Other Toggles
createToggle(otherContent, "Infinite Jump", 0, function(e)
    settings.InfiniteJump = e
    if e then enableInfiniteJump() else disableInfiniteJump() end
end)

createToggle(otherContent, "Invisible", 42, function(e)
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
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if settings.BoxESP then task.spawn(function() addBoxESP(player) end) end
        if settings.NameESP then task.spawn(function() addNameESP(player) end) end
        if settings.TracerESP then task.spawn(function() addTracerESP(player) end) end
        if settings.DistanceESP then task.spawn(function() addDistanceESP(player) end) end
        if settings.HitboxResize then task.spawn(function() resizeHitbox(player) end) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeBoxESP(player)
    removeNameESP(player)
    removeTracerESP(player)
    removeDistanceESP(player)
    restoreHitbox(player)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            task.wait(0.1)
            if settings.BoxESP then task.spawn(function() addBoxESP(player) end) end
            if settings.NameESP then task.spawn(function() addNameESP(player) end) end
            if settings.TracerESP then task.spawn(function() addTracerESP(player) end) end
            if settings.DistanceESP then task.spawn(function() addDistanceESP(player) end) end
            if settings.HitboxResize then task.spawn(function() resizeHitbox(player) end) end
        end
        
        player.CharacterAdded:Connect(function()
            if tracers[player] then removeTracerESP(player) end
            if distanceLabels[player] then removeDistanceESP(player) end
            task.wait(0.5)
            if settings.BoxESP then task.spawn(function() addBoxESP(player) end) end
            if settings.NameESP then task.spawn(function() addNameESP(player) end) end
            if settings.TracerESP then task.spawn(function() addTracerESP(player) end) end
            if settings.DistanceESP then task.spawn(function() addDistanceESP(player) end) end
            if settings.HitboxResize then task.spawn(function() resizeHitbox(player) end) end
        end)
    end
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    maintainFOVCircle()
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
    if settings.HitboxResize then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isTeammate(player) and player.Character and isInRange(player) then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Size ~= Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize) then
                    hrp.Size = Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                    hrp.Massless = true
                end
            end
        end
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if settings.Invisible then setInvisible(true) end
    if settings.InfiniteJump then enableInfiniteJump() end
end)

-- Reopen Button (DRAGGABLE)
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size = UDim2.new(0, 100, 0, 35)
reopenBtn.Position = UDim2.new(0, 10, 0, 10)
reopenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
reopenBtn.Text = "Open Config"
reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextSize = 11
reopenBtn.Visible = false
reopenBtn.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 6)
reopenCorner.Parent = reopenBtn

reopenBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenBtn.Visible = false
end)

-- Reopen Button Dragging
local reopenDrag = false
local reopenDragStart, reopenStartPos

reopenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        reopenDrag = true
        reopenDragStart = input.Position
        reopenStartPos = reopenBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                reopenDrag = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if reopenDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - reopenDragStart
        reopenBtn.Position = UDim2.new(reopenStartPos.X.Scale, reopenStartPos.X.Offset + delta.X, reopenStartPos.Y.Scale, reopenStartPos.Y.Offset + delta.Y)
    end
end)

-- Close Button
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

print("✅ X-Aim Hub [RIVALS] Loaded Successfully!")
print("✅ All features working within 1000 studs")
print("✅ Team Check: RIVALS-SPECIFIC with 4 detection methods")
print("✅ Sliders: FIXED and fully functional")
print("✅ ESP: FIXED with error handling")
print("✅ FOV Circle: FIXED (won't disappear)")
print("✅ Reopen Button: DRAGGABLE")
print("✅ Script: 100% COMPLETE")-- Roblox Rivals X-Aim Hub - COMPLETE VERSION
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
local originalHitboxSizes = {}
local godModeConnection = nil
local invisibleParts = {}
local wallhackConnection = nil

-- Settings
local settings = {
    BoxESP = false,
    NameESP = false,
    TracerESP = false,
    DistanceESP = false,
    FOVCircle = false,
    FOVSize = 100,
    HitboxResize = false,
    HitboxSize = 10,
    Triggerbot = false,
    TriggerbotKey = Enum.KeyCode.Q,
    TeamCheck = true,
    Aimbot = false,
    AimbotType = "Blatant",
    ESPRange = 1000,
    GodMode = false,
    InfiniteJump = false,
    Invisible = false,
    Wallhack = false
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XAimHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 1, 0)
title.BackgroundTransparency = 1
title.Text = "X-Aim Hub [RIVALS]"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
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

local aimTab = Instance.new("TextButton")
aimTab.Size = UDim2.new(0.33, 0, 1, 0)
aimTab.Position = UDim2.new(0.33, 0, 0, 0)
aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimTab.BorderSizePixel = 0
aimTab.Text = "Aim"
aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
aimTab.Font = Enum.Font.Gotham
aimTab.TextSize = 12
aimTab.Parent = tabContainer

local otherTab = Instance.new("TextButton")
otherTab.Size = UDim2.new(0.34, 0, 1, 0)
otherTab.Position = UDim2.new(0.66, 0, 0, 0)
otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
otherTab.BorderSizePixel = 0
otherTab.Text = "Other"
otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
otherTab.Font = Enum.Font.Gotham
otherTab.TextSize = 12
otherTab.Parent = tabContainer

-- Content Frames
local visualContent = Instance.new("ScrollingFrame")
visualContent.Size = UDim2.new(1, -20, 1, -80)
visualContent.Position = UDim2.new(0, 10, 0, 70)
visualContent.BackgroundTransparency = 1
visualContent.BorderSizePixel = 0
visualContent.ScrollBarThickness = 4
visualContent.CanvasSize = UDim2.new(0, 0, 0, 300)
visualContent.Parent = mainFrame

local aimContent = Instance.new("ScrollingFrame")
aimContent.Size = UDim2.new(1, -20, 1, -80)
aimContent.Position = UDim2.new(0, 10, 0, 70)
aimContent.BackgroundTransparency = 1
aimContent.BorderSizePixel = 0
aimContent.ScrollBarThickness = 4
aimContent.CanvasSize = UDim2.new(0, 0, 0, 400)
aimContent.Visible = false
aimContent.Parent = mainFrame

local otherContent = Instance.new("ScrollingFrame")
otherContent.Size = UDim2.new(1, -20, 1, -80)
otherContent.Position = UDim2.new(0, 10, 0, 70)
otherContent.BackgroundTransparency = 1
otherContent.BorderSizePixel = 0
otherContent.ScrollBarThickness = 4
otherContent.CanvasSize = UDim2.new(0, 0, 0, 150)
otherContent.Visible = false
otherContent.Parent = mainFrame

-- Tab Switching
visualTab.MouseButton1Click:Connect(function()
    visualContent.Visible = true
    aimContent.Visible = false
    otherContent.Visible = false
    visualTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    visualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

aimTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = true
    otherContent.Visible = false
    aimTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    aimTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTab.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

otherTab.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = false
    otherContent.Visible = true
    otherTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    otherTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    aimTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTab.TextColor3 = Color3.fromRGB(200, 200, 200)
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

local function createDropdown(parent, text, yPos, options, default, callback)
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
    button.Size = UDim2.new(0, 80, 0, 22)
    button.Position = UDim2.new(1, -87, 0.5, -11)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = default
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(0, 80, 0, #options * 25)
    list.Position = UDim2.new(1, -87, 1, 5)
    list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    list.Parent = frame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 4)
    listCorner.Parent = list
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -4, 0, 23)
        optBtn.Position = UDim2.new(0, 2, 0, (i - 1) * 25 + 1)
        optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 10
        optBtn.ZIndex = 11
        optBtn.Parent = list
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 3)
        optCorner.Parent = optBtn
        
        optBtn.MouseButton1Click:Connect(function()
            button.Text = opt
            list.Visible = false
            callback(opt)
        end)
    end
    
    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)
    
    return frame
end

-- RIVALS Team Check
local function isTeammate(player)
    if not settings.TeamCheck then return false end
    
    -- Method 1: Team property
    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        return true
    end
    
    -- Method 2: TeamColor
    if LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then
        return true
    end
    
    -- Method 3: Character team values
    if LocalPlayer.Character and player.Character then
        local myTeam = LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamValue")
        local theirTeam = player.Character:FindFirstChild("Team") or player.Character:FindFirstChild("TeamValue")
        if myTeam and theirTeam and myTeam.Value == theirTeam.Value then
            return true
        end
    end
    
    -- Method 4: Neutral check
    if not LocalPlayer.Neutral and not player.Neutral and LocalPlayer.Team == player.Team then
        return true
    end
    
    return false
end

local function isInRange(player)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
    return (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= settings.ESPRange
end

-- ESP Functions
local function addBoxESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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

local function removeBoxESP(player)
    pcall(function()
        if highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
    end)
end

local function addNameESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        if tracers[player] then removeTracerESP(player) end
        
        local gui = Instance.new("ScreenGui")
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer.PlayerGui
        
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Size = UDim2.new(0, 0, 0, 2)
        line.Parent = gui
        
        tracers[player] = {gui = gui, line = line}
    end)
end

local function removeTracerESP(player)
    pcall(function()
        if tracers[player] then
            tracers[player].gui:Destroy()
            tracers[player] = nil
        end
    end)
end

local function updateTracers()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    local size = cam.ViewportSize
    local center = Vector2.new(size.X / 2, size.Y / 2)
    
    for player, data in pairs(tracers) do
        pcall(function()
            if not player.Parent or isTeammate(player) or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                removeTracerESP(player)
                return
            end
            
            if not isInRange(player) then
                removeTracerESP(player)
                return
            end
            
            local pos, onScreen = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if pos.Z > 0 then
                local target = Vector2.new(pos.X, pos.Y)
                local dist = (center - target).Magnitude
                local angle = math.atan2(target.Y - center.Y, target.X - center.X)
                
                data.line.Size = UDim2.new(0, dist, 0, 2)
                data.line.Position = UDim2.new(0, center.X, 0, center.Y)
                data.line.Rotation = math.deg(angle)
                data.line.Visible = true
            else
                data.line.Visible = false
            end
        end)
    end
end

local function addDistanceESP(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) then return end
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

local function maintainFOVCircle()
    if settings.FOVCircle and (not fovCircle or not fovCircle.gui or not fovCircle.gui.Parent) then
        createFOVCircle()
    end
end

-- Hitbox
local function resizeHitbox(player)
    if player == LocalPlayer or isTeammate(player) or not isInRange(player) or not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not originalHitboxSizes[player] then
        originalHitboxSizes[player] = {Size = hrp.Size, CanCollide = hrp.CanCollide}
    end
    
    hrp.Size = Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize)
    hrp.Transparency = 1
    hrp.CanCollide
