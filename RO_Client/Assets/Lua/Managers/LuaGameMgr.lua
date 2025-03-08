local LuaGameMgr = class("LuaGameMgr", function()
    return GameMgr.Instance
end)

function LuaGameMgr:ctor()
    self:SetOnSceneLoadedLuaFunc(self.OnSceneLoadedInLua)
    self:SetLuaPlayStoryFunc(self.PlayStory)
    self:SdkInitFunc(self.SdkInitResult)
    self:SdkLoginFunc(self.SdkLoginResult)
    self:SdkLogoutFunc(self.SdkLogoutResult)
    self:SdkPayFunc(self.SdkPayResult)
    self:SdkQuestionFunc(self.UrlQuestionRewardResult)



    self:SdkVideoAdFunc(self.SdkVideoAdResult)
    self:SdkPageAdFunc(self.SdkPageAdResult)
    self:SdkShareFunc(self.SdkShareResult)
    self:SdkBindTickTokFunc(self.SdkBindTickTokResult)
    self:SdkCreateInDesktopFunc(self.SdkCreateInDesktopResult)
    self:SdkGetSafeAreaFunc(self.SdkGetSafeAreaResult)

    self:SdkRecordFunc(self.SdkRecordResult)

    self.newbieActors = nil
    self.IsCreateRole = false
    self.loadingPageOk = false
    self.IsActivationCodeMode = false
    self.showNiewbieLoading = false
    self.registerEvents = false
    self.isPreloadedFellow = false

    self.sdkInited = Enum.ParamState.None
    self.sdkLogined = Enum.ParamState.None
    self.token = ''
    self.openId = ''
    self.IsNewPlayer = 2
    self.platform = ''
    self.channelName = ''
    self.serverData = {}
end

function LuaGameMgr:SendBattleRecordReq(recordType,params)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_PLAYER_BATTLE_RECORD_REQ, {record_type = recordType, param_list = params})
end


function LuaGameMgr:OnSceneLoadedInLua(sceneType,mode)
    if sceneType == SceneType.CreateRoleScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.CreateRoleState.stateId)
    elseif sceneType == SceneType.NormalBattleScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.BattleState.stateId)
        local datas = System.Collections.Generic.Dictionary_object_object()
        datas:Add('eventName', 'LoadingFinish2')
        datas:Add('player', ManagerContainer.LuaGameMgr.IsNewPlayer)
        LogWarning("Scene load finish")
        SDKMgr.Instance:ReportAction(datas)
    elseif sceneType == SceneType.GuildLobbyScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.GuildLobbyState.stateId)
    elseif sceneType == SceneType.TowerBattleScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.DojoState.stateId, mode)
    elseif sceneType == SceneType.BossBattleScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.BossBattleState.stateId,mode)
    elseif sceneType == SceneType.TimeBattleScene then
        ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.TimeBattleState.stateId,mode)
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Close)
end

function LuaGameMgr:Destroy()
    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

function LuaGameMgr:SdkInitResult(success,platformName)
    if success == false then
        self:ErrorNoticeDisplay("初始化失败 "..platformName)
    end
    self.platform = platformName
    self.sdkInited = (success and Enum.ParamState.Success or Enum.ParamState.Fail)
end

function LuaGameMgr:SdkVideoAdResult(success)
    self:ErrorNoticeDisplay("播放视频广告结束 ")

end

function LuaGameMgr:SdkPageAdResult(success)
    self:ErrorNoticeDisplay("播放插屏广告结束 ")

end

function LuaGameMgr:SdkShareResult(success)
    self:ErrorNoticeDisplay("分享完成 ")

end

function LuaGameMgr:SdkBindTickTokResult(success)
    self:ErrorNoticeDisplay("绑定完成 ")
end

function LuaGameMgr:SdkCreateInDesktopResult(success)
    self:ErrorNoticeDisplay("创建完成 ")
end

function LuaGameMgr:SdkRecordResult(type,success,ext_data)
    LogWarning("Recoding type " .. type )
    LogWarning("Recoding success " .. tostring(success) )
    LogWarning("Recoding ext_data " .. ext_data )
    if type == "record_start" then
       ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TT_RECORD_START,success)
    elseif type == "record_finish" then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TT_RECORD_FINISH,success)
    elseif type == "create_view_load" then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_ENTER_CREATE_ROLE)
    end

end


function LuaGameMgr:SdkGetSafeAreaResult(left,right,top,bottom,width,height)
    -- self:ErrorNoticeDisplay("SafeArea: left: " ..left
    --         .." right: " ..right
    --         .." top: " ..top
    --         .." bottom: " ..bottom
    --         .." width: " ..width
    --         .." height: " ..height
    --     )

    -- LogWarning("SafeArea: left: " ..left
    -- .." right: " ..right
    -- .." top: " ..top
    -- .." bottom: " ..bottom
    -- .." width: " ..width
    -- .." height: " ..height
    -- )  
end



function LuaGameMgr:SdkLoginResult(success,openId,token,isSwitchAccount)
    local lastSdkLogined = self.sdkLogined
    self.sdkLogined = (success and Enum.ParamState.Success or Enum.ParamState.Fail)
    self.token = token or ''
    self.openId = openId or ''
    if success then
        if isSwitchAccount then
            if lastSdkLogined == Enum.ParamState.Success then
                if ManagerContainer.DataMgr.UserData:IsInitedOver() then
                    ManagerContainer.DataMgr.UserData:SDKExitGame()
                end
                self:ClearServerData()
                self:ReLogin()
            end
        end
    end
end

function LuaGameMgr:ErrorNoticeDisplay(error, ...)
    if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=error,params = {...}}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId=error,params = {...}})
    end
end

function LuaGameMgr:SdkLogoutResult()
    if ManagerContainer.DataMgr.UserData:IsInitedOver() then
        ManagerContainer.DataMgr.UserData:SDKExitGame()
    end
    local lastSdkLogined = self.sdkLogined
    self.sdkLogined = Enum.ParamState.Fail
    self.token = ''
    self.openId = ''
    if lastSdkLogined == Enum.ParamState.Success then
        self:ClearServerData()
        self:ReLogin()
    end
end

function LuaGameMgr:SdkPayResult(success)
    -- self:ErrorNoticeDisplay("支付完成： "..success)
    ManagerContainer.PayMgr:SdkPayResult(success)
end

function LuaGameMgr:InitServerData(id, name, ip, ports, state)
    self.serverData.id = id
    self.serverData.name = name
    self.serverData.ip = ip
    self.serverData.ports = ports
    self.serverData.state = state
    self.serverData.portidx = nil
end

function LuaGameMgr:ClearServerData()
    self.serverData = {}
end

function LuaGameMgr:ComposeCommonServerInfo(url)
    local openId = self.openId
    if openId and openId ~= '' then
		url = url .. '&openid=' .. tostring(openId)
		-- url = url .. '&openid=sdjaslkdjaskldjaslkdjasldaskl'
	end
    local platform = self.platform
	if platform and platform ~= '' then
		url = url .. '&platform=' .. tostring(platform)
	end
	local subplatform = self.channelName
	if subplatform and subplatform ~= '' then
		url = url .. '&sub_platform=' .. tostring(subplatform)
	end
	local resVer = self.ResVersion
	if resVer and resVer ~= '' then
		url = url .. '&resver=' .. tostring(resVer)
	end
	url = url .. '&timesamp=' .. tostring(os.time())
    return url
end


--进入创建角色场景
function LuaGameMgr:EnterCreateRole(activedCode)
    self.IsCreateRole = true
    self.IsActivationCodeMode = activedCode
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_ENTER_CREATE_ROLE)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.CreateRoleScene)
end

--进入战斗
function LuaGameMgr:EnterBattle(first)
    if ManagerContainer.FSMMgr:IsBattleState() then
        --ManagerContainer.LuaUIMgr:HideAllPagesExceptId(Enum.UIPageName.UIBattle)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle)
        return;
    end

    if first == false then
        local nloadingId = 3
        if self.showNiewbieLoading then
            nloadingId = 2
            self.showNiewbieLoading = false
        end
        self:OpenLoading(Enum.UIPageName.UILoading,{loadingId = nloadingId})
    end
    --ManagerContainer.LuaActorAttributeMgr:SyncServerActorDataToLocal()
    --清空断线后 返回巡游 残留的远征BUFF
    ManagerContainer.LuaActorDataMgr:ResetData()
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.NormalBattleScene,first)
end

--进入公会大厅
function LuaGameMgr:EnterGuildLobby()
    if ManagerContainer.FSMMgr:IsGuildLobbyState() then
        return
    end

    self:OpenLoading(Enum.UIPageName.UILoading)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.GuildLobbyScene)
end

--进入道场
function LuaGameMgr:EnterDojo(sceneName, ourActors, enemyActors,OurMarks, IsPresspoint,nPresspoint,battleEndConds)
    if ManagerContainer.FSMMgr:IsDojoState() then
        return;
    end
    local param = {}
    param["mode"] = BattleSubMode.Arena
    param["sceneName"] = sceneName
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    param["OurBattleMarks"] = OurMarks 
    param["IsPresspoint"] = IsPresspoint
    param["nPresspoint"] = nPresspoint    
    -- self:OpenLoading(Enum.UIPageName.UILoading)
    self:OpenLoading(Enum.UIPageName.UIDojoMatch, param)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TowerBattleScene, param)
end

function LuaGameMgr:EnterHundredDojo(sceneName, ourActors, enemyActors, maxFightingTime,OurMarks,IsPresspoint,nPresspoint, battleEndConds)
    if ManagerContainer.FSMMgr:IsDojoState() then
        return;
    end
    local param = {}
    param["mode"] = BattleSubMode.HundredDojo
    param["sceneName"] = sceneName
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["maxFightingTime"] = maxFightingTime
    param["OurBattleMarks"] = OurMarks 
    param["IsPresspoint"] = IsPresspoint
    param["nPresspoint"] = nPresspoint
    param["battleEndConds"] = battleEndConds
    self:OpenLoading(Enum.UIPageName.UIDojoMatch, param)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TowerBattleScene, param)
end

--工会战
function LuaGameMgr:EnterGvGBattle(sceneName, ourActors, enemyActors, maxFightingTime, battleEndConds,OurMarksDatas,EnemyMarksDatas,IsPresspoint,nPresspoint)
    if ManagerContainer.FSMMgr:IsDojoState() then
        return;
    end
    local param = {}
    param["mode"] = BattleSubMode.GvG
    param["sceneName"] = sceneName
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["maxFightingTime"] = maxFightingTime
    param["battleEndConds"] = battleEndConds
    param["OurBattleMarks"] = OurMarksDatas 
    param["EnemyBattleMarks"] = EnemyMarksDatas 
    param["IsPresspoint"] = IsPresspoint
    param["nPresspoint"] = nPresspoint
    self:OpenLoading(Enum.UIPageName.UIDojoMatch, param)

    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TowerBattleScene, param)
end

function LuaGameMgr:EnterVoyageBattle(sceneName, ourActors, enemyActors, maxFightingTime, ourMarks,IsPresspoint,nPresspoint, battleEndConds)
    if ManagerContainer.FSMMgr:IsDojoState() then
        return;
    end
    local param = {}
    param["mode"] = BattleSubMode.Voyage
    param["sceneName"] = sceneName
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["maxFightingTime"] = maxFightingTime
    param["battleEndConds"] = battleEndConds
    param["OurBattleMarks"] = ourMarks
    param["IsPresspoint"] = IsPresspoint
    param["nPresspoint"] = nPresspoint
    self:OpenLoading(Enum.UIPageName.UIDojoMatch, param)

    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TowerBattleScene, param)
end

-- 进入资源副本战斗
function LuaGameMgr:EnterResourceBattle(sceneName,bgmMusic,maxFightingTime,ourActors,enemyActors,battleEndConds)
    if ManagerContainer.FSMMgr:IsTimeBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param = {}
    param["mode"] = BattleSubMode.Resource
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["maxFightingTime"] = maxFightingTime
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TimeBattleScene, param)
end

-- 进入公会狩猎boss战斗
function LuaGameMgr:EnterGuildHuntBattle(sceneName, bgmMusic, maxFightingTime, ourActors, enemyActors, battleEndConds)
    if ManagerContainer.FSMMgr:IsTimeBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param = {}
    param["mode"] = BattleSubMode.Guild
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["maxFightingTime"] = maxFightingTime
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TimeBattleScene, param)
end

-- 进入公会魔王boss战斗
function LuaGameMgr:EnterGuildHuntExBattle(sceneName, bgmMusic, maxFightingTime, ourActors, enemyActors, battleEndConds)
    if ManagerContainer.FSMMgr:IsTimeBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param = {}
    param["mode"] = BattleSubMode.GuildEx
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["maxFightingTime"] = maxFightingTime
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TimeBattleScene, param)
end

-- 进入爬塔战斗
function LuaGameMgr:EnterClimbingTowerBattle(sceneName,bgmMusic,maxFightingTime,ourActors,enemyActors,battleEndConds,recordStr,battleFactors,replayername)
    if ManagerContainer.FSMMgr:IsTimeBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param = {}
    param["mode"] = BattleSubMode.ClimbingTower
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["maxFightingTime"] = maxFightingTime
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    param["battleRecordStr"] = recordStr
    param["battleFactors"] = battleFactors       
    if param["battleRecordStr"] ~= nil then
        param["replayername"] = replayername
    end
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TimeBattleScene, param)
end

--PVP 爬塔
function LuaGameMgr:EnterClimbingTowerBattlePvP(sceneName, bgmMusic,maxFightingTime,ourActors, enemyActors,OurMarks, IsPresspoint,nPresspoint,battleEndConds)
    if ManagerContainer.FSMMgr:IsDojoState() then
        return;
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param = {}
    param["mode"] = BattleSubMode.PvPClimbinglower
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["maxFightingTime"] = maxFightingTime
    param["OurBattleMarks"] = OurMarks 
    param["IsPresspoint"] = IsPresspoint
    param["nPresspoint"] = nPresspoint
    param["battleEndConds"] = battleEndConds
    --self:OpenLoading(Enum.UIPageName.UIDojoMatch, param)

    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TowerBattleScene, param)
end

-- 进入远征之门战斗
function LuaGameMgr:EnterExpeditionBattle(sceneName,bgmMusic,maxFightingTime,ourActors,enemyActors,nloadingId,serverActorData,battleEndConds,RestoreSp)
    if ManagerContainer.FSMMgr:IsTimeBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading,{loadingId = nloadingId})
    local param = {}
    param["mode"] = BattleSubMode.Expedition
    param["sceneName"] = sceneName
    param["bgmMusic"] = bgmMusic
    param["maxFightingTime"] = maxFightingTime
    param["ourActors"] = ourActors
    param["enemyActors"] = enemyActors
    param["battleEndConds"] = battleEndConds
    param["serverActorData"] = serverActorData
    param['RestoreSp'] = RestoreSp
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.TimeBattleScene, param)
end

--- 进入世界boss
---@param actorDatas Array<ActorData> 进入挑战的其它玩家信息
---@param summonId boss等配置Id
---@param summonScene 战斗场景配置Id
function LuaGameMgr:EnterWorldBoss(actorDatas, summonId, summonScene,battleEndConds)
    if ManagerContainer.FSMMgr:IsBossBattleState() then
        return
    end
    self:OpenLoading(Enum.UIPageName.UILoading)
    local param ={}
    param["actors"] = actorDatas
    param["bossId"] = summonId
    param["sceneId"] = summonScene
    param["bossMode"] = BattleSubMode.WorldBoss
    param["battleEndConds"] = battleEndConds

    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.BossBattleScene, param)
end

function LuaGameMgr:EnterNewbie()
    if ManagerContainer.FSMMgr:IsBossBattleState() then
        return
    end

    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UILanuch) == false then
        self:OpenLoading(Enum.UIPageName.UILoading,{loadingId = 1})
    end

    -- local param ={}
    -- param["sceneId"] = 2
    -- param["bossMode"] = BattleSubMode.NewbieBoss

    -- ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.BossBattleScene, param)

    -- self:ShowNewbieLoading()
    self:EnterBattle(true)
end

--- 播放剧情动画
function LuaGameMgr:PlayStory(storyType, storyId)
    if storyType == Enum.StoryType.Dlg then
        if storyId <= 0 then
            storyId = self:GetCurStoryId()
        end
        if storyId then
            ManagerContainer.UIStoryMgr:StartStoryByStoryId(storyId)
            return
        end
    elseif storyType == Enum.StoryType.EnterNewMap then
        if storyId <= 0 then
            storyId = self:GetCurStoryId()
        end
        if storyId then
            if ManagerContainer.StoryMgr:StartStoryChapterById(storyId) then
                return
            end
        end
    end
    self:StopStory(storyType)
end

function LuaGameMgr:GetCurStoryId()
    local luaBattleMgr = ManagerContainer.LuaBattleMgr
    if not luaBattleMgr then return nil end
    local id = luaBattleMgr:GetCurLevelUniqueId()
    if not id then return nil end
    local cfgMgr = ManagerContainer.CfgMgr
    if not cfgMgr then return nil end
    local levelCfgData = cfgMgr:GetLevelDataById(id)
    if not levelCfgData then return nil end
    return levelCfgData.DlgContentId
end

function LuaGameMgr:StopStory(storyType)
    LuaBattleBridge.CurStoryOver(storyType)
end

function LuaGameMgr:SetCreateRoleStatus(status)
    self.IsCreateRole = status
end

function LuaGameMgr:OpenLoading(pageId,param)
    self.loadingPageOk = false
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Loaded_Page_OK, self, self.OnLoadingPageOk)
    ManagerContainer.LuaUIMgr:Open(pageId,param)
end

function LuaGameMgr:OnLoadingPageOk()
    LogWarning("LuaGameMgr:OpenLoading OK ")
    self.loadingPageOk = true
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Loaded_Page_OK, self, self.OnLoadingPageOk)
end

function LuaGameMgr:LoadCommonUIAssets()
    ManagerContainer.ResMgr:LoadAssetGameObjects(Constants.EffectPath, ELoadType.OTHER, function()
	end, unpack(Constant.Quality_FX))

    ManagerContainer.ResMgr:InitCommonMats()
end

function LuaGameMgr:ShowNewbieLoading()
    self.showNiewbieLoading = true
end

function LuaGameMgr:LuaSaveGameSpeed(speed)
    self:SaveGameSpeed(speed)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetString(tostring(uid).."_GameSpeed",tostring(speed))
end

function LuaGameMgr:LoadGameSpeed()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local speedStr = UnityEngine.PlayerPrefs.GetString(tostring(uid).."_GameSpeed")
    if speedStr ~= nil and speedStr ~= "" then
        self:SaveGameSpeed(tonumber(speedStr))
    else
        self:SaveGameSpeed(1)
    end
end

function LuaGameMgr:PreloadFellowsModel()
    if self.isPreloadedFellow == true  then
        return
    end

    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    local fellows = System.Array.CreateInstance(Enum.TypeInfo.ActorData,#partnerDatas)
    local idx = 0
	for _,v in pairs(partnerDatas) do
		if v ~= nil  and  not v.isBattle then
            local fellowActor = ActorData.CreateFellowActor(v.configId)
            fellows[idx] = fellowActor
            idx = idx + 1
		end
	end
       
    self:PreloadAllFellows(fellows)
    self.isPreloadedFellow = true
end

function LuaGameMgr:UrlQuestionRewardResult(success)
    if success then
        ManagerContainer.DataMgr.UserData:SendQuestionReward()
    end
end

return LuaGameMgr