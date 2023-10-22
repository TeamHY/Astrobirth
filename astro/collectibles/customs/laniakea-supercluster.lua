Astro.Collectible.LANIAKEA_SUPERCLUSTER = Isaac.GetItemIdByName("Laniakea Supercluster")

if EID then
    EID:addCollectible(Astro.Collectible.LANIAKEA_SUPERCLUSTER, "사용 시 모든 {{Planetarium}}행성방 아이템이 존재하는 방으로 이동합니다.", "라니아케아 초은하단")
end

-- 사용 시 모든 행성방 배열이 존재하는 방으로 이동됩니다
-- └울그로 이동되는 그리드 아이템처럼 행성방 0번으로 이동하면 됨. 참고로 액티브는 소모성 아니니까 삭제 ㄴㄴ

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        Isaac.ExecuteCommand("goto s.planetarium.0")
    end,
    Astro.Collectible.LANIAKEA_SUPERCLUSTER
)
