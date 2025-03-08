local UIFuncMenuView = require("UIGuild/UIFuncMenuView_Generate")

local AlignmentMinMax =
{
	[Enum.Alignment.UpperLeft] = {Vector2(0, -1), Vector2(1, 0), Vector2(0, 0)},
	[Enum.Alignment.UpperCenter] = {Vector2(-0.5, -1), Vector2(0.5, 0), Vector2(-0.5, 0)},
	[Enum.Alignment.UpperRight] = {Vector2(-1, -1), Vector2(0, 0), Vector2(-1, 0)},
	[Enum.Alignment.MiddleLeft] = {Vector2(0, -0.5), Vector2(1, 0.5), Vector2(0, 0.5)},
	[Enum.Alignment.MiddleCenter] = {Vector2(-0.5, -0.5), Vector2(0.5, 0.5), Vector2(-0.5, 0.5)},
	[Enum.Alignment.MiddleRight] = {Vector2(-1, -0.5), Vector2(0, 0.5), Vector2(-1, 0.5)},
	[Enum.Alignment.LowerLeft] = {Vector2(0, 0), Vector2(1, 1), Vector2(0, 1)},
	[Enum.Alignment.LowerCenter] = {Vector2(-0.5, 0), Vector2(0.5, 1), Vector2(-0.5, 1)},
	[Enum.Alignment.LowerRight] = {Vector2(-1, 0), Vector2(0, 1), Vector2(-1, 1)},
}

local AlignmentPriority =
{
	[Enum.Alignment.UpperLeft] = {
		Enum.Alignment.UpperCenter, Enum.Alignment.UpperRight,
		Enum.Alignment.MiddleLeft, Enum.Alignment.LowerLeft, Enum.Alignment.MiddleCenter,
		Enum.Alignment.LowerCenter, Enum.Alignment.MiddleRight, Enum.Alignment.LowerRight
	},
	[Enum.Alignment.UpperCenter] = {
		Enum.Alignment.UpperLeft, Enum.Alignment.UpperRight,
		Enum.Alignment.MiddleCenter, Enum.Alignment.LowerCenter, Enum.Alignment.MiddleLeft,
		Enum.Alignment.LowerLeft, Enum.Alignment.MiddleRight, Enum.Alignment.LowerRight
	},
	[Enum.Alignment.UpperRight] = {
		Enum.Alignment.UpperCenter, Enum.Alignment.UpperLeft,
		Enum.Alignment.MiddleRight, Enum.Alignment.LowerRight, Enum.Alignment.MiddleCenter,
		Enum.Alignment.LowerCenter, Enum.Alignment.MiddleLeft, Enum.Alignment.LowerLeft
	},
	[Enum.Alignment.MiddleLeft] = {
		Enum.Alignment.MiddleCenter, Enum.Alignment.MiddleRight,
		Enum.Alignment.UpperLeft, Enum.Alignment.LowerLeft, Enum.Alignment.UpperCenter,
		Enum.Alignment.LowerCenter, Enum.Alignment.UpperRight, Enum.Alignment.LowerRight
	},
	[Enum.Alignment.MiddleCenter] = {
		Enum.Alignment.MiddleLeft, Enum.Alignment.MiddleRight,
		Enum.Alignment.UpperCenter, Enum.Alignment.LowerCenter, Enum.Alignment.UpperLeft,
		Enum.Alignment.UpperRight, Enum.Alignment.LowerLeft, Enum.Alignment.LowerRight
	},
	[Enum.Alignment.MiddleRight] = {
		Enum.Alignment.MiddleCenter, Enum.Alignment.MiddleLeft,
		Enum.Alignment.UpperRight, Enum.Alignment.LowerRight, Enum.Alignment.UpperCenter,
		Enum.Alignment.LowerCenter, Enum.Alignment.UpperLeft, Enum.Alignment.LowerLeft
	},
	[Enum.Alignment.LowerLeft] = {
		Enum.Alignment.LowerCenter, Enum.Alignment.LowerRight,
		Enum.Alignment.MiddleLeft, Enum.Alignment.UpperLeft, Enum.Alignment.MiddleCenter,
		Enum.Alignment.MiddleRight, Enum.Alignment.UpperCenter, Enum.Alignment.UpperRight
	},
	[Enum.Alignment.LowerCenter] = {
		Enum.Alignment.LowerLeft, Enum.Alignment.LowerRight,
		Enum.Alignment.MiddleCenter, Enum.Alignment.UpperCenter, Enum.Alignment.MiddleLeft,
		Enum.Alignment.MiddleRight, Enum.Alignment.UpperLeft, Enum.Alignment.UpperRight
	},
	[Enum.Alignment.LowerRight] = {
		Enum.Alignment.LowerCenter, Enum.Alignment.LowerLeft,
		Enum.Alignment.MiddleRight, Enum.Alignment.UpperRight, Enum.Alignment.MiddleCenter,
		Enum.Alignment.MiddleLeft, Enum.Alignment.UpperCenter, Enum.Alignment.UpperLeft
	},
}

function UIFuncMenuView:OnAwake(data)
	self.controller = require("UIGuild/UIFuncMenuCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFuncMenuView:AddEventListener()

end

function UIFuncMenuView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFuncMenuView:Init()
	-- 初始化按钮列表
	self.menuBtns = {self.btn}

	self:RefreshMenus()
	self:RefreshAlignPos()
end

function UIFuncMenuView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFuncMenuView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.mask.button, self, self.OnClickEmptyArea)
end

function UIFuncMenuView:OnHide()

end

function UIFuncMenuView:OnShow(data)
	self.controller:SetData(data)

end

function UIFuncMenuView:OnClose()
end

function UIFuncMenuView:OnDispose()
	self.controller:OnDispose()
	for _, menuBtn in pairs(self.menuBtns) do
		if menuBtn ~= self.btn then
			menuBtn.button = nil
			menuBtn.text.text = nil
			if tolua.getpeer(menuBtn.text) ~= nil then
				tolua.setpeer(menuBtn.text, nil)
			end
			menuBtn.text = nil
			CommonUtil.DestroyGO(menuBtn)
			if tolua.getpeer(menuBtn) ~= nil then
				tolua.setpeer(menuBtn, nil)
			end
		end
	end
	self.menuBtns = nil
end

function UIFuncMenuView:RefreshMenus()
	local menus = self.controller:GetMenus()
	local hasNum = #self.menuBtns
	local menuNum = #menus
	local btn, isChangeNum = false
	for i = 1, menuNum do
		local menu = menus[i]
		if hasNum < i then
			local go = UnityEngine.GameObject.Instantiate(self.btn)
			local trans = go.transform
			trans:SetParent(self.btnContainer.rectTransform)
			trans.localPosition = Vector3.zero
			trans.localRotation = Quaternion.identity
			trans.localScale = self.btn.transform.localScale
			if tolua.getpeer(go) == nil then
				tolua.setpeer(go, {})
			end
			btn = go
			btn.button = go:GetComponent(Enum.TypeInfo.Button)
			local textGo = trans:Find("Text").gameObject
			if tolua.getpeer(textGo) == nil then
				tolua.setpeer(textGo, {})
			end
			btn.text = textGo
			btn.text.text = textGo:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
			self.menuBtns[i] = btn
			isChangeNum = true
		else
			btn = self.menuBtns[i]
		end
		isChangeNum = isChangeNum or not btn.activeSelf
		btn:SetActive(true)
		btn.text.text.text = string.formatbykey(menu[1])
		if menu[3] then
			btn.button.interactable = false
			btn.button.onClick:RemoveAllListeners()
		else
			btn.button.interactable = true
			self.uiBase:AddButtonUniqueEventListener(btn.button, self, self.OnClickMenuBtn, i)
		end
	end

	for i = menuNum, hasNum do
		btn = self.menuBtns[i]
		isChangeNum = isChangeNum or btn.activeSelf
		if btn then btn:SetActive(false) end
	end

	-- 需要重新布局，计算Size
	if isChangeNum then
		local layoutGroup = self.btnContainer.verticalLayoutGroup
		layoutGroup:CalculateLayoutInputHorizontal()
		layoutGroup:SetLayoutHorizontal()
		layoutGroup:CalculateLayoutInputVertical()
		layoutGroup:SetLayoutVertical()
		local contentSizeFitter = self.btnContainer.contentSizeFitter
		contentSizeFitter:SetLayoutHorizontal()
		contentSizeFitter:SetLayoutVertical()
	end
end

function UIFuncMenuView:RefreshAlignPos()
	local parent = self.btnContainer.rectTransform.parent
	local parentRect = parent.rect
	local alignPos = self.controller:GetAlignPos()
	local alignment = self.controller:GetAlignment()
	local vaildMin = self.controller:GetVaildMin()
	local vaildMax = self.controller:GetVaildMax()
	if alignPos then
		alignPos = parent:InverseTransformPoint(alignPos)
		alignPos = Vector2(alignPos.x, alignPos.y)
	else
		alignPos = Vector2.zero
	end
	alignPos.z = 0
	if vaildMin then
		vaildMin = parent:InverseTransformPoint(vaildMin)
		vaildMin = Vector2(vaildMin.x, vaildMin.y)
	else
		vaildMin = parentRect.min
	end
	if vaildMax then
		vaildMax = parent:InverseTransformPoint(vaildMax)
		vaildMax = Vector2(vaildMax.x, vaildMax.y)
	else
		vaildMax = parentRect.max
	end
	local size = self.btnContainer.rectTransform.rect.size
	local min, max
	local offMin, offMax, offAnchor
	-- 默认对齐是否按钮
	if alignment then
		offMin, offMax, offAnchor = self:_GetPosByAlignment(alignment)
		min = Vector2.Scale(size, offMin) + alignPos
		max = Vector2.Scale(size, offMax) + alignPos
		self.btnContainer.rectTransform.localPosition = alignPos + Vector2.Scale(size, offAnchor)
		if self:_CheckSafe(min, max, vaildMin, vaildMax) then
			return
		end
	end
	local priority = AlignmentPriority[alignment]
	if priority then
		for i = 1, #priority do
			offMin, offMax, offAnchor = self:_GetPosByAlignment(priority[i])
			min = Vector2.Scale(size, offMin) + alignPos
			max = Vector2.Scale(size, offMax) + alignPos
			if self:_CheckSafe(min, max, vaildMin, vaildMax) then
				self.btnContainer.rectTransform.localPosition = alignPos + Vector2.Scale(size, offAnchor)
				return
			end
		end
	else
		for i = Enum.Alignment.UpperLeft, Enum.Alignment.LowerRight do
			offMin, offMax, offAnchor = self:_GetPosByAlignment(i)
			min = Vector2.Scale(size, offMin) + alignPos
			max = Vector2.Scale(size, offMax) + alignPos
			if self:_CheckSafe(min, max, vaildMin, vaildMax) then
				self.btnContainer.rectTransform.localPosition = alignPos + Vector2.Scale(size, offAnchor)
				return
			end
		end
	end
end

function UIFuncMenuView:OnClickEmptyArea()
	self.controller:ExecuteCancelCallBack(nil)
	self:UIClose()
end

function UIFuncMenuView:OnClickMenuBtn(_, params)
	local idx = params[0]
	self.controller:ExecuteCallBack(idx)
	self:UIClose()
end



--- btnContainer为左上锚点
function UIFuncMenuView:_GetPosByAlignment(alignment)
	local rect = AlignmentMinMax[alignment]
	if not rect then
		rect = AlignmentMinMax[Enum.Alignment.MiddleCenter]
	end
	return rect[1], rect[2], rect[3]
end

function UIFuncMenuView:_CheckSafe(min, max, vaildMin, vaildMax)
	return vaildMin.x <= min.x and vaildMin.y <= min.y and vaildMax.x >= max.x and vaildMax.y >= max.y
end


return UIFuncMenuView

