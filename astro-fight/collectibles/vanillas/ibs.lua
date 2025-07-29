---

local COOLDOWN_TIME = 300

local MIN_COOLDOWN_TIME = 300

---

if EID then
    EID:addDescriptionModifier(
        "AstroIBS",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_IBS then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#10초마다 {{DamageSmall}}공격력과 {{TearsSmall}}연사속도가 증가하는 장판을 생성합니다.#중복 시 쿨타임이 절반씩 감소합니다.")

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_IBS) then
                local data = Astro.SaveManager.GetRunSave(player)

                if data["ibs"] == nil then
                    data["ibs"] = {
                        NextFrameCount = 0
                    }
                end

                local frameCount = Game():GetFrameCount()

                if data["ibs"].NextFrameCount <= frameCount then
                    local ibsCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IBS)
                    data["ibs"].NextFrameCount = math.min(frameCount + COOLDOWN_TIME / (2 ^ (ibsCount - 1)), frameCount + MIN_COOLDOWN_TIME)

                    player:UsePoopSpell(PoopSpellType.SPELL_LIQUID)
                end
            end
        end
    end
)
