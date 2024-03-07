Astro.Collectible.Oblivion = Isaac.GetItemIdByName("Oblivion")

if EID then
    Astro:AddEIDCollectible(
        Astro.Collectible.Oblivion,
        "망각",
        "...",
        "사용 시 {{Card41}}Black Rune 효과를 발동합니다."
    )
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
        playerWhoUsedItem:UseCard(Card.RUNE_BLACK, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
        return true
    end,
    Astro.Collectible.Oblivion
)
