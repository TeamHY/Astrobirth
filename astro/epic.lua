local isc = require("astro.lib.isaacscript-common")

local soundId = Isaac.GetSoundIdByName("Epic")

-- 투명도 설정
local alpha = 1 -- (0.1 ~ 1) 까지 편하신대로 설정 하시면 됩니다 0일 경우 출력 안됨

-- 볼륨 설정
local volume = 0.7 -- (0.1 ~ 1) 까지 편하신대로 설정 하시면 됩니다 0일 경우 출력 안됨

-- 지속 프레임
local duration = 5 * 30 -- 오른쪽 30 은 건들지 마시고, 왼쪽 숫자만 건드시면 됩니다 10 * 30 -> 10초동안 에픽 애니메이션 출력

-- 장면당 프레임 (숫자가 낮을수록 빠름)
local speed = 1.1

local epics = {
    [RoomType.ROOM_TREASURE] = {
        CollectibleType.COLLECTIBLE_D6,
    },
    [RoomType.ROOM_DEFAULT] = {
        CollectibleType.COLLECTIBLE_D6,
    },
    [RoomType.ROOM_SHOP] = {
        CollectibleType.COLLECTIBLE_TREASURE_MAP,
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
        Astro.Collectible.ANGRY_ONION,
        Astro.Collectible.HAPPY_ONION,
        Astro.Collectible.GALACTIC_MEDAL_OF_VALOR,
    },
}

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

            if epics[roomType] then
                for _, epic in ipairs(epics[roomType]) do
                    if pickup.SubType == epic then
                        local sprite = Sprite()
                        sprite:Load("gfx/effects/epic.anm2", true)
                        sprite.Color = Color(1, 1, 1, alpha, 0, 0, 0)
                        sprite:Play("Play", true)

                        local frameCount = Game():GetFrameCount()
                        table.insert(targets, { pickup = pickup, sprite = sprite, prevFrame = frameCount, endFrame = frameCount + duration })

                        SFXManager():Play(soundId, volume)
                        break
                    end
                end
            end
        end
    end
)
