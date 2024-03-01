Astro.Collectible.POWER_ROCK_BOTTOM = Isaac.GetItemIdByName("Power Rock Bottom")

if EID then
    EID:addCollectible(Astro.Collectible.POWER_ROCK_BOTTOM, "공격력을 항상 가장 높았던 값으로 고정합니다.", "강력한 밑바닥")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if isContinued then
            for i = 1, Game():GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1)
			
				local data = Astro:GetPersistentPlayerData(player)

				if data.peakDamage then
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:EvaluateItems()
				end
			end
        end
    end
)


Astro:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if player:HasCollectible(Astro.Collectible.POWER_ROCK_BOTTOM) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) then
            if cacheFlag == CacheFlag.CACHE_DAMAGE then
                local data = Astro:GetPersistentPlayerData(player)

                if data then
                    if player.Damage > (data.peakDamage or -10000) then
                        data.peakDamage = player.Damage
                    end

                    player.Damage = data.peakDamage
                end
            end
        end
    end
)
