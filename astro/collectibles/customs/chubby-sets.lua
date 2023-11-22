Astro.Collectible.CHUBBYS_HEAD = Isaac.GetItemIdByName("Chubby's Head")
Astro.Collectible.SLEEPING_PUPPY = Isaac.GetItemIdByName("Sleeping Puppy")
Astro.Collectible.CHUBBYS_TAIL = Isaac.GetItemIdByName("Chubby's Tail")

if EID then
    EID:addCollectible(Astro.Collectible.CHUBBYS_HEAD, "↑ {{DamageSmall}}공격력(고정) +3.5", "처비의 머리")
    EID:addCollectible(Astro.Collectible.SLEEPING_PUPPY, "9번째 방 클리어 시 공격력, 연사, 사거리, 속도, 행운중 한가지의 스텟이 0.35(고정) 증가됩니다.", "잠자는 강아지")
    EID:addCollectible(Astro.Collectible.CHUBBYS_TAIL, "{{Chest}} 갈색 상자가 등장 시 33% 확률로 갈색 상자가 한 개 더 드랍 됩니다.", "처비의 꼬리")
end

local CHUBBYS_HEAD_DAMAGE = 3.5

local CHUBBYS_TAIL_SUBTYPE = 1000
local CHUBBYS_TAIL_CHANCE = 0.33

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.CHUBBYS_HEAD) then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + CHUBBYS_HEAD_DAMAGE
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_CHEST and pickup.SubType ~= CHUBBYS_TAIL_SUBTYPE then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:HasTrinket(Astro.Collectible.CHUBBYS_TAIL) then
                    local rng = player:GetTrinketRNG(Astro.Collectible.CHUBBYS_TAIL)

                    if rng:RandomFloat() < CHUBBYS_TAIL_CHANCE then
                        local currentRoom = Game():GetLevel():GetCurrentRoom()

                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_CHEST,
                            CHUBBYS_TAIL_SUBTYPE,
                            currentRoom:FindFreePickupSpawnPosition(pickup.Position, 40, true),
                            Vector.Zero,
                            nil
                        )
                    end

                    break
                end
            end

            pickup.SubType = CHUBBYS_TAIL_SUBTYPE
        end
    end
)
