-- ============================================
--   FusionLib v1.0 | SimpleLib + Rayfield Merge
--   Discord VIP | Notifications | Full UI Suite
-- ============================================

local FusionLib = {}
FusionLib.__index = FusionLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Utility
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    for _, child in pairs(children or {}) do child.Parent = obj end
    return obj
end

-- ============================================
-- KEY SYSTEM (Rayfield-inspired)
-- ============================================
function FusionLib:KeySystem(config)
    config = config or {}
    local Key = config.Key or ""
    local Title = config.Title or "Key System"
    local Subtitle = config.Subtitle or "Enter your key to continue"
    local Note = config.Note or "Get your key in our Discord"

    local valid = false

    local ScreenGui = Create("ScreenGui", {Name="FusionKeySystem", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = LocalPlayer.PlayerGui end

    local Blur = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=0.5, ZIndex=10}, {ScreenGui})
    local Frame = Create("Frame", {
        Size=UDim2.fromOffset(400,220), AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=Color3.fromRGB(20,20,30),
        BorderSizePixel=0, ZIndex=11
    }, {Blur})
    Create("UICorner", {CornerRadius=UDim.new(0,12)}, {Frame})
    Create("UIStroke", {Color=Color3.fromRGB(88,101,242), Thickness=1.5}, {Frame})

    Create("TextLabel", {Size=UDim2.new(1,0,0,36), Position=UDim2.fromOffset(0,14), Text=Title,
        Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.new(1,1,1), BackgroundTransparency=1, ZIndex=12, TextXAlignment=Enum.TextXAlignment.Center}, {Frame})
    Create("TextLabel", {Size=UDim2.new(1,0,0,24), Position=UDim2.fromOffset(0,46), Text=Subtitle,
        Font=Enum.Font.Gotham, TextSize=13, TextColor3=Color3.fromRGB(150,150,180), BackgroundTransparency=1, ZIndex=12, TextXAlignment=Enum.TextXAlignment.Center}, {Frame})

    local Box = Create("TextBox", {
        Size=UDim2.new(1,-40,0,38), Position=UDim2.fromOffset(20,84),
        BackgroundColor3=Color3.fromRGB(30,30,45), TextColor3=Color3.new(1,1,1),
        PlaceholderText="Enter key...", PlaceholderColor3=Color3.fromRGB(100,100,130),
        Font=Enum.Font.Gotham, TextSize=14, BorderSizePixel=0, ZIndex=12, ClearTextOnFocus=false
    }, {Frame})
    Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Box})

    local Btn = Create("TextButton", {
        Size=UDim2.new(1,-40,0,36), Position=UDim2.fromOffset(20,132),
        BackgroundColor3=Color3.fromRGB(88,101,242), Text="Submit Key",
        Font=Enum.Font.GothamBold, TextSize=14, TextColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=12
    }, {Frame})
    Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Btn})

    Create("TextLabel", {Size=UDim2.new(1,0,0,20), Position=UDim2.fromOffset(0,178), Text=Note,
        Font=Enum.Font.Gotham, TextSize=11, TextColor3=Color3.fromRGB(88,101,242), BackgroundTransparency=1, ZIndex=12, TextXAlignment=Enum.TextXAlignment.Center}, {Frame})

    Btn.MouseButton1Click:Connect(function()
        if Box.Text == Key then
            valid = true
            Tween(Frame, {BackgroundColor3=Color3.fromRGB(20,35,20)}, 0.3)
            Btn.Text = "✓ Correct"
            Btn.BackgroundColor3 = Color3.fromRGB(50,180,80)
            task.wait(0.8)
            ScreenGui:Destroy()
        else
            Tween(Frame, {BackgroundColor3=Color3.fromRGB(35,20,20)}, 0.15)
            Btn.Text = "✗ Wrong Key"
            Btn.BackgroundColor3 = Color3.fromRGB(180,50,50)
            task.wait(0.8)
            Tween(Frame, {BackgroundColor3=Color3.fromRGB(20,20,30)}, 0.15)
            Btn.Text = "Submit Key"
            Btn.BackgroundColor3 = Color3.fromRGB(88,101,242)
        end
    end)

    repeat task.wait() until valid
    return true
end

-- ============================================
-- NOTIFICATIONS (Rayfield-inspired)
-- ============================================
local NotifHolder
function FusionLib:Notify(config)
    config = config or {}
    local Title = config.Title or "Notification"
    local Content = config.Content or ""
    local Duration = config.Duration or 4
    local Type = config.Type or "Info" -- Info, Success, Warning, Error

    if not NotifHolder then
        local sg = Create("ScreenGui", {Name="FusionNotifs", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
        local ok = pcall(function() sg.Parent = CoreGui end)
        if not ok then sg.Parent = LocalPlayer.PlayerGui end
        NotifHolder = Create("Frame", {
            Size=UDim2.new(0,300,1,0), Position=UDim2.new(1,-310,0,0),
            BackgroundTransparency=1, ZIndex=100
        }, {sg})
        Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8), VerticalAlignment=Enum.VerticalAlignment.Bottom}, {NotifHolder})
        Create("UIPadding", {PaddingBottom=UDim.new(0,12), PaddingRight=UDim.new(0,8)}, {NotifHolder})
    end

    local colors = {Info=Color3.fromRGB(88,101,242), Success=Color3.fromRGB(50,180,80), Warning=Color3.fromRGB(250,166,26), Error=Color3.fromRGB(237,66,69)}
    local accent = colors[Type] or colors.Info

    local Card = Create("Frame", {
        Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundColor3=Color3.fromRGB(22,22,32), BorderSizePixel=0, ZIndex=101,
        ClipsDescendants=true
    }, {NotifHolder})
    Create("UICorner", {CornerRadius=UDim.new(0,10)}, {Card})
    Create("UIStroke", {Color=accent, Thickness=1}, {Card})

    local Bar = Create("Frame", {Size=UDim2.new(0,3,1,0), BackgroundColor3=accent, BorderSizePixel=0, ZIndex=102}, {Card})
    Create("UICorner", {CornerRadius=UDim.new(0,4)}, {Bar})

    local Inner = Create("Frame", {Size=UDim2.new(1,-14,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=102}, {Card})
    Create("UIPadding", {PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10)}, {Inner})
    Create("TextLabel", {Size=UDim2.new(1,0,0,18), Text=Title, Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.new(1,1,1), BackgroundTransparency=1, ZIndex=103, TextXAlignment=Enum.TextXAlignment.Left}, {Inner})
    Create("TextLabel", {Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,20), Text=Content, Font=Enum.Font.Gotham, TextSize=12, TextColor3=Color3.fromRGB(180,180,200), BackgroundTransparency=1, ZIndex=103, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y}, {Inner})

    Card.Size = UDim2.new(1,0,0,0)
    Tween(Card, {}, 0)
    task.delay(Duration, function()
        Tween(Card, {BackgroundTransparency=1}, 0.3)
        task.wait(0.35)
        Card:Destroy()
    end)
end

-- ============================================
-- DISCORD VIP INTEGRATION
-- ============================================
function FusionLib:DiscordVIP(config)
    config = config or {}
    local GuildID = config.GuildID or ""
    local RoleID = config.RoleID or ""
    local InviteLink = config.InviteLink or "https://discord.gg/example"
    local Webhook = config.Webhook

    -- Show Discord link UI
    local ScreenGui = Create("ScreenGui", {Name="FusionDiscord", ResetOnSpawn=false})
    local ok = pcall(function() ScreenGui.Parent = CoreGui end)
    if not ok then ScreenGui.Parent = LocalPlayer.PlayerGui end

    local Frame = Create("Frame", {
        Size=UDim2.fromOffset(360,150), AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5), BackgroundColor3=Color3.fromRGB(30,33,36),
        BorderSizePixel=0
    }, {ScreenGui})
    Create("UICorner", {CornerRadius=UDim.new(0,12)}, {Frame})
    Create("UIStroke", {Color=Color3.fromRGB(88,101,242), Thickness=1.5}, {Frame})

    Create("TextLabel", {Size=UDim2.new(1,0,0,30), Position=UDim2.fromOffset(0,12), Text="🎮  Join Our Discord for VIP",
        Font=Enum.Font.GothamBold, TextSize=16, TextColor3=Color3.new(1,1,1), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center}, {Frame})
    Create("TextLabel", {Size=UDim2.new(1,-30,0,40), Position=UDim2.fromOffset(15,46), Text=InviteLink,
        Font=Enum.Font.Gotham, TextSize=13, TextColor3=Color3.fromRGB(88,101,242), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Center, TextWrapped=true}, {Frame})

    local CloseBtn = Create("TextButton", {
        Size=UDim2.new(1,-30,0,34), Position=UDim2.fromOffset(15,100),
        BackgroundColor3=Color3.fromRGB(88,101,242), Text="Copy Invite Link",
        Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.new(1,1,1), BorderSizePixel=0
    }, {Frame})
    Create("UICorner", {CornerRadius=UDim.new(0,8)}, {CloseBtn})

    CloseBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(InviteLink) end
        CloseBtn.Text = "✓ Copied!"
        task.wait(1.5)
        ScreenGui:Destroy()
    end)

    -- Optional: Send join log to webhook
    if Webhook and request then
        pcall(function()
            request({
                Url = Webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = "New VIP Viewer",
                        description = "**User:** " .. LocalPlayer.Name .. "\n**ID:** " .. LocalPlayer.UserId,
                        color = 5793266
                    }}
                })
            })
        end)
    end
end

-- ============================================
-- WINDOW (Main UI)
-- ============================================
function FusionLib:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "FusionLib"
    local Subtitle = config.Subtitle or "v1.0"
    local Theme = config.Theme or "Dark"
    local Size = config.Size or UDim2.fromOffset(580, 420)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    -- Theme colors
    local Themes = {
        Dark = {
            BG = Color3.fromRGB(18, 18, 26),
            Surface = Color3.fromRGB(24, 24, 36),
            Panel = Color3.fromRGB(30, 30, 44),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.new(1, 1, 1),
            SubText = Color3.fromRGB(160, 160, 185),
            Border = Color3.fromRGB(50, 50, 70)
        },
        Light = {
            BG = Color3.fromRGB(240, 240, 250),
            Surface = Color3.fromRGB(255, 255, 255),
            Panel = Color3.fromRGB(230, 230, 245),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(20, 20, 30),
            SubText = Color3.fromRGB(80, 80, 110),
            Border = Color3.fromRGB(200, 200, 220)
        },
        Midnight = {
            BG = Color3.fromRGB(10, 10, 18),
            Surface = Color3.fromRGB(15, 15, 25),
            Panel = Color3.fromRGB(20, 20, 35),
            Accent = Color3.fromRGB(140, 80, 255),
            Text = Color3.new(1, 1, 1),
            SubText = Color3.fromRGB(140, 130, 180),
            Border = Color3.fromRGB(40, 35, 65)
        }
    }

    local C = Themes[Theme] or Themes.Dark

    local ScreenGui = Create("ScreenGui", {Name="FusionLib_"..Title, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    local sOK = pcall(function() ScreenGui.Parent = CoreGui end)
    if not sOK then ScreenGui.Parent = LocalPlayer.PlayerGui end

    -- Main window frame
    local Main = Create("Frame", {
        Size = Size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = C.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, {ScreenGui})
    Create("UICorner", {CornerRadius=UDim.new(0,14)}, {Main})
    Create("UIStroke", {Color=C.Border, Thickness=1.5}, {Main})

    -- Drag
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == ToggleKey then
            Main.Visible = not Main.Visible
        end
    end)

    -- Title bar
    local TitleBar = Create("Frame", {
        Size = UDim2.new(1,0,0,50), BackgroundColor3 = C.Surface, BorderSizePixel = 0
    }, {Main})
    Create("UICorner", {CornerRadius=UDim.new(0,14)}, {TitleBar})
    -- Cover bottom corners
    Create("Frame", {Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,1,-14), BackgroundColor3=C.Surface, BorderSizePixel=0}, {TitleBar})

    Create("TextLabel", {
        Size=UDim2.new(0,200,1,0), Position=UDim2.fromOffset(16,0),
        Text=Title, Font=Enum.Font.GothamBold, TextSize=16,
        TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left
    }, {TitleBar})
    Create("TextLabel", {
        Size=UDim2.new(0,100,1,0), Position=UDim2.new(0,16+200,0,0),
        Text=Subtitle, Font=Enum.Font.Gotham, TextSize=13,
        TextColor3=C.SubText, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left
    }, {TitleBar})

    -- Close button
    local CloseBtn = Create("TextButton", {
        Size=UDim2.fromOffset(28,28), AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-12,0.5,0), Text="✕",
        Font=Enum.Font.GothamBold, TextSize=14, TextColor3=C.SubText,
        BackgroundTransparency=1, BorderSizePixel=0
    }, {TitleBar})
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Minimize
    local MinBtn = Create("TextButton", {
        Size=UDim2.fromOffset(28,28), AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-44,0.5,0), Text="─",
        Font=Enum.Font.GothamBold, TextSize=14, TextColor3=C.SubText,
        BackgroundTransparency=1, BorderSizePixel=0
    }, {TitleBar})
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, {Size=UDim2.new(Size.X.Scale, Size.X.Offset, 0, 50)}, 0.25)
        else
            Tween(Main, {Size=Size}, 0.25)
        end
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 140, 1, -50), Position = UDim2.fromOffset(0, 50),
        BackgroundColor3 = C.Surface, BorderSizePixel = 0
    }, {Main})
    Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}, {Sidebar})
    Create("UIPadding", {PaddingTop=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}, {Sidebar})

    -- Content area
    local ContentArea = Create("Frame", {
        Size = UDim2.new(1,-140,1,-50), Position = UDim2.fromOffset(140,50),
        BackgroundColor3 = C.BG, BorderSizePixel = 0
    }, {Main})

    -- Window object
    local Window = {_tabs={}, _activeTab=nil, _C=C, _ContentArea=ContentArea, _ScreenGui=ScreenGui}

    -- ==================== TAB ====================
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local Name = tabConfig.Name or "Tab"
        local Icon = tabConfig.Icon or ""

        local TabBtn = Create("TextButton", {
            Size=UDim2.new(1,0,0,34), BackgroundColor3=C.Panel,
            Text=(Icon~="" and Icon.." " or "")..Name,
            Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=C.SubText,
            BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=#Window._tabs+1
        }, {Sidebar})
        Create("UICorner", {CornerRadius=UDim.new(0,8)}, {TabBtn})

        local ScrollFrame = Create("ScrollingFrame", {
            Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
            BorderSizePixel=0, ScrollBarThickness=4,
            ScrollBarImageColor3=C.Border, Visible=false
        }, {ContentArea})
        Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)}, {ScrollFrame})
        Create("UIPadding", {PaddingAll=UDim.new(0,12)}, {ScrollFrame})

        local Tab = {_frame=ScrollFrame, _C=C, _btn=TabBtn, _window=Window}

        TabBtn.MouseButton1Click:Connect(function()
            Window:_SelectTab(Tab)
        end)

        table.insert(Window._tabs, Tab)
        if #Window._tabs == 1 then Window:_SelectTab(Tab) end

        -- ==================== SECTION ====================
        function Tab:CreateSection(name)
            local Sect = Create("Frame", {
                Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=999
            }, {ScrollFrame})
            Create("TextLabel", {
                Size=UDim2.new(1,0,1,0), Text=name or "Section",
                Font=Enum.Font.GothamBold, TextSize=11,
                TextColor3=C.Accent, BackgroundTransparency=1,
                TextXAlignment=Enum.TextXAlignment.Left
            }, {Sect})
            local Line = Create("Frame", {
                Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
                BackgroundColor3=C.Accent, BorderSizePixel=0
            }, {Sect})
            Tween(Line, {}, 0)
        end

        -- ==================== BUTTON ====================
        function Tab:CreateButton(bConfig)
            bConfig = bConfig or {}
            local Btn = Create("TextButton", {
                Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel,
                Text=bConfig.Name or "Button", Font=Enum.Font.GothamSemibold,
                TextSize=13, TextColor3=C.Text, BorderSizePixel=0, AutoButtonColor=false
            }, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Btn})

            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, {BackgroundColor3=C.Accent}, 0.1)
                task.wait(0.12)
                Tween(Btn, {BackgroundColor3=C.Panel}, 0.12)
                if bConfig.Callback then pcall(bConfig.Callback) end
            end)
            Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3=C.Border}, 0.1) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3=C.Panel}, 0.1) end)
        end

        -- ==================== TOGGLE ====================
        function Tab:CreateToggle(tConfig)
            tConfig = tConfig or {}
            local state = tConfig.Default or false

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(12,0), Text=tConfig.Name or "Toggle",
                Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {Row})

            local Track = Create("Frame", {Size=UDim2.fromOffset(40,22), AnchorPoint=Vector2.new(1,0.5),
                Position=UDim2.new(1,-12,0.5,0), BackgroundColor3=state and C.Accent or C.Border, BorderSizePixel=0}, {Row})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Track})
            local Knob = Create("Frame", {Size=UDim2.fromOffset(16,16), AnchorPoint=Vector2.new(0,0.5),
                Position=UDim2.new(0, state and 21 or 3, 0.5, 0), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Knob})

            local function SetState(s)
                state = s
                Tween(Track, {BackgroundColor3=s and C.Accent or C.Border}, 0.15)
                Tween(Knob, {Position=UDim2.new(0, s and 21 or 3, 0.5, 0)}, 0.15)
                if tConfig.Callback then pcall(tConfig.Callback, s) end
            end

            local ToggleObj = {Value=state, Set=function(self,v) SetState(v) self.Value=v end}

            local Btn = Create("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", BorderSizePixel=0}, {Row})
            Btn.MouseButton1Click:Connect(function() SetState(not state) ToggleObj.Value=state end)
            return ToggleObj
        end

        -- ==================== SLIDER ====================
        function Tab:CreateSlider(sConfig)
            sConfig = sConfig or {}
            local Min = sConfig.Min or 0
            local Max = sConfig.Max or 100
            local Default = sConfig.Default or Min
            local current = Default

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,52), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("UIPadding", {PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), PaddingTop=UDim.new(0,8)}, {Row})

            local TopRow = Create("Frame", {Size=UDim2.new(1,0,0,18), BackgroundTransparency=1}, {Row})
            Create("TextLabel", {Size=UDim2.new(0.7,0,1,0), Text=sConfig.Name or "Slider",
                Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {TopRow})
            local ValLabel = Create("TextLabel", {Size=UDim2.new(0.3,0,1,0), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0),
                Text=tostring(current), Font=Enum.Font.GothamBold, TextSize=13, TextColor3=C.Accent, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right}, {TopRow})

            local Track = Create("Frame", {Size=UDim2.new(1,0,0,6), Position=UDim2.fromOffset(0,28), BackgroundColor3=C.Border, BorderSizePixel=0}, {Row})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Track})
            local Fill = Create("Frame", {Size=UDim2.new((current-Min)/(Max-Min),0,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Fill})
            local Thumb = Create("Frame", {Size=UDim2.fromOffset(14,14), AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new((current-Min)/(Max-Min),0,0.5,0), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Thumb})

            local sliding = false
            local function UpdateSlider(x)
                local abs = Track.AbsolutePosition.X
                local w = Track.AbsoluteSize.X
                local pct = math.clamp((x - abs) / w, 0, 1)
                current = math.round(Min + (Max - Min) * pct)
                ValLabel.Text = tostring(current)
                Fill.Size = UDim2.new(pct,0,1,0)
                Thumb.Position = UDim2.new(pct,0,0.5,0)
                if sConfig.Callback then pcall(sConfig.Callback, current) end
            end

            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true; UpdateSlider(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)

            local SliderObj = {Value=current}
            SliderObj.Set = function(self, v)
                v = math.clamp(math.round(v), Min, Max)
                current = v
                local pct = (v - Min) / (Max - Min)
                ValLabel.Text = tostring(v)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Thumb.Position = UDim2.new(pct, 0, 0.5, 0)
                SliderObj.Value = v
            end
            return SliderObj
        end

        -- ==================== TEXT SLIDER ====================
        -- Like a slider but with an editable number box. Type a value or drag.
        function Tab:CreateTextSlider(sConfig)
            sConfig = sConfig or {}
            local Min = sConfig.Min or 0
            local Max = sConfig.Max or 100
            local Default = math.clamp(sConfig.Default or Min, Min, Max)
            local current = Default
            local Increment = sConfig.Increment or 1

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,58), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("UIPadding", {PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8)}, {Row})

            -- Top: name + editable number box
            local TopRow = Create("Frame", {Size=UDim2.new(1,0,0,20), BackgroundTransparency=1}, {Row})
            Create("TextLabel", {Size=UDim2.new(0.65,0,1,0),
                Text=sConfig.Name or "Slider", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {TopRow})

            local NumBox = Create("TextBox", {
                Size=UDim2.new(0.32,0,1,0), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0),
                BackgroundColor3=C.BG, TextColor3=C.Accent, Text=tostring(current),
                Font=Enum.Font.GothamBold, TextSize=12, BorderSizePixel=0,
                ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Center
            }, {TopRow})
            Create("UICorner", {CornerRadius=UDim.new(0,5)}, {NumBox})
            Create("UIStroke", {Color=C.Border, Thickness=1}, {NumBox})

            -- Bottom: track
            local Track = Create("Frame", {Size=UDim2.new(1,0,0,6), Position=UDim2.fromOffset(0,32),
                BackgroundColor3=C.Border, BorderSizePixel=0}, {Row})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Track})
            local Fill = Create("Frame", {Size=UDim2.new((current-Min)/(Max-Min),0,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Fill})
            local Thumb = Create("Frame", {Size=UDim2.fromOffset(14,14), AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new((current-Min)/(Max-Min),0,0.5,0), BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Thumb})

            local TSObj = {Value=current}

            local function ApplyValue(v)
                v = math.clamp(math.round(v / Increment) * Increment, Min, Max)
                current = v
                TSObj.Value = v
                local pct = (v - Min) / (Max - Min)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Thumb.Position = UDim2.new(pct, 0, 0.5, 0)
                NumBox.Text = tostring(v)
                if sConfig.Callback then pcall(sConfig.Callback, v) end
            end

            local function UpdateFromX(x)
                local abs = Track.AbsolutePosition.X
                local w = Track.AbsoluteSize.X
                local pct = math.clamp((x - abs) / w, 0, 1)
                ApplyValue(Min + (Max - Min) * pct)
            end

            local sliding = false
            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true; UpdateFromX(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then UpdateFromX(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)

            -- Typing a value in the box
            NumBox.FocusLost:Connect(function()
                local v = tonumber(NumBox.Text)
                if v then ApplyValue(v) else NumBox.Text = tostring(current) end
            end)

            TSObj.Set = function(self, v) ApplyValue(v) end
            return TSObj
        end

        -- ==================== MULTI-DROPDOWN ====================
        -- Like dropdown but lets you pick multiple options at once.
        function Tab:CreateMultiDropdown(dConfig)
            dConfig = dConfig or {}
            local Options = dConfig.Options or {}
            local selected = {}
            if dConfig.Default then
                for _, v in ipairs(dConfig.Default) do selected[v] = true end
            end
            local open = false

            local function SelectedText()
                local t = {}
                for _, opt in ipairs(Options) do if selected[opt] then table.insert(t, opt) end end
                return #t == 0 and "None" or table.concat(t, ", ")
            end

            local Wrap = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundTransparency=1, ClipsDescendants=false}, {ScrollFrame})
            local Main2 = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=C.Panel, BorderSizePixel=0, ZIndex=5}, {Wrap})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Main2})
            Create("TextLabel", {Size=UDim2.new(0.4,0,1,0), Position=UDim2.fromOffset(12,0),
                Text=dConfig.Name or "Multi-Select", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6}, {Main2})
            local SelLabel = Create("TextLabel", {Size=UDim2.new(0.52,0,1,0), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-28,0,0),
                Text=SelectedText(), Font=Enum.Font.Gotham, TextSize=11, TextColor3=C.Accent,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=6, TextTruncate=Enum.TextTruncate.AtEnd}, {Main2})
            Create("TextLabel", {Size=UDim2.fromOffset(20,20), AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0),
                Text="▾", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=C.SubText, BackgroundTransparency=1, ZIndex=6}, {Main2})

            local DropFrame = Create("Frame", {
                Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,42),
                BackgroundColor3=C.Surface, BorderSizePixel=0, ClipsDescendants=true, ZIndex=10, Visible=false
            }, {Wrap})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {DropFrame})
            Create("UIStroke", {Color=C.Border, Thickness=1}, {DropFrame})
            local DropList = Create("Frame", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=11}, {DropFrame})
            Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2)}, {DropList})
            Create("UIPadding", {PaddingAll=UDim.new(0,4)}, {DropList})

            local MDObj = {Value=selected}
            local optBtns = {}

            local function RefreshBtns()
                for opt, btn in pairs(optBtns) do
                    Tween(btn, {BackgroundColor3=selected[opt] and C.Accent or C.Panel}, 0.1)
                end
                SelLabel.Text = SelectedText()
            end

            for _, opt in ipairs(Options) do
                local OBtn = Create("TextButton", {
                    Size=UDim2.new(1,0,0,30), BackgroundColor3=selected[opt] and C.Accent or C.Panel,
                    Text=opt, Font=Enum.Font.Gotham, TextSize=12, TextColor3=C.Text, BorderSizePixel=0, ZIndex=12, AutoButtonColor=false
                }, {DropList})
                Create("UICorner", {CornerRadius=UDim.new(0,6)}, {OBtn})
                optBtns[opt] = OBtn
                OBtn.MouseButton1Click:Connect(function()
                    selected[opt] = not selected[opt]
                    MDObj.Value = selected
                    RefreshBtns()
                    if dConfig.Callback then
                        local arr = {}
                        for _, o in ipairs(Options) do if selected[o] then table.insert(arr, o) end end
                        pcall(dConfig.Callback, arr)
                    end
                end)
                OBtn.MouseEnter:Connect(function() if not selected[opt] then Tween(OBtn,{BackgroundColor3=C.Border},0.1) end end)
                OBtn.MouseLeave:Connect(function() if not selected[opt] then Tween(OBtn,{BackgroundColor3=C.Panel},0.1) end end)
            end

            local TotalH = #Options * 34 + 8
            local ToggleBtn = Create("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", BorderSizePixel=0, ZIndex=7}, {Main2})
            ToggleBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    DropFrame.Visible = true
                    Wrap.Size = UDim2.new(1,0,0,38+TotalH+8)
                    Tween(DropFrame, {Size=UDim2.new(1,0,0,TotalH)}, 0.2)
                else
                    Tween(DropFrame, {Size=UDim2.new(1,0,0,0)}, 0.2)
                    Wrap.Size = UDim2.new(1,0,0,38)
                    task.delay(0.21, function() DropFrame.Visible=false end)
                end
            end)

            MDObj.Set = function(self, arr)
                selected = {}
                for _, v in ipairs(arr) do selected[v] = true end
                MDObj.Value = selected
                RefreshBtns()
            end
            return MDObj
        end

        -- ==================== PROGRESS BAR ====================
        -- Show a read-only progress bar you can update from code.
        function Tab:CreateProgressBar(pConfig)
            pConfig = pConfig or {}
            local Min = pConfig.Min or 0
            local Max = pConfig.Max or 100
            local current = math.clamp(pConfig.Default or Min, Min, Max)
            local suffix = pConfig.Suffix or ""

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,52), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("UIPadding", {PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), PaddingTop=UDim.new(0,8)}, {Row})

            local TopRow = Create("Frame", {Size=UDim2.new(1,0,0,18), BackgroundTransparency=1}, {Row})
            Create("TextLabel", {Size=UDim2.new(0.7,0,1,0),
                Text=pConfig.Name or "Progress", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {TopRow})
            local ValLabel = Create("TextLabel", {Size=UDim2.new(0.3,0,1,0), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0),
                Text=tostring(current)..suffix, Font=Enum.Font.GothamBold, TextSize=13, TextColor3=C.Accent,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right}, {TopRow})

            local Track = Create("Frame", {Size=UDim2.new(1,0,0,8), Position=UDim2.fromOffset(0,28),
                BackgroundColor3=C.Border, BorderSizePixel=0}, {Row})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Track})
            local Fill = Create("Frame", {Size=UDim2.new((current-Min)/(Max-Min),0,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0}, {Track})
            Create("UICorner", {CornerRadius=UDim.new(1,0)}, {Fill})

            local PBObj = {Value=current}
            PBObj.Set = function(self, v)
                v = math.clamp(v, Min, Max)
                current = v
                PBObj.Value = v
                local pct = (v - Min) / (Max - Min)
                Tween(Fill, {Size=UDim2.new(pct, 0, 1, 0)}, 0.25)
                ValLabel.Text = tostring(math.round(v)) .. suffix
            end
            return PBObj
        end

        -- ==================== DIVIDER ====================
        -- Thin horizontal rule for spacing sections visually.
        function Tab:CreateDivider()
            local D = Create("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Border, BorderSizePixel=0}, {ScrollFrame})
        end

        -- ==================== DROPDOWN ====================
        function Tab:CreateDropdown(dConfig)
            dConfig = dConfig or {}
            local Options = dConfig.Options or {}
            local selected = dConfig.Default or Options[1] or "Select..."
            local open = false

            local Wrap = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundTransparency=1, ClipsDescendants=false}, {ScrollFrame})
            local Main2 = Create("Frame", {Size=UDim2.fromScale(1,1), BackgroundColor3=C.Panel, BorderSizePixel=0, ZIndex=5}, {Wrap})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Main2})
            Create("TextLabel", {Size=UDim2.new(1,-50,1,0), Position=UDim2.fromOffset(12,0),
                Text=dConfig.Name or "Dropdown", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6}, {Main2})
            local SelLabel = Create("TextLabel", {Size=UDim2.new(0,120,1,0), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-30,0,0),
                Text=selected, Font=Enum.Font.Gotham, TextSize=12, TextColor3=C.Accent, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=6}, {Main2})
            Create("TextLabel", {Size=UDim2.fromOffset(20,20), AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-8,0.5,0),
                Text="▾", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=C.SubText, BackgroundTransparency=1, ZIndex=6}, {Main2})

            local DropFrame = Create("Frame", {
                Size=UDim2.new(1,0,0,0), Position=UDim2.fromOffset(0,42),
                BackgroundColor3=C.Surface, BorderSizePixel=0,
                ClipsDescendants=true, ZIndex=10, Visible=false
            }, {Wrap})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {DropFrame})
            Create("UIStroke", {Color=C.Border, Thickness=1}, {DropFrame})
            local DropList = Create("Frame", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, ZIndex=11}, {DropFrame})
            Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,2)}, {DropList})
            Create("UIPadding", {PaddingAll=UDim.new(0,4)}, {DropList})

            local DropObj = {Value=selected}

            local function BuildOptions()
                for _, child in pairs(DropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, opt in ipairs(Options) do
                    local OBtn = Create("TextButton", {
                        Size=UDim2.new(1,0,0,30), BackgroundColor3=opt==selected and C.Accent or C.Panel,
                        Text=opt, Font=Enum.Font.Gotham, TextSize=12, TextColor3=C.Text, BorderSizePixel=0, ZIndex=12, AutoButtonColor=false
                    }, {DropList})
                    Create("UICorner", {CornerRadius=UDim.new(0,6)}, {OBtn})
                    OBtn.MouseButton1Click:Connect(function()
                        selected = opt; DropObj.Value = opt
                        SelLabel.Text = opt
                        if dConfig.Callback then pcall(dConfig.Callback, opt) end
                        open = false
                        Tween(DropFrame, {Size=UDim2.new(1,0,0,0)}, 0.2)
                        task.delay(0.21, function() DropFrame.Visible=false end)
                        BuildOptions()
                    end)
                    OBtn.MouseEnter:Connect(function() if opt~=selected then Tween(OBtn,{BackgroundColor3=C.Border},0.1) end end)
                    OBtn.MouseLeave:Connect(function() if opt~=selected then Tween(OBtn,{BackgroundColor3=C.Panel},0.1) end end)
                end
            end
            BuildOptions()

            local TotalH = #Options * 34 + 8
            local ToggleBtn = Create("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", BorderSizePixel=0, ZIndex=7}, {Main2})
            ToggleBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    DropFrame.Visible = true
                    Wrap.Size = UDim2.new(1,0,0,38+TotalH+8)
                    Tween(DropFrame, {Size=UDim2.new(1,0,0,TotalH)}, 0.2)
                else
                    Tween(DropFrame, {Size=UDim2.new(1,0,0,0)}, 0.2)
                    Wrap.Size = UDim2.new(1,0,0,38)
                    task.delay(0.21, function() DropFrame.Visible=false end)
                end
            end)

            DropObj.Set = function(self, val)
                selected = val; DropObj.Value = val; SelLabel.Text = val; BuildOptions()
            end
            DropObj.Refresh = function(self, newOptions)
                Options = newOptions; BuildOptions()
            end
            return DropObj
        end

        -- ==================== TEXT INPUT ====================
        function Tab:CreateInput(iConfig)
            iConfig = iConfig or {}
            local Row = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("TextLabel", {Size=UDim2.new(0.4,0,1,0), Position=UDim2.fromOffset(12,0),
                Text=iConfig.Name or "Input", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {Row})
            local Box = Create("TextBox", {
                Size=UDim2.new(0.55,0,0,26), AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
                BackgroundColor3=C.BG, TextColor3=C.Text, PlaceholderText=iConfig.Placeholder or "Enter...",
                PlaceholderColor3=C.SubText, Font=Enum.Font.Gotham, TextSize=12, BorderSizePixel=0, ClearTextOnFocus=false
            }, {Row})
            Create("UICorner", {CornerRadius=UDim.new(0,6)}, {Box})
            Create("UIPadding", {PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}, {Box})

            Box.FocusLost:Connect(function(enter)
                if enter or iConfig.CallOnChange then
                    if iConfig.Callback then pcall(iConfig.Callback, Box.Text) end
                end
            end)
            return {Value=Box.Text, Set=function(self,v) Box.Text=v end}
        end

        -- ==================== COLOR PICKER ====================
        function Tab:CreateColorPicker(cpConfig)
            cpConfig = cpConfig or {}
            local color = cpConfig.Default or Color3.new(1,0.3,0.3)

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(12,0),
                Text=cpConfig.Name or "Color", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {Row})
            local Swatch = Create("Frame", {Size=UDim2.fromOffset(24,24), AnchorPoint=Vector2.new(1,0.5),
                Position=UDim2.new(1,-10,0.5,0), BackgroundColor3=color, BorderSizePixel=0}, {Row})
            Create("UICorner", {CornerRadius=UDim.new(0,6)}, {Swatch})
            Create("UIStroke", {Color=C.Border, Thickness=1}, {Swatch})

            -- Simple R/G/B popup
            local PopupOpen = false
            local Popup = Create("Frame", {
                Size=UDim2.fromOffset(200,120), Position=UDim2.new(1,-210,1,4),
                BackgroundColor3=C.Surface, BorderSizePixel=0, ZIndex=20, Visible=false
            }, {Row})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Popup})
            Create("UIStroke", {Color=C.Border, Thickness=1}, {Popup})
            Create("UIPadding", {PaddingAll=UDim.new(0,10)}, {Popup})
            local Layout = Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}, {Popup})

            local channels = {"R","G","B"}
            local vals = {color.R*255, color.G*255, color.B*255}
            local sliders = {}
            for i, ch in ipairs(channels) do
                local SRow = Create("Frame", {Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, LayoutOrder=i, ZIndex=21}, {Popup})
                Create("TextLabel", {Size=UDim2.fromOffset(12,26), Text=ch, Font=Enum.Font.GothamBold, TextSize=11,
                    TextColor3=C.SubText, BackgroundTransparency=1, ZIndex=22}, {SRow})
                local STrack = Create("Frame", {Size=UDim2.new(1,-40,0,4), Position=UDim2.fromOffset(16,11),
                    BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=22}, {SRow})
                Create("UICorner", {CornerRadius=UDim.new(1,0)}, {STrack})
                local SFill = Create("Frame", {Size=UDim2.new(vals[i]/255,0,1,0), BackgroundColor3=C.Accent, BorderSizePixel=0, ZIndex=23}, {STrack})
                Create("UICorner", {CornerRadius=UDim.new(1,0)}, {SFill})
                local VLbl = Create("TextLabel", {Size=UDim2.fromOffset(24,26), AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,0,0,0),
                    Text=tostring(math.round(vals[i])), Font=Enum.Font.Gotham, TextSize=10, TextColor3=C.SubText, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Right, ZIndex=22}, {SRow})

                local si = false
                STrack.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        si = true
                        local pct = math.clamp((inp.Position.X - STrack.AbsolutePosition.X)/STrack.AbsoluteSize.X,0,1)
                        vals[i] = pct*255; VLbl.Text=tostring(math.round(vals[i])); SFill.Size=UDim2.new(pct,0,1,0)
                        color = Color3.fromRGB(vals[1],vals[2],vals[3]); Swatch.BackgroundColor3=color
                        if cpConfig.Callback then pcall(cpConfig.Callback, color) end
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if si and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local pct = math.clamp((inp.Position.X - STrack.AbsolutePosition.X)/STrack.AbsoluteSize.X,0,1)
                        vals[i] = pct*255; VLbl.Text=tostring(math.round(vals[i])); SFill.Size=UDim2.new(pct,0,1,0)
                        color = Color3.fromRGB(vals[1],vals[2],vals[3]); Swatch.BackgroundColor3=color
                        if cpConfig.Callback then pcall(cpConfig.Callback, color) end
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then si=false end
                end)
                sliders[i] = {fill=SFill, lbl=VLbl}
            end

            local SwBtn = Create("TextButton", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", BorderSizePixel=0, ZIndex=5}, {Row})
            SwBtn.MouseButton1Click:Connect(function()
                PopupOpen = not PopupOpen
                Popup.Visible = PopupOpen
            end)

            return {Value=color, Set=function(self,c)
                color=c; Swatch.BackgroundColor3=c
                vals={c.R*255,c.G*255,c.B*255}
                for i,s in ipairs(sliders) do
                    s.fill.Size=UDim2.new(vals[i]/255,0,1,0)
                    s.lbl.Text=tostring(math.round(vals[i]))
                end
            end}
        end

        -- ==================== KEYBIND ====================
        function Tab:CreateKeybind(kConfig)
            kConfig = kConfig or {}
            local currentKey = kConfig.Default or Enum.KeyCode.Unknown
            local listening = false

            local Row = Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Panel, BorderSizePixel=0}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Row})
            Create("TextLabel", {Size=UDim2.new(1,-100,1,0), Position=UDim2.fromOffset(12,0),
                Text=kConfig.Name or "Keybind", Font=Enum.Font.GothamSemibold, TextSize=13,
                TextColor3=C.Text, BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}, {Row})
            local KeyBtn = Create("TextButton", {
                Size=UDim2.fromOffset(80,26), AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
                BackgroundColor3=C.BG, Text=currentKey.Name, Font=Enum.Font.GothamSemibold, TextSize=11,
                TextColor3=C.Accent, BorderSizePixel=0
            }, {Row})
            Create("UICorner", {CornerRadius=UDim.new(0,6)}, {KeyBtn})

            KeyBtn.MouseButton1Click:Connect(function()
                listening = true; KeyBtn.Text="..."
                KeyBtn.TextColor3=C.SubText
            end)

            UserInputService.InputBegan:Connect(function(i, gp)
                if listening and i.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = i.KeyCode
                    KeyBtn.Text = i.KeyCode.Name
                    KeyBtn.TextColor3 = C.Accent
                    if kConfig.Callback then pcall(kConfig.Callback, currentKey) end
                end
            end)

            -- Auto-fire on keypress
            if kConfig.Callback and kConfig.AutoFire then
                UserInputService.InputBegan:Connect(function(i, gp)
                    if not gp and i.KeyCode == currentKey then pcall(kConfig.Callback, currentKey) end
                end)
            end

            return {Value=currentKey, Set=function(self,k) currentKey=k; KeyBtn.Text=k.Name end}
        end

        -- ==================== LABEL ====================
        function Tab:CreateLabel(text)
            local Lbl = Create("Frame", {Size=UDim2.new(1,0,0,28), BackgroundTransparency=1}, {ScrollFrame})
            Create("TextLabel", {Size=UDim2.fromScale(1,1), Text=text or "Label",
                Font=Enum.Font.Gotham, TextSize=12, TextColor3=C.SubText,
                BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true}, {Lbl})
        end

        -- ==================== PARAGRAPH ====================
        function Tab:CreateParagraph(pConfig)
            pConfig = type(pConfig)=="string" and {Title=pConfig} or pConfig
            local Box2 = Create("Frame", {Size=UDim2.new(1,0,0,0), BackgroundColor3=C.Panel, BorderSizePixel=0, AutomaticSize=Enum.AutomaticSize.Y}, {ScrollFrame})
            Create("UICorner", {CornerRadius=UDim.new(0,8)}, {Box2})
            Create("UIPadding", {PaddingAll=UDim.new(0,10)}, {Box2})
            local InnerList = Create("Frame", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y}, {Box2})
            Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}, {InnerList})
            if pConfig.Title then
                Create("TextLabel", {Size=UDim2.new(1,0,0,18), Text=pConfig.Title, Font=Enum.Font.GothamBold,
                    TextSize=13, TextColor3=C.Text, BackgroundTransparency=1, LayoutOrder=1, TextXAlignment=Enum.TextXAlignment.Left}, {InnerList})
            end
            if pConfig.Content then
                Create("TextLabel", {Size=UDim2.new(1,0,0,0), Text=pConfig.Content, Font=Enum.Font.Gotham,
                    TextSize=12, TextColor3=C.SubText, BackgroundTransparency=1, LayoutOrder=2,
                    TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y}, {InnerList})
            end
        end

        return Tab
    end

    -- Tab selection
    function Window:_SelectTab(tab)
        for _, t in pairs(self._tabs) do
            t._frame.Visible = false
            Tween(t._btn, {BackgroundColor3=C.Panel, TextColor3=C.SubText}, 0.15)
        end
        tab._frame.Visible = true
        Tween(tab._btn, {BackgroundColor3=C.Accent, TextColor3=Color3.new(1,1,1)}, 0.15)
        self._activeTab = tab
    end

    return Window
end

return FusionLib
