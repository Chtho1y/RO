using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DropDownHelper
{
    public static void ClearDropDown(Dropdown _dropDown)
    {
        _dropDown.ClearOptions();
    }

    public static void SetDropDownItems(Dropdown _dropDown, string _name)
    {
        Dropdown.OptionData _itemData = new Dropdown.OptionData();
        _itemData.text = _name;
        _dropDown.options.Add(_itemData);
    }

    public static void SetStartName(Dropdown _dropDown, string _name)
    {
        _dropDown.captionText.text = _name;
    }

    public static void AddListener(Dropdown _dropDown, UnityEngine.Events.UnityAction<int> _action)
    {
        _dropDown.onValueChanged.RemoveAllListeners();
        _dropDown.onValueChanged.AddListener(_action);
    }
}
