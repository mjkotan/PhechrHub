function checkLevelAndPrint()
    local player = game:GetService("Players").LocalPlayer
    if player then
        local levelValue = player.Data.Level.Value
        print("Current level value:", levelValue)
        
        -- เช็คเงื่อนไข Level น้อยกว่า 9
        if levelValue < 9 then
            local questValue = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Value
            -- เช็คเงื่อนไข Quest เป็น false
            if not questValue then
                local args = {
                    [1] = "StartQuest",
                    [2] = "BanditQuest1",
                    [3] = 1
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
            else
                print("Quest is already active.")
            end
        else
            print("Player's level is 9 or higher. No action needed.")
        end
        
        return levelValue
    else
        return nil  -- หรือค่าที่ต้องการในกรณีที่ไม่พบผู้เล่น
    end
end

-- เรียกใช้งานฟังก์ชัน checkLevelAndPrint()
checkLevelAndPrint()
