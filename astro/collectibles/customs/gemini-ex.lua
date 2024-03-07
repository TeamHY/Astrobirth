local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.GEMINI_EX = Isaac.GetItemIdByName("Gemini EX")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.GEMINI_EX,
        "초 쌍둥이자리",
        "...",
        "현재 소지중인 아이템에서 랜덤하게 5개를 소환합니다. 하나를 선택하면 나머지는 사라집니다."
    )
end

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
                Astro:SpawnCollectible(value, player.Position + Vector(Astro.GRID_SIZE * (-3 + key), -Astro.GRID_SIZE), Astro.Collectible.GEMINI_EX)
            end
        end
    end,
    Astro.Collectible.GEMINI_EX
)
