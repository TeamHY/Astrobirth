Astro.Collectible.LUCKY_ROCK_BOTTOM = Isaac.GetItemIdByName("Lucky Rock Bottom")

if EID then
    EID:addCollectible(Astro.Collectible.LUCKY_ROCK_BOTTOM, "행운을 항상 가장 높았던 값으로 고정합니다.", "운 좋은 밑바닥")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if isContinued then
            for i = 1, Game():GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1)
			
				local data = Astro:GetPersistentPlayerData(player)

				if data.peakLuck then
					player:AddCacheFlags(CacheFlag.CACHE_LUCK)
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
        if player:HasCollectible(Astro.Collectible.LUCKY_ROCK_BOTTOM) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) then
            if cacheFlag == CacheFlag.CACHE_LUCK then
                local data = Astro:GetPersistentPlayerData(player)

                if data then
                    if player.Luck > (data.peakLuck or 0) then
                        data.peakLuck = player.Luck
                    end

                    player.Luck = data.peakLuck
                end
            end
        end
    end
)
