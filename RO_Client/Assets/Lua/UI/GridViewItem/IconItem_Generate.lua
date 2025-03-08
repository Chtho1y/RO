---@class IconItem__Generate_locked
---@field public gameObject UnityEngine.GameObject
---@field public locked UnityEngine.GameObject

---@class IconItem__Generate_artifactLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconItem__Generate_artifactStar_star5
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class IconItem__Generate_artifactStar_star4
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class IconItem__Generate_artifactStar_star3
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class IconItem__Generate_artifactStar_star2
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class IconItem__Generate_artifactStar_star1
---@field public gameObject UnityEngine.GameObject
---@field public star UnityEngine.GameObject

---@class IconItem__Generate_artifactStar
---@field public gameObject UnityEngine.GameObject
---@field public star1 IconItem__Generate_artifactStar_star1
---@field public star2 IconItem__Generate_artifactStar_star2
---@field public star3 IconItem__Generate_artifactStar_star3
---@field public star4 IconItem__Generate_artifactStar_star4
---@field public star5 IconItem__Generate_artifactStar_star5

---@class IconItem__Generate_label
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_advenceLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconItem__Generate_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconItem__Generate_refineLv
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconItem__Generate_num
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class IconItem__Generate_piece
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_cardLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_sexLabel
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_job
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_level
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_frameLead
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_frame
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class IconItem__Generate_icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public uIEventTriggerListener UIEventTriggerListener

---@class IconItem__Generate_bg
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class IconItem__Generate_shadow
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image
---@field public button UnityEngine.UI.Button

---@class IconItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private rectTransform UnityEngine.RectTransform
---@field private layoutElement UnityEngine.UI.LayoutElement
---@field private shadow IconItem__Generate_shadow
---@field private bg IconItem__Generate_bg
---@field private icon IconItem__Generate_icon
---@field private frame IconItem__Generate_frame
---@field private frameLead IconItem__Generate_frameLead
---@field private level IconItem__Generate_level
---@field private job IconItem__Generate_job
---@field private limited UnityEngine.GameObject
---@field private sexLabel IconItem__Generate_sexLabel
---@field private cardLabel IconItem__Generate_cardLabel
---@field private piece IconItem__Generate_piece
---@field private num IconItem__Generate_num
---@field private refineLv IconItem__Generate_refineLv
---@field private qualityFX UnityEngine.GameObject
---@field private conertips UnityEngine.GameObject
---@field private text IconItem__Generate_text
---@field private repeatSign UnityEngine.GameObject
---@field private advence UnityEngine.GameObject
---@field private advenceLv IconItem__Generate_advenceLv
---@field private vip UnityEngine.GameObject
---@field private label IconItem__Generate_label
---@field private redPoint UnityEngine.GameObject
---@field private artifactStar IconItem__Generate_artifactStar
---@field private artifactLv IconItem__Generate_artifactLv
---@field private selected UnityEngine.GameObject
---@field private locked IconItem__Generate_locked
local IconItemView = class("IconItemView")

function IconItemView:ctor()
end

---@private
function IconItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function IconItemView:InitGenerate(Root, data)
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


end

---@private
function IconItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]

	self.rectTransform = Root:GetComponent(Enum.TypeInfo.RectTransform)

	self.layoutElement = Root:GetComponent(Enum.TypeInfo.LayoutElement)
end

---@private
function IconItemView:InitGenerate__2(Root, data)
--[[
	shadow
--]]
	local tmp = Root:Find("shadow").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.shadow = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IconItemView:InitGenerate__3(Root, data)
--[[
	bg
--]]
	local tmp = Root:Find("bg").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.bg = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function IconItemView:InitGenerate__4(Root, data)
--[[
	Icon
--]]
	local tmp = Root:Find("Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)

	tmp.uIEventTriggerListener = tmp:GetComponent(Enum.TypeInfo.UIEventTriggerListener)
end

---@private
function IconItemView:InitGenerate__5(Root, data)
--[[
	Frame
--]]
	local tmp = Root:Find("Frame").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frame = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__6(Root, data)
--[[
	FrameLead
--]]
	local tmp = Root:Find("FrameLead").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.frameLead = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__7(Root, data)
--[[
	Level
--]]
	local tmp = Root:Find("Level").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.level = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__8(Root, data)
--[[
	Job
--]]
	local tmp = Root:Find("Job").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.job = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__9(Root, data)
--[[
	Limited
--]]
	local tmp = Root:Find("Limited").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.limited = tmp
end

---@private
function IconItemView:InitGenerate__10(Root, data)
--[[
	SexLabel
--]]
	local tmp = Root:Find("SexLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.sexLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__11(Root, data)
--[[
	CardLabel
--]]
	local tmp = Root:Find("CardLabel").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.cardLabel = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__12(Root, data)
--[[
	Piece
--]]
	local tmp = Root:Find("Piece").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.piece = tmp
	self.piece:SetActive(false)

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__13(Root, data)
--[[
	Num
--]]
	local tmp = Root:Find("Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconItemView:InitGenerate__14(Root, data)
--[[
	RefineLv
--]]
	local tmp = Root:Find("RefineLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.refineLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconItemView:InitGenerate__15(Root, data)
--[[
	QualityFX
--]]
	local tmp = Root:Find("QualityFX").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.qualityFX = tmp
end

---@private
function IconItemView:InitGenerate__16(Root, data)
--[[
	Conertips
--]]
	local tmp = Root:Find("Conertips").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.conertips = tmp
end

---@private
function IconItemView:InitGenerate__17(Root, data)
--[[
	Conertips/Text
--]]
	local tmp = Root:Find("Conertips/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconItemView:InitGenerate__18(Root, data)
--[[
	RepeatSign
--]]
	local tmp = Root:Find("RepeatSign").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.repeatSign = tmp
end

---@private
function IconItemView:InitGenerate__19(Root, data)
--[[
	Advence
--]]
	local tmp = Root:Find("Advence").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.advence = tmp
end

---@private
function IconItemView:InitGenerate__20(Root, data)
--[[
	Advence/AdvenceLv
--]]
	local tmp = Root:Find("Advence/AdvenceLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.advenceLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconItemView:InitGenerate__21(Root, data)
--[[
	Vip
--]]
	local tmp = Root:Find("Vip").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.vip = tmp
end

---@private
function IconItemView:InitGenerate__22(Root, data)
--[[
	Vip/label
--]]
	local tmp = Root:Find("Vip/label").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.label = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function IconItemView:InitGenerate__23(Root, data)
--[[
	RedPoint
--]]
	local tmp = Root:Find("RedPoint").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.redPoint = tmp
end

---@private
function IconItemView:InitGenerate__24(Root, data)
--[[
	ArtifactStar
--]]
	local tmp = Root:Find("ArtifactStar").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar = tmp
end

---@private
function IconItemView:InitGenerate__25(Root, data)
--[[
	ArtifactStar/Star1
--]]
	local tmp = Root:Find("ArtifactStar/Star1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star1 = tmp
end

---@private
function IconItemView:InitGenerate__26(Root, data)
--[[
	ArtifactStar/Star1/Star
--]]
	local tmp = Root:Find("ArtifactStar/Star1/Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star1.star = tmp
end

---@private
function IconItemView:InitGenerate__27(Root, data)
--[[
	ArtifactStar/Star2
--]]
	local tmp = Root:Find("ArtifactStar/Star2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star2 = tmp
end

---@private
function IconItemView:InitGenerate__28(Root, data)
--[[
	ArtifactStar/Star2/Star
--]]
	local tmp = Root:Find("ArtifactStar/Star2/Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star2.star = tmp
end

---@private
function IconItemView:InitGenerate__29(Root, data)
--[[
	ArtifactStar/Star3
--]]
	local tmp = Root:Find("ArtifactStar/Star3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star3 = tmp
end

---@private
function IconItemView:InitGenerate__30(Root, data)
--[[
	ArtifactStar/Star3/Star
--]]
	local tmp = Root:Find("ArtifactStar/Star3/Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star3.star = tmp
end

---@private
function IconItemView:InitGenerate__31(Root, data)
--[[
	ArtifactStar/Star4
--]]
	local tmp = Root:Find("ArtifactStar/Star4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star4 = tmp
end

---@private
function IconItemView:InitGenerate__32(Root, data)
--[[
	ArtifactStar/Star4/Star
--]]
	local tmp = Root:Find("ArtifactStar/Star4/Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star4.star = tmp
end

---@private
function IconItemView:InitGenerate__33(Root, data)
--[[
	ArtifactStar/Star5
--]]
	local tmp = Root:Find("ArtifactStar/Star5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star5 = tmp
end

---@private
function IconItemView:InitGenerate__34(Root, data)
--[[
	ArtifactStar/Star5/Star
--]]
	local tmp = Root:Find("ArtifactStar/Star5/Star").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactStar.star5.star = tmp
end

---@private
function IconItemView:InitGenerate__35(Root, data)
--[[
	ArtifactLv
--]]
	local tmp = Root:Find("ArtifactLv").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.artifactLv = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function IconItemView:InitGenerate__36(Root, data)
--[[
	Selected
--]]
	local tmp = Root:Find("Selected").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.selected = tmp
end

---@private
function IconItemView:InitGenerate__37(Root, data)
--[[
	Locked
--]]
	local tmp = Root:Find("Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked = tmp
end

---@private
function IconItemView:InitGenerate__38(Root, data)
--[[
	Locked/Locked
--]]
	local tmp = Root:Find("Locked/Locked").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.locked.locked = tmp
end

---@private
function IconItemView:GenerateDestroy()
	if tolua.getpeer(self.locked.locked) ~= nil then
		tolua.setpeer(self.locked.locked, nil)
	end
	if tolua.getpeer(self.artifactStar.star5.star) ~= nil then
		tolua.setpeer(self.artifactStar.star5.star, nil)
	end
	if tolua.getpeer(self.artifactStar.star5) ~= nil then
		tolua.setpeer(self.artifactStar.star5, nil)
	end
	if tolua.getpeer(self.artifactStar.star4.star) ~= nil then
		tolua.setpeer(self.artifactStar.star4.star, nil)
	end
	if tolua.getpeer(self.artifactStar.star4) ~= nil then
		tolua.setpeer(self.artifactStar.star4, nil)
	end
	if tolua.getpeer(self.artifactStar.star3.star) ~= nil then
		tolua.setpeer(self.artifactStar.star3.star, nil)
	end
	if tolua.getpeer(self.artifactStar.star3) ~= nil then
		tolua.setpeer(self.artifactStar.star3, nil)
	end
	if tolua.getpeer(self.artifactStar.star2.star) ~= nil then
		tolua.setpeer(self.artifactStar.star2.star, nil)
	end
	if tolua.getpeer(self.artifactStar.star2) ~= nil then
		tolua.setpeer(self.artifactStar.star2, nil)
	end
	if tolua.getpeer(self.artifactStar.star1.star) ~= nil then
		tolua.setpeer(self.artifactStar.star1.star, nil)
	end
	if tolua.getpeer(self.artifactStar.star1) ~= nil then
		tolua.setpeer(self.artifactStar.star1, nil)
	end
	if tolua.getpeer(self.shadow) ~= nil then
		tolua.setpeer(self.shadow, nil)
	end
	self.shadow = nil
	if tolua.getpeer(self.bg) ~= nil then
		tolua.setpeer(self.bg, nil)
	end
	self.bg = nil
	if tolua.getpeer(self.icon) ~= nil then
		tolua.setpeer(self.icon, nil)
	end
	self.icon = nil
	if tolua.getpeer(self.frame) ~= nil then
		tolua.setpeer(self.frame, nil)
	end
	self.frame = nil
	if tolua.getpeer(self.frameLead) ~= nil then
		tolua.setpeer(self.frameLead, nil)
	end
	self.frameLead = nil
	if tolua.getpeer(self.level) ~= nil then
		tolua.setpeer(self.level, nil)
	end
	self.level = nil
	if tolua.getpeer(self.job) ~= nil then
		tolua.setpeer(self.job, nil)
	end
	self.job = nil
	if tolua.getpeer(self.limited) ~= nil then
		tolua.setpeer(self.limited, nil)
	end
	self.limited = nil
	if tolua.getpeer(self.sexLabel) ~= nil then
		tolua.setpeer(self.sexLabel, nil)
	end
	self.sexLabel = nil
	if tolua.getpeer(self.cardLabel) ~= nil then
		tolua.setpeer(self.cardLabel, nil)
	end
	self.cardLabel = nil
	if tolua.getpeer(self.piece) ~= nil then
		tolua.setpeer(self.piece, nil)
	end
	self.piece = nil
	if tolua.getpeer(self.num) ~= nil then
		tolua.setpeer(self.num, nil)
	end
	self.num = nil
	if tolua.getpeer(self.refineLv) ~= nil then
		tolua.setpeer(self.refineLv, nil)
	end
	self.refineLv = nil
	if tolua.getpeer(self.qualityFX) ~= nil then
		tolua.setpeer(self.qualityFX, nil)
	end
	self.qualityFX = nil
	if tolua.getpeer(self.conertips) ~= nil then
		tolua.setpeer(self.conertips, nil)
	end
	self.conertips = nil
	if tolua.getpeer(self.text) ~= nil then
		tolua.setpeer(self.text, nil)
	end
	self.text = nil
	if tolua.getpeer(self.repeatSign) ~= nil then
		tolua.setpeer(self.repeatSign, nil)
	end
	self.repeatSign = nil
	if tolua.getpeer(self.advence) ~= nil then
		tolua.setpeer(self.advence, nil)
	end
	self.advence = nil
	if tolua.getpeer(self.advenceLv) ~= nil then
		tolua.setpeer(self.advenceLv, nil)
	end
	self.advenceLv = nil
	if tolua.getpeer(self.vip) ~= nil then
		tolua.setpeer(self.vip, nil)
	end
	self.vip = nil
	if tolua.getpeer(self.label) ~= nil then
		tolua.setpeer(self.label, nil)
	end
	self.label = nil
	if tolua.getpeer(self.redPoint) ~= nil then
		tolua.setpeer(self.redPoint, nil)
	end
	self.redPoint = nil
	if tolua.getpeer(self.artifactStar) ~= nil then
		tolua.setpeer(self.artifactStar, nil)
	end
	self.artifactStar = nil
	if tolua.getpeer(self.artifactLv) ~= nil then
		tolua.setpeer(self.artifactLv, nil)
	end
	self.artifactLv = nil
	if tolua.getpeer(self.selected) ~= nil then
		tolua.setpeer(self.selected, nil)
	end
	self.selected = nil
	if tolua.getpeer(self.locked) ~= nil then
		tolua.setpeer(self.locked, nil)
	end
	self.locked = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return IconItemView