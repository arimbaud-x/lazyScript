--[[
    additive font config module 
    overwrites fonts defined in .xmls
]] 
local _G = getfenv(0)

local fontFamily = {
    header = {
        path = "Interface\\Addons\\LazyScript\\fonts\\PT-Sans-Narrow-Bold.ttf",
        size = 14,
        flag = "OUTLINE"
    },
    
    body = {
        path = "Interface\\Addons\\LazyScript\\fonts\\PT-Sans-Narrow-Bold.ttf",
        size = 12,
        flag = nil
    },

    -- font for editForm code box 
    code = {
        path = "Interface\\Addons\\LazyScript\\fonts\\Envy-Code-R.ttf",
        size = 12,
        flag = nil
    }
}

local function applyFont(frame, fontType)
    if not frame or not frame.SetFont then
        lazyScript.d("fonts.lua: applyFont: Invalid frame or no SetFont method")
        return false
    end

    local font = fontFamily[fontType]
    
    if not font then
        lazyScript.d("fonts.lua: applyFont: no font defined for type: " .. tostring(fontType))
        return false
    end

    -- apply font 
    frame:SetFont(font.path, font.size or 12, font.flag or nil)
    lazyScript.d("Applied font to frame: " .. tostring(fontType) .. "@" .. font.path)
    return true
end

--[[
custom font applications
]]
function lazyScript.loadFont()
    -- lazyScript.loadFontFamily()
    lazyScript.d("Custom fonts loaded.")
    -- formEdit.xml
end


-- edit frame
applyFont(_G.LazyScriptFormEditFrameTitle, "header")
applyFont(_G.LazyScriptFormEditFrameFormName, "body")
applyFont(_G.LazyScriptFormEditFrameFormNameDescr, "body")
applyFont(_G.LazyScriptFormEditFrameForm, "code")

local editFrameButton = {
    "LazyScriptFormEditFrameHelpButton",
    "LazyScriptFormEditFrameCancelButton",
    "LazyScriptFormEditFrameOkayButton",
    "LazyScriptFormEditFrameTestButton",
}

for _, name in ipairs(editFrameButton) do
    local btn = _G[name]
    if btn then
        applyFont(btn,"body")
    end
end

-- help form
applyFont(_G.LazyScriptFormHelpTitle, "header")
applyFont(_G.LazyScriptFormHelpScrollFrameScrollChildText, "body")
    -- help form subheaders

--[[
    tabs
]]

for i = 1, 5 do
    applyFont(_G["LazyScriptFormHelpTab"..i],"body")
end

for i = 1, 5 do
    applyFont(_G["LazyScriptAboutFrameTab"..i],"body")
end

--[[
    minion
]]

applyFont(_G.LazyScriptMinionText, "body")
applyFont(_G.LazyScriptDeathstimatorText, "body")