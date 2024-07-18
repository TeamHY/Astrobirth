local isc = require("astro.lib.isaacscript-common")

local nextRunBanItems = {
    CollectibleType.COLLECTIBLE_SACRED_HEART,
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
    CollectibleType.COLLECTIBLE_GLASS_CANNON,
    CollectibleType.COLLECTIBLE_EUCHARIST,
    CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
    CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON,
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_STAIRWAY,
    CollectibleType.COLLECTIBLE_GODHEAD,
    CollectibleType.COLLECTIBLE_R_KEY,
    CollectibleType.COLLECTIBLE_MAGIC_SKIN,
    CollectibleType.COLLECTIBLE_CENSER,
    CollectibleType.COLLECTIBLE_SOL,
    CollectibleType.COLLECTIBLE_C_SECTION,
    CollectibleType.COLLECTIBLE_FLIP,
    CollectibleType.COLLECTIBLE_GOAT_HEAD,
    CollectibleType.COLLECTIBLE_APPLE,
    CollectibleType.COLLECTIBLE_DAMOCLES,
    CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
    CollectibleType.COLLECTIBLE_TOUGH_LOVE,
    CollectibleType.COLLECTIBLE_SACRED_ORB,
    CollectibleType.COLLECTIBLE_COMPASS,
    CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
    CollectibleType.COLLECTIBLE_PSY_FLY,
    CollectibleType.COLLECTIBLE_TREASURE_MAP,
    CollectibleType.COLLECTIBLE_BINGE_EATER,
    CollectibleType.COLLECTIBLE_LODESTONE,
    CollectibleType.COLLECTIBLE_MIND,
    CollectibleType.COLLECTIBLE_DEAD_CAT,
    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
    CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
    CollectibleType.COLLECTIBLE_LACHRYPHAGY,
    CollectibleType.COLLECTIBLE_BIRTHRIGHT,
    AstroItems.Collectible.TECHNOLOGY_OMICRON_EX,
    AstroItems.Collectible.AMAZING_CHAOS_SCROLL,
    AstroItems.Collectible.ARIES_EX,
    AstroItems.Collectible.BIRTHRIGHT_THE_LOST,
    AstroItems.Collectible.RITE_OF_ARAMESIR,
    AstroItems.Collectible.THE_HOLY_BLOOD_AND_THE_HOLY_GRAIL,
    AstroItems.Collectible.CAINS_SECRET_BAG,
    AstroItems.Collectible.CURSE_OF_ARAMATIR,
    AstroItems.Collectible.OMEGA_321,
    AstroItems.Collectible.FALLEN_ORB,
    AstroItems.Collectible.MY_MOON_MY_MAN,
    AstroItems.Collectible.WANTED_SEEKER_OF_SINFUL_SPOIL,
    AstroItems.Collectible.MIRROR_DICE,
    AstroItems.Collectible.BONFIRE,
    AstroItems.Collectible.SPINUP_DICE,
    AstroItems.Collectible.BLACK_CUBE,
    AstroItems.Collectible.RED_CUBE,
}

if EID then
    EID:addDescriptionModifier(
        "AstroBan",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and Astro:ContainCollectible(nextRunBanItems, descObj.ObjSubType) then
                return true
            end
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#!!! 주의: 해당 아이템을 획득했을 경우, 다음 판 배열에서 제거됩니다. (리셋하면 재사용 가능)")

            return descObj
        end
    )
end

local banItems = {
    common = {
        collectible = {
            CollectibleType.COLLECTIBLE_DADS_NOTE,
            CollectibleType.COLLECTIBLE_CANCER,
            CollectibleType.COLLECTIBLE_FRIEND_FINDER,
            CollectibleType.COLLECTIBLE_SPIN_TO_WIN,
            CollectibleType.COLLECTIBLE_MEGA_BEAN,
            CollectibleType.COLLECTIBLE_MOMS_PURSE,
            CollectibleType.COLLECTIBLE_KNIFE_PIECE_1,
            CollectibleType.COLLECTIBLE_KNIFE_PIECE_2,
            CollectibleType.COLLECTIBLE_CLICKER,
            CollectibleType.COLLECTIBLE_D100,
            CollectibleType.COLLECTIBLE_MORE_OPTIONS,
            CollectibleType.COLLECTIBLE_PARASITE,
            CollectibleType.COLLECTIBLE_MARS,
            CollectibleType.COLLECTIBLE_DAMOCLES,
            CollectibleType.COLLECTIBLE_GLITCHED_CROWN,
            CollectibleType.COLLECTIBLE_POUND_OF_FLESH,
            CollectibleType.COLLECTIBLE_MONTEZUMAS_REVENGE,
            CollectibleType.COLLECTIBLE_REDEMPTION,
            CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION,
            CollectibleType.COLLECTIBLE_DOCTORS_REMOTE,
            CollectibleType.COLLECTIBLE_MONSTROS_TOOTH,
            CollectibleType.COLLECTIBLE_BEAN,
            CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS,
            CollectibleType.COLLECTIBLE_KIDNEY_BEAN,
            CollectibleType.COLLECTIBLE_MOMS_BRACELET,
            CollectibleType.COLLECTIBLE_THE_JAR,
            CollectibleType.COLLECTIBLE_BUTTER_BEAN,
            CollectibleType.COLLECTIBLE_UNICORN_STUMP,
            CollectibleType.COLLECTIBLE_SCISSORS,
            CollectibleType.COLLECTIBLE_COMPOST,
            CollectibleType.COLLECTIBLE_JAR_OF_WISPS,
            CollectibleType.COLLECTIBLE_DEAD_TOOTH,
            CollectibleType.COLLECTIBLE_MISSING_NO,
            CollectibleType.COLLECTIBLE_BEST_BUD,
            CollectibleType.COLLECTIBLE_GUILLOTINE,
            CollectibleType.COLLECTIBLE_SAMSONS_CHAINS,
            CollectibleType.COLLECTIBLE_MYSTERY_EGG,
            CollectibleType.COLLECTIBLE_SUMPTORIUM,
            CollectibleType.COLLECTIBLE_WAIT_WHAT,
            CollectibleType.COLLECTIBLE_FRIEND_BALL,
            CollectibleType.COLLECTIBLE_MEGA_BEAN,
            CollectibleType.COLLECTIBLE_BOOMERANG,
            CollectibleType.COLLECTIBLE_BREATH_OF_LIFE,
            CollectibleType.COLLECTIBLE_GLAUCOMA,
            CollectibleType.COLLECTIBLE_EYE_OF_GREED,
            CollectibleType.COLLECTIBLE_CURSED_EYE,
            CollectibleType.COLLECTIBLE_IBS,
            CollectibleType.COLLECTIBLE_LEPROSY,
            CollectibleType.COLLECTIBLE_BIRD_CAGE,
            CollectibleType.COLLECTIBLE_LIL_PORTAL,
            CollectibleType.COLLECTIBLE_JAW_BONE,
            CollectibleType.COLLECTIBLE_SHADE,
            CollectibleType.COLLECTIBLE_OBSESSED_FAN,
            CollectibleType.COLLECTIBLE_FRIEND_ZONE,
            CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,
            CollectibleType.COLLECTIBLE_BLACK_BEAN,
            CollectibleType.COLLECTIBLE_LADDER,
            CollectibleType.COLLECTIBLE_KIDNEY_STONE,
            CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES,
            CollectibleType.COLLECTIBLE_NUMBER_TWO,
            CollectibleType.COLLECTIBLE_LINGER_BEAN,
            CollectibleType.COLLECTIBLE_POKE_GO,
            CollectibleType.COLLECTIBLE_JUPITER,
            CollectibleType.COLLECTIBLE_BUMBO,
            CollectibleType.COLLECTIBLE_GREEDS_GULLET,
            CollectibleType.COLLECTIBLE_BIRDS_EYE,
            CollectibleType.COLLECTIBLE_GODS_FLESH,
            AstroItems.Collectible.REINCARNATION,

        },
        trinket = {
            TrinketType.TRINKET_BROKEN_REMOTE,
            TrinketType.TRINKET_CARTRIDGE,
            TrinketType.TRINKET_MOMS_TOENAIL,
            TrinketType.TRINKET_MYSTERIOUS_PAPER,
            TrinketType.TRINKET_ERROR,
            TrinketType.TRINKET_FILIGREE_FEATHERS,
            TrinketType.TRINKET_RC_REMOTE,
            TrinketType.TRINKET_EXPANSION_PACK,
            TrinketType.TRINKET_FOUND_SOUL,
            TrinketType.TRINKET_MYOSOTIS,
            TrinketType.TRINKET_HOLLOW_HEART,
            TrinketType.TRINKET_MISSING_POSTER,
        },
        card = {
            Card.CARD_REVERSE_HIGH_PRIESTESS,
            Card.CARD_EMPEROR,
            Card.CARD_WHEEL_OF_FORTUNE,
            Card.CARD_HANGED_MAN,
            Card.CARD_TOWER,
            Card.CARD_HEARTS_2,
            Card.RUNE_HAGALAZ,
            Card.RUNE_BLANK,
            Card.CARD_EMERGENCY_CONTACT,
            Card.CARD_REVERSE_HANGED_MAN,
            Card.CARD_SOUL_MAGDALENE,
            Card.CARD_SOUL_BLUEBABY,
            Card.CARD_SOUL_SAMSON,
            Card.CARD_SOUL_JACOB,
        },
        pill = {
            PillEffect.PILLEFFECT_BAD_TRIP,
            PillEffect.PILLEFFECT_AMNESIA,
            PillEffect.PILLEFFECT_SMALLER,
            PillEffect.PILLEFFECT_EXPLOSIVE_DIARRHEA,
            PillEffect.PILLEFFECT_HORF,
            PillEffect.PILLEFFECT_IM_EXCITED,
            PillEffect.PILLEFFECT_RETRO_VISION,
            PillEffect.PILLEFFECT_SPEED_DOWN,
        }
    },
    -- 노말, 하드 밴 목록
    original = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    -- 그리드, 그리디어 밴 목록
    greed = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_ISAAC] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_MAGDALENE] = {
        collectible = {
            CollectibleType.COLLECTIBLE_BIRTHRIGHT,
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_CAIN] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_JUDAS] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_BLUEBABY] = {
        collectible = {
            CollectibleType.COLLECTIBLE_BIRTHRIGHT,
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_EVE] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_SAMSON] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_AZAZEL] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LAZARUS] = {
        collectible = {
            CollectibleType.COLLECTIBLE_COMPASS,
            CollectibleType.COLLECTIBLE_TREASURE_MAP,
            CollectibleType.COLLECTIBLE_MIND,
            CollectibleType.COLLECTIBLE_BLUE_MAP,
            CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
            CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
            AstroItems.Collectible.DUALITY_LIGHT_AND_DARKNESS,

        },
        trinket = {
            TrinketType.TRINKET_CAINS_EYE,
            TrinketType.TRINKET_FRAGMENTED_CARD,
            AstroItems.Trinket.MOSIS_EYES,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_EDEN] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THELOST] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            CollectibleType.COLLECTIBLE_LOST_CONTACT,
            CollectibleType.COLLECTIBLE_PSY_FLY,
            CollectibleType.COLLECTIBLE_DAMOCLES,
            CollectibleType.COLLECTIBLE_TOUGH_LOVE,
            CollectibleType.COLLECTIBLE_APPLE,
            CollectibleType.COLLECTIBLE_GHOST_PEPPER,
            CollectibleType.COLLECTIBLE_D6,
            CollectibleType.COLLECTIBLE_STARTER_DECK,
            CollectibleType.COLLECTIBLE_SOUL,
            CollectibleType.COLLECTIBLE_HEARTBREAK,
            AstroItems.Collectible.ARIES_EX,
        },
        trinket = {
            TrinketType.TRINKET_BROKEN_ANKH,
            TrinketType.TRINKET_JAW_BREAKER,
            TrinketType.TRINKET_SIGIL_OF_BAPHOMET,
        },
        card = {
            Card.CARD_HOLY,
            Card.CARD_ERA_WALK,
            Card.CARD_REVERSE_MAGICIAN,
            Card.CARD_SOUL_LAZARUS,
            Card.CARD_SOUL_LOST,
            Card.RUNE_ALGIZ,
            Card.CARD_CHAOS,
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LAZARUS2] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_BLACKJUDAS] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LILITH] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_KEEPER] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_APOLLYON] = {
        collectible = {
            CollectibleType.COLLECTIBLE_MEGA_MUSH,
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THEFORGOTTEN] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THESOUL] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_BETHANY] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            CollectibleType.COLLECTIBLE_HOLY_MANTLE,
            CollectibleType.COLLECTIBLE_BIRTHRIGHT,
            AstroItems.Collectible.ALTAIR,
            AstroItems.Collectible.COMET,
            AstroItems.Collectible.ARIES_EX,
            AstroItems.Collectible.WARD,
            AstroItems.Collectible.PINK_WARD,
        },
        trinket = {
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_JACOB] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            CollectibleType.COLLECTIBLE_SCHOOLBAG,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_ESAU] = {
        collectible = {
            CollectibleType.COLLECTIBLE_SCHOOLBAG,
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_ISAAC_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_MAGDALENE_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_CAIN_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_JUDAS_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_BLUEBABY_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_EVE_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_SAMSON_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_AZAZEL_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LAZARUS_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_EDEN_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_MISSING_NO,
            CollectibleType.COLLECTIBLE_TMTRAINER,
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THELOST_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_DAMOCLES,
            CollectibleType.COLLECTIBLE_STARTER_DECK,
            CollectibleType.COLLECTIBLE_HEARTBREAK,
            CollectibleType.COLLECTIBLE_BLANK_CARD,
        },
        trinket = {
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LILITH_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_KEEPER_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_GREEDS_GULLET,
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_APOLLYON_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_HIVE_MIND,
            CollectibleType.COLLECTIBLE_BFFS,
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THEFORGOTTEN_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_BETHANY_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_JACOB_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_LAZARUS2_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_JACOB2_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_ANKH,
            CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
            CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
            AstroItems.Collectible.ALTAIR,
        },
        trinket = {
            TrinketType.TRINKET_MISSING_POSTER,
            TrinketType.TRINKET_BROKEN_ANKH,
        },
        card = {
        },
        pill = {
        }
    },
    [PlayerType.PLAYER_THESOUL_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [AstroItems.Players.LEAH] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [AstroItems.Players.DIABELLSTAR] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [AstroItems.Players.DIABELLSTAR_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [AstroItems.Players.WATER_ENCHANTRESS] = {
        collectible = {
            CollectibleType.COLLECTIBLE_CAR_BATTERY,
            CollectibleType.COLLECTIBLE_SOL,
        },
        trinket = {
        },
        card = {
        },
        pill = {
            PillEffect.PILLEFFECT_48HOUR_ENERGY,
        }
    },
    [AstroItems.Players.WATER_ENCHANTRESS_B] = {
        collectible = {
            CollectibleType.COLLECTIBLE_CAR_BATTERY,
            CollectibleType.COLLECTIBLE_SOL,
        },
        trinket = {
        },
        card = {
        },
        pill = {
            PillEffect.PILLEFFECT_48HOUR_ENERGY,
        }
    },
    [AstroItems.Players.DAVID_MARTINEZ] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [AstroItems.Players.DAVID_MARTINEZ_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
}

local function GetBanTables()
    local banTables = { banItems.common }

    if Game():IsGreedMode() then
        table.insert(banTables, banItems.greed)
    else
        table.insert(banTables, banItems.original)
    end

    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        local playerType = player:GetPlayerType()

        table.insert(banTables, banItems[playerType])
    end

    return banTables
end

local banAnimationList = {}

local function CreateBanAnimationSprite()
    local banAnimationSprite = Sprite()
    banAnimationSprite:Load("gfx/ban_collectible.anm2", true)
    banAnimationSprite:Play("Idle", true)
    banAnimationSprite:SetLastFrame()

    return banAnimationSprite
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            local itemPool = Game():GetItemPool()

            for _, banTable in ipairs(GetBanTables()) do
                if banTable == nil then
                    break
                end

                for _, value in ipairs(banTable.collectible) do
                    itemPool:RemoveCollectible(value)
                end

                for _, value in ipairs(banTable.trinket) do
                    itemPool:RemoveTrinket(value)
                end
            end

            banAnimationList = {}

            if Astro.Data.NextBanItems == nil then
                Astro.Data.NextBanItems = {}
            end

            for _, value in ipairs(Astro.Data.NextBanItems) do
                table.insert(banAnimationList, { value, CreateBanAnimationSprite(), 0 })
            end

            Astro.Data.NextBanItems = {}
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for _, value in ipairs(banAnimationList) do
            local banAnimationSprite = value[2]

            if not banAnimationSprite:IsFinished("Idle") then
                banAnimationSprite:Update()
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        local level = Game():GetLevel()

        if level:GetAbsoluteStage() ~= LevelStage.STAGE4_3 and level:GetCurrentRoomIndex() == 84 and Game():GetFrameCount() > 15 then
            for i, value in ipairs(banAnimationList) do
                local collectible = value[1]
                local banAnimationSprite = value[2]

                local xOffset = (i - 0.5 - #banAnimationList / 2) * 50

                if banAnimationSprite:IsFinished("Idle") then
                    if #banAnimationList >= 1 then
                        local config = Isaac.GetItemConfig():GetCollectible(collectible)
        
                        Game():GetItemPool():RemoveCollectible(collectible)
        
                        banAnimationSprite:Play("Idle", true)
                        banAnimationSprite:ReplaceSpritesheet(0, config.GfxFileName)
                        banAnimationSprite:LoadGraphics()
                        banAnimationSprite:Render(Isaac.WorldToRenderPosition(Isaac.GetPlayer().Position + Vector(xOffset, -60)), Vector(0, 0), Vector(0, 0))
                    end
                else
                    banAnimationSprite:Render(Isaac.WorldToRenderPosition(Isaac.GetPlayer().Position + Vector(xOffset, -60)), Vector(0, 0), Vector(0, 0))
                end
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        -- 밴 목록에는 있지만 밴 적용 목록에 없는 경우 추가
        if Astro:ContainCollectible(nextRunBanItems, collectibleType) and not Astro:ContainCollectible(Astro.Data.NextBanItems, collectibleType) then
            table.insert(Astro.Data.NextBanItems, collectibleType)
        end
    end
)

--- @param card Card
function Astro:IsCardBlacklisted(card)
    for _, banTable in ipairs(GetBanTables()) do
        for _, value in ipairs(banTable.card) do
            if card == value then
                return true
            end
        end
    end

    return false
end

--- @param pillEffect PillEffect
function Astro:IsPillBlacklisted(pillEffect)
    for _, banTable in ipairs(GetBanTables()) do
        for _, value in ipairs(banTable.pill) do
            if pillEffect == value then
                return true
            end
        end
    end

    return false
end

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_PILL then
            local pillEffect = Game():GetItemPool():GetPillEffect(pickup.SubType)

            if Astro:IsPillBlacklisted(pillEffect) then
                local newPill = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, PillColor.PILL_NULL, pickup.Position, pickup.Velocity, pickup.SpawnerEntity):ToPickup()
                newPill.Price = pickup.Price

                pickup:Remove()
            end
        end
    end
)

--- Credit to Xalum(Retribution)
local recursing
local rng
local function initialiseCardRNG()
    if Astro.Data.cardRngSeed ~= Game():GetSeeds():GetStartSeed() then
        Astro.Data.cardRngSeed = Astro.Data.cardRngSeed or Game():GetSeeds():GetStartSeed()
        rng = RNG()
        rng:SetSeed(Astro.Data.cardRngSeed, 35)
    elseif not rng then
        rng = RNG()
        rng:SetSeed(Astro.Data.cardRngSeed, 35)
    end
end

--- Credit to Xalum(Retribution)
Astro:AddCallback(
    ModCallbacks.MC_GET_CARD,
    function(_, _, card, canSuit, canRune, forceRune)
        initialiseCardRNG()

        if Astro:IsCardBlacklisted(card) and not recursing then
            recursing = true

            local itempool = Game():GetItemPool()
            local new

            for i = 1, 32 do
                new = itempool:GetCard(rng:Next(), canSuit, canRune, forceRune)

                if not Astro:IsCardBlacklisted(new) then
                    break
                end
            end

            recursing = false

            return new
        end
    end
)

---@param player EntityPlayer
---@param cardID Card
---@param slotId integer
local function WasteCard(player, cardID, slotId)
	player:SetCard(slotId, 0)
	player:UseCard(cardID)
end

---@param player EntityPlayer
function Astro:AutoWasting(player)
	if player:GetCard(0) == Card.RUNE_ANSUZ then
		WasteCard(player, Card.RUNE_ANSUZ, 0)
	elseif player:GetCard(0) == Card.CARD_WORLD then
		WasteCard(player, Card.CARD_WORLD, 0)
	elseif player:GetCard(0) == Card.CARD_SUN then
		WasteCard(player, Card.CARD_SUN, 0)
	elseif player:GetCard(0) == Card.CARD_JUSTICE then
		WasteCard(player, Card.CARD_JUSTICE, 0)
	elseif player:GetCard(0) == Card.CARD_HIEROPHANT then
		WasteCard(player, Card.CARD_HIEROPHANT, 0)
	elseif player:GetCard(0) == Card.CARD_REVERSE_HIEROPHANT then
		WasteCard(player, Card.CARD_REVERSE_HIEROPHANT, 0)
	elseif player:GetCard(0) == Card.CARD_RULES then
		WasteCard(player, Card.CARD_RULES, 0)
	elseif player:GetCard(0) == Card.CARD_ANCIENT_RECALL then
		WasteCard(player, Card.CARD_ANCIENT_RECALL, 0)
	elseif player:GetCard(0) == Card.CARD_REVERSE_MAGICIAN then
		WasteCard(player, Card.CARD_REVERSE_MAGICIAN, 0)
	elseif player:GetCard(0) == Card.RUNE_BERKANO then
		WasteCard(player, Card.RUNE_BERKANO, 0)
	elseif player:GetCard(0) == Astro.Card.ETERNITY then
		WasteCard(player, Astro.Card.ETERNITY, 0)
	elseif player:GetCard(0) == Card.CARD_HOLY and player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
		player:SetCard(0, 0) -- 획득 시 삭제
	else
		local pillColor = player:GetPill(0)

		if pillColor then
			local itemPool = Game():GetItemPool()
			local pillEffect = itemPool:GetPillEffect(pillColor)

			if pillEffect == PillEffect.PILLEFFECT_BALLS_OF_STEEL then
				player:SetPill(0, PillColor.PILL_NULL)
				player:UsePill(PillEffect.PILLEFFECT_BALLS_OF_STEEL, pillColor)
			end
		end
	end
end

Astro:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Astro.AutoWasting)
