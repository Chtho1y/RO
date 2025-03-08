local ManagerContainer = class("ManagerContainer")

function ManagerContainer:ctor()
end

function ManagerContainer:Init()
	self.CfgMgr = require("CfgMgr"):new()
end

function ManagerContainer:InitMgr()
    self.PlayerPrefsMgr = require("PlayerPrefsMgr"):new()
    self.LuaGameMgr = require("LuaGameMgr"):new()
    --self.CfgMgr = require("CfgMgr"):new()
    self.NetManager = require("NetManager"):new()
    self.PbManager = require("PbManager"):new()
    self.LuaEventMgr = require("LuaEventMgr"):new()
    self.RedPointSimpleMgr = require("RedPointSimpleMgr"):new()
    self.LuaModelMgr = require("LuaModelMgr"):new()
    -- self.LuaStoryMgr = require("LuaStoryMgr"):new()
    self.LuaTimerMgr = require("LuaTimerMgr"):new()
    self.DataMgr = require("DataMgr"):new()
    self.FSMMgr = require("FSMMgr"):new()
    self.ResMgr = require("ResMgr"):new()
    self.LuaMusicMgr = require("LuaMusicMgr"):new()
    self.GoPoolMgr = require("GoPoolMgr"):new()
    self.LuaUIMgr = require("LuaUIMgr"):new()
    self.AnimatorMgr = require("AnimatorMgr"):new()
    self.LuaActorDataMgr = require("LuaActorDataMgr"):new()
    self.LuaActorAttributeMgr = require('LuaActorAttributeMgr'):new()
    self.LuaBattleMgr = require("LuaBattleMgr"):new()
    self.LuaGuildLobbyMgr = require("LuaGuildLobbyMgr"):new()
    self.LuaDojoMgr = require("LuaDojoMgr"):new()
    self.LuaBossBattleMgr = require("LuaBossBattleMgr"):new()
    self.LuaTimeBattleMgr = require("LuaTimeBattleMgr"):new()
    self.PopGotMgr = require("PopGotMgr"):new()
    self.NewGotTipsMgr = require("NewGotTipsMgr"):new()
    self.RedPointMgr = require("RedPointMgr"):new()
    self.UIJumpMgr = require("UIJumpMgr"):new()
    self.UIFuncUnlockMgr = require("UIFuncUnlockMgr"):new()
    self.UIStoryMgr = require("UIStoryMgr"):new()
    self.StoryMgr = require("StoryMgr"):new()
    self.ExecuteSequenceMgr = require("ExecuteSequenceMgr"):new()
    self.ActivityMgr = require("ActivityMgr"):new();
    self.ForceGuideMgr = require("ForceGuideMgr"):new();
    self.BattleFailedTipsMgr = require("BattleFailedTipsMgr"):new()
    self.VipChangeMgr = require('VipChangeMgr'):new()
    self.PayMgr = require('PayMgr'):new()
    self.LoginMgr = require('LoginMgr'):new()
end

function ManagerContainer:Update()
    self.FSMMgr:Update()
    self.LuaTimerMgr:Update()
end

function ManagerContainer:Reset()
    if self.LuaUIMgr then
        self.LuaUIMgr:CloseAllPage()
    end
    if self.DataMgr then
        self.DataMgr:ResetAllData()
    end
    if self.LuaBattleMgr then
        self.LuaBattleMgr:StopSyncServerTimeTimer()
    end
    if self.LuaTimerMgr then
        self.LuaTimerMgr:RemoveAllTimer()
    end
    if self.NetManager then
        self.NetManager:ResetNetMgr()
    end
    if self.RedPointMgr then
        self.RedPointMgr:Init()
    end
    if self.PayMgr then
        self.PayMgr:Clear()
    end
    if self.VipChangeMgr then
        self.VipChangeMgr:Clear()
    end
    if self.LuaActorAttributeMgr then
        self.LuaActorAttributeMgr:Clear()
    end
end

function ManagerContainer:FieldDestroy(field)
    if field and field.Destroy then
        field:Destroy()
    end
end

function ManagerContainer:Destroy()
    self:FieldDestroy(self.LoginMgr)
    self:FieldDestroy(self.PayMgr)
    self:FieldDestroy(self.VipChangeMgr)
    self:FieldDestroy(self.LuaActorAttributeMgr)
    self:FieldDestroy(self.ExecuteSequenceMgr)
    self:FieldDestroy(self.StoryMgr)
    self:FieldDestroy(self.RedPointSimpleMgr)
    self:FieldDestroy(self.UIFuncUnlockMgr)
    self:FieldDestroy(self.RedPointMgr)
    self:FieldDestroy(self.NewGotTipsMgr)
    self:FieldDestroy(self.PopGotMgr)
    self:FieldDestroy(self.LuaGuildLobbyMgr)
    self:FieldDestroy(self.LuaBossBattleMgr)
    self:FieldDestroy(self.LuaTimeBattleMgr)
    self:FieldDestroy(self.GoPoolMgr)
    self:FieldDestroy(self.LuaUIMgr)
    self:FieldDestroy(self.LuaMusicMgr)
    self:FieldDestroy(self.LuaActorDataMgr)
    self:FieldDestroy(self.DataMgr)
    self:FieldDestroy(self.AnimatorMgr)
    self:FieldDestroy(self.FSMMgr)
    self:FieldDestroy(self.PbManager)
    self:FieldDestroy(self.NetManager)
    self:FieldDestroy(self.LuaTimerMgr)
    self:FieldDestroy(self.LuaEventMgr)
    -- self:FieldDestroy(self.LuaStoryMgr)
    self:FieldDestroy(self.LuaModelMgr)
    self:FieldDestroy(self.LuaGameMgr)
    self:FieldDestroy(self.LuaBattleMgr)
    self:FieldDestroy(self.LuaDojoMgr)
    self:FieldDestroy(self.UIJumpMgr)
    self:FieldDestroy(self.ResMgr)
    self:FieldDestroy(self.CfgMgr)
    self:FieldDestroy(self.PlayerPrefsMgr)
    self:FieldDestroy(self.UIStoryMgr)
    self:FieldDestroy(self.ActivityMgr)
    self:FieldDestroy(self.BattleFailedTipsMgr)

    self.LuaActorAttributeMgr = nil
    self.NewGotTipsMgr = nil
    self.PopGotMgr = nil
    self.LuaGuildLobbyMgr = nil
    self.GoPoolMgr = nil
    self.LuaUIMgr = nil
    self.LuaMusicMgr = nil
    self.AnimatorMgr = nil
    self.DataMgr = nil
    self.ResMgr = nil
    self.LuaActorDataMgr = nil
    self.LuaTimerMgr = nil
    self.LuaEventMgr = nil
    self.CfgMgr = nil
    self.PbManager = nil
    self.NetManager = nil
    self.FSMMgr = nil
    self.LuaModelMgr = nil
    -- self.LuaStoryMgr = nil
    self.LuaGameMgr = nil
    self.LuaBattleMgr = nil
    self.LuaDojoMgr = nil
    self.UIJumpMgr = nil
    self.PlayerPrefsMgr = nil
    self.LuaBossBattleMgr = nil
    self.LuaTimeBattleMgr = nil
    self.UIStoryMgr = nil
    self.StoryMgr = nil
    self.ExecuteSequenceMgr = nil
    self.ActivityMgr = nil
    self.BattleFailedTipsMgr = nil
    self.VipChangeMgr = nil
    self.PayMgr = nil
    self.LoginMgr = nil
end

return ManagerContainer