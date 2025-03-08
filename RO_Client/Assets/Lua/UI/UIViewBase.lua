local UIViewBase = class("UIViewBase")

function UIViewBase:Init()
    self.fxGoes = {}
end

function UIViewBase:UIHide(needBackIn)
    ManagerContainer.LuaUIMgr:Hide(self.uiData.id, needBackIn or false)
end

function UIViewBase:UIClose()
    ManagerContainer.LuaUIMgr:ClosePage(self.uiData.id, true)
end

function UIViewBase:OnBaseShow()
    --LogError(self.uiData.name.."  show")

    if self.uiData.type == Enum.UIType.TotalWin or self.uiData.type == Enum.UIType.Total then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_TOP, not self.uiData.hide_main_top, self.uiBase.SortingOrder)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_BOTTOM, not self.uiData.hide_main_bottom, self.uiBase.SortingOrder)
    end

    if self.uiData.top_res_id > 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_MAIN_TOP_RES_TYPE, self.uiData.top_res_id)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FILLCONTENT_COMPELETED, self)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_CONDITION_TRIGGER, Enum.UIStoryCondType.FirstUIOpen, self.uiData.id)
    ManagerContainer.LuaUIMgr:OnShowPage(self.uiData)

    --打开限时礼包
    --if self.uiData.can_limit_gift then
    --    ManagerContainer.LuaUIMgr:OpenLimitRechargeUI()
    --end
end

function UIViewBase:OnBaseHide()
    --LogError(self.uiData.name.."  hide")

    ManagerContainer.LuaUIMgr:OnRemovePage(self.uiData)
    CommonUtil.CloseUIClearAsyncSeqIds(self)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_CLOSE_COMPELETED, self)
end

function UIViewBase:OnSubClose(path)
    local target = CommonUtil.ParseUITargetPath(self, path)
    if target == nil then
        return
    end

    local animator = target.gameObject:GetComponent(Enum.TypeInfo.Animator)
    if animator then
        CommonUtil.ResetAnimator(animator)
    end
    target:SetActive(false)
end

function UIViewBase:OnBaseClose()
    ManagerContainer.LuaUIMgr:OnRemovePage(self.uiData)
end

function UIViewBase:OnBaseDispose()

    --if owner.uiData.hide_main_top then
    --    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_TOP, true)
    --end
    --if owner.uiData.hide_main_bottom then
    --    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.DISPLAY_MAIN_BOTTOM, true)
    --end
    if self.fxGoes ~= nil then
        for i =1, #self.fxGoes do
            ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath,self.fxGoes[i].name,self.fxGoes[i].go)
            self.fxGoes[i].item.uiParticle = nil
        end
    end
    self.fxGoes = nil

    CommonUtil.ClearGridViewItem(self)
    CommonUtil.BatchDisposeItems(self)
    CommonUtil.CloseUIClearAsyncSeqIds(self)
end

function UIViewBase:DisposeView()
    if self.controller then
        self.controller:OnDispose()
        self.controller = nil
    end

    if self.inited then
        self:GenerateDestroy()
    end

    if self.uiData then
        local uiId = self.uiData.id
        ManagerContainer.LuaUIMgr:RemoveUIView(uiId, self)
        self.gameObject = nil
        self.transform = nil
        self.uiBase = nil
        self.uiData = nil
        ManagerContainer.LuaUIMgr:DestroyUIView(uiId)
    end
end

function UIViewBase:AddNewEffect(itemlua,effectName,effectGo)
    if effectName == nil or effectGo == nil then
        return
    else
        self.fxGoes[#self.fxGoes+1] = {item =itemlua,name=effectName,go=effectGo}
    end
end

function UIViewBase:RemoveEffect(itemlua,effectName,effectGo)
    if effectName == nil or effectGo == nil  or self.fxGoes == nil then
        return
    else
        for i =1, #self.fxGoes do 
            if self.fxGoes[i].item == itemlua and self.fxGoes[i].name == effectName and self.fxGoes[i].go == effectGo then
                table.remove(self.fxGoes, i)
                return
            end
        end
    end
end

function UIViewBase:OnPageOutEnd()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_PAGE_OUT_END_NTF, self.uiData.id)
end

function UIViewBase:OnPageInEnd()
    if self.uiData == nil then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_PAGE_IN_END_NTF, self.uiData.id)
    if self.uiBase.MSourceUIID > 0 and self.uiBase.MUIType == Enum.UIType.TotalWin then
        ManagerContainer.LuaUIMgr:Hide(self.uiBase.MSourceUIID, false)
    end
end

return UIViewBase