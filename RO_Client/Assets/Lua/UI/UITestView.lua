local UITestView = require("UILogin/UITestView_Generate")

function UITestView:OnAwake(data)
	self.controller = require("UILogin/UILoginCtr"):new()
	self.controller:Init(self)
end

function UITestView:AddEventListener()
	-- local list = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
	-- CommonUtil.LoopGridViewEleCreate(self, self.scrollView.loopHorizontalScrollRect, list, 2000, function (itemLua, idx)
	-- 	-- print(itemLua.gameObject.name)
	-- 	-- print(idx)
	-- end)
end


function UITestView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	--	Filter and Sort
	-- local a = {}
	-- for i = 1,10 do
	-- 	local b = {a = i, b = i/2, c = math.fmod( i, 2)}
	-- 	a[#a + 1] = b
	-- end
	-- Log(Inspect(a))
	-- local list = CommonUtil.ArrayFilterSelections(a, Enum.FilterType.AND, {"a", "b"}, {1, 0.5})
	-- a[3].a = 5
	-- a[4].a = 5
	-- CommonUtil.ArraySortSelections(a, Enum.TableSortRule.Down, "a", "b")
	-- Log(Inspect(a))

	--NetConnectTest()

	-- ManagerContainer.ResMgr:LuaLoadAssetSprite(Constants.UITexturePath, ELoadType.UI, function (obj, path, name)
	-- 	self.image.image.sprite = obj
	-- end, "1")
end

function UITestView:RemoveEventListener()
	-- ManagerContainer.LuaEventMgr:Dispatch("hallo")
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UITestView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, "hallo", function()
	-- 	print("hello")
	-- end)
	self.uiBase:AddButtonEventListener(self.start.button, function()
		--self.controller:OnStartClick()
		-- ManagerContainer.NetManager:NetRegister(ProtoMsgId.response, function (data)
		-- 	print(Inspect(data))
		-- end)
	
		-- ManagerContainer.NetManager:SendMessage(ProtoMsgId.request, {open_id = "haha"})

		-- ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, Enum.SceneType.Battle)
	end)

	-- self.start.repeatButton:AddRepeatClickEventListener(function ()
	-- 	Log("repeatButton  eff")
	-- end)

	-- ManagerContainer.LuaTimerMgr:AddTimer(3000, 5, false, function(sequence, param)
	-- 	print("sequence  "..sequence)
	-- end, nil)
end

function UITestView:OnHide()

end

function UITestView:OnShow()

end

function UITestView:OnClose()

end

function UITestView:OnDispose()
	--self.content.loopHorizontalScrollRect:DestroyCells();

end

return UITestView

