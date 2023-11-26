Astro.Collectible.CHAOS_DICE = Isaac.GetItemIdByName("Chaos Dice")

if EID then
    EID:addCollectible(Astro.Collectible.CHAOS_DICE, "사용 시 방 안의 모든 아이템과 픽업을 다른 아이템으로 바꿉니다.#바뀐 아이템의 배열은 랜덤으로 결정됩니다.", "혼돈의 주사위")
end

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        playerWhoUsedItem:UseCard(Card.CARD_SOUL_EDEN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

        return true
    end,
    Astro.Collectible.CHAOS_DICE
)
