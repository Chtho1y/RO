--[[
    新获得提示，管理 UISuccessTips 的显示数据
]]

local NewGotTipsMgr = class("NewGotTipsMgr")

function NewGotTipsMgr:ctor()
    self.showDatas = {}
end

function NewGotTipsMgr:Destroy()
    self.showDatas = nil
end

function NewGotTipsMgr:GetShowData()
    if self.showDatas then
        local curData = self.showDatas[1]
        if curData and curData.datas then
            return curData.type, curData.datas[1]
        end
    end
	return nil, nil
end

---@param type type为类型获得新技能，解锁新功能等,（1:为获得新技能）
---@param datas 技能时为List{skillType=Enum.SkillType.Active,skillId=10001}
function NewGotTipsMgr:AddShowData(type, datas)
    if not self.showDatas then self.showDatas = {} end
    table.insert(self.showDatas, {type = type, datas = datas})
    if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UISuccessTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISuccessTips)
    end
end

function NewGotTipsMgr:RemoveCurShowData()
    if not self.showDatas then return false end
    local curData = self.showDatas[1]
	if curData and curData.datas then
		table.remove(curData.datas, 1)
		if #curData.datas <= 0 then
			table.remove(self.showDatas, 1)
		end
	else
		table.remove(self.showDatas, 1)
    end
    return self.showDatas[1] ~= nil
end

return NewGotTipsMgr