local TeacherLogUIView = class("TeacherLogUIView")

function TeacherLogUIView:ctor()

end

function TeacherLogUIView:InitGo(root,uiGo)
    self.root = root
    self.viewLua = CommonUtil.BindGridViewItem2Lua(self.root, "TeacherLogUI", uiGo)

    self.viewLua.transform:SetParent(self.root.transform, false)
    self.viewLua.transform.localScale = Vector3.one
    self.viewLua.rectTransform.anchorMin = Vector2.zero
    self.viewLua.rectTransform.anchorMax = Vector2.one
    self.viewLua.rectTransform.pivot = Vector2(0.5, 0.5)
    self.viewLua.rectTransform.anchoredPosition3D = Vector3.zero
    self.viewLua.rectTransform.sizeDelta = Vector2.zero
end

function TeacherLogUIView:AddEventListener()

end

function TeacherLogUIView:RemoveEventListener()

end

function TeacherLogUIView:Show()
    self.viewLua:SetActive(true)
    self:AddEventListener()
end

function TeacherLogUIView:Hide()
    self.viewLua:SetActive(false)
    self:RemoveEventListener()
end

function TeacherLogUIView:Dispose()
    self:Hide()
    self.viewLua = nil
end

return TeacherLogUIView