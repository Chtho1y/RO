local UIShopGoldBuyTips = class("UIShopGoldBuyTips")

local exchangeIconKey = 310
local exchangeCostKey = 308
local exchangeRewardKey = 309

local exchangeIcon
local exchangeCosts
local exchangeRewards
function UIShopGoldBuyTips:ctor()
end

function UIShopGoldBuyTips:InitGo(host,uiGo)
    self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "UIShopGoldBuyTips", uiGo)
	
    self:InitPanel()
end

function UIShopGoldBuyTips:InitPanel()
	exchangeIcon = GlobalConfig.Instance:GetConfigStrValue(exchangeIconKey)
	local val = GlobalConfig.Instance:GetConfigStrValue(exchangeCostKey)
	if val ~= "" and val ~= nil then
		exchangeCosts = CommonUtil.DeserializeGlobalStrToTable(val)
	end
	local val = GlobalConfig.Instance:GetConfigStrValue(exchangeRewardKey)
	if val ~= "" and val ~= nil then
		exchangeRewards = CommonUtil.DeserializeGlobalStrToTable(val)
	end
end

function UIShopGoldBuyTips:AddEventListener()
end

function UIShopGoldBuyTips:RemoveEventListener()
end

function UIShopGoldBuyTips:AddUIEventListener()
	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.btnClose.button, self, self.OnClickCloseBtn)
	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.AnyBtn.button, self, self.OnClickCloseBtn)

	self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.btnBuy.button, self, self.OnClickBuyBtn)
end

function UIShopGoldBuyTips:Show()
	self:AddEventListener()

	if not exchangeCosts then
		self.viewLua.textTitle.text.text = ''
		self.viewLua.buyLimitTxt.text.text = ''
		self.viewLua.presentPrice.number.text.text = ''
		self.viewLua.image.image.enabled = false
		self.viewLua.image.image.sprite = nil
		return
	end
	if exchangeIcon then
		CommonUtil.LoadIcon(self, exchangeIcon, function(sprite)
			if sprite then
				self.viewLua.image.image.sprite = sprite
				self.viewLua.image.image.enabled = true
			end
		end)
	end

	local rewards = exchangeRewards
	local reward
	local contentStr = ""
	if rewards then
		for i = 1, #rewards do
			reward = rewards[i]
			local id = tonumber(reward[1])
			local num = tonumber(reward[2])
			contentStr = contentStr..'+' .. num
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(id)
			if itemCfgData then
				contentStr = contentStr .. tostring(itemCfgData.Name)
			end
			if i < #reward then
				contentStr = contentStr ..'\n'
			end
		end
	end
	self.viewLua.goldText.text.text = contentStr

	local price = 0
	if exchangeCosts and exchangeCosts[1] then
		price = tonumber(exchangeCosts[1][2])
	end
	if price <= 0 then
		self.viewLua.presentPrice.number.text.text = string.formatbykey('Free')
	else
		self.viewLua.presentPrice.number.text.text = tostring(price)
	end

	self.viewLua:SetActive(true)
end

function UIShopGoldBuyTips:OnClickCloseBtn()
	self:Hide()
end

function UIShopGoldBuyTips:OnClickBuyBtn()
	ManagerContainer.DataMgr.ShopDataMgr:SendRedBagExchangeReq()
	self:Hide()
end

function UIShopGoldBuyTips:Hide()

    self:RemoveEventListener()
	self.viewLua:SetActive(false)
	self:Clear()
end


function UIShopGoldBuyTips:Clear()

end

function UIShopGoldBuyTips:Dispose()

	self:Hide()
    self.host = nil
    self.viewLua = nil
end


return UIShopGoldBuyTips