Astro.Collectible.RITE_OF_ARAMESIR = Isaac.GetItemIdByName("Rite of Aramesir")

local useSound = Isaac.GetSoundIdByName('Specialsummon')
local useSoundVoulme = 1 -- 0 ~ 1

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if EID then
            Astro:AddEIDCollectible(Astro.Collectible.RITE_OF_ARAMESIR, "아라메시아의 의", "...", "사용 시 {{Trinket" .. Astro.Trinket.BLACK_MIRROR .. "}}Black Mirror를 소환합니다.#스테이지 진입 시 쿨타임이 채워집니다.")
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            for j = 0, ActiveSlot.SLOT_POCKET2 do
                if player:GetActiveItem(j) == Astro.Collectible.RITE_OF_ARAMESIR then
                    player:SetActiveCharge(50, j)
                end
            end
        end
    end
)


Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        Astro:SpawnTrinket(Astro.Trinket.BLACK_MIRROR, playerWhoUsedItem.Position)

        SFXManager():Play(useSound, useSoundVoulme)

        return {
            Discharge = true,
            Remove = false,
            ShowAnim = true,
        }
    end,
    Astro.Collectible.RITE_OF_ARAMESIR
)
