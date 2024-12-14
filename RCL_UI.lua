local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

Library.Settings = {
    MainColor = Color3.fromRGB(50, 50, 50),
    AccentColor = Color3.fromRGB(255, 100, 100), -- Red as the accent color
    BackgroundColor = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    ButtonColor = Color3.fromRGB(60, 60, 60),
    ButtonHoverColor = Color3.fromRGB(70, 70, 70),
    TabColor = Color3.fromRGB(60, 60, 60),
    TabSelectedColor = Color3.fromRGB(255, 100, 100),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BorderColor = Color3.fromRGB(80, 80, 80),
    BorderThickness = 1,
    SliderColor = Color3.fromRGB(255, 100, 100),
    ToggleColor = Color3.fromRGB(255, 100, 100),
    DropdownColor = Color3.fromRGB(60, 60, 60),
    SectionColor = Color3.fromRGB(50, 50, 50),
    DefaultTransparency = 0.2,
    GlowEnabled = true,
    ColorSchemes = {
        Default = {
            MainColor = Color3.fromRGB(50, 50, 50),
            AccentColor = Color3.fromRGB(255, 100, 100)
        },
        White = {
            MainColor = Color3.fromRGB(240, 240, 240),
            AccentColor = Color3.fromRGB(200, 200, 200)
        },
        Green = {
            MainColor = Color3.fromRGB(30, 35, 30),
            AccentColor = Color3.fromRGB(100, 255, 100)
        },
        Yellow = {
            MainColor = Color3.fromRGB(35, 35, 30),
            AccentColor = Color3.fromRGB(255, 255, 100)
        },
        Pink = {
            MainColor = Color3.fromRGB(35, 30, 35),
            AccentColor = Color3.fromRGB(255, 100, 255)
        }
    },
    Keybinds = {
        ToggleUI = Enum.KeyCode.RightControl
    }
}

function Library:SaveSettings()
    local data = {
        ColorScheme = self.CurrentColorScheme,
        Transparency = self.CurrentTransparency,
        GlowEnabled = self.Settings.GlowEnabled,
        Position = {
            X = self.MainFrame.Position.X.Scale,
            Y = self.MainFrame.Position.Y.Scale,
            OffsetX = self.MainFrame.Position.X.Offset,
            OffsetY = self.MainFrame.Position.Y.Offset
        }
    }
    
    writefile("UILibrarySettings.json", HttpService:JSONEncode(data))
end

function Library:LoadSettings()
    if isfile("UILibrarySettings.json") then
        local data = HttpService:JSONDecode(readfile("UILibrarySettings.json"))
        
        self.CurrentColorScheme = data.ColorScheme
        self.CurrentTransparency = data.Transparency
        self.Settings.GlowEnabled = data.GlowEnabled
        
        if data.Position then
            self.MainFrame.Position = UDim2.new(
                data.Position.X, 
                data.Position.OffsetX,
                data.Position.Y,
                data.Position.OffsetY
            )
        end
    end
end

function Library:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Hidden = false
    Window.ColorScheme = "Default"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title
    ScreenGui.Parent = CoreGui
    Window.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Settings.MainColor
    MainFrame.BackgroundTransparency = Library.Settings.DefaultTransparency
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true
    Window.MainFrame = MainFrame

    local MainBorder = Instance.new("UIStroke")
    MainBorder.Parent = MainFrame
    MainBorder.Color = Library.Settings.BorderColor
    MainBorder.Thickness = Library.Settings.BorderThickness

    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -15, 0, -15)
    Glow.Size = UDim2.new(1, 30, 1, 30)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://4996891970"
    Glow.ImageColor3 = Library.Settings.AccentColor
    Glow.ImageTransparency = 0.5
    Glow.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Library.Settings.BackgroundColor
    TitleBar.Size = UDim2.new(1, 0, 0, 35)

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.Size = UDim2.new(1, -100, 1, 0)
    TitleText.Font = Library.Settings.Font
    TitleText.Text = title
    TitleText.TextColor3 = Library.Settings.TextColor
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
    MinimizeButton.Font = Library.Settings.Font
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Library.Settings.TextColor
    MinimizeButton.TextSize = 25

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -35, 0, 0)
    CloseButton.Size = UDim2.new(0, 35, 1, 0)
    CloseButton.Font = Library.Settings.Font
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Library.Settings.TextColor
    CloseButton.TextSize = 16

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Parent = MainFrame
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position = UDim2.new(0, 0, 0, 35)
    ContentHolder.Size = UDim2.new(1, 0, 1, -35)
    ContentHolder.ClipsDescendants = true

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = ContentHolder
    TabContainer.BackgroundColor3 = Library.Settings.TabColor
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(0, 150, 1, -20)

    local TabBorder = Instance.new("UIStroke")
    TabBorder.Parent = TabContainer
    TabBorder.Color = Library.Settings.BorderColor
    TabBorder.Thickness = Library.Settings.BorderThickness

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 5, 0, 5)
    TabList.Size = UDim2.new(1, -10, 1, -10)
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Library.Settings.AccentColor
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = ContentHolder
    ContentFrame.BackgroundColor3 = Library.Settings.BackgroundColor
    ContentFrame.Position = UDim2.new(0, 170, 0, 10)
    ContentFrame.Size = UDim2.new(1, -180, 1, -20)

    local ContentBorder = Instance.new("UIStroke")
    ContentBorder.Parent = ContentFrame
    ContentBorder.Color = Library.Settings.BorderColor
    ContentBorder.Thickness = Library.Settings.BorderThickness

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentFrame

    MinimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        
        if Window.Minimized then
            TweenService:Create(ContentHolder, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 600, 0, 35)
            }):Play()
            MainFrame.BackgroundTransparency = 0.5
        else
            TweenService:Create(ContentHolder, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Size = UDim2.new(1, 0, 1, -35)
            }):Play()
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, 600, 0, 400)
            }):Play()
            MainFrame.BackgroundTransparency = Library.Settings.DefaultTransparency
        end
    end)

    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            TextColor3 = Library.Settings.TextColor
        }):Play()
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local function MakeDraggable(frame, handle)
        local dragging, dragInput, dragStart, startPos
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        
        handle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    MakeDraggable(MainFrame, TitleBar)

function Window:CreateTab(name, icon)
    local Tab = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabList
    TabButton.BackgroundColor3 = Library.Settings.TabColor
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.Font = Library.Settings.Font
    TabButton.TextColor3 = Library.Settings.TextColor
    TabButton.TextSize = Library.Settings.TextSize
    TabButton.AutoButtonColor = false

    local Padding = Instance.new("UIPadding")
    Padding.Parent = TabButton
    Padding.PaddingLeft = UDim.new(0, icon and 35 or 10)
    Padding.PaddingRight = UDim.new(0, 10)

    if icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Parent = TabButton
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 10, 0.5, -10) -- 아이콘 위치
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Image = icon
        
        TabButton.Text = name
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
    else
        TabButton.Text = name
        TabButton.TextXAlignment = Enum.TextXAlignment.Center
    end

    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 6)
    TabButtonCorner.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name.."Page"
    TabPage.Parent = ContentFrame
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, -20, 1, -20)
    TabPage.Position = UDim2.new(0, 10, 0, 10)
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Library.Settings.AccentColor
    TabPage.Visible = false
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local TabPageLayout = Instance.new("UIListLayout")
    TabPageLayout.Parent = TabPage
    TabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabPageLayout.Padding = UDim.new(0, 8)

    TabButton.MouseButton1Click:Connect(function()
        if Window.CurrentTab then
            Window.CurrentTab.Button.BackgroundColor3 = Library.Settings.TabColor
            Window.CurrentTab.Page.Visible = false
        end
        
        Window.CurrentTab = Tab
        TabButton.BackgroundColor3 = Library.Settings.TabSelectedColor
        TabPage.Visible = true
    end)

    if not Window.CurrentTab then
        Window.CurrentTab = Tab
        TabButton.BackgroundColor3 = Library.Settings.TabSelectedColor
        TabPage.Visible = true
    end

    Tab.Button = TabButton
    Tab.Page = TabPage
end

        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = TabPage
            Button.BackgroundColor3 = Library.Settings.ButtonColor
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Library.Settings.Font
            Button.Text = text
            Button.TextColor3 = Library.Settings.TextColor
            Button.TextSize = Library.Settings.TextSize
            Button.AutoButtonColor = false

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Settings.ButtonHoverColor
                }):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Settings.ButtonColor
                }):Play()
            end)

            Button.MouseButton1Click:Connect(callback)
            return Button
        end

        function Tab:CreateToggle(text, default, callback)
            local Toggle = {Value = default or false}
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Library.Settings.ButtonColor
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame

            local ToggleButton = Instance.new("")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Toggle.Value and Library.Settings.ToggleColor or Library.Settings.ButtonColor
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleButton.Size = UDim2.new(0, 45, 0, 24)
            ToggleButton.AutoButtonColor = false

            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton

            local Circle = Instance.new("Frame")
            Circle.Parent = ToggleButton
            Circle.BackgroundColor3 = Library.Settings.TextColor
            Circle.Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            Circle.Size = UDim2.new(0, 20, 0, 20)

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -75, 1, 0)
            Label.Font = Library.Settings.Font
            Label.Text = text
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local function UpdateToggle()
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Toggle.Value and Library.Settings.ToggleColor or Library.Settings.ButtonColor
                }):Play()
                
                TweenService:Create(Circle, TweenInfo.new(0.2), {
                    Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }):Play()
                
                callback(Toggle.Value)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                UpdateToggle()
            end)

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggle.Value = not Toggle.Value
                    UpdateToggle()
                end
            end)

            UpdateToggle()
            return Toggle
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local Slider = {Value = default or min}
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = Library.Settings.ButtonColor
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -30, 0, 25)
            Label.Font = Library.Settings.Font
            Label.Text = text
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ValueLabel.Size = UDim2.new(0, 35, 0, 25)
            ValueLabel.Font = Library.Settings.Font
            ValueLabel.Text = tostring(Slider.Value)
            ValueLabel.TextColor3 = Library.Settings.TextColor
            ValueLabel.TextSize = Library.Settings.TextSize

            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Library.Settings.BackgroundColor
            SliderBar.Position = UDim2.new(0, 15, 0, 35)
            SliderBar.Size = UDim2.new(1, -30, 0, 4)

            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar

            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Library.Settings.SliderColor
            SliderFill.Size = UDim2.new((Slider.Value - min)/(max - min), 0, 1, 0)

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill

            local SliderButton = Instance.new("TextButton")
            SliderButton.Parent = SliderBar
            SliderButton.BackgroundColor3 = Library.Settings.TextColor
            SliderButton.Position = UDim2.new((Slider.Value - min)/(max - min), -6, 0.5, -6)
            SliderButton.Size = UDim2.new(0, 12, 0, 12)
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false

            local SliderButtonCorner = Instance.new("UICorner")
            SliderButtonCorner.CornerRadius = UDim.new(1, 0)
            SliderButtonCorner.Parent = SliderButton

            local dragging = false

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), -6, 0.5, -6)
                    Slider.Value = math.floor(min + ((max - min) * math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)))
                    
                    TweenService:Create(SliderButton, TweenInfo.new(0.1), {Position = pos}):Play()
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)}):Play()
                    
                    ValueLabel.Text = tostring(Slider.Value)
                    callback(Slider.Value)
                end
            end)

            return Slider
        end

        function Tab:CreateDropdown(text, options, callback)
            local Dropdown = {Value = options[1], Open = false}
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = Library.Settings.ButtonColor
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
            DropdownFrame.ClipsDescendants = true

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = DropdownFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -35, 0, 35)
            Label.Font = Library.Settings.Font
            Label.Text = text..": "..Dropdown.Value
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Parent = DropdownFrame
            OptionsFrame.BackgroundColor3 = Library.Settings.DropdownColor
            OptionsFrame.Position = UDim2.new(0, 0, 0, 35)
            OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 25)
            OptionsFrame.Visible = false

            local OptionsCorner = Instance.new("UICorner")
            OptionsCorner.CornerRadius = UDim.new(0, 6)
            OptionsCorner.Parent = OptionsFrame

            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Parent = OptionsFrame
                OptionButton.BackgroundTransparency = 1
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Library.Settings.Font
                OptionButton.Text = option
                OptionButton.TextColor3 = Library.Settings.TextColor
                OptionButton.TextSize = Library.Settings.TextSize

                OptionButton.MouseButton1Click:Connect(function()
                    Dropdown.Value = option
                    Label.Text = text..": "..option
                    Dropdown.Open = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    OptionsFrame.Visible = false
                    callback(option)
                end)
            end

            DropdownFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dropdown.Open = not Dropdown.Open
                    if Dropdown.Open then
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35 + #options * 25)}):Play()
                        OptionsFrame.Visible = true
                    else
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        OptionsFrame.Visible = false
                    end
                end
            end)

            return Dropdown
        end

        function Tab:CreateSection(text)
            local Section = Instance.new("Frame")
            Section.Parent = TabPage
            Section.BackgroundColor3 = Library.Settings.SectionColor
            Section.Size = UDim2.new(1, 0, 0, 30)

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section

            local Label = Instance.new("TextLabel")
            Label.Parent = Section
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Font = Library.Settings.Font
            Label.Text = text
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            return Section
        end

        function Tab:CreateColorPicker(text, default, callback)
            local ColorPicker = {Value = default or Color3.fromRGB(255, 255, 255)}
            
            local ColorPickerFrame = Instance.new("Frame")
            ColorPickerFrame.Parent = TabPage
            ColorPickerFrame.BackgroundColor3 = Library.Settings.ButtonColor
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)

            local ColorPickerCorner = Instance.new("UICorner")
            ColorPickerCorner.CornerRadius = UDim.new(0, 6)
            ColorPickerCorner.Parent = ColorPickerFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = ColorPickerFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Font = Library.Settings.Font
            Label.Text = text
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Parent = ColorPickerFrame
            ColorDisplay.BackgroundColor3 = ColorPicker.Value
            ColorDisplay.Position = UDim2.new(1, -45, 0.5, -10)
            ColorDisplay.Size = UDim2.new(0, 35, 0, 20)

            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayCorner.Parent = ColorDisplay

            ColorDisplay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- 여기에 컬러피커 UI 구현
                    callback(ColorPicker.Value)
                end
            end)

            return ColorPicker
        end

        function Tab:CreateKeybind(text, default, callback)
            local Keybind = {Value = default or Enum.KeyCode.Unknown}
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Parent = TabPage
            KeybindFrame.BackgroundColor3 = Library.Settings.ButtonColor
            KeybindFrame.Size = UDim2.new(1, 0, 0, 35)

            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = KeybindFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = KeybindFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Size = UDim2.new(1, -85, 1, 0)
            Label.Font = Library.Settings.Font
            Label.Text = text
            Label.TextColor3 = Library.Settings.TextColor
            Label.TextSize = Library.Settings.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Parent = KeybindFrame
            KeyLabel.BackgroundColor3 = Library.Settings.ButtonColor
            KeyLabel.Position = UDim2.new(1, -75, 0.5, -12)
            KeyLabel.Size = UDim2.new(0, 65, 0, 24)
            KeyLabel.Font = Library.Settings.Font
            KeyLabel.Text = Keybind.Value.Name
            KeyLabel.TextColor3 = Library.Settings.TextColor
            KeyLabel.TextSize = Library.Settings.TextSize

            local KeyLabelCorner = Instance.new("UICorner")
            KeyLabelCorner.CornerRadius = UDim.new(0, 4)
            KeyLabelCorner.Parent = KeyLabel

            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = KeyLabel
            KeyButton.BackgroundTransparency = 1
            KeyButton.Size = UDim2.new(1, 0, 1, 0)
            KeyButton.Font = Library.Settings.Font
            KeyButton.Text = ""
            KeyButton.TextColor3 = Library.Settings.TextColor
            KeyButton.TextSize = Library.Settings.TextSize

            local binding = false

            KeyButton.MouseButton1Click:Connect(function()
                binding = true
                KeyLabel.Text = "Press any key..."
            end)

        local UserInputService = game:GetService("UserInputService")

        local function CreateKeybindButton(KeyLabel, Library, callback)
            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = KeyLabel
            KeyButton.BackgroundTransparency = 1
            KeyButton.Size = UDim2.new(1, 0, 1, 0)
            KeyButton.Font = Library.Settings.Font
            KeyButton.Text = ""
            KeyButton.TextColor3 = Library.Settings.TextColor
            KeyButton.TextSize = Library.Settings.TextSize

        local binding = false

        KeyButton.MouseButton1Click:Connect(function()
            binding = true
            KeyLabel.Text = "Press any key..."
        end)

        UserInputService.InputBegan:Connect(function(input)
            if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                binding = false
                KeyLabel.Text = input.KeyCode.Name
                if callback then)
                    callback(input.KeyCode)
                end
            end
        end)
    end
