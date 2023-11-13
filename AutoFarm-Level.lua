-- ตั้งค่าสำหรับเกม 
_G.AutoFarm_Level = true
_G.FastAttack = true

-- ตัวแปรสำหรับทำภารกิจ
local MON, QUESTTITLE, QUESTPOS, MONPOS, QUESTNAME, QUESTNUMBER, SPAWNPOINT, SPAWNPOINTPOS

-- ฟังก์ชันตรวจสอบเลเวลและตั้งค่าภารกิจ
function checkLevel()
    local Level = game.Players.LocalPlayer.Data.Level.Value
    if Level == 1 or Level <= 9 then
        MON = "Bandit [Lv. 5]"
        QUESTTITLE = "Bandit"
        QUESTPOS = CFrame.new(1060.0158691406, 16.424287796021, 1547.9769287109)
        MONPOS = CFrame.new(1148.8698730469, 16.432844161987, 1630.5396728516)
        QUESTNAME = "BanditQuest1"
        QUESTNUMBER = 1
        SPAWNPOINT = "Default"
        SPAWNPOINTPOS = CFrame.new(973.96197509766, 16.273551940918, 1413.2775878906)
        combatWithMonsters()  -- เรียกใช้ฟังก์ชันนี้เพื่อทำการต่อสู้กับมอนสเตอร์
    end
end


-- ฟังก์ชันเปลี่ยนที่อยู่ที่ใช้ในการต่อสู้
function toggleMethod()
    if Methodnow == 1 then
        Methodnow = 2
        Method = CFrame.new(0, 25, 0)
    else
        Methodnow = 1
        Method = CFrame.new(0, 0, 25)
    end
end

-- ฟังก์ชันโทรทัศน์ไปยังภารกิจ
function teleportToQuest()
    -- โทรทัศน์ไปยังภารกิจ
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = QUESTPOS
    wait(0.8)

    -- เริ่มภารกิจ
    local args = {
        [1] = "StartQuest",
        [2] = QUESTNAME,
        [3] = QUESTNUMBER
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    wait(0.8)

    -- โทรทัศน์ไปยังตำแหน่งของมอนสเตอร์
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = MONPOS
end

-- ฟังก์ชันต่อสู้กับมอนสเตอร์
function combatWithMonsters()
    for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
        for i2, v2 in pairs(game.Workspace.Enemies:GetChildren()) do
            if v.Name == MON and v2.Name == MON then
                v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                v2.HumanoidRootPart.CanCollide = false
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * Method
                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
            end
        end
    end
end


-- ฟังก์ชันตรวจสอบการเปิด/ปิด Warp
function toggleWarp()
    if _G.WARP then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
    else
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end

-- ฟังก์ชันตรวจสอบเป้าหมายและละทิ้งเควสที่ไม่ตรงกับเป้าหมาย
function checkQuestTarget()
    if not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, QUESTTITLE) then
        local args = {
            [1] = "AbandonQuest"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end

-- ฟังก์ชันหลังจากเกิด RenderStepped
function onRenderStepped()
    pcall(function()
        if _G.FastAttack and _G.AutoFarm_Level then
            local Combat = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework)
            local Cemara = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
            Cemara.CameraShakeInstance.CameraShakeState = {FadingIn = 3, FadingOut = 2, Sustained = 0, Inactive = 1}
            Combat.activeController.timeToNextAttack = 0
            Combat.activeController.hitboxMagnitude = 120
            Combat.activeController.increment = 3
        end
    end)

    pcall(function()
        if _G.AutoFarm_Level then
            game:GetService('VirtualUser'):CaptureController()
            game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
        end
    end)
end

-- ฟังก์ชันหลังจากเกิด Heartbeat
function onHeartbeat()
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and _G.AutoFarm_Level then
        setfflag("HumanoidParallelRemoveNoPhysics", "False")
        setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end

-- ทำการ spawn ฟังก์ชันต่าง ๆ
spawn(function()
    while wait(3) do
        toggleMethod()
    end
end)

spawn(function()
    while wait() do
        toggleWarp()
    end
end)

spawn(function()
    game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
end)

spawn(function()
    while wait() do
        if _G.AutoFarm_Level then
            pcall(function()
                checkLevel()
                checkQuestTarget()

                if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    if game.Players.LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT then
                        local args = {
                            [1] = "SetTeam",
                            [2] = "Pirates"
                        }
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        wait(0.5)
                        teleportToQuest()
                    else
                        _G.WARP = true
                        repeat
                            wait()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SPAWNPOINTPOS
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                        until game.Players.LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT or _G.AutoFarm_Level == false
                        _G.WARP = false
                    end
                end

                combatWithMonsters()
            end)
        end
    end
end)

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(onRenderStepped)
end)
