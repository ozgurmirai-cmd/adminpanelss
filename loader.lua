-- Admin Panel v1.1 — Xeno Optimized
-- Executor: Xeno (+ Synapse/KRNL/Fluxus uyumlu)
-- Kick fix: PlayerGui parent, pcall wrappers, fly yeniden yazıldı

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI PARENT — Xeno'da CoreGui kick atabilir
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AP_" .. tostring(math.random(1000,9999)) -- rastgele isim
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = lp:WaitForChild("PlayerGui")
    end
end)
if not ok then
    ScreenGui.Parent = lp:WaitForChild("PlayerGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ Admin Panel"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -64, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.new(0,400,0,36) or UDim2.new(0,400,0,500)
end)

-- Drag
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)

-- Tab sistemi
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,36)
TabBar.Position = UDim2.new(0,0,0,36)
TabBar.BackgroundColor3 = Color3.fromRGB(15,15,25)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
local tbl = Instance.new("UIListLayout")
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,0,1,-72)
ContentFrame.Position = UDim2.new(0,0,0,72)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local tabs = {}

local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Text = name; btn.Size = UDim2.new(0.25,0,1,0)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,35)
    btn.TextColor3 = Color3.fromRGB(140,140,180)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 11
    btn.BorderSizePixel = 0; btn.LayoutOrder = order; btn.Parent = TabBar

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1
    page.BorderSizePixel = 0; page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80,80,140)
    page.Visible = false; page.Parent = ContentFrame

    local pl = Instance.new("UIListLayout")
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding = UDim.new(0,6); pl.Parent = page

    local pp = Instance.new("UIPadding")
    pp.PaddingLeft = UDim.new(0,10); pp.PaddingRight = UDim.new(0,10)
    pp.PaddingTop = UDim.new(0,8); pp.Parent = page

    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+16)
    end)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(20,20,35)
            t.btn.TextColor3 = Color3.fromRGB(140,140,180)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(40,40,70)
        btn.TextColor3 = Color3.fromRGB(180,180,255)
    end)

    table.insert(tabs, {btn=btn, page=page})
    return page
end

local function createToggle(parent, label, order, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,38)
    frame.BackgroundColor3 = Color3.fromRGB(28,28,45)
    frame.BorderSizePixel = 0; frame.LayoutOrder = order; frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label; lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,10,0,0); lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200,200,220); lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame

    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(0,44,0,22); togBtn.Position = UDim2.new(1,-54,0.5,-11)
    togBtn.BackgroundColor3 = Color3.fromRGB(50,50,80); togBtn.Text = "OFF"
    togBtn.TextColor3 = Color3.fromRGB(150,150,180); togBtn.Font = Enum.Font.GothamBold
    togBtn.TextSize = 10; togBtn.BorderSizePixel = 0; togBtn.Parent = frame
    Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0,11)

    local state = false
    togBtn.MouseButton1Click:Connect(function()
        state = not state
        togBtn.BackgroundColor3 = state and Color3.fromRGB(80,80,200) or Color3.fromRGB(50,50,80)
        togBtn.Text = state and "ON" or "OFF"
        togBtn.TextColor3 = state and Color3.fromRGB(200,200,255) or Color3.fromRGB(150,150,180)
        pcall(callback, state)
    end)
end

local function createSlider(parent, label, order, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,0,54)
    frame.BackgroundColor3 = Color3.fromRGB(28,28,45)
    frame.BorderSizePixel = 0; frame.LayoutOrder = order; frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel")
    lbl.Text = label..": "..tostring(default)
    lbl.Size = UDim2.new(1,-10,0,22); lbl.Position = UDim2.new(0,10,0,4)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(200,200,220)
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-20,0,6); track.Position = UDim2.new(0,10,0,34)
    track.BackgroundColor3 = Color3.fromRGB(50,50,80); track.BorderSizePixel = 0; track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(0,3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(80,80,200); fill.BorderSizePixel = 0; fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new((default-min)/(max-min),-7,0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(150,150,255)
    knob.Text = ""; knob.BorderSizePixel = 0; knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0,7)

    local sliding = false
    knob.MouseButton1Down:Connect(function() sliding = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max-min)*rel)
            fill.Size = UDim2.new(rel,0,1,0)
            knob.Position = UDim2.new(rel,-7,0.5,-7)
            lbl.Text = label..": "..tostring(val)
            pcall(callback, val)
        end
    end)
end

local function createSection(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Text = " "..text; lbl.Size = UDim2.new(1,-20,0,24)
    lbl.BackgroundColor3 = Color3.fromRGB(40,40,65)
    lbl.TextColor3 = Color3.fromRGB(120,120,200); lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BorderSizePixel = 0; lbl.LayoutOrder = order; lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0,4)
end

-- Tablar
local movePage   = createTab("Move",   1)
local combatPage = createTab("Combat", 2)
local visualPage = createTab("Visual", 3)
local miscPage   = createTab("Misc",   4)

tabs[1].page.Visible = true
tabs[1].btn.BackgroundColor3 = Color3.fromRGB(40,40,70)
tabs[1].btn.TextColor3 = Color3.fromRGB(180,180,255)

-- ===== MOVEMENT =====
createSection(movePage, "MOVEMENT", 1)

local flyActive = false
local flySpeed  = 60
local flyConn

-- FLY — Xeno fix: Physics state + düşük MaxForce + pcall
createToggle(movePage, "Fly  [WASD + Space/Shift]", 2, function(state)
    flyActive = state
    char = lp.Character
    hrp  = char and char:FindFirstChild("HumanoidRootPart")
    hum  = char and char:FindFirstChildOfClass("Humanoid")

    if state and hrp and hum then
        -- PlatformStand yerine Physics state — daha az anticheat hit
        hum:ChangeState(Enum.HumanoidStateType.Physics)

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9999, 9999, 9999) -- 1e5 yerine düşük değer
        bv.Velocity  = Vector3.zero
        bv.Name = "FlyVel"; bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9999,9999,9999)
        bg.P = 5000; bg.D = 100
        bg.Name = "FlyGyro"; bg.Parent = hrp

        flyConn = RunService.RenderStepped:Connect(function()
            if not flyActive or not hrp or not hrp.Parent then
                return
            end
            pcall(function()
                local cam = workspace.CurrentCamera
                local mv  = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then mv += Vector3.yAxis end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.yAxis end
                bv.Velocity = mv * flySpeed
                bg.CFrame   = cam.CFrame
            end)
        end)
    else
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        pcall(function()
            if hrp then
                local bv = hrp:FindFirstChild("FlyVel");  if bv then bv:Destroy() end
                local bg = hrp:FindFirstChild("FlyGyro"); if bg then bg:Destroy() end
            end
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
    end
end)

createSlider(movePage, "Fly Speed", 3, 10, 400, 60, function(v) flySpeed = v end)

local infJumpConn
createToggle(movePage, "Infinite Jump", 4, function(state)
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local c = lp.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
    else
        if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    end
end)

local noclipConn
createToggle(movePage, "Noclip", 5, function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                local c = lp.Character
                if not c then return end
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        pcall(function()
            local c = lp.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end)
    end
end)

createSection(movePage, "SPEED", 6)
createSlider(movePage, "WalkSpeed", 7, 16, 500, 16, function(v)
    pcall(function()
        local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end)
end)
createSlider(movePage, "JumpPower", 8, 50, 500, 50, function(v)
    pcall(function()
        local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v end
    end)
end)

-- ===== COMBAT =====
createSection(combatPage, "COMBAT", 1)

local kaActive = false
local kaRange  = 15
local kaConn

createToggle(combatPage, "Kill Aura", 2, function(state)
    kaActive = state
    if state then
        kaConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local c   = lp.Character
                local mhr = c and c:FindFirstChild("HumanoidRootPart")
                if not mhr then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp and plr.Character then
                        local tc  = plr.Character
                        local th  = tc:FindFirstChild("HumanoidRootPart")
                        local th2 = tc:FindFirstChildOfClass("Humanoid")
                        if th and th2 and th2.Health > 0 then
                            if (mhr.Position - th.Position).Magnitude <= kaRange then
                                th2:TakeDamage(math.huge)
                            end
                        end
                    end
                end
            end)
        end)
    else
        if kaConn then kaConn:Disconnect(); kaConn = nil end
    end
end)

createSlider(combatPage, "KA Range", 3, 5, 100, 15, function(v) kaRange = v end)

-- ===== VISUAL =====
createSection(visualPage, "ESP", 1)

local espBoxes = {}
local espActive = false
local espConn

local function clearESP()
    for _, b in pairs(espBoxes) do pcall(function() b:Destroy() end) end
    espBoxes = {}
end

-- ESP — BillboardGui tabanlı (SelectionBox'a göre daha az detect)
local function makeESPLabel(character, player)
    local root = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
    if not root then return end

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = root
    bb.Parent = root
    bb.Name = "ESPTag"

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    lbl.Text = player.Name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = bb

    table.insert(espBoxes, bb)
end

createToggle(visualPage, "Player ESP (Name+Box)", 2, function(state)
    espActive = state
    if not state then
        if espConn then espConn:Disconnect(); espConn = nil end
        clearESP()
        return
    end
    espConn = RunService.Heartbeat:Connect(function()
        if not espActive then return end
        clearESP()
        pcall(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then
                    makeESPLabel(plr.Character, plr)
                end
            end
        end)
    end)
end)

createToggle(visualPage, "Chams", 3, function(state)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if state then
                            local h = Instance.new("SelectionBox")
                            h.Adornee = part
                            h.Color3 = Color3.fromRGB(255,100,0)
                            h.SurfaceTransparency = 0.5
                            h.SurfaceColor3 = Color3.fromRGB(255,100,0)
                            h.Name = "Cham"; h.Parent = part
                        else
                            local ch = part:FindFirstChild("Cham")
                            if ch then ch:Destroy() end
                        end
                    end
                end
            end
        end
    end)
end)

createToggle(visualPage, "Fullbright", 4, function(state)
    pcall(function()
        local L = game:GetService("Lighting")
        L.Brightness = state and 10 or 1
        L.GlobalShadows = not state
        L.FogEnd = state and 1e6 or 1e4
    end)
end)

-- ===== MISC =====
createSection(miscPage, "MISC", 1)

createToggle(miscPage, "Anti-AFK", 2, function(state)
    if state then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            lp.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end)

local godConn
createToggle(miscPage, "Local God Mode", 3, function(state)
    if state then
        godConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health = h.MaxHealth end
            end)
        end)
    else
        if godConn then godConn:Disconnect(); godConn = nil end
    end
end)

createToggle(miscPage, "Big Head", 4, function(state)
    pcall(function()
        local head = lp.Character and lp.Character:FindFirstChild("Head")
        if head then head.Size = state and Vector3.new(5,5,5) or Vector3.new(2,1,1) end
    end)
end)

createSection(miscPage, "TELEPORT", 5)

local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(1,-20,0,38)
tpFrame.BackgroundColor3 = Color3.fromRGB(28,28,45)
tpFrame.BorderSizePixel = 0; tpFrame.LayoutOrder = 6; tpFrame.Parent = miscPage
Instance.new("UICorner", tpFrame).CornerRadius = UDim.new(0,6)

local tpInput = Instance.new("TextBox")
tpInput.PlaceholderText = "Oyuncu adı..."
tpInput.Size = UDim2.new(0.6,0,0.8,0); tpInput.Position = UDim2.new(0,8,0.1,0)
tpInput.BackgroundColor3 = Color3.fromRGB(40,40,60)
tpInput.TextColor3 = Color3.fromRGB(220,220,240)
tpInput.PlaceholderColor3 = Color3.fromRGB(100,100,130)
tpInput.Font = Enum.Font.Gotham; tpInput.TextSize = 11
tpInput.BorderSizePixel = 0; tpInput.ClearTextOnFocus = false; tpInput.Parent = tpFrame
Instance.new("UICorner", tpInput).CornerRadius = UDim.new(0,4)

local tpBtn = Instance.new("TextButton")
tpBtn.Text = "TP"; tpBtn.Size = UDim2.new(0.3,0,0.8,0); tpBtn.Position = UDim2.new(0.65,0,0.1,0)
tpBtn.BackgroundColor3 = Color3.fromRGB(60,60,140); tpBtn.TextColor3 = Color3.fromRGB(200,200,255)
tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 11; tpBtn.BorderSizePixel = 0; tpBtn.Parent = tpFrame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,4)

tpBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local name = tpInput.Text:lower()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) and plr.Character then
                local th   = plr.Character:FindFirstChild("HumanoidRootPart")
                local c    = lp.Character
                local mhrp = c and c:FindFirstChild("HumanoidRootPart")
                if th and mhrp then
                    mhrp.CFrame = th.CFrame + Vector3.new(2,0,0)
                end
            end
        end
    end)
end)

-- Respawn refresh
lp.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum  = newChar:WaitForChild("Humanoid")
    hrp  = newChar:WaitForChild("HumanoidRootPart")
    -- Aktif özellikler respawn sonrası sıfırlanmaz, event'ler zaten global
end)