local isc = require("astro.lib.isaacscript-common")

local GRID_SIZE = 40
local GOLDEN_TRINKET_OFFSET = 32768

local game = Game()

if EID then
    EID:addDescriptionModifier(
        "AstroTrinketsGolden",
        function(descObj)
            if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
                return true
            end
        end,
        function(descObj)
            if descObj.ObjSubType == TrinketType.TRINKET_UMBILICAL_CORD then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible100}}Little Steven을 획득합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_MISSING_PAGE then
                EID:appendToDescription(
                    descObj,
                    "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible35}}The Necronomicon을 소환합니다."
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_RED_PATCH then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible157}}Bloody Lust을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SUPER_MAGNET then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible617}}Lodestone을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BROKEN_ANKH then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible161}}Ankh을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_FADED_POLAROID then
                EID:appendToDescription(
                    descObj,
                    "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible327}}The Polaroid과 {{Collectible328}}The Negative를 소환합니다. 하나를 선택하면 나머지는 사라집니다."
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_LOUSE then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible234}} 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BROKEN_SYRINGE then
                EID:appendToDescription(
                    descObj,
                    "#!!! {{ColorGold}}획득 시 사라지고 랜덤한 주사기 아이템 2개를 소환합니다. 하나를 선택하면 나머지는 사라집니다."
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_LIBERTY_CAP then
                EID:appendToDescription(
                    descObj,
                    "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible12}}Magic Mushroom 또는 {{Collectible71}}Mini Mush를 소환합니다."
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_RAINBOW_WORM then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible418}}Fruit Cake를 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_USED_DIAPER then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible9}}Skatole을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_POKER_CHIP then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible199}}Mom's Key를 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_TORN_POCKET then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible416}}Deep Pockets을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_AZAZELS_STUMP then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible118}}Brimstone을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_CRICKET_LEG then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible248}}Hive Mind를 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_STRANGE_KEY then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible297}}Pandora's Box를 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SHORT_FUSE then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible517}}Fast Bombs을 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_WISH_BONE then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 사라지고 {{Collectible515}}Mystery Gift를 소환합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SILVER_DOLLAR then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BLOODY_CROWN then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_HOLY_CROWN then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_WICKED_CROWN then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_NUMBER_MAGNET then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}획득 시 바로 흡수됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_PURPLE_HEART then
                EID:appendToDescription(descObj, "#↑ {{ColorGold}}{{DamageSmall}}공격력 x1.2")
            elseif descObj.ObjSubType == TrinketType.TRINKET_PINKY_EYE then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}100%로 발동합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_PUSH_PIN then
                EID:appendToDescription(descObj, "#!!! {{ColorGold}}100%로 발동합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SUPER_BALL then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}25%의 확률로 적용됩니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 75 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_BRAIN_WORM then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}눈물을 발사할 때 50%의 확률로 유도 효과가 생깁니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 50 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_BLACK_LIPSTICK then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{BlackHeart}}블랙하트를 하나 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_RUSTED_KEY then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{GoldenKey}}황금열쇠를 하나 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SAFETY_CAP then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{Pill1}}Gulp! 알약을 하나 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_ACE_SPADES then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{Card}}카드를 하나 생성합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_MATCH_STICK then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{Bomb}}기가 폭탄을 하나 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_THE_TWINS then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{Card92}}Soul of Lilith를 하나 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_STUD_FINDER then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{LadderRoom}}사다리방으로 가는 다락문을 생성합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_KARMA then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 행운이 1 증가합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_MONKEY_PAW then
                EID:appendToDescription(descObj, "#{{ColorGold}}스테이지를 넘어갈 때마다 {{BlackHeart}}블랙하트를 셋 드랍합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BLOODY_PENNY then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}효과가 1번 더 발동합니다. 동전 가치를 반영하지 않습니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 75 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_BURNT_PENNY then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}효과가 1번 더 발동합니다. 동전 가치를 반영하지 않습니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 75 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_FLAT_PENNY then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}효과가 1번 더 발동합니다. 동전 가치를 반영하지 않습니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 75 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_COUNTERFEIT_PENNY then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}효과가 1번 더 발동합니다. 동전 가치를 반영하지 않습니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 75 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_ROTTEN_PENNY then
                EID:appendToDescription(descObj, "#{{ColorGold}}효과가 1번 더 발동합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BLESSED_PENNY then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}효과가 1번 더 발동합니다. 동전 가치를 반영하지 않습니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 88 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_BAT_WING then
                EID:appendToDescription(descObj, "#{{ColorGold}}비행 능력을 얻습니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_TEMPORARY_TATTOO then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}{{ChallengeRoom}} 소지 중일 때 도전방/보스도전방에 항상 입장할 수 있습니다.#{{ColorGold}}맵에 {{ChallengeRoom}}도전방/보스도전방의 위치가 표시됩니다."
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_FRAGMENTED_CARD then
                EID:appendToDescription(descObj, "#{{ColorGold}}맵에 비밀방/일급비밀방의 위치가 표시됩니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_BROKEN_PADLOCK then
                EID:appendToDescription(descObj, "#{{ColorGold}}방 클리어 시 마다 {{Collectible175}}Dad's Key 효과를 발동합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_ADOPTION_PAPERS then
                EID:appendToDescription(descObj, "#{{ColorGold}}{{Shop}}상점에 {{Card92}}Soul of Lilith를 하나 생성합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_GOLDEN_HORSE_SHOE then
                EID:appendToDescription(descObj, "#{{ColorGold}}{{TreasureRoom}}보물방에 보상을 하나 추가로 생성합니다.")
            elseif descObj.ObjSubType == TrinketType.TRINKET_SIGIL_OF_BAPHOMET then
                EID:appendToDescription(
                    descObj,
                    "#{{ColorGold}}클리어 되지않은 방 입장 시 10% 확률로 {{Collectible58}}Book of Shadows 효과를 발동합니다.#!!! {{ColorGold}}{{LuckSmall}}행운 수치 비례: 행운 90 이상일 때 100% 확률 (행운 1당 +1%p)"
                )
            elseif descObj.ObjSubType == TrinketType.TRINKET_BLACK_FEATHER then
                EID:appendToDescription(descObj, "#{{ColorGold}}{{DevilRoom}}악마방 입장 시 공격력 +2 증가합니다.")
            end

            return descObj
        end
    )
end

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.KarmaLuck = 0
            Astro.Data.BlackFeatherDamage = 0
        else
            for i = 1, Game():GetNumPlayers() do
                local player = Isaac.GetPlayer(i - 1)

                if player:GetTrinketMultiplier(TrinketType.TRINKET_KARMA) > 1 then
                    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                end

                if player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) > 1 then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                end

                player:EvaluateItems()
            end
        end
    end
)

---@param value integer
---@param trinket TrinketType
---@return boolean
function Astro:CheckTrinket(value, trinket)
    if value == trinket or value - GOLDEN_TRINKET_OFFSET == trinket then
        return true
    end

    return false
end

---@param player EntityPlayer
---@param type integer
---@return boolean
local function RunEffect(player, type)
    if Astro:CheckTrinket(type, TrinketType.TRINKET_UMBILICAL_CORD) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_LITTLE_STEVEN)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_MISSING_PAGE) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_NECRONOMICON,
            currentRoom:FindFreePickupSpawnPosition(player.Position + Vector(0, -GRID_SIZE), GRID_SIZE, true),
            Vector.Zero,
            nil
        )
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_RED_PATCH) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_BLOODY_LUST,
            currentRoom:FindFreePickupSpawnPosition(player.Position + Vector(0, -GRID_SIZE), GRID_SIZE, true),
            Vector.Zero,
            nil
        )
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_SUPER_MAGNET) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_LODESTONE,
            currentRoom:FindFreePickupSpawnPosition(player.Position + Vector(0, -GRID_SIZE), GRID_SIZE, true),
            Vector.Zero,
            nil
        )
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_BROKEN_ANKH) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_ANKH,
            currentRoom:FindFreePickupSpawnPosition(player.Position + Vector(0, -GRID_SIZE), GRID_SIZE, true),
            Vector.Zero,
            nil
        )
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_FADED_POLAROID) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_POLAROID,
            currentRoom:FindFreePickupSpawnPosition(
                player.Position + Vector(-GRID_SIZE, -GRID_SIZE),
                GRID_SIZE,
                true
            ),
            Vector.Zero,
            nil
        ):ToPickup().OptionsPickupIndex = TrinketType.TRINKET_FADED_POLAROID
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_NEGATIVE,
            currentRoom:FindFreePickupSpawnPosition(
                player.Position + Vector(GRID_SIZE, -GRID_SIZE),
                GRID_SIZE,
                true
            ),
            Vector.Zero,
            nil
        ):ToPickup().OptionsPickupIndex = TrinketType.TRINKET_FADED_POLAROID
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LOUSE) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            CollectibleType.COLLECTIBLE_INFESTATION_2,
            currentRoom:FindFreePickupSpawnPosition(player.Position + Vector(0, -GRID_SIZE), GRID_SIZE, true),
            Vector.Zero,
            nil
        )
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_BROKEN_SYRINGE) then
        local currentRoom = game:GetLevel():GetCurrentRoom()
        local rng = player:GetTrinketRNG(TrinketType.TRINKET_BROKEN_SYRINGE)

        local syringes = {
            CollectibleType.COLLECTIBLE_VIRUS,
            CollectibleType.COLLECTIBLE_ROID_RAGE,
            CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
            CollectibleType.COLLECTIBLE_SPEED_BALL,
            CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT,
            CollectibleType.COLLECTIBLE_SYNTHOIL,
            CollectibleType.COLLECTIBLE_ADRENALINE,
            CollectibleType.COLLECTIBLE_EUTHANASIA,
            Astro.Collectible.MORPHINE
        }

        local count = #syringes

        local firstIndex = rng:RandomInt(count) + 1
        local secondIndex = rng:RandomInt(count - 1) + 1

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            syringes[firstIndex],
            currentRoom:FindFreePickupSpawnPosition(
                player.Position + Vector(-GRID_SIZE, -GRID_SIZE),
                GRID_SIZE,
                true
            ),
            Vector.Zero,
            nil
        ):ToPickup().OptionsPickupIndex = TrinketType.TRINKET_BROKEN_SYRINGE

        table.remove(syringes, firstIndex)

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            syringes[secondIndex],
            currentRoom:FindFreePickupSpawnPosition(
                player.Position + Vector(GRID_SIZE, -GRID_SIZE),
                GRID_SIZE,
                true
            ),
            Vector.Zero,
            nil
        ):ToPickup().OptionsPickupIndex = TrinketType.TRINKET_BROKEN_SYRINGE
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LIBERTY_CAP) then
        local rng = player:GetTrinketRNG(TrinketType.TRINKET_LIBERTY_CAP)

        local mushrooms = {
            CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
            CollectibleType.COLLECTIBLE_MINI_MUSH
        }

        Astro:SpawnCollectible(mushrooms[rng:RandomInt(#mushrooms) + 1], player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_RAINBOW_WORM) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_FRUIT_CAKE, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_USED_DIAPER) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_SKATOLE, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_POKER_CHIP) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_MOMS_KEY, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_TORN_POCKET) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_AZAZELS_STUMP) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_CRICKET_LEG) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_STRANGE_KEY) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_BLUE_BOX, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_SHORT_FUSE) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_FAST_BOMBS, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_WISH_BONE) then
        Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_MYSTERY_GIFT, player.Position)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_SILVER_DOLLAR) then
        isc:smeltTrinket(player, TrinketType.TRINKET_SILVER_DOLLAR + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_BLOODY_CROWN) then
        isc:smeltTrinket(player, TrinketType.TRINKET_BLOODY_CROWN + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_HOLY_CROWN) then
        isc:smeltTrinket(player, TrinketType.TRINKET_HOLY_CROWN + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_WICKED_CROWN) then
        isc:smeltTrinket(player, TrinketType.TRINKET_WICKED_CROWN + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_NUMBER_MAGNET) then
        isc:smeltTrinket(player, TrinketType.TRINKET_NUMBER_MAGNET + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LOCUST_OF_PESTILENCE) then
        isc:smeltTrinket(player, TrinketType.TRINKET_LOCUST_OF_PESTILENCE + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LOCUST_OF_FAMINE) then
        isc:smeltTrinket(player, TrinketType.TRINKET_LOCUST_OF_FAMINE + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LOCUST_OF_DEATH) then
        isc:smeltTrinket(player, TrinketType.TRINKET_LOCUST_OF_DEATH + GOLDEN_TRINKET_OFFSET)
        return true
    elseif Astro:CheckTrinket(type, TrinketType.TRINKET_LOCUST_OF_CONQUEST) then
        isc:smeltTrinket(player, TrinketType.TRINKET_LOCUST_OF_CONQUEST + GOLDEN_TRINKET_OFFSET)
        return true
    end

    return false
end

-- 최적화 해야 함
Astro:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    ---@param player EntityPlayer
    function(_, player)
        for i = 0, 1 do -- TrinketIndex 0 ~ 1
            local trinket = player:GetTrinket(i)

            if trinket == TrinketType.TRINKET_NULL then
                break
            end

            if
                (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) or isc:isGoldenTrinketType(trinket)) and
                RunEffect(player, trinket)
            then
                player:TryRemoveTrinket(trinket)
                break;
            end

            Astro:UpdateLavaHandEffect(player, trinket)
        end

        if player:GetTrinketMultiplier(TrinketType.TRINKET_TEMPORARY_TATTOO) > 1 then
            Astro:DisplayRoom(RoomType.ROOM_CHALLENGE)

            local currentRoom = game:GetLevel():GetCurrentRoom()

            for _, value in pairs(isc:getDoors()) do
                local door = value ---@type GridEntityDoor

                if currentRoom:IsClear() and door:IsOpen() == false and door.TargetRoomType == RoomType.ROOM_CHALLENGE then
                    door:TryUnlock(Isaac.GetPlayer(), true)
                end
            end
        elseif player:GetTrinketMultiplier(TrinketType.TRINKET_FRAGMENTED_CARD) > 1 then
            Astro:DisplayRoom(RoomType.ROOM_SECRET)
            Astro:DisplayRoom(RoomType.ROOM_SUPERSECRET)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    ---@param player EntityPlayer
    ---@param cacheFlag CacheFlag
    function(_, player, cacheFlag)
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PURPLE_HEART) > 1 then
                player.Damage = player.Damage * 1.2
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) > 1 and Astro.Data.BlackFeatherDamage ~= nil then
                player.Damage = player.Damage + Astro.Data.BlackFeatherDamage
            end
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_KARMA) > 1 and Astro.Data.KarmaLuck ~= nil then
                player.Luck = player.Luck + Astro.Data.KarmaLuck
            end
        elseif cacheFlag == CacheFlag.CACHE_FLYING then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_BAT_WING) > 1 then
                player.CanFly = true
            end
        elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PINKY_EYE) > 1 then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_POISON
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_PUSH_PIN) > 1 then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)

        if player ~= nil then
            if player:GetTrinketMultiplier(TrinketType.TRINKET_PINKY_EYE) > 1 then
                tear.Color = Color(0.4, 0.97, 0.5, 1, 0, 0, 0)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_PUSH_PIN) > 1 then
                if tear.Variant == TearVariant.BLUE then
                    tear:ChangeVariant(TearVariant.CUPID_BLUE)
                elseif tear.Variant == TearVariant.BLOOD then
                    tear:ChangeVariant(TearVariant.CUPID_BLOOD)
                end

                tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_SUPER_BALL) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_SUPER_BALL)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BOUNCE
                    tear.Color = Color(1, 1, 0.8, 1, 0.1, 0.1, 0.1)
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BRAIN_WORM) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BRAIN_WORM)

                if rng:RandomFloat() < 0.5 + player.Luck / 100 then
                    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
                    -- tear.Color = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    function()
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            local currentRoom = game:GetLevel():GetCurrentRoom()

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_LIPSTICK) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_BLACK,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_RUSTED_KEY) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_KEY,
                    KeySubType.KEY_GOLDEN,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_SAFETY_CAP) > 1 then
                local itemPool = game:GetItemPool()
                local pillColor = itemPool:ForceAddPillEffect(PillEffect.PILLEFFECT_GULP)

                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_PILL,
                    pillColor,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, 40, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_ACE_SPADES) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_TAROTCARD,
                    0,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_MATCH_STICK) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_BOMB,
                    BombSubType.BOMB_GIGA,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_THE_TWINS) > 1 then
                Astro:SpawnCard(Card.CARD_SOUL_LILITH, player.Position)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_STUD_FINDER) > 1 then
                Isaac.GridSpawn(GridEntityType.GRID_STAIRS, 0, Vector(560, 400), true)
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_KARMA) > 1 then
                Astro.Data.KarmaLuck = Astro.Data.KarmaLuck + 1

                player:AddCacheFlags(CacheFlag.CACHE_LUCK)
                player:EvaluateItems()
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_MONKEY_PAW) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_BLACK,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_BLACK,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_BLACK,
                    currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                    Vector.Zero,
                    nil
                )
            end
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_PICKUP_COLLECT,
    ---@param pickup EntityPickup
    ---@param player EntityPlayer
    function(_, pickup, player)
        if pickup.Variant == PickupVariant.PICKUP_COIN then
            local currentRoom = game:GetLevel():GetCurrentRoom()

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLOODY_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BLOODY_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        2,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BURNT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BURNT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_BOMB,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_FLAT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_FLAT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_KEY,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_COUNTERFEIT_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_COUNTERFEIT_PENNY)

                if rng:RandomFloat() < 0.25 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_COIN,
                        0,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_ROTTEN_PENNY) > 1 then
                Isaac.Spawn(
                    EntityType.ENTITY_FAMILIAR,
                    FamiliarVariant.BLUE_FLY,
                    0,
                    player.Position,
                    Vector.Zero,
                    player
                )
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BLESSED_PENNY) > 1 then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_BLESSED_PENNY)

                if rng:RandomFloat() < 0.125 + player.Luck / 100 then
                    Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_HEART,
                        HeartSubType.HEART_HALF_SOUL,
                        currentRoom:FindFreePickupSpawnPosition(player.Position, GRID_SIZE, true),
                        Vector.Zero,
                        nil
                    )
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    ---@param rng RNG
    ---@param spawnPosition Vector
    function(_, rng, spawnPosition)
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if player:GetTrinketMultiplier(TrinketType.TRINKET_BROKEN_PADLOCK) > 1 then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, false, true, false, false)
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        local level = Game():GetLevel()
        local currentRoom = level:GetCurrentRoom()
        local roomType = currentRoom:GetType()

        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)

            if currentRoom:GetFrameCount() <= 0 and currentRoom:IsFirstVisit() then
                if
                    player:GetTrinketMultiplier(TrinketType.TRINKET_ADOPTION_PAPERS) > 1 and
                    roomType == RoomType.ROOM_SHOP
                then
                    Astro:SpawnCard(Card.CARD_SOUL_LILITH, currentRoom:GetCenterPos())
                elseif
                    player:GetTrinketMultiplier(TrinketType.TRINKET_GOLDEN_HORSE_SHOE) > 1 and
                    roomType == RoomType.ROOM_TREASURE
                then
                    Astro:SpawnCollectible(CollectibleType.COLLECTIBLE_NULL, currentRoom:GetCenterPos())
                elseif
                    player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) > 1 and
                    roomType == RoomType.ROOM_DEVIL
                then
                    Astro.Data.BlackFeatherDamage = Astro.Data.BlackFeatherDamage + 2

                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    player:EvaluateItems()
                end
            end

            if player:GetTrinketMultiplier(TrinketType.TRINKET_SIGIL_OF_BAPHOMET) > 1 then
                if not currentRoom:IsClear() then
                    local rng = player:GetTrinketRNG(TrinketType.TRINKET_SIGIL_OF_BAPHOMET)

                    if rng:RandomFloat() < 0.1 + player.Luck / 100 then
                        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false)
                    end
                end
            end
        end
    end
)
