local isc = require("astro.lib.isaacscript-common")

require "astro.collectibles.active"
-- require "AstroItems.Collectibles.golden"
require "astro.collectibles.status"

require "astro.collectibles.vanillas.aquarius"
require "astro.collectibles.vanillas.blood-oath"
require "astro.collectibles.vanillas.crickets-body"
require "astro.collectibles.vanillas.dads-lost-coin"
require "astro.collectibles.vanillas.damocles"
require "astro.collectibles.vanillas.depression"
require "astro.collectibles.vanillas.false_phd"
require "astro.collectibles.vanillas.king-baby"
require "astro.collectibles.vanillas.luna"
require "astro.collectibles.vanillas.marbles"
require "astro.collectibles.vanillas.yum-heart"

if EID then
    EID:addDescriptionModifier(
        "AstroCollectibles",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                return true
            end
        end,
        function(descObj)
            if descObj.ObjSubType == CollectibleType.COLLECTIBLE_HUSHY then
                EID:appendToDescription(descObj, "#Hush의 체력이 15% 감소됩니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LIL_DELIRIUM then
                EID:appendToDescription(descObj, "#Delirium의 체력이 15% 감소됩니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_DARK_BUM then
                EID:appendToDescription(descObj, "#빨간 거미가 등장하지 않습니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_MILK then
                EID:appendToDescription(
                    descObj,
                    "#몬스터가 있는 방 입장 시 30% 확률로 {{Collectible486}}Dull Razor를 1회 발동합니다. {{BossRoom}}보스방에서는 항상 발동합니다."
                )
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_BLOODY_LUST or descObj.ObjSubType == CollectibleType.COLLECTIBLE_BLOODY_GUST then
                EID:appendToDescription(descObj, "#방 클리어 시 30% 확률로 {{Collectible486}}Dull Razor를 1회 발동합니다.#한 스테이지에서 최대 6번 발동될 수 있습니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_CRACKED_ORB then
                EID:appendToDescription(descObj, "#방 클리어 시 10% 확률로 {{Collectible486}}Dull Razor를 1회 발동합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 90 이상일 때 100% 확률 (행운 1당 +1%p)")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_SALVATION then
                EID:appendToDescription(descObj, "#방 클리어 시 10% 확률로 {{Collectible486}}Dull Razor를 1회 발동합니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 90 이상일 때 100% 확률 (행운 1당 +1%p)")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_ZODIAC then
                EID:appendToDescription(
                    descObj,
                    "#!!! 획득 시 사라지고 배열에서 제거됩니다.#{{Planetarium}}천체관 아이템 2개를 소환합니다. 하나를 선택하면 나머지는 사라집니다."
                )
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_VOODOO_HEAD then
                EID:appendToDescription(
                    descObj,
                    "#획득 시 {{Trinket" .. AstroItems.Trinket.BLOODY_BANDAGE .. "}}Bloody Bandage를 1개 소환합니다."
                )
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_INFESTATION then
                EID:appendToDescription(descObj, "#획득 시 {{Trinket70}}Louse를 1개 소환합니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_ARIES then
                EID:appendToDescription(descObj, "#획득 시 {{Trinket35}}Curved Horn을 1개 소환합니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_D20 then
                EID:appendToDescription(descObj, "#획득 시 {{Card49}}Dice Shard를 1개 소환합니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_INCUBUS then
                EID:appendToDescription(descObj, "#!!! 이번 게임에서 {{Collectible698}}Twisted Pair가 등장하지 않습니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_TWISTED_PAIR then
                EID:appendToDescription(descObj, "#!!! 이번 게임에서 {{Collectible360}}Incubus가 등장하지 않습니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LUCKY_FOOT then
                EID:appendToDescription(descObj, "#맵에 행운방의 위치가 표시됩니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_BONE_SPURS then
                EID:appendToDescription(descObj, "#!!! The Beast 보스방에서 사라집니다.")
            end

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entity Entity
    function(_, entity)
        if entity.Type == EntityType.ENTITY_HUSH then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(CollectibleType.COLLECTIBLE_HUSHY) then
                    entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.15
                    break
                end
            end
        elseif entity.Type == EntityType.ENTITY_DELIRIUM then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(CollectibleType.COLLECTIBLE_LIL_DELIRIUM) then
                    entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.15
                    break
                end
            end
        elseif entity.Type == EntityType.ENTITY_SPIDER and Astro:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM) then
            entity:Remove()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()
        local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

        if not currentRoom:IsClear() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasCollectible(CollectibleType.COLLECTIBLE_MILK) then
                    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MILK)

                    if currentRoom:GetType() == RoomType.ROOM_BOSS or rng:RandomFloat() < 0.3 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                        SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                    end
                end
            end
        end

        if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
            if currentRoomDesc.Data.Name == "Beast Room" then
                for i = 1, Game():GetNumPlayers() do
                    local player = Isaac.GetPlayer(i - 1)
                
                    Astro:RemoveAllCollectible(player, CollectibleType.COLLECTIBLE_BONE_SPURS)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
                local level = Game():GetLevel()
                local idx = level:QueryRoomTypeIndex(RoomType.ROOM_BARREN, false, RNG())
                local room = level:GetRoomByIdx(idx)

                if room.Data.Type == RoomType.ROOM_BARREN then
                    room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
                    level:UpdateVisibility()
                end
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST) or player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_GUST) then
                Astro:GetPersistentPlayerData(player).BloodyLust = {
                    Count = 0
                }
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local itemPool = Game():GetItemPool()
        local currentRoom = Game():GetLevel():GetCurrentRoom()

        player:RemoveCollectible(CollectibleType.COLLECTIBLE_ZODIAC)
        itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_ZODIAC)

        Astro:SpawnCollectible(
            itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, currentRoom:GetSpawnSeed()),
            player.Position + Vector(-40, 0),
            CollectibleType.COLLECTIBLE_ZODIAC
        )
        Astro:SpawnCollectible(
            itemPool:GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, currentRoom:GetSpawnSeed()),
            player.Position + Vector(40, 0),
            CollectibleType.COLLECTIBLE_ZODIAC
        )
    end,
    CollectibleType.COLLECTIBLE_ZODIAC
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if collectibleType == CollectibleType.COLLECTIBLE_VOODOO_HEAD and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_VOODOO_HEAD) then
            Astro:SpawnTrinket(AstroItems.Trinket.BLOODY_BANDAGE, player.Position)
        elseif collectibleType == CollectibleType.COLLECTIBLE_INFESTATION and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_INFESTATION) then
            Astro:SpawnTrinket(TrinketType.TRINKET_LOUSE, player.Position)
        elseif collectibleType == CollectibleType.COLLECTIBLE_ARIES and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_ARIES) then
            Astro:SpawnTrinket(TrinketType.TRINKET_CURVED_HORN, player.Position)
        elseif collectibleType == CollectibleType.COLLECTIBLE_D20 and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_D20) then
            Astro:SpawnCard(Card.CARD_DICE_SHARD, player.Position)
        elseif collectibleType == CollectibleType.COLLECTIBLE_INCUBUS and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_INCUBUS) then
            Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_TWISTED_PAIR)
        elseif collectibleType == CollectibleType.COLLECTIBLE_TWISTED_PAIR and Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_TWISTED_PAIR) then
            Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_INCUBUS)
        elseif collectibleType == CollectibleType.COLLECTIBLE_LUCKY_FOOT then
            local level = Game():GetLevel()
            local idx = level:QueryRoomTypeIndex(RoomType.ROOM_BARREN, false, RNG())
            local room = level:GetRoomByIdx(idx)

            if room.Data.Type == RoomType.ROOM_BARREN then
                room.DisplayFlags = room.DisplayFlags | RoomDescriptor.DISPLAY_BOX | RoomDescriptor.DISPLAY_ICON
                level:UpdateVisibility()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST) or player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_GUST) then
                local data = Astro:GetPersistentPlayerData(player)

                if data.BloodyLust == nil then
                    data.BloodyLust = {
                        Count = 0
                    }
                end

                if data.BloodyLust.Count < 6 then
                    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BLOODY_LUST)

                    if rng:RandomFloat() < 0.3 + player.Luck / 100 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                        SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                    end

                    data.BloodyLust.Count = data.BloodyLust.Count + 1
                end
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_CRACKED_ORB) then
                local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_CRACKED_ORB)

                if rng:RandomFloat() < 0.1 + player.Luck / 100 then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                    SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                end
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_SALVATION) then
                local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SALVATION)

                if rng:RandomFloat() < 0.1 + player.Luck / 100 then
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                    SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
                end
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_TRANSFORMATION,
    ---@param player EntityPlayer
    ---@param playerForm PlayerForm
    ---@param hasForm boolean
    function(_, player, playerForm, hasForm)
        local data = Astro:GetPersistentPlayerData(player)

        if not data.RunMomForm and hasForm then
            data.RunMomForm = true

            local list = {
                CollectibleType.COLLECTIBLE_PHD,
                CollectibleType.COLLECTIBLE_FALSE_PHD,
                AstroItems.Collectible.MASTERS_DEGREE,
                AstroItems.Collectible.BACHELORS_DEGREE,
            }

            local inventory = Astro:getPlayerInventory(player, false)
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MOMS_HEELS)
            local optionsPickupIndex = CollectibleType.COLLECTIBLE_MOMS_HEELS + player.Index * 10000

            local hadCollectable = Astro:GetRandomCollectibles(inventory, rng, 1, nil, true)[1]

            if hadCollectable ~= nil then
                player:RemoveCollectible(hadCollectable)
                Astro:SpawnCollectible(hadCollectable, player.Position, optionsPickupIndex)
            end

            -- for _ = 1, 2 do
            local random = rng:RandomInt(#list) + 1

            Astro:SpawnCollectible(list[random], player.Position, optionsPickupIndex)
            table.remove(list, random)
            -- end
        end
    end,
    PlayerForm.PLAYERFORM_MOM
)
