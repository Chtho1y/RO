--这个脚本是UIRoleMessage界面中用来显示角色技能的控制
local SkillSlotOriginalCtr = {}

function SkillSlotOriginalCtr:SetData(_wnd, _item, _data)
    local _id = _data.id;
    local _lock = _id <= 0;
    _item.locked.gameObject:SetActive(_lock);
    _item.noSkill.gameObject:SetActive(not _lock);
    _item.skillListItem.gameObject:SetActive(not _lock);

    if not _lock then
        local skillId = GetMathInteger(_data._id,1000)
        local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(skillId)
        if skillCfgData.Icon and skillCfgData.Icon ~= '' then
            CommonUtil.LoadIcon(_wnd, skillCfgData.Icon, function (sprite)
                _item.equip.image.sprite = sprite
            end, _item, "IconAsyncIdx")
        end

        _item.skillName.text.text = skillCfgData.Name

        local _skillLvCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(_data._id);
        _item.desTxt.text.text = string.formatbykey(_skillLvCfgData.Desc,_skillLvCfgData.DescParam);
    end
end

return SkillSlotOriginalCtr