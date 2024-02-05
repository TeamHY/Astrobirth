local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.BIRTHRIGHT_EDEN = Isaac.GetItemIdByName("Birthright - Eden")

if EID then
    EID:addCollectible(Astro.Collectible.BIRTHRIGHT_EDEN, "#!!! 효과가 발동한 뒤 사라집니다.#{{TreasureRoom}}황금방 아이템 3개를 소환합니다. 하나를 선택하면 나머지는 사라집니다.", "생득권 - 에덴")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        local game = Game()
        local itemPool = game:GetItemPool()
        local currentRoom = game:GetLevel():GetCurrentRoom()

        for _ = 1, 3 do
            Astro:SpawnCollectible(itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true, currentRoom:GetSpawnSeed()), player.Position, Astro.Collectible.BIRTHRIGHT_EDEN)
        end

        player:RemoveCollectible(Astro.Collectible.BIRTHRIGHT_EDEN)
    end,
    Astro.Collectible.BIRTHRIGHT_EDEN
)
