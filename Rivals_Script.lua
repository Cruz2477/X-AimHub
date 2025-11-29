-- Roblox Rivals X-Aim Hub (FIXED VERSION)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Storage for ESP objects
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
screenGui.Name = "X-Aim Hub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
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
title.Text = "X-Aim Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeButton

-- Tab container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Visual Tab Button
local visualTabBtn = Instance.new("TextButton")
visualTabBtn.Name = "VisualTab"
visualTabBtn.Size = UDim2.new(0.33, 0, 1, 0)
visualTabBtn.Position = UDim2.new(0, 0, 0, 0)
visualTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
visualTabBtn.BorderSizePixel = 0
visualTabBtn.Text = "Visual"
visualTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTabBtn.Font = Enum.Font.Gotham
visualTabBtn.TextSize = 12
visualTabBtn.Parent = tabContainer

-- Aim Tab Button
local aimTabBtn = Instance.new("TextButton")
aimTabBtn.Name = "AimTab"
aimTabBtn.Size = UDim2.new(0.33, 0, 1, 0)
aimTabBtn.Position = UDim2.new(0.33, 0, 0, 0)
aimTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimTabBtn.BorderSizePixel = 0
aimTabBtn.Text = "Aim"
aimTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
aimTabBtn.Font = Enum.Font.Gotham
aimTabBtn.TextSize = 12
aimTabBtn.Parent = tabContainer

-- Other Tab Button
local otherTabBtn = Instance.new("TextButton")
otherTabBtn.Name = "OtherTab"
otherTabBtn.Size = UDim2.new(0.34, 0, 1, 0)
otherTabBtn.Position = UDim2.new(0.66, 0, 0, 0)
otherTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
otherTabBtn.BorderSizePixel = 0
otherTabBtn.Text = "Other"
otherTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
otherTabBtn.Font = Enum.Font.Gotham
otherTabBtn.TextSize = 12
otherTabBtn.Parent = tabContainer

-- Content frames
local visualContent = Instance.new("ScrollingFrame")
visualContent.Name = "VisualContent"
visualContent.Size = UDim2.new(1, -20, 1, -80)
visualContent.Position = UDim2.new(0, 10, 0, 70)
visualContent.BackgroundTransparency = 1
visualContent.BorderSizePixel = 0
visualContent.ScrollBarThickness = 4
visualContent.CanvasSize = UDim2.new(0, 0, 0, 280)
visualContent.Parent = mainFrame

local aimContent = Instance.new("ScrollingFrame")
aimContent.Name = "AimContent"
aimContent.Size = UDim2.new(1, -20, 1, -80)
aimContent.Position = UDim2.new(0, 10, 0, 70)
aimContent.BackgroundTransparency = 1
aimContent.BorderSizePixel = 0
aimContent.ScrollBarThickness = 4
aimContent.CanvasSize = UDim2.new(0, 0, 0, 400)
aimContent.Visible = false
aimContent.Parent = mainFrame

local otherContent = Instance.new("ScrollingFrame")
otherContent.Name = "OtherContent"
otherContent.Size = UDim2.new(1, -20, 1, -80)
otherContent.Position = UDim2.new(0, 10, 0, 70)
otherContent.BackgroundTransparency = 1
otherContent.BorderSizePixel = 0
otherContent.ScrollBarThickness = 4
otherContent.CanvasSize = UDim2.new(0, 0, 0, 100)
otherContent.Visible = false
otherContent.Parent = mainFrame

-- Tab switching
visualTabBtn.MouseButton1Click:Connect(function()
    visualContent.Visible = true
    aimContent.Visible = false
    otherContent.Visible = false
    visualTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    visualTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

aimTabBtn.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = true
    otherContent.Visible = false
    aimTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    aimTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    otherTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

otherTabBtn.MouseButton1Click:Connect(function()
    visualContent.Visible = false
    aimContent.Visible = false
    otherContent.Visible = true
    otherTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    otherTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    visualTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    aimTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    aimTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Function to create toggle
local function createToggle(parent, name, yPos, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 45, 0, 22)
    button.Position = UDim2.new(1, -52, 0.5, -11)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = button
    
    local enabled = false
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            button.Text = "ON"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.Text = "OFF"
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(enabled)
    end)
    
    return toggleFrame
end

-- Function to create keybind selector
local function createKeybind(parent, name, yPos, defaultKey, callback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Size = UDim2.new(1, 0, 0, 35)
    keybindFrame.Position = UDim2.new(0, 0, 0, yPos)
    keybindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = parent
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 6)
    keybindCorner.Parent = keybindFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = keybindFrame
    
    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0, 60, 0, 22)
    keyButton.Position = UDim2.new(1, -67, 0.5, -11)
    keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keyButton.Text = defaultKey.Name
    keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyButton.Font = Enum.Font.GothamBold
    keyButton.TextSize = 10
    keyButton.Parent = keybindFrame
    
    local keyBtnCorner = Instance.new("UICorner")
    keyBtnCorner.CornerRadius = UDim.new(0, 4)
    keyBtnCorner.Parent = keyButton
    
    local selecting = false
    
    keyButton.MouseButton1Click:Connect(function()
        if not selecting then
            selecting = true
            keyButton.Text = "..."
            keyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if selecting and input.UserInputType == Enum.UserInputType.Keyboard then
            selecting = false
            keyButton.Text = input.KeyCode.Name
            keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            callback(input.KeyCode)
        end
    end)
    
    return keybindFrame
end

-- Function to create dropdown
local function createDropdown(parent, name, yPos, options, defaultOption, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.Position = UDim2.new(0, 0, 0, yPos)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parent
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0, 80, 0, 22)
    dropdownButton.Position = UDim2.new(1, -87, 0.5, -11)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownButton.Text = defaultOption
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Font = Enum.Font.GothamBold
    dropdownButton.TextSize = 10
    dropdownButton.Parent = dropdownFrame
    
    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 4)
    dropBtnCorner.Parent = dropdownButton
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 80, 0, #options * 25)
    dropdownList.Position = UDim2.new(1, -87, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 10
    dropdownList.Parent = dropdownFrame
    
    local dropListCorner = Instance.new("UICorner")
    dropListCorner.CornerRadius = UDim.new(0, 4)
    dropListCorner.Parent = dropdownList
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, -4, 0, 23)
        optionButton.Position = UDim2.new(0, 2, 0, (i - 1) * 25 + 1)
        optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 10
        optionButton.ZIndex = 11
        optionButton.Parent = dropdownList
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 3)
        optCorner.Parent = optionButton
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return dropdownFrame
end

-- FIXED: Function to create slider
local function createSlider(parent, name, yPos, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPos)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    sliderBar.Position = UDim2.new(0, 10, 1, -15)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 14, 0, 14)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -7, 0.5, -7)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBar
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = input.Position
        local relX = math.clamp((pos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * relX)
        
        valueLabel.Text = tostring(value)
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relX, -7, 0.5, -7)
        
        callback(value)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderFrame
end

-- FIXED: Team check function for Rivals
local function isTeammate(player)
    if not settings.TeamCheck then return false end
    if player == LocalPlayer then return true end
    
    local myTeam = LocalPlayer.Team
    local theirTeam = player.Team
    
    -- If either has no team, not teammates
    if not myTeam or not theirTeam then return false end
    
    -- Direct comparison
    return myTeam == theirTeam
end

-- BoxESP Functions (FIXED: Auto-updates)
local function addBoxESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    -- Remove existing first
    if highlights[player] then
        highlights[player]:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BoxESP"
    highlight.Adornee = char
    
    -- Set color based on team
    if isTeammate(player) then
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    end
    
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = char
    
    highlights[player] = highlight
end

local function removeBoxESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

-- NameESP Functions (FIXED: Auto-updates)
local function addNameESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    -- Remove existing first
    if nameTags[player] then
        nameTags[player]:Destroy()
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    
    -- Set color based on team
    if isTeammate(player) then
        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard
    
    nameTags[player] = billboard
end

local function removeNameESP(player)
    if nameTags[player] then
        nameTags[player]:Destroy()
        nameTags[player] = nil
    end
end

-- TracerESP Functions (FIXED: Auto-updates)
local function addTracerESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Remove existing first
    if tracers[player] then
        removeTracerESP(player)
    end
    
    local tracerGui = Instance.new("ScreenGui")
    tracerGui.Name = "TracerESP_" .. player.Name
    tracerGui.IgnoreGuiInset = true
    tracerGui.ResetOnSpawn = false
    tracerGui.Parent = LocalPlayer.PlayerGui
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    
    -- Set color based on team
    if isTeammate(player) then
        line.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    line.BorderSizePixel = 0
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Parent = tracerGui
    
    tracers[player] = {gui = tracerGui, line = line}
end

local function removeTracerESP(player)
    if tracers[player] then
        if tracers[player].gui then
            tracers[player].gui:Destroy()
        end
        tracers[player] = nil
    end
end

local function updateTracers()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenSize = camera.ViewportSize
    local centerScreen = Vector2.new(screenSize.X / 2, screenSize.Y)
    
    for player, data in pairs(tracers) do
        if not player or not player.Parent or not Players:GetPlayerByUserId(player.UserId) then
            removeTracerESP(player)
            continue
        end
        
        local char = player.Character
        if char and char.Parent then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then
                local hrpPos = hrp.Position
                local screenPos, onScreen = camera:WorldToViewportPoint(hrpPos)
                
                if screenPos.Z > 0 then
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (centerScreen - targetPos).Magnitude
                    local angle = math.atan2(targetPos.Y - centerScreen.Y, targetPos.X - centerScreen.X)
                    
                    data.line.Size = UDim2.new(0, distance, 0, 2)
                    data.line.Position = UDim2.new(0, centerScreen.X, 0, centerScreen.Y)
                    data.line.Rotation = math.deg(angle)
                    data.line.Visible = true
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

-- DistanceESP Functions (FIXED: Auto-updates)
local function addDistanceESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if distanceLabels[player] then
        distanceLabels[player]:Destroy()
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DistanceESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(3, 0, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 1, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 14
    distLabel.Parent = billboard
    
    distanceLabels[player] = billboard
end

local function removeDistanceESP(player)
    if distanceLabels[player] then
        distanceLabels[player]:Destroy()
        distanceLabels[player] = nil
    end
end

local function updateDistanceLabels()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for player, billboard in pairs(distanceLabels) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local theirPos = player.Character.HumanoidRootPart.Position
            local distance = (myPos - theirPos).Magnitude
            local distLabel = billboard:FindFirstChildOfClass("TextLabel")
            if distLabel then
                distLabel.Text = string.format("%.0fm", distance)
            end
        end
    end
end

-- FOV Circle Functions
local function createFOVCircle()
    if fovCircle then return end
    
    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "FOVCircle"
    fovGui.IgnoreGuiInset = true
    fovGui.Parent = LocalPlayer.PlayerGui
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.Size = UDim2.new(0, settings.FOVSize * 2, 0, settings.FOVSize * 2)
    circle.BackgroundTransparency = 1
    circle.Parent = fovGui
    
    local circleOutline = Instance.new("UIStroke")
    circleOutline.Color = Color3.fromRGB(255, 255, 255)
    circleOutline.Thickness = 2
    circleOutline.Transparency = 0
    circleOutline.Parent = circle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    fovCircle = {gui = fovGui, circle = circle}
end

local function removeFOVCircle()
    if fovCircle then
        fovCircle.gui:Destroy()
        fovCircle = nil
    end
end

-- Hitbox Resize Functions (FIXED)
local function resizeHitbox(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not originalHitboxSizes[player] then
        originalHitboxSizes[player] = {
            Size = hrp.Size,
            CanCollide = hrp.CanCollide
        }
    end
    
    hrp.Size = Vector3.new(settings.HitboxSize, settings.HitboxSize, settings.HitboxSize)
    hrp.Transparency = 1
    hrp.CanCollide = false
    hrp.Massless = true
end

local function restoreHitbox(player)
    if not originalHitboxSizes[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.Size = originalHitboxSizes[player].Size
    hrp.Transparency = 1
    hrp.CanCollide = originalHitboxSizes[player].CanCollide
    hrp.Massless = false
    
    originalHitboxSizes[player] = nil
end

-- Aimbot Functions
local aimbotActive = false

local function getNearestPlayer()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if isTeammate(player) then continue end
        
        local char = player.Character
        if char then
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance > 1000 then continue end
                end
                
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen and screenPos.Z > 0 then
                    local origin = camera.CFrame.Position
                    local direction = (head.Position - origin).Unit * (head.Position - origin).Magnitude
                    
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, camera}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
                    
                    if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(char) then
                        local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        if screenDistance < shortestDistance then
                            shortestDistance = screenDistance
                            nearestPlayer = player
                        end
                    end
                end
            end
        end
    end
    
    return nearestPlayer
end

local function aimAtPlayer(player)
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local origin = camera.CFrame.Position
    local direction = (head.Position - origin).Unit * (head.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(player.Character) then
        local targetPos = head.Position
        local currentCFrame = camera.CFrame
        
        if settings.AimbotType == "Blatant" then
            camera.CFrame = CFrame.new(currentCFrame.Position, targetPos)
        else
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.2)
        end
    end
end

-- Triggerbot
local triggerbotActive = false

local function lockOntoPlayer(player)
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    task.spawn(function()
        mouse1click()
    end)
end

-- Infinite Jump
local infiniteJumpConnection = nil

local function enableInfiniteJump()
    if infiniteJumpConnection then return end
    
    infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if settings.InfiniteJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function disableInfiniteJump()
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
end

-- Invisible
local function setInvisible(enabled)
    if not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                if enabled then
                    if not invisibleParts[part] then
                        invisibleParts[part] = part.Transparency
                        part.Transparency = 1
                        if part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                else
                    if invisibleParts[part] then
                        part.Transparency = invisibleParts[part]
                        invisibleParts[part] = nil
                    end
                end
            end
        elseif part:IsA("Decal") or part:IsA("Face") or part:IsA("Texture") then
            if enabled then
                if not invisibleParts[part] then
                    invisibleParts[part] = part.Transparency
                    part.Transparency = 1
                end
            else
                if invisibleParts[part] then
                    part.Transparency = invisibleParts[part]
                    invisibleParts[part] = nil
                end
            end
        end
    end
    
    for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
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

-- VISUAL TAB
createToggle(visualContent, "BoxESP", 0, function(enabled)
    settings.BoxESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                addBoxESP(player)
            end
        end
    else
        for player in pairs(highlights) do
            removeBoxESP(player)
        end
    end
end)

createToggle(visualContent, "NameESP", 42, function(enabled)
    settings.NameESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                addNameESP(player)
            end
        end
    else
        for player in pairs(nameTags) do
            removeNameESP(player)
        end
    end
end)

createToggle(visualContent, "TracerESP", 84, function(enabled)
    settings.TracerESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                addTracerESP(player)
            end
        end
    else
        for player in pairs(tracers) do
            removeTracerESP(player)
        end
    end
end)

createToggle(visualContent, "DistanceESP", 126, function(enabled)
    settings.DistanceESP = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                addDistanceESP(player)
            end
        end
    else
        for player in pairs(distanceLabels) do
            removeDistanceESP(player)
        end
    end
end)

createToggle(visualContent, "FOV Circle", 168, function(enabled)
    settings.FOVCircle = enabled
    if enabled then
        createFOVCircle()
    else
        removeFOVCircle()
    end
end)

createSlider(visualContent, "FOV Size", 210, 50, 300, 100, function(value)
    settings.FOVSize = value
    if fovCircle then
        fovCircle.circle.Size = UDim2.new(0, value * 2, 0, value * 2)
    end
end)

-- AIM TAB
createToggle(aimContent, "Team Check", 0, function(enabled)
    settings.TeamCheck = enabled
    
    -- Update all ESP colors
    for player, highlight in pairs(highlights) do
        if highlight and player.Character then
            if isTeammate(player) then
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    for player, billboard in pairs(nameTags) do
        if billboard and player.Character then
            local nameLabel = billboard:FindFirstChildOfClass("TextLabel")
            if nameLabel then
                if isTeammate(player) then
                    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                else
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
    
    for player, data in pairs(tracers) do
        if player.Character and data.line then
            if isTeammate(player) then
                data.line.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                data.line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end)

createToggle(aimContent, "Hitbox Resize", 42, function(enabled)
    settings.HitboxResize = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                resizeHitbox(player)
            end
        end
    else
        for player in pairs(originalHitboxSizes) do
            restoreHitbox(player)
        end
    end
end)

createSlider(aimContent, "Hitbox Size", 84, 2, 50, 10, function(value)
    settings.HitboxSize = value
    if settings.HitboxResize then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(value, value, value)
                end
            end
        end
    end
end)

createToggle(aimContent, "Aimbot", 141, function(enabled)
    settings.Aimbot = enabled
    aimbotActive = enabled
end)

createDropdown(aimContent, "Aimbot Type", 183, {"Blatant", "Legit"}, "Blatant", function(option)
    settings.AimbotType = option
end)

createToggle(aimContent, "Triggerbot", 225, function(enabled)
    settings.Triggerbot = enabled
    triggerbotActive = false
end)

createKeybind(aimContent, "Triggerbot Key", 267, Enum.KeyCode.Q, function(key)
    settings.TriggerbotKey = key
end)

-- OTHER TAB
createToggle(otherContent, "Infinite Jump", 0, function(enabled)
    settings.InfiniteJump = enabled
    if enabled then
        enableInfiniteJump()
    else
        disableInfiniteJump()
    end
end)

createToggle(otherContent, "Invisible", 42, function(enabled)
    settings.Invisible = enabled
    setInvisible(enabled)
end)

-- FIXED: Player event handlers that auto-update ESP
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 5)
        wait(0.5)
        
        if settings.BoxESP then addBoxESP(player) end
        if settings.NameESP then addNameESP(player) end
        if settings.TracerESP then addTracerESP(player) end
        if settings.DistanceESP then addDistanceESP(player) end
        if settings.HitboxResize then resizeHitbox(player) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeBoxESP(player)
    removeNameESP(player)
    removeTracerESP(player)
    removeDistanceESP(player)
    restoreHitbox(player)
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            if settings.BoxESP then addBoxESP(player) end
            if settings.NameESP then addNameESP(player) end
            if settings.TracerESP then addTracerESP(player) end
            if settings.DistanceESP then addDistanceESP(player) end
            if settings.HitboxResize then resizeHitbox(player) end
        end
        
        player.CharacterAdded:Connect(function(char)
            removeTracerESP(player)
            removeDistanceESP(player)
            
            char:WaitForChild("HumanoidRootPart", 5)
            wait(0.5)
            
            if settings.BoxESP then addBoxESP(player) end
            if settings.NameESP then addNameESP(player) end
            if settings.TracerESP then addTracerESP(player) end
            if settings.DistanceESP then addDistanceESP(player) end
            if settings.HitboxResize then resizeHitbox(player) end
        end)
    end
end

-- Main update loop
RunService.RenderStepped:Connect(function()
    if settings.TracerESP then
        updateTracers()
    end
    
    if settings.DistanceESP then
        updateDistanceLabels()
    end
    
    if settings.Aimbot and aimbotActive then
        local target = getNearestPlayer()
        if target then
            aimAtPlayer(target)
        end
    end
end)

-- Triggerbot input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if settings.Triggerbot and input.KeyCode == settings.TriggerbotKey then
        triggerbotActive = true
        
        while triggerbotActive and settings.Triggerbot do
            local target = getNearestPlayer()
            if target then
                lockOntoPlayer(target)
            end
            task.wait(0.01)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == settings.TriggerbotKey then
        triggerbotActive = false
    end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    if settings.Invisible then
        setInvisible(true)
    end
    if settings.InfiniteJump then
        enableInfiniteJump()
    end
end)

-- Reopen button
local reopenButton = Instance.new("TextButton")
reopenButton.Name = "ReopenButton"
reopenButton.Size = UDim2.new(0, 100, 0, 35)
reopenButton.Position = UDim2.new(0, 10, 0, 10)
reopenButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
reopenButton.Text = "Open Config"
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Font = Enum.Font.GothamBold
reopenButton.TextSize = 11
reopenButton.Visible = false
reopenButton.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 6)
reopenCorner.Parent = reopenButton

reopenButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenButton.Visible = true
end)

-- Make draggable
local windowDragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        windowDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                windowDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if windowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
