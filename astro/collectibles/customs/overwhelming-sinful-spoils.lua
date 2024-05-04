Astro.Collectible.OVERWHELMING_SINFUL_SPOILS = Isaac.GetItemIdByName("Overwhelming Sinful Spoils")

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.OVERWHELMING_SINFUL_SPOILS, "폭주하는 죄보", "...", "적 처치 시 영혼을 흡수합니다. 사용 시 영혼을 소모해 여러 유령을 소환합니다.#최대 50개까지 저장할 수 있습니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
             Astro.Data.OverwhelmingSinfulSpoils = {
                Souls = 0
             }
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags UseFlag
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        if collectibleID == Astro.Collectible.OVERWHELMING_SINFUL_SPOILS then
            for _ = 1, Astro.Data.OverwhelmingSinfulSpoils.Souls do
                local rng = playerWhoUsedItem:GetCollectibleRNG(Astro.Collectible.OVERWHELMING_SINFUL_SPOILS)
                local random = rng:RandomInt(3)

                if random == 0 then
                    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, playerWhoUsedItem.Position, Vector.Zero, playerWhoUsedItem)
                    effect:GetSprite():Play("Charge", false)
                elseif random == 1 then
                    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 0, playerWhoUsedItem.Position, Vector.Zero, playerWhoUsedItem)
                    local data = effect:GetData()

                    if not data.Astro then
                        data.Astro = {}
                    end

                    data.Astro.KillFrame = Game():GetFrameCount() + 7 * 30
                else
                    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 1, playerWhoUsedItem.Position, Vector.Zero, playerWhoUsedItem)
                    local data = effect:GetData()

                    if not data.Astro then
                        data.Astro = {}
                    end

                    data.Astro.KillFrame = Game():GetFrameCount() + 10 * 30
                end
            end

            Astro.Data.OverwhelmingSinfulSpoils.Souls = 0

            return true
        end
    end,
    Astro.Collectible.OVERWHELMING_SINFUL_SPOILS
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    ---@param npc EntityNPC
    function(_, npc)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            if player:HasCollectible(Astro.Collectible.OVERWHELMING_SINFUL_SPOILS) then
                local soul = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_SOUL, 0, npc.Position, Vector.Zero, player)

                local data = soul:GetData()
                data.OverwhelmingSinfulSpoils = {
                    player = player,
                }

                -- local rng = player:GetCollectibleRNG(Astro.Collectible.OVERWHELMING_SINFUL_SPOILS)
                -- soul:AddVelocity(Vector.One.FromAngle(rng:RandomInt(360)):Resized(200))

                break
            end
        end
    end
)

Astro:AddCallback(
	ModCallbacks.MC_POST_EFFECT_UPDATE,
	---@param effect EntityEffect
	function(_, effect)
        local data = effect:GetData()

        if data.OverwhelmingSinfulSpoils then
            local player = data.OverwhelmingSinfulSpoils.player

            effect:AddVelocity((player.Position - effect.Position):Resized(20))

            if effect.Position:Distance(player.Position) < 10 then
                Astro.Data.OverwhelmingSinfulSpoils.Souls = Astro.Data.OverwhelmingSinfulSpoils.Souls + 1

                if Astro.Data.OverwhelmingSinfulSpoils.Souls > 50 then
                    Astro.Data.OverwhelmingSinfulSpoils.Souls = 50
                end

                effect:Remove()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
        
            if player:HasCollectible(Astro.Collectible.OVERWHELMING_SINFUL_SPOILS) then
                local souls = Astro.Data.OverwhelmingSinfulSpoils.Souls

                Isaac.RenderText(
                    "x" .. souls,
                    Isaac.WorldToScreen(player.Position).X,
                    Isaac.WorldToScreen(player.Position).Y - 40,
                    1,
                    1,
                    1,
                    1
                )

                break
            end
        end
    end
)
