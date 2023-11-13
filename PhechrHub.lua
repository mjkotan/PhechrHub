local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Phechr Hub #", -- Remove Fluent.Version from the title
    SubTitle = "by Phechr",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

-- ฟังก์ชัน CheckLevel เพื่อตรวจสอบระดับและตั้งค่าค่าต่าง ๆ
function CheckLevel()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value

    if Old_World then
        if Lv == 1 or Lv <= 9 or SelectMonster == "Bandit [Lv. 5]" then
            -- Bandit
            Ms = "Bandit [Lv. 5]"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            NameMon = "Bandit"
            
            -- เปิด-ปิด MyToggle
            MyToggleFunction()
        end
    end
end

-- ฟังก์ชัน MyToggleFunction เพื่อเปิด-ปิด MyToggle
function MyToggleFunction()
    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Farm", Default = false })

    Toggle:OnChanged(function()
        if Options.MyToggle.Value then
            -- กระทำเมื่อเปิด
            print("Auto Farm is ON")
        else
            -- กระทำเมื่อปิด
            print("Auto Farm is OFF")
        end
    end)

    Options.MyToggle:SetValue(false) -- ตั้งค่าให้เป็น false เริ่มต้น
end


    local Dropdown = Tabs.Main:AddDropdown("เลือกหมัด", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "คิดไม่ออก", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)

    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "คิดไม่ออก2", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)


    Options.MyToggle:SetValue(false) 


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
