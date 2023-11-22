Astro.Collectible.CHAOS_DICE = Isaac.GetItemIdByName("Chaos Dice")

if EID then
    EID:addCollectible(Astro.Collectible.CHAOS_DICE, "", "혼돈의 주사위")
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
    end,
    Astro.Collectible.CHAOS_DICE
)
