-- ============================================================================
-- noly 世界地图：让 AI 在出生点直接建都
-- 模式：
--   "AI"  = 所有 AI 文明 + 城邦（推荐，默认）
--   "CS"  = 只强制城邦
--   "ALL" = AI + 城邦 + 玩家自己
--   "OFF" = 关闭
-- 只对 166×82 的 noly 世界地图生效。
--
-- 逻辑：第一回合每个玩家轮到时，如果还没有城市，就在其 StartingPlot
-- 直接创建首都；建城成功后删除该玩家所有初始 Settler，避免“多一个开拓者”。
-- 建城失败则完全跳过，让 AI 按正常逻辑处理，避免卡回合。
-- ============================================================================

local FORCE_TSL_MODE = "AI"

local mapW, mapH = Map.GetGridSize()
if mapW ~= 166 or mapH ~= 82 then
    return
end

if FORCE_TSL_MODE == "OFF" then
    return
end

print("NolyForceTSL: enabled, mode = " .. tostring(FORCE_TSL_MODE))

-- 在指定位置创建城市；如果地块有可移除的 Feature，先移除，失败再恢复
function NolyCreatePlayerCity(player, x, y)
    local plot = Map.GetPlot(x, y)
    local eFeatureType = plot and plot:GetFeatureType()
    local bFeatureValid = GameInfo.Features[eFeatureType] and not GameInfo.Features[eFeatureType].NaturalWonder

    if eFeatureType and bFeatureValid then
        TerrainBuilder.SetFeatureType(plot, -1)
    end

    local city = player:GetCities():Create(x, y)
    if city then
        return city
    elseif bFeatureValid then
        TerrainBuilder.SetFeatureType(plot, eFeatureType)
    end
end

-- 删除该玩家所有 Settler，避免城市 + 额外开拓者
function NolyRemoveAllSettlers(player)
    local settlers = {}
    for _, unit in player:GetUnits():Members() do
        if unit:GetType() == GameInfo.Units["UNIT_SETTLER"].Index then
            table.insert(settlers, unit)
        end
    end
    for _, unit in ipairs(settlers) do
        pcall(function()
            player:GetUnits():Destroy(unit)
        end)
    end
    return #settlers
end

function NolyForceTSL(iPrevPlayer)

    -- 只在第一回合执行
    if Game.GetCurrentGameTurn() > GameConfiguration.GetStartTurn() then
        Events.PlayerTurnDeactivated.Remove(NolyForceTSL)
        return
    end

    local bForceAll = (FORCE_TSL_MODE == "ALL")
    local bForceAI  = (FORCE_TSL_MODE == "AI") or bForceAll
    local bForceCS  = (FORCE_TSL_MODE == "CS") or bForceAI

    local iPlayer = iPrevPlayer + 1
    local player = Players[iPlayer]

    if player
        and player:WasEverAlive()
        and player:GetCities():GetCount() == 0
        and (
            (not player:IsMajor() and bForceCS)
            or (player:IsMajor() and (not player:IsHuman()) and bForceAI)
            or (player:IsHuman() and bForceAll)
        )
        and not player:IsBarbarian()
    then
        local startingPlot = player:GetStartingPlot()
        if startingPlot and not startingPlot:IsCity() and not startingPlot:IsWater() then
            -- Only force if the player actually has an initial settler.
            -- This avoids creating a free city for a player without a settler.
            local hasSettler = false
            for _, unit in player:GetUnits():Members() do
                if unit:GetType() == GameInfo.Units["UNIT_SETTLER"].Index then
                    hasSettler = true
                    break
                end
            end

            if hasSettler then
                local x, y = startingPlot:GetX(), startingPlot:GetY()
                local ok, city = pcall(NolyCreatePlayerCity, player, x, y)
                if ok and city then
                    local removed = NolyRemoveAllSettlers(player)
                    print("NolyForceTSL: capital founded at " .. tostring(x) .. "," .. tostring(y)
                        .. " for player #" .. tostring(iPlayer)
                        .. ", removed " .. tostring(removed) .. " settler(s)")
                else
                    print("NolyForceTSL: skipped player #" .. tostring(iPlayer)
                        .. " (could not create city at " .. tostring(x) .. "," .. tostring(y) .. ")")
                end
            end
        end
    end
end

Events.PlayerTurnDeactivated.Add(NolyForceTSL)

function NolyOnEnterGame()
    NolyForceTSL(-1)
end
Events.LoadScreenClose.Add(NolyOnEnterGame)
