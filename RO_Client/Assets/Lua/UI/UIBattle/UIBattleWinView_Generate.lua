---@class UIBattleWin__Generate_drop_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_drop
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_drop_text

---@class UIBattleWin__Generate_coin_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_coin
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_coin_text

---@class UIBattleWin__Generate_expJob_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_expJob
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_expJob_text

---@class UIBattleWin__Generate_expParter_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_expParter
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_expParter_text

---@class UIBattleWin__Generate_zeny_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_zeny
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_zeny_text

---@class UIBattleWin__Generate_expBase_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIBattleWin__Generate_expBase
---@field public gameObject UnityEngine.GameObject
---@field public text UIBattleWin__Generate_expBase_text

---@class UIBattleWin__Generate_bigMap_linePath
---@field public gameObject UnityEngine.GameObject
---@field public uIBigMapLine UIBigMapLine

---@class UIBattleWin__Generate_bigMap_bottomImage
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public image UnityEngine.UI.Image

---@class UIBattleWin__Generate_bigMap_content
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform

---@class UIBattleWin__Generate_bigMap
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public content UIBattleWin__Generate_bigMap_content
---@field public bottomImage UIBattleWin__Generate_bigMap_bottomImage
---@field public linePath UIBattleWin__Generate_bigMap_linePath
---@field public smallPoints UnityEngine.GameObject
---@field public bigPoints UnityEngine.GameObject
---@field public startPoint UnityEngine.GameObject
---@field public storyPoints UnityEngine.GameObject
---@field public oneRank UnityEngine.GameObject
---@field public selfContainer UnityEngine.GameObject

---@class UIBattleWin__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIBattleWin__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UnityEngine.GameObject
---@field private AnyBtn UIBattleWin__Generate_AnyBtn
---@field private window UnityEngine.GameObject
---@field private bigMap UIBattleWin__Generate_bigMap
---@field private expBase UIBattleWin__Generate_expBase
---@field private zeny UIBattleWin__Generate_zeny
---@field private expParter UIBattleWin__Generate_expParter
---@field private expJob UIBattleWin__Generate_expJob
---@field private coin UIBattleWin__Generate_coin
---@field private drop UIBattleWin__Generate_drop
local UIBattleWinView = class("UIBattleWinView", require("UIViewBase"))

function UIBattleWinView:ctor()
end

---@private
function UIBattleWinView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIBattleWinView:InitGenerate(Root, data)
	self.transform = Root
	self.inited = true

	if self.super.Init then
		self.super.Init(self)
	end
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
	self:InitGenerate__24(Root,data)
	self:InitGenerate__25(Root,data)


end

---@private
function UIBattleWinView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp
end

---@private
function UIBattleWinView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Alpha
--]]
	local tmp = Root:Find("UIAnimator/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIBattleWinView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window
--]]
	local tmp = Root:Find("UIAnimator/Window").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.window = tmp
end

---@private
function UIBattleWinView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIBattleWinView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.content = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
end

---@private
function UIBattleWinView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/BottomImage
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/BottomImage").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.bottomImage = tmp

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIBattleWinView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/LinePath
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/LinePath").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.linePath = tmp

	tmp.uIBigMapLine = tmp:GetComponent(Enum.TypeInfo.UIBigMapLine)
end

---@private
function UIBattleWinView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/SmallPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/SmallPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.smallPoints = tmp
end

---@private
function UIBattleWinView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/BigPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/BigPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.bigPoints = tmp
end

---@private
function UIBattleWinView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/StartPoint
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/StartPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.startPoint = tmp
end

---@private
function UIBattleWinView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/StoryPoints
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/StoryPoints").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.storyPoints = tmp
end

---@private
function UIBattleWinView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/OneRank
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/OneRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.oneRank = tmp
end

---@private
function UIBattleWinView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/SelfContainer
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Map/Map/BigMap/Viewport/Content/SelfContainer").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bigMap.selfContainer = tmp
end

---@private
function UIBattleWinView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpBase
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpBase").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expBase = tmp
end

---@private
function UIBattleWinView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpBase/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpBase/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expBase.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Zeny
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Zeny").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.zeny = tmp
end

---@private
function UIBattleWinView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Zeny/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Zeny/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.zeny.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpParter
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpParter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expParter = tmp
end

---@private
function UIBattleWinView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpParter/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpParter/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expParter.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpJob
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpJob").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expJob = tmp
end

---@private
function UIBattleWinView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/ExpJob/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/ExpJob/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.expJob.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Coin
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Coin").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coin = tmp
end

---@private
function UIBattleWinView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Coin/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Coin/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.coin.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Drop
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Drop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.drop = tmp
end

---@private
function UIBattleWinView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BG/Coinreward/Group/Drop/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/Coinreward/Group/Drop/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.drop.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIBattleWinView:GenerateDestroy()
	if tolua.getpeer(self.drop.text) ~= nil then
		tolua.setpeer(self.drop.text, nil)
	end
	if tolua.getpeer(self.coin.text) ~= nil then
		tolua.setpeer(self.coin.text, nil)
	end
	if tolua.getpeer(self.expJob.text) ~= nil then
		tolua.setpeer(self.expJob.text, nil)
	end
	if tolua.getpeer(self.expParter.text) ~= nil then
		tolua.setpeer(self.expParter.text, nil)
	end
	if tolua.getpeer(self.zeny.text) ~= nil then
		tolua.setpeer(self.zeny.text, nil)
	end
	if tolua.getpeer(self.expBase.text) ~= nil then
		tolua.setpeer(self.expBase.text, nil)
	end
	if tolua.getpeer(self.bigMap.selfContainer) ~= nil then
		tolua.setpeer(self.bigMap.selfContainer, nil)
	end
	if tolua.getpeer(self.bigMap.oneRank) ~= nil then
		tolua.setpeer(self.bigMap.oneRank, nil)
	end
	if tolua.getpeer(self.bigMap.storyPoints) ~= nil then
		tolua.setpeer(self.bigMap.storyPoints, nil)
	end
	if tolua.getpeer(self.bigMap.startPoint) ~= nil then
		tolua.setpeer(self.bigMap.startPoint, nil)
	end
	if tolua.getpeer(self.bigMap.bigPoints) ~= nil then
		tolua.setpeer(self.bigMap.bigPoints, nil)
	end
	if tolua.getpeer(self.bigMap.smallPoints) ~= nil then
		tolua.setpeer(self.bigMap.smallPoints, nil)
	end
	if tolua.getpeer(self.bigMap.linePath) ~= nil then
		tolua.setpeer(self.bigMap.linePath, nil)
	end
	if tolua.getpeer(self.bigMap.bottomImage) ~= nil then
		tolua.setpeer(self.bigMap.bottomImage, nil)
	end
	if tolua.getpeer(self.bigMap.content) ~= nil then
		tolua.setpeer(self.bigMap.content, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.window) ~= nil then
		tolua.setpeer(self.window, nil)
	end
	self.window = nil
	if tolua.getpeer(self.bigMap) ~= nil then
		tolua.setpeer(self.bigMap, nil)
	end
	self.bigMap = nil
	if tolua.getpeer(self.expBase) ~= nil then
		tolua.setpeer(self.expBase, nil)
	end
	self.expBase = nil
	if tolua.getpeer(self.zeny) ~= nil then
		tolua.setpeer(self.zeny, nil)
	end
	self.zeny = nil
	if tolua.getpeer(self.expParter) ~= nil then
		tolua.setpeer(self.expParter, nil)
	end
	self.expParter = nil
	if tolua.getpeer(self.expJob) ~= nil then
		tolua.setpeer(self.expJob, nil)
	end
	self.expJob = nil
	if tolua.getpeer(self.coin) ~= nil then
		tolua.setpeer(self.coin, nil)
	end
	self.coin = nil
	if tolua.getpeer(self.drop) ~= nil then
		tolua.setpeer(self.drop, nil)
	end
	self.drop = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIBattleWinView