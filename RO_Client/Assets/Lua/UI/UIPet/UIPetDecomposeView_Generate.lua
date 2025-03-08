---@class UIPetDecompose__Generate_btnSure
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_returnUI_btnRight
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_btnCancleText
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_returnUI_btnCancle
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_dscTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_noticeTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_returnUI_btnClose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_returnUI_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_returnUI
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator
---@field public AnyBtn UIPetDecompose__Generate_returnUI_AnyBtn
---@field public btnClose UIPetDecompose__Generate_returnUI_btnClose
---@field public scrollView UnityEngine.GameObject
---@field public content UnityEngine.GameObject
---@field public btnCancle UIPetDecompose__Generate_returnUI_btnCancle
---@field public btnRight UIPetDecompose__Generate_returnUI_btnRight

---@class UIPetDecompose__Generate_btnPetShop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_btnDecompose_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_btnDecompose
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIPetDecompose__Generate_btnDecompose_text

---@class UIPetDecompose__Generate_btnOneKey_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_btnOneKey
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public off UnityEngine.GameObject
---@field public on UnityEngine.GameObject
---@field public text UIPetDecompose__Generate_btnOneKey_text

---@class UIPetDecompose__Generate_number
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIPetDecompose__Generate_btnBack
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_desTxt
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript
---@field public contentSizeFitter UnityEngine.UI.ContentSizeFitter

---@class UIPetDecompose__Generate_iconPetItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetDecompose__Generate_iconItem
---@field public gameObject UnityEngine.GameObject
---@field public rectTransform UnityEngine.RectTransform
---@field public layoutElement UnityEngine.UI.LayoutElement

---@class UIPetDecompose__Generate_scrollview
---@field public gameObject UnityEngine.GameObject
---@field public loopGridView SuperScrollView.LoopGridView

---@class UIPetDecompose__Generate_decompose_text
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_btnFilter
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public check UnityEngine.GameObject

---@class UIPetDecompose__Generate_decompose
---@field public gameObject UnityEngine.GameObject
---@field public text UIPetDecompose__Generate_decompose_text

---@class UIPetDecompose__Generate_boardTitle
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_btnPlayRule
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_decomposeDsc
---@field public gameObject UnityEngine.GameObject
---@field public uILocalizeScript UILocalizeScript

---@class UIPetDecompose__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIPetDecompose__Generate_uIAnimator
---@field public gameObject UnityEngine.GameObject
---@field public animator UnityEngine.Animator

---@class UIPetDecompose__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private uIAnimator UIPetDecompose__Generate_uIAnimator
---@field private AnyBtn UIPetDecompose__Generate_AnyBtn
---@field private decomposeDsc UIPetDecompose__Generate_decomposeDsc
---@field private btnPlayRule UIPetDecompose__Generate_btnPlayRule
---@field private boardTitle UIPetDecompose__Generate_boardTitle
---@field private decompose UIPetDecompose__Generate_decompose
---@field private btnFilter UIPetDecompose__Generate_btnFilter
---@field private scrollview UIPetDecompose__Generate_scrollview
---@field private smallPets UnityEngine.GameObject
---@field private iconItem UIPetDecompose__Generate_iconItem
---@field private iconPetItem UIPetDecompose__Generate_iconPetItem
---@field private noPets UnityEngine.GameObject
---@field private desTxt UIPetDecompose__Generate_desTxt
---@field private btnBack UIPetDecompose__Generate_btnBack
---@field private iconpet UnityEngine.GameObject
---@field private iconartifact UnityEngine.GameObject
---@field private number UIPetDecompose__Generate_number
---@field private btnOneKey UIPetDecompose__Generate_btnOneKey
---@field private btnDecompose UIPetDecompose__Generate_btnDecompose
---@field private btnPetShop UIPetDecompose__Generate_btnPetShop
---@field private mask UnityEngine.GameObject
---@field private returnUI UIPetDecompose__Generate_returnUI
---@field private noticeTitle UIPetDecompose__Generate_noticeTitle
---@field private dscTxt UIPetDecompose__Generate_dscTxt
---@field private btnBox UnityEngine.GameObject
---@field private btnCancleText UIPetDecompose__Generate_btnCancleText
---@field private btnSure UIPetDecompose__Generate_btnSure
local UIPetDecomposeView = class("UIPetDecomposeView", require("UIViewBase"))

function UIPetDecomposeView:ctor()
end

---@private
function UIPetDecomposeView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIPetDecomposeView:InitGenerate(Root, data)
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
	self:InitGenerate__27(Root,data)
	self:InitGenerate__28(Root,data)
	self:InitGenerate__29(Root,data)
	self:InitGenerate__30(Root,data)
	self:InitGenerate__31(Root,data)
	self:InitGenerate__32(Root,data)
	self:InitGenerate__33(Root,data)
	self:InitGenerate__34(Root,data)
	self:InitGenerate__35(Root,data)
	self:InitGenerate__36(Root,data)
	self:InitGenerate__37(Root,data)
	self:InitGenerate__38(Root,data)
	self:InitGenerate__39(Root,data)


end

---@private
function UIPetDecomposeView:InitGenerate__1(Root, data)
--[[
	UIAnimator
--]]
	local tmp = Root:Find("UIAnimator").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uIAnimator = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIPetDecomposeView:InitGenerate__2(Root, data)
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
function UIPetDecomposeView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/BGBoli/Boli/TalkBox/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BGBoli/Boli/TalkBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decomposeDsc = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/BtnBg/BtnPlayRule
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBg/BtnPlayRule").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPlayRule = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/BoardTitle
--]]
	local tmp = Root:Find("UIAnimator/Window/BoardTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.boardTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/Decompose
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/Decompose/BtnFilter
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/BtnFilter").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFilter = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/Decompose/BtnFilter/Check
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/BtnFilter/Check").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnFilter.check = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/Decompose/bg3/Dsc/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/bg3/Dsc/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.decompose.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/Decompose/scrollview
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/scrollview").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.scrollview = tmp

	tmp.loopGridView = tmp:GetComponent(Enum.TypeInfo.LoopGridView)
end

---@private
function UIPetDecomposeView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/Decompose/scrollview/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/scrollview/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.smallPets = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/Decompose/scrollview/Viewport/Content/IconItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/scrollview/Viewport/Content/IconItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
	self.iconItem.prefabName = "IconItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetDecomposeView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/Decompose/scrollview/Viewport/Content/IconPetItem
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/scrollview/Viewport/Content/IconPetItem").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconPetItem = CommonUtil.BindGridViewItem2LuaStatic("IconPetItem", tmp)
	self.iconPetItem.prefabName = "IconPetItem"

	tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)

	tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function UIPetDecomposeView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/Decompose/NoPets
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/NoPets").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noPets = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/Decompose/NoPets/DesTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Decompose/NoPets/DesTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.desTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)

	tmp.contentSizeFitter = tmp:GetComponent(Enum.TypeInfo.ContentSizeFitter)
end

---@private
function UIPetDecomposeView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBack = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/ChosenNum/iconpet
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/iconpet").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconpet = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/ChosenNum/iconartifact
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/iconartifact").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.iconartifact = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/ChosenNum/Number
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/Number").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.number = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIPetDecomposeView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/ChosenNum/BtnOneKey
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/BtnOneKey").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKey = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/ChosenNum/BtnOneKey/off
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/BtnOneKey/off").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKey.off = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/ChosenNum/BtnOneKey/on
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/BtnOneKey/on").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKey.on = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/ChosenNum/BtnOneKey/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/ChosenNum/BtnOneKey/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnOneKey.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/BtnDecompose
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnDecompose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDecompose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/BtnDecompose/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnDecompose/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnDecompose.text = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/BtnPetShop
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnPetShop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnPetShop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/Mask
--]]
	local tmp = Root:Find("UIAnimator/Window/Mask").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.mask = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__28(Root, data)
--[[
	UIAnimator/ReturnUI
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI = tmp

	tmp.animator = tmp:GetComponent(Enum.TypeInfo.Animator)
	tmp.animator.logWarnings = false
end

---@private
function UIPetDecomposeView:InitGenerate__29(Root, data)
--[[
	UIAnimator/ReturnUI/Alpha
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Alpha").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.AnyBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__30(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnClose
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnClose").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.btnClose = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__31(Root, data)
--[[
	UIAnimator/ReturnUI/Window/NoticeTitle
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/NoticeTitle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.noticeTitle = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__32(Root, data)
--[[
	UIAnimator/ReturnUI/Window/Boli/TalkBox/Text
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/Boli/TalkBox/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.dscTxt = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__33(Root, data)
--[[
	UIAnimator/ReturnUI/Window/Scroll View
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/Scroll View").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.scrollView = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__34(Root, data)
--[[
	UIAnimator/ReturnUI/Window/Scroll View/Viewport/Content
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/Scroll View/Viewport/Content").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.content = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__35(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnBox
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnBox").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnBox = tmp
end

---@private
function UIPetDecomposeView:InitGenerate__36(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnBox/BtnCancle
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnBox/BtnCancle").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.btnCancle = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__37(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnBox/BtnCancle/Text
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnBox/BtnCancle/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnCancleText = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:InitGenerate__38(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnBox/BtnRight
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnBox/BtnRight").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.returnUI.btnRight = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIPetDecomposeView:InitGenerate__39(Root, data)
--[[
	UIAnimator/ReturnUI/Window/BtnBox/BtnRight/Text
--]]
	local tmp = Root:Find("UIAnimator/ReturnUI/Window/BtnBox/BtnRight/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnSure = tmp

	tmp.uILocalizeScript = tmp:GetComponent(Enum.TypeInfo.UILocalizeScript)
end

---@private
function UIPetDecomposeView:GenerateDestroy()
	if tolua.getpeer(self.returnUI.btnRight) ~= nil then
		tolua.setpeer(self.returnUI.btnRight, nil)
	end
	if tolua.getpeer(self.returnUI.btnCancle) ~= nil then
		tolua.setpeer(self.returnUI.btnCancle, nil)
	end
	if tolua.getpeer(self.returnUI.content) ~= nil then
		tolua.setpeer(self.returnUI.content, nil)
	end
	if tolua.getpeer(self.returnUI.scrollView) ~= nil then
		tolua.setpeer(self.returnUI.scrollView, nil)
	end
	if tolua.getpeer(self.returnUI.btnClose) ~= nil then
		tolua.setpeer(self.returnUI.btnClose, nil)
	end
	if tolua.getpeer(self.returnUI.AnyBtn) ~= nil then
		tolua.setpeer(self.returnUI.AnyBtn, nil)
	end
	if tolua.getpeer(self.btnDecompose.text) ~= nil then
		tolua.setpeer(self.btnDecompose.text, nil)
	end
	if tolua.getpeer(self.btnOneKey.text) ~= nil then
		tolua.setpeer(self.btnOneKey.text, nil)
	end
	if tolua.getpeer(self.btnOneKey.on) ~= nil then
		tolua.setpeer(self.btnOneKey.on, nil)
	end
	if tolua.getpeer(self.btnOneKey.off) ~= nil then
		tolua.setpeer(self.btnOneKey.off, nil)
	end
	if tolua.getpeer(self.decompose.text) ~= nil then
		tolua.setpeer(self.decompose.text, nil)
	end
	if tolua.getpeer(self.btnFilter.check) ~= nil then
		tolua.setpeer(self.btnFilter.check, nil)
	end
	if tolua.getpeer(self.uIAnimator) ~= nil then
		tolua.setpeer(self.uIAnimator, nil)
	end
	self.uIAnimator = nil
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.decomposeDsc) ~= nil then
		tolua.setpeer(self.decomposeDsc, nil)
	end
	self.decomposeDsc = nil
	if tolua.getpeer(self.btnPlayRule) ~= nil then
		tolua.setpeer(self.btnPlayRule, nil)
	end
	self.btnPlayRule = nil
	if tolua.getpeer(self.boardTitle) ~= nil then
		tolua.setpeer(self.boardTitle, nil)
	end
	self.boardTitle = nil
	if tolua.getpeer(self.decompose) ~= nil then
		tolua.setpeer(self.decompose, nil)
	end
	self.decompose = nil
	if tolua.getpeer(self.btnFilter) ~= nil then
		tolua.setpeer(self.btnFilter, nil)
	end
	self.btnFilter = nil
	if tolua.getpeer(self.scrollview) ~= nil then
		tolua.setpeer(self.scrollview, nil)
	end
	self.scrollview = nil
	if tolua.getpeer(self.smallPets) ~= nil then
		tolua.setpeer(self.smallPets, nil)
	end
	self.smallPets = nil
	if self.iconItem.GenerateDestroy ~= nil then
		self.iconItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconItem) ~= nil then
		tolua.setpeer(self.iconItem, nil)
	end
	self.iconItem = nil
	if self.iconPetItem.GenerateDestroy ~= nil then
		self.iconPetItem:GenerateDestroy()
	end
	if tolua.getpeer(self.iconPetItem) ~= nil then
		tolua.setpeer(self.iconPetItem, nil)
	end
	self.iconPetItem = nil
	if tolua.getpeer(self.noPets) ~= nil then
		tolua.setpeer(self.noPets, nil)
	end
	self.noPets = nil
	if tolua.getpeer(self.desTxt) ~= nil then
		tolua.setpeer(self.desTxt, nil)
	end
	self.desTxt = nil
	if tolua.getpeer(self.btnBack) ~= nil then
		tolua.setpeer(self.btnBack, nil)
	end
	self.btnBack = nil
	if tolua.getpeer(self.iconpet) ~= nil then
		tolua.setpeer(self.iconpet, nil)
	end
	self.iconpet = nil
	if tolua.getpeer(self.iconartifact) ~= nil then
		tolua.setpeer(self.iconartifact, nil)
	end
	self.iconartifact = nil
	if tolua.getpeer(self.number) ~= nil then
		tolua.setpeer(self.number, nil)
	end
	self.number = nil
	if tolua.getpeer(self.btnOneKey) ~= nil then
		tolua.setpeer(self.btnOneKey, nil)
	end
	self.btnOneKey = nil
	if tolua.getpeer(self.btnDecompose) ~= nil then
		tolua.setpeer(self.btnDecompose, nil)
	end
	self.btnDecompose = nil
	if tolua.getpeer(self.btnPetShop) ~= nil then
		tolua.setpeer(self.btnPetShop, nil)
	end
	self.btnPetShop = nil
	if tolua.getpeer(self.mask) ~= nil then
		tolua.setpeer(self.mask, nil)
	end
	self.mask = nil
	if tolua.getpeer(self.returnUI) ~= nil then
		tolua.setpeer(self.returnUI, nil)
	end
	self.returnUI = nil
	if tolua.getpeer(self.noticeTitle) ~= nil then
		tolua.setpeer(self.noticeTitle, nil)
	end
	self.noticeTitle = nil
	if tolua.getpeer(self.dscTxt) ~= nil then
		tolua.setpeer(self.dscTxt, nil)
	end
	self.dscTxt = nil
	if tolua.getpeer(self.btnBox) ~= nil then
		tolua.setpeer(self.btnBox, nil)
	end
	self.btnBox = nil
	if tolua.getpeer(self.btnCancleText) ~= nil then
		tolua.setpeer(self.btnCancleText, nil)
	end
	self.btnCancleText = nil
	if tolua.getpeer(self.btnSure) ~= nil then
		tolua.setpeer(self.btnSure, nil)
	end
	self.btnSure = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIPetDecomposeView