local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.E = Isaac.GetItemIdByName("E")

if EID then
    EID:addCollectible(Astro.Collectible.E, "e - 저주받은 심장(Cursed Heart) : 배수 1.15배 + 유도 효과 적용 이번 게임에서 불심 배열 제거", "백금 탄환")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART)
    end,
    Astro.Collectible.E
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.E) then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage * 1.15
            elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
            elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
                player.TearColor = Color(0.45, 0.3, 0.3)
            end
        end
    end
)
