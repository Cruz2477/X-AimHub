-- Roblox Rivals Visual Config
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

-- Add corner
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
visualContent.Parent = mainFrame

local aimContent = Instance.new("ScrollingFrame")
aimContent.Name = "AimContent"
aimContent.Size = UDim2.new(1, -20, 1, -80)
aimContent.Position = UDim2.new(0, 10, 0, 70)
aimContent.BackgroundTransparency = 1
aimContent.BorderSizePixel = 0
aimContent.ScrollBarThickness = 4
aimContent.Visible = false
aimContent.Parent = mainFrame

local otherContent = Instance.new("ScrollingFrame")
otherContent.Name = "OtherContent"
otherContent.Size = UDim2.new(1, -20, 1, -80)
otherContent.Position = UDim2.new(0, 10, 0, 70)
otherContent.BackgroundTransparency = 1
otherContent.BorderSizePixel = 0
otherContent.ScrollBarThickness = 4
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
    keybindFrame.Visible = false
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
    dropdownFrame.Visible = false
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

-- Function to create slider (FIXED VERSION)
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
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Active = true
    sliderButton.Parent = sliderBar
    
    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(1, 0)
    sliderBtnCorner.Parent = sliderButton
    
    local sliderDragging = false
    
    local function updateSlider(inputX)
        if not sliderBar or not sliderBar.Parent then return end
        
        wait() -- Small delay to ensure AbsolutePosition is updated
        
        local relativePos = (inputX - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
        relativePos = math.clamp(relativePos, 0, 1)
        
        local value = math.floor(minVal + (maxVal - minVal) * relativePos)
        valueLabel.Text = tostring(value)
        sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativePos, -6, 0.5, -6)
        
        callback(value)
    end
    
    -- Start dragging from button
    sliderButton.MouseButton1Down:Connect(function()
        sliderDragging = true
    end)
    
    sliderButton.TouchTap:Connect(function()
        sliderDragging = true
    end)
    
    -- Start dragging from bar click
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            task.spawn(function()
                updateSlider(input.Position.X)
            end)
        end
    end)
    
    -- Stop dragging
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
    
    -- Update while dragging
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            task.spawn(function()
                updateSlider(input.Position.X)
            end)
        end
    end)
end

-- BoxESP Functions
local function addBoxESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    -- Remove existing highlight first
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BoxESP"
    highlight.Adornee = char
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
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

-- NameESP Functions
local function addNameESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    -- Check distance
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance > settings.ESPRange then return end
    end
    
    -- Remove existing name tag first
    if nameTags[player] then
        nameTags[player]:Destroy()
        nameTags[player] = nil
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
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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

-- TracerESP Functions (FIXED)
local function addTracerESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Check distance
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance > settings.ESPRange then return end
    end
    
    -- Remove existing tracer first
    if tracers[player] then
        removeTracerESP(player)
    end
    
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
        local tracerGui = Instance.new("ScreenGui")
        tracerGui.Name = "TracerESP_" .. player.Name
        tracerGui.IgnoreGuiInset = true
        tracerGui.ResetOnSpawn = false
        tracerGui.Parent = LocalPlayer.PlayerGui
        
        local line = Instance.new("Frame")
        line.Name = "Line"
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Size = UDim2.new(0, 0, 0, 2)
        line.Parent = tracerGui
        
        tracers[player] = {gui = tracerGui, line = line, isDrawing = false}
    end
end

local function removeTracerESP(player)
    if tracers[player] then
        if tracers[player].isDrawing and tracers[player].line then
            tracers[player].line:Remove()
        elseif tracers[player].gui then
            tracers[player].gui:Destroy()
        end
        tracers[player] = nil
    end
end

local function updateTracers()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenSize = camera.ViewportSize
    local centerScreen = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    
    for player, data in pairs(tracers) do
        -- Check if player still exists and is in the game
        if not player or not player.Parent or not Players:GetPlayerByUserId(player.UserId) then
            removeTracerESP(player)
            continue
        end
        
        local char = player.Character
        if char and char.Parent then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then
                -- Check distance
                local inRange = true
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    inRange = distance <= settings.ESPRange
                end
                
                if inRange then
                    local hrpPos = hrp.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(hrpPos)
                    
                    if screenPos.Z > 0 then
                        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                        
                        if data.isDrawing then
                            -- Drawing API method
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
                -- HumanoidRootPart is gone, remove tracer
                removeTracerESP(player)
            end
        else
            -- Character is gone, remove tracer
            removeTracerESP(player)
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

-- Hitbox Resize Functions
local function resizeHitbox(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Check if within range (1000 studs)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if distance > 1000 then return end
    end
    
    -- Store original size if not already stored
    if not originalHitboxSizes[player] then
        originalHitboxSizes[player] = {
            Size = hrp.Size,
            CanCollide = hrp.CanCollide
        }
    end
    
    -- CRITICAL FIX: Resize hitbox to current slider value and make massless
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
    
    -- Restore original size and properties
    hrp.Size = originalHitboxSizes[player].Size
    hrp.Transparency = 1
    hrp.CanCollide = originalHitboxSizes[player].CanCollide
    hrp.Massless = false
    
    originalHitboxSizes[player] = nil
end

local function updateAllHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if settings.HitboxResize then
            if player ~= LocalPlayer and player.Character then
                resizeHitbox(player)
            end
        else
            restoreHitbox(player)
        end
    end
end

-- Triggerbot Functions
local triggerbotActive = false

local function isTeammate(player)
    -- If team check is disabled, return false (target everyone)
    if not settings.TeamCheck then 
        return false 
    end
    
    -- Get both teams
    local myTeam = LocalPlayer.Team
    local theirTeam = player.Team
    
    -- If no team exists, they're not teammates
    if not myTeam or not theirTeam then 
        return false 
    end
    
    -- Return true ONLY if same team
    return myTeam == theirTeam
end

local function getNearestPlayer()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        -- FIRST: Skip self
        if player == LocalPlayer then continue end
        
        -- SECOND: Check teammate status IMMEDIATELY
        if isTeammate(player) then continue end
        
        local char = player.Character
        if not char then continue end
        
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if not head or not hrp then continue end
        
        -- Check distance (within 1000 studs)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance > 1000 then continue end
        end
        
        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
        
        if onScreen and screenPos.Z > 0 then
            -- Check visibility with raycast
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
    
    return nearestPlayer
end

-- Aimbot Functions
local aimbotActive = false

local function aimAtPlayer(player, smoothness)
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- Verify player is visible (not behind walls)
    local origin = camera.CFrame.Position
    local direction = (head.Position - origin).Unit * (head.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    -- Only aim if player is visible
    if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(player.Character) then
        local targetPos = head.Position
        local currentCFrame = camera.CFrame
        
        if settings.AimbotType == "Blatant" then
            -- Instant snap to target (100% headshot rate)
            camera.CFrame = CFrame.new(currentCFrame.Position, targetPos)
        else
            -- Legit smooth aim
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
            camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness or 0.2)
        end
    end
end

-- God Mode Functions
local godModeTarget = nil

local function teleportBehindPlayer(player)
    if not player or not player.Character then return end
    if not LocalPlayer.Character then return end
    
    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetHRP or not myHRP then return end
    
    -- Calculate position behind the target
    local behindPos = targetHRP.CFrame * CFrame.new(0, 0, 3) -- 3 studs behind
    
    -- Smooth tween to position
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {CFrame = behindPos}
    
    local tween = TweenService:Create(myHRP, tweenInfo, goal)
    tween:Play()
end

-- Infinite Jump Function
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

-- Invisible Function
local function setInvisible(enabled)
    if not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                if enabled then
                    if not invisibleParts[part] then
                        invisibleParts[part] = part.Transparency
                        part.Transparency = 1
                        -- Also make it non-collidable
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
    
    -- Make accessories invisible too
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

local function lockOntoPlayer(player)
    if not player or not player.Character then return end
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- Lock camera onto head
    camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    
    -- Simulate shooting
    task.spawn(function()
        mouse1click()
    end)
end

-- Wallhack Functions
local function enableWallhack()
    if wallhackConnection then return end
    
    -- Make all bullets/projectiles ignore walls
    wallhackConnection = RunService.Heartbeat:Connect(function()
        if not settings.Wallhack then return end
        
        -- Find all projectiles/bullets in workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("bullet") or obj.Name:lower():find("projectile") or obj.Name:lower():find("shot")) then
                -- Check if it belongs to local player
                if obj:FindFirstAncestorOfClass("Model") then
                    local model = obj:FindFirstAncestorOfClass("Model")
                    if model and Players:GetPlayerFromCharacter(model) == LocalPlayer then
                        obj.CanCollide = false
                        -- Make it pass through everything except players
                        if obj:FindFirstChild("BodyVelocity") or obj:FindFirstChild("BodyForce") then
                            obj.CanCollide = false
                        end
                    end
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
end

-- DistanceESP Functions
local function addDistanceESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Remove existing distance label
    if distanceLabels[player] then
        distanceLabels[player]:Destroy()
        distanceLabels[player] = nil
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DistanceESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(3, 0, 0) -- 90 degree angle to the side
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

-- Update functions
local function updateBoxESP()
    -- Not used anymore - handled by toggle directly
end

local function updateNameESP()
    -- Not used anymore - handled by toggle directly
end

local function updateTracerESP()
    -- Not used anymore - handled by toggle directly
end

-- Create toggles
createToggle(visualContent, "BoxESP", 0, function(enabled)
    settings.BoxESP = enabled
    if enabled then
        -- Add ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                task.spawn(function()
                    addBoxESP(player)
                end)
            end
        end
    else
        -- Remove all ESP
        for player, highlight in pairs(highlights) do
            if highlight then
                highlight:Destroy()
            end
            highlights[player] = nil
        end
    end
end)

createToggle(visualContent, "NameESP", 42, function(enabled)
    settings.NameESP = enabled
    if enabled then
        -- Add ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                task.spawn(function()
                    addNameESP(player)
                end)
            end
        end
    else
        -- Remove all ESP
        for player, tag in pairs(nameTags) do
            if tag then
                tag:Destroy()
            end
            nameTags[player] = nil
        end
    end
end)

createToggle(visualContent, "TracerESP", 84, function(enabled)
    settings.TracerESP = enabled
    if enabled then
        -- Add ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                task.spawn(function()
                    addTracerESP(player)
                end)
            end
        end
    else
        -- Remove all ESP
        for player, data in pairs(tracers) do
            removeTracerESP(player)
        end
    end
end)

createToggle(visualContent, "DistanceESP", 126, function(enabled)
    settings.DistanceESP = enabled
    if enabled then
        -- Add distance ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                task.spawn(function()
                    addDistanceESP(player)
                end)
            end
        end
    else
        -- Remove all distance ESP
        for player, billboard in pairs(distanceLabels) do
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
    
    -- Show/hide FOV size slider
    local fovSlider = visualContent:FindFirstChild("FOVSlider")
    if fovSlider then
        fovSlider.Visible = enabled
    end
end)

-- Other Tab Toggles
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

-- Create FOV slider (starts hidden)
local fovSlider = Instance.new("Frame")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(1, 0, 0, 50)
fovSlider.Position = UDim2.new(0, 0, 0, 210)
fovSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fovSlider.BorderSizePixel = 0
fovSlider.Visible = false
fovSlider.Parent = visualContent

local fovSliderCorner = Instance.new("UICorner")
fovSliderCorner.CornerRadius = UDim.new(0, 6)
fovSliderCorner.Parent = fovSlider

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -20, 0, 20)
fovLabel.Position = UDim2.new(0, 10, 0, 5)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size"
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 12
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = fovSlider

local fovValueLabel = Instance.new("TextLabel")
fovValueLabel.Size = UDim2.new(0, 40, 0, 20)
fovValueLabel.Position = UDim2.new(1, -50, 0, 5)
fovValueLabel.BackgroundTransparency = 1
fovValueLabel.Text = "100"
fovValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovValueLabel.Font = Enum.Font.GothamBold
fovValueLabel.TextSize = 11
fovValueLabel.TextXAlignment = Enum.TextXAlignment.Right
fovValueLabel.Parent = fovSlider

local fovSliderBar = Instance.new("Frame")
fovSliderBar.Size = UDim2.new(1, -20, 0, 4)
fovSliderBar.Position = UDim2.new(0, 10, 1, -15)
fovSliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovSliderBar.BorderSizePixel = 0
fovSliderBar.Parent = fovSlider

local fovSliderBarCorner = Instance.new("UICorner")
fovSliderBarCorner.CornerRadius = UDim.new(1, 0)
fovSliderBarCorner.Parent = fovSliderBar

local fovSliderFill = Instance.new("Frame")
fovSliderFill.Size = UDim2.new((100 - 50) / (300 - 50), 0, 1, 0)
fovSliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
fovSliderFill.BorderSizePixel = 0
fovSliderFill.Parent = fovSliderBar

local fovSliderFillCorner = Instance.new("UICorner")
fovSliderFillCorner.CornerRadius = UDim.new(1, 0)
fovSliderFillCorner.Parent = fovSliderFill

local fovSliderButton = Instance.new("TextButton")
fovSliderButton.Size = UDim2.new(0, 12, 0, 12)
fovSliderButton.Position = UDim2.new((100 - 50) / (300 - 50), -6, 0.5, -6)
fovSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovSliderButton.Text = ""
fovSliderButton.AutoButtonColor = false
fovSliderButton.Active = true
fovSliderButton.Parent = fovSliderBar

local fovSliderBtnCorner = Instance.new("UICorner")
fovSliderBtnCorner.CornerRadius = UDim.new(1, 0)
fovSliderBtnCorner.Parent = fovSliderButton

local fovSliderDragging = false

local function updateFOVSlider(inputX)
    if not fovSliderBar or not fovSliderBar.Parent then return end
    
    wait()
    
    local relativePos = (inputX - fovSliderBar.AbsolutePosition.X) / fovSliderBar.AbsoluteSize.X
    relativePos = math.clamp(relativePos, 0, 1)
    
    local value = math.floor(50 + (300 - 50) * relativePos)
    fovValueLabel.Text = tostring(value)
    fovSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
    fovSliderButton.Position = UDim2.new(relativePos, -6, 0.5, -6)
    
    settings.FOVSize = value
    if fovCircle then
        fovCircle.circle.Size = UDim2.new(0, value * 2, 0, value * 2)
    end
end

fovSliderButton.MouseButton1Down:Connect(function()
    fovSliderDragging = true
end)

fovSliderButton.TouchTap:Connect(function()
    fovSliderDragging = true
end)

fovSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fovSliderDragging = true
        task.spawn(function()
            updateFOVSlider(input.Position.X)
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fovSliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if fovSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        task.spawn(function()
            updateFOVSlider(input.Position.X)
        end)
    end
end)

-- Aim Tab Toggles
local hitboxSizeSlider
local triggerbotKeybind
local aimbotTypeDropdown

createToggle(aimContent, "Team Check", 0, function(enabled)
    settings.TeamCheck = enabled
    
    -- Update all ESP colors when team check changes
    if settings.BoxESP then
        for player, highlight in pairs(highlights) do
            if highlight and player.Character then
                if enabled and isTeammate(player) then
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                else
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
    
    if settings.NameESP then
        for player, billboard in pairs(nameTags) do
            if billboard and player.Character then
                local nameLabel = billboard:FindFirstChildOfClass("TextLabel")
                if nameLabel then
                    if enabled and isTeammate(player) then
                        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    else
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
    
    if settings.TracerESP then
        for player, data in pairs(tracers) do
            if player.Character then
                if data.isDrawing then
                    if enabled and isTeammate(player) then
                        data.line.Color = Color3.new(0, 1, 0)
                    else
                        data.line.Color = Color3.new(1, 1, 1)
                    end
                else
                    if enabled and isTeammate(player) then
                        data.line.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    else
                        data.line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
end)

createToggle(aimContent, "Hitbox Resize", 42, function(enabled)
    settings.HitboxResize = enabled
    updateAllHitboxes()
    
    -- Show/hide hitbox size slider
    if hitboxSizeSlider then
        hitboxSizeSlider.Visible = enabled
        
        -- Adjust aimbot toggle position
        local aimbotToggle = aimContent:FindFirstChild("AimbotToggle")
        if aimbotToggle then
            if enabled then
                aimbotToggle.Position = UDim2.new(0, 0, 0, 142)
            else
                aimbotToggle.Position = UDim2.new(0, 0, 0, 84)
            end
        end
        
        -- Adjust aimbot type dropdown position
        if aimbotTypeDropdown then
            if enabled then
                aimbotTypeDropdown.Position = UDim2.new(0, 0, 0, 184)
            else
                aimbotTypeDropdown.Position = UDim2.new(0, 0, 0, 126)
            end
        end
        
        -- Adjust god mode position
        local godModeToggle = aimContent:FindFirstChild("GodModeToggle")
        if godModeToggle then
            if enabled then
                godModeToggle.Position = UDim2.new(0, 0, 0, 226)
            else
                godModeToggle.Position = UDim2.new(0, 0, 0, 168)
            end
        end
        
        -- Adjust triggerbot toggle position
        local triggerbotToggle = aimContent:FindFirstChild("TriggerbotToggle")
        if triggerbotToggle then
            if enabled then
                triggerbotToggle.Position = UDim2.new(0, 0, 0, 268)
            else
                triggerbotToggle.Position = UDim2.new(0, 0, 0, 210)
            end
        end
        
        -- Adjust triggerbot keybind position
        if triggerbotKeybind then
            if enabled then
                triggerbotKeybind.Position = UDim2.new(0, 0, 0, 310)
            else
                triggerbotKeybind.Position = UDim2.new(0, 0, 0, 252)
            end
        end
    end
end)

-- Create hitbox size slider (initially hidden)
hitboxSizeSlider = Instance.new("Frame")
hitboxSizeSlider.Size = UDim2.new(1, 0, 0, 50)
hitboxSizeSlider.Position = UDim2.new(0, 0, 0, 84)
hitboxSizeSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hitboxSizeSlider.BorderSizePixel = 0
hitboxSizeSlider.Visible = false
hitboxSizeSlider.Parent = aimContent

local hitboxSliderCorner = Instance.new("UICorner")
hitboxSliderCorner.CornerRadius = UDim.new(0, 6)
hitboxSliderCorner.Parent = hitboxSizeSlider

local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(1, -20, 0, 20)
hitboxLabel.Position = UDim2.new(0, 10, 0, 5)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.Text = "Hitbox Size"
hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxLabel.Font = Enum.Font.Gotham
hitboxLabel.TextSize = 12
hitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
hitboxLabel.Parent = hitboxSizeSlider

local hitboxValueLabel = Instance.new("TextLabel")
hitboxValueLabel.Size = UDim2.new(0, 40, 0, 20)
hitboxValueLabel.Position = UDim2.new(1, -50, 0, 5)
hitboxValueLabel.BackgroundTransparency = 1
hitboxValueLabel.Text = "10"
hitboxValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxValueLabel.Font = Enum.Font.GothamBold
hitboxValueLabel.TextSize = 11
hitboxValueLabel.TextXAlignment = Enum.TextXAlignment.Right
hitboxValueLabel.Parent = hitboxSizeSlider

local hitboxSliderBar = Instance.new("Frame")
hitboxSliderBar.Size = UDim2.new(1, -20, 0, 4)
hitboxSliderBar.Position = UDim2.new(0, 10, 1, -15)
hitboxSliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxSliderBar.BorderSizePixel = 0
hitboxSliderBar.Parent = hitboxSizeSlider

local hitboxSliderBarCorner = Instance.new("UICorner")
hitboxSliderBarCorner.CornerRadius = UDim.new(1, 0)
hitboxSliderBarCorner.Parent = hitboxSliderBar

local hitboxSliderFill = Instance.new("Frame")
hitboxSliderFill.Size = UDim2.new((10 - 2) / (50 - 2), 0, 1, 0)
hitboxSliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
hitboxSliderFill.BorderSizePixel = 0
hitboxSliderFill.Parent = hitboxSliderBar

local hitboxSliderFillCorner = Instance.new("UICorner")
hitboxSliderFillCorner.CornerRadius = UDim.new(1, 0)
hitboxSliderFillCorner.Parent = hitboxSliderFill

local hitboxSliderButton = Instance.new("TextButton")
hitboxSliderButton.Size = UDim2.new(0, 12, 0, 12)
hitboxSliderButton.Position = UDim2.new((10 - 2) / (50 - 2), -6, 0.5, -6)
hitboxSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hitboxSliderButton.Text = ""
hitboxSliderButton.AutoButtonColor = false
hitboxSliderButton.Active = true
hitboxSliderButton.Parent = hitboxSliderBar

local hitboxSliderBtnCorner = Instance.new("UICorner")
hitboxSliderBtnCorner.CornerRadius = UDim.new(1, 0)
hitboxSliderBtnCorner.Parent = hitboxSliderButton

local hitboxSliderDragging = false

local function updateHitboxSlider(inputX)
    if not hitboxSliderBar or not hitboxSliderBar.Parent then return end
    
    task.wait() -- Use task.wait instead of wait
    
    local relativePos = (inputX - hitboxSliderBar.AbsolutePosition.X) / hitboxSliderBar.AbsoluteSize.X
    relativePos = math.clamp(relativePos, 0, 1)
    
    local value = math.floor(2 + (50 - 2) * relativePos)
    hitboxValueLabel.Text = tostring(value)
    hitboxSliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
    hitboxSliderButton.Position = UDim2.new(relativePos, -6, 0.5, -6)
    
    -- Update the setting
    settings.HitboxSize = value
    
    -- CRITICAL FIX: Force update all hitboxes immediately
    if settings.HitboxResize then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Check distance
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= 1000 then
                            -- Force resize with new value
                            hrp.Size = Vector3.new(value, value, value)
                            hrp.Transparency = 1
                            hrp.CanCollide = false
                            hrp.Massless = true
                        end
                    else
                        -- If we can't check distance, resize anyway
                        hrp.Size = Vector3.new(value, value, value)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                        hrp.Massless = true
                    end
                end
            end
        end
    end
end

hitboxSliderButton.MouseButton1Down:Connect(function()
    hitboxSliderDragging = true
end)

hitboxSliderButton.TouchTap:Connect(function()
    hitboxSliderDragging = true
end)

hitboxSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hitboxSliderDragging = true
        task.spawn(function()
            updateHitboxSlider(input.Position.X)
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hitboxSliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if hitboxSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        task.spawn(function()
            updateHitboxSlider(input.Position.X)
        end)
    end
end)

-- Aimbot Toggle and Type Selector
local aimbotToggle = createToggle(aimContent, "Aimbot", 84, function(enabled)
    settings.Aimbot = enabled
    aimbotActive = enabled
    
    -- Show/hide aimbot type dropdown
    if aimbotTypeDropdown then
        aimbotTypeDropdown.Visible = enabled
        
        -- Adjust positions of elements below
        local godModeToggle = aimContent:FindFirstChild("GodModeToggle")
        local triggerbotToggle = aimContent:FindFirstChild("TriggerbotToggle")
        
        if enabled then
            -- Aimbot dropdown is visible, move things down
            if godModeToggle then
                godModeToggle.Position = UDim2.new(0, 0, 0, 168)
            end
            if triggerbotToggle then
                triggerbotToggle.Position = UDim2.new(0, 0, 0, 210)
            end
            if triggerbotKeybind then
                triggerbotKeybind.Position = UDim2.new(0, 0, 0, 252)
            end
        else
            -- Aimbot dropdown is hidden, move things up
            if godModeToggle then
                godModeToggle.Position = UDim2.new(0, 0, 0, 126)
            end
            if triggerbotToggle then
                triggerbotToggle.Position = UDim2.new(0, 0, 0, 168)
            end
            if triggerbotKeybind then
                triggerbotKeybind.Position = UDim2.new(0, 0, 0, 210)
            end
        end
    end
end)
aimbotToggle.Name = "AimbotToggle"

aimbotTypeDropdown = createDropdown(aimContent, "Aimbot Type", 126, {"Blatant", "Legit"}, "Blatant", function(option)
    settings.AimbotType = option
end)

-- God Mode Toggle
local godModeToggle = createToggle(aimContent, "God Mode", 126, function(enabled)
    settings.GodMode = enabled
    
    if enabled then
        -- Start god mode loop
        godModeConnection = RunService.Heartbeat:Connect(function()
            if settings.GodMode and godModeTarget then
                teleportBehindPlayer(godModeTarget)
            end
        end)
        
        -- Get nearest target
        godModeTarget = getNearestPlayer()
    else
        -- Stop god mode
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        godModeTarget = nil
    end
end)
godModeToggle.Name = "GodModeToggle"

-- Wallhack Toggle
createToggle(aimContent, "Wallhack", 168, function(enabled)
    settings.Wallhack = enabled
    if enabled then
        enableWallhack()
    else
        disableWallhack()
    end
end)

-- Triggerbot Toggle and Keybind
local triggerbotToggle = createToggle(aimContent, "Triggerbot", 210, function(enabled)
    settings.Triggerbot = enabled
    triggerbotActive = false
    
    -- Show/hide triggerbot keybind
    if triggerbotKeybind then
        triggerbotKeybind.Visible = enabled
    end
end)
triggerbotToggle.Name = "TriggerbotToggle"

triggerbotKeybind = createKeybind(aimContent, "Triggerbot Key", 252, Enum.KeyCode.Q, function(key)
    settings.TriggerbotKey = key
end)

-- Triggerbot activation
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

-- Player events
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            wait(0.5)
            if settings.BoxESP then
                task.spawn(function() addBoxESP(player) end)
            end
            if settings.NameESP then
                task.spawn(function() addNameESP(player) end)
            end
            if settings.TracerESP then
                task.spawn(function() addTracerESP(player) end)
            end
            if settings.HitboxResize then
                task.spawn(function() resizeHitbox(player) end)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeBoxESP(player)
    removeNameESP(player)
    removeTracerESP(player)
    restoreHitbox(player)
    originalHitboxSizes[player] = nil
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            task.wait(0.1) -- Small delay to ensure character is fully loaded
            if settings.BoxESP then
                task.spawn(function() addBoxESP(player) end)
            end
            if settings.NameESP then
                task.spawn(function() addNameESP(player) end)
            end
            if settings.TracerESP then
                task.spawn(function() addTracerESP(player) end)
            end
            if settings.DistanceESP then
                task.spawn(function() addDistanceESP(player) end)
            end
            if settings.HitboxResize then
                task.spawn(function() resizeHitbox(player) end)
            end
        end
        
        player.CharacterAdded:Connect(function(char)
            -- Remove old tracer before adding new one to prevent glitch
            if tracers[player] then
                removeTracerESP(player)
            end
            if distanceLabels[player] then
                removeDistanceESP(player)
            end
            
            -- Wait for character to fully load
            char:WaitForChild("HumanoidRootPart", 5)
            wait(0.5)
            
            if settings.BoxESP then
                task.spawn(function() addBoxESP(player) end)
            end
            if settings.NameESP then
                task.spawn(function() addNameESP(player) end)
            end
            if settings.TracerESP then
                task.spawn(function() addTracerESP(player) end)
            end
            if settings.DistanceESP then
                task.spawn(function() addDistanceESP(player) end)
            end
            if settings.HitboxResize then
                task.spawn(function() resizeHitbox(player) end)
            end
        end)
    end
end

-- Update tracers every frame
RunService.RenderStepped:Connect(function()
    if settings.TracerESP then
        updateTracers()
    end
    
    -- Update distance labels
    if settings.DistanceESP then
        updateDistanceLabels()
    end
    
    -- Aimbot loop
    if settings.Aimbot and aimbotActive then
        local target = getNearestPlayer()
        if target then
            aimAtPlayer(target, 0.2)
        end
    end
    
    -- God Mode loop - update target if current is invalid
    if settings.GodMode then
        if not godModeTarget or not godModeTarget.Parent or not godModeTarget.Character then
            godModeTarget = getNearestPlayer()
        end
    end
end)

-- Handle character respawn for invisible
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

-- Close button action
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
