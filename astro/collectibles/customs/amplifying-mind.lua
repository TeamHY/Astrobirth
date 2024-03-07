Astro.Collectible.AMPLIFYING_MIND = Isaac.GetItemIdByName("Amplifying Mind")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.AMPLIFYING_MIND, "증폭하는 마음", "...", "1초 마다 공격력이 0.005 증가합니다.#피격 시 60초 동안 증가 효과가 중단됩니다.#중첩 시 다음 증가량부터 적용됩니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()

        if player ~= nil then
            if player:HasCollectible(Astro.Collectible.AMPLIFYING_MIND) then
                if damageFlags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS) == 0 then
                    local data = Astro:GetPersistentPlayerData(player)

                    data.AmplifyingMindCooldown = Game():GetFrameCount() + 1 * Astro.MINUTE
                end
            end
        end
    end
)

---@param player EntityPlayer
---@return number
local function ComputeMultiplier(player)
    local result = player:GetCollectibleNum(Astro.Collectible.AMPLIFYING_MIND)

    if player:GetPlayerType() == Astro.Players.LEAH then
        result = result + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    end

    return result
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:HasCollectible(Astro.Collectible.AMPLIFYING_MIND) then
            local data = Astro:GetPersistentPlayerData(player)

            if data then
                if data.AmplifyingMindDamage == nil then
                    data.AmplifyingMindDamage = 0
                end
    
                local cooldown = data.AmplifyingMindCooldown or 0
                local frame = Game():GetFrameCount()
    
                if frame % 30 == 0 and cooldown < frame then
                    data.AmplifyingMindDamage = data.AmplifyingMindDamage + 0.005 * ComputeMultiplier(player)
    
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:EvaluateItems()
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        local data = Astro:GetPersistentPlayerData(player)

		if data then
			local damage = data.AmplifyingMindDamage or 0

			player.Damage = player.Damage + damage
		end
    end,
    CacheFlag.CACHE_DAMAGE
)
