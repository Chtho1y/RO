local UIIdolGiftItemCtr = {}

function UIIdolGiftItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)

    local brief = ManagerContainer.DataMgr.IdolData:GetPlayerBriefInfoByUid(logicData.uid)
    if brief then
        local name = CommonUtil.GetVaildNickName(brief.nick_name)
        item.flag.playername.text.text = name
        local curRoleLv = brief.level
        local jobCfgId = brief.config_id
        local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
        local headIcon = CommonUtil.GetPlayerHeadIcon(brief)
        local _fakerData = {Level = curRoleLv, ProfessionIcon = jobCfgData.JobIcon, HeadIcon = headIcon, IsHero = true};
        local _headFrameId = brief.head_frame_id
        CommonUtil.SetPlayerHeadAndFrame(wnd, item.flag.headItem, _fakerData,false, _headFrameId,wnd,wnd.OnClickOtherHeadBtn,brief.uid);
    end

    if onClickOwner and onClickCB then
        item.btnSupport.button.enabled = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(item.btnSupport.button, onClickOwner, onClickCB, logicData)
    else
        item.btnSupport.button.enabled = false
    end
    self:InitLoveGiftItems(wnd,item,logicData)
end

function UIIdolGiftItemCtr:InitLoveGiftItems(wnd,item,logicData)
	local uid = logicData.uid
	local rewardData = ManagerContainer.DataMgr.IdolData:GetFansRewardInfoByUid(uid)
	if not rewardData  then
		rewardData = {hotVal = 0,rewardState={false,false,false,false,false}}
	end
    local ticket = rewardData.hotVal or 0
    local loveGiftItems = item.loveGiftItems
	if not loveGiftItems then
		loveGiftItems = {item.slider.item}
		item.loveGiftItems = loveGiftItems
	end
    local BoxData = ManagerContainer.CfgMgr:GetAidouluCfg()
	local len1 = #loveGiftItems
	local len2 = BoxData
    local maxHot = BoxData[#BoxData].ConditionHot
    item.slider.num.text.text = ticket
    item.slider.slider.maxValue = maxHot
    item.slider.slider.value = math.min(maxHot,ticket)
	if BoxData  then
		local rectW  = item.slider.slider.handleRect.parent.rect.width
		local defPos = item.slider.item.transform.anchoredPosition3D
		len2 = #BoxData
		for i = 1, len2 do
			local loveGiftItem = nil
			local trans = nil
			if i <= len1 then
				loveGiftItem = loveGiftItems[i]
				trans = loveGiftItem.transform
			else
				loveGiftItem = UnityEngine.GameObject.Instantiate(item.slider.item.gameObject)
				trans = loveGiftItem.transform
				trans:SetParent(item.slider.item.transform.parent)
				trans.localRotation = Quaternion.identity
				trans.localScale = Vector3.one
				if tolua.getpeer(loveGiftItem) == nil then
					tolua.setpeer(loveGiftItem, {})
				end
				local tmp = trans:Find('text/num').gameObject
                if tolua.getpeer(tmp) == nil then
                    tolua.setpeer(tmp, {})
                end
				loveGiftItem.num = tmp
				tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
				local tmp = trans:Find('BtnBox').gameObject
                if tolua.getpeer(tmp) == nil then
                    tolua.setpeer(tmp, {})
                end
				loveGiftItem.btnBox = tmp
				tmp.button = tmp:GetComponent(Enum.TypeInfo.Button)
				tmp.box1 = trans:Find('BtnBox/box1').gameObject
				tmp.box2 = trans:Find('BtnBox/box2').gameObject
				tmp.box3 = trans:Find('BtnBox/box3').gameObject
				tmp.box4 = trans:Find('BtnBox/box4').gameObject
				loveGiftItems[i] = loveGiftItem
			end
			loveGiftItem:SetActive(true)
			local loveVal = BoxData[i].ConditionHot
			local posX = rectW
			if maxHot > 0 then
				posX = posX * ((loveVal / maxHot) - 0.5)
			end
			trans:SetSiblingIndex(0)
			trans.anchoredPosition3D = Vector3(posX, defPos.y, defPos.z)
			loveGiftItem.num.text.text = tostring(loveVal)
            local rewardState =  rewardData.rewardState
            loveGiftItem.btnBox.box1:SetActive(false)
            loveGiftItem.btnBox.box2:SetActive(false)
            loveGiftItem.btnBox.box3:SetActive(false)
            loveGiftItem.btnBox.box4:SetActive(false)
            if rewardData.hotVal >= loveVal then
                if logicData.box < i then
                    loveGiftItem.btnBox.box2:SetActive(true)
                else
                    if rewardState[i]  then
                        loveGiftItem.btnBox.box4:SetActive(true)
                    else
                        loveGiftItem.btnBox.box1:SetActive(true)
                    end
                end
            else
                if logicData.box < i then
                    loveGiftItem.btnBox.box2:SetActive(true)
                else
					local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
					if selfUid == uid then
						if rewardState[i]  then
							loveGiftItem.btnBox.box4:SetActive(true)
						else
							loveGiftItem.btnBox.box1:SetActive(true)
						end
					else
						loveGiftItem.btnBox.box3:SetActive(true)
					end
                end
            end
            local data = {loveVal = loveVal,ticket = rewardData.hotVal,rewardState = rewardData.rewardState,boxId = i,boxNum = logicData.box,obj =loveGiftItem,uid = logicData.uid}
            wnd.uiBase:AddButtonUniqueEventListener(loveGiftItem.btnBox.button, wnd, wnd.OnClickBoxItem, data)
		end
	end
	for i = len2 + 1, len1 do
		if loveGiftItems[i] then
			loveGiftItems[i]:SetActive(false)
		end
	end
end

return UIIdolGiftItemCtr