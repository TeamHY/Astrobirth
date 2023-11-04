Astro.Ban = {}

local Ban = Astro.Ban

function Ban:Init()
    local banTable = {
        all = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_DADS_NOTE)
            self.BanCollectible(CollectibleType.COLLECTIBLE_CANCER)
            self.BanCollectible(CollectibleType.COLLECTIBLE_FRIEND_FINDER)
            self.BanCollectible(CollectibleType.COLLECTIBLE_SPIN_TO_WIN)
            self.BanCollectible(CollectibleType.COLLECTIBLE_MEGA_BEAN)
            self.BanCollectible(CollectibleType.COLLECTIBLE_MOMS_PURSE)
            self.BanCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_1)
            self.BanCollectible(CollectibleType.COLLECTIBLE_KNIFE_PIECE_2)
            self.BanCollectible(CollectibleType.COLLECTIBLE_CLICKER)
            self.BanCollectible(CollectibleType.COLLECTIBLE_D100)
            self.BanCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_PARASITE)
            self.BanCollectible(CollectibleType.COLLECTIBLE_MARS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_GLITCHED_CROWN)
            self.BanCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_REMOTE)
            self.BanTrinket(TrinketType.TRINKET_CARTRIDGE)
            self.BanTrinket(TrinketType.TRINKET_MOMS_TOENAIL)
            self.BanTrinket(TrinketType.TRINKET_MYSTERIOUS_PAPER)
            self.BanTrinket(TrinketType.TRINKET_ERROR)
            self.BanTrinket(TrinketType.TRINKET_FILIGREE_FEATHERS)
            self.BanTrinket(TrinketType.TRINKET_RC_REMOTE)
            self.BanTrinket(TrinketType.TRINKET_EXPANSION_PACK)
            self.BanTrinket(TrinketType.TRINKET_FOUND_SOUL)
            self.BanTrinket(TrinketType.TRINKET_MYOSOTIS)
            self.BanTrinket(TrinketType.TRINKET_HOLLOW_HEART)
        end,
        [PlayerType.PLAYER_ISAAC] = function()
        end,
        [PlayerType.PLAYER_MAGDALENE] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        end,
        [PlayerType.PLAYER_CAIN] = function()
        end,
        [PlayerType.PLAYER_JUDAS] = function()
        end,
        [PlayerType.PLAYER_BLUEBABY] = function()
        end,
        [PlayerType.PLAYER_EVE] = function()
        end,
        [PlayerType.PLAYER_SAMSON] = function()
        end,
        [PlayerType.PLAYER_AZAZEL] = function()
        end,
        [PlayerType.PLAYER_LAZARUS] = function()
        end,
        [PlayerType.PLAYER_EDEN] = function()
        end,
        [PlayerType.PLAYER_THELOST] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT)
            self.BanCollectible(CollectibleType.COLLECTIBLE_PSY_FLY)
            self.BanCollectible(CollectibleType.COLLECTIBLE_DAMOCLES)
            self.BanCollectible(CollectibleType.COLLECTIBLE_TOUGH_LOVE)
            self.BanCollectible(CollectibleType.COLLECTIBLE_APPLE)
            self.BanCollectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_LAZARUS2] = function()
        end,
        [PlayerType.PLAYER_BLACKJUDAS] = function()
        end,
        [PlayerType.PLAYER_LILITH] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_TWISTED_PAIR)
        end,
        [PlayerType.PLAYER_KEEPER] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_GREEDS_GULLET)
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_APOLLYON] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_MEGA_MUSH)
        end,
        [PlayerType.PLAYER_THEFORGOTTEN] = function()
        end,
        [PlayerType.PLAYER_THESOUL] = function()
        end,
        [PlayerType.PLAYER_BETHANY] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanCollectible(Astro.Collectible.COMET)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_JACOB] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_ESAU] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_ISAAC_B] = function()
        end,
        [PlayerType.PLAYER_MAGDALENE_B] = function()
        end,
        [PlayerType.PLAYER_CAIN_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_JUDAS_B] = function()
        end,
        [PlayerType.PLAYER_BLUEBABY_B] = function()
        end,
        [PlayerType.PLAYER_EVE_B] = function()
        end,
        [PlayerType.PLAYER_SAMSON_B] = function()
        end,
        [PlayerType.PLAYER_AZAZEL_B] = function()
        end,
        [PlayerType.PLAYER_LAZARUS_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_EDEN_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_MISSING_NO)
            self.BanCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        end,
        [PlayerType.PLAYER_THELOST_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_DAMOCLES)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_LILITH_B] = function()
        end,
        [PlayerType.PLAYER_KEEPER_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_GREEDS_GULLET)
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_APOLLYON_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
            self.BanCollectible(CollectibleType.COLLECTIBLE_BFFS)
        end,
        [PlayerType.PLAYER_THEFORGOTTEN_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_BETHANY_B] = function()
        end,
        [PlayerType.PLAYER_JACOB_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_LAZARUS2_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_JACOB2_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(Astro.Collectible.ALTAIR)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_ANKH)
        end,
        [PlayerType.PLAYER_THESOUL_B] = function()
        end
    }

    local player = Isaac.GetPlayer(0)

    banTable["all"]()
    banTable[player:GetPlayerType()]()
end

---comment
---@param itemId CollectibleType | number
function Ban.BanCollectible(itemId)
    Game():GetItemPool():RemoveCollectible(itemId)
end

---comment
---@param itemId TrinketType | number
function Ban.BanTrinket(itemId)
    Game():GetItemPool():RemoveTrinket(itemId)
end

function Ban:OnPostGameStarted(newstart)
    Ban:Init()
end

Astro:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Ban.OnPostGameStarted)

Astro:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT,
    ---@param selectedPillEffect PillEffect
    ---@param pillColor PillColor
    function(_, selectedPillEffect, pillColor)
        if selectedPillEffect == PillEffect.PILLEFFECT_SMALLER or selectedPillEffect == PillEffect.PILLEFFECT_AMNESIA or selectedPillEffect == PillEffect.PILLEFFECT_BAD_TRIP then
            return PillEffect.PILLEFFECT_GULP
        end
    end
)
