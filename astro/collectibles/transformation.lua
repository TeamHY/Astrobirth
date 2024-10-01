---
local MOM_SOUND_VOLUME = 1

local MOM_FORM_COOLDOWN = 36000 * 30 --왼쪽이 게임 시간

local MOM_FORM_NUM = 1
---

local isc = require("astro.lib.isaacscript-common")

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_TRANSFORMATION,
    ---@param player EntityPlayer
    ---@param playerForm PlayerForm
    ---@param hasForm boolean
    function(_, player, playerForm, hasForm)
        SFXManager():Play(SoundEffect.SOUND_MOTHER_SPIN_START, MOM_SOUND_VOLUME)
    end,
    PlayerForm.PLAYERFORM_MOM
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local room = Game():GetRoom()

        if player:HasPlayerForm(PlayerForm.PLAYERFORM_MOM) and not room:IsClear() and room:GetBossID() ~= 6 and Game():GetFrameCount() % MOM_FORM_COOLDOWN == 0 then
            for _ = 1, MOM_FORM_NUM do
                player:UseCard(Card.CARD_HIGH_PRIESTESS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    ---@param entity Entity
    ---@param amount number
    ---@param damageFlags number
    ---@param source EntityRef
    ---@param countdownFrames number
    function(_, entity, amount, damageFlags, source, countdownFrames)
        local player = entity:ToPlayer()

        if player ~= nil and player:HasPlayerForm(PlayerForm.PLAYERFORM_MOM) then
            if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.MOM_FOOT_STOMP then
                return false
            end
        end
    end
)
