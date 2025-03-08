---@class FruitHeroItem__Generate_fruit2BtnUse
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FruitHeroItem__Generate_fruit2Num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FruitHeroItem__Generate_fruit2Name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FruitHeroItem__Generate_fruit2Icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FruitHeroItem__Generate_fruit2Slider
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FruitHeroItem__Generate_fruit1BtnUse
---@field public gameObject UnityEngine.GameObject
---@field public button UnityEngine.UI.Button

---@class FruitHeroItem__Generate_fruit1Num
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FruitHeroItem__Generate_fruit1Name
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FruitHeroItem__Generate_fruit1Icon
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FruitHeroItem__Generate_fruit1Slider
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FruitHeroItem__Generate_nameText
---@field public gameObject UnityEngine.GameObject
---@field public text UnityEngine.UI.Text

---@class FruitHeroItem__Generate_heroHalf
---@field public gameObject UnityEngine.GameObject
---@field public image UnityEngine.UI.Image

---@class FruitHeroItem__Generate
---@field private gameObject UnityEngine.GameObject
---@field private transform UnityEngine.Transform
---@field private heroHalf FruitHeroItem__Generate_heroHalf
---@field private nameText FruitHeroItem__Generate_nameText
---@field private uncured UnityEngine.GameObject
---@field private fruit1 UnityEngine.GameObject
---@field private fruit1Slider FruitHeroItem__Generate_fruit1Slider
---@field private fruit1Icon FruitHeroItem__Generate_fruit1Icon
---@field private fruit1Name FruitHeroItem__Generate_fruit1Name
---@field private fruit1Num FruitHeroItem__Generate_fruit1Num
---@field private fruit1BtnUse FruitHeroItem__Generate_fruit1BtnUse
---@field private fruit2 UnityEngine.GameObject
---@field private fruit2Slider FruitHeroItem__Generate_fruit2Slider
---@field private fruit2Icon FruitHeroItem__Generate_fruit2Icon
---@field private fruit2Name FruitHeroItem__Generate_fruit2Name
---@field private fruit2Num FruitHeroItem__Generate_fruit2Num
---@field private fruit2BtnUse FruitHeroItem__Generate_fruit2BtnUse
local FruitHeroItemView = class("FruitHeroItemView")

function FruitHeroItemView:ctor()
end

---@private
function FruitHeroItemView:SetActive(result)
	self.gameObject:SetActive(result)
end
---@private
function FruitHeroItemView:InitGenerate(Root, data)
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


end

---@private
function FruitHeroItemView:InitGenerate__1(Root, data)
--[[
	Root
--]]
end

---@private
function FruitHeroItemView:InitGenerate__2(Root, data)
--[[
	HeroHalf
--]]
	local tmp = Root:Find("HeroHalf").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.heroHalf = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FruitHeroItemView:InitGenerate__3(Root, data)
--[[
	Name/nameText
--]]
	local tmp = Root:Find("Name/nameText").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.nameText = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FruitHeroItemView:InitGenerate__4(Root, data)
--[[
	Uncured
--]]
	local tmp = Root:Find("Uncured").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.uncured = tmp
end

---@private
function FruitHeroItemView:InitGenerate__5(Root, data)
--[[
	Fruit1
--]]
	local tmp = Root:Find("Fruit1").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1 = tmp
end

---@private
function FruitHeroItemView:InitGenerate__6(Root, data)
--[[
	Fruit1/Fruit1Slider
--]]
	local tmp = Root:Find("Fruit1/Fruit1Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1Slider = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FruitHeroItemView:InitGenerate__7(Root, data)
--[[
	Fruit1/Fruit1Icon
--]]
	local tmp = Root:Find("Fruit1/Fruit1Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1Icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FruitHeroItemView:InitGenerate__8(Root, data)
--[[
	Fruit1/Fruit1Name
--]]
	local tmp = Root:Find("Fruit1/Fruit1Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1Name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FruitHeroItemView:InitGenerate__9(Root, data)
--[[
	Fruit1/Number/Fruit1Num
--]]
	local tmp = Root:Find("Fruit1/Number/Fruit1Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1Num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FruitHeroItemView:InitGenerate__10(Root, data)
--[[
	Fruit1/Fruit1BtnUse
--]]
	local tmp = Root:Find("Fruit1/Fruit1BtnUse").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit1BtnUse = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FruitHeroItemView:InitGenerate__11(Root, data)
--[[
	Fruit2
--]]
	local tmp = Root:Find("Fruit2").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2 = tmp
end

---@private
function FruitHeroItemView:InitGenerate__12(Root, data)
--[[
	Fruit2/Fruit2Slider
--]]
	local tmp = Root:Find("Fruit2/Fruit2Slider").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2Slider = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FruitHeroItemView:InitGenerate__13(Root, data)
--[[
	Fruit2/Fruit2Icon
--]]
	local tmp = Root:Find("Fruit2/Fruit2Icon").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2Icon = tmp

	tmp.image = tmp:GetComponent(Enum.TypeInfo.Image)
end

---@private
function FruitHeroItemView:InitGenerate__14(Root, data)
--[[
	Fruit2/fruit2Name
--]]
	local tmp = Root:Find("Fruit2/fruit2Name").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2Name = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FruitHeroItemView:InitGenerate__15(Root, data)
--[[
	Fruit2/Number/Fruit2Num
--]]
	local tmp = Root:Find("Fruit2/Number/Fruit2Num").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2Num = tmp

	tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
end

---@private
function FruitHeroItemView:InitGenerate__16(Root, data)
--[[
	Fruit2/Fruit2BtnUse
--]]
	local tmp = Root:Find("Fruit2/Fruit2BtnUse").gameObject
	if tolua.getpeer(tmp) == nil then
		tolua.setpeer(tmp, {})
	end
	self.fruit2BtnUse = tmp

	tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
end

---@private
function FruitHeroItemView:GenerateDestroy()
	if tolua.getpeer(self.heroHalf) ~= nil then
		tolua.setpeer(self.heroHalf, nil)
	end
	self.heroHalf = nil
	if tolua.getpeer(self.nameText) ~= nil then
		tolua.setpeer(self.nameText, nil)
	end
	self.nameText = nil
	if tolua.getpeer(self.uncured) ~= nil then
		tolua.setpeer(self.uncured, nil)
	end
	self.uncured = nil
	if tolua.getpeer(self.fruit1) ~= nil then
		tolua.setpeer(self.fruit1, nil)
	end
	self.fruit1 = nil
	if tolua.getpeer(self.fruit1Slider) ~= nil then
		tolua.setpeer(self.fruit1Slider, nil)
	end
	self.fruit1Slider = nil
	if tolua.getpeer(self.fruit1Icon) ~= nil then
		tolua.setpeer(self.fruit1Icon, nil)
	end
	self.fruit1Icon = nil
	if tolua.getpeer(self.fruit1Name) ~= nil then
		tolua.setpeer(self.fruit1Name, nil)
	end
	self.fruit1Name = nil
	if tolua.getpeer(self.fruit1Num) ~= nil then
		tolua.setpeer(self.fruit1Num, nil)
	end
	self.fruit1Num = nil
	if tolua.getpeer(self.fruit1BtnUse) ~= nil then
		tolua.setpeer(self.fruit1BtnUse, nil)
	end
	self.fruit1BtnUse = nil
	if tolua.getpeer(self.fruit2) ~= nil then
		tolua.setpeer(self.fruit2, nil)
	end
	self.fruit2 = nil
	if tolua.getpeer(self.fruit2Slider) ~= nil then
		tolua.setpeer(self.fruit2Slider, nil)
	end
	self.fruit2Slider = nil
	if tolua.getpeer(self.fruit2Icon) ~= nil then
		tolua.setpeer(self.fruit2Icon, nil)
	end
	self.fruit2Icon = nil
	if tolua.getpeer(self.fruit2Name) ~= nil then
		tolua.setpeer(self.fruit2Name, nil)
	end
	self.fruit2Name = nil
	if tolua.getpeer(self.fruit2Num) ~= nil then
		tolua.setpeer(self.fruit2Num, nil)
	end
	self.fruit2Num = nil
	if tolua.getpeer(self.fruit2BtnUse) ~= nil then
		tolua.setpeer(self.fruit2BtnUse, nil)
	end
	self.fruit2BtnUse = nil
	self.transform = nil
	self.gameObject = nil
	self.inited = false
end
return FruitHeroItemView