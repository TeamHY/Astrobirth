---
local MOM_SOUND_VOLUME = 1

local MOM_FORM_COOLDOWN = 10 * 30

local MOM_FORM_NUM = 1
---

local isc = require("astro.lib.isaacscript-common")

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_TRANSFORMATION,
    ---@param player EntityPlayer
    ---@param playerForm PlayerForm
    ---@param hasForm boolean
    function(_, player, playerForm, hasForm)
        local data = Astro:GetPersistentPlayerData(player)

        if not data.RunMomForm and hasForm then
            data.RunMomForm = true

            SFXManager():Play(SoundEffect.SOUND_MOTHER_SPIN_START, MOM_SOUND_VOLUME)
        end
    end,
    PlayerForm.PLAYERFORM_MOM
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local data = Astro:GetPersistentPlayerData(player)
        local room = Game():GetRoom()

        if data and data.RunMomForm and not room:IsClear() and room:GetBossID() ~= 6 and Game():GetFrameCount() % MOM_FORM_COOLDOWN == 0 then
            for _ = 1, MOM_FORM_NUM do
                player:UseCard(Card.CARD_HIGH_PRIESTESS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
        end
    end
)
