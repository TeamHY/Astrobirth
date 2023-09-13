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
            self.BanTrinket(TrinketType.TRINKET_BROKEN_REMOTE)
            self.BanTrinket(TrinketType.TRINKET_CARTRIDGE)
            self.BanTrinket(TrinketType.TRINKET_MOMS_TOENAIL)
            self.BanTrinket(TrinketType.TRINKET_MYSTERIOUS_PAPER)
            self.BanTrinket(TrinketType.TRINKET_ERROR)
            self.BanTrinket(TrinketType.TRINKET_FILIGREE_FEATHERS)
            self.BanTrinket(TrinketType.TRINKET_RC_REMOTE)
            self.BanTrinket(TrinketType.TRINKET_EXPANSION_PACK)
            self.BanTrinket(TrinketType.TRINKET_FOUND_SOUL)
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
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LOST_CONTACT)
            self.BanCollectible(CollectibleType.COLLECTIBLE_PSY_FLY)
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
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_APOLLYON] = function()
        end,
        [PlayerType.PLAYER_THEFORGOTTEN] = function()
        end,
        [PlayerType.PLAYER_THESOUL] = function()
        end,
        [PlayerType.PLAYER_BETHANY] = function()
            self.BanCollectible(Astro.Collectible.COMET)
        end,
        [PlayerType.PLAYER_JACOB] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_ESAU] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
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
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_EDEN_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_MISSING_NO)
            self.BanCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        end,
        [PlayerType.PLAYER_THELOST_B] = function()
        end,
        [PlayerType.PLAYER_LILITH_B] = function()
        end,
        [PlayerType.PLAYER_KEEPER_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_GREEDS_GULLET)
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_APOLLYON_B] = function()
        end,
        [PlayerType.PLAYER_THEFORGOTTEN_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_BETHANY_B] = function()
        end,
        [PlayerType.PLAYER_JACOB_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_LAZARUS2_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
        end,
        [PlayerType.PLAYER_JACOB2_B] = function()
            self.BanCollectible(CollectibleType.COLLECTIBLE_ANKH)
            self.BanCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS)
            self.BanCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW)
            self.BanTrinket(TrinketType.TRINKET_MISSING_POSTER)
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

-- Ban Room Type

local tryCount = 0
local LIMIT = 100

Astro:AddPriorityCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    CallbackPriority.IMPORTANT,
    function(_, isContinued)
        tryCount = 0
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function(_)
        local hasMissingNo = false

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_NO) then
                hasMissingNo = true
            end
        end

        if tryCount < LIMIT and not hasMissingNo then
            local level = Game():GetLevel()
            local isaacsRoom = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_ISAACS, false, RNG()))
            local barrenRoom = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_BARREN, false, RNG()))
            local sacrificeRoom = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_SACRIFICE, false, RNG()))

            -- 막달레나일 경우 케이스 추가
            -- TODO: 더 추가될 경우 보기 쉽게 변경해야 함
            if
                isaacsRoom.Data.Type == RoomType.ROOM_ISAACS or barrenRoom.Data.Type == RoomType.ROOM_BARREN or
                (sacrificeRoom.Data.Type ~= RoomType.ROOM_SACRIFICE and Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_MAGDALENE and level:GetStage() == LevelStage.STAGE1_1 and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH)
             then
                tryCount = tryCount + 1
                Isaac.ExecuteCommand("reseed")
                Isaac.DebugString("Run reseed: " .. tryCount)
            end
        end
    end
)
