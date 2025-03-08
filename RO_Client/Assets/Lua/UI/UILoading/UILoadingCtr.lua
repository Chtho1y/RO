local UILoadingCtr = class("UILoadingCtr", require("UICtrBase"))

local _tipIndexRecord;	--这个是记录上一次显示的tip的index

function UILoadingCtr:Init(view)
	self.view = view
end

function UILoadingCtr:SetData(data)
	_tipIndexRecord = -1;
	self.data = data
	self.asyncIdx = 0
	if self.data ~= nil and nil ~= self.data.loadingId then
		self.loadingId = self.data.loadingId
	else
		self.loadingId = 3		--进入迅游的loading id
	end

	local loadingCfg = ManagerContainer.CfgMgr:GetLoadingCfg(self.loadingId)
	if loadingCfg ~= nil  and loadingCfg.imgs~= nil then
		--loading图数据
		self._bgsName = CommonUtil.StringSplit(loadingCfg.imgs,";")

		--小提示数据
		local _tipsId = CommonUtil.StringSplit(loadingCfg.tips, ";");
		self._tips = {};
		for i = 1, #_tipsId do
			local _tip = I18N.T(_tipsId[i]);
			if _tip == nil or _tip == "" then
				DebugHelper.LogError("没有找到id为：" .. _tipsId[i] .. " 的语言内容，请检查LoadingCfg和UIConfig表");
			end
			table.insert(self._tips, _tip);
		end
	end
end

--获取背景图片的名字
function UILoadingCtr:GetBgName()
	local _outPut = "Bg/img_loading_01";
	if self._bgsName then
		local _bgNameCount = #self._bgsName;
		if _bgNameCount == 1 then
			_outPut = self._bgsName[1];
		elseif _bgNameCount > 1 then
			local _outPutIndex = math.random(_bgNameCount);
			_outPut = self._bgsName[_outPutIndex];
		end
	end
	return _outPut;
end

--获取小提示
function UILoadingCtr:GetTipString()
	local _outPut = "没有配置小提示哦！";
	if self._tips then
		local _tipsCount = #self._tips;
		if _tipsCount == 1 then
			_outPut = self._tips[1];
		elseif _tipsCount > 1 then
			local _outPutIndex = _tipIndexRecord;
			while _outPutIndex == _tipIndexRecord do
				_outPutIndex = math.random(_tipsCount);
			end
			_tipIndexRecord = _outPutIndex;
			_outPut = self._tips[_tipIndexRecord];
		end
	end
	return _outPut;
end

function UILoadingCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UILoadingCtr:OnDispose()
	self.data = nil
	self.view = nil
end
return UILoadingCtr

