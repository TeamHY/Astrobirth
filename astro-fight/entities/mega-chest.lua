Astro:AddCallback(
	ModCallbacks.MC_PRE_PICKUP_COLLISION,
	---@param entityPickup EntityPickup
	---@param collider Entity
	---@param low boolean
	function(_, entityPickup, collider, low)
		local sprite = entityPickup:GetSprite()
		local isOpened = sprite:GetAnimation() ~= "Idle" and sprite:GetAnimation() ~= "UseKey" and sprite:GetAnimation() ~= "UseCoin"

		if not isOpened and entityPickup.Variant == PickupVariant.PICKUP_MEGACHEST then
			if collider.Type == EntityType.ENTITY_PLAYER then
				local player = collider:ToPlayer()
                -- TODO: RNG 교체해야 함
                local rng = player:GetCollectibleRNG(Astro.Collectible.ANGRY_ONION)

                local data = entityPickup:GetData()

                if player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
                    while player:GetNumCoins() > 0 do
                        if (data.count == nil) then
                            data.count = 1
                        else
                            data.count = data.count + 1
                        end
    
                        player:AddCoins(-1)
    
                        if (data.count >= 7 or rng:RandomFloat() < 0.1) then -- 동전 소모 개수만큼 10% 독립시행 확률
                            entityPickup:TryOpenChest(player)
                            break
                        else
                            sprite:Play("UseCoin", true)
                            -- TODO: 사운드 재생 추가
                        end
                    end
                else
                    if player:HasGoldenKey() then
                        entityPickup:TryOpenChest(player)
                        return nil
                    end

                    while player:GetNumKeys() > 0 do
                        if (data.count == nil) then
                            data.count = 1
                        else
                            data.count = data.count + 1
                        end
    
                        player:AddKeys(-1)
    
                        if (data.count >= 7 or rng:RandomFloat() < 0.1) then -- 열쇠 소모 개수만큼 10% 독립시행 확률
                            entityPickup:TryOpenChest(player)
                            break
                        else
                            sprite:Play("UseKey", true)
                            -- TODO: 열쇠 사운드 재생 추가
                        end
                    end
                end

				return false
			end
		end
	end
)
