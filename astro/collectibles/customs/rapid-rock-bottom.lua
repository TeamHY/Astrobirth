Astro.Collectible.RAPID_ROCK_BOTTOM = Isaac.GetItemIdByName("Rapid Rock Bottom")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.RAPID_ROCK_BOTTOM, "재빠른 밑바닥", "...", "연사를 항상 가장 높았던 값으로 고정합니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if isContinued then
            for i = 1, Game():GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1)
			
				local data = Astro:GetPersistentPlayerData(player)

				if data.peakFireDelay then
					player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
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
        if player:HasCollectible(Astro.Collectible.RAPID_ROCK_BOTTOM) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) then
            if cacheFlag == CacheFlag.CACHE_FIREDELAY then
                local data = Astro:GetPersistentPlayerData(player)

                if data then
                    if player.MaxFireDelay < (data.peakFireDelay or 10000) then
                        data.peakFireDelay = player.MaxFireDelay
                    end

                    player.MaxFireDelay = data.peakFireDelay
                end
            end
        end
    end
)
