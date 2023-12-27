local isc = require("astro.lib.isaacscript-common")

local soundId = Isaac.GetSoundIdByName("Epic")

-- 투명도 설정
local alpha = 1

-- 볼륨 설정
local volume = 0.7

local epics = {
    [RoomType.ROOM_TREASURE] = {
        CollectibleType.COLLECTIBLE_D6,
    },
    [RoomType.ROOM_SHOP] = {
        CollectibleType.COLLECTIBLE_TREASURE_MAP,
    },
}

local sprite = Sprite()
sprite:Load("gfx/effects/epic.anm2", true)
sprite.Color = Color(1, 1, 1, alpha, 0, 0, 0)

---@type EntityPlayer?
local targetPlayer = nil

Astro:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    function(_)
        sprite:Update()
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    function(_)
        if targetPlayer then
            sprite:Render(Isaac.WorldToRenderPosition(targetPlayer.Position + Vector(0, -56)), Vector(0, 0), Vector(0, 0))
        end
    end
)

Astro:AddCallbackCustom(
    isc.ModCallbackCustom.PRE_ITEM_PICKUP,
    ---@param player EntityPlayer
    ---@param pickingUpItem { itemType: ItemType, subType: CollectibleType | TrinketType }
    function(_, player, pickingUpItem)
        local roomType = Game():GetLevel():GetCurrentRoom():GetType()

        if epics[roomType] then
            for _, epic in ipairs(epics[roomType]) do
                if pickingUpItem.itemType ~= ItemType.ITEM_TRINKET and pickingUpItem.subType == epic then
                    targetPlayer = player
                    sprite:Play("Play", true)
                    SFXManager():Play(soundId, volume)
                    break
                end
            end
        end
    end
)
