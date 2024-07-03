function checkLevel()
    local player = game:GetService("Players").LocalPlayer
    if player then
        return player.Data.Level
    else
        return nil  -- หรือค่าที่ต้องการในกรณีที่ไม่พบผู้เล่น
    end
end
