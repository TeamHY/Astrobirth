local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.DENEB = Isaac.GetItemIdByName("Deneb")

if EID then
    EID:addCollectible(
        Astro.Collectible.DENEB,
        "다음 게임 시작 시 애프터버스 추가 변종 스테이지 (Burning Basement, Flooded Caves, Dank Depths, Scarred Womb)가 등장하지 않습니다.",
        "데네브"
    )
end

local function TryChangeStage()
    if Astro.Data.BanAfterbirthStage then
        local level = Game():GetLevel()
        local stage = level:GetStage()
        local rng = Isaac.GetPlayer():GetCollectibleRNG(Astro.Collectible.DENEB)

        if level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH and stage <= LevelStage.STAGE4_2 then
            Isaac.ExecuteCommand("stage " .. stage .. (rng:RandomFloat() < 0.5 and "" or "a"))
            print("Deneb Effect: Ban Afterbirth Stage")
        end
    end
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            if Astro.Data.RunDeneb then
                Astro.Data.BanAfterbirthStage = true
                TryChangeStage()
            else
                Astro.Data.BanAfterbirthStage = false
            end

            Astro.Data.RunDeneb = false
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        if Game():GetFrameCount() > 1 then
            TryChangeStage()
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        Astro.Data.RunDeneb = true
    end,
    Astro.Collectible.DENEB
)
