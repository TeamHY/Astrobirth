local isc = require("astro.lib.isaacscript-common")

Astro.Trinket.NOSTALGIA = Isaac.GetTrinketIdByName("Nostalgia")

if EID then
    EID:addTrinket(Astro.Trinket.NOSTALGIA, "#소지한 상태에서 {{BossRoom}}보스방 클리어 시 The Binding of Isaac: Wrath of the Lamb에서 등장한 아이템 2개를 소환합니다.#!!! 획득 시 바로 흡수됩니다.#!!! 효과가 발동한 뒤 사라집니다.", "노스텔지아")
end

-- The Sad Onion(c1) ~ Box(c198)까지 포함되어 있습니다. 누락된 아이템이 있을 수 있습니다.
local wolItemList = {
	CollectibleType.COLLECTIBLE_SAD_ONION,
	CollectibleType.COLLECTIBLE_INNER_EYE,
	CollectibleType.COLLECTIBLE_SPOON_BENDER,
	CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
	CollectibleType.COLLECTIBLE_MY_REFLECTION,
	CollectibleType.COLLECTIBLE_NUMBER_ONE,
	CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR,
	CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
	CollectibleType.COLLECTIBLE_SKATOLE,
	CollectibleType.COLLECTIBLE_HALO_OF_FLIES,
	CollectibleType.COLLECTIBLE_1UP,
	CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
	CollectibleType.COLLECTIBLE_VIRUS,
	CollectibleType.COLLECTIBLE_ROID_RAGE,
	CollectibleType.COLLECTIBLE_HEART,
	CollectibleType.COLLECTIBLE_RAW_LIVER,
	CollectibleType.COLLECTIBLE_SKELETON_KEY,
	CollectibleType.COLLECTIBLE_DOLLAR,
	CollectibleType.COLLECTIBLE_BOOM,
	CollectibleType.COLLECTIBLE_TRANSCENDENCE,
	CollectibleType.COLLECTIBLE_COMPASS,
	CollectibleType.COLLECTIBLE_LUNCH,
	CollectibleType.COLLECTIBLE_DINNER,
	CollectibleType.COLLECTIBLE_DESSERT,
	CollectibleType.COLLECTIBLE_BREAKFAST,
	CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
	CollectibleType.COLLECTIBLE_WOODEN_SPOON,
	CollectibleType.COLLECTIBLE_BELT,
	CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
	CollectibleType.COLLECTIBLE_MOMS_HEELS,
	CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
	CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER,
	CollectibleType.COLLECTIBLE_BIBLE,
	CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
	CollectibleType.COLLECTIBLE_NECRONOMICON,
	CollectibleType.COLLECTIBLE_POOP,
	CollectibleType.COLLECTIBLE_MR_BOOM,
	CollectibleType.COLLECTIBLE_TAMMYS_HEAD,
	CollectibleType.COLLECTIBLE_MOMS_BRA,
	CollectibleType.COLLECTIBLE_KAMIKAZE,
	CollectibleType.COLLECTIBLE_MOMS_PAD,
	CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
	-- 43
	CollectibleType.COLLECTIBLE_TELEPORT,
	CollectibleType.COLLECTIBLE_YUM_HEART,
	CollectibleType.COLLECTIBLE_LUCKY_FOOT,
	CollectibleType.COLLECTIBLE_DOCTORS_REMOTE,
	CollectibleType.COLLECTIBLE_CUPIDS_ARROW,
	CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP,
	CollectibleType.COLLECTIBLE_STEVEN,
	CollectibleType.COLLECTIBLE_PENTAGRAM,
	CollectibleType.COLLECTIBLE_DR_FETUS,
	CollectibleType.COLLECTIBLE_MAGNETO,
	CollectibleType.COLLECTIBLE_TREASURE_MAP,
	CollectibleType.COLLECTIBLE_MOMS_EYE,
	CollectibleType.COLLECTIBLE_LEMON_MISHAP,
	CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION,
	CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
	CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE,
	CollectibleType.COLLECTIBLE_LADDER,
	-- 61
	CollectibleType.COLLECTIBLE_CHARM_VAMPIRE,
	CollectibleType.COLLECTIBLE_BATTERY,
	CollectibleType.COLLECTIBLE_STEAM_SALE,
	CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK,
	CollectibleType.COLLECTIBLE_HOURGLASS,
	CollectibleType.COLLECTIBLE_SISTER_MAGGY,
	CollectibleType.COLLECTIBLE_TECHNOLOGY,
	CollectibleType.COLLECTIBLE_CHOCOLATE_MILK,
	CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
	CollectibleType.COLLECTIBLE_MINI_MUSH,
	CollectibleType.COLLECTIBLE_ROSARY,
	CollectibleType.COLLECTIBLE_CUBE_OF_MEAT,
	CollectibleType.COLLECTIBLE_QUARTER,
	CollectibleType.COLLECTIBLE_PHD,
	CollectibleType.COLLECTIBLE_XRAY_VISION,
	CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN,
	CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS,
	CollectibleType.COLLECTIBLE_MARK,
	CollectibleType.COLLECTIBLE_PACT,
	CollectibleType.COLLECTIBLE_DEAD_CAT,
	CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT,
	CollectibleType.COLLECTIBLE_THE_NAIL,
	CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,
	CollectibleType.COLLECTIBLE_DECK_OF_CARDS,
	CollectibleType.COLLECTIBLE_MONSTROS_TOOTH,
	CollectibleType.COLLECTIBLE_LOKIS_HORNS,
	CollectibleType.COLLECTIBLE_LITTLE_CHUBBY,
	CollectibleType.COLLECTIBLE_SPIDER_BITE,
	CollectibleType.COLLECTIBLE_SMALL_ROCK,
	CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
	CollectibleType.COLLECTIBLE_SUPER_BANDAGE,
	CollectibleType.COLLECTIBLE_GAMEKID,
	CollectibleType.COLLECTIBLE_SACK_OF_PENNIES,
	CollectibleType.COLLECTIBLE_ROBO_BABY,
	CollectibleType.COLLECTIBLE_LITTLE_CHAD,
	CollectibleType.COLLECTIBLE_BOOK_OF_SIN,
	CollectibleType.COLLECTIBLE_RELIC,
	CollectibleType.COLLECTIBLE_LITTLE_GISH,
	CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
	CollectibleType.COLLECTIBLE_HALO,
	CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS,
	CollectibleType.COLLECTIBLE_COMMON_COLD,
	CollectibleType.COLLECTIBLE_PARASITE,
	CollectibleType.COLLECTIBLE_D6,
	CollectibleType.COLLECTIBLE_MR_MEGA,
	CollectibleType.COLLECTIBLE_PINKING_SHEARS,
	CollectibleType.COLLECTIBLE_WAFER,
	CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER,
	CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
	CollectibleType.COLLECTIBLE_BEAN,
	CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
	CollectibleType.COLLECTIBLE_DEMON_BABY,
	CollectibleType.COLLECTIBLE_MOMS_KNIFE,
	CollectibleType.COLLECTIBLE_OUIJA_BOARD,
	CollectibleType.COLLECTIBLE_9_VOLT,
	CollectibleType.COLLECTIBLE_DEAD_BIRD,
	CollectibleType.COLLECTIBLE_BRIMSTONE,
	CollectibleType.COLLECTIBLE_BLOOD_BAG,
	CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
	CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
	CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON,
	CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
	CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS,
	CollectibleType.COLLECTIBLE_BOBBY_BOMB,
	CollectibleType.COLLECTIBLE_RAZOR_BLADE,
	CollectibleType.COLLECTIBLE_FORGET_ME_NOW,
	CollectibleType.COLLECTIBLE_FOREVER_ALONE,
	CollectibleType.COLLECTIBLE_BUCKET_OF_LARD,
	CollectibleType.COLLECTIBLE_PONY,
	CollectibleType.COLLECTIBLE_BOMB_BAG,
	CollectibleType.COLLECTIBLE_LUMP_OF_COAL,
	CollectibleType.COLLECTIBLE_GUPPYS_PAW,
	CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
	CollectibleType.COLLECTIBLE_IV_BAG,
	CollectibleType.COLLECTIBLE_BEST_FRIEND,
	CollectibleType.COLLECTIBLE_REMOTE_DETONATOR,
	CollectibleType.COLLECTIBLE_STIGMATA,
	CollectibleType.COLLECTIBLE_MOMS_PURSE,
	CollectibleType.COLLECTIBLE_BOBS_CURSE,
	CollectibleType.COLLECTIBLE_PAGEANT_BOY,
	CollectibleType.COLLECTIBLE_SCAPULAR,
	CollectibleType.COLLECTIBLE_SPEED_BALL,
	CollectibleType.COLLECTIBLE_BUM_FRIEND,
	CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
	CollectibleType.COLLECTIBLE_PRAYER_CARD,
	CollectibleType.COLLECTIBLE_NOTCHED_AXE,
	CollectibleType.COLLECTIBLE_INFESTATION,
	CollectibleType.COLLECTIBLE_IPECAC,
	CollectibleType.COLLECTIBLE_TOUGH_LOVE,
	CollectibleType.COLLECTIBLE_MULLIGAN,
	CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
	CollectibleType.COLLECTIBLE_MUTANT_SPIDER,
	CollectibleType.COLLECTIBLE_CHEMICAL_PEEL,
	CollectibleType.COLLECTIBLE_PEEPER,
	CollectibleType.COLLECTIBLE_HABIT,
	CollectibleType.COLLECTIBLE_BLOODY_LUST,
	CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
	CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT,
	CollectibleType.COLLECTIBLE_CRACK_THE_SKY,
	CollectibleType.COLLECTIBLE_ANKH,
	CollectibleType.COLLECTIBLE_CELTIC_CROSS,
	CollectibleType.COLLECTIBLE_GHOST_BABY,
	CollectibleType.COLLECTIBLE_CANDLE,
	CollectibleType.COLLECTIBLE_CAT_O_NINE_TAILS,
	CollectibleType.COLLECTIBLE_D20,
	CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
	CollectibleType.COLLECTIBLE_EPIC_FETUS,
	CollectibleType.COLLECTIBLE_POLYPHEMUS,
	CollectibleType.COLLECTIBLE_DADDY_LONGLEGS,
	CollectibleType.COLLECTIBLE_SPIDER_BUTT,
	CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER,
	CollectibleType.COLLECTIBLE_MITRE,
	CollectibleType.COLLECTIBLE_RAINBOW_BABY,
	CollectibleType.COLLECTIBLE_DADS_KEY,
	CollectibleType.COLLECTIBLE_STEM_CELLS,
	CollectibleType.COLLECTIBLE_PORTABLE_SLOT,
	CollectibleType.COLLECTIBLE_HOLY_WATER,
	CollectibleType.COLLECTIBLE_FATE,
	CollectibleType.COLLECTIBLE_BLACK_BEAN,
	CollectibleType.COLLECTIBLE_WHITE_PONY,
	CollectibleType.COLLECTIBLE_SACRED_HEART,
	CollectibleType.COLLECTIBLE_TOOTH_PICKS,
	CollectibleType.COLLECTIBLE_HOLY_GRAIL,
	CollectibleType.COLLECTIBLE_DEAD_DOVE,
	CollectibleType.COLLECTIBLE_BLOOD_RIGHTS,
	CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL,
	CollectibleType.COLLECTIBLE_ABEL,
	CollectibleType.COLLECTIBLE_SMB_SUPER_FAN,
	CollectibleType.COLLECTIBLE_PYRO,
	CollectibleType.COLLECTIBLE_3_DOLLAR_BILL,
	CollectibleType.COLLECTIBLE_TELEPATHY_BOOK,
	CollectibleType.COLLECTIBLE_MEAT,
	CollectibleType.COLLECTIBLE_MAGIC_8_BALL,
	CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE,
	CollectibleType.COLLECTIBLE_SQUEEZY,
	CollectibleType.COLLECTIBLE_JESUS_JUICE,
	CollectibleType.COLLECTIBLE_BOX,
}

Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        local trinket0 = player:GetTrinket(0)
        local trinket1 = player:GetTrinket(1)

        if Astro:CheckTrinket(trinket0, Astro.Trinket.NOSTALGIA) then
            player:TryRemoveTrinket(trinket0)
            isc:smeltTrinket(player, Astro.Trinket.NOSTALGIA)
        elseif Astro:CheckTrinket(trinket1, Astro.Trinket.NOSTALGIA) then
            player:TryRemoveTrinket(trinket1)
            isc:smeltTrinket(player, Astro.Trinket.NOSTALGIA)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    function()
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()

        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:HasTrinket(Astro.Trinket.NOSTALGIA) and currentRoom:GetType() == RoomType.ROOM_BOSS then
                local rng = player:GetTrinketRNG(Astro.Trinket.NOSTALGIA)

                local items = Astro:GetRandomCollectibles(wolItemList, rng, 2)

                for _, value in ipairs(items) do
                    Astro:SpawnCollectible(value, player.Position)
                end

                player:TryRemoveTrinket(Astro.Trinket.NOSTALGIA)
            end
        end
    end
)
