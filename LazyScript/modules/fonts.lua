local _G = getfenv(0)

local ADDON_PATH = "Interface\\Addons\\LazyScript\\fonts\\"

local FONT_FILES = {
    PTSans   = ADDON_PATH .. "PT-Sans-Narrow-Bold.ttf",
    EnvyCode = ADDON_PATH .. "Envy-Code-R.ttf",
}

-- #### font object factory
local function CreateLSFont(name, base, path, size, flags)
    local f = CreateFont(name)
    f:SetFontObject(base)
    f:SetShadowColor(0, 0, 0, 0)
    f:SetFont(path, size, flags)
    return f
end

-- --------------------------------------------------------------------
-- #### font objects
CreateLSFont(
    "LS_Font_Header",
    GameFontHighlightLarge,
    FONT_FILES.PTSans,
    14,
    "OUTLINE"
)

CreateLSFont(
    "LS_Font_Body",
    GameFontHighlightLarge,
    FONT_FILES.PTSans,
    12,
    "THICK"
)

CreateLSFont(
    "LS_Font_Code",
    GameFontHighlightLarge,
    FONT_FILES.EnvyCode,
    11,
    "THICK"
)

-- --------------------------------------------------------------------
-- #### font object applier
local function ApplyFontObject(frame, fontObject)
    if not frame then return end

    local font = _G[fontObject]

    -- Case 1: FontString
    if frame.SetFontObject then
        frame:SetFontObject(font)
        return
    end

    -- Case 2: Button / TabButton
    if frame.SetNormalFontObject then
        frame:SetNormalFontObject(font)
        frame:SetHighlightFontObject(font)
        frame:SetDisabledFontObject(font)
        return
    end

    -- Case 3: EditBox
    if frame.SetFont then
        local p, s, f = font:GetFont()
        frame:SetFont(p, s, f)
    end
end

-- --------------------------------------------------------------------
-- #### font mapping 
local FONT_MAP = {
    LS_Font_Header = {
        "LazyScriptFormEditFrameTitle",
        "LazyScriptFormHelpTitle",
    },

    LS_Font_Body = {
        "LazyScriptFormEditFrameFormName",
        "LazyScriptFormEditFrameFormNameDescr",
        "LazyScriptFormEditFrameHelpButton",
        "LazyScriptFormEditFrameCancelButton",
        "LazyScriptFormEditFrameOkayButton",
        "LazyScriptFormEditFrameTestButton",
        "LazyScriptMinionText",
        "LazyScriptDeathstimatorText",
    },

    LS_Font_Code = {
        "LazyScriptFormEditFrameForm",
    },
}

-- #### font mapping 
-- ##### tabs  
local TAB_PATTERNS = {
    { "LazyScriptFormHelpTab", 5 },
    { "LazyScriptAboutFrameTab", 5 },
}

-- --------------------------------------------------------------------
-- #### simplehtml font applier
local function SetupHTMLFonts()
    local html = _G.LazyScriptFormHelpScrollFrameScrollChildText
    if not html then return end
    html:SetShadowColor(0, 0, 0, 0) -- otherwise p inherits a shadow 
    html:SetFont("H1", FONT_FILES.PTSans,   18, "")
    html:SetTextColor("H1", 0.58,0.63,0.63)
    html:SetFont("H2", FONT_FILES.PTSans,   14, "")
    html:SetTextColor("H2", 0.4,0.48,0.51)
    html:SetFont("H3", FONT_FILES.EnvyCode, 11, "")
    html:SetTextColor("H3", 0.71,0.54,0)
    html:SetFont("P",  FONT_FILES.PTSans,   12, "")
    html:SetTextColor("P", 0.51,0.58,0.59)


end

-- --------------------------------------------------------------------
-- #### public font init function
function lazyScript.LoadFonts()
    -- Apply static mappings
    for fontObject, frames in pairs(FONT_MAP) do
        for i = 1, table.getn(frames) do
            ApplyFontObject(_G[frames[i]], fontObject)
        end
    end

    -- Apply tab patterns
    for i = 1, table.getn(TAB_PATTERNS) do
        local prefix, count = TAB_PATTERNS[i][1], TAB_PATTERNS[i][2]
        for n = 1, count do
            ApplyFontObject(_G[prefix .. n], "LS_Font_Body")
        end
    end

    SetupHTMLFonts()
end
-- --------------------------------------------------------------------
-- #### run
lazyScript.LoadFonts()