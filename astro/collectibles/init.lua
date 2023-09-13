Astro.Collectible = {}

require "astro.collectibles.aquarius-ex"
require "astro.collectibles.aries-ex"
require "astro.collectibles.cancer-ex"
require "astro.collectibles.capricorn-ex"
require "astro.collectibles.casiopea"
require "astro.collectibles.comet"
require "astro.collectibles.corvus"
require "astro.collectibles.cygnus"
require "astro.collectibles.king-baby"
require "astro.collectibles.leo-ex"
require "astro.collectibles.libra-ex"
require "astro.collectibles.luna"
require "astro.collectibles.pavo"
require "astro.collectibles.scorpio-ex"
require "astro.collectibles.taurus-ex"
require "astro.collectibles.virgo-ex"

if EID then
    EID:addDescriptionModifier(
        "TrinketStackingPlus",
        function(descObj)
            return true
        end,
        function(descObj)
            if descObj.ObjSubType == CollectibleType.COLLECTIBLE_LITTLE_HORN or descObj.ObjSubType == CollectibleType.COLLECTIBLE_EUTHANASIA or descObj.ObjSubType == CollectibleType.COLLECTIBLE_LOST_CONTACT then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER or descObj.ObjSubType == CollectibleType.COLLECTIBLE_BIRDS_EYE then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.8#↓ {{LuckSmall}}행운 -5")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_C_SECTION then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.8")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_HUSHY then
                EID:appendToDescription(descObj, "#Hush의 체력이 15% 감소됩니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LIL_DELIRIUM then
                EID:appendToDescription(descObj, "#Delirium의 체력이 15% 감소됩니다.")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_PARASITOID then
                EID:appendToDescription(descObj, "#{{LuckSmall}}행운 -2")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_TOUGH_LOVE then
                EID:appendToDescription(descObj, "#{{LuckSmall}}행운 -3")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_APPLE then
                EID:appendToDescription(descObj, "#{{LuckSmall}}행운 -4")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_ATHAME then
                EID:appendToDescription(descObj, "#{{LuckSmall}}행운 -3")
            elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_LODESTONE then
                EID:appendToDescription(descObj, "#{{LuckSmall}}행운 -2")
            end

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_HORN) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_EUTHANASIA) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT) then
                player.Damage = player.Damage * 0.75
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
                player.Damage = player.Damage * 0.8
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Damage = player.Damage * 0.8
            end
            
            if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
                player.Damage = player.Damage * 0.8
            end
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
                player.Luck = player.Luck - 5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Luck = player.Luck - 5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITOID) then
                player.Luck = player.Luck - 2
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_TOUGH_LOVE) then
                player.Luck = player.Luck - 3
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_APPLE) then
                player.Luck = player.Luck - 4
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_ATHAME) then
                player.Luck = player.Luck - 3
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_LODESTONE) then
                player.Luck = player.Luck - 2
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    ---@param entity Entity
    function(_, entity)
        if entity.Type == EntityType.ENTITY_HUSH then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(CollectibleType.COLLECTIBLE_HUSHY)then
                    entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.15
                    break
                end
            end
        elseif entity.Type == EntityType.ENTITY_DELIRIUM then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
    
                if player:HasCollectible(CollectibleType.COLLECTIBLE_LIL_DELIRIUM)then
                    entity.HitPoints = entity.HitPoints - entity.MaxHitPoints * 0.15
                    break
                end
            end
        end
    end
)
