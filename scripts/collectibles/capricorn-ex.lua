local item = {}

function item:OnPostNewRoom()
    local game = Game();

    if game:GetRoom():GetType() == RoomType.ROOM_DEVIL then
        
    end
end

Redrawn:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, item.OnPostNewRoom)

return item
