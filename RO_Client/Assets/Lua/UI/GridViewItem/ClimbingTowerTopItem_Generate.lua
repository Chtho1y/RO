---@class ClimbingTowerTopItem__Generate_levelNum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerTopItem__Generate_btnBuy_num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerTopItem__Generate_btnBuy_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerTopItem__Generate_btnBuy
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public icon ClimbingTowerTopItem__Generate_btnBuy_icon
---@field public num ClimbingTowerTopItem__Generate_btnBuy_num

---@class ClimbingTowerTopItem__Generate_iconSmallItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class ClimbingTowerTopItem__Generate_scrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class ClimbingTowerTopItem__Generate_challengeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ClimbingTowerTopItem__Generate_center
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerTopItem__Generate_right
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerTopItem__Generate_left
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerTopItem__Generate_btnMessage
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class ClimbingTowerTopItem__Generate_atknum
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class ClimbingTowerTopItem__Generate_servertext
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ClimbingTowerTopItem__Generate_nametext
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class ClimbingTowerTopItem__Generate_roleModel
---@field public gameObject UnityEngine.GameObject
---@field public rawImage UnityEngine.UI.RawImage
---@field public uIEventTriggerListener UIEventTriggerListener

---@class ClimbingTowerTopItem__Generate_pos
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class ClimbingTowerTopItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private playerNode UnityEngine.GameObject
---@field private pos ClimbingTowerTopItem__Generate_pos
---@field private roleModel ClimbingTowerTopItem__Generate_roleModel
---@field private nametext ClimbingTowerTopItem__Generate_nametext
---@field private servertext ClimbingTowerTopItem__Generate_servertext
---@field private atknum ClimbingTowerTopItem__Generate_atknum
---@field private btnMessage ClimbingTowerTopItem__Generate_btnMessage
---@field private bottomNode UnityEngine.GameObject
---@field private left ClimbingTowerTopItem__Generate_left
---@field private right ClimbingTowerTopItem__Generate_right
---@field private center ClimbingTowerTopItem__Generate_center
---@field private challengeBtn ClimbingTowerTopItem__Generate_challengeBtn
---@field private passedNode UnityEngine.GameObject
---@field private cover UnityEngine.GameObject
---@field private rewards UnityEngine.GameObject
---@field private scrollView ClimbingTowerTopItem__Generate_scrollView
---@field private content UnityEngine.GameObject
---@field private iconSmallItem ClimbingTowerTopItem__Generate_iconSmallItem
---@field private btnBuy ClimbingTowerTopItem__Generate_btnBuy
---@field private levelNum ClimbingTowerTopItem__Generate_levelNum
local ClimbingTowerTopItemView = class("ClimbingTowerTopItemView")

function ClimbingTowerTopItemView:ctor()
end

---@private
function ClimbingTowerTopItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function ClimbingTowerTopItemView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	local tmp

	self:InitGenerate__1(Root,data)
	self:InitGenerate__2(Root,data)
	self:InitGenerate__3(Root,data)
	self:InitGenerate__4(Root,data)
	self:InitGenerate__5(Root,data)
	self:InitGenerate__6(Root,data)
	self:InitGenerate__7(Root,data)
	self:InitGenerate__8(Root,data)
	self:InitGenerate__9(Root,data)
	self:InitGenerate__10(Root,data)
	self:InitGenerate__11(Root,data)
	self:InitGenerate__12(Root,data)
	self:InitGenerate__13(Root,data)
	self:InitGenerate__14(Root,data)
	self:InitGenerate__15(Root,data)
	self:InitGenerate__16(Root,data)
	self:InitGenerate__17(Root,data)
	self:InitGenerate__18(Root,data)
	self:InitGenerate__19(Root,data)
	self:InitGenerate__20(Root,data)
	self:InitGenerate__21(Root,data)
	self:InitGenerate__22(Root,data)
	self:InitGenerate__23(Root,data)


end

---@private
function ClimbingTowerTopItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function ClimbingTowerTopItemView:InitGenerate__2(Root, data)
--[[
	PlayerNode
--]]
	local tmp = Root:Find("PlayerNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.playerNode = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__3(Root, data)
--[[
	PlayerNode/Pos
--]]
	local tmp = Root:Find("PlayerNode/Pos").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.pos = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__4(Root, data)
--[[
	PlayerNode/RoleModel
--]]
	local tmp = Root:Find("PlayerNode/RoleModel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.roleModel = tmp

	tmp.rawImage = tmp:GetComponent(Enum.TypeInfo.RawImage)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__5(Root, data)
--[[
	PlayerNode/Info/nametext
--]]
	local tmp = Root:Find("PlayerNode/Info/nametext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nametext = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__6(Root, data)
--[[
	PlayerNode/Info/servertext
--]]
	local tmp = Root:Find("PlayerNode/Info/servertext").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.servertext = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__7(Root, data)
--[[
	PlayerNode/Info/Atk/atknum
--]]
	local tmp = Root:Find("PlayerNode/Info/Atk/atknum").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.atknum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__8(Root, data)
--[[
	PlayerNode/Info/BtnMessage
--]]
	local tmp = Root:Find("PlayerNode/Info/BtnMessage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnMessage = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__9(Root, data)
--[[
	Bottom
--]]
	local tmp = Root:Find("Bottom").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bottomNode = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__10(Root, data)
--[[
	Bottom/left
--]]
	local tmp = Root:Find("Bottom/left").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.left = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__11(Root, data)
--[[
	Bottom/right
--]]
	local tmp = Root:Find("Bottom/right").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.right = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__12(Root, data)
--[[
	Bottom/center
--]]
	local tmp = Root:Find("Bottom/center").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.center = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__13(Root, data)
--[[
	ChallengeBtn
--]]
	local tmp = Root:Find("ChallengeBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.challengeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__14(Root, data)
--[[
	PassedNode
--]]
	local tmp = Root:Find("PassedNode").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.passedNode = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__15(Root, data)
--[[
	Cover
--]]
	local tmp = Root:Find("Cover").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cover = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__16(Root, data)
--[[
	Rewards
--]]
	local tmp = Root:Find("Rewards").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewards = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__17(Root, data)
--[[
	Rewards/Flag/ScrollView
--]]
	local tmp = Root:Find("Rewards/Flag/ScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollView = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__18(Root, data)
--[[
	Rewards/Flag/ScrollView/Viewport/Content
--]]
	local tmp = Root:Find("Rewards/Flag/ScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp
end

---@private
function ClimbingTowerTopItemView:InitGenerate__19(Root, data)
--[[
	Rewards/Flag/ScrollView/Viewport/Content/IconSmallItem
--]]
	local tmp = Root:Find("Rewards/Flag/ScrollView/Viewport/Content/IconSmallItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconSmallItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__20(Root, data)
--[[
	BtnBuy
--]]
	local tmp = Root:Find("BtnBuy").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__21(Root, data)
--[[
	BtnBuy/Content/Icon
--]]
	local tmp = Root:Find("BtnBuy/Content/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__22(Root, data)
--[[
	BtnBuy/Content/num
--]]
	local tmp = Root:Find("BtnBuy/Content/num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBuy.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerTopItemView:InitGenerate__23(Root, data)
--[[
	Top/LevelNumTxt
--]]
	local tmp = Root:Find("Top/LevelNumTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.levelNum = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function ClimbingTowerTopItemView:GenerateDestroy()
	if tolua.getpeer(self.levelNum) ~= nil then
		tolua.setpeer(self.levelNum, nil)
	end
	if tolua.getpeer(self.btnBuy.num) ~= nil then
		tolua.setpeer(self.btnBuy.num, nil)
	end
	if tolua.getpeer(self.btnBuy.icon) ~= nil then
		tolua.setpeer(self.btnBuy.icon, nil)
	end
	if tolua.getpeer(self.btnBuy) ~= nil then
		tolua.setpeer(self.btnBuy, nil)
	end
	if tolua.getpeer(self.cover) ~= nil then
		tolua.setpeer(self.cover, nil)
	end
	if tolua.getpeer(self.passedNode) ~= nil then
		tolua.setpeer(self.passedNode, nil)
	end
	if tolua.getpeer(self.challengeBtn) ~= nil then
		tolua.setpeer(self.challengeBtn, nil)
	end
	if tolua.getpeer(self.bottomNode) ~= nil then
		tolua.setpeer(self.bottomNode, nil)
	end
	if tolua.getpeer(self.btnMessage) ~= nil then
		tolua.setpeer(self.btnMessage, nil)
	end
	if tolua.getpeer(self.atknum) ~= nil then
		tolua.setpeer(self.atknum, nil)
	end
	if tolua.getpeer(self.servertext) ~= nil then
		tolua.setpeer(self.servertext, nil)
	end
	if tolua.getpeer(self.nametext) ~= nil then
		tolua.setpeer(self.nametext, nil)
	end
	if tolua.getpeer(self.roleModel) ~= nil then
		tolua.setpeer(self.roleModel, nil)
	end
	if tolua.getpeer(self.pos) ~= nil then
		tolua.setpeer(self.pos, nil)
	end
	if tolua.getpeer(self.playerNode) ~= nil then
		tolua.setpeer(self.playerNode, nil)
	end
	if tolua.getpeer(self.left) ~= nil then
		tolua.setpeer(self.left, nil)
	end
	self.left = nil
	if tolua.getpeer(self.right) ~= nil then
		tolua.setpeer(self.right, nil)
	end
	self.right = nil
	if tolua.getpeer(self.center) ~= nil then
		tolua.setpeer(self.center, nil)
	end
	self.center = nil
	if tolua.getpeer(self.rewards) ~= nil then
		tolua.setpeer(self.rewards, nil)
	end
	self.rewards = nil
	if tolua.getpeer(self.scrollView) ~= nil then
		tolua.setpeer(self.scrollView, nil)
	end
	self.scrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if self.iconSmallItem.GenerateDestroy ~= nil then
		self.iconSmallItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconSmallItem) ~= nil then
		tolua.setpeer(self.iconSmallItem, nil)
	end
	self.iconSmallItem = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return ClimbingTowerTopItemView