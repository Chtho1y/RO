---@class UIHundredDojoReward__Generate_content
---@field public gameObject UnityEngine.GameObject
---@field public gridLayoutGroup UnityEngine.UI.GridLayoutGroup

---@class UIHundredDojoReward__Generate_itemScrollView
---@field public gameObject UnityEngine.GameObject
---@field public loopVerticalScrollRect UnityEngine.UI.LoopVerticalScrollRect

---@class UIHundredDojoReward__Generate_receiveRes3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_receiveRes3_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_receiveRes3
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_receiveRes3_icon
---@field public text UIHundredDojoReward__Generate_receiveRes3_text

---@class UIHundredDojoReward__Generate_receiveRes2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_receiveRes2_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_receiveRes2
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_receiveRes2_icon
---@field public text UIHundredDojoReward__Generate_receiveRes2_text

---@class UIHundredDojoReward__Generate_receiveRes1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_receiveRes1_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_receiveRes1
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_receiveRes1_icon
---@field public text UIHundredDojoReward__Generate_receiveRes1_text

---@class UIHundredDojoReward__Generate_rewardTimeTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_currency3_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_currency3_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_currency3
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_currency3_icon
---@field public text UIHundredDojoReward__Generate_currency3_text

---@class UIHundredDojoReward__Generate_currency2_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_currency2_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_currency2
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_currency2_icon
---@field public text UIHundredDojoReward__Generate_currency2_text

---@class UIHundredDojoReward__Generate_currency1_text
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIHundredDojoReward__Generate_currency1_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class UIHundredDojoReward__Generate_currency1
---@field public gameObject UnityEngine.GameObject
---@field public icon UIHundredDojoReward__Generate_currency1_icon
---@field public text UIHundredDojoReward__Generate_currency1_text

---@class UIHundredDojoReward__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIHundredDojoReward__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIHundredDojoReward__Generate_AnyBtn
---@field private timingBox UnityEngine.GameObject
---@field private currency1 UIHundredDojoReward__Generate_currency1
---@field private currency2 UIHundredDojoReward__Generate_currency2
---@field private currency3 UIHundredDojoReward__Generate_currency3
---@field private talkBox UnityEngine.GameObject
---@field private rewardTimeTxt UIHundredDojoReward__Generate_rewardTimeTxt
---@field private receiveRes1 UIHundredDojoReward__Generate_receiveRes1
---@field private receiveRes2 UIHundredDojoReward__Generate_receiveRes2
---@field private receiveRes3 UIHundredDojoReward__Generate_receiveRes3
---@field private receiveIcons UnityEngine.GameObject
---@field private itemScrollView UIHundredDojoReward__Generate_itemScrollView
---@field private content UIHundredDojoReward__Generate_content
---@field private nothing UnityEngine.GameObject
local UIHundredDojoRewardView = class("UIHundredDojoRewardView", require("UIViewBase"))

function UIHundredDojoRewardView:ctor()
end

---@private
function UIHundredDojoRewardView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIHundredDojoRewardView:InitGenerate(Root, data)
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
	self:InitGenerate__26(Root,data)


end

---@private
function UIHundredDojoRewardView:InitGenerate__1(Root, data)
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
function UIHundredDojoRewardView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.timingBox = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency1/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency1/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency1/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency2/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency2/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency2/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency3/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency3/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/Profit/Currency3/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/Profit/Currency3/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.currency3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/TalkBox
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/TalkBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.talkBox = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BG/TimingBox/TalkBox/RewardTime/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/TimingBox/TalkBox/RewardTime/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardTimeTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes1 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes1.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes1/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes1.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes2 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes2.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes2/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes2.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes3 = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3/Icon
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3/Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes3.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function UIHundredDojoRewardView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveRes/ReceiveRes3/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveRes3.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIHundredDojoRewardView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveIcons
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveIcons").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.receiveIcons = tmp
end

---@private
function UIHundredDojoRewardView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/ItemScrollView
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/ItemScrollView").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.itemScrollView = tmp

	tmp.loopVerticalScrollRect = tmp:GetComponent(Enum.TypeInfo.LoopVerticalScrollRect)
end

---@private
function UIHundredDojoRewardView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/ItemScrollView/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/ItemScrollView/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.content = tmp

	tmp.gridLayoutGroup = tmp:GetComponent(Enum.TypeInfo.GridLayoutGroup)
end

---@private
function UIHundredDojoRewardView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/Nothing
--]]
	local tmp = Root:Find("UIAnimator/Window/BG/ReceiveBox/ReceiveIcons/Nothing").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nothing = tmp
end

---@private
function UIHundredDojoRewardView:GenerateDestroy()
	if tolua.getpeer(self.receiveRes3.text) ~= nil then
		tolua.setpeer(self.receiveRes3.text, nil)
	end
	if tolua.getpeer(self.receiveRes3.icon) ~= nil then
		tolua.setpeer(self.receiveRes3.icon, nil)
	end
	if tolua.getpeer(self.receiveRes2.text) ~= nil then
		tolua.setpeer(self.receiveRes2.text, nil)
	end
	if tolua.getpeer(self.receiveRes2.icon) ~= nil then
		tolua.setpeer(self.receiveRes2.icon, nil)
	end
	if tolua.getpeer(self.receiveRes1.text) ~= nil then
		tolua.setpeer(self.receiveRes1.text, nil)
	end
	if tolua.getpeer(self.receiveRes1.icon) ~= nil then
		tolua.setpeer(self.receiveRes1.icon, nil)
	end
	if tolua.getpeer(self.currency3.text) ~= nil then
		tolua.setpeer(self.currency3.text, nil)
	end
	if tolua.getpeer(self.currency3.icon) ~= nil then
		tolua.setpeer(self.currency3.icon, nil)
	end
	if tolua.getpeer(self.currency2.text) ~= nil then
		tolua.setpeer(self.currency2.text, nil)
	end
	if tolua.getpeer(self.currency2.icon) ~= nil then
		tolua.setpeer(self.currency2.icon, nil)
	end
	if tolua.getpeer(self.currency1.text) ~= nil then
		tolua.setpeer(self.currency1.text, nil)
	end
	if tolua.getpeer(self.currency1.icon) ~= nil then
		tolua.setpeer(self.currency1.icon, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.timingBox) ~= nil then
		tolua.setpeer(self.timingBox, nil)
	end
	self.timingBox = nil
	if tolua.getpeer(self.currency1) ~= nil then
		tolua.setpeer(self.currency1, nil)
	end
	self.currency1 = nil
	if tolua.getpeer(self.currency2) ~= nil then
		tolua.setpeer(self.currency2, nil)
	end
	self.currency2 = nil
	if tolua.getpeer(self.currency3) ~= nil then
		tolua.setpeer(self.currency3, nil)
	end
	self.currency3 = nil
	if tolua.getpeer(self.talkBox) ~= nil then
		tolua.setpeer(self.talkBox, nil)
	end
	self.talkBox = nil
	if tolua.getpeer(self.rewardTimeTxt) ~= nil then
		tolua.setpeer(self.rewardTimeTxt, nil)
	end
	self.rewardTimeTxt = nil
	if tolua.getpeer(self.receiveRes1) ~= nil then
		tolua.setpeer(self.receiveRes1, nil)
	end
	self.receiveRes1 = nil
	if tolua.getpeer(self.receiveRes2) ~= nil then
		tolua.setpeer(self.receiveRes2, nil)
	end
	self.receiveRes2 = nil
	if tolua.getpeer(self.receiveRes3) ~= nil then
		tolua.setpeer(self.receiveRes3, nil)
	end
	self.receiveRes3 = nil
	if tolua.getpeer(self.receiveIcons) ~= nil then
		tolua.setpeer(self.receiveIcons, nil)
	end
	self.receiveIcons = nil
	if tolua.getpeer(self.itemScrollView) ~= nil then
		tolua.setpeer(self.itemScrollView, nil)
	end
	self.itemScrollView = nil
	if tolua.getpeer(self.content) ~= nil then
		tolua.setpeer(self.content, nil)
	end
	self.content = nil
	if tolua.getpeer(self.nothing) ~= nil then
		tolua.setpeer(self.nothing, nil)
	end
	self.nothing = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIHundredDojoRewardView