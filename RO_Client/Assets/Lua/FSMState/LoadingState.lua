local LoadingState = class("LoadingState", require("StateBase"))
function LoadingState:Enter(sceneType, param1)
    ManagerContainer.GoPoolMgr:Dispose()
    ManagerContainer.UIStoryMgr:Dispose()
    ManagerContainer.StoryMgr:ExpectedStopCurStoryChapter()
    ManagerContainer.LuaUIMgr:CloseInputMask()

    self.sceneType = sceneType
    self.param = param1
    self.bStarted = false

    if self.sceneType == SceneType.TowerBattleScene then
        if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIDojoMatch) then
            ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UIDojoMatch)
        elseif ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UILoading) then
            ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UILoading)        
        end
    else 
        if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UILanuch) then
            ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UILanuch)
        elseif ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UILoading) then
            ManagerContainer.LuaUIMgr:CloseAllPagesExceptId(Enum.UIPageName.UILoading)
        end
    end

    self:SyncDataToActorData()
end

function LoadingState:Update()
    LogWarning("LoadingState:BeginLoading "..(ManagerContainer.LuaGameMgr.loadingPageOk and "true" or "false") )
    if self.bStarted == false and ManagerContainer.LuaGameMgr.loadingPageOk then
        self:BeginLoading()
    end
end

function LoadingState:Exit()
end

function LoadingState:GetTask()
    return nil
end

function LoadingState:BeginLoading()
    LogWarning("LoadingState:BeginLoading ")
    self.bStarted = true
    if self.sceneType == SceneType.LoginScene then
    elseif self.sceneType == SceneType.CreateRoleScene then
        ManagerContainer.LuaGameMgr:PreloadCreateRoleScene()
    elseif self.sceneType == SceneType.NormalBattleScene then

        local dataInitedOver = ManagerContainer.DataMgr.UserData:IsInitedOver()
        if dataInitedOver then
            self:StartNormalBattle()
        end
        LogWarning("开始加载场景---- ")
        local datas = System.Collections.Generic.Dictionary_object_object()
        datas:Add('eventName', 'LoadingBegin2')
        datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
        SDKMgr.Instance:ReportAction(datas)

    elseif self.sceneType == SceneType.GuildLobbyScene then
        ManagerContainer.LuaGameMgr:PreloadGuildLobby();
    elseif self.sceneType == SceneType.TowerBattleScene then
        local mode = self.param["mode"]
        local battleEndConds = self.param["battleEndConds"]
        local ourActors = self.param["ourActors"]
        local enemyActors = self.param["enemyActors"]
        local sceneName = self.param["sceneName"]
        local maxFightingTime = self.param["maxFightingTime"]
        local OurMarks = nil
        local EnemyMarks = nil
        local IsPresspoint = false
        local nPresspoint = 0
        if not maxFightingTime then
            maxFightingTime = 0
        end
        if nil ~= self.param['OurBattleMarks'] then
            OurMarks = self.param['OurBattleMarks'] 
        end
        if nil ~= self.param['EnemyBattleMarks'] then
            EnemyMarks = self.param['EnemyBattleMarks'] 
        end
        if nil ~= self.param['IsPresspoint'] then
            IsPresspoint = self.param['IsPresspoint']
        end
        if nil ~= self.param['nPresspoint'] then
            nPresspoint = self.param['nPresspoint']
        end
        ManagerContainer.LuaGameMgr:PreloadVersusBattle(mode, ourActors, enemyActors, sceneName, maxFightingTime, battleEndConds,OurMarks,EnemyMarks,IsPresspoint,nPresspoint);
        LuaBattleBridge.SetLuaBattleMgr(BattleMode.Versus, ManagerContainer.LuaDojoMgr)
    elseif self.sceneType == SceneType.BossBattleScene then
        self.actors = self.param["actors"]
        self.bossId = self.param["bossId"]
        self.sceneId = self.param["sceneId"]
        self.bossMode = self.param["bossMode"]
        self.battleEndConds = self.param["battleEndConds"]

        if self.bossMode == BattleSubMode.WorldBoss then
            ManagerContainer.LuaGameMgr:PreloadBossBattle(self.actors,self.bossId,self.sceneId,self.battleEndConds)
        elseif self.bossMode == BattleSubMode.NewbieBoss then
           local fellows =  ManagerContainer.LuaGameMgr:StartNewbieBossBattle(self.sceneId,ManagerContainer.DataMgr.UserData:GetSex())
           ManagerContainer.LuaGameMgr.newbieActors = fellows
        end
        
        LuaBattleBridge.SetLuaBattleMgr(BattleMode.Boss, ManagerContainer.LuaBossBattleMgr)
    elseif self.sceneType == SceneType.TimeBattleScene then
        local mode = self.param["mode"]
        local maxFightingTime = self.param["maxFightingTime"]
        local sceneName = self.param["sceneName"]
        local bgmMusic = self.param["bgmMusic"]
        local ourActors = self.param["ourActors"]
        local enemyActors = self.param["enemyActors"]
        local battleEndConds = self.param["battleEndConds"]
        local serverActorData = self.param["serverActorData"]
        local battleRecordStr = self.param["battleRecordStr"]
        local battleFactors = self.param["battleFactors"]
        local replayername = self.param["replayername"]
        local RestoreSp = 0
        local OurMarks = nil
        local EnemyMarks = nil
        if nil ~= self.param['RestoreSp'] then
            RestoreSp = self.param['RestoreSp'] 
        end
        if nil ~= self.param['OurBattleMarks'] then
            OurMarks = self.param['OurBattleMarks'] 
        end
        if nil ~= self.param['EnemyBattleMarks'] then
            EnemyMarks = self.param['EnemyBattleMarks'] 
        end
        if ourActors ~= nil and enemyActors ~= nil then
            if battleFactors == nil then
                battleFactors = System.Array.CreateInstance(Enum.TypeInfo.ValType, 0)
            end
            ManagerContainer.LuaGameMgr:PreloadTimeBattle(ManagerContainer.LuaTimeBattleMgr, mode, maxFightingTime,sceneName,bgmMusic,ourActors,enemyActors,serverActorData,battleEndConds,battleFactors,RestoreSp,OurMarks,EnemyMarks)
        elseif battleRecordStr ~= nil then
            ManagerContainer.LuaGameMgr:ReplayTimeBattle(ManagerContainer.LuaTimeBattleMgr, mode, maxFightingTime,sceneName,bgmMusic,battleRecordStr)   
           
            LuaBattleBridge.SetReplayHeroActorName(replayername)	      
        end
    end
end

function LoadingState:StartNormalBattle()
    -- 加载场景
    LogWarning("LoadingState:StartNormalBattle ")
    ManagerContainer.DataMgr.UserData:RefreshAddPointAttr()
    ManagerContainer.DataMgr.PartnerData:InitPartnerPointAttr()

    ManagerContainer.DataMgr.UserData:InitHeroAttrFromBattle()
    ManagerContainer.DataMgr.PartnerData:InitPartnerAttrFromBattle()

    local teamData = ManagerContainer.DataMgr.UserData:GetTeamData(true);
    ManagerContainer.LuaGameMgr:PreloadFellowsModel()
    ManagerContainer.LuaGameMgr:PreloadBattle(teamData);

    LuaBattleBridge.SetLuaBattleMgr(BattleMode.Normal, ManagerContainer.LuaBattleMgr)
end

--- 只同步到当前玩家已创建的ActorData
function LoadingState:SyncDataToActorData()
    local actorData = ManagerContainer.LuaActorDataMgr:GetActorData(true, 0)
    if actorData then
        self:SyncHeroDataToActorData(ManagerContainer.DataMgr.UserData:GetMainRoleData(), actorData)
    end
    local list = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    if list ~= nil then
        for _,v in pairs(list) do
            if v.owned then
                actorData = ManagerContainer.LuaActorDataMgr:GetActorData(false, v.configId)
                if actorData then
                    self:SyncHeroDataToActorData(v, actorData)
                end
            end
        end
    end
end

function LoadingState:SyncHeroDataToActorData(heroData, actorData)
    if not heroData then return end
    if not actorData then return end

    -- 同步技能
    local skillData = heroData.skillData
    if skillData then
        local skillPrams = skillData:GetUsedSkillParams()        
        skillPrams = CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, skillPrams)
        actorData:RefreshSkills(skillPrams)
    end
end

return LoadingState