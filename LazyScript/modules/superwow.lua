
if not SUPERWOW_VERSION then
    lazyScript.p("SuperWoW not detected!")
    return
end
if SUPERWOW_STRING then
    lazyScript.p("lazyScript detected "..SUPERWOW_STRING) 
end
if SUPERWOW_VERSION ~= "1.6" then
    lazyScript.p("|cffffffaaAn old version of SuperWoW was detected. Please consider updating:")
    lazyScript.p("-> https://github.com/balakethelock/SuperWoW/releases/")
end

-- Add mouseover support
if SUPERWOW_VERSION and lazyScript.GetUnitIdFromFrame() then
    local unit = "mouseover"

    if not UnitExists(unit) then
        local frame = GetMouseFocus()
        if frame.label and frame.id then
            unit = frame.label .. frame.id
        elseif UnitExists("target") then
            unit = "target"
        elseif GetCVar("autoSelfCast") == "1" then
            unit = "player"
        else
            return
        end
    end
end

-- cast monitor obj for superwow
local castMonitor = CreateFrame("Frame", nil)
castMonitor:SetPoint("CENTER", UIParent, "CENTER", 0, 70)
castMonitor:SetWidth(64)
castMonitor:SetHeight(64)
castMonitor:RegisterEvent("UNIT_CASTEVENT")

castMonitor:SetScript("OnEvent", function()
    -- validate event type & target
    if not arg1 then
        return
    end
    local caster, target, event, spellId, castDuration = arg1, arg2, arg3, arg4, arg5
    local _, playerGuid = UnitExists('player')
    local _, targetGuid = UnitExists('target')
    if event == "MAINHAND" or event == "OFFHAND" or caster ~= targetGuid then
        return
    end
    local spell = SpellInfo(spellId)
    if not spell then
        return
    end
    -- temp debug msgs
    local tName = UnitName('target')
    if lazyScript.perPlayerConf and lazyScript.perPlayerConf.showTargetCasts and tName then
        if event == "START" then
            lazyScript.p("SuperWoW: " .. tName .. " is casting " .. spell .. "!")
        elseif event == "CHANNEL" then
            lazyScript.p("SuperWoW: " .. tName .. " is channeling " .. spell .. "!")
        elseif event == "CAST" then
            lazyScript.p("SuperWoW: " .. tName .. " has cast " .. spell .. "!")
        elseif event == "FAIL" then
            lazyScript.p("SuperWoW: " .. tName .. " has failed to cast " .. spell .. "!") -- when spell has been interrupted or target dies 
        else
            lazyScript.p("SuperWoW: " .. event .. "ing " .. spell .. " detected.")
        end
    end
    -- goto interrupt func
    lazyScript.interrupt.OnSuperWoWSpell(spell, event)

    -- masks handle interrupt skipping and so dont need to be implemented here
end)

-- todo: superwow spells

--  cast after autoshoot



