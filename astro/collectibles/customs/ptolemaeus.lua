Astro.Collectible.PTOLEMAEUS = Isaac.GetItemIdByName("Ptolemaeus")

local radius = 15
local subScale = 0.5
local subDamageMultiplier = 0.5

if EID then
    Astro:AddEIDCollectible(Astro.Collectible.PTOLEMAEUS, "프톨레마이오스", "...", "발사한 눈물 주변을 회전하는 공격력 절반의 눈물이 생깁니다.")
end

Astro:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)
        local tearData = tear:GetData()

        if player ~= nil and player:HasCollectible(Astro.Collectible.PTOLEMAEUS) then
            tearData.Ptolemaeus = {}
        end
    end
)

Astro:AddCallback(
    ModCallbacks.MC_POST_TEAR_UPDATE,
    ---@param tear EntityTear
    function(_, tear)
        local player = Astro:GetPlayerFromEntity(tear)
        local tearData = tear:GetData()

        if player ~= nil and tearData.Ptolemaeus ~= nil then
            if not tearData.Ptolemaeus.IsSub then -- 메인 눈물 업데이트 (서브 눈물 위치 계산)
                if tear.FrameCount == 1 then
                    local subTears = {}

                    for _ = 1, player:GetCollectibleNum(Astro.Collectible.PTOLEMAEUS) do
                        local subTear =
                            player:FireTear(tear.Position, tear.Velocity, false, true, false, tear, subDamageMultiplier)

                        subTear.Scale = tear.Scale * subScale
                        subTear.TearFlags = subTear.TearFlags & ~TearFlags.TEAR_SPLIT & ~TearFlags.TEAR_BONE
                        subTear:GetData().Ptolemaeus = {
                            MainTear = tear,
                            IsSub = true
                        }

                        if tear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO then
                            subTear.TearFlags = subTear.TearFlags | TearFlags.TEAR_LUDOVICO
                            subTear.Height = tear.Height
                        end

                        table.insert(subTears, subTear)
                    end

                    tearData.Ptolemaeus.SubTears = subTears
                    tearData.Ptolemaeus.StartAngle = tear.Velocity:GetAngleDegrees()
                end

                for index, value in ipairs(tearData.Ptolemaeus.SubTears) do
                    local angle =
                        math.rad(
                            tearData.Ptolemaeus.StartAngle + (360 * index / #tearData.Ptolemaeus.SubTears) +
                            (360 * player.ShotSpeed * tear.FrameCount / 30)
                        )

                    if angle > 360 then
                        angle = angle - 360
                    end

                    local x = math.cos(angle) * radius
                    local y = math.sin(angle) * radius

                    if value:Exists() then
                        value.Velocity = tear.Position - value.Position + Vector(x, y)
                    end
                end
            else -- 서브 눈물 업데이트
                if
                    tear.TearFlags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO and
                    not tearData.Ptolemaeus.MainTear:Exists()
                then
                    tear:Remove()
                end
            end
        end
    end
)
