local isc = require("astro.lib.isaacscript-common")

local soundId = Isaac.GetSoundIdByName("Epic")

-- 투명도 설정
local alpha = 1 -- (0.1 ~ 1) 까지 편하신대로 설정 하시면 됩니다 0일 경우 출력 안됨

-- 볼륨 설정
local volume = 0.5 -- (0.1 ~ 1) 까지 편하신대로 설정 하시면 됩니다 0일 경우 출력 안됨

-- 지속 프레임
local duration = 1.1 * 30 -- 오른쪽 30 은 건들지 마시고, 왼쪽 숫자만 건드시면 됩니다 10 * 30 -> 10초동안 에픽 애니메이션 출력

-- 장면당 프레임 (숫자가 낮을수록 빠름)
local speed = 1.1

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    function(_, isContinued)
        if not isContinued or Astro.Data.Epice == nil then
            Astro.Data.Epics = {
                common = {
                    CollectibleType.COLLECTIBLE_SACRED_HEART,
                    CollectibleType.COLLECTIBLE_ROCK_BOTTOM,
                    CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
                    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
                    CollectibleType.COLLECTIBLE_COMPASS,
                    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
                    CollectibleType.COLLECTIBLE_SPOON_BENDER,
                    CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
                    CollectibleType.COLLECTIBLE_TOUGH_LOVE,
                    CollectibleType.COLLECTIBLE_GOAT_HEAD,
                    CollectibleType.COLLECTIBLE_RUBBER_CEMENT,
                    CollectibleType.COLLECTIBLE_CRICKETS_BODY,
                    CollectibleType.COLLECTIBLE_STARTER_DECK,
                    CollectibleType.COLLECTIBLE_EVES_MASCARA,
                    CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
                    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
                    CollectibleType.COLLECTIBLE_DEAD_EYE,
                    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
                    CollectibleType.COLLECTIBLE_CENSER,
                    CollectibleType.COLLECTIBLE_TECH_X,
                    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
                    CollectibleType.COLLECTIBLE_SINUS_INFECTION,
                    CollectibleType.COLLECTIBLE_PARASITOID,
                    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
                    CollectibleType.COLLECTIBLE_GHOST_PEPPER,
                    CollectibleType.COLLECTIBLE_BROKEN_MODEM,
                    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
                    CollectibleType.COLLECTIBLE_HAEMOLACRIA,
                    CollectibleType.COLLECTIBLE_LACHRYPHAGY,
                    CollectibleType.COLLECTIBLE_TRISAGION,
                    CollectibleType.COLLECTIBLE_DAMOCLES,
                    CollectibleType.COLLECTIBLE_PSY_FLY,
                    CollectibleType.COLLECTIBLE_BRIMSTONE,
                    CollectibleType.COLLECTIBLE_GENESIS,
                    CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
                    CollectibleType.COLLECTIBLE_C_SECTION,
                    CollectibleType.COLLECTIBLE_SACRED_ORB,
                    CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
                    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
                    CollectibleType.COLLECTIBLE_SACRED_HEART,
                    CollectibleType.COLLECTIBLE_GODHEAD,
                    CollectibleType.COLLECTIBLE_PSY_FLY,
                    CollectibleType.COLLECTIBLE_SACRED_ORB,
                    CollectibleType.COLLECTIBLE_POLYPHEMUS,
                    CollectibleType.COLLECTIBLE_EYE_OF_BELIAL,
                    CollectibleType.COLLECTIBLE_SOL,
                    AstroItems.Collectible.CYGNUS,
                    AstroItems.Collectible.ARIES_EX,
                    AstroItems.Collectible.AQUARIUS_EX,
                    AstroItems.Collectible.PTOLEMAEUS,
                    AstroItems.Collectible.CURSED_HEART,
                    AstroItems.Collectible.DEATHS_EYES,
                    AstroItems.Collectible.DIVINE_LIGHT,
                    AstroItems.Collectible.ACUTE_SINUSITIS,
                    AstroItems.Collectible.LANIAKEA_SUPERCLUSTER,
                    AstroItems.Collectible.GALACTIC_MEDAL_OF_VALOR,
                    AstroItems.Collectible.QUASAR,
                    AstroItems.Collectible.BIRTHRIGHT_EDEN,
                    AstroItems.Collectible.BIRTHRIGHT_ISAAC,
                    AstroItems.Collectible.LANIAKEA_SUPERCLUSTER,
                    AstroItems.Collectible.PTOLEMAEUS,
                    AstroItems.Collectible.SINFUL_SPOILS_OF_SUBVERSION_SNAKE_EYE,
                    AstroItems.Collectible.TECHNOLOGY_OMICRON,
                    AstroItems.Collectible.ORIGINAL_SINFUL_SPOILS_SNAKE_EYE,
                    AstroItems.Collectible.RITE_OF_ARAMESIR,
                    AstroItems.Collectible.CHUBBYS_HEAD,
                    AstroItems.Collectible.AMAZING_CHAOS_SCROLL,
                    AstroItems.Collectible.THE_HOLY_BLOOD_AND_THE_HOLY_GRAIL,
                    AstroItems.Collectible.CAINS_SECRET_BAG,
                    AstroItems.Collectible.CURSE_OF_ARAMATIR,
                },
                [RoomType.ROOM_DEVIL] = {
                    CollectibleType.COLLECTIBLE_SPOON_BENDER,
                    CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
                    CollectibleType.COLLECTIBLE_TOUGH_LOVE,
                    CollectibleType.COLLECTIBLE_GOAT_HEAD,
                    CollectibleType.COLLECTIBLE_RUBBER_CEMENT,
                    CollectibleType.COLLECTIBLE_CRICKETS_BODY,
                    CollectibleType.COLLECTIBLE_STARTER_DECK,
                    CollectibleType.COLLECTIBLE_EVES_MASCARA,
                    CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
                    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
                    CollectibleType.COLLECTIBLE_DEAD_EYE,
                    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
                    CollectibleType.COLLECTIBLE_CENSER,
                    CollectibleType.COLLECTIBLE_TECH_X,
                    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
                    CollectibleType.COLLECTIBLE_SINUS_INFECTION,
                    CollectibleType.COLLECTIBLE_PARASITOID,
                    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
                    CollectibleType.COLLECTIBLE_GHOST_PEPPER,
                    CollectibleType.COLLECTIBLE_BROKEN_MODEM,
                    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
                    CollectibleType.COLLECTIBLE_HAEMOLACRIA,
                    CollectibleType.COLLECTIBLE_LACHRYPHAGY,
                    CollectibleType.COLLECTIBLE_TRISAGION,
                    CollectibleType.COLLECTIBLE_DAMOCLES,
                    CollectibleType.COLLECTIBLE_PSY_FLY,
                    CollectibleType.COLLECTIBLE_GENESIS,
                    CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
                    CollectibleType.COLLECTIBLE_C_SECTION,
                    CollectibleType.COLLECTIBLE_SACRED_ORB,
                    AstroItems.Collectible.CYGNUS,
                    AstroItems.Collectible.ARIES_EX,
                    AstroItems.Collectible.AQUARIUS_EX,
                    AstroItems.Collectible.PTOLEMAEUS,
                    AstroItems.Collectible.CURSED_HEART,
                    AstroItems.Collectible.DEATHS_EYES,
                    AstroItems.Collectible.DIVINE_LIGHT,
                    AstroItems.Collectible.ACUTE_SINUSITIS,
                    AstroItems.Collectible.LANIAKEA_SUPERCLUSTER,
                    AstroItems.Collectible.GALACTIC_MEDAL_OF_VALOR,
                    AstroItems.Collectible.QUASAR,
                },
                [RoomType.ROOM_CURSE] = {
                    CollectibleType.COLLECTIBLE_SPOON_BENDER,
                    CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
                    CollectibleType.COLLECTIBLE_TOUGH_LOVE,
                    CollectibleType.COLLECTIBLE_GOAT_HEAD,
                    CollectibleType.COLLECTIBLE_RUBBER_CEMENT,
                    CollectibleType.COLLECTIBLE_CRICKETS_BODY,
                    CollectibleType.COLLECTIBLE_STARTER_DECK,
                    CollectibleType.COLLECTIBLE_EVES_MASCARA,
                    CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
                    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
                    CollectibleType.COLLECTIBLE_DEAD_EYE,
                    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
                    CollectibleType.COLLECTIBLE_CENSER,
                    CollectibleType.COLLECTIBLE_TECH_X,
                    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
                    CollectibleType.COLLECTIBLE_SINUS_INFECTION,
                    CollectibleType.COLLECTIBLE_PARASITOID,
                    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
                    CollectibleType.COLLECTIBLE_GHOST_PEPPER,
                    CollectibleType.COLLECTIBLE_BROKEN_MODEM,
                    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
                    CollectibleType.COLLECTIBLE_HAEMOLACRIA,
                    CollectibleType.COLLECTIBLE_LACHRYPHAGY,
                    CollectibleType.COLLECTIBLE_TRISAGION,
                    CollectibleType.COLLECTIBLE_DAMOCLES,
                    CollectibleType.COLLECTIBLE_PSY_FLY,
                    CollectibleType.COLLECTIBLE_GENESIS,
                    CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM,
                    CollectibleType.COLLECTIBLE_C_SECTION,
                    CollectibleType.COLLECTIBLE_SACRED_ORB,
                    AstroItems.Collectible.CYGNUS,
                    AstroItems.Collectible.ARIES_EX,
                    AstroItems.Collectible.AQUARIUS_EX,
                    AstroItems.Collectible.PTOLEMAEUS,
                    AstroItems.Collectible.CURSED_HEART,
                    AstroItems.Collectible.DEATHS_EYES,
                    AstroItems.Collectible.DIVINE_LIGHT,
                    AstroItems.Collectible.ACUTE_SINUSITIS,
                    AstroItems.Collectible.LANIAKEA_SUPERCLUSTER,
                    AstroItems.Collectible.GALACTIC_MEDAL_OF_VALOR,
                    AstroItems.Collectible.QUASAR,
                },
                [RoomType.ROOM_SHOP] = {
                    CollectibleType.COLLECTIBLE_DOLLAR,
                    CollectibleType.COLLECTIBLE_COMPASS,
                    CollectibleType.COLLECTIBLE_TREASURE_MAP,
                    CollectibleType.COLLECTIBLE_SPELUNKER_HAT,
                    CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE,
                    CollectibleType.COLLECTIBLE_BLUE_MAP,
                    CollectibleType.COLLECTIBLE_STARTER_DECK,
                    CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
                    CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
                    CollectibleType.COLLECTIBLE_BROKEN_MODEM,
                    CollectibleType.COLLECTIBLE_PSY_FLY,
                    CollectibleType.COLLECTIBLE_LIL_DUMPY,
                    CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
                    CollectibleType.COLLECTIBLE_DIPLOPIA,
                    CollectibleType.COLLECTIBLE_STAIRWAY,
                    CollectibleType.COLLECTIBLE_BIRTHRIGHT,
                    CollectibleType.COLLECTIBLE_SPOON_BENDER,
                },
                [RoomType.ROOM_BOSS] = {
                    CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
                    CollectibleType.COLLECTIBLE_SCORPIO,
                    CollectibleType.COLLECTIBLE_EDENS_BLESSING,
                    CollectibleType.COLLECTIBLE_SERAPHIM,
                    CollectibleType.COLLECTIBLE_SUCCUBUS,
                    CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON,
                    CollectibleType.COLLECTIBLE_DOGMA,
                    CollectibleType.COLLECTIBLE_R_KEY,
                    CollectibleType.COLLECTIBLE_SAUSAGE,
                    CollectibleType.COLLECTIBLE_PASCHAL_CANDLE,
                    CollectibleType.COLLECTIBLE_VIRGO,
                    CollectibleType.COLLECTIBLE_ROTTEN_BABY,
                    AstroItems.Collectible.ANGRY_ONION,
                    AstroItems.Collectible.HAPPY_ONION,
                    AstroItems.Collectible.GALACTIC_MEDAL_OF_VALOR,
                },
                [RoomType.ROOM_CHEST] = {
                    CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
                    CollectibleType.COLLECTIBLE_SCORPIO,
                    CollectibleType.COLLECTIBLE_EDENS_BLESSING,
                    CollectibleType.COLLECTIBLE_SERAPHIM,
                    CollectibleType.COLLECTIBLE_SUCCUBUS,
                    CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON,
                    CollectibleType.COLLECTIBLE_DOGMA,
                    CollectibleType.COLLECTIBLE_R_KEY,
                    CollectibleType.COLLECTIBLE_SAUSAGE,
                    CollectibleType.COLLECTIBLE_PASCHAL_CANDLE,
                    CollectibleType.COLLECTIBLE_VIRGO,
                    CollectibleType.COLLECTIBLE_ROTTEN_BABY,
                    AstroItems.Collectible.ANGRY_ONION,
                    AstroItems.Collectible.HAPPY_ONION,
                    AstroItems.Collectible.GALACTIC_MEDAL_OF_VALOR,
                },
            }
        end
    end
)

---@type {pickup: EntityPickup, sprite: Sprite, prevFrame: integer, endFrame: integer}[]
local targets = {}

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for _, target in ipairs(targets) do
            local frameCount = Game():GetFrameCount()

            if target.prevFrame + speed < frameCount then
                target.sprite:Update()
                target.prevFrame = frameCount
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        local removeIndexs = {}

        for i, target in ipairs(targets) do
            if target.pickup:Exists() and target.pickup.SubType ~= 0 and Game():GetFrameCount() < target.endFrame then
                target.sprite:Render(Isaac.WorldToRenderPosition(target.pickup.Position + Vector(0, -40)), Vector(0, 0), Vector(0, 0))
            else
                table.insert(removeIndexs, i)
            end
        end

        for _, value in ipairs(removeIndexs) do
            table.remove(targets, value)
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    ---@param pickup EntityPickup
    function(_, pickup)
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local roomType = Game():GetLevel():GetCurrentRoom():GetType()

            if Astro.Data.Epics and Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == 0 and not Astro:IsDeathCertificateRoom() then
                local index = Astro:FindIndex(Astro.Data.Epics.common, pickup.SubType)
                local targetList = Astro.Data.Epics.common

                if index == -1 and Astro.Data.Epics[roomType] then
                    index = Astro:FindIndex(Astro.Data.Epics[roomType], pickup.SubType)
                    targetList = Astro.Data.Epics[roomType]
                end

                if index ~= -1 then
                pickup:GetData().ShowEpic = true
                    table.remove(targetList, index)
                end
            end
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_PICKUP_RENDER,
    ---@param pickup EntityPickup
    ---@param renderOffset Vector
    function(_, pickup, renderOffset)
        local data = pickup:GetData()

        if data.ShowEpic then
            local roomType = Game():GetLevel():GetCurrentRoom():GetType()
            local stageType = Game():GetLevel():GetStageType()

            if not (roomType == RoomType.ROOM_TREASURE and (stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B) and isc:isBlindCollectible(pickup)) then
                local sprite = Sprite()
                sprite:Load("gfx/effects/epic.anm2", true)
                sprite.Color = Color(1, 1, 1, alpha, 0, 0, 0)
                sprite:Play("Play", true)

                local frameCount = Game():GetFrameCount()
                table.insert(targets, { pickup = pickup, sprite = sprite, prevFrame = frameCount, endFrame = frameCount + duration })

                SFXManager():Play(soundId, volume)
            end

            data.ShowEpic = false
        end
    end
)
