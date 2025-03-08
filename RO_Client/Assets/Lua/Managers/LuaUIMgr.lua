local LuaUIMgr = class("LuaUIMgr", function()
    return UIMgr.Instance
end)

local oldSlot
local UIOpenStatusList = {}
function LuaUIMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF, self, self.OpenLimitRechargeUI)

    self.isAcrossRole = false

    self.UIViewMap = {}
    self.ShowUIPageList = {}
    self:SetClickLuaFun(self.OnClickScreen)
end

function LuaUIMgr:Destroy()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF, self, self.OpenLimitRechargeUI)

    self.uiBattleDropRoot = nil
    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end

local isRoleUI = false

function LuaUIMgr:OnClickScreen()
    ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIMinTips)
end

function LuaUIMgr:Open(id, param, sourceUI, needOutAnim, skipCloseAll, sortingOrder)
    local page = self:GetPage(id)
    local view, uiData
    if page ~= nil and page.MLuaTable then
        view = page.MLuaTable
        uiData = view.uiData
    else
        uiData = ManagerContainer.CfgMgr:GetUIData(id)
        if uiData == nil then
            LogError( CommonUtil.StringConcat(id, " ui isnt exist") )
            return
        end
        local luaPath = nil
        if uiData.lua_path and uiData.lua_path ~= '' then
            luaPath = CommonUtil.StringConcat(uiData.lua_path, "View")
        else
            luaPath = CommonUtil.StringConcat(uiData.res_path, "View")
        end
        view = require(luaPath):new()

        if view == nil then
            LogError( CommonUtil.StringConcat(id, " view isnt exist") )
            return
        end

        view.uiData = uiData

        self:AddUIView(uiData.id, view)
    end
    if not Constant.OpenPay then
        if uiData and uiData.NoPay then
            return
        end
    end

    if uiData.type == Enum.UIType.Total then
        if uiData.id ~= Enum.UIPageName.UIBattle then
            ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIBattle)
            ManagerContainer.LuaUIMgr:SetBattleDropRootVisible(false)
        end
        if not skipCloseAll then
            ManagerContainer.LuaUIMgr:CloseAllPagesExceptIdAndPersistentWnd(uiData.id)
        end
    end
    
    self:LuaOpenUI(uiData, view, sortingOrder or Enum.UISibling[uiData.type + 1], param, sourceUI or 0, needOutAnim)

    -- if uiData.id == Enum.UIPageName.UIBattle or uiData.id == Enum.UIPageName.UIMainCity then
    if uiData.id == Enum.UIPageName.UIBattle then
    elseif uiData.type == Enum.UIType.Total then
        if uiData.id == Enum.UIPageName.UIRoleMain1 then
            isRoleUI = true;
        end
    end
end

function LuaUIMgr:CloseRoleUI()
    isRoleUI = false
end

function LuaUIMgr:GetBattleUIDropRoot()
    if self.UIBattleRootTrans == nil then
        return
    end

    local drop = self.UIBattleRootTrans:Find("DropRoot")
    if tolua.isnull(drop) then
        return
    end
    self.uiBattleDropRoot = drop
    if self.uiBattleDropRoot == nil then
        return
    end
    return self.uiBattleDropRoot
end

function LuaUIMgr:SetBattleDropRootVisible(state)
    local dropRoot = self:GetBattleUIDropRoot()
    if dropRoot == nil then return end

    dropRoot.gameObject:SetActive(state)
end

function LuaUIMgr:IsInRoleUI()
    return isRoleUI
end

function LuaUIMgr:ClosePage(id, needOutAnim)
    local uiData = ManagerContainer.CfgMgr:GetUIData(id);
    if uiData == nil then
        return;
    end

    local ignoreCheckCam = id == Enum.UIPageName.UILoading or id == Enum.UIPageName.UIStartLoading
    self:Close(uiData.id,ignoreCheckCam, (needOutAnim == false and false or true));
end

function LuaUIMgr:ErrorNoticeDisplay(error)
    if not error or error == "" then return end
    --网络重连状态，不显示errortips
    if self:HasOpenPage(Enum.UIPageName.UIWaiting) then
        return
    end

    local uiData = ManagerContainer.CfgMgr:GetUIData(Enum.UIPageName.UIErrorTips)
    if not ManagerContainer.LuaUIMgr:GetPage(uiData.id) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=error})
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY,  {errorId=error})
    end
end

function LuaUIMgr:ErrorNoticeDisplayWithParam(error,...)
    if not error or error == "" then return end
    local uiData = ManagerContainer.CfgMgr:GetUIData(Enum.UIPageName.UIErrorTips)
    if not ManagerContainer.LuaUIMgr:GetPage(uiData.id) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=error,params = {...}})
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId=error,params = {...}})
    end
end

function LuaUIMgr:AttrNoticeDisplay1(data)
    local uiData = ManagerContainer.CfgMgr:GetUIData(Enum.UIPageName.UIAttrAddTips)
    if not ManagerContainer.LuaUIMgr:GetPage(uiData.id) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIAttrAddTips, data)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ADD_ATTR_DISPLAY, data)
    end
end

function LuaUIMgr:POPGotAnimNotice(data)
    local uiData = ManagerContainer.CfgMgr:GetUIData(Enum.UIPageName.UIPOPGotAnims)
    if not ManagerContainer.LuaUIMgr:GetPage(uiData.id) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGotAnims, data)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ITEM_ANIM,  data)
    end
end

function LuaUIMgr:SetOldSlot(slot)
    oldSlot = slot
end

function LuaUIMgr:GetOldSlot()
    return oldSlot
end

function LuaUIMgr:AttrNoticeDisplay(slotIndex)
    if oldSlot == nil then return end

    CommonUtil.AttrNoticeDisplay(slotIndex)
    oldSlot = nil
end

--- 打开道具Tips
---@param cfgId integer 道具配置id
---@param enterType Enum.ItemIEnterType 进入类型,在不同的调用地方,tips显示不一样,根据需要给值
---@param extData table 扩展参数,根据需要给值
function LuaUIMgr:OpenItemTips(cfgId, enterType, extData)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    if not itemCfgData then
        return false
    end
    local data = {cfgId = cfgId, enterType = enterType, extData = extData}
    if itemCfgData.ResType == Enum.ItemType.FashionPaper then
        self:Open(Enum.UIPageName.UIFashionPaperTips, data)
    else
        self:Open(Enum.UIPageName.UIItemTips, data)
    end
    return true
end


--- 打开通用Tips
---@param data table 传入数据 data = {tipsType = Enum.UITipsType.Item, cfgId = 100001, num = 100, state = CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.Cost)}
---@param extData table 扩展参数,根据需要给值
function LuaUIMgr:OpenTips(data, extData)
    local tipsType, cfgId, num, state, displayBtn, id, timeStamp
    if type(data) == "number" then
        cfgId = data
        num = 0
        state = 0
        displayBtn = false
        tipsType = Enum.UITipsType.Item
    elseif type(data) == "table" then
        cfgId = data.cfgId
        num = data.num
        state = data.state or 0
        id = data.id
        displayBtn = data.displayBtn == nil and false or data.displayBtn
        tipsType = data.tipsType or Enum.UITipsType.Item
        timeStamp = data.timeStamp
        if tipsType == Enum.UITipsType.Skill then
            local data1 = {tipsType = tipsType, cfgId = cfgId, num = num, state = state, extData = extData, displayBtn = displayBtn}
            self:Open(Enum.UIPageName.UITips, data1)
            return
        end
    end
    if cfgId == nil then return false end

    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
    if not itemCfgData then
        return false
    end

    local data1 = {tipsType = tipsType, id = id, cfgId = cfgId, num = num, state = state, extData = extData, displayBtn = displayBtn, isPreview = data.isPreview, starLv = data.starLv}
    --if data1.state <= 0 then
    if itemCfgData.ResType == Enum.ItemType.Equip then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BaseAttr), Bit.lshift(1, Enum.TipsEnterType.BtnEquip)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.BtnEquip)
        if data.source == Enum.UIPageName.UIBag then
            local equipData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
            if equipData.Forge == 0 then
                data1.state = Bit.bxor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BtnEquip))
            end
        end
    elseif itemCfgData.ResType == Enum.ItemType.Card then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BaseAttr), Bit.lshift(1, Enum.TipsEnterType.BtnInsertCard)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.BtnInsertCard)
    elseif itemCfgData.ResType == Enum.ItemType.PetStamp then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BaseAttr)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.BtnInsertCard)
    elseif itemCfgData.ResType == Enum.ItemType.FashionPaper then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.Cost)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.Cost)
        local fashionPaperData = ManagerContainer.CfgMgr:GetFashionPaperById(data.cfgId)
        local owned = ManagerContainer.DataMgr.FashionData:Contains(fashionPaperData.FashionId)
        data1.state = Bit.bor(data1.state, (owned and Bit.lshift(1, Enum.TipsEnterType.BtnDecompose) or Bit.lshift(1, Enum.TipsEnterType.BtnCompose))) --data1.state + (owned and CommonUtil.Get2Powers(Enum.TipsEnterType.BtnDecompose) or CommonUtil.Get2Powers(Enum.TipsEnterType.BtnCompose))
    elseif itemCfgData.ResType == Enum.ItemType.Gift then --宝箱，这是宝箱
        local isGoto = nil
        if itemCfgData.SkipInterface > 0 then
            local isActItem, iActing = ManagerContainer.DataMgr.ActsDataMgr:IsActivityItemAndUnderway(cfgId)
            local isSeason = (not ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason())and ManagerContainer.DataMgr.CompetitionData:IsCurCompetitionItem(cfgId)
            if (isActItem and iActing) or isSeason then
                data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BtnGoto))--data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BtnGoto)
                isGoto = true
            end
        end
        if not isGoto then
            local _hasCondition = itemCfgData and itemCfgData.Costitem ~= nil;
            if _hasCondition then   --开启宝箱需要条件，需要道具才能开启
                data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBoxCondition), Bit.lshift(1, Enum.TipsEnterType.SliderComs)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBoxCondition, Enum.TipsEnterType.SliderComs)
            else
                data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBox), Bit.lshift(1, Enum.TipsEnterType.SliderComs)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBox, Enum.TipsEnterType.SliderComs)
            end
        end
    elseif itemCfgData.ResType == Enum.ItemType.HeadFrame then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BaseAttr), Bit.lshift(1, Enum.TipsEnterType.SliderBox), Bit.lshift(1, Enum.TipsEnterType.SliderComs)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.SliderBox, Enum.TipsEnterType.SliderComs)
    elseif itemCfgData.ResType == Enum.ItemType.Compose then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBox), Bit.lshift(1, Enum.TipsEnterType.SliderComs), Bit.lshift(1, Enum.TipsEnterType.BtnBoxCompose)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBox, Enum.TipsEnterType.SliderComs, Enum.TipsEnterType.BtnBoxCompose)
    elseif itemCfgData.ResType == Enum.ItemType.Item then

    elseif itemCfgData.ResType == Enum.ItemType.Income then
        local _hasCondition = itemCfgData and itemCfgData.Costitem ~= nil
        local _hasCompose = itemCfgData and itemCfgData.ComposeItem ~= nil
        if _hasCondition and _hasCompose then   --开启需要条件，需要道具才能开启
            data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBoxCondition), Bit.lshift(1, Enum.TipsEnterType.SliderComs), Bit.lshift(1, Enum.TipsEnterType.ItemNumber)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBoxCondition, Enum.TipsEnterType.SliderComs, Enum.TipsEnterType.ItemNumber)
        elseif _hasCondition then
            data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBoxCondition), Bit.lshift(1, Enum.TipsEnterType.SliderComs)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBoxCondition, Enum.TipsEnterType.SliderComs)
        elseif _hasCompose then
            data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBox), Bit.lshift(1, Enum.TipsEnterType.SliderComs), Bit.lshift(1, Enum.TipsEnterType.ItemNumber)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBox, Enum.TipsEnterType.SliderComs, Enum.TipsEnterType.ItemNumber)
        else
            data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.SliderBox), Bit.lshift(1, Enum.TipsEnterType.SliderComs)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.SliderBox, Enum.TipsEnterType.SliderComs)
        end
    elseif itemCfgData.ResType == Enum.ItemType.OptionalGift or itemCfgData.ResType == Enum.ItemType.VipProof or itemCfgData.ResType == Enum.ItemType.RuneShopExploreUnlock or itemCfgData.ResType == Enum.ItemType.WishBox or itemCfgData.ResType == Enum.ItemType.OptionalWishBox then
        data1.state = Bit.bor(data1.state, Bit.lshift(1, Enum.TipsEnterType.BtnOpen)) --data1.state + CommonUtil.Get2Powers(Enum.TipsEnterType.BtnOpen)
    end

    if itemCfgData.ItemTime > 0 then
        local logicData = ManagerContainer.DataMgr.BagData:GetItemById(id)
        if not logicData then
            logicData = ManagerContainer.DataMgr.BagData:GetItemDataByCfgId(cfgId)
        end
        if logicData then
            data1.timeStamp = logicData.timeStamp
        end
    end

    --end
    self:Open(Enum.UIPageName.UITips, data1)
    return true
end

function LuaUIMgr:OpenTipsSkill(data)
    self:Open(Enum.UIPageName.UITipsSkill, data)
end

function LuaUIMgr:FightPowerAddNotice(data)
    local uiData = ManagerContainer.CfgMgr:GetUIData(Enum.UIPageName.UIFightPowerTips)
    if not ManagerContainer.LuaUIMgr:GetPage(uiData.id) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFightPowerTips, data)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.FIGHTPOWER_REFRESH_TIPS,  data)
    end
end

--只能用于根界面
function LuaUIMgr:OpenSourceUI(owner, data)
    if owner == nil then return end

    --owner:UIClose()
    ManagerContainer.LuaUIMgr:ClosePage(owner.uiData.id)
    if owner.uiBase.MSourceUIID > 0 then
        local sourceId = owner.uiBase.MSourceUIID
        if sourceId == Enum.UIPageName.UIMainCity1 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Town)
        elseif sourceId == Enum.UIPageName.UIBag then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Pub)
        elseif sourceId == Enum.UIPageName.UIBattle then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Adventure)
        elseif sourceId == Enum.UIPageName.UIRoleMain1 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role)
        elseif sourceId == Enum.UIPageName.UIPetRoot then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Battle)
        else
            ManagerContainer.LuaUIMgr:Open(owner.uiBase.MSourceUIID, data, nil, false)
        end
    end

    if not self:HasOpenPage(Enum.UIPageName.UIMain) then
        ManagerContainer.LuaUIMgr:Back2NormalBattleMain(Enum.MainViewPageType.Town)
    end

end

function LuaUIMgr:StoryHideUIStatus(status)
    if not status then
        UIOpenStatusList = {}
        local array = self:GetCurUIStack()
        for i = 0, array.Length - 1 do
            local luaUIBase = array[i]
            local uiView = luaUIBase.MLuaTable
            if uiView.gameObject.activeSelf then
                UIOpenStatusList[#UIOpenStatusList + 1] = uiView
            end
        end
    end

    for i = 1,#UIOpenStatusList do
        UIOpenStatusList[i].gameObject:SetActive(status)
    end
end

function LuaUIMgr:GetCurUIId()
    local array = self:GetCurUIStack()
    if array.Length > 0 then
        for i = 0, array.Length - 1 do
            local luaUIBase = array[i]
            local uiView = luaUIBase.MLuaTable
            local uiData = uiView.uiData
            if uiData.type <= Enum.UIType.Tips then
                return uiView.uiData.id
            end
        end
    end
    return nil
end

function LuaUIMgr:IsUIPageIsOpenning(pageId)
    local uiData = ManagerContainer.CfgMgr:GetUIData(pageId)
    return ManagerContainer.LuaUIMgr:GetPage(uiData.id)
end

function LuaUIMgr:NeedMainHideTop()
    local array = self:GetCurUIStack()
    for i = 0, array.Length - 1 do
        local luaUIBase = array[i]
        local uiView = luaUIBase.MLuaTable
        if uiView.gameObject.activeSelf then
            if (uiView.uiData.type == Enum.UIType.Total or uiView.uiData.type == Enum.UIType.TotalWin) and uiView.uiData.hide_main_top then
                return true
            end
        end
    end
    return false
end

function LuaUIMgr:NeedMainHideBottom()
    local array = self:GetCurUIStack()
    for i = 0, array.Length - 1 do
        local luaUIBase = array[i]
        local uiView = luaUIBase.MLuaTable
        if uiView.gameObject.activeSelf then
            if (uiView.uiData.type == Enum.UIType.Total or uiView.uiData.type == Enum.UIType.TotalWin) and uiView.uiData.hide_main_bottom then
                return true
            end
        end
    end
    return false
end

function LuaUIMgr:ShowNetWaiting()
    if self:HasOpenPage(Enum.UIPageName.UIWaiting) then
        return
    end
    self:Open(Enum.UIPageName.UIWaiting)
end

function LuaUIMgr:CloseNetWaiting()
    self:ClosePage(Enum.UIPageName.UIWaiting)
end

--显示单按钮mesbox
function LuaUIMgr:ShowOkMessageBox(tipsKey,OkCb)
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIAntiCheatMsgWnd,  {tipsKey,OkCb})
end
--关闭单按钮mesbox
function LuaUIMgr:CloseOkMessageBox(strTipName)
    local page = self:GetPage(Enum.UIPageName.UIAntiCheatMsgWnd)
    if nil ~= page then
        if nil ~= page.Data and nil ~= page.Data[1] then
            if strTipName ==page.Data[1] then
                self:ClosePage(Enum.UIPageName.UIAntiCheatMsgWnd)
            end
        end
    end
end

-- 显示messagebox
function LuaUIMgr:ShowMessageBox(tipsKey,keyParams,data,owner,confirmCb,cancelCb)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips,  {tipsKey,keyParams, data, owner, confirmCb,cancelCb})
end

--关闭strTipName的 UINoticeTips
function LuaUIMgr:CloseMessageBox(strTipName)
    local page = self:GetPage(Enum.UIPageName.UINoticeTips)
    if nil ~= page then
        if nil ~= page.Data and nil ~= page.Data[1] then
            if strTipName ==page.Data[1] then
                self:ClosePage(Enum.UIPageName.UINoticeTips)
            end
        end
    end
end

function LuaUIMgr:SetBattleRootVisible(vis)
    if self.UIBattleRootTrans == nil then
        return
    end

    -- self.UIBattleRootTrans.gameObject:SetActive(vis)
end

function LuaUIMgr:BackToMainCity()
    self:Open(Enum.UIPageName.UIMainCity1)
end

--- 私聊接口
---@param uid integer 唯一ID
---@param nickname string 名字
---@param headId integer 头像
function LuaUIMgr:PrivateChatOtherPlayer(uid, nickname, headIcon, jobId, level,gender)
    local fromData = {uid = tostring(uid), nickname = nickname or "NickName", imgId = headIcon, jobId = jobId, level = level, sex = gender}
    local idx = ManagerContainer.DataMgr.ChatData:GetTargetIdxInSortedDatas(fromData)
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChatPrivate, idx)
end

--打开玩家头像交互界面,t_uid是想要查看的好友的uid的字符串
function LuaUIMgr:OpenRoleMessagePanel(_uid, isAcrossRole)
    local t_uid_int64 = _uid;
    if "string" == type(_uid) then
        t_uid_int64 = int64.new(_uid);
    end

    local _userUid = ManagerContainer.DataMgr.UserData:GetUserId();
    if int64.equals(t_uid_int64, _userUid) then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
    else
        if not isAcrossRole then isAcrossRole = false end
        self.isAcrossRole = isAcrossRole 
        ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_DETAIL_INFO_REQ, {t_uid = t_uid_int64});
    end
end

function LuaUIMgr:GetIsAcrossRole()
    return self.isAcrossRole
end

function LuaUIMgr:ClearIsAcrossRoleState()
    self.isAcrossRole = false
end

--建立 返回正常巡游战斗主界面 执行队列
function LuaUIMgr:Back2NormalBattleMain(mainViewPageType)
    local data = require('ExecuteSequenceData'):new();
    data:AppendFunc(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIMain);
    data:AppendUIListener(Enum.UIPageName.UIMain, UIEventNames.UI_FILLCONTENT_COMPELETED, 5);
    data:AppendUIViewFunc(false, Enum.UIPageName.UIMain, 'ChangePageMsg', mainViewPageType);
    ManagerContainer.ExecuteSequenceMgr:Execute(data);
    return data
end

function LuaUIMgr:AddUIView(id, view)
    if id == nil then return end
    if self.UIViewMap[id] == nil then
        self.UIViewMap[id] = {}
    end

    self.UIViewMap[id][#self.UIViewMap[id] + 1] = view
end

function LuaUIMgr:RemoveUIView(id, view)
    if id == nil then return end
    for i = 1, #self.UIViewMap[id] do
        if self.UIViewMap[id][i] == view then
            self.UIViewMap[id][i] = nil
        end
    end
end

function LuaUIMgr:DestroyUIView(id)
    if id == nil then return end
    if #self.UIViewMap[id] == 0 then
        CommonUtil.SetUITableNilInPackage(id)
    end
end

function LuaUIMgr:GetViewCtrById(id)
    if id == nil then return end
    if self.UIViewMap[id] == nil then return end
    if self.UIViewMap[id][#self.UIViewMap[id]] == nil then return end

    return self.UIViewMap[id][#self.UIViewMap[id]].controller
end

function LuaUIMgr:ShowMinTips(contentKey,params)
    local tipsData = {self.ClickMousePos,1,contentKey,params}
    if self:HasOpenPage(Enum.UIPageName.UIMinTips) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_MINTIPS,tipsData)
    else
        self:Open(Enum.UIPageName.UIMinTips, tipsData)
    end
end

function LuaUIMgr:ShowMinRewardTips(rewards)
    local tipsData = {self.ClickMousePos,2,nil,nil,rewards}
    if self:HasOpenPage(Enum.UIPageName.UIMinTips) then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_REFRESH_MINTIPS,tipsData)
    else
        self:Open(Enum.UIPageName.UIMinTips, tipsData)
    end
end

function LuaUIMgr:OnShowPage(uiData)
    if uiData.id == Enum.UIPageName.UIPrivateChatBtn then
        return
    end
    if uiData.type >= Enum.UIType.Tips then
        return
    end
    self.ShowUIPageList[#self.ShowUIPageList+1] = {pageId = uiData.id, topBtnState = uiData.top_btn_display_state}
    self:MainChangeBtnStateNotify(uiData.top_btn_display_state)
end

function LuaUIMgr:OnRemovePage(uiData)
    if self.ShowUIPageList == nil then
        return
    end

    if uiData.id == Enum.UIPageName.UIPrivateChatBtn then
        return
    end

    if uiData.type >= Enum.UIType.Tips then
        return
    end

    for i = 1, #self.ShowUIPageList do
        if self.ShowUIPageList[i].pageId == uiData.id then
            table.remove(self.ShowUIPageList, i)
            break
        end
    end

    if #self.ShowUIPageList > 0 then
        local topPage = self.ShowUIPageList[#self.ShowUIPageList]
        self:MainChangeBtnStateNotify(topPage.topBtnState)
    end
end


function LuaUIMgr:MainChangeBtnStateNotify(state)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_CHANGE_BUTTONS_STATE,state)
end

function LuaUIMgr:OpenLimitRechargeUI()
    local limitRecharge = ManagerContainer.DataMgr.ActsDataMgr:GetLimitRechargeItem()
    if not limitRecharge or not limitRecharge:IsLimitRechargeExist() then
        return
    end

    if not limitRecharge.needOpen then
        return
    end
    if ManagerContainer.FSMMgr:IsLoadingState() then
        return
    end

    local battlePage = self:GetCurrentBattlePageId()
    if battlePage > 0 then
        if battlePage ~= Enum.UIPageName.UIBattle then
            return
        else
            if ManagerContainer.LuaBattleMgr:GetBossFightState() then
                return
            end
        end
    end
    if not self:HasOpenPage(Enum.UIPageName.UIActivityLimitedGift) then
        self:Open(Enum.UIPageName.UIActivityLimitedGift, true)
    end
end

function LuaUIMgr:IsBatting()
    if ManagerContainer.FSMMgr:IsLoadingState() then
        return true
    end
    local battlePage = self:GetCurrentBattlePageId()
    if battlePage then
        if battlePage ~= Enum.UIPageName.UIBattle then
            return
        else
            if ManagerContainer.LuaBattleMgr:GetBossFightState() then
                return true
            end
        end
    end
    return false
end

return LuaUIMgr