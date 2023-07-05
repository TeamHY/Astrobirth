local capricornEX = {}

function capricornEX:OnPostNewRoom()
    local game = Game();

    if game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
        
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, capricornEX.OnPostNewRoom)

return capricornEX
