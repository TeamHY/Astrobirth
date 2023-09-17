local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    EID:addCollectible(Astro.Collectible.VIRGO_EX, "다음 게임 시작 시 {{Planetarium}}행성방으로 이동됩니다", "초 처녀자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunVirgo then
            local player = Isaac.GetPlayer()
            local collectibleRNG = player:GetCollectibleRNG(Astro.Collectible.VIRGO_EX)

            Isaac.ExecuteCommand("goto s.planetarium." .. collectibleRNG:RandomInt(7))
            Astro.Data.RunVirgo = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunVirgo = true
    end,
    Astro.Collectible.VIRGO_EX
)
