local hiddenItemManager = require("astro.lib.hidden_item_manager")

Astro.Players = {
    LEAH = Isaac.GetPlayerTypeByName("Leah"),
    DIABELLSTAR = Isaac.GetPlayerTypeByName("Diabellstar"),
    DIABELLSTAR_B = Isaac.GetPlayerTypeByName("Tainted Diabellstar", true),
    WATER_ENCHANTRESS = Isaac.GetPlayerTypeByName("Water Enchantress"),
    SUBJECT_GAMMA = Isaac.GetPlayerTypeByName("Subject Gamma"),
}

local DIABELLSTAR_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/character_diabellstar_hair.anm2")
local DIABELLSTAR_HAIR_B = Isaac.GetCostumeIdByPath("gfx/characters/character_diabellstar_hairb.anm2")
local WATER_ENCHANTRESS_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/character_water_enchantress_hair.anm2")

local startItem = {
    common = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_ISAAC] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
            -- Astro.Collectible.CHUBBYS_TAIL,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_MAGDALENE] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_CAIN] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_JUDAS] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_BLUEBABY] = {
        collectible = {
            CollectibleType.COLLECTIBLE_MARBLES,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_EVE] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_SAMSON] = {
        collectible = {
            Astro.Collectible.RHONGOMYNIAD,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_AZAZEL] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LAZARUS] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_EDEN] = {
        collectible = {
            CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THELOST] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LAZARUS2] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_BLACKJUDAS] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LILITH] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_KEEPER] = {
        collectible = {
            CollectibleType.COLLECTIBLE_DEEP_POCKETS,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_APOLLYON] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THEFORGOTTEN] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THESOUL] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_BETHANY] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_JACOB] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_ESAU] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [Astro.Players.LEAH] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [Astro.Players.DIABELLSTAR] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [Astro.Players.DIABELLSTAR_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [Astro.Players.WATER_ENCHANTRESS] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [Astro.Players.SUBJECT_GAMMA] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_ISAAC_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_MAGDALENE_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_CAIN_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_JUDAS_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_BLUEBABY_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_EVE_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_SAMSON_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_AZAZEL_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LAZARUS_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_EDEN_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THELOST_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LILITH_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_KEEPER_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_APOLLYON_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THEFORGOTTEN_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_BETHANY_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_JACOB_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_LAZARUS2_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            Card.CARD_HOLY,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_JACOB2_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
    [PlayerType.PLAYER_THESOUL_B] = {
        collectible = {
            -- CollectibleType.COLLECTIBLE_SAD_ONION,
        },
        trinket = {
            -- TrinketType.TRINKET_SWALLOWED_PENNY,
        },
        card = {
            -- Card.CARD_FOOL,
        },
        pill = {
            -- PillEffect.PILLEFFECT_BAD_GAS,
        }
    },
}

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)
                local playerType = player:GetPlayerType()
                local position = player.Position

                for _, itemTable in ipairs({ startItem.common, startItem[playerType] }) do
                    if itemTable == nil then
                        break
                    end

                    for _, value in ipairs(itemTable.collectible) do
                        Astro:SpawnCollectible(value, position)
                    end

                    for _, value in ipairs(itemTable.trinket) do
                        Astro:SpawnTrinket(value, position)
                    end

                    for _, value in ipairs(itemTable.card) do
                        Astro:SpawnCard(value, position)
                    end

                    for _, value in ipairs(itemTable.pill) do
                        Astro:SpawnPill(value, position)
                    end
                end

                if playerType == PlayerType.PLAYER_ISAAC then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_D6)
                elseif playerType == PlayerType.PLAYER_EVE then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_RAZOR_BLADE)
                elseif playerType == Astro.Players.DIABELLSTAR then
                    player:AddCollectible(Astro.Collectible.SINFUL_SPOILS_OF_SUBVERSION_SNAKE_EYE)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        local player = Isaac.GetPlayer()

        if not isContinued then
            hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)

            if
                player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B or
                player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B or
                player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or
                player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
            then
                hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            end
        end

        local itemConfig = Isaac.GetItemConfig()
        local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)

        player:RemoveCostume(itemConfigItem)
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        if player:GetPlayerType() == Astro.Players.DIABELLSTAR then
            if not player:GetEffects():HasNullEffect(DIABELLSTAR_HAIR) then
                player:GetEffects():AddNullEffect(DIABELLSTAR_HAIR, true)
                -- hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_SNAKE_EYE)
            end
        else
            if player:GetEffects():HasNullEffect(DIABELLSTAR_HAIR) then
                player:GetEffects():RemoveNullEffect(DIABELLSTAR_HAIR)
                -- hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_SNAKE_EYE)
            end
        end

        if player:GetPlayerType() == Astro.Players.DIABELLSTAR_B then
            if not player:GetEffects():HasNullEffect(DIABELLSTAR_HAIR_B) then
                player:GetEffects():AddNullEffect(DIABELLSTAR_HAIR_B, true)
                -- hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_SNAKE_EYE)
            end
        else
            if player:GetEffects():HasNullEffect(DIABELLSTAR_HAIR_B) then
                player:GetEffects():RemoveNullEffect(DIABELLSTAR_HAIR_B)
                -- hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_SNAKE_EYE)
            end
        end

        if player:GetPlayerType() == Astro.Players.WATER_ENCHANTRESS then
            if not player:GetEffects():HasNullEffect(WATER_ENCHANTRESS_HAIR) then
                player:GetEffects():AddNullEffect(WATER_ENCHANTRESS_HAIR, true)
            end
        else
            if player:GetEffects():HasNullEffect(WATER_ENCHANTRESS_HAIR) then
                player:GetEffects():RemoveNullEffect(WATER_ENCHANTRESS_HAIR)
            end
        end
    end
)
