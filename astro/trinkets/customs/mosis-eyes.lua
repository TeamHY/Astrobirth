local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.MOSIS_EYES = Isaac.GetTrinketIdByName("Mosi's Eyes")

if EID then
    EID:addTrinket(Astro.Trinket.MOSIS_EYES, "↓ {{LuckSmall}}행운 -3#캐릭터가 있는 방에서 2칸 이내에 있는 스테이지 구조를 맵에 표시합니다.#가려진 아이템을 알 수 있게 됩니다.", "모시의 눈")

    -- Astro:AddGoldenTrinketDescription(Astro.Trinket.MOSIS_EYES, "", 1)
end


local function DisplayNeighborRoom()
    local level = Game():GetLevel()

    local currentRoomPosition = Astro:ConvertRoomIndexToPosition(level:GetCurrentRoomIndex())

    for x = -2, 2 do
        for y = -2, 2 do
            local roomIndex = Astro:ConvertRoomPositionToIndex(currentRoomPosition + Vector(x, y))

            if roomIndex ~= -1 then
                local room = level:GetRoomByIdx(roomIndex)

                if room.Data and room.Data.Type ~= RoomType.ROOM_SECRET and room.Data.Type ~= RoomType.ROOM_SUPERSECRET and room.Data.Type ~= RoomType.ROOM_ULTRASECRET and room.DisplayFlags then
                    room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX
                end
            end
        end
    end

    level:UpdateVisibility()
end

local function TryRemoveBlind()
    if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == LevelCurse.CURSE_OF_BLIND then
        Game():GetLevel():RemoveCurses(LevelCurse.CURSE_OF_BLIND)
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if not player:HasTrinket(Astro.Trinket.MOSIS_EYES) then
                break
            end

            DisplayNeighborRoom()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        if Astro:HasTrinket(Astro.Trinket.MOSIS_EYES) then
            TryRemoveBlind()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasTrinket(Astro.Trinket.MOSIS_EYES) then
            player.Luck = player.Luck - 3
        end
    end,
    CacheFlag.CACHE_LUCK
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        if pickingUpItem.itemType == ItemType.ITEM_TRINKET and pickingUpItem.subType == Astro.Trinket.MOSIS_EYES then
            DisplayNeighborRoom()
            TryRemoveBlind()
            print("asd")
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if Astro:HasCollectible(Astro.Trinket.MOSIS_EYES) then
            if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local game = Game()
                local roomType = game:GetRoom():GetType()
                local stageType = game:GetLevel():GetStageType()

                if roomType == RoomType.ROOM_TREASURE and stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
                    local sprite = pickup:GetSprite()
                    sprite:ReplaceSpritesheet(1, Isaac.GetItemConfig():GetCollectible(pickup.SubType).GfxFileName)
                    sprite:LoadGraphics()
                end
            end
        end
    end
)
