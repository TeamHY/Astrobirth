local isc = require("astro.lib.isaacscript-common")

local soundId = Isaac.GetSoundIdByName("Epic")

-- 투명도 설정
local alpha = 1

-- 볼륨 설정
local volume = 0.7

-- 지속 프레임
local duration = 10 * 30 -- 10초

local epics = {
    [RoomType.ROOM_TREASURE] = {
        CollectibleType.COLLECTIBLE_D6,
    },
    [RoomType.ROOM_SHOP] = {
        CollectibleType.COLLECTIBLE_TREASURE_MAP,
    },
}

---@type {pickup: EntityPickup, sprite: Sprite, endFrame: integer}[]
local targets = {}

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        for i, target in ipairs(targets) do
            target.sprite:Update()
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        local removeList = {}

        for i, target in ipairs(targets) do
            if target.pickup:Exists() and target.pickup.SubType ~= 0 and Game():GetFrameCount() < target.endFrame then
                target.sprite:Render(Isaac.WorldToRenderPosition(target.pickup.Position + Vector(0, -40)), Vector(0, 0), Vector(0, 0))
            else
                table.insert(removeList, i)
            end
        end

        for i, _ in ipairs(removeList) do
            table.remove(targets, i)
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

                        table.insert(targets, { pickup = pickup, sprite = sprite, endFrame = Game():GetFrameCount() + duration })

                        SFXManager():Play(soundId, volume)
                        break
                    end
                end
            end
        end
    end
)
