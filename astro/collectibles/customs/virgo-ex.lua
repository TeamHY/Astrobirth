local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.VIRGO_EX = Isaac.GetItemIdByName("Virgo EX")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.VIRGO_EX,
        "초 처녀자리",
        "...",
        "획득 시 {{Trinket152}}Telescope Lens, {{Pill1}}Gulp!가 소환됩니다.#{{Planetarium}}천체관을 보여줍니다.#다음 게임 시작 시 {{Trinket152}}Telescope Lens 또는 {{Collectible194}}Magic 8 Ball 하나 소환합니다."
    )
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

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        if Astro:CheckCollectible(Astro.Collectible.VIRGO_EX) then
            Astro:DisplayRoom(RoomType.ROOM_PLANETARIUM)
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:IsFirstAdded(Astro.Collectible.VIRGO_EX) then
            Astro:SpawnPill(PillEffect.PILLEFFECT_GULP, player.Position)
            Astro:SpawnTrinket(TrinketType.TRINKET_TELESCOPE_LENS, player.Position)
        end

        Astro:DisplayRoom(RoomType.ROOM_PLANETARIUM)

        Astro.Data.RunVirgo = true
    end,
    Astro.Collectible.VIRGO_EX
)
