---

-- NOTE: 변경 관련 코드가 Astrobirth(구 AstroItems)에도 존재합니다. 변경 혹은 제거 시 함께 수정해야합니다.
-- planetarium-beggar, lava-beggar

---

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesDarkBum",
        function(descObj)
            return descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_DARK_BUM
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#모든 거지가 악마 거지로 변경됩니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    Astro.Callbacks.POST_SLOT_INIT,
    ---@param slot Entity
    function(_, slot)
        if slot.Variant == 4 or slot.Variant == 7 or slot.Variant == 9 or slot.Variant == 13 or slot.Variant == 18 or slot.Variant == Astro.Entity.LAVA_BEGGAR.Variant or slot.Variant == Astro.Entity.PLANETARIUM_BEGGAR.Variant then
            Isaac.Spawn(EntityType.ENTITY_SLOT, 5, 0, slot.Position, Vector(0, 0), nil)
            slot:Remove()
        end
    end
)
