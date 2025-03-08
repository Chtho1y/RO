---@class UIGuildRecommend__Generate_btnRefresh
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_btnCreate
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_closeBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_searchBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_clearBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_input
---@field public gameObject UnityEngine.GameObject
---@field public inputField UnityEngine.UI.InputField

---@class UIGuildRecommend__Generate_guildRecommendItem
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate_guildList
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIGuildRecommend__Generate_titleLab4
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildRecommend__Generate_titleLab3
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildRecommend__Generate_titleLab1
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildRecommend__Generate_emptyTips_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIGuildRecommend__Generate_emptyTips
---@field public gameObject UnityEngine.GameObject
---@field public desTxt UIGuildRecommend__Generate_emptyTips_desTxt

---@class UIGuildRecommend__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIGuildRecommend__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIGuildRecommend__Generate_AnyBtn
---@field private emptyTips UIGuildRecommend__Generate_emptyTips
---@field private titleLab1 UIGuildRecommend__Generate_titleLab1
---@field private titleLab3 UIGuildRecommend__Generate_titleLab3
---@field private titleLab4 UIGuildRecommend__Generate_titleLab4
---@field private guildList UIGuildRecommend__Generate_guildList
---@field private guildRecommendItem UIGuildRecommend__Generate_guildRecommendItem
---@field private input UIGuildRecommend__Generate_input
---@field private clearBtn UIGuildRecommend__Generate_clearBtn
---@field private searchBtn UIGuildRecommend__Generate_searchBtn
---@field private closeBtn UIGuildRecommend__Generate_closeBtn
---@field private btnCreate UIGuildRecommend__Generate_btnCreate
---@field private btnRefresh UIGuildRecommend__Generate_btnRefresh
local UIGuildRecommendView = class("UIGuildRecommendView", require("UIViewBase"))

function UIGuildRecommendView:ctor()
end

---@private
function UIGuildRecommendView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIGuildRecommendView:InitGenerate(Root, data)
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


end

---@private
function UIGuildRecommendView:InitGenerate__1(Root, data)
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
function UIGuildRecommendView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/EmptyTips
--]]
	local tmp = Root:Find("UIAnimator/Window/EmptyTips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyTips = tmp
end

---@private
function UIGuildRecommendView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/EmptyTips/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/EmptyTips/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.emptyTips.desTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildRecommendView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TitleLab1
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleLab1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleLab1 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildRecommendView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/TitleLab3
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleLab3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleLab3 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildRecommendView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/TitleLab4
--]]
	local tmp = Root:Find("UIAnimator/Window/TitleLab4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.titleLab4 = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIGuildRecommendView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/GuildList
--]]
	local tmp = Root:Find("UIAnimator/Window/GuildList").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildList = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIGuildRecommendView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/GuildList/Viewport/Content/GuildRecommendItem
--]]
	local tmp = Root:Find("UIAnimator/Window/GuildList/Viewport/Content/GuildRecommendItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.guildRecommendItem = CommonUtil.BindGridViewItem2LuaStatic("GuildRecommendItem", tmp)
	self.guildRecommendItem.prefabName = "GuildRecommendItem"

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/SearchNode/Input
--]]
	local tmp = Root:Find("UIAnimator/Window/SearchNode/Input").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.input = tmp

	tmp.inputField = tmp:GetComponent(Enum.TypeInfo.InputField)
end

---@private
function UIGuildRecommendView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/SearchNode/ClearBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/SearchNode/ClearBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.clearBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/SearchNode/SearchBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/SearchNode/SearchBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.searchBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.closeBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/BtnCreate
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnCreate").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCreate = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/BtnRefresh
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnRefresh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRefresh = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIGuildRecommendView:GenerateDestroy()
	if tolua.getpeer(self.emptyTips.desTxt) ~= nil then
		tolua.setpeer(self.emptyTips.desTxt, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.emptyTips) ~= nil then
		tolua.setpeer(self.emptyTips, nil)
	end
	self.emptyTips = nil
	if tolua.getpeer(self.titleLab1) ~= nil then
		tolua.setpeer(self.titleLab1, nil)
	end
	self.titleLab1 = nil
	if tolua.getpeer(self.titleLab3) ~= nil then
		tolua.setpeer(self.titleLab3, nil)
	end
	self.titleLab3 = nil
	if tolua.getpeer(self.titleLab4) ~= nil then
		tolua.setpeer(self.titleLab4, nil)
	end
	self.titleLab4 = nil
	if tolua.getpeer(self.guildList) ~= nil then
		tolua.setpeer(self.guildList, nil)
	end
	self.guildList = nil
	if self.guildRecommendItem.GenerateDestroy ~= nil then
		self.guildRecommendItem:GenerateDestroy()
	end
	if tolua.getpeer(self.guildRecommendItem) ~= nil then
		tolua.setpeer(self.guildRecommendItem, nil)
	end
	self.guildRecommendItem = nil
	if tolua.getpeer(self.input) ~= nil then
		tolua.setpeer(self.input, nil)
	end
	self.input = nil
	if tolua.getpeer(self.clearBtn) ~= nil then
		tolua.setpeer(self.clearBtn, nil)
	end
	self.clearBtn = nil
	if tolua.getpeer(self.searchBtn) ~= nil then
		tolua.setpeer(self.searchBtn, nil)
	end
	self.searchBtn = nil
	if tolua.getpeer(self.closeBtn) ~= nil then
		tolua.setpeer(self.closeBtn, nil)
	end
	self.closeBtn = nil
	if tolua.getpeer(self.btnCreate) ~= nil then
		tolua.setpeer(self.btnCreate, nil)
	end
	self.btnCreate = nil
	if tolua.getpeer(self.btnRefresh) ~= nil then
		tolua.setpeer(self.btnRefresh, nil)
	end
	self.btnRefresh = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIGuildRecommendView