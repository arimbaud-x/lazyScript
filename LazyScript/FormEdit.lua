lazyScript.metadata:updateRevisionFromKeyword("$Revision: 700 $")

-- Form Edit Box
lazyScript.formEditBox = {}

lazyScript.formEditBox.currentForm = nil
lazyScript.formEditBox.cancelEdit = false

function lazyScript.formEditBox.OnShow()
    if (not lazyScript.formEditBox.currentForm) then
        lazyScript.formEditBox.currentForm = ""
    end

    LazyScriptFormEditFrameFormName:SetText(lazyScript.formEditBox.currentForm)
    if (lazyScript.formEditBox.currentForm == "") then
        LazyScriptFormEditFrameFormName:SetFocus()
    else
        LazyScriptFormEditFrameForm:SetFocus()
    end

    local actions = lazyScript.perPlayerConf.forms[lazyScript.formEditBox.currentForm]
    local text
    if (actions) then
        text = table.concat(actions, "\n")
    else
        text = ""
    end
    LazyScriptFormEditFrameForm:SetText(text)
end

function lazyScript.formEditBox.OnHide()
    if (lazyScript.formEditBox.cancelEdit) then
        lazyScript.formEditBox.cancelEdit = false
        return
    end

    local name = LazyScriptFormEditFrameFormName:GetText()
    -- convert spaces to underscores
    name = string.gsub(name, "%s+", "_")

    local oldName = lazyScript.formEditBox.currentForm
    local text = LazyScriptFormEditFrameForm:GetText()

    if (not name or name == "" or not text or text == "") then
        return
    end

    -- lazyScript.SlashCommand("set "..name.." "..text)
    -- doing this manually (dup code alert! :-( ) so we can
    -- preserve comments or other goodies
    if (lazyScript.perPlayerConf.forms[name]) then
        verb = FORM_UPDATED
    else
        verb = FORM_CREATED
    end
    local lines = {}
    for line in string.gfind(text, "[^\r\n]+") do
        table.insert(lines, line)
    end
    lazyScript.perPlayerConf.forms[name] = lines
    lazyScript.ClearParsedForm(name)
    lazyScript.FindParsedForm(name)
    lazyScript.p(FORM .. name .. " " .. verb .. ".")

    if (oldName and oldName ~= "" and name ~= oldName) then
        -- user changed the name
        if (lazyScript.perPlayerConf.defaultForm == oldName) then
            lazyScript.SlashCommand("default " .. name)
        end
        lazyScript.SlashCommand("clear " .. oldName)
    end

    lazyScript.formEditBox.currentForm = nil
end

function lazyScript.formEditBox.testForm()
    local name = LazyScriptFormEditFrameFormName:GetText() or ""
    lazyScript.p(TESTING .. name .. FORM_1)
    local text = LazyScriptFormEditFrameForm:GetText()
    local lines = {}
    for line in string.gfind(text, "[^\r\n]+") do
        table.insert(lines, line)
    end
    lazyScript.ParseForm(name, lines)
    lazyScript.p(TESTING_COMPLETED)
end

-- help form
lazyScript.formHelp = {}
lazyScript.formHelp.tabHelpText = {}
--- 
function lazyScript.formHelp.OnLoad()
    PanelTemplates_SetNumTabs(LazyScriptFormHelp, 5) -- changed from 4 -> 5
    LazyScriptFormHelp.selectedTab = 1
    PanelTemplates_UpdateTabs(LazyScriptFormHelp)
end

function lazyScript.formHelp.OnTabButtonClick(tabId, tabName)
    -- lazyScript.p("OnTabButtonClick "..tabId..": "..tabName)

    -- If help text has not been initialized yet, do so.
    if not lazyScript.formHelp.tabHelpText[tabName] then
        lazyScript.formHelp.SetupHelpText()
    end

    local text = lazyScript.formHelp.tabHelpText[tabName]
    LazyScriptFormHelpScrollFrameScrollChildText.currentText = text -- save it for forcing a relayout when resizing
    LazyScriptFormHelpScrollFrameScrollChildText:SetText(text)
    LazyScriptFormHelpScrollFrameScrollBar:SetValue(0);
    LazyScriptFormHelpScrollFrame:UpdateScrollChildRect()
end

function lazyScript.formHelp.SetupHelpText()
    lazyScript.formHelp.SetupOverview()
    lazyScript.formHelp.SetupActions()
    lazyScript.formHelp.SetupCriteria()
    lazyScript.formHelp.SetupBuffsDebuffs()
end
    
--[[ function lazyScript.formHelp.ColorizeBrackets(text)
	text = string.gsub(text, "{",  "|cffff6060{|r")
	text = string.gsub(text, "}",  "|cffff6060}|r")
	text = string.gsub(text, "%[", "|cff8080ff[|r")
	text = string.gsub(text, "%]", "|cff8080ff]|r")
	return text
end ]]

function lazyScript.formHelp.SetupOverview()
    local text = "<HTML><BODY>"

    text = text .. TAB_OVERVIEW_1 -- 'overview'
    text = text .. TAB_OVERVIEW_2 .. "<BR/>"
    text = text .. TAB_OVERVIEW_3 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_1_1
    text = text .. TAB_OVERVIEW_TUTORIAL_1_2 .. "<BR/>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_1_3 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_1_4 .. "<BR/>"
    text = text .. "<P>|cffff770C/lazyscript|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_1_5 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_2_1
    text = text .. TAB_OVERVIEW_TUTORIAL_2_2
    text = text .. TAB_OVERVIEW_TUTORIAL_2_3 .. "<BR/>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_2_4 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_3_1
    text = text .. TAB_OVERVIEW_TUTORIAL_3_2 .. "<BR/>"
    text = text .. "<P>|cffff770Ckick-ifTargetIsCasting|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_3_3 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_3_4
    text = text .. TAB_OVERVIEW_TUTORIAL_3_5 .. "<BR/>"
    text = text .. "<P>|cffff770Ckick-ifTargetIsCasting=FIRE|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_3_6
    text = text .. TAB_OVERVIEW_TUTORIAL_3_7 .. "<BR/>"
    text = text .. "<P>|cffff770Ckick-ifTargetIsCasting=FIRE,FROST|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_3_8
    text = text .. TAB_OVERVIEW_TUTORIAL_3_9 .. "<BR/>"
    text = text .. "<P>|cffff770Ckick-ifTargetIsCasting=Heal,Greater Heal|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_4_1
    text = text .. TAB_OVERVIEW_TUTORIAL_4_2 .. "<BR/>"
    text = text .. "<P>|cffff770Csnd-ifNotPlayerHasBuff=snd|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_4_3 .. "<BR/>"
    text = text .. "<P>|cffff770Crupture-ifNotTargetHasDebuff=rupture|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_4_4
    text = text .. TAB_OVERVIEW_TUTORIAL_4_5 .. "<BR/>"
    text = text .. "<P>|cffff770Cecho=w00t-ifPlayerHasBuffTitle=Rallying Cry of the Dragonslayer|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_4_6
    text = text .. TAB_OVERVIEW_TUTORIAL_4_7 .. "<BR/>"
    text = text .. "<P>|cffff770CstopAll-ifTargetHasDebuff&lt;3=sunder|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_5_1
    text = text .. TAB_OVERVIEW_TUTORIAL_5_2 .. "<BR/>"
    text = text .. "<P>|cffff770CcoldBlood-evisc-sayInSay=DIE!-ifCbKillShot|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_5_3 .. "<BR/>"
    text = text .. "<P>|cffff770ChuntersMark-petAttack|r</P>"
    text = text .. "<P>|cffff770Cjudge-sealCommand|r</P>"
    text = text .. "<P>|cffff770CinnerFocus-greaterHeal|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_1
    text = text .. TAB_OVERVIEW_TUTORIAL_6_2 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_INT
    text = text .. "<P>|cffff770Ckick-ifTargetIsCasting-ifNotTargetIs=Stunned|r</P>"
    text = text .. "<P>|cffff770Cgouge-ifTargetIsCasting-ifNotInFrontAttackJustFailed-ifNotTargetIs=Stunned|r</P>"
    text = text ..
               "<P>|cffff770Cks-ifTargetIsCasting=Greater Heal,Prayer of Healing,Healing Touch,Holy Light,Healing Wave,Chain Heal-ifNotTargetIs=Stunned|r</P>"
    text = text ..
               "<P>|cffff770Cblind-ifTargetIsCasting=Greater Heal,Prayer of Healing,Healing Touch,Holy Light,Healing Wave,Chain Heal-ifNotTargetIs=Stunned|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_FA
    text = text .. "<P>|cffff770CincludeForm=Interrupts|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Cevisc-5cp|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_BA
    text = text .. "<P>|cffff770CincludeForm=Interrupts|r</P>"
    text = text .. "<P>|cffff770Cevisc-5cp|r</P>"
    text = text .. "<P>|cffff770Cbs|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_3 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_4 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_5 .. "<BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_INT
    text = text .. "<P>|cffff770Ckick|r</P>"
    text = text .. "<P>|cffff770Cgouge-ifNotInFrontAttackJustFailed|r</P>"
    text = text ..
               "<P>|cffff770Cks-ifTargetIsCasting=Greater Heal,Prayer of Healing,Healing Touch,Holy Light,Healing Wave,Chain Heal|r</P>"
    text = text ..
               "<P>|cffff770Cblind-ifTargetIsCasting=Greater Heal,Prayer of Healing,Healing Touch,Holy Light,Healing Wave,Chain Heal|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_FA
    text = text .. "<P>|cffff770CcallForm=Interrupts-ifTargetIsCasting-ifNotTargetIs=Stunned|r</P>"
    text = text .. "<P>|cffff770Criposte|r</P>"
    text = text .. "<P>|cffff770Cevisc-5cp|r</P>"
    text = text .. "<P>|cffff770Css|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_FORM_BA
    text = text .. "<P>|cffff770CcallForm=Interrupts-ifTargetIsCasting-ifNotTargetIs=Stunned|r</P>"
    text = text .. "<P>|cffff770Cevisc-5cp|r</P>"
    text = text .. "<P>|cffff770Cbs|r</P><BR/>"
    text = text .. TAB_OVERVIEW_TUTORIAL_6_6 .. "<BR/>"
    text = text .. "</BODY></HTML>"

    lazyScript.formHelp.tabHelpText[Overview] = text
end

function lazyScript.formHelp.SetupActions()
    local text = "<HTML><BODY>"
    text = text .. TAB_LIST_ACTIONS
    text = text .. TAB_ACTIONS_SYNTAX_SPECIFIC_SPELL_RANK
    text = text .. "<P>|cffff770Caction|r[|cffff770C(rankXX)|r][|cffff770C@&lt;UnitId&gt;|r]</P>"
    text = text .. TAB_ACTIONS_SYNTAX_SPECIFIC_SPELL_RANK_1
    text = text .. TAB_ACTIONS_GREEN_ACTIONS
    local actionList = {}
    for actionName, actionObj in pairs(lazyScript.actions) do
        local actionNameText = actionName
        if (actionObj.triggersGlobal == false) then
            actionNameText = "|cff40ff40" .. actionNameText .. "|r"
        end
        table.insert(actionList,
            "|cffffffff" .. (lazyScript.actions[actionName]["name"] or lazyScript.actions[actionName]["code"]) ..
                "|r = " .. actionNameText)
    end
    table.sort(actionList)
    text = text .. TAB_FULL_SHORT_NAME
    text = text .. "<P>" .. table.concat(actionList, "</P><P>") .. "</P><BR/>"

    actionList = {}
    for actionName, actionObj in pairs(lazyScript.comboActions) do
        local actionNameText = actionName
        if (actionObj.triggersGlobal == false) then
            actionNameText = "|cff40ff40" .. actionNameText .. "|r"
        end
        table.insert(actionList,
            "|cffffffff" .. (lazyScript.comboActions[actionName]["name"] or lazyScript.comboActions[actionName]["code"]) ..
                "|r = " .. actionNameText)
    end
    table.sort(actionList)
    if table.getn(actionList) >= 1 then
        text = text .. TAB_ACTIONS_COMBO
        text = text .. "<P>" .. table.concat(actionList, "</P><P>") .. "</P><BR/>"
    end

    actionList = {}
    for actionName, actionObj in pairs(lazyScript.shapeshift) do
        local actionNameText = actionName
        if (actionObj.triggersGlobal == false) then
            actionNameText = "|cff40ff40" .. actionNameText .. "|r"
        end
        table.insert(actionList,
            "|cffffffff" .. (lazyScript.shapeshift[actionName]["name"] or lazyScript.shapeshift[actionName]["code"]) ..
                "|r = " .. actionNameText)
    end
    table.sort(actionList)
    if table.getn(actionList) >= 1 then
        text = text .. TAB_ACTIONS_OTHER
        text = text .. "<P>" .. table.concat(actionList, "</P><P>") .. "</P><BR/>"
    end

    actionList = {}
    for actionName, actionObj in pairs(lazyScript.pseudoActions) do
        local actionNameText = actionName
        if (actionObj.triggersGlobal == false) then
            actionNameText = "|cff40ff40" .. actionNameText .. "|r"
        end
        table.insert(actionList,
            "|cffffffff" ..
                (lazyScript.pseudoActions[actionName]["name"] or lazyScript.pseudoActions[actionName]["code"]) ..
                "|r = " .. actionNameText)
    end
    table.sort(actionList)
    if table.getn(actionList) >= 1 then
        text = text .. TAB_ACTIONS_SPECIAL
        text = text .. "<P>" .. table.concat(actionList, "</P><P>") .. "</P><BR/>"
    end

    if (lazyScript.CustomActionHelp) then
        text = text .. lazyScript.CustomLocaleActionHelp()
        text = text .. lazyScript.CustomActionHelp()
    end

    text = text .. "<BR/>" .. TAB_ACTIONS_PARAMETERS
    text = text .. TAB_ACTIONS_PARAMETERS_1 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_2 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_3 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_4 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_5 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_6 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_7 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_8 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_9 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_10 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_11 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_12 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_13 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_14 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_15 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_16 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_17 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_18 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_19 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_20 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_21 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_22
    text = text .. TAB_ACTIONS_PARAMETERS_23 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_24 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_25 .. "<BR/>"
    text = text .. TAB_ACTIONS_PARAMETERS_26
    text = text .. "<BR/></BODY></HTML>"

    -- text = lazyScript.formHelp.ColorizeBrackets(text)
    lazyScript.formHelp.tabHelpText[Actions] = text
end

function lazyScript.formHelp.SetupCriteria()
    local text = "<HTML><BODY>"
    text = text .. TAB_LIST_CRITERIA
    text = text .. TAB_CRITERIA_1
    text = text .. TAB_CRITERIA_2 .. "<BR/>"

    -- Only criteria need special help text
    if (lazyScript.CustomHelp) then
        text = text .. lazyScript.CustomLocaleHelp()
        text = text .. lazyScript.CustomHelp()
    end

    text = text .. "<BR/>" .. TAB_CRITERIA_ACTION
    text = text .. "<P>-everyXXs</P>"
    text = text .. "<P>-if[Not]{Ctrl,Alt,Shift}Down |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #1)|r</P>"
    text = text .. "<P>-if[Not]Cooldown{&lt;,&gt;}XXs={action1,action2,...}</P>"
    text = text .. "<P>-if[Not]CurrentAction[=action1,action2,...]</P>"
    text = text .. "<P>-if[Not]GlobalCooldown |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #8)</P>"
    text = text .. "<P>-if[Not]History{&lt;,=,&gt;}XX=action</P>"
    text = text .. "<P>-if[Not]HistoryCount{&lt;,=,&gt;}XX=action</P>"
    text = text .. "<P>-if[Not]LastAction=action</P>"
    text = text .. "<P>-if[Not]LastUsed&gt;XXs=action |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #10)|r</P>"
    text = text .. "<P>-if[Not]InCooldown={action1,action2,...}</P>"
    text = text .. "<P>-if[Not]InRange={action1,action2,...} |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #2)|r</P>"
    text = text .. "<P>-if[Not]Timer&gt;XXs=action |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #10)|r</P>"
    text = text .. "<P>-if[Not]Usable={action1,action2,...} |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #7)|r</P><BR/>"
    text = text .. TAB_CRITERIA_ATTACK
    text = text .. "<P>-if[Not]BehindAttackJustFailed[X[.Y]s] |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #3)|r</P>"
    text = text .. "<P>-if[Not]InFrontAttackJustFailed[X[.Y]s] |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #3)|r</P>"
    text = text .. "<P>-if[Not]OutdoorsAttackJustFailed[X[.Y]s] |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #3)|r</P>"
    text = text .. "<P>-if[Not]Casting</P>"
    text = text .. "<P>-if[Not]Channelling</P>"
    text = text .. "<P>-if[Not]Shooting</P>"
    text = text .. "<P>-if[Not]Wanding</P><BR/>"
    text = text .. TAB_CRITERIA_BUFF_DEBUFF
    text = text .. "<P>-if[Not]{Buff,Debuff}Duration{&lt;,&gt;}XXs={buff1,buff2,...} |cffffff00(" ..
               TAB_CRITERIA_PLAYER_ONLY .. ")|r</P>"
    text = text .. "<P>-if[Not]{Buff,Debuff}TitleDuration{&lt;,&gt;}XXs={buffTitle1,buffTitle2,...} |cffffff00(" ..
               TAB_CRITERIA_SEE_NOTE .. " #4, " .. TAB_CRITERIA_PLAYER_ONLY .. ")|r</P>"
    text = text ..
               "<P>-if[Not][|cff00ffff&lt;UnitId&gt;|r]Has{Buff,Debuff}[{&lt;,=,&gt;}XX]={buff1,buff2,...} |cffffff00(" ..
               TAB_CRITERIA_SEE_NOTES .. " #5 " .. TAB_CRITERIA_AND .. " #9)|r</P>"
    text = text ..
               "<P>-if[Not][|cff00ffff&lt;UnitId&gt;|r]Has{Buff,Debuff}Title[{&lt;,=,&gt;}XX]={buffTitle1,buffTitle2,...} |cffffff00(" ..
               TAB_CRITERIA_SEE_NOTES .. " #4, #5, " .. TAB_CRITERIA_AND .. " #9)|r</P>"
    text = text ..
               "<P>-if[Not][|cff00ffff&lt;UnitId&gt;|r]Is={Asleep, Bleeding, CCd, Charmed, Cursed, Diseased, Disoriented, Dotted, Drinking, Eating, Feared, Immobile, Incapacitated, Magicked, Poisoned, Polymorphed, Slowed, Stunned, Stung} |cffffff00(" ..
               TAB_CRITERIA_SEE_NOTE .. " #9)|r</P>"
    text = text .. "<P>-if[Not]{MainHand, OffHand}Buffed</P><BR/>"
    text = text .. TAB_CRITERIA_ITEM
    text = text .. "<P>-if[Not]ItemCooldown{&lt;,&gt;}XXs={item1,item2,...}</P>"
    text = text .. "<P>-if[Not]ItemInCooldown={item1,item2,...}</P><BR/>"
    text = text .. TAB_CRITERIA_PLAYER
    text = text .. "<P>-if[Not]Dueling</P>"
    text = text .. "<P>-if[Not]Equipped=item</P>"
    text = text .. "<P>-if[Not]Ganked</P>"
    text = text .. "<P>-if[Not]InGroup |cffffff00(" .. TAB_CRITERIA_PARTY_OR_RAID .. ")|r</P>"
    text = text .. "<P>-if[Not]InInstance</P>"
    text = text .. "<P>-if[Not]InBattleground</P>"
    text = text .. "<P>-if[Not]InRaid</P>"
    text = text .. "<P>-if[Not]Mounted</P>"
    text = text .. "<P>-if[Not]Shadowmelded</P>"
    text = text .. "<P>-if[Not]Tracking={Herbs, Minerals, Treasure}</P>"
    text = text .. "<P>-if[{&lt;,=,&gt;}]XAttackers |cffffff00(" .. TAB_CRITERIA_PVP_ONLY .. ")|r</P>"
    text = text .. "<P>-if[Not]Zone=zonename</P><BR/>"
    text = text .. TAB_CRITERIA_PET
    text = text .. "<P>-if[Not]HasPet</P>"
    text = text .. "<P>-if[Not]PetAlive</P>"
    text = text .. "<P>-if[Not]Pet{Attacking, Following, Staying, Aggressive, Defensive, Passive}</P>"
    text = text ..
               "<P>-if[Not]PetFamily={Bat, Bear, Boar, Carrion Bird, Cat, Crab, Crocolisk, Doomguard, Felhunter, Gorilla, Hyena, Imp, Infernal, Owl, Raptor, Scorpid, Spider, Succubus, Tallstrider, Turtle, Voidwalker, Windserpent, Wolf}</P>"
    text = text .. "<P>-if[Not]PetName=name</P><BR/>"
    text = text .. TAB_CRITERIA_PARTY_PET_TARGET
    text = text .. "<P>-if[Not]{[Player],Target}{Blocked, Dodged, Parried, Resisted}[{&lt;,&gt;}XX.XXs] |cffffff00(" ..
               TAB_CRITERIA_DEFAULT .. TAB_CRITERIA_SEE_NOTE .. " #11)|r</P>"
    text = text .. "<P>-if[Not]{[Player],Target}FlaggedPVP</P>"
    text = text .. "<P>-if[Not]{[Player],Target}FlagRunner</P>"
    text = text .. "<P>-if[Not]{[Player],Pet,Target}InCombat</P>"
    text = text ..
               "<P>-if[|cff00ffff&lt;UnitId&gt;|r]{&lt;,=,&gt;}XX[%]{hp,mana/energy/rage/focus}[Deficit] |cffffff00(" ..
               TAB_CRITERIA_SEE_NOTE .. " #9)|r</P>"
    text = text ..
               "<P>-if[Not]{[Player],Target}Race={Human, Night Elf, Gnome, Dwarf, Orc, Scourge/Undead, Tauren, Troll}</P>"
    text = text ..
               "<P>-if[Not]PartyHaveClass={Druid, Hunder, Mage, Paladin, Priest, Rogue, Shaman, Warlock, Warrior}</P><BR/>"
    text = text .. TAB_CRITERIA_TARGET
    text = text .. "<P>-if[Not]CanDebuff</P>"
    text = text .. "<P>-if[Not]HaveTarget</P>"
    text = text .. "<P>-if[Not]TargetAlive</P>"
    text = text .. "<P>-if[Not]TargetAttackable</P>"
    text = text .. "<P>-if[Not]TargetBoss</P>"
    text = text .. "<P>-if[Not]TargetClass={Druid, Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock, Warrior}</P>"
    text = text .. "<P>-if[Not]TargetElite</P>"
    text = text .. "<P>-if[Not]TargetEnemy</P>"
    text = text .. "<P>-if[Not]TargetFleeing |cffffff00(" .. TAB_CRITERIA_NPC_ONLY .. ")|r</P>"
    text = text .. "<P>-if[Not]TargetFriend</P>"
    text = text .. "<P>-if[Not]TargetHasTarget</P>"
    text = text .. "<P>-if[Not]TargetHostile</P>"
    text = text .. "<P>-if[Not]TargetIsCasting[={name regex,FIRE,FROST,NATURE,SHADOW,ARCANE,HOLY}]</P>"
    text = text .. "<P>-if[Not]TargetImmune[=action]</P>"
    text = text .. "<P>-if[Not]TargetInBlindRange |cffffff00(" .. TAB_CRITERIA_WITHIN .. " 10 " .. TAB_CRITERIA_YARDS ..
               ")|r</P>"
    text = text .. "<P>-if[Not]TargetInLongRange |cffffff00(" .. TAB_CRITERIA_WITHIN .. " 28 " .. TAB_CRITERIA_YARDS ..
               ")|r</P>"
    text =
        text .. "<P>-if[Not]TargetInMediumRange |cffffff00(" .. TAB_CRITERIA_WITHIN .. " 10 " .. TAB_CRITERIA_YARDS ..
            ")|r</P>"
    text = text .. "<P>-if[Not]TargetInMeleeRange |cffffff00(" .. TAB_CRITERIA_SEE_NOTE .. " #6)|r</P>"
    text = text .. "<P>-if[Not]TargetLevel{&lt;,=,&gt;}XX |cffffff00(" .. TAB_CRITERIA_NOT_WORK_BOSS .. ")|r</P>"
    text = text .. "<P>-if[Not]TargetMyLevel{&lt;,=,&gt;}{plus,minus}XX |cffffff00(" .. TAB_CRITERIA_NOT_WORK_BOSS ..
               ")|r</P>"
    text = text .. "<P>-if[Not]TargetNamed={regex1,regex2,...}</P>"
    text = text .. "<P>-if[Not]TargetNPC</P>"
    text = text .. "<P>-if[Not]TargetOfTarget</P>"
    text = text ..
               "<P>-if[Not]TargetOfTargetClass={Druid, Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock, Warrior}</P>"
    text = text .. "<P>-if[Not]TargetTrivial</P>"
    text = text .. "<P>-if[Not]TargetType={Beast, Critter, Demon, Dragonkin, Elemental, Humanoid, Undead}</P>"
    text = text .. "<P>-ifTimeToDeath{&lt;,=,&gt;}XXs</P>"
    text = text .. "<P>-if[Not]UnitExists=[|cff00ffff&lt;UnitId&gt;|r]</P><BR/>"

    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_1
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_2
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_3
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_4
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_5
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_6
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_7
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_8
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_8_CLASSES
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_9
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_10
    text = text .. "<BR/>" .. TAB_CRITERIA_CUSTOM_HELP_11
    text = text .. "<BR/></BODY></HTML>"

    -- text = lazyScript.formHelp.ColorizeBrackets(text)

    lazyScript.formHelp.tabHelpText[Criteria] = text
end

function lazyScript.formHelp.SetupBuffsDebuffs()
    local text = "<HTML><BODY>"
    text = text .. TAB_LIST_BUFFS_DEBUFFS
    text = text .. TAB_BUFFS_DEBUFFS_USED
    text = text .. TAB_FULL_SHORT_NAME
    local buffList = {}
    for buffName in pairs(lazyScript.buffTable) do
        table.insert(buffList,
            "|cffffffff" .. lazyScript.safeString(lazyScript.buffTable[buffName]["name"]) .. "|r = " .. buffName)
    end
    table.sort(buffList)

    text = text .. "<P>" .. table.concat(buffList, "</P><P>") .. "</P>"
    text = text .. "<BR/></BODY></HTML>"

    lazyScript.formHelp.tabHelpText[Buffs_Debuffs] = text
end

--[[
new tab
for undocumented features
]]

-- function lazyScript.formHelp.SetupExtras()
-- 	local text = "<HTML><BODY>"
-- 	text = text.."<H1>|cffffffffExtra documentation|r</H1><BR/>"
-- 	text = text.."<H2>|cffffffffValid UnitIDs|r</H2><BR/>"
-- 	text = text.."<P>The following unit IDs can be used in actions that require a target unit (e.g., action{@&lt;UnitId&gt;}):</P>"
-- 	local displayUnitIds = {
-- 		"player",
-- 		"pet",
-- 		"party1, party2, party3, party4",
-- 		"partypet1, partypet2, partypet3, partypet4",
-- 		"raid[1-40]",
-- 		"raidpet[1-40]",
-- 		"target",
-- 		"targettarget",
-- 		"mouseover"
-- 	}
-- 	local unitIdList = {}
-- 	for _, unitId in ipairs(displayUnitIds) do
-- 		table.insert(unitIdList, unitId)
-- 	end
-- 	text = text.."<P>"..table.concat(unitIdList, "</P><P>").."</P>"
-- 	text = text.."<H1>New Features:</H1><BR/>"
-- 	text = text.."<P> - /ls command for use in macros, e.g., '/ls do ss' </P>"
--     text = text.."<P> - (smart) tag; if you are using LazySpell, this tag will replace the rank of spell for Lazyspell calculation, e.g., '/ls do heal(smart)@mouseOver'</P>"
--     text = text.."<P> - if(Not)GotTalent=Talent1,Talent2 critera</P>"
--     text = text.."<P> - Support for LUNA, pfUI, NotGrid unitframes in mouseover actions</P>"
-- 	text = text.."<P> - frostNova and frostbite to known debuffs</P>"
-- 	text = text.."<P> - if(Not)PartyHaveClass criteria; e.g., 'sayInParty=No Totem!-ifPartyHaveClass=shaman'</P>"
-- 	text = text.."<P> - active=message action; this action will indicate what script is active, e.g., 'active=solo-every2s'. This message will pop-up in a small window for about 1 second.</P>"
-- 	text = text.."<P> - if(Not)OnCooldown; added as an alternative for ifInCooldown for grammatic consistency</P>"
-- 	text = text.."<P> - if(Not)AutoShotSafe; this mask will try not to clip autoshots [Hunter only] [Quiver Required]. Mileage may vary according to lag.</P>"
-- 	text = text.."<P> - if(Not)SwingSafe; this mask will try not to clip weapon swings [SP_SwingTimer Required].</P>"

-- 	--[[
-- 	sayInParty=NoTotem-ifPartyHaveClass=shaman
-- 	- Added ifShieldEquipped criteria
-- 	- Added action active=msg ucan use it to indicate what script is active now
-- 	example active-solo-every2s
-- 	- Added `Zeal` buff\debuff
-- 	]]
-- 	text = text.."<BR/><H1>PlaySound Action</H1><BR/>"
-- 	text = text.."<P>The playSound action plays a sound file. Syntax:</P>"
-- 	text = text.."<P>|cff40ff40playSound|r={soundName}</P><BR/>"
-- 	text = text.."<P>Valid sound names include |cffff6060(note: some have deliberate typos that work in-game)|r:</P>"
-- 	local VALID_SOUND_NAMES = {
-- 	"ACTIONBARBUTTONDOWN",
-- 	"AUCTIONWINDOWCLOSE",
-- 	"AUCTIONWINDOWOPEN",
-- 	"BAGMENUBUTTONPRESS",
-- 	"Deathbind Sound",
-- 	"DwarfExploration",
-- 	"Fishing Reel in",
-- 	"FriendJoinGame",
-- 	"GAMEABILITYACTIVATE",
-- 	"GAMEABILITYBUTTONMOUSEDOWN",
-- 	"GAMEERRORINVALIDTARGET",
-- 	"GAMEERROROUTOFMANA",
-- 	"GAMEERROROUTOFRANGE",
-- 	"GAMEERRORUNABLETOEQUIP",
-- 	"GAMEDIALOGCLOSE",
-- 	"GAMEDIALOGOPEN",
-- 	"GAMEGENERICBUTTONPRESS",
-- 	"GAMEHIGHLIGHTFRIENDLYUNIT",
-- 	"GAMEHIGHLIGHTHOSTILEUNIT",
-- 	"GAMEHIGHLIGHTNEUTRALUNIT",
-- 	"GAMEINITIALATTACK",
-- 	"GAMENEWWINDOWTAB",
-- 	"GAMESCREENLARGEBUTTONMOUSEDOWN",
-- 	"GAMESCREENLARGEBUTTONMOUSEOVER",
-- 	"GAMESCREENLARGEBUTTONMOUSEUP",
-- 	"GAMESCREENMEDIUMBUTTONMOUSEDOWN",
-- 	"GAMESCREENMEDIUMBUTTONMOUSEOVER",
-- 	"GAMESCREENMEDIUMBUTTONMOUSEUP",
-- 	"GAMESCREENSMALLBUTTONMOUSEDOWN",
-- 	"GAMESCREENSMALLBUTTONMOUSEOVER",
-- 	"GAMESCREENSMALLBUTTONMOUSEUP",
-- 	"GAMESPELLACTIVATE",
-- 	"GAMESPELLBUTTONMOUSEDOWN",
-- 	"GAMETARGETFRIENDLYUNIT",
-- 	"GAMETARGETHOSTILEUNIT",
-- 	"GAMETARGETNEUTRALUNIT",
-- 	"GAMEWINDOWCLOSE",
-- 	"GAMEWINDOWOPEN",
-- 	"GLUECHARCUSTOMIZATIONMOUSEDOWN",
-- 	"GLUECHARCUSTOMIZATIONMOUSEOVER",
-- 	"GLUECHARCUSTOMIZATIONMOUSEUP",
-- 	"GLUECHECKBOXMOUSEDOWN",
-- 	"GLUECHECKBOXMOUSEOVER",
-- 	"GLUECHECKBOXMOUSEUP",
-- 	"GLUECREATECHARACTERBUTTON",
-- 	"GLUEENTERWORLDBUTTON",
-- 	"GLUEGENERICBUTTONPRESS",
-- 	"GLUESCREENEDITBOXKEYCLICK",
-- 	"GLUESCREENLARGEBUTTONMOUSEDOWN",
-- 	"GLUESCREENLARGEBUTTONMOUSEOVER",
-- 	"GLUESCREENLARGEBUTTONMOUSEUP",
-- 	"GLUESCREENMEDIUMBUTTONMOUSEDOWN",
-- 	"GLUESCREENMEDIUMBUTTONMOUSEOVER",
-- 	"GLUESCREENMEDIUMBUTTONMOUSEUP",
-- 	"GLUESCREENSMALLBUTTONMOUSEDOWN",
-- 	"GLUESCREENSMALLBUTTONMOUSEOVER",
-- 	"GLUESCREENSMALLBUTTONMOUSEUP",
-- 	"GLUESCROLLBUTTONMOUSEDOWN",
-- 	"GLUESCROLLBUTTONMOUSEOVER",
-- 	"GLUESCROLLBUTTONMOUSEUP",
-- 	"GLUESOCIALCLOSE",
-- 	"GLUESOCIALOPEN",
-- 	"GnomeExploration",
-- 	"gsCharacterCreationCancel",
-- 	"gsCharacterCreationClass",
-- 	"gsCharacterCreationCreateChar",
-- 	"gsCharacterCreationGender",
-- 	"gsCharacterCreationLook",
-- 	"gsCharacterCreationRace",
-- 	"gsCharacterSelection",
-- 	"gsCharacterSelectionAcctOptions",
-- 	"gsCharacterSelectionCreateNew",
-- 	"gsCharacterSelectionDelCharacter",
-- 	"gsCharacterSelectionEnterWorld",
-- 	"gsCharacterSelectionExit",
-- 	"gsLogin",
-- 	"gsLoginChangeRealm",
-- 	"gsLoginChangeRealmCancel",
-- 	"gsLoginChangeRealmOK",
-- 	"gsLoginChangeRealmSelect",
-- 	"gsLoginExit",
-- 	"gsLoginNewAccount",
-- 	"gsTitleCredits",
-- 	"gsTitleEnterWorld",
-- 	"gsTitleIntroMovie",
-- 	"gsTitleOK",
-- 	"gsTitleOption16bit",
-- 	"gsTitleOption32bit",
-- 	"gsTitleOptionDirect3D",
-- 	"gsTitleOptionExit",
-- 	"gsTitleOptionFullScreenMode",
-- 	"gsTitleOptionOK",
-- 	"gsTitleOptionOpenGL",
-- 	"gsTitleOptionScreenResolution",
-- 	"gsTitleOptions",
-- 	"gsTitleQuit",
-- 	"HumanExploration",
-- 	"igAbilityClose",
-- 	"igAbilityIconDrop",
-- 	"igAbilityIconPickup",
-- 	"igAbilityOpen",
-- 	"igAbiliityPageTurn",
-- 	"igBackPackClose",
-- 	"igBackPackCoinCancel",
-- 	"igBackPackCoinOK",
-- 	"igBackPackCoinSelect",
-- 	"igBackPackOpen",
-- 	"igBonusBarOpen",
-- 	"igCharacterInfoClose",
-- 	"igCharacterInfoOpen",
-- 	"igCharacterInfoScrollDown",
-- 	"igCharacterInfoScrollUp",
-- 	"igCharacterInfoTab",
-- 	"igCharacterNPCDeselect",
-- 	"igCharacterNPCSelect",
-- 	"igCharacterSelect",
-- 	"igCharacterDeselect",
-- 	"igChatBottom",
-- 	"igChatEmoteButton",
-- 	"igChatScrollDown",
-- 	"igChatScrollUp",
-- 	"igCreatureAggroDeselect",
-- 	"igCreatureAggroSelect",
-- 	"igCreatureNeutralDeselect",
-- 	"igCreatureNeutralSelect",
-- 	"igCurrentActiveSpell",
-- 	"igInventoryClose",
-- 	"igInventoryOepn",
-- 	"igInventoryRotateCharacter",
-- 	"igMainMenuClose",
-- 	"igMainMenuContinue",
-- 	"igMainMenuLogout",
-- 	"igMainMenuOpen",
-- 	"igMainMenuOption",
-- 	"igMainMenuOptionCheckBoxOff",
-- 	"igMainMenuOptionCheckBoxOn",
-- 	"igMainMenuOptionFaerTab",
-- 	"igMainMenuQuit",
-- 	"igMiniMapClose",
-- 	"igMiniMapOpen",
-- 	"igMiniMapZoomIn",
-- 	"igMiniMapZoomOut",
-- 	"igPlayerInvite",
-- 	"igPlayerInviteAccept",
-- 	"igPlayerInviteDecline",
-- 	"igPVPUpdate",
-- 	"igQuestCancel",
-- 	"igQuestFailed",
-- 	"igQuestListClose",
-- 	"igQuestListComplete",
-- 	"igQuestListOpen",
-- 	"igQuestListSelect",
-- 	"igQuestLogAbandonQuest",
-- 	"igQuestLogClose",
-- 	"igQuestLogOpen",
-- 	"igSocialClose",
-- 	"igSocialOepn",
-- 	"igSpellBookClose",
-- 	"igSpellBookOpen",
-- 	"igSpellBookSpellIconDrop",
-- 	"igSpellBookSpellIconPickup",
-- 	"igSpellBokPageTur",
-- 	"INTERFACESOUND_BACKPACKCLOSE",
-- 	"INTERFACESOUND_BACKPACKOPEN",
-- 	"INTERFACESOUND_CHARWINDOWCLOSE",
-- 	"INTERFACESOUND_CHARWINDOWOPEN",
-- 	"INTERFACESOUND_CHARWINDOWTAB",
-- 	"INTERFACESOUND_CURSORGRABOBJECT",
-- 	"INTERFACESOUND_CURSORDROPOBJECT",
-- 	"INTERFACESOUND_GAMEMENUCLOSE",
-- 	"INTERFACESOUND_GAMEMENUOPEN",
-- 	"INTERFACESOUND_GAMESCROLLBUTTON",
-- 	"INTERFACESOUND_LOSTTARGETUNIT",
-- 	"INTERFACESOUND_MONEYFRAMECLOSE",
-- 	"INTERFACESOUND_MONEYFRAMEOPEN",
-- 	"ITEMARMORSOUND",
-- 	"ITEMGENERICSOUND",
-- 	"ITEMWEAPONSOUND",
-- 	"LEVELUP",
-- 	"LEVELUPSOUND",
-- 	"LOOTWINDOWCLOSE",
-- 	"LOOTWINDOWCOINSOUND",
-- 	"LOOTWINDOWOPEN",
-- 	"LOOTWINDOWOPENEMPTY",
-- 	"MAINBUTTONBARMENU",
-- 	"MapPing",
-- 	"MINIMAPCLOSE",
-- 	"MINIMAPOPEN",
-- 	"MINIMAPZOOMIN",
-- 	"MINIMAPZOOMOUT",
-- 	"MONEYFRAMECLOSE",
-- 	"MONEYFRAMEOPEN",
-- 	"NightElfExploration",
-- 	"OrcExploration",
-- 	"PAPERDOLLCLOSE",
-- 	"PAPERDOLLOPEN",
-- 	"PVPENTERQUEUE",
-- 	"PVPTHROUGHQUEUE",
-- 	"QUESTADDED",
-- 	"QUESTCOMPLETED",
-- 	"QUESTLOGCLOSE",
-- 	"QUESTLOGOPEN",
-- 	"RaidWarning",
-- 	"ReadyCheck",
-- 	"SHEATHINGMETALWEAPONUNSHEATHE",
-- 	"SHEATHINGMETALWEAPONSHEATHE",
-- 	"SHEATHINGSHIELDUNSHEATHE",
-- 	"SHEATHINGSHIELDSHEATHE",
-- 	"SHEATHINGWOODWEAPONUNSHEATHE",
-- 	"SHEATHINGWOODWEAPONSHEATHE",
-- 	"SPELLBOOKCHANGEPAGE",
-- 	"SPELLBOOKCLOSE",
-- 	"SPELLBOOKOPEN",
-- 	"TalentScreenClose",
-- 	"TalentScreenOpen",
-- 	"TaxiNodeDiscovered",
-- 	"TaurenExploration",
-- 	"TellMessage",
-- 	"TrollExploration",
-- 	"UChatScrollButton",
-- 	"UndeadExploration",
-- 	"UnwrapGift",
-- 	"WriteQuest"
-- 	}

-- 	local soundList = {}
-- 	for _, soundName in ipairs(VALID_SOUND_NAMES) do
-- 		local displayName = soundName
-- 		-- Highlight known typos with different color
-- 		if soundName == "igSocialOepn" or soundName == "igInventoryOepn" then
-- 			displayName = "|cffff6060" .. soundName .. "|r"  -- Red color for typos
-- 		else
-- 			displayName = "|cffffffff" .. soundName .. "|r"
-- 		end
-- 		table.insert(soundList, displayName)
-- 	end
-- 	text = text.."<P>"..table.concat(soundList, "</P><P>").."</P>"
-- 	text = text.."<BR/></BODY></HTML>"

-- 	lazyScript.formHelp.tabHelpText[Extras] = text
-- end
