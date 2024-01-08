Astro.Card = {}

require "astro.cards.capsules"

Astro.Card.THE_COLD = Isaac.GetCardIdByName("I - The Cold")
Astro.Card.THE_SERVANT = Isaac.GetCardIdByName("II - The Servant")
Astro.Card.WISDOM = Isaac.GetCardIdByName("III - Wisdom")
Astro.Card.REPENTANCE = Isaac.GetCardIdByName("IV - Repentance")
Astro.Card.ETERNITY = Isaac.GetCardIdByName("V - Eternity")
Astro.Card.CORRUPTION = Isaac.GetCardIdByName("VI - Corruption")
Astro.Card.IMMOLATION = Isaac.GetCardIdByName("VII - Immolation")
Astro.Card.WORSHIP = Isaac.GetCardIdByName("VIII - Worship")

if EID then
    EID:addCard(Astro.Card.THE_COLD, "사용 시 모든 적이 둔화됩니다.", "I - The Cold")
    EID:addCard(Astro.Card.THE_SERVANT, "사용 시 랜덤한 패밀리어 한마리가 소환됩니다.", "II - The Servant")
    EID:addCard(Astro.Card.WISDOM, "사용 시 일급 비밀방으로 이동합니다.", "III - Wisdom")
    EID:addCard(Astro.Card.REPENTANCE, "사용 시 30% 확률로 해당 방 안의 아이템을 변경합니다.#실패 시 깨진 하트 2개를 추가합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)", "IV - Repentance")
    EID:addCard(Astro.Card.ETERNITY, "사용 시 이터널 하트가 1~4개 소환됩니다.", "V - Eternity")
    EID:addCard(Astro.Card.CORRUPTION, "사용 시 30% 확률로 에러방으로 이동합니다.#실패 시 깨진 하트 2개를 추가합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)", "VI - Corruption")
    EID:addCard(Astro.Card.IMMOLATION, "사용 시 희생방으로 이동합니다.", "VII - Immolation")
    EID:addCard(Astro.Card.WORSHIP, "사용 시 30% 확률로 현재 방 배열 아이템이 소환됩니다.#실패 시 배드 트립 알약을 1회 적용시킵니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)", "VIII - Worship")
end

Astro:AddCallback(
    ModCallbacks.MC_USE_CARD,
    ---@param cardID Card
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    function(_, cardID, playerWhoUsedItem, useFlags)
        if cardID == Astro.Card.THE_COLD then
            playerWhoUsedItem:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, false, true, false, false)
            playerWhoUsedItem:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, false, true, false, false)
            playerWhoUsedItem:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, false, true, false, false)
        elseif cardID == Astro.Card.THE_SERVANT then
            playerWhoUsedItem:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, false, true, false, false)
        elseif cardID == Astro.Card.WISDOM then
            local level = Game():GetLevel()
            local roomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_SUPERSECRET, false, RNG());

            Game():StartRoomTransition(roomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
        elseif cardID == Astro.Card.REPENTANCE then
            local rng = playerWhoUsedItem:GetCardRNG(cardID)

            if rng:RandomFloat() < 0.3 + playerWhoUsedItem.Luck / 100 then
                playerWhoUsedItem:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, true, false, false)
            else
                playerWhoUsedItem:AddBrokenHearts(2)
            end
        elseif cardID == Astro.Card.ETERNITY then
            local rng = playerWhoUsedItem:GetCardRNG(cardID)
            local currentRoom = Game():GetLevel():GetCurrentRoom()

            for _ = 0, rng:RandomInt(4) do
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_ETERNAL,
                    currentRoom:FindFreePickupSpawnPosition(playerWhoUsedItem.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end
        elseif cardID == Astro.Card.CORRUPTION then
            local rng = playerWhoUsedItem:GetCardRNG(cardID)

            if rng:RandomFloat() < 0.3 + playerWhoUsedItem.Luck / 100 then
                local level = Game():GetLevel()
                local roomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_ERROR, false, RNG());

                Game():StartRoomTransition(roomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
            else
                playerWhoUsedItem:AddBrokenHearts(2)
            end
        elseif cardID == Astro.Card.IMMOLATION then
            local level = Game():GetLevel()
            local roomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_SACRIFICE, false, RNG());

            Game():StartRoomTransition(roomIndex, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
        elseif cardID == Astro.Card.WORSHIP then
            local rng = playerWhoUsedItem:GetCardRNG(cardID)

            if rng:RandomFloat() < 0.3 + playerWhoUsedItem.Luck / 100 then
                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_NULL, playerWhoUsedItem.Position)
            else
                playerWhoUsedItem:UsePill(PillEffect.PILLEFFECT_BAD_TRIP, PillColor.PILL_NULL, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
        end
    end
)
