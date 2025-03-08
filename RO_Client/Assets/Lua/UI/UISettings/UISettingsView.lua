local UISettingsView = require("UISettings/UISettingsView_Generate")

local DefaultVolumeValue = 0.2
local MuteVolumeThreshold = 0.01

function UISettingsView:OnAwake(data)
	self.controller = require("UISettings/UISettingsCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISettingsView:AddEventListener()
end

function UISettingsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISettingsView:Init()
	self.verText.text.text = ManagerContainer.LuaGameMgr.ResVersion
	self:RefreshServerInfo()
	self:RefreshMusic()
	self:RefreshSound()
end

function UISettingsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISettingsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.alpha.button, self, self.OnClickClose)

	--TODO:这个版本暂时隐藏
	--self.uiBase:AddButtonEventListener(self.changeServerButton.button, self, self.OnChangeServerClick)
	CommonUtil.SetTotalChildrenGray(self.changeServerButton, true)
	self.changeServerButton.button.interactable = false;

	self.uiBase:AddToggleEventListener(self.music.toggle.toggle, self, self.OnClickToggleMusic, nil)
	self.uiBase:AddSliderEventListener(self.music.slider.slider, self, self.OnValueChangeMusic, nil)
	self.uiBase:AddToggleEventListener(self.sound.toggle.toggle, self, self.OnClickToggleSound, nil)
	self.uiBase:AddSliderEventListener(self.sound.slider.slider, self, self.OnValueChangeSound, nil)
end

function UISettingsView:OnHide()
	--- TODO:下次打开重新获得数据,未来看功能使用频率，可优化发送速度，避免服务器压力
	ManagerContainer.DataMgr.HeadProtraitData:SetVaild()
end

function UISettingsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UISettingsView:OnClose()
	ManagerContainer.DataMgr.HeadProtraitData:SetVaild()
end

function UISettingsView:OnDispose()
	self.dots = nil

end


function UISettingsView:RefreshJobIcon()
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
	CommonUtil.LoadIcon(self, jobCfgData.JobIcon, function (sprite)
        self.head.jobIcon.image.sprite = sprite
    end, self, 'jobIconIdx')
end

function UISettingsView:RefreshServerInfo()
	local record = UnityEngine.PlayerPrefs.GetInt(Constant.SELECT_SERVER_INDEX_KEY, 1)
	self.serverNameTxt.text.text = UnityEngine.PlayerPrefs.GetString("ServerName");
end

function UISettingsView:RefreshMusic()
	local musicMgr = MusicMgr.Instance
	self.music.toggle.toggle.isOn = musicMgr.MuteMusic
	self.music.slider.slider.value = musicMgr.MuteMusic and 0 or musicMgr.MusicVolume
end

function UISettingsView:RefreshSound()
	local musicMgr = MusicMgr.Instance
	self.sound.toggle.toggle.isOn = musicMgr.MuteSound
	self.sound.slider.slider.value = musicMgr.MuteSound and 0 or musicMgr.SoundVolume
end

function UISettingsView:OnClickClose()
	self:UIClose()
end

--点击了切换服务器的按钮
function UISettingsView:OnChangeServerClick()
	local _openId = UnityEngine.PlayerPrefs.GetString("LoginName")
	local _curType = UnityEngine.PlayerPrefs.GetString("ServerType");
	local url = PlatformPack.SERVERLIST_URL .. "?type=" .. _curType .. "&openid = " .. _openId; --"http://101.133.164.98:8088/serverlist?type=" .. _curType .. "&openid = " .. _openId
	local OnRequestHttpCb = function(serverInfo)
		local _server = JSON:decode(serverInfo)

		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeServer, {_server});
	end
	ManagerContainer.LuaGameMgr:RequestHttpServer(url,OnRequestHttpCb)
	self:OnClickClose();
end

function UISettingsView:OnClickToggleMusic(toggle, params, value)
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount('lastMMFC') then
		return
	end
	local musicMgr = MusicMgr.Instance
	local muteMusic = musicMgr.MuteMusic
	if muteMusic == value then return end
	musicMgr.MuteMusic = value
	musicMgr.MusicVolume = value and 0 or DefaultVolumeValue
	self:RefreshMusic()
end

function UISettingsView:OnValueChangeMusic(slider, value)
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount('lastMVFC') then
		return
	end
	local musicMgr = MusicMgr.Instance
	local musicVolume = musicMgr.MusicVolume
	if musicVolume == value then return end
	if value < MuteVolumeThreshold then
		musicMgr.MuteMusic = true
		value = 0
	elseif musicMgr.MuteMusic then
		musicMgr.MuteMusic = false
	end
	musicMgr.MusicVolume = value
	self:RefreshMusic()
end

function UISettingsView:OnClickToggleSound(toggle, params, value)
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount('lastMSFC') then
		return
	end
	local musicMgr = MusicMgr.Instance
	local muteSound = musicMgr.MuteSound
	if muteSound == value then return end
	musicMgr.MuteSound = value
	musicMgr.SoundVolume = value and 0 or DefaultVolumeValue
	self:RefreshSound()
end

function UISettingsView:OnValueChangeSound(slider, value)
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount('lasetSVFC') then
		return
	end
	local musicMgr = MusicMgr.Instance
	local soundVolume = musicMgr.SoundVolume
	if soundVolume == value then return end
	if value < MuteVolumeThreshold then
		musicMgr.MuteSound = true
		value = 0
	elseif musicMgr.MuteSound then
		musicMgr.MuteSound = false
	end
	musicMgr.SoundVolume = value
	self:RefreshSound()
end

function UISettingsView:IsSomeFrameCount(keyName)
	local value = self[keyName]
	if value and value >= Time.frameCount then
		return true
	end
	self[keyName] = Time.frameCount
	return false
end


return UISettingsView

