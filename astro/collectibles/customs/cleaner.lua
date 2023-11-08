local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.CLEANER = Isaac.GetItemIdByName("Cleaner")

local collectibles = {}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        collectibles = {
            CollectibleType.COLLECTIBLE_MOMS_KNIFE,
            CollectibleType.COLLECTIBLE_BRIMSTONE,
            CollectibleType.COLLECTIBLE_IPECAC,
            CollectibleType.COLLECTIBLE_EPIC_FETUS,
            CollectibleType.COLLECTIBLE_DR_FETUS,
            CollectibleType.COLLECTIBLE_TECH_X,
            CollectibleType.COLLECTIBLE_TECHNOLOGY,
            CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
            Astro.Collectible.SCORPIO_EX,
            CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
            CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE
        }
    end
)

if EID then
    EID:addCollectible(
        Astro.Collectible.CLEANER,
        "!!! 효과가 발동한 뒤 사라집니다.#!!! 획득 시 아래 아이템이 제거됩니다.#{{Collectible114}}, {{Collectible329}}, {{Collectible579}}, {{Collectible736}}, {{Collectible152}}, {{Collectible68}}, {{Collectible395}}, {{Collectible52}}, {{Collectible168}}, {{Collectible149}}, {{Collectible118}}",
        "클리너"
    )
end

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        for _, collectible in ipairs(collectibles) do
            Astro:RemoveAllCollectible(player, collectible)
        end

        Astro:RemoveAllCollectible(player, Astro.Collectible.CLEANER)
    end,
    Astro.Collectible.CLEANER
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local stage = level:GetAbsoluteStage()
        local currentRoom = level:GetCurrentRoom()
        local currentRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())

        if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
            if (currentRoomDesc.Data.Name == "Starting Room" and stage == LevelStage.STAGE4_3) or (currentRoomDesc.Data.Variant == 0 and stage == LevelStage.STAGE6) then
                Astro:SpawnCollectible(Astro.Collectible.CLEANER, currentRoom:GetTopLeftPos(), nil, true)
            end
        end
    end
)
