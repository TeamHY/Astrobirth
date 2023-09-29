local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CURSED_HEART = Isaac.GetItemIdByName("Cursed Heart")

if EID then
    EID:addCollectible(
        Astro.Collectible.CURSED_HEART,
        "↑ {{DamageSmall}}공격력 배율 x1.25#공격에 유도 효과가 생깁니다.#!!! 이번 게임에서 {{Collectible182}}Sacred Heart가 등장하지 않습니다.",
        "저주받은 심장"
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART)
    end,
    Astro.Collectible.CURSED_HEART
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.CURSED_HEART) then
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
