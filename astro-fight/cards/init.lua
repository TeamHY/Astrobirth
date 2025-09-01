Astro.Card = {}
Astro.EIDCard = {}

Astro.Card.THE_COLD = Isaac.GetCardIdByName("I - The Cold")
Astro.Card.THE_SERVANT = Isaac.GetCardIdByName("II - The Servant")
Astro.Card.WISDOM = Isaac.GetCardIdByName("III - Wisdom")
Astro.Card.REPENTANCE = Isaac.GetCardIdByName("IV - Repentance")
Astro.Card.ETERNITY = Isaac.GetCardIdByName("V - Eternity")
Astro.Card.CORRUPTION = Isaac.GetCardIdByName("VI - Corruption")
Astro.Card.IMMOLATION = Isaac.GetCardIdByName("VII - Immolation")
Astro.Card.WORSHIP = Isaac.GetCardIdByName("VIII - Worship")

---@param id Card
---@param eidDescription string
---@param name string
---@param description string
function Astro:AddEIDCard(id, eidDescription, name, description)
    if EID then
        EID:addCard(id, eidDescription, name, "ko_kr")
    end

    Astro.EIDCard[id] = {
        name = name,
        description = description
    }
end

if EID then
    local nonongRemixCard = Sprite()
    nonongRemixCard:Load("gfx/ui/cards/lostcards.anm2", true)
    EID:addIcon("Card" .. Astro.Card.THE_COLD, "I - The Cold", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.THE_SERVANT, "II - The Servant", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.WISDOM, "III - Wisdom", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.REPENTANCE, "IV - Repentance", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.ETERNITY, "V - Eternity", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.CORRUPTION, "VI - Corruption", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.IMMOLATION, "VII - Immolation", 0, 9, 9, 4, 7, nonongRemixCard)
    EID:addIcon("Card" .. Astro.Card.WORSHIP, "VIII - Worship", 0, 9, 9, 4, 7, nonongRemixCard)

    Astro:AddEIDCard(
        Astro.Card.THE_COLD,
        "{{Slow}} 그 방의 적이 둔화됩니다.",
        "I - 냉기", "눈처럼 차갑고 고요하리라"
    )

    Astro:AddEIDCard(
        Astro.Card.THE_SERVANT,
        "{{Collectible123}} 사용 시 그 스테이지에서 랜덤 패밀리어를 하나 소환합니다.",
        "II - 종신", "당신의 명령을 기다리리라"
    )

    Astro:AddEIDCard(
        Astro.Card.WISDOM,
        "{{SuperSecretRoom}} 사용 시 일급비밀방으로 이동합니다.",
        "III - 지혜", "당신의 지식이 강인함을 가져오리라"
    )

    Astro:AddEIDCard(
        Astro.Card.REPENTANCE,
        "사용 시 30% 확률로 해당 방 안의 아이템을 변경하거나;" ..
        "#실패 시 {{BrokenHeart}}소지 불가능 체력 2칸을 추가합니다." ..
        "#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)",
        "IV - 회개", "반드시 기억하리라"
    )

    Astro:AddEIDCard(
        Astro.Card.ETERNITY,
        "{{EternalHeart}} 이터널하트를 1~4개 드랍합니다.",
        "V - 영원", "영원히 축복받으리라"
    )

    Astro:AddEIDCard(
        Astro.Card.CORRUPTION,
        "{{ErrorRoom}} 사용 시 30% 확률로 오류방으로 이동하거나;" ..
        "#실패 시 {{BrokenHeart}}소지 불가능 체력 2칸을 추가합니다." ..
        "#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)",
        "VI - 부패", "미지로 이끌어가리라..."
    )

    Astro:AddEIDCard(
        Astro.Card.IMMOLATION,
        "{{SacrificeRoom}} 사용 시 희생방으로 이동합니다.",
        "VII - 희생", "주를 향한 희생"
    )

    Astro:AddEIDCard(
        Astro.Card.WORSHIP,
        "사용 시 30% 확률로 현재 방 배열 아이템이 소환하거나;" ..
        "#실패 시 {{Pill1}}Bad Trip 알약을 발동합니다." ..
        "#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)",
        "VIII - 숭배", "육체와 영혼을 바치리라"
    )
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
