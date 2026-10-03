local CONFIRM_TEXT = "현재 적용중인 BAN 을 해제하시겠습니까? YES 라면 한번 더 저에게 말을 걸어주세요."
local COMPLETE_TEXT = "다음판에 BAN 시스템이 적용되지 않도록 설정하였습니다."
local SPAWN_GRID_INDEX = 108

local dialogueFont = Font()
dialogueFont:Load(Astro.Fight.modPath .. "resources/font/eid_korean_soyakkoma_shadow.fnt")

Astro.Entities.BAN_BEGGAR = Isaac.GetEntityVariantByName("Ban Beggar")

if EID then
    EID:addEntity(
        EntityType.ENTITY_SLOT,
        Astro.Entities.BAN_BEGGAR,
        0,
        "BAN 해제 거지",
        "두 번 말을 걸면 다음 판의 아이템 BAN을 해제합니다."
    )
end

local function SpawnBanBeggar()
    local level = Game():GetLevel()

    if level:GetCurrentRoomIndex() ~= level:GetStartingRoomIndex() or level:GetAbsoluteStage() == LevelStage.STAGE4_3 then
        return
    end

    if Astro.Data.disableNextBan then
        return
    end

    if Isaac.CountEntities(nil, EntityType.ENTITY_SLOT, Astro.Entities.BAN_BEGGAR, -1) > 0 then
        return
    end

    local room = Game():GetRoom()
    local position = room:GetGridPosition(SPAWN_GRID_INDEX)

    local beggar = Astro:Spawn(EntityType.ENTITY_SLOT, Astro.Entities.BAN_BEGGAR, 0, position)
    beggar:GetSprite():Play("enter", true)
    beggar.Mass = 100
end

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        Astro:ScheduleForUpdate(SpawnBanBeggar, 1)
    end
)

---@param first Entity
---@param second Entity
---@return boolean
local function IsTouching(first, second)
    return first.Position:Distance(second.Position) <= first.Size + second.Size
end

Astro:AddCallback(
    ModCallbacks.MC_PRE_PLAYER_COLLISION,
    ---@param player EntityPlayer
    ---@param collider Entity
    function(_, player, collider)
        if collider.Type ~= EntityType.ENTITY_SLOT or collider.Variant ~= Astro.Entities.BAN_BEGGAR then
            return
        end

        if not collider:Exists() then
            return
        end

        local data = collider:GetData()
        local sprite = collider:GetSprite()

        if data.banBeggarTouching then
            return
        end

        data.banBeggarTouching = true

        if not sprite:IsPlaying("idle") or Astro:IsDialogueTyping(collider) then
            return
        end

        if data.banBeggarConfirming or Astro.Data.disableNextBan then
            Astro.Data.disableNextBan = true
            Astro:ShowDialogue(collider, COMPLETE_TEXT, nil, dialogueFont)
            sprite:Play("speak_yes", true)
        else
            data.banBeggarConfirming = true
            Astro:ShowDialogue(collider, CONFIRM_TEXT, nil, dialogueFont)
            sprite:Play("speak", true)
        end

    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for _, beggar in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, Astro.Entities.BAN_BEGGAR, -1, true)) do
            local data = beggar:GetData()
            local sprite = beggar:GetSprite()

            if beggar.GridCollisionClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
                for entityType = EntityType.ENTITY_BOMB, EntityType.ENTITY_PICKUP do
                    for _, entity in ipairs(Isaac.FindByType(entityType, -1, -1, true)) do
                        if entity.FrameCount <= 1 and IsTouching(entity, beggar) then
                            entity:Remove()
                        end
                    end
                end

                Astro:HideDialogue(beggar)
                beggar:Remove()
            elseif sprite:IsFinished("exit") then
                beggar:Remove()
            else
                if sprite:IsFinished("enter") or (sprite:IsPlaying("speak") and not Astro:IsDialogueTyping(beggar)) then
                    sprite:Play("idle", true)
                elseif sprite:IsPlaying("speak_yes") and not Astro:IsDialogueTyping(beggar) then
                    sprite:Play("prize_yes", true)
                elseif sprite:IsFinished("prize_yes") and not Astro:IsDialogueActive(beggar) then
                    sprite:Play("exit", true)
                end

                local touching = false

                for i = 0, Game():GetNumPlayers() - 1 do
                    local player = Isaac.GetPlayer(i)

                    if not player:IsDead() and IsTouching(player, beggar) then
                        touching = true
                        break
                    end
                end

                if not touching then
                    data.banBeggarTouching = false
                end
            end
        end
    end
)
