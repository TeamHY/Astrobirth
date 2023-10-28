local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.REINCARNATION = Isaac.GetItemIdByName("Reincarnation")

if EID then
    EID:addCollectible(Astro.Collectible.REINCARNATION, "다음 게임 시작 시 {{Collectible482}}Clicker가 소환됩니다.", "리인카네이션")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunReincarnation then
            local player = Isaac.GetPlayer()

            Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_CLICKER, player.Position)

            Astro.Data.RunReincarnation = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunReincarnation = true
    end,
    Astro.Collectible.REINCARNATION
)
