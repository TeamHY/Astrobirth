Redrawn.BanManager = {}

local BanManager = Redrawn.BanManager

function BanManager:Init()
    local banTable = {
        all = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_SAD_ONION)
            self.BanTrinket(TrinketType.TRINKET_BROKEN_REMOTE)
            self.BanTrinket(TrinketType.TRINKET_CARTRIDGE)
            self.BanTrinket(TrinketType.TRINKET_MOMS_TOENAIL)
            self.BanTrinket(TrinketType.TRINKET_MYSTERIOUS_PAPER)
            self.BanTrinket(TrinketType.TRINKET_ERROR)
        end,
        [PlayerType.PLAYER_ISAAC] = function()
        end,
        [PlayerType.PLAYER_MAGDALENE] = function()
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
        end,
        [PlayerType.PLAYER_LAZARUS2] = function()
        end,
        [PlayerType.PLAYER_BLACKJUDAS] = function()
        end,
        [PlayerType.PLAYER_LILITH] = function()
        end,
        [PlayerType.PLAYER_KEEPER] = function()
        end,
        [PlayerType.PLAYER_APOLLYON] = function()
        end,
        [PlayerType.PLAYER_THEFORGOTTEN] = function()
        end,
        [PlayerType.PLAYER_THESOUL] = function()
        end,
        [PlayerType.PLAYER_BETHANY] = function()
        end,
        [PlayerType.PLAYER_JACOB] = function()
        end,
        [PlayerType.PLAYER_ESAU] = function()
        end,
        [PlayerType.PLAYER_ISAAC_B] = function()
        end,
        [PlayerType.PLAYER_MAGDALENE_B] = function()
        end,
        [PlayerType.PLAYER_CAIN_B] = function()
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
        end,
        [PlayerType.PLAYER_EDEN_B] = function()
        end,
        [PlayerType.PLAYER_THELOST_B] = function()
        end,
        [PlayerType.PLAYER_LILITH_B] = function()
        end,
        [PlayerType.PLAYER_KEEPER_B] = function()
        end,
        [PlayerType.PLAYER_APOLLYON_B] = function()
        end,
        [PlayerType.PLAYER_THEFORGOTTEN_B] = function()
        end,
        [PlayerType.PLAYER_BETHANY_B] = function()
        end,
        [PlayerType.PLAYER_JACOB_B] = function()
        end,
        [PlayerType.PLAYER_LAZARUS2_B] = function()
        end,
        [PlayerType.PLAYER_JACOB2_B] = function()
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
function BanManager.BanCollectible(itemId)
    Game():GetItemPool():RemoveCollectible(itemId)
end

---comment
---@param itemId TrinketType | number
function BanManager.BanTrinket(itemId)
    Game():GetItemPool():RemoveTrinket(itemId)
end

function BanManager:OnPostGameStarted(newstart)
    BanManager:Init()
end

Redrawn:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BanManager.OnPostGameStarted)
