local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.SOLAR_SYSTEM = Isaac.GetItemIdByName("Solar System")

-- TODO: 현재는 아래 리스트에서 천체관 배열 상태와 상관없이 소환합니다.
--       소환은 실제 배열에서 소환하도록 변경할 수 있으나, 제거 기능은 아래 리스트가 필요합니다.

-- 천체관 아이템 리스트 (itempools.xml과 별도로 업데이트해야 합니다.)
local planetariumList = {
    392,
    588,
    589,
    590,
    591,
    592,
    593,
    594,
    595,
    596,
    597,
    598,
    Astro.Collectible.CYGNUS,
    Astro.Collectible.LIBRA_EX,
    Astro.Collectible.CANCER_EX,
    Astro.Collectible.SCORPIO_EX,
    Astro.Collectible.CAPRICORN_EX,
    Astro.Collectible.VIRGO_EX,
    Astro.Collectible.LEO_EX,
    Astro.Collectible.ARIES_EX,
    Astro.Collectible.TAURUS_EX,
    Astro.Collectible.AQUARIUS_EX,
    Astro.Collectible.CASIOPEA,
    Astro.Collectible.CORVUS,
    Astro.Collectible.PAVO,
    Astro.Collectible.COMET,
    Astro.Collectible.PISCES_EX,
    Astro.Collectible.GEMINI_EX,
    Astro.Collectible.PTOLEMAEUS,
    Astro.Collectible.ALTAIR,
    Astro.Collectible.VEGA,
    Astro.Collectible.SOLAR_SYSTEM
}

if EID then
    EID:addCollectible(
        Astro.Collectible.SOLAR_SYSTEM,
        "획득 시 소지 중인 {{Planetarium}}천체관 아이템이 모두 제거됩니다. 제거한 수 만큼 {{Planetarium}}천체관 아이템을 소환합니다.",
        "태양계"
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.SOLAR_SYSTEM) then
            local count = 0

            for _, value in ipairs(planetariumList) do
                if player:HasCollectible(value) then
                    count = count + Astro:RemoveAllCollectible(player, value)
                end
            end

            local list = Astro:GetRandomCollectibles(planetariumList, player:GetCollectibleRNG(Astro.Collectible.SOLAR_SYSTEM), count)

            for _, value in ipairs(list) do
                Astro:SpawnCollectible(value, player.Position)
            end
        end
    end,
    Astro.Collectible.SOLAR_SYSTEM
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()
        local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

        if currentRoom:GetType() == RoomType.ROOM_ERROR and currentRoomDesc.Data.Variant == 0 then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_BIGCHEST,
                0,
                currentRoom:GetCenterPos(),
                Vector(0, 0),
                nil
            )
        end
    end
)
