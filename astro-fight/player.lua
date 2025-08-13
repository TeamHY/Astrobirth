local hiddenItemManager = Astro.HiddenItemManager

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
            Astro.Collectible.THE_HOLY_BLOOD_AND_THE_HOLY_GRAIL,
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
    [Astro.Players.LEAH_B] = {
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
    [Astro.Players.WATER_ENCHANTRESS_B] = {
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
    [Astro.Players.DAVID_MARTINEZ] = {
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
    [Astro.Players.DAVID_MARTINEZ_B] = {
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
    [Astro.Players.STELLAR] = {
        collectible = {
            Astro.Collectible.VIRGO_EX,
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
    [Astro.Players.STELLAR_B] = {
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
    [Astro.Players.AINZ_OOAL_GOWN] = {
        collectible = {
            Astro.Collectible.STAFF_OF_AINZ_OOAL_GOWN,
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
    [Astro.Players.AINZ_OOAL_GOWN_B] = {
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
            -- hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)

            if
                player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B or
                player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B or
                player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or
                player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
            then
                hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            end
        end

        -- local itemConfig = Isaac.GetItemConfig()
        -- local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)

        -- player:RemoveCostume(itemConfigItem)
    end
)

--------------------------------------------------
-- 아이작 컨셉 효과
--------------------------------------------------

local diceData = {
    [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = 1,
    [CollectibleType.COLLECTIBLE_D6] = 1,
    [CollectibleType.COLLECTIBLE_D4] = 1,
    [Astro.Collectible.SPINUP_DICE] = 1,
    [Astro.Collectible.MIRROR_DICE] = 1,
    [Astro.Collectible.SACRED_DICE] = 1,
    [Astro.Collectible.RESTOCK_DICE] = 1,
    [Astro.Collectible.FORBIDDEN_DICE] = 1,
    [Astro.Collectible.QUBIT_DICE] = 1,
    [Astro.Collectible.PUZZLE_DICE] = 1,
}

Astro:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ---@param collectibleID CollectibleType
    ---@param rngObj RNG
    ---@param playerWhoUsedItem EntityPlayer
    ---@param useFlags integer
    ---@param activeSlot ActiveSlot
    ---@param varData integer
    function(_, collectibleID, rngObj, playerWhoUsedItem, useFlags, activeSlot, varData)
        if playerWhoUsedItem:GetPlayerType() == PlayerType.PLAYER_ISAAC and not activeSlot == -1 then
            Astro:ScheduleForUpdate(
                function()
                    local bonusCharge = diceData[collectibleID]

                    if bonusCharge then
                        if playerWhoUsedItem:GetActiveItem(activeSlot) == collectibleID and playerWhoUsedItem:GetActiveCharge(activeSlot) == 0 then
                            playerWhoUsedItem:SetActiveCharge(bonusCharge, activeSlot)
                        end
                    end
                end,
                1
            )
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:GetPlayerType() == PlayerType.PLAYER_ISAAC then
                local rng = player:GetCollectibleRNG(Astro.Collectible.SPINUP_DICE)
                local room = Game():GetRoom()
                local diceList = {}

                for key, _ in pairs(diceData) do
                    table.insert(diceList, key)
                end

                for j, dice in ipairs(Astro:GetRandomCollectibles(diceList, rng, 2)) do
                    local position = room:GetGridPosition(49 + j * 2)

                    Astro:SpawnCollectible(dice, position, Astro.Collectible.SPINUP_DICE * 1000, true)
                end

                player:RemoveCollectible(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))

                break;
            end
        end
    end
)
