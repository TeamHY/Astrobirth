local isc = require("astro.lib.isaacscript-common")

Astro.Collectible = {}

require "astro.collectibles.status"

require "astro.collectibles.vanillas.aquarius"
require "astro.collectibles.vanillas.damocles"
require "astro.collectibles.vanillas.luna"

require "astro.collectibles.customs.aquarius-ex"
require "astro.collectibles.customs.aries-ex"
require "astro.collectibles.customs.cancer-ex"
require "astro.collectibles.customs.capricorn-ex"
require "astro.collectibles.customs.casiopea"
require "astro.collectibles.customs.comet"
require "astro.collectibles.customs.corvus"
require "astro.collectibles.customs.cygnus"
require "astro.collectibles.customs.gemini-ex"
require "astro.collectibles.customs.greed"
require "astro.collectibles.customs.king-baby"
require "astro.collectibles.customs.leo-ex"
require "astro.collectibles.customs.libra-ex"
require "astro.collectibles.customs.pavo"
require "astro.collectibles.customs.pisces-ex"
require "astro.collectibles.customs.prometheus"
require "astro.collectibles.customs.ptolemaeus"
require "astro.collectibles.customs.pure-white-heart"
require "astro.collectibles.customs.scorpio-ex"
require "astro.collectibles.customs.silver-bullet"
require "astro.collectibles.customs.super-magneto"
require "astro.collectibles.customs.taurus-ex"
require "astro.collectibles.customs.virgo-ex"

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
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_MILK then
                EID:appendToDescription(descObj, "#몬스터가 있는 방 입장 시 30% 확률로 {{Collectible486}}Dull Razor를 1회 발동합니다. {{BossRoom}}보스방에서는 항상 발동합니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_ZODIAC then
                EID:appendToDescription(
                    descObj,
                    "#!!! 획득 시 사라지고 배열에서 제거됩니다.#{{Planetarium}}천체관 아이템 2개를 소환합니다. 하나를 선택하면 나머지는 사라집니다."
                )
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_VOODOO_HEAD then
                EID:appendToDescription(
                    descObj,
                    "#획득 시 {{Trinket" .. Astro.Trinket.BLOODY_BANDAGE .. "}}Bloody Bandage를 1개 소환합니다."
                )
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
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local currentRoom = Game():GetLevel():GetCurrentRoom()

        if not currentRoom:IsClear() then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MILK) then
                    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MILK)

                    if currentRoom:GetType() == RoomType.ROOM_BOSS or rng:RandomFloat() < 0.3 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, false, true, false, false)
                    end
                end
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
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_VOODOO_HEAD) then
            Astro:SpawnTrinket(Astro.Trinket.BLOODY_BANDAGE, player.Position)
        end
    end,
    CollectibleType.COLLECTIBLE_VOODOO_HEAD
)
