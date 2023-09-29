local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.GEMINI_EX = Isaac.GetItemIdByName("Gemini EX")

if EID then
    EID:addCollectible(
        Astro.Collectible.GEMINI_EX,
        "현재 소지중인 아이템에서 랜덤하게 5개를 소환합니다. 하나를 선택하면 나머지는 사라집니다.#다음 게임 시작 시 {{Collectible318}}Gemini를 가지고 시작합니다.",
        "초 쌍둥이자리"
    )
end

local GRID_SIZE = 40

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunGeminiEX then
            local player = Isaac.GetPlayer()

            player:AddCollectible(CollectibleType.COLLECTIBLE_GEMINI)

            Astro.Data.RunGeminiEX = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.GEMINI_EX) then
            local level = Game():GetLevel()
            local currentRoom = level:GetCurrentRoom()
            local rng = player:GetCollectibleRNG(Astro.Collectible.GEMINI_EX)
            local inventory = Astro:getPlayerInventory(player, false)

            local listToSpawn = Astro:GetRandomCollectibles(inventory, rng, 5, Astro.Collectible.GEMINI_EX, true)

            for key, value in ipairs(listToSpawn) do
                Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_COLLECTIBLE,
                        value,
                        currentRoom:FindFreePickupSpawnPosition(
                            player.Position + Vector(GRID_SIZE * (-3 + key), -GRID_SIZE)
                        ),
                        Vector.Zero,
                        nil
                    ):ToPickup().OptionsPickupIndex = Astro.Collectible.GEMINI_EX
            end
        end

        Astro.Data.RunGeminiEX = true
    end,
    Astro.Collectible.GEMINI_EX
)
