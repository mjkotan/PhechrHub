function checkLevelAndPrint()
    local player = game:GetService("Players").LocalPlayer
    if player then
        local levelValue = player.Data.Level.Value
        print("Current level value:", levelValue)
        return levelValue
    else
        return nil  -- หรือค่าที่ต้องการในกรณีที่ไม่พบผู้เล่น
    end
end

-- เรียกใช้งานฟังก์ชัน checkLevelAndPrint()
checkLevelAndPrint()
