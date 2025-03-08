---@class UIVoyage__Generate_btnInfo
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_remindNumTxt
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class UIVoyage__Generate_backBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_btnChat
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_rewardBtn_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVoyage__Generate_rewardBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIVoyage__Generate_rewardBtn_text

---@class UIVoyage__Generate_voyageBtn_text
---@field public gameObject UnityEngine.GameObject
---@field public text TMPro.TextMeshProUGUI

---@class UIVoyage__Generate_voyageBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button
---@field public text UIVoyage__Generate_voyageBtn_text

---@class UIVoyage__Generate_btnLog
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_btnShop
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_btnRank
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate_race10
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race9
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race8
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race7
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race6
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race5
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race4
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race3
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race2
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_race1
---@field public gameObject UnityEngine.GameObject
---@field public start UnityEngine.GameObject
---@field public finsh UnityEngine.GameObject

---@class UIVoyage__Generate_traceGroup
---@field public gameObject UnityEngine.GameObject
---@field public scrollRect UnityEngine.UI.ScrollRect

---@class UIVoyage__Generate_AnyBtn
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class UIVoyage__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private AnyBtn UIVoyage__Generate_AnyBtn
---@field private traceGroup UIVoyage__Generate_traceGroup
---@field private race1 UIVoyage__Generate_race1
---@field private race2 UIVoyage__Generate_race2
---@field private race3 UIVoyage__Generate_race3
---@field private race4 UIVoyage__Generate_race4
---@field private race5 UIVoyage__Generate_race5
---@field private race6 UIVoyage__Generate_race6
---@field private race7 UIVoyage__Generate_race7
---@field private race8 UIVoyage__Generate_race8
---@field private race9 UIVoyage__Generate_race9
---@field private race10 UIVoyage__Generate_race10
---@field private airShipRoot1 UnityEngine.GameObject
---@field private airShipRoot2 UnityEngine.GameObject
---@field private airShipRoot3 UnityEngine.GameObject
---@field private airShipRoot4 UnityEngine.GameObject
---@field private airShipRoot5 UnityEngine.GameObject
---@field private airShipRoot6 UnityEngine.GameObject
---@field private airShipRoot7 UnityEngine.GameObject
---@field private airShipRoot8 UnityEngine.GameObject
---@field private airShipRoot9 UnityEngine.GameObject
---@field private airShipRoot10 UnityEngine.GameObject
---@field private btnRank UIVoyage__Generate_btnRank
---@field private btnShop UIVoyage__Generate_btnShop
---@field private btnLog UIVoyage__Generate_btnLog
---@field private voyageBtn UIVoyage__Generate_voyageBtn
---@field private rewardBtn UIVoyage__Generate_rewardBtn
---@field private btnChat UIVoyage__Generate_btnChat
---@field private backBtn UIVoyage__Generate_backBtn
---@field private remindNumTxt UIVoyage__Generate_remindNumTxt
---@field private btnInfo UIVoyage__Generate_btnInfo
local UIVoyageView = class("UIVoyageView", require("UIViewBase"))

function UIVoyageView:ctor()
end

---@private
function UIVoyageView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function UIVoyageView:InitGenerate(Root, data)
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
	self:InitGenerate__40(Root,data)
	self:InitGenerate__41(Root,data)
	self:InitGenerate__42(Root,data)
	self:InitGenerate__43(Root,data)
	self:InitGenerate__44(Root,data)
	self:InitGenerate__45(Root,data)
	self:InitGenerate__46(Root,data)
	self:InitGenerate__47(Root,data)
	self:InitGenerate__48(Root,data)
	self:InitGenerate__49(Root,data)
	self:InitGenerate__50(Root,data)
	self:InitGenerate__51(Root,data)
	self:InitGenerate__52(Root,data)
	self:InitGenerate__53(Root,data)


end

---@private
function UIVoyageView:InitGenerate__1(Root, data)
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
function UIVoyageView:InitGenerate__2(Root, data)
--[[
	UIAnimator/Window/TraceGroup
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.traceGroup = tmp

	tmp.scrollRect = tmp:GetComponent(Enum.TypeInfo.ScrollRect)
end

---@private
function UIVoyageView:InitGenerate__3(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race1
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race1 = tmp
end

---@private
function UIVoyageView:InitGenerate__4(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race1/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race1/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race1.start = tmp
end

---@private
function UIVoyageView:InitGenerate__5(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race1/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race1/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race1.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__6(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race2
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race2 = tmp
end

---@private
function UIVoyageView:InitGenerate__7(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race2/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race2/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race2.start = tmp
end

---@private
function UIVoyageView:InitGenerate__8(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race2/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race2/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race2.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__9(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race3
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race3 = tmp
end

---@private
function UIVoyageView:InitGenerate__10(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race3/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race3/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race3.start = tmp
end

---@private
function UIVoyageView:InitGenerate__11(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race3/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race3/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race3.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__12(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race4
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race4 = tmp
end

---@private
function UIVoyageView:InitGenerate__13(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race4/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race4/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race4.start = tmp
end

---@private
function UIVoyageView:InitGenerate__14(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race4/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race4/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race4.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__15(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race5
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race5 = tmp
end

---@private
function UIVoyageView:InitGenerate__16(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race5/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race5/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race5.start = tmp
end

---@private
function UIVoyageView:InitGenerate__17(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race5/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race5/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race5.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__18(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race6
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race6 = tmp
end

---@private
function UIVoyageView:InitGenerate__19(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race6/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race6/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race6.start = tmp
end

---@private
function UIVoyageView:InitGenerate__20(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race6/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race6/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race6.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__21(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race7
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race7 = tmp
end

---@private
function UIVoyageView:InitGenerate__22(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race7/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race7/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race7.start = tmp
end

---@private
function UIVoyageView:InitGenerate__23(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race7/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race7/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race7.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__24(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race8
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race8 = tmp
end

---@private
function UIVoyageView:InitGenerate__25(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race8/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race8/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race8.start = tmp
end

---@private
function UIVoyageView:InitGenerate__26(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race8/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race8/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race8.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__27(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race9
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race9 = tmp
end

---@private
function UIVoyageView:InitGenerate__28(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race9/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race9/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race9.start = tmp
end

---@private
function UIVoyageView:InitGenerate__29(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race9/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race9/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race9.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__30(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race10
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race10 = tmp
end

---@private
function UIVoyageView:InitGenerate__31(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race10/Start
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race10/Start").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race10.start = tmp
end

---@private
function UIVoyageView:InitGenerate__32(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/Race10/Finsh
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/Race10/Finsh").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.race10.finsh = tmp
end

---@private
function UIVoyageView:InitGenerate__33(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot1
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot1 = tmp
end

---@private
function UIVoyageView:InitGenerate__34(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot2
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot2 = tmp
end

---@private
function UIVoyageView:InitGenerate__35(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot3
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot3").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot3 = tmp
end

---@private
function UIVoyageView:InitGenerate__36(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot4
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot4").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot4 = tmp
end

---@private
function UIVoyageView:InitGenerate__37(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot5
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot5").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot5 = tmp
end

---@private
function UIVoyageView:InitGenerate__38(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot6
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot6").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot6 = tmp
end

---@private
function UIVoyageView:InitGenerate__39(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot7
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot7").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot7 = tmp
end

---@private
function UIVoyageView:InitGenerate__40(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot8
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot8").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot8 = tmp
end

---@private
function UIVoyageView:InitGenerate__41(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot9
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot9").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot9 = tmp
end

---@private
function UIVoyageView:InitGenerate__42(Root, data)
--[[
	UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot10
--]]
	local tmp = Root:Find("UIAnimator/Window/TraceGroup/Viewport/Content/AirShipRoot10").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.airShipRoot10 = tmp
end

---@private
function UIVoyageView:InitGenerate__43(Root, data)
--[[
	UIAnimator/Window/UITitle/Top/BtnGroup/BtnRank
--]]
	local tmp = Root:Find("UIAnimator/Window/UITitle/Top/BtnGroup/BtnRank").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnRank = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__44(Root, data)
--[[
	UIAnimator/Window/UITitle/Top/BtnGroup/BtnShop
--]]
	local tmp = Root:Find("UIAnimator/Window/UITitle/Top/BtnGroup/BtnShop").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnShop = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__45(Root, data)
--[[
	UIAnimator/Window/UITitle/Top/BtnGroup/BtnLog
--]]
	local tmp = Root:Find("UIAnimator/Window/UITitle/Top/BtnGroup/BtnLog").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnLog = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__46(Root, data)
--[[
	UIAnimator/Window/BottomView/VoyageBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/VoyageBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.voyageBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__47(Root, data)
--[[
	UIAnimator/Window/BottomView/VoyageBtn/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/VoyageBtn/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.voyageBtn.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVoyageView:InitGenerate__48(Root, data)
--[[
	UIAnimator/Window/BottomView/RewardBtn
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/RewardBtn").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__49(Root, data)
--[[
	UIAnimator/Window/BottomView/RewardBtn/Text
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/RewardBtn/Text").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.rewardBtn.text = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
end

---@private
function UIVoyageView:InitGenerate__50(Root, data)
--[[
	UIAnimator/Window/BottomView/BtnChat
--]]
	local tmp = Root:Find("UIAnimator/Window/BottomView/BtnChat").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnChat = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__51(Root, data)
--[[
	UIAnimator/Window/BtnBack
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnBack").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.backBtn = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:InitGenerate__52(Root, data)
--[[
	UIAnimator/Window/Times/RemindNumTxt
--]]
	local tmp = Root:Find("UIAnimator/Window/Times/RemindNumTxt").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.remindNumTxt = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function UIVoyageView:InitGenerate__53(Root, data)
--[[
	UIAnimator/Window/BtnInfo
--]]
	local tmp = Root:Find("UIAnimator/Window/BtnInfo").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.btnInfo = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function UIVoyageView:GenerateDestroy()
	if tolua.getpeer(self.rewardBtn.text) ~= nil then
		tolua.setpeer(self.rewardBtn.text, nil)
	end
	if tolua.getpeer(self.voyageBtn.text) ~= nil then
		tolua.setpeer(self.voyageBtn.text, nil)
	end
	if tolua.getpeer(self.race10.finsh) ~= nil then
		tolua.setpeer(self.race10.finsh, nil)
	end
	if tolua.getpeer(self.race10.start) ~= nil then
		tolua.setpeer(self.race10.start, nil)
	end
	if tolua.getpeer(self.race9.finsh) ~= nil then
		tolua.setpeer(self.race9.finsh, nil)
	end
	if tolua.getpeer(self.race9.start) ~= nil then
		tolua.setpeer(self.race9.start, nil)
	end
	if tolua.getpeer(self.race8.finsh) ~= nil then
		tolua.setpeer(self.race8.finsh, nil)
	end
	if tolua.getpeer(self.race8.start) ~= nil then
		tolua.setpeer(self.race8.start, nil)
	end
	if tolua.getpeer(self.race7.finsh) ~= nil then
		tolua.setpeer(self.race7.finsh, nil)
	end
	if tolua.getpeer(self.race7.start) ~= nil then
		tolua.setpeer(self.race7.start, nil)
	end
	if tolua.getpeer(self.race6.finsh) ~= nil then
		tolua.setpeer(self.race6.finsh, nil)
	end
	if tolua.getpeer(self.race6.start) ~= nil then
		tolua.setpeer(self.race6.start, nil)
	end
	if tolua.getpeer(self.race5.finsh) ~= nil then
		tolua.setpeer(self.race5.finsh, nil)
	end
	if tolua.getpeer(self.race5.start) ~= nil then
		tolua.setpeer(self.race5.start, nil)
	end
	if tolua.getpeer(self.race4.finsh) ~= nil then
		tolua.setpeer(self.race4.finsh, nil)
	end
	if tolua.getpeer(self.race4.start) ~= nil then
		tolua.setpeer(self.race4.start, nil)
	end
	if tolua.getpeer(self.race3.finsh) ~= nil then
		tolua.setpeer(self.race3.finsh, nil)
	end
	if tolua.getpeer(self.race3.start) ~= nil then
		tolua.setpeer(self.race3.start, nil)
	end
	if tolua.getpeer(self.race2.finsh) ~= nil then
		tolua.setpeer(self.race2.finsh, nil)
	end
	if tolua.getpeer(self.race2.start) ~= nil then
		tolua.setpeer(self.race2.start, nil)
	end
	if tolua.getpeer(self.race1.finsh) ~= nil then
		tolua.setpeer(self.race1.finsh, nil)
	end
	if tolua.getpeer(self.race1.start) ~= nil then
		tolua.setpeer(self.race1.start, nil)
	end
	if tolua.getpeer(self.AnyBtn) ~= nil then
		tolua.setpeer(self.AnyBtn, nil)
	end
	self.AnyBtn = nil
	if tolua.getpeer(self.traceGroup) ~= nil then
		tolua.setpeer(self.traceGroup, nil)
	end
	self.traceGroup = nil
	if tolua.getpeer(self.race1) ~= nil then
		tolua.setpeer(self.race1, nil)
	end
	self.race1 = nil
	if tolua.getpeer(self.race2) ~= nil then
		tolua.setpeer(self.race2, nil)
	end
	self.race2 = nil
	if tolua.getpeer(self.race3) ~= nil then
		tolua.setpeer(self.race3, nil)
	end
	self.race3 = nil
	if tolua.getpeer(self.race4) ~= nil then
		tolua.setpeer(self.race4, nil)
	end
	self.race4 = nil
	if tolua.getpeer(self.race5) ~= nil then
		tolua.setpeer(self.race5, nil)
	end
	self.race5 = nil
	if tolua.getpeer(self.race6) ~= nil then
		tolua.setpeer(self.race6, nil)
	end
	self.race6 = nil
	if tolua.getpeer(self.race7) ~= nil then
		tolua.setpeer(self.race7, nil)
	end
	self.race7 = nil
	if tolua.getpeer(self.race8) ~= nil then
		tolua.setpeer(self.race8, nil)
	end
	self.race8 = nil
	if tolua.getpeer(self.race9) ~= nil then
		tolua.setpeer(self.race9, nil)
	end
	self.race9 = nil
	if tolua.getpeer(self.race10) ~= nil then
		tolua.setpeer(self.race10, nil)
	end
	self.race10 = nil
	if tolua.getpeer(self.airShipRoot1) ~= nil then
		tolua.setpeer(self.airShipRoot1, nil)
	end
	self.airShipRoot1 = nil
	if tolua.getpeer(self.airShipRoot2) ~= nil then
		tolua.setpeer(self.airShipRoot2, nil)
	end
	self.airShipRoot2 = nil
	if tolua.getpeer(self.airShipRoot3) ~= nil then
		tolua.setpeer(self.airShipRoot3, nil)
	end
	self.airShipRoot3 = nil
	if tolua.getpeer(self.airShipRoot4) ~= nil then
		tolua.setpeer(self.airShipRoot4, nil)
	end
	self.airShipRoot4 = nil
	if tolua.getpeer(self.airShipRoot5) ~= nil then
		tolua.setpeer(self.airShipRoot5, nil)
	end
	self.airShipRoot5 = nil
	if tolua.getpeer(self.airShipRoot6) ~= nil then
		tolua.setpeer(self.airShipRoot6, nil)
	end
	self.airShipRoot6 = nil
	if tolua.getpeer(self.airShipRoot7) ~= nil then
		tolua.setpeer(self.airShipRoot7, nil)
	end
	self.airShipRoot7 = nil
	if tolua.getpeer(self.airShipRoot8) ~= nil then
		tolua.setpeer(self.airShipRoot8, nil)
	end
	self.airShipRoot8 = nil
	if tolua.getpeer(self.airShipRoot9) ~= nil then
		tolua.setpeer(self.airShipRoot9, nil)
	end
	self.airShipRoot9 = nil
	if tolua.getpeer(self.airShipRoot10) ~= nil then
		tolua.setpeer(self.airShipRoot10, nil)
	end
	self.airShipRoot10 = nil
	if tolua.getpeer(self.btnRank) ~= nil then
		tolua.setpeer(self.btnRank, nil)
	end
	self.btnRank = nil
	if tolua.getpeer(self.btnShop) ~= nil then
		tolua.setpeer(self.btnShop, nil)
	end
	self.btnShop = nil
	if tolua.getpeer(self.btnLog) ~= nil then
		tolua.setpeer(self.btnLog, nil)
	end
	self.btnLog = nil
	if tolua.getpeer(self.voyageBtn) ~= nil then
		tolua.setpeer(self.voyageBtn, nil)
	end
	self.voyageBtn = nil
	if tolua.getpeer(self.rewardBtn) ~= nil then
		tolua.setpeer(self.rewardBtn, nil)
	end
	self.rewardBtn = nil
	if tolua.getpeer(self.btnChat) ~= nil then
		tolua.setpeer(self.btnChat, nil)
	end
	self.btnChat = nil
	if tolua.getpeer(self.backBtn) ~= nil then
		tolua.setpeer(self.backBtn, nil)
	end
	self.backBtn = nil
	if tolua.getpeer(self.remindNumTxt) ~= nil then
		tolua.setpeer(self.remindNumTxt, nil)
	end
	self.remindNumTxt = nil
	if tolua.getpeer(self.btnInfo) ~= nil then
		tolua.setpeer(self.btnInfo, nil)
	end
	self.btnInfo = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return UIVoyageView