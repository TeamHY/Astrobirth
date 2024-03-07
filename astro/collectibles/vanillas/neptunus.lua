--- Credit to Roary(Neptunus Synergies)
--- https://steamcommunity.com/sharedfiles/filedetails/?id=2965292371

if EID then
    EID:addDescriptionModifier(
        "AstroCollectiblesNeptunus",
        function(descObj)
            return descObj.ObjType == EntityType.ENTITY_PICKUP and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE and descObj.ObjSubType == CollectibleType.COLLECTIBLE_NEPTUNUS
        end,
        function(descObj)
            EID:appendToDescription(descObj, "#Neptunus Synergies 모드의 추가 시너지가 적용되어 있습니다.")

            return descObj
        end
    )
end

local game = Game()
local zeroV = Vector.Zero

local function findPlayer(entity)
    while (entity ~= nil and entity:ToPlayer() == nil) do
        entity = entity.SpawnerEntity
        if entity
            and entity.Type == EntityType.ENTITY_FAMILIAR
            and entity.Variant ~= FamiliarVariant.CAINS_OTHER_EYE
            and entity.Variant ~= FamiliarVariant.SCISSORS
            and entity.Variant ~= FamiliarVariant.INCUBUS
            and entity.Variant ~= FamiliarVariant.FATES_REWARD
            and entity.Variant ~= FamiliarVariant.MINISAAC
            and entity.Variant ~= FamiliarVariant.TWISTED_BABY
            and entity.Variant ~= FamiliarVariant.BLOOD_BABY --Blood Clots
            and entity.Variant ~= FamiliarVariant.UMBILICAL_BABY
            and entity.Variant ~= FamiliarVariant.DECAP_ATTACK
            and entity.Variant ~= 244 --Esau Jr.
        then
            return nil
        end
    end
    if entity then
        return entity:ToPlayer()
    end
end


local function changeSprite(entity, file)
    local sprite = entity:GetSprite()
    local anim = sprite:GetAnimation()
    file = file or sprite:GetFilename():sub(1, -6) .. "_neptunus.anm2"
    sprite:Load(file, true)
    sprite:Play(anim, true)
end


local function playerInAnim(player) -- original from Samael by Ghostbroster Connor, a little tweaked by me
    local curAnim = player:GetSprite():GetAnimation()
    if player:IsHoldingItem() then return true end
    if curAnim:sub(1, 6) == "Pickup" then return true end
    for i, anim in ipairs({ "Hit", "Sad", "Happy", "Jump", "LiftItem", "HideItem", "UseItem", "FallIn", "JumpOut" }) do
        if curAnim == anim then return true end
    end
    return false
end


---@param player EntityPlayer
local function postPEffectUpdate(_, player)
    if playerInAnim(player) then return end

    local data = player:GetData()
    if player:HasCollectible(597)
        and player:HasCollectible(229)
        and (player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) or player:HasWeaponType(WeaponType.WEAPON_BONE))
    then
        if not data.RoarysNeptunusSynergies then
            data.RoarysNeptunusSynergies = {
                FireDelay = player.MaxFireDelay,
                Charge = 0,
                Chargebar = nil,
                WasHoldingFire = nil,
                LastFireInput = nil
            }
        end
        local mData = data.RoarysNeptunusSynergies
        local isHoldingFire = (player:GetLastActionTriggers() & ActionTriggers.ACTIONTRIGGER_SHOOTING ~= 0)
        mData.Charge = (math.max(player.MaxFireDelay, 1) - mData.FireDelay) / math.max(player.MaxFireDelay, 1)

        if not isHoldingFire then
            if mData.WasHoldingFire then
                local tearsAmount = math.floor(13 * mData.Charge)
                local velocity = Vector(10 * player.ShotSpeed, 0)
                local rotation = mData.LastFireInput:GetAngleDegrees()
                for i = 1, tearsAmount do
                    local tear = player:FireTear(player.Position, velocity:Rotated(rotation + math.random(-2 * i - 10, 2 * i + 10)), true, false, true, player, math.random(8, 13) / 10)
                    tear.FallingSpeed = math.random(-16, -10)
                    tear.FallingAcceleration = 2 + math.random(-4, 2) / 10
                end
                mData.FireDelay = player.MaxFireDelay
            else
                if mData.FireDelay > 0 then mData.FireDelay = mData.FireDelay - 0.25 end
            end
        end

        mData.WasHoldingFire = isHoldingFire
        mData.LastFireInput = player:GetShootingInput()
    elseif data.RoarysNeptunusSynergies then
        data.RoarysNeptunusSynergies = nil
    end
end


local function postPlayerRender(_, player) -- original from Samael by Ghostbroster Connor, a little tweaked by me
    local data = player:GetData()
    if not data.RoarysNeptunusSynergies then return end

    local mData = data.RoarysNeptunusSynergies
    if not mData.Chargebar then
        mData.Chargebar = Sprite()
        mData.Chargebar:Load("gfx/chargebar.anm2", true)
        local newColor = Color(1, 1, 1, 1, 0, 0, 0)
        newColor:SetColorize(0.0, 1.5, 2.5, 1)
        mData.Chargebar.Color = newColor
        mData.Chargebar.Offset = Vector(-16, -33)
        mData.Chargebar.PlaybackSpeed = 0.5
        mData.Chargebar:Play("Disappear", true)
        mData.Chargebar:SetLastFrame()
    end
    local chargebar = mData.Chargebar
    local cbAnim = chargebar:GetAnimation()
    if mData.Charge >= 1 then
        if cbAnim == "StartCharged" and chargebar:IsFinished("StartCharged") then
            chargebar:Play("Charged", true)
        elseif cbAnim == "Charging" or cbAnim == "Disappear" then
            chargebar:Play("StartCharged", true)
        end
    elseif mData.Charge >= 0.05 then
        chargebar:SetFrame("Charging", math.floor(mData.Charge * 100))
    elseif cbAnim ~= "Disappear" then
        chargebar:Play("Disappear", true)
    end
    chargebar:Render(Isaac.WorldToScreen(player.Position))

    if not game:IsPaused() then
        chargebar:Update()
    end
end


local function evaluateCache(_, player)
    if player:HasCollectible(597) then
        player.LaserColor = player.TearColor
    end
end



local function postTearInit(_, tear)
    local player = findPlayer(tear)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    local sprite = tear:GetSprite()
    if tear.Variant == TearVariant.TECH_SWORD_BEAM then
        local newColor = Color(sprite.Color.R, sprite.Color.G, sprite.Color.B, sprite.Color.A, sprite.Color.RO, sprite.Color.GO, sprite.Color.BO)
        newColor:SetColorize(1, 1, 1.5, 2)
        sprite.Color = newColor
    elseif tear.Variant == TearVariant.BLOOD
        or tear.Variant == TearVariant.CUPID_BLOOD
        or tear.Variant == TearVariant.PUPULA_BLOOD
        or tear.Variant == TearVariant.GODS_FLESH_BLOOD
        or tear.Variant == TearVariant.GLAUCOMA_BLOOD
        or tear.Variant == TearVariant.EYE_BLOOD
        or tear.Variant == TearVariant.KEY_BLOOD
    then
        tear:ChangeVariant(tear.Variant - 1)
    elseif tear.Variant == TearVariant.NAIL_BLOOD then
        tear:ChangeVariant(TearVariant.NAIL)
    end
end


local function postTearUpdate(_, tear)
    local player = findPlayer(tear)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    if not tear:GetData().RoarysNeptunusSynergies then
        tear:GetData().RoarysNeptunusSynergies = { cooldown = 0, currentScaleMod = 1 }
    end
    local data = tear:GetData().RoarysNeptunusSynergies
    if tear:HasTearFlags(TearFlags.TEAR_FETUS) then
        if data.cooldown <= 0 then
            local sprite = tear:GetSprite()
            local tear = player:FireTear(tear.Position, Vector(10 * player.ShotSpeed, 0):Rotated(90 + 360 / 14 * sprite:GetFrame()), true, false, true, player, 0.4)
            tear.FallingSpeed = math.random(-5, -1)
            tear.FallingAcceleration = 2 + math.random(-14, -6) / 10
            data.cooldown = 0.9 * player.MaxFireDelay
        else
            data.cooldown = data.cooldown - 1
        end
    elseif tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
        if not player:HasWeaponType(WeaponType.WEAPON_BONE) then
            if player:GetLastActionTriggers() & ActionTriggers.ACTIONTRIGGER_SHOOTING == 0
                and data.currentScaleMod < 2.5
            then
                tear.Scale = tear.Scale / data.currentScaleMod * (data.currentScaleMod + 0.015)
                data.currentScaleMod = data.currentScaleMod + 0.015
            elseif data.currentScaleMod > 1 then
                tear.Scale = tear.Scale / data.currentScaleMod * (data.currentScaleMod - 0.005)
                data.currentScaleMod = data.currentScaleMod - 0.005
            end
        end
    end
end



local function postLaserImpactInit(_, impact)
    if not impact.SpawnerEntity
        or not impact.SpawnerEntity:ToLaser()
    then
        return
    end
    local player = findPlayer(impact)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    local laser = impact.SpawnerEntity:ToLaser()
    if laser.Variant == LaserVariant.THIN_RED
        or laser.Variant == LaserVariant.THICK_RED
        or laser.Variant == LaserVariant.BRIM_TECH
        or laser.Variant == LaserVariant.THICKER_RED
        or laser.Variant == LaserVariant.THICKER_BRIM_TECH
        or laser.Variant == LaserVariant.GIANT_RED
        or laser.Variant == LaserVariant.GIANT_BRIM_TECH
    then
        changeSprite(laser)
        changeSprite(impact)
    end
end


local function postBrimstoneEffectInit(_, effect) -- used for anti-gravity swirls and forgotten's brim-balls
    local player = findPlayer(effect)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    changeSprite(effect)
end


local function postLaserUpdate(_, laser)
    local player = findPlayer(laser)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    local stat = math.floor(10 * math.max(player.MaxFireDelay, 1))
    local tearsAmount = math.floor((550 / stat) ^ 0.7 + math.random(2, 6) / 10)
    if laser.Variant == LaserVariant.THIN_RED then
        tearsAmount = math.floor((170 / stat) ^ 0.7 + math.random(2, 4) / 10)
        if player:HasCollectible(229) and player:HasWeaponType(WeaponType.WEAPON_LASER) then
            tearsAmount = math.floor((80 / stat) ^ 0.7 + math.random(1, 6) / 10)
        end
    elseif laser.Variant == LaserVariant.SHOOP or laser.Variant == LaserVariant.ELECTRIC then
        tearsAmount = 0
    end
    if laser.SubType == 0 and laser.Child and tearsAmount > 0 then
        local vel = Vector(12 * player.ShotSpeed, 0)
        for i = 1, tearsAmount do
            local rotation = laser.AngleDegrees + math.random(100, 260)
            if laser.MaxDistance > 0 then
                rotation = math.random(-15, 375)
            end
            local tear = player:FireTear(laser.Child.Position, vel:Rotated(rotation), true, false, true, player, math.random(2, 4) / 10)
            tear:ClearTearFlags(TearFlags.TEAR_LASER)
            tear:ClearTearFlags(TearFlags.TEAR_LASERSHOT)
            tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
            tear.FallingSpeed = math.random(-18, -6)
            tear.FallingAcceleration = 2 + math.random(0, 8) / 10
        end
    end
    --laser.Size = laser.Size*1.3
    --laser:GetSprite().Scale = laser:GetSprite().Scale*1.3
end


local function entityTakeDMG(_, entity, _, flags, source) -- since lasers don't collide
    if flags & DamageFlag.DAMAGE_LASER ~= DamageFlag.DAMAGE_LASER
        or not source
        or not source.Entity
    then
        return
    end

    local player = findPlayer(source.Entity)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    --[[local laser = entity:ToLaser()
	if laser.Variant == LaserVariant.SHOOP
	or laser.Variant == LaserVariant.LIGHT_BEAM
	or laser.Variant == LaserVariant.TRACTOR_BEAM
	or laser.Variant == LaserVariant.LIGHT_RING
	or laser.SubType == LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT
	or (laser.Variant == LaserVariant.ELECTRIC and laser.SubType == LaserSubType.LASER_SUBTYPE_NO_IMPACT)
	then return end]]
    local stat = math.floor(10 * player.MaxFireDelay)
    local tearsAmount = math.floor((150 / stat) ^ 0.5 + math.random(3, 6) / 10)
    if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
        tearsAmount = math.floor((450 / stat) ^ 0.6 + math.random(3, 6) / 10)
    end
    if tearsAmount > 0 then
        local vel = Vector(10 * player.ShotSpeed, 0)
        for i = 1, tearsAmount do
            local rotation = math.random(0, 359)
            local pos = entity.Position:__add(Vector(25, 0):Rotated(rotation))
            local tear = player:FireTear(pos, vel:Rotated(rotation), true, false, true, player, math.random(2, 4) / 10)
            tear:ClearTearFlags(TearFlags.TEAR_LASER)
            tear:ClearTearFlags(TearFlags.TEAR_LASERSHOT)
            tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
            tear.FallingSpeed = math.random(-12, -2)
            tear.FallingAcceleration = 2 + math.random(2, 10) / 10
        end
    end
end



local function postKnifeUpdate(_, knife)
    local player = findPlayer(knife)
    if not player
        or not player:HasCollectible(597)
        or player:HasCollectible(678)
    then
        return
    end

    if not knife:GetData().RoarysNeptunusSynergies then
        knife:GetData().RoarysNeptunusSynergies = { wasAtPeak = false }
    end
    local data = knife:GetData().RoarysNeptunusSynergies

    local sprite = knife:GetSprite()
    local anim = sprite:GetAnimation()
    local frame = sprite:GetFrame()
    -- knife and symptorium
    if knife.Variant == 0 or knife.Variant == 5 then
        if knife:GetKnifeDistance() > knife.MaxDistance - 2 and not data.wasAtPeak then
            local tear = player:FireTear(knife.Position, Vector(13 * player.ShotSpeed * (2 + knife.Charge) / 3, 0):Rotated(knife.Rotation), true, false, true, player, 5)
            if tear.Variant == TearVariant.BLUE or tear.Variant == TearVariant.BLOOD then
                tear:ChangeVariant(TearVariant.CUPID_BLUE)
            end
            tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            tear.Height = tear.Height * (1 + 3 * knife.Charge) / 4
            tear.FallingSpeed = 2 - 1 * knife.Charge
            tear.Scale = tear.Scale * 2
            data.wasAtPeak = true
        end
        if not knife:IsFlying() then
            data.wasAtPeak = false
        end
        -- Forgotten's bone and scythe + donkey jawbone (berserk)
    elseif (knife.Variant == 1 or knife.Variant == 2 or knife.Variant == 3) and knife.SubType == 0 then
        local modifiers = { dmgSpin = 3, dmgSwing = 0.7, shotspeed = 12, scale = 2 }
        if knife.Variant == 2 then --Scythe stats
            modifiers = { dmgSpin = 5, dmgSwing = 1, shotspeed = 17, scale = 2.3 }
        end
        if anim == "Spin" and knife:GetKnifeDistance() > knife.MaxDistance - 2 and not data.wasAtPeak then
            local tear = player:FireTear(knife.Position, Vector(modifiers.shotspeed * player.ShotSpeed * (1 + 2 * knife.Charge) / 3, 0):Rotated(knife.Rotation), true, false, true, player, modifiers.dmgSpin)
            tear:AddTearFlags(TearFlags.TEAR_PIERCING)
            tear:ChangeVariant(TearVariant.PUPULA)
            tear.Height = tear.Height * (1 + 3 * knife.Charge) / 4
            tear.FallingSpeed = 2 - 1 * knife.Charge
            tear.Scale = tear.Scale * modifiers.scale
            data.wasAtPeak = true
        elseif anim:sub(1, 5) == "Swing" and frame == 4 and not data.wasAtPeak then
            for i = -1, 1 do
                local tear = player:FireTear(knife.Position, Vector(modifiers.shotspeed * player.ShotSpeed, 0):Rotated(knife.Rotation + i * 35), true, false, true, player, modifiers.dmgSwing)
                tear:ChangeVariant(TearVariant.PUPULA)
                tear.FallingSpeed = 1.3
                tear.Scale = tear.Scale * modifiers.scale
            end
            data.wasAtPeak = true
        elseif anim == "Idle" or (anim:sub(1, 5) == "Swing" and frame >= 6) then
            data.wasAtPeak = false
        end
        -- spirit and tech sword's slashes
    elseif (knife.Variant == 10 or knife.Variant == 11) and knife.SubType == 4 then
        if anim:sub(1, 6) == "Attack" and frame == 3 and not data.wasAtPeak and player.FireDelay <= 0 then
            for i = -1, 1 do
                local tear = player:FireTear(knife.Position, Vector(13 * player.ShotSpeed, 0):Rotated(knife.Rotation + i * 30 + math.random(-5, 5)), true, false, true, player, 0.5)
                tear.FallingSpeed = math.random(-12, -4)
                tear.FallingAcceleration = 2 + math.random(-2, 4) / 10
            end
            player.FireDelay = player.MaxFireDelay * 2
            data.wasAtPeak = true
        elseif anim:sub(1, 4) == "Spin" and frame == 10 and not data.wasAtPeak then
            for i = 0, 11 do
                local tear = player:FireTear(knife.Position, Vector(18 * player.ShotSpeed, 0):Rotated(knife.Rotation + i * 30 + math.random(-10, 10)), true, false, true, player, 0.9)
                tear.FallingSpeed = math.random(-16, -10)
                tear.FallingAcceleration = 2 + math.random(4, 12) / 10
            end
            data.wasAtPeak = true
        elseif anim:sub(1, 4) == "Idle" or anim:sub(1, 4) == "Spin" and frame <= 5 then
            data.wasAtPeak = false
        end
    end
end


local function postKnifeRender(_, knife)
    if knife:GetData().neptunusSprite then return end
    local player = findPlayer(knife)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    if knife.Variant == 10 then
        if knife.SubType == 0 then
            changeSprite(knife, "gfx/008.010.0_spirit sword_neptunus.anm2")
        elseif knife.SubType == 4 then
            changeSprite(knife, "gfx/008.010.4_spirit sword_neptunus.anm2")
        end
    elseif knife.Variant == 11 then
        local sprite = knife:GetSprite()
        local newColor = Color(sprite.Color.R, sprite.Color.G, sprite.Color.B, sprite.Color.A, sprite.Color.RO, sprite.Color.GO, sprite.Color.BO)
        newColor:SetColorize(1, 1, 1.5, 2)
        sprite.Color = newColor
    end
    knife:GetData().neptunusSprite = true
end


local function preKnifeCollision(_, knife, collider) -- currently unused; hitting ludo tear with bone doesn't trigger ANY collision callback
    if not collider:ToTear()
        or not collider:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO)
    then
        return
    end

    local player = findPlayer(knife)
    if not player
        or not player:HasCollectible(597)
        or player:HasCollectible(678)
    then
        return
    end

    for i = 1, 12 do
        local tear = player:FireTear(collider.Position, Vector(18 * player.ShotSpeed, 0):Rotated(i * 30), true, false, true, player, 0.9)
        tear.FallingSpeed = math.random(-16, -10)
        tear.FallingAcceleration = 2 + math.random(4, 12) / 10
    end
end



local function postBombUpdate(_, bomb)
    if not bomb.IsFetus then return end
    local player = findPlayer(bomb)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    if bomb:IsDead() then
        local tearsAmount = math.random(8, 16)
        for i = 0, tearsAmount do
            local tear = player:FireTear(bomb.Position, Vector(10 * player.ShotSpeed, 0):Rotated(i * 360 / tearsAmount + math.random(-5, 5)), true, false, true, player, 10 / tearsAmount)
            tear.FallingSpeed = math.random(-18, -6)
            tear.FallingAcceleration = 2 + math.random(-2, 10) / 10
            tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
        end
        local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, bomb.Position, zeroV, player):ToEffect()
        creep.Size = creep.Size * player.Damage * 2 / 3.5
        creep.SpriteScale = creep.SpriteScale * player.Damage * 2 / 3.5
        creep:SetTimeout(100)
        creep:Update()
    end
end


local function postExplosionInit(_, explosion)
    if not explosion.SpawnerEntity then return end

    local shouldApply = explosion.SpawnerEntity.Type == 1000 and (explosion.SpawnerEntity.Variant == 31 or explosion.SpawnerEntity.Variant == 118)
    if explosion.SpawnerEntity:ToBomb()
        and explosion.SpawnerEntity:ToBomb().IsFetus then
        shouldApply = true
    end
    if not shouldApply then return end

    local player = findPlayer(explosion)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    changeSprite(explosion, "gfx/1000.001b_water explosion.anm2")
end


local function postRocketUpdate(_, rocket)
    local player = findPlayer(rocket)
    if not player
        or not player:HasCollectible(597)
    then
        return
    end

    if rocket:IsDead() and not rocket:Exists() then
        local tearsAmount = math.random(8, 16)
        for i = 0, tearsAmount do
            local tear = player:FireTear(rocket.Position, Vector(10 * player.ShotSpeed, 0):Rotated(i * 360 / tearsAmount + math.random(-5, 5)), true, false, true, player, 10 / tearsAmount)
            tear.FallingSpeed = math.random(-18, -6)
            tear.FallingAcceleration = 2 + math.random(-2, 10) / 10
            tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
        end
        local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, rocket.Position, zeroV, player):ToEffect()
        creep.Size = creep.Size * player.Damage * 2 / 3.5
        creep.SpriteScale = creep.SpriteScale * player.Damage * 2 / 3.5
        creep:SetTimeout(100)
        creep:Update()
    end
end



-- Callbacks --
if Options.ChargeBars then
    Astro:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, postPlayerRender)
end
Astro:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, evaluateCache, CacheFlag.CACHE_TEARCOLOR)
Astro:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_INIT, CallbackPriority.LATE, postTearInit)
Astro:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_INIT, CallbackPriority.LATE, postLaserImpactInit, EffectVariant.LASER_IMPACT)
Astro:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_INIT, CallbackPriority.LATE, postBrimstoneEffectInit, EffectVariant.BRIMSTONE_SWIRL)
Astro:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_INIT, CallbackPriority.LATE, postBrimstoneEffectInit, EffectVariant.BRIMSTONE_BALL)
Astro:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_INIT, CallbackPriority.LATE, postBrimstoneEffectInit, EffectVariant.TECH_DOT)
Astro:AddCallback(ModCallbacks.MC_POST_KNIFE_RENDER, postKnifeRender)
Astro:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, postPEffectUpdate)
Astro:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, postTearUpdate)
Astro:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, postLaserUpdate)
Astro:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, entityTakeDMG)
Astro:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, postKnifeUpdate)
--Astro:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, preKnifeCollision, 4)
Astro:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, postBombUpdate)
Astro:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, postExplosionInit, EffectVariant.BOMB_EXPLOSION)
Astro:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postRocketUpdate, EffectVariant.ROCKET)
Astro:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, postRocketUpdate, EffectVariant.SMALL_ROCKET)
