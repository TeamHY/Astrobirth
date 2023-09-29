local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.A = Isaac.GetItemIdByName("A")

if EID then
    EID:addCollectible(
        Astro.Collectible.A,
        "a - 사신의 눈(Death's Eyes) : 공격 시 50%(고정) 확률로 갓헤드 적용(유도까지 포함), 이번 게임에서 갓헤드 배열 제거",
        "백금 탄환"
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Game():GetItemPool():RemoveCollectible(CollectibleType.COLLECTIBLE_GODHEAD)
    end,
    Astro.Collectible.A
)

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if
                player:HasTrinket(Astro.Trinket.EYE_OF_GOD) and
                    not player:HasCollectible(CollectibleType.COLLECTIBLE_GODHEAD)
             then
                local rng = player:GetTrinketRNG(Astro.Trinket.EYE_OF_GOD)

                -- 눈물에 후광을 직접 적용하면 이펙트 오류가 발생한다. 따라서 리페어 모드와 동일한 아래 코드를 사용한다.
                player.TearFlags = player.TearFlags & ~TearFlags.TEAR_GLOW

                if rng:RandomFloat() < 0.5 then
                    player.TearFlags = player.TearFlags | TearFlags.TEAR_GLOW | TearFlags.TEAR_HOMING
                end
            end
        end
    end
)
