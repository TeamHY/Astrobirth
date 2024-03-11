local isc = require("astro.lib.isaacscript-common")

Astro.Collectible.FIRECRACKER_FLOWER = Isaac.GetItemIdByName("Firecracker Flower")

Astro:AddEIDCollectible(Astro.Collectible.FIRECRACKER_FLOWER, "폭죽 꽃", "...", "{{Burning}} 30%의 확률로 적에게 달라붙는 씨앗 공격이 나갑니다.#!!! {{LuckSmall}}행운 수치 비례: 행운 70 이상일 때 100% 확률 (행운 1당 +1%p)#적에게 달라붙은 씨앗은 2초 후 공격력 x6 +35의 폭발 피해를 줍니다. (자해 없음)")

local tearChance = 0.3

local tearLuckMultiplier = 1 / 100

local laserChance = 0.1

local laserLuckMultiplier = 1 / 100

local knifeChance = 0.05

local knifeLuckMultiplier = 1 / 100

local swingChance = 0.15

local swingLuckMultiplier = 1 / 100

Astro:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    ---@param isContinued boolean
    function(_, isContinued)
        if not isContinued then
            Astro.Data.FirecrackerFlower = {
                FirecrackerTears = {},
                CrackeredEnemies = {},
                PetalTears = {}
            }
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    function(_)
        Astro.Data.FirecrackerFlower = {
            FirecrackerTears = {},
            CrackeredEnemies = {},
            PetalTears = {}
        }
    end
)

local CrackerSeedSprites = {}
local IsSpawningPetalTear = false

---@param npc EntityNPC
---@param source EntityPlayer?
local function FirecrackerExplode(npc, source)
    if source == nil then return end

    Isaac.Explode(npc.Position, source, 35 + 6 * source.Damage)

    local npcPtr = GetPtrHash(npc)
    local petalTears = Astro.Data.FirecrackerFlower.PetalTears

    local rng = isc:newRNG(npc.InitSeed)
    local numTears = 5 + rng:RandomInt(3)

    for _ = 1, numTears, 1 do
        local angle = rng:RandomInt(360)
        local velocity = Vector.FromAngle(angle):Resized(7)

        IsSpawningPetalTear = true
        local tear = source:FireTear(npc.Position, velocity, false, true, false, source, (1 / source.Damage) * 5)
        tear.Height = -26
        tear.FallingSpeed = isc:getRandomFloat(0, 3, rng)
        tear.FallingAcceleration = 0.5 * (isc:getRandomFloat(0.3, 1.3, rng))

        local tearSpr = tear:GetSprite()
        tearSpr:Load("/gfx/firecracker_petal.anm2", true)

        tearSpr:PlayRandom(tear.InitSeed)

        local tearPtr = GetPtrHash(tear)
        petalTears[tearPtr] = npcPtr
    end
end


---@param npc EntityNPC
---@param player EntityPlayer
local function AddCrackered(npc, player)
    local colliderPtr = GetPtrHash(npc)
    local crackeredEnemies = Astro.Data.FirecrackerFlower.CrackeredEnemies

    if crackeredEnemies[colliderPtr] ~= nil then return end

    local seedSprite = Sprite()
    seedSprite:Load("/gfx/firecracker_bullet.anm2", true)
    seedSprite:Play("SeedIdle", true)
    CrackerSeedSprites[colliderPtr] = seedSprite

    crackeredEnemies[colliderPtr] = {
        timer = 30 * 2,
        source = isc:getPlayerIndex(player)
    }
end

---@param tear EntityTear
local function MakeTearFirecrackerSeed(tear)
    local tearPtr = GetPtrHash(tear)

    tear:ChangeVariant(TearVariant.BONE)

    local tearSpr = tear:GetSprite()
    tearSpr:Load("/gfx/firecracker_seed.anm2", true)
    tearSpr:Play("spin", true)

    local newColor = Color(1, 1, 1, 1, 0.5)
    tear.Color = newColor

    Astro.Data.FirecrackerFlower.FirecrackerTears[tearPtr] = true
end


---@param tear EntityTear
local function OnTearInit(_, tear)
    if IsSpawningPetalTear then
        IsSpawningPetalTear = false
        return
    end

    local tearPtr = GetPtrHash(tear)
    local petalTears = Astro.Data.FirecrackerFlower.PetalTears

    if petalTears[tearPtr] then return end

    local spawner = tear.SpawnerEntity
    if not spawner then return end

    local player = spawner:ToPlayer()
    if not player then return end
    if not player:HasCollectible(Astro.Collectible.FIRECRACKER_FLOWER) then return end

    local rng = player:GetCollectibleRNG(Astro.Collectible.FIRECRACKER_FLOWER)
    if rng:RandomFloat() >= tearChance + player.Luck * tearLuckMultiplier then return end

    MakeTearFirecrackerSeed(tear)
end
Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_TEAR_INIT_LATE,
    OnTearInit
)


---@param tear EntityTear
local function OnTearUpdate(_, tear)
    local tearPtr = GetPtrHash(tear)
    local petalTears = Astro.Data.FirecrackerFlower.PetalTears

    if not petalTears[tearPtr] then return end

    local angle = tear.Velocity:GetAngleDegrees()
    tear.SpriteRotation = angle + 180
end
Astro:AddCallback(
    ModCallbacks.MC_POST_TEAR_UPDATE,
    OnTearUpdate
)


---@param tear EntityTear
---@param collider Entity
local function OnFirecrackerTearCollision(tear, collider)
    local npc = collider:ToNPC()
    if not npc or not collider:IsVulnerableEnemy() then return end

    local player = isc:getPlayerFromEntity(tear)

    if player == nil then return end

    AddCrackered(npc, player)
end


---@param collider Entity
---@param targetPtr integer
local function OnPetalTearCollision(collider, targetPtr)
    local colliderPtr = GetPtrHash(collider)

    if colliderPtr == targetPtr then
        return true
    end
end


---@param tear EntityTear
---@param collider Entity
local function OnTearCollision(_, tear, collider)
    local tearPtr = GetPtrHash(tear)
    local firecrackerTears = Astro.Data.FirecrackerFlower.FirecrackerTears
    local petalTears = Astro.Data.FirecrackerFlower.PetalTears

    if petalTears[tearPtr] then
        return OnPetalTearCollision(collider, petalTears[tearPtr])
    elseif firecrackerTears[tearPtr] then
        OnFirecrackerTearCollision(tear, collider)
    end
end
Astro:AddCallback(
    ModCallbacks.MC_PRE_TEAR_COLLISION,
    OnTearCollision
)


---@param npc EntityNPC
local function OnNPCUpdate(_, npc)
    local npcPtr = GetPtrHash(npc)

    if Astro.Data.FirecrackerFlower == nil then return end
    
    local crackeredEnemies = Astro.Data.FirecrackerFlower.CrackeredEnemies

    local crackerInfo = crackeredEnemies[npcPtr]

    if crackerInfo == nil then return end

    if crackerInfo.timer > 0 then
        crackerInfo.timer = crackerInfo.timer - 1

        ---@type Sprite
        local seedSpr = CrackerSeedSprites[npcPtr]

        seedSpr:Update()

        if crackerInfo.timer <= 30 * 3 and seedSpr:IsPlaying("SeedIdle") then
            seedSpr:Play("Bloom", true)
        end

        if seedSpr:IsFinished("Bloom") then
            seedSpr:Play("Idle")
        end

        return
    end

    CrackerSeedSprites[npcPtr] = nil

    npc.Color = Color(1, 1, 1)

    crackeredEnemies[npcPtr] = nil

    FirecrackerExplode(npc, isc:getPlayerFromIndex(crackerInfo.source))
end
Astro:AddCallback(
    ModCallbacks.MC_NPC_UPDATE,
    OnNPCUpdate
)


---@param npc EntityNPC
local function OnNPCRender(_, npc)
    local npcPtr = GetPtrHash(npc)
    local crackeredEnemies = Astro.Data.FirecrackerFlower.CrackeredEnemies
    local crackerInfo = crackeredEnemies[npcPtr]

    if crackerInfo == nil then return end

    local rng = isc:newRNG(npc.InitSeed)

    ---@type Sprite
    local seedSpr = CrackerSeedSprites[npcPtr]
    local renderPos = Isaac.WorldToScreen(npc.Position) - Vector(0, 10)
    seedSpr:Render(renderPos + Vector(isc:getRandomInt(-6, 6, rng), isc:getRandomInt(-2, 5, rng)))

    local colorAmount = math.abs(math.sin(npc.FrameCount * 0.1) * 0.6)
    local newColor = Color(1, 1, 1, 1, colorAmount)

    npc.Color = newColor
end
Astro:AddCallback(
    ModCallbacks.MC_POST_NPC_RENDER,
    OnNPCRender
)


---@param entity Entity
local function OnEntityRemove(_, entity)
    if Astro:isLeavingRoom() then return end

    local tear = entity:ToTear()
    if tear == nil then return end
    local tearPtr = GetPtrHash(tear)

    local petalTears = Astro.Data.FirecrackerFlower.PetalTears

    if not petalTears[tearPtr] then return end

    petalTears[tearPtr] = nil

    local spawner = tear.SpawnerEntity
    if not spawner then return end
    local player = spawner:ToPlayer()
    if not player then return end

    local miniExplosion = isc:spawnEffect(
        EffectVariant.BOMB_EXPLOSION,
        0,
        tear.Position
    )

    miniExplosion.SpriteScale = Vector(0.5, 0.5)

    local nearEnemies = Isaac.FindInRadius(entity.Position, 40, EntityPartition.ENEMY)

    for _, enemy in ipairs(nearEnemies) do
        enemy:TakeDamage(
            10 + 2 * player.Damage,
            DamageFlag.DAMAGE_EXPLOSION,
            EntityRef(player),
            -1
        )
    end
    SFXManager():Play(SoundEffect.SOUND_ROCKET_LAUNCH_TINY)
    SFXManager():Stop(SoundEffect.SOUND_EXPLOSION_STRONG)
    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK)
end
Astro:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    OnEntityRemove
)


---@param npc EntityNPC
---@param source EntityRef
function CheckForFirecrackerLaser(npc, source)
    if source.Type ~= EntityType.ENTITY_PLAYER then return end

    local player = source.Entity:ToPlayer()
    if not player then return end
    if not player:HasCollectible(Astro.Collectible.FIRECRACKER_FLOWER) then return end

    local rng = player:GetCollectibleRNG(Astro.Collectible.FIRECRACKER_FLOWER)
    if rng:RandomFloat() >= laserChance + player.Luck * laserLuckMultiplier then return end

    AddCrackered(npc, player)
end

---@param npc EntityNPC
---@param source EntityRef
function CheckForFirecrackerKnife(npc, source)
    if source.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

    local player = source.Entity.SpawnerEntity:ToPlayer()

    if not player then return end
    if not player:HasCollectible(Astro.Collectible.FIRECRACKER_FLOWER) then return end

    local rng = player:GetCollectibleRNG(Astro.Collectible.FIRECRACKER_FLOWER)
    if rng:RandomFloat() >= knifeChance + player.Luck * knifeLuckMultiplier then return end

    AddCrackered(npc, player)
end

---@param entity Entity
---@param flags integer
---@param source EntityRef
local function OnEntityDamage(_, entity, _, flags, source)
    local npc = entity:ToNPC()
    if not npc or not npc:IsVulnerableEnemy() then return end

    if isc:hasFlag(flags, DamageFlag.DAMAGE_LASER) then
        CheckForFirecrackerLaser(npc, source)
    elseif source.Type == EntityType.ENTITY_KNIFE then
        CheckForFirecrackerKnife(npc, source)
    end
end
Astro:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    OnEntityDamage
)


---@param bone EntityKnife
local function OnBoneSwing(_, bone)
    local spawner = bone.SpawnerEntity
    if spawner == nil then return end

    local player = spawner:ToPlayer()
    if not player then return end
    if not player:HasCollectible(Astro.Collectible.FIRECRACKER_FLOWER) then return end

    local rng = player:GetCollectibleRNG(Astro.Collectible.FIRECRACKER_FLOWER)
    if rng:RandomFloat() >= swingChance + player.Luck * swingLuckMultiplier then return end

    local tearVelocity = isc:directionToVector(player:GetFireDirection())
    tearVelocity = tearVelocity * 7 * player.ShotSpeed
    tearVelocity = tearVelocity + player.Velocity

    local tear = player:FireTear(
        bone.Position,
        tearVelocity,
        true,
        false,
        false,
        player
    )

    tear.FallingAcceleration = player.TearFallingAcceleration
    tear.FallingSpeed = player.TearFallingSpeed
    MakeTearFirecrackerSeed(tear)
end
Astro:AddCallbackCustom(
    isc.ModCallbackCustom.POST_BONE_SWING,
    OnBoneSwing
)


---@param effect EntityEffect
local function OnTearPoofInit(_, effect)
    local petalTears = Astro.Data.FirecrackerFlower.PetalTears
    local tears = isc:getTears()

    for _, tear in ipairs(tears) do
        local ptrHash = GetPtrHash(tear)

        if petalTears[ptrHash] then
            local distance = effect.Position:DistanceSquared(tear.Position + tear.PosDisplacement)

            if distance < 0.1 then
                effect:Remove()
                break
            end
        end
    end
end
Astro:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    OnTearPoofInit,
    EffectVariant.TEAR_POOF_A
)
Astro:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    OnTearPoofInit,
    EffectVariant.TEAR_POOF_B
)
