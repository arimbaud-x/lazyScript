local _G = getfenv(0)

local Theme = {}

-- #### List of themes
Theme.Colors = {
    -- #####            | border -> border                    | bg -> background                  | bghighlight ->                            | element -> tab buttons
    
    solarizedDark =     { 
        border = {0.027, 0.212, 0.259, 0.6},  
        bg = {0, 0.169, 0.212  , 0.9},      
        bghighlight = {0.027, 0.212, 0.259,0.9},    
        element = {0.027, 0.212, 0.259, 0.6} 
    },
    solarizedLight =    { 
        border = {0.9, 0.9, 0.9, 0},          
        bg = {0.992, 0.965, 0.890, 1},                                                  
        element = {0.992, 0.965, 0.890, 1} 
    },
    pitchBlack = {
        border = {0.02,0.2,0.3,0.6},
        bg = {0.05,0.05,0.05, 0.9},
        bghighlight = {0,0,0,0.9},
        element = {0.2,0.1,0.1,1}
    },
    classic = {
        border = {1,1,1,1},
        bg = {0,0,0,1},
        bghighlight = {1,1,1,1},
        element = {1,1,1,1}
    },
    
    transparent = {1, 1, 1, 0},
    
    minion = {0.8, 0.8, 0.8, 0.5},
}

-- Apply border color from selected theme to frame border
function Theme.border(frame, colorSet)
    if frame and frame.SetBackdropBorderColor then
        frame:SetBackdropBorderColor(unpack(colorSet))
    end
end

-- Apply color to frame background
function Theme.background(frame, colorSet)
    if frame and frame.SetBackdropColor then
        local currentBackdrop = frame:GetBackdrop()
        if currentBackdrop then -- replace backdrop with blank white that can be modified easier
            currentBackdrop.bgFile = "Interface\\BUTTONS\\WHITE8X8"
            frame:SetBackdrop(currentBackdrop)
        end

        frame:SetBackdropColor(unpack(colorSet))
    end
end

-- Apply color to all texture regions within frame
function Theme.regions(frame, colorSet)
    if not frame or not frame.GetRegions then return end
    for _, region in ipairs({ frame:GetRegions() }) do
        if region and region.GetObjectType and region:GetObjectType() == "Texture" and region.SetVertexColor then
            region:SetVertexColor(unpack(colorSet))
        end
    end
end

-- Combined theme application
function Theme.solarizedDark(frame)
    
    if not frame then return end
    Theme.background(frame, Theme.Colors.solarizedDark.bg)
    Theme.border(frame, Theme.Colors.solarizedDark.border)
    Theme.regions(frame, Theme.Colors.solarizedDark.element)
end

function Theme.solarizedDarkHighlight(frame)
    
    if not frame then return end
    Theme.background(frame, Theme.Colors.solarizedDark.bghighlight)
    Theme.border(frame, Theme.Colors.transparent)
end

function Theme.solarizedLight(frame)
    if not frame then return end
    Theme.background(frame, Theme.Colors.solarizedLight.bg)
    Theme.border(frame, Theme.Colors.solarizedLight.border)
    Theme.regions(frame, Theme.Colors.solarizedLight.element)
end

function Theme.clear(frame)
    Theme.border(frame, Theme.Colors.transparent)
end

function Theme.pitchBlack(frame)
    
    if not frame then return end
    Theme.background(frame, Theme.Colors.pitchBlack.bg)
    Theme.border(frame, Theme.Colors.pitchBlack.border)
    Theme.regions(frame, Theme.Colors.pitchBlack.element)
end

--------------------------------------------------------------------
-- #### batch styling frames
local Frames = {
    edit = {
        main = _G.LazyScriptFormEditFrame,
        name = _G.LazyScriptFormEditFrameFormName,
        editbox = _G.LazyScriptFormScrollFrame,
        namebox = _G.LazyScriptFormEditFrameFormName,
    },
    
    help = {
        main = _G.LazyScriptFormHelp,
        tabs = {1,2,3,4,5}
    },
    
    about = {
        main = _G.LazyScriptAboutFrame,
        tabs = {1,2}
    },
    
    minion = _G.LazyScriptMinionFrame,
    deathstimator = _G.LazyScriptDeathstimatorFrame
}

--------------------------------------------------------------------
-- #### running theme applications

-- ##### edit frames
Theme.pitchBlack(Frames.edit.main)
Theme.pitchBlack(Frames.edit.editbox)
Theme.pitchBlack(Frames.edit.namebox)
Theme.clear(Frames.edit.name)

-- ##### help frames
Theme.pitchBlack(Frames.help.main)
for _, i in ipairs(Frames.help.tabs) do
    Theme.pitchBlack(_G["LazyScriptFormHelpTab"..i])
end
-- for _, i in ipairs(Frames.help.tabs.light) do
--     Theme.light(_G["LazyScriptFormHelpTab"..i])
-- end

-- ##### about frames
Theme.pitchBlack(Frames.about.main)
for _, i in ipairs(Frames.about.tabs) do
    Theme.pitchBlack(_G["LazyScriptAboutFrameTab"..i])
end

--------------------------------------------------------------------
-- ##### minion frames
Theme.clear(Frames.minion)
Frames.minion:SetWidth(120)
Frames.minion:SetHeight(40)
Frames.minion:SetBackdrop({
    bgFile = "Interface\\Addons\\LazyScript\\img\\dot.tga",
    tile = false,
    tileSize = 32,
    edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
Frames.minion:SetBackdropColor(unpack(Theme.Colors.minion))

-- Disable minion tooltip
lazyScript.minion.OnEnter = function() end
lazyScript.minion.OnLeave = function() end

-- Deathstimator Frame
Theme.clear(Frames.deathstimator)