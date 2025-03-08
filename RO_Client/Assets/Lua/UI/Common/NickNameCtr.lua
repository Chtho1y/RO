local NickNameCtr = {}
ProtoMsgId = require("ProtoMsgId")

--判断需要开启起名还是改名界面，true -- 起名；false -- 改名
function NickNameCtr:NeedOpenCreate()
    local _nickName = ManagerContainer.DataMgr.UserData:GetOriUserNickname();
    if _nickName == "" or _nickName == nil or _nickName == "NickName" then
        return true;
    else
        return false;
    end
end

--打开对应的昵称界面
function NickNameCtr:OpenNickNamePage(_isCreate)
    if _isCreate then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICreateName);
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeName);
    end
end

--获取改名时候的错误信息，_ignoreCard是否忽略改名卡数量的判断
function NickNameCtr:GetChangeNameError(_newName, _ignoreCard)
    --o:可以改名，1:改名卡不够，2:名字重复，无法修改，3:你要改成“新用户”，这也不行，4:空的，没输入，5:有非法字符， 6名字长处超出限制
    if not _ignoreCard then
        local _enoughCard = self:JudgeCard();
        if _enoughCard then
            return 1;
        end
    end

    if not self:JudgeNameLength(_newName) then
        if not _newName or _newName == "" then
            return 4;
        else
            return 6;
        end
    end

    if ManagerContainer.DataMgr.UserData:GetUserNickname() == _newName then return 2; end

    if _newName == I18N.T("NewGamePlayer") then return 3; end

    if not StringUtil.JudgeString_CN_EN_NUM(_newName) then return 5; end

    return 0
end

--判断改名卡是否充足
function NickNameCtr:JudgeCard()
    local itemCfgId, itemNum = self:GetChangeNameConsume();
    return ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(itemCfgId) < itemNum;
end

--发送改名消息
function NickNameCtr:SendChangeName(_newName)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RENAME_REQ, { name = _newName })
end

--判断名字长度
function NickNameCtr:JudgeNameLength(_name)
    if not _name or _name == "" then return false; end
    local _nameLength = StringUtil.GetStringByteLength(_name);
    local _nameLengthLimit = GlobalConfig.Instance:GetConfigIntValue(138);
    return _nameLength <= _nameLengthLimit;
end

function NickNameCtr:GetChangeNameConsume()
    local itemCfgId = 0
    local itemNum = 0
    local consumeStr = GlobalConfig.Instance:GetConfigStrValue(107)
    if consumeStr then
        local comuseArr = string.split(consumeStr, ':')
        if #comuseArr >= 2 then
            itemCfgId = tonumber(comuseArr[1])
            itemNum = tonumber(comuseArr[2])
        end
    end
    return itemCfgId, itemNum
end

return NickNameCtr