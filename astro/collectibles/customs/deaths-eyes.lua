local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.DEATHS_EYES = Isaac.GetItemIdByName("Death's Eyes")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.DEATHS_EYES,
        "사신의 눈",
        "...",
        "25%의 확률로 눈물에 후광이 생기며 후광에 닿은 적은 프레임당 2의 피해를 입습니다.#중첩 시 확률이 합 연산으로 증가합니다.#!!! 이번 게임에서 {{Collectible331}}Godhead가 등장하지 않습니다."
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_GODHEAD)
    end,
    Astro.Collectible.DEATHS_EYES
)

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if
                player:HasCollectible(Astro.Collectible.DEATHS_EYES) and
                    not player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD)
             then
                local rng = player:GetCollectibleRNG(Astro.Collectible.DEATHS_EYES)

                -- 눈물에 후광을 직접 적용하면 이펙트 오류가 발생한다. 따라서 리페어 모드와 동일한 아래 코드를 사용한다.
                player.TearFlags = player.TearFlags & ~TearFlags.TEAR_GLOW

                if rng:RandomFloat() < 0.25 * player:GetCollectibleNum(Astro.Collectible.DEATHS_EYES) then
                    player.TearFlags = player.TearFlags | TearFlags.TEAR_GLOW
                end

                if tear.TearFlags & TearFlags.TEAR_GLOW == TearFlags.TEAR_GLOW then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                end
            end
        end
    end
)
