local isc = require("astro.lib.isaacscript-common")

local nextRunBanItems = {
    CollectibleType.COLLECTIBLE_SACRED_HEART,
    CollectibleType.COLLECTIBLE_GODHEAD,
    CollectibleType.COLLECTIBLE_SOL,
    CollectibleType.COLLECTIBLE_C_SECTION,
    CollectibleType.COLLECTIBLE_GOAT_HEAD,
    CollectibleType.COLLECTIBLE_DAMOCLES,
    CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
    CollectibleType.COLLECTIBLE_SACRED_ORB,
    CollectibleType.COLLECTIBLE_COMPASS,
    CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
    CollectibleType.COLLECTIBLE_PSY_FLY,
    CollectibleType.COLLECTIBLE_TREASURE_MAP,
    CollectibleType.COLLECTIBLE_MIND,
    CollectibleType.COLLECTIBLE_DEAD_CAT,
    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
    CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
    CollectibleType.COLLECTIBLE_LACHRYPHAGY,
    Astro.Collectible.TECHNOLOGY_OMICRON,
    Astro.Collectible.AMAZING_CHAOS_SCROLL,
    Astro.Collectible.ARIES_EX,
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
            Astro.Collectible.REINCARNATION,
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
            Astro.Collectible.DUALITY_LIGHT_AND_DARKNESS,

        },
        trinket = {
            TrinketType.TRINKET_CAINS_EYE,
            TrinketType.TRINKET_FRAGMENTED_CARD,
            Astro.Trinket.MOSIS_EYES,
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
            Astro.Collectible.ARIES_EX,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
            Astro.Collectible.COMET,
            Astro.Collectible.ARIES_EX,
            Astro.Collectible.WARD,
            Astro.Collectible.PINK_WARD,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
            Astro.Collectible.ALTAIR,
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
    [Astro.Players.LEAH] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [Astro.Players.DIABELLSTAR] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [Astro.Players.DIABELLSTAR_B] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [Astro.Players.WATER_ENCHANTRESS] = {
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
    [Astro.Players.DAVID_MARTINEZ] = {
        collectible = {
        },
        trinket = {
        },
        card = {
        },
        pill = {
        }
    },
    [Astro.Players.DAVID_MARTINEZ_B] = {
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

    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        local playerType = player:GetPlayerType()

        table.insert(banTables, banItems[playerType])
    end

    return banTables
end

local banAnimationList = {}

local banAnimationSprite = Sprite()
banAnimationSprite:Load("gfx/ban_collectible.anm2", true)
banAnimationSprite:Play("Idle", true)
banAnimationSprite:SetLastFrame()

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

            banAnimationList = Astro.Data.NextBanItems or {}
            Astro.Data.NextBanItems = {}
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        if not banAnimationSprite:IsFinished("Idle") then
            banAnimationSprite:Update()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        if level:GetAbsoluteStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == 84 and currentRoom:IsFirstVisit() and Game():GetFrameCount() > 15 then
            if banAnimationSprite:IsFinished("Idle") then
                if #banAnimationList >= 1 then
                    local collectible = table.remove(banAnimationList, 1)
                    local config = Isaac.GetItemConfig():GetCollectible(collectible)
    
                    Game():GetItemPool():RemoveCollectible(collectible)
    
                    banAnimationSprite:Play("Idle", true)
                    banAnimationSprite:ReplaceSpritesheet(0, config.GfxFileName)
                    banAnimationSprite:LoadGraphics()
                    banAnimationSprite:Render(Isaac.WorldToRenderPosition(Isaac.GetPlayer().Position + Vector(0, -60)), Vector(0, 0), Vector(0, 0))
    
                    table.insert(banAnimationList, collectible)
                end
            else
                banAnimationSprite:Render(Isaac.WorldToRenderPosition(Isaac.GetPlayer().Position + Vector(0, -60)), Vector(0, 0), Vector(0, 0))
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PLAYER_COLLECTIBLE_ADDED,
    ---@param player EntityPlayer
    ---@param collectibleType CollectibleType
    function(_, player, collectibleType)
        if Astro:ContainCollectible(nextRunBanItems, collectibleType) then
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
