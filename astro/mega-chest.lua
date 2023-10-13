-- FIXME: 게임 재시작 시 상자가 소모한 열쇠 개수가 초기화 됨.
-- FIXME: 게임 재시작 시 열려있는 상자도 열쇠를 소모 함.

Astro:AddCallback(
	ModCallbacks.MC_PRE_PICKUP_COLLISION,
	---@param entityPickup EntityPickup
	---@param collider Entity
	---@param low boolean
	function(_, entityPickup, collider, low)
		local player = collider:ToPlayer()

		if player ~= nil and player:HasGoldenKey() then
			entityPickup:TryOpenChest(player)
			entityPickup:GetData().isOpened = true
			return nil
		elseif player ~= nil and entityPickup.Variant == PickupVariant.PICKUP_MEGACHEST then
			if collider.Type == EntityType.ENTITY_PLAYER then
				-- TODO: RNG 교체해야 함
				local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_SAD_ONION)
				local data = entityPickup:GetData()

				-- TODO: 열리지 않을 시 열쇠 애니메이션 출력해야 함
				while player:GetNumKeys() > 0 do
					if data.isOpened then
						break
					end

					if (data.count == nil) then
						data.count = 1
					else
						data.count = data.count + 1
					end

					player:AddKeys(-1)

					if (data.count >= 7 or rng:RandomFloat() < 0.25) then -- 열쇠 소모 개수만큼 25% 독립시행 확률
						entityPickup:TryOpenChest(player)
						data.isOpened = true
						break
					end
				end

				return false
			end
		end
	end
)
