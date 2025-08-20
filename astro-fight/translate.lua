------ 카드 ------

------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!
------ 이 쓰레기 더미를 누군가 수정해주세요!!!

local pickedUpCards = {}        -- InitSeed 기준으로 플레이어가 닿은 후보 표시
local pickupJustTouched = {}    -- 인덱스 기반으로 닿은 기록
local pickupCollected = {}      -- 인덱스 기반으로 Collect 처리 기록
local consumedByBoC = {}        -- 제작 가방으로 처리됐는지
local showQueue = {}            -- 텍스트 표시를 다음 프레임으로 미루기 위한 큐

Astro.Fight.craftingBag = {}
Astro.Fight.pickupIDLookup = {}
Astro.Fight.runeIDs = {}

local function pid(pickup)
    return pickup.InitSeed
end

function Astro.Fight:getBagOfCraftingID(Variant, SubType)   -- 제작 가방 판별
    local entry = Astro.Fight.pickupIDLookup[Variant.."."..SubType]

    if entry ~= nil then
        return entry
    elseif Variant == 300 then
        if SubType == 0 then
            return nil
        elseif Astro.Fight.runeIDs[SubType] then
            return {23}
        else
            return {21}
        end
    end
    return nil
end


Astro.Fight:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, _)
    local id = pid(pickup)

    if collider.Type == EntityType.ENTITY_PLAYER
    or collider.Type == EntityType.ENTITY_FAMILIAR
    or collider.Type == EntityType.ENTITY_BUMBINO
    or collider.Type == EntityType.ENTITY_ULTRA_GREED then
        pickupJustTouched[pickup.Index] = true    -- 인덱스 기반으로 pickupJustTouched에 닿은 기록을 남김
    end

    if collider.Type == EntityType.ENTITY_PLAYER then
        pickedUpCards[id] = true    -- 플레이어가 닿으면 InitSeed 기준으로 pickedUpCards에 후보 표시
    end
end, 300)

Astro.Fight:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for _, pickup in ipairs(Isaac.FindByType(5, 300, -1, false, false)) do
        if not pickup then return end

        local idx = pickup.Index
        local id = pid(pickup)

        if pickup:GetSprite():GetAnimation() == "Collect" and not pickupCollected[idx] then    -- Collect에 진입했고 아직 처리하지 않았으면 처리
            pickupCollected[idx] = true

            if not pickupJustTouched[idx] then  -- 인덱스 기준으로 '닿지 않은 상태'라면 제작 가방 판정
                local ASTROcraftingIDs = Astro.Fight:getBagOfCraftingID(pickup.Variant, pickup.SubType)

                if ASTROcraftingIDs ~= nil then
                    for _, v in ipairs(ASTROcraftingIDs) do
                        if #Astro.Fight.craftingBag >= 8 then
                            table.remove(Astro.Fight.craftingBag, 1)
                        end
                        table.insert(Astro.Fight.craftingBag, v)
                    end
                    
                    consumedByBoC[id] = true    -- InitSeed 기준으로 제작 가방 판정 기록
                end
            end
        end

        pickupJustTouched[idx] = nil    -- 다음 프레임을 위해 인덱스 기반으로 닿은 기록 초기화
    end
end)

Astro.Fight:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for _, pickup in ipairs(Isaac.FindByType(5, 300, -1, false, false)) do    -- 현재 프레임에 뒤져버린 픽업들 중 플레이어가 닿아서 후보로 표시된 것들을 showQueue에 넣음
        if not pickup then return end
        local id = pid(pickup)

        if pickup:IsDead() and pickedUpCards[id] then
            table.insert(showQueue, {id = id, pickupRef = pickup})
            pickedUpCards[id] = nil    -- 큐로 보냈으니 후뵤 표시는 제거
        end
    end

    if #showQueue > 0 then
        for _, entry in ipairs(showQueue) do
            local id = entry.id
            local pickupRef = entry.pickupRef

            if consumedByBoC[id] then    -- 만약 Collect 처리에서 가방으로 흡수되었다면 --
                consumedByBoC[id] = nil                                                 --
            else                                                                        --
                if pickupRef and not pickupRef:Exists() then                            --
                    -- 스킵띠 <-----------------------------------------------------------
                else
                    local cardID = pickupRef and pickupRef.SubType
                    for _, c in pairs(Astro.Card) do
                        if c == cardID and Astro.EIDCard[cardID] then
                            local cardNames = Astro.EIDCard[cardID].name
                            local cardDescs = Astro.EIDCard[cardID].description

                            Game():GetHUD():ShowItemText(cardNames or "", cardDescs or "...")
                        end
                    end
                end
            end
        end

        showQueue = {}    -- 큐 비우기
    end
end)

Astro.Fight:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()    -- 새 방 진입 시 전체 초기화
    pickedUpCards = {}
    pickupJustTouched = {}
    pickupCollected = {}
    consumedByBoC = {}
    showQueue = {}
end)


------ 포켓 슬롯 번역 ------
local PocketItemStrings = {}

local function BuildPocketItemStrings()
    PocketItemStrings = {}

    local numPlayers = Game():GetNumPlayers()
    for i = 0, numPlayers - 1 do
        local ic = Isaac.GetItemConfig()
        local player = Isaac.GetPlayer(i)
        if not player or not player:Exists() or not player:ToPlayer() then
            goto skip
        end

        local TrslName = nil
        local card = player:GetCard(0)
        local pill = player:GetPill(0)

        for _, k in pairs(Astro.Card) do
            if k == card and Astro.EIDCard[card] then
                TrslName = Astro.EIDCard[card].name

                if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) then    -- Tab 누르면 이름 대신 설명 표시
                    TrslName = Astro.EIDCard[card].description
                end
            end
        end

        local id = #PocketItemStrings + 1
        PocketItemStrings[id] = {
            Name = TrslName or "",
            PType = player:GetPlayerType(),
            CtrlIdx = player.ControllerIndex
        }

        ::skip::
    end
end

Astro.Fight:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, cont)
    if not cont then
        PocketItemStrings = {}
    end 
end)

local font = Font()
font:Load(Astro.Fight.modPath .. "resources/font/for translate/luaminioutlined.fnt")

local function RenderPocketItemName()
    if not REPKOR then return end
    if not Game():GetHUD():IsVisible() then return end
    if Game():GetNumPlayers() > 1 then return end    -- 멀티 유기

    local shakeOffset = Game().ScreenShakeOffset
    local fontSize, sizeOffset = 1, -2

    for i, k in pairs(PocketItemStrings) do
        if not k or not k.Name or k.Name == "" then goto skip end

        local id = i - 1
        local str = k.Name
        local alpha = 0.75
        local pType = k.PType

        if (pType == PlayerType.PLAYER_JACOB or pType == PlayerType.PLAYER_ESAU) then goto skip end    -- 병머 유기

        if id == 0 then
            local Corner = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
            local Offset = -Vector(Options.HUDOffset * 16 + 30, Options.HUDOffset * 6 + 22)
            local Pos = Corner + Offset + shakeOffset
            font:DrawStringScaledUTF8(str, Pos.X + 1, Pos.Y + 13 + sizeOffset, fontSize, fontSize, KColor(alpha, alpha, alpha, alpha), 1, false)
        end

        ::skip::
    end
end

local renderCollback = ModCallbacks.MC_POST_RENDER
if Renderer then    -- RGON
    renderCollback = ModCallbacks.MC_HUD_RENDER
end

Astro.Fight:AddCallback(renderCollback, function()
    BuildPocketItemStrings()
    RenderPocketItemName()
end)