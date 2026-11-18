-- ============================================================================
-- noly 世界地图：强制在出生点建都
-- 模式：
--   "AI"  = 所有 AI 文明 + 城邦（推荐，默认）
--   "CS"  = 只强制城邦
--   "ALL" = AI + 城邦 + 玩家自己（玩家也会直接在出生点建都，不再有初始 Settler）
--   "OFF" = 关闭
-- 只对 166×82 的 noly 世界地图生效。
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
            local unitsInPlot = Units.GetUnitsInPlot(startingPlot)
            if unitsInPlot ~= nil then
                for _, unit in ipairs(unitsInPlot) do
                    if unit:GetType() == GameInfo.Units["UNIT_SETTLER"].Index then
                        print("NolyForceTSL: founding city at start plot for player #" .. tostring(iPlayer)
                            .. " (" .. tostring(startingPlot:GetX()) .. "," .. tostring(startingPlot:GetY()) .. ")")
                        local city = NolyCreatePlayerCity(player, startingPlot:GetX(), startingPlot:GetY())
                        if city then
                            player:GetUnits():Destroy(unit)
                        else
                            print("NolyForceTSL: WARNING city creation failed at "
                                .. tostring(startingPlot:GetX()) .. "," .. tostring(startingPlot:GetY()))
                        end
                    end
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
