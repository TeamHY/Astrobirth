local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.GO_HOME = Isaac.GetItemIdByName("Go Home!")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.GO_HOME, "집으로!", "...", "!!! 획득 시 사라지고 Home으로 이동합니다.")
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Isaac.ExecuteCommand("stage 13a")

        player:RemoveCollectible(Astro.Collectible.GO_HOME)
    end,
    Astro.Collectible.GO_HOME
)
