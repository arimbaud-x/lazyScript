--[[
FontString:SetTextColor(r,g,b[,a])
FontString:SetText(str)
Button:GetFontString()
Button:GetNormalTexture(), Button:GetPushedTexture(), Button:GetHighlightTexture()
Texture:SetVertexColor(r,g,b[,a]) -- use only after checking
Texture:SetTexture(path) / Button:SetNormalTexture(path)
Frame:SetBackdrop({ ... }) and Frame:SetBackdropBorderColor(r,g,b,a)
]]

local _G = getfenv(0)

local function removeBorder(frame)
    if frame and frame.SetBackdropBorderColor then
        frame:SetBackdropBorderColor(1, 1, 1, 0)
    end
end

local function darkModeBorder(frame)
    if frame and frame.SetBackdropBorderColor then
        frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.5)
    end
end

local function darkModeElement(frame)
    if not frame or not frame.GetRegions then return end
    local regions = { frame:GetRegions() }
    for _, region in ipairs(regions) do
        if region and region.GetObjectType and region:GetObjectType() == "Texture" and region.SetVertexColor then
            region:SetVertexColor(0.5, 0.5, 0.5, 1)
        end
    end
end

--LazyScriptFormEditFrame:SetBackdropBorderColor(0.3,0.3,0.3,0.5)
darkModeBorder(_G.LazyScriptFormEditFrame)
darkModeBorder(_G.LazyScriptFormHelp)

for i = 1, 5 do
    darkModeElement(_G["LazyScriptFormHelpTab"..i])
end

removeBorder(_G.LazyScriptFormEditFrameFormName)
removeBorder(_G.LazyScriptFormScrollFrame)
--removeBorder(LazyScriptFormHelp)

--[[
    removeBorder(LazyScriptFormHelpScrollFrameScrollChildText)
    ]]
    
-- about frame
darkModeBorder(_G.LazyScriptAboutFrame)

for i = 1, 2 do
    darkModeElement(_G["LazyScriptAboutFrameTab"..i])
end

--minion
--[[
    LazyScriptMinionFrame
    LazyScriptMinionFrameBackdrop
    ]]

removeBorder(_G.LazyScriptMinionFrame)
-- dimensions
_G.LazyScriptMinionFrame:SetWidth(120)
_G.LazyScriptMinionFrame:SetHeight(40)
-- remove tooltip fkn annoying
lazyScript.minion.OnEnter = function() end
lazyScript.minion.OnLeave = function() end

_G.LazyScriptMinionFrame:SetBackdrop({
    bgFile = "Interface\\Addons\\LazyScript\\img\\dot.tga",
    tile = false,
    tileSize = 32,
    edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
_G.LazyScriptMinionFrame:SetBackdropColor(0.8, 0.8, 0.8, 0.5)

--deathstimator
removeBorder(_G.LazyScriptDeathstimatorFrame)