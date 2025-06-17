---

local LEECH_COUNT = 1

---

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesMyShadow",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_MY_SHADOW then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#방 입장 시 검은색 아군 애벌레를 소환합니다. 중첩이 가능합니다.")
            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MY_SHADOW) then
                local room = Game():GetRoom()
                local collectibleCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MY_SHADOW)
                local totalLeechCount = LEECH_COUNT * collectibleCount
                
                if not room:IsClear() then
                    for _ = 1, totalLeechCount do
                        local leech = Isaac.Spawn(23, 0, 1, player.Position, Vector.Zero, player)
                        leech:AddCharmed(EntityRef(player), -1)
                    end
                end
            end
        end
    end
)
