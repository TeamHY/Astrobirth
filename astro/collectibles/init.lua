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
            if
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_LITTLE_HORN or
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_EUTHANASIA or
                    descObj.ObjSubType == CollectibleType.COLLECTIBLE_LOST_CONTACT
             then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.75")
             elseif descObj.ObjSubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER or
                descObj.ObjSubType == CollectibleType.COLLECTIBLE_BIRDS_EYE
             then
                EID:appendToDescription(descObj, "#↓ {{DamageSmall}}공격력 배율 x0.8#↓ {{LuckSmall}}행운 -5")
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
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER) then
                player.Luck = player.Luck - 5
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRDS_EYE) then
                player.Luck = player.Luck - 5
            end
        end
    end
)
