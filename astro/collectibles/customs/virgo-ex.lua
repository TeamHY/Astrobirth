local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    EID:addCollectible(Astro.Collectible.VIRGO_EX, "획득 시 {{Trinket152}}Telescope Lens, {{Pill1}}Gulp!가 소환됩니다.#다음 게임 시작 시 {{Trinket152}}Telescope Lens 또는 {{Collectible194}}Magic 8 Ball 하나 소환합니다.", "초 처녀자리")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued and Astro.Data.RunVirgo then
            local player = Isaac.GetPlayer()
            local collectibleRNG = player:GetCollectibleRNG(Astro.Collectible.VIRGO_EX)

            if collectibleRNG:RandomFloat() > 0.5 then
                Astro:SpawnTrinket(TrinketType.TRINKET_TELESCOPE_LENS, player.Position)
            else
                Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_MAGIC_8_BALL, player.Position)
            end

            Astro.Data.RunVirgo = false
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro:SpawnPill(PillEffect.PILLEFFECT_GULP, player.Position)
        Astro:SpawnTrinket(TrinketType.TRINKET_TELESCOPE_LENS, player.Position)

        Astro.Data.RunVirgo = true
    end,
    Astro.Collectible.VIRGO_EX
)
