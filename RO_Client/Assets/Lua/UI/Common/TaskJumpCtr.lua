local TaskJumpCtr = {}
local ConditionJudge = require("Common/ConditionJudge")

function TaskJumpCtr:JumpBuyCfgId(_cfgId, customParams)
    --boss战不跳转
    local UIBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIBattle)
    if UIBattleCtr then
        local _bossFightState = UIBattleCtr:GetBattleState();
        if _bossFightState then
            return false;
        end
    end
    --试炼之塔不跳转
    local UICliBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIClimbingTowerBattle)
    if UICliBattleCtr then
        return false;
    end

    local UIExpeditionBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIExpeditionBattle)
    if UIExpeditionBattleCtr then
            return false;
    end   
    --远征之门不跳转
    local page = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIGuildWar)
    if page ~= nil and page.MLuaTable then
        return false;
    end

    local _cfgData = ManagerContainer.CfgMgr:GetUIJumpData(_cfgId);
    if _cfgData then
        --判断解锁条件
        local _unlockState = self:JudgeUnLock(_cfgData.UIFuncUnLock);
        if not _unlockState then
            return false;
        end
    else
        return false;
    end

    --跳转
    local _jumpType = _cfgData.JumpType;
    if _jumpType == Enum.TaskJumpType.WeaponHousePage then --武器屋
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData);
        for _i = 1, #_panelsData do
            _panelsData[_i]._param = Enum.EquipForgeType[_panelsData[_i]._param];
        end
        ManagerContainer.UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.HeroPage then --英灵殿
        local _curMinPage = self:JudgeCurMainPage();
        ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIDojo2D, _curMinPage);

    elseif _jumpType == Enum.TaskJumpType.ChallengerHouse then --挑战者之家
        self:ClearWorldBossParam();
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData);
        self._backPageId = _mainPanelId;
        ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_LIST_CHANGED, self, self.OpenWorldBossAck);
        self:OpenWorldBoss(self._backPageId);
    elseif _jumpType == Enum.TaskJumpType.RolePage then --角色界面
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role, 1)
        --ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIRoleMain1, nil);
    elseif _jumpType == Enum.TaskJumpType.Guild then
        local errorCode = ManagerContainer.DataMgr.GuildDataMgr:GetGuildDataStateErrorCode()
        if errorCode then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
            return false
        end
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData)
        if customParams then
            if _panelsData and _panelsData[1] and not _panelsData[1]._param then
                _panelsData[1]._param = customParams
            end
        end
        ManagerContainer.UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData)
    elseif _jumpType == Enum.TaskJumpType.ActivityPage then
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData)
        if _panelsData  and _panelsData[1] and _panelsData[1]._param then
            local actData = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemById(_panelsData[1]._param)
            if not (actData and not actData:IsOutofDate() and actData:IsOpened()) then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('UIJumpNoActivity')
                return false
            end
            _panelsData[1]._param = {pageBg = actData.pageBg, actId = actData.actId}
            ManagerContainer.UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData)
        else
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('UIJumpNoActivity')
            return false
        end
    elseif _jumpType == Enum.TaskJumpType.TitleMaterials then
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData);
        _panelsData[1]._param = customParams
        ManagerContainer.UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData);
    else
        local _panelsData, _mainPanelId = self:CreatePanelsData(_cfgData);
        ManagerContainer.UIJumpMgr:CreateJumpTask(_mainPanelId, _panelsData);

    end
    return true;
end

function TaskJumpCtr:CreatePanelsData(_cfgData)
    local _panelsData = nil;
    if _cfgData.PanelData and #_cfgData.PanelData > 0 then
        _panelsData = {};
        local _curMinPage = self:JudgeCurMainPage();
        for _i = 1, #_cfgData.PanelData do
            local _panel = _cfgData.PanelData[_i];
            local _type = type(_panel);
            if _type == "number" then
                local _panelData = {
                    _panelId = _panel,
                    _param = nil,
                    _backPageId = _curMinPage,
                };
                _curMinPage = _panel;
                table.insert(_panelsData, _panelData);
            elseif _type == "table" then
                local _id = _panel[1];
                if _id ~= nil then
                    local _param = _panel[2];
                    if _param then
                        local _panelData = {
                            _panelId = _id,
                            _param = _param,
                            _backPageId = _curMinPage,
                        };
                        _curMinPage = _id;
                        table.insert(_panelsData, _panelData);
                    else
                        LogError("跳转页面传参有误：" .. Inspect(_panel))
                        LogError(Inspect(_cfgData))
                    end
                else
                    LogError("跳转页面id有误：" .. Inspect(_panel))
                    LogError(Inspect(_cfgData))
                end
            end
        end
    end

    local _mainPanelId = self:JudgeCurMainPage() or Enum.UIPageName.UIRoleMain1;
    if _cfgData.MainPanelId and _cfgData.MainPanelId > 0 then
        _mainPanelId = _cfgData.MainPanelId;
    end

    return _panelsData, _mainPanelId;
end

function TaskJumpCtr:JumpUIPage(_jumpType, _UIFunLockId)
    --boss战不跳转
    local _bossFightState = UIBattleCtr:GetBattleState();
    if _bossFightState then
        return;
    end

    --判断解锁条件
    local _unlockState = self:JudgeUnLock(_UIFunLockId);
    if not _unlockState then
        return;
    end

    --跳转
    local _curMinPage = self:JudgeCurMainPage();
    if _jumpType == Enum.TaskJumpType.BattlePage then --战斗巡游界面
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIBattle, nil);

    elseif _jumpType == Enum.TaskJumpType.RolePage then --角色界面
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIRoleMain1, nil);

    elseif _jumpType == Enum.TaskJumpType.WeaponHousePage then --武器屋
        local _panelsData = {{_panelId = Enum.UIPageName.UIForge1,
                              _param = Enum.EquipForgeType[Enum.ForgeType.Sword],
                              _backPageId = _curMinPage}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.TowerPage then --试炼爬塔界面
        local _panelsData = {{_panelId = Enum.UIPageName.UIClimbingTower,
                              _param = nil,
                              _backPageId = _curMinPage}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.HeroPage then --英灵殿
        ManagerContainer.DataMgr.ArenaData:SendArenaDataReq(Enum.UIPageName.UIDojo2D, _curMinPage);

    elseif _jumpType == Enum.TaskJumpType.AlliancePage then --工会

    elseif _jumpType == Enum.TaskJumpType.DevilAlliancePage then --恶魔协会
        local _panelsData = {{_panelId = Enum.UIPageName.UISkillExpBattle,
                              _param = nil,
                              _backPageId = _curMinPage}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.ShopPage then --普通商店
        --暂时不开
        --ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIShopNew, nil);

    elseif _jumpType == Enum.TaskJumpType.HeroShopPage then --英灵殿商店
        --暂时不开
        --[[
        local _panelsData = {{_panelId = Enum.UIPageName.UIDojoShop,
                              nil,
                              _backPageId = Enum.UIPageName.UIMainCity1}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);]]--

    elseif _jumpType == Enum.TaskJumpType.CardHousePage then --卡片屋
        local _panelsData = {{_panelId = Enum.UIPageName.UICardList,
                              _param = Enum.CardFuncType.Recreate,
                              _backPageId = _curMinPage}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.Fashion then --时装
        local _panelsData = {{_panelId = Enum.UIPageName.UIFashion,
                              _param = nil,
                              _backPageId = _curMinPage}};
        ManagerContainer.UIJumpMgr:CreateJumpTask(Enum.UIPageName.UIMainCity1, _panelsData);

    elseif _jumpType == Enum.TaskJumpType.ChallengerHouse then --挑战者之家
        local data = require('ExecuteSequenceData'):new()
        ManagerContainer.LuaUIMgr:OpenInputMask(9500);
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMainCity1) then
            data:AppendUIViewFunc(false, Enum.UIPageName.UIMain, 'ChangePageMsg', Enum.MainViewPageType.Town)
            data:AppendUIListener(Enum.UIPageName.UIMainCity1, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
        end
        data:AppendUIViewFunc(false, Enum.UIPageName.UIMainCity1, 'OpenWorldBoss')
        data:AppendUIListener(Enum.UIPageName.UIWorldBossList, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
        data:AppendUIViewFunc(true, Enum.UIPageName.UIMainCity1, 'CloseInputMask')
        ManagerContainer.ExecuteSequenceMgr:Execute(data)

    end
end

--判断跳转的功能是否已经解锁
function TaskJumpCtr:JudgeUnLock(_id)
    if _id == nil or _id == 0 then
        return true;
    end
    local _unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(_id)
    if not _unlockState then
        local _cfgData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(_id);
        if _cfgData and _cfgData.UnlockCond and _cfgData.UnlockCond[1] then
            local result, val, content = ConditionJudge:ConditionPassResult1(_cfgData.UnlockCond[1])
            if not result then
                ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content..I18N.T(_cfgData.FunName)..I18N.T("Fun"))
            end
        end
    end
    return _unlockState;
end

--创建提示字符串
function TaskJumpCtr:CreateWarningStr(_levelId, _strId)
    local _nameStr = I18N.T(_strId);
    local _levelData = ManagerContainer.CfgMgr:GetLevelDataById(_levelId);
    local _levelName = "";
    if _levelData then
        _levelName = _levelData.Name;
    end
    local _str = I18N.SetLanguageValue("FunUnLock", _levelName, _nameStr);
    return _str;
end

--获取当前的主界面的id
function TaskJumpCtr:JudgeCurMainPage()
    local _page = ManagerContainer.DataMgr.TaskDataNew:GetMainButton();

    if _page == Enum.MainViewPageType.Town then
        return Enum.UIPageName.UIMainCity1;
    elseif _page == Enum.MainViewPageType.Pub then
            return Enum.UIPageName.UIBag;
    elseif _page == Enum.MainViewPageType.Adventure then
        return Enum.UIPageName.UIBattle;
    end
end

--打开挑战者大厅（曾用名是世界boss）
function TaskJumpCtr:OpenWorldBoss(_uiDataId)
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIWorldBossList) then
        return
    end
    local _hasWordBoss = ManagerContainer.DataMgr.WorldBossData:HasWorldBossList();
    if _hasWordBoss then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWorldBossList, nil, _uiDataId);
    else
        ManagerContainer.DataMgr.WorldBossData:SendWorldBossListRequest();
    end
end

function TaskJumpCtr:OpenWorldBossAck()
    self:OpenWorldBoss(self._backPageId);
    self:ClearWorldBossParam();
end

function TaskJumpCtr:ClearWorldBossParam()
    self._backPageId = nil;
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_LIST_CHANGED, self, self.OpenWorldBoss)
end

return TaskJumpCtr