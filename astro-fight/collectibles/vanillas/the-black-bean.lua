if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesTheBlackBean",
        function(descObj)
            if descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_BLACK_BEAN then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#방 마다 처음으로 적 처치 시 {{Collectible486}}Dull Razor를 1회 발동합니다.")

            return descObj
        end
    )
end

local isFirstKill = true

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        isFirstKill = true
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param entityNPC EntityNPC
    function(_, entityNPC)
        if isFirstKill and entityNPC.Type ~= EntityType.ENTITY_FIREPLACE then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_BEAN) then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                    SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                end
            end

            isFirstKill = false
        end
    end
)
