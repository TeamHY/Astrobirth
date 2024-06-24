local isc = require("astro.lib.isaacscript-common")

local collectibles = {
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_EPIC_FETUS,
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_TECH_X,
    CollectibleType.COLLECTIBLE_TECHNOLOGY
}

-- TODO: 설명 추가할 방법 찾기
-- if EID then
--     local itemsString = ""

--     for _, collectible in ipairs(collectibles) do
--         itemsString = itemsString .. "{{Collectible" .. collectible .. "}} "
--     end

--     EID:addBirthright(PlayerType.PLAYER_AZAZEL, "#아래 아이템 2개를 소환합니다. 하나를 선택하면 나머지는 사라집니다.#" .. itemsString)
-- end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)

            local items = Astro:GetRandomCollectibles(collectibles, rng, 2)

            for _, item in ipairs(items) do
                Astro:SpawnCollectible(item, player.Position, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            end
        end
    end,
    CollectibleType.COLLECTIBLE_BIRTHRIGHT
)
