using LuaInterface;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;

public struct UICfgData
{
    public int id;
    public string name;
    public string res_path;
}

public class GenerateLuaTemple
{
    static Dictionary<GameObject, Dictionary<string, string>> uiNodes =
       new Dictionary<GameObject, Dictionary<string, string>>();

    static Dictionary<string, bool> Generated = new Dictionary<string, bool>();
    static Dictionary<string, GenerateData> needGenerate = new Dictionary<string, GenerateData>();
    static string currPrefabPath = string.Empty;

    private const string c_UICfgPath = "Assets/Lua/Config/UICfg.lua";
    static Dictionary<int, UICfgData> UIConfigData = new Dictionary<int, UICfgData>();

    private static List<string> nullStr = new List<string>();
    private static List<string> nullPeerStr = new List<string>();

    public static readonly string UIPrefabDirPath = "Assets/Content/Prefabs/UI/";
    const string LuaViewDirPath = "Assets/Lua/UI/{0}.lua";

    const string LuaGridViewDir = "GridViewItem/";

    const string TextMeshProString = "textMeshProUGUI";
    const string TextString = "text";

    static Dictionary<string, string> ComponentTypes = new Dictionary<string, string>
    {
        //{ typeof(RectTransform).FullName, "xxxx" },
    };
    public static Dictionary<string, List<string>> functions = new Dictionary<string, List<string>>
    {

    };

    struct Class
    {
        public string name;
        public string super;
        public Dictionary<string, ClassFiled> fileds;
    }

    struct ClassFiled
    {
        public ClassFiled(string name, string type)
        {
            this.name = name;
            this.type = type;
        }
        public string name;
        public string type;
    }

    struct GenerateData
    {
        public GameObject gameObject;
        public string className;
        public string filePath;
        public string luaPath;
        public string uitype;
        public bool bTouchCLose;
        public string id;
        public int type;
    }

    [MenuItem("Assets/GenerateLuaClass(生成UI代码)")]
    [MenuItem("Tools/GenerateLuaClass")]
    public static void GenerateLua()
    {
        List<GameObject> objs = new List<GameObject>();
        GameObject[] gameObjects = Selection.gameObjects;
        Transform[] activeTransforms = Selection.transforms;
        foreach (GameObject gameObject in gameObjects)
        {
            bool bPrfab = true;
            foreach (Transform activeTransform in activeTransforms)
            {
                if (activeTransform == gameObject.transform)
                {
                    bPrfab = false;
                    break;
                }
            }
            if (bPrfab)
            {
                objs.Add(gameObject);
            }
        }
        Generate(objs);
        //TransPanelTool.TransPanel();
    }

    //[MenuItem("Assets/GenerateAllUILuaClass(生成所有UI代码)")]
    [MenuItem("Tools/GenerateAllUILuaClass(生成所有UI代码)")]
    public static void GenerateAllUILua()
    {
        string[] allPath = AssetDatabase.FindAssets("t:Prefab", new string[] { "Assets/Content/Prefabs/UI" });
        Debug.Log(allPath.Length);
        List<GameObject> objs = new List<GameObject>();
        for (int i = 0; i < allPath.Length; i++)
        {
            string path = AssetDatabase.GUIDToAssetPath(allPath[i]);
            var obj = AssetDatabase.LoadAssetAtPath(path, typeof(GameObject)) as GameObject;
            if (obj != null)
            {
                objs.Add(obj);
            }
        }
        Generate(objs);
        //TransPanelTool.TransPanel();
    }

    public static void Generate(List<GameObject> objs)
    {
        GenerateCode(objs);
        AssetDatabase.Refresh();
    }

    private static bool CheckDepObjs(GameObject obj)
    {
        Func<Transform, string> getPathName = (o) =>
        {
            string path = o.name;
            Transform parent = o.parent;
            while (parent != null)
            {
                path = parent.name + "/" + path;
                parent = parent.parent;
            }
            return path;
        };
        UINode[] nodes = obj.GetComponentsInChildren<UINode>();
        foreach (var node in nodes)
        {
            if (node.depObjs == null)
            {
                continue;
            }
            foreach (var depObj in node.depObjs)
            {
                if (depObj)
                {
                    if (depObj.gameObject == node.gameObject)
                    {
                        Debug.LogError("uinode 不能 依赖 自身！！！！！ " + getPathName(node.transform));
                        return false;
                    }

                    Transform parent = node.transform.parent;
                    bool bFind = false;
                    while (parent != null)
                    {
                        UINode uiNode = parent.GetComponent<UINode>();
                        if (uiNode == depObj)
                        {
                            bFind = true;
                            break;
                        }
                        parent = parent.parent;
                    }
                    if (!bFind)
                    {
                        parent = node.transform.parent;
                        while (parent != null)
                        {
                            parent = parent.parent;
                        }
                    }
                }

            }
        }
        return true;
    }

    private static void GenerateCode(List<GameObject> objs)
    {
        foreach (var obj in objs)
        {
            if (!CheckDepObjs(obj))
                return;
        }
        Generated.Clear();
        needGenerate.Clear();
        UIConfigData.Clear();

        foreach (GameObject gameObject in objs)
        {
            string assetPath = AssetDatabase.GetAssetPath(gameObject);

            UIGridViewMark mark = gameObject.GetComponent<UIGridViewMark>();

            GenerateData data = new GenerateData();

            string filePath = "";
            string className = "";
            string luaPath = "";

            if (mark)
            {
                className = gameObject.name;
                filePath = string.Format(LuaViewDirPath, LuaGridViewDir + className);
                data.type = 1;
            }
            else
            {
                UICfgData? config = GetUIConfig(gameObject.name);
                if (config == null)
                {
                    DebugHelper.LogError("[GenerateLua error] {0} {1} {2}", "UIConfig", gameObject.name, "isnt exist");
                    continue;
                }

                UICfgData data1 = config.Value;
                className = data1.name;
                luaPath = data1.res_path;
                filePath = string.Format(LuaViewDirPath, luaPath + "View");
                data.type = 0;
            }

            data.gameObject = gameObject;
            data.className = className;
            data.filePath = filePath;
            data.luaPath = luaPath;

            if (!needGenerate.ContainsKey(className))
            {
                needGenerate[className] = data;
            }
        }

        while (needGenerate.Count > 0)
        {
            foreach (string key in needGenerate.Keys)
            {
                uiNodes.Clear();
                GenerateData data = needGenerate[key];
                string filePath = data.filePath;
                string uitype = data.uitype;
                string className = data.className;
                string luaPath = data.luaPath;
                GameObject gameObject = data.gameObject;

                string dirPath = filePath.Substring(0, filePath.LastIndexOf("/") + 1);
                if (!Directory.Exists(dirPath))
                {
                    Directory.CreateDirectory(dirPath);
                }

                if (data.type == 0)
                {
                    //UI类型
                    GenerateView(gameObject, className, filePath, luaPath);

                    string generatePath = filePath.Replace(".lua", "_Generate.lua");
                    GenerateMap(gameObject, className, generatePath, luaPath, data.type);

                    string ctrPath = filePath.Replace("View", "Ctr");
                    GenerateCtr(gameObject, className, ctrPath, luaPath);
                }
                else
                {
                    //GridItem类型
                    string generatePath = filePath.Replace(".lua", "_Generate.lua");
                    GenerateMap(gameObject, className, generatePath, luaPath, data.type);
                }

                Generated[key] = true;
                needGenerate.Remove(key);
                break;
            }
        }

        Debug.Log("Generate  lua  over ");
    }

    private static void Generate_Field(StringBuilder sb_logic, string className)
    {
        sb_logic.Append(string.Format("---@class {0}\r\n", className));
        sb_logic.Append(string.Format("---##################### 【{0} Generate Field】  Start #####################\r\n", className));
        sb_logic.Append(string.Format("---自动生成代码变量声明\r\n"));
        sb_logic.Append(string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Generate Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className));

        sb_logic.Append(string.Format("---##################### 【{0} Custom Field】  Start #####################\r\n", className));
        sb_logic.Append(string.Format("---TODO 自定义变量声明在这里: ---@field [public|protected|private] field_name FIELD_TYPE[|OTHER_TYPE]\r\n"));
        sb_logic.Append(string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Custom Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className));
    }

    private static void GenerateView(GameObject obj, string className, string path, string luaPath)
    {
        if (File.Exists(path)) return;

        StringBuilder sb_logic = new StringBuilder();

        int index = luaPath.IndexOf("/");
        string dir = luaPath.Substring(0, index);
        string viewName = className + "View";
        string ctrName = dir + "/" + className + "Ctr";
        string generateName = dir + "/" + viewName + "_Generate";
        sb_logic.Append(string.Format("local {0} = require(\"" + generateName + "\")\r\n", viewName, viewName));
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnAwake(data)\r\n", viewName));
        sb_logic.Append("\tself.controller = require(\"" + ctrName + "\"):new()\r\n");
        sb_logic.Append("\tself.controller:Init(self)\r\n");
        sb_logic.Append("\tself.controller:SetData(data)\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:AddEventListener()\r\n", viewName));
        sb_logic.Append("\tManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)\r\n");
        sb_logic.Append("\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:FillContent(data, uiBase)\r\n", viewName));
        sb_logic.Append("\tself.uiBase = uiBase\r\n");
        sb_logic.Append("\tlocal gameObject = self.uiBase:GetRoot()\r\n");
        sb_logic.Append("\tif gameObject ~= nil then\r\n");
        sb_logic.Append("\t\tself.gameObject = gameObject\r\n");
        sb_logic.Append("\t\tself.transform = gameObject.transform\r\n");
        sb_logic.Append("\tend\r\n");
        sb_logic.Append("\tself:InitGenerate(self.transform, data)\r\n");
        sb_logic.Append("\r\n");
        sb_logic.Append("\tself:Init()\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:Init()\r\n", viewName));
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:RemoveEventListener()\r\n", viewName));
        sb_logic.Append("\tManagerContainer.LuaEventMgr:Unregister(self.uiData.name)\r\n");
        sb_logic.Append("\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:AddUIEventListener()\r\n", viewName));
        sb_logic.Append("\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnHide()\r\n", viewName));
        sb_logic.Append("\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnShow(data)\r\n", viewName));
        sb_logic.Append("\tself.controller:SetData(data)\r\n");
        sb_logic.Append("\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnClose()\r\n", viewName));
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnDispose()\r\n", viewName));
        sb_logic.Append("\tself.controller:OnDispose()\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("return {0}\r\n", viewName));

        sb_logic.Append("\r\n");

        using (StreamWriter textWriter = new StreamWriter(path, false, new UTF8Encoding(false)))
        {
            textWriter.Write(sb_logic.ToString());
            textWriter.Flush();
            textWriter.Close();
        }
        sb_logic.Clear();
        sb_logic = null;

        //string baseClassName = "UIBase";

        //GenerateContent(obj, className, path, generatePath, sb_logic, baseClassName);
    }

    private static void GenerateCtr(GameObject obj, string className, string path, string luaPath)
    {
        if (File.Exists(path)) return;

        StringBuilder sb_logic = new StringBuilder();

        string ctrName = className + "Ctr";
        string baseClassName = "UICtrBase";

        sb_logic.Append(string.Format("local {0} = class(\"{1}\", require(\"{2}\"))\r\n", ctrName, ctrName, baseClassName));
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:Init(view)\r\n", ctrName));
        sb_logic.Append("\tself.view = view\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:SetData(data)\r\n", ctrName));
        sb_logic.Append("\tself.asyncIdx = 0\r\n");
        sb_logic.Append("\tif data == nil then return end\r\n");
        sb_logic.Append("\tself.data = data\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:GetAsyncIdx()\r\n", ctrName));
        sb_logic.Append("\tself.asyncIdx = self.asyncIdx + 1\r\n");
        sb_logic.Append("\treturn self.asyncIdx\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");


        sb_logic.Append(string.Format("function {0}:GetData()\r\n", ctrName));
        sb_logic.Append("\treturn self.data\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("function {0}:OnDispose()\r\n", ctrName));
        sb_logic.Append("\tself.data = nil\r\n");
        sb_logic.Append("\tself.view = nil\r\n");
        sb_logic.Append("end\r\n");
        sb_logic.Append("\r\n");

        sb_logic.Append(string.Format("return {0}\r\n", ctrName));

        sb_logic.Append("\r\n");

        using (StreamWriter textWriter = new StreamWriter(path, false, new UTF8Encoding(false)))
        {
            textWriter.Write(sb_logic.ToString());
            textWriter.Flush();
            textWriter.Close();
        }
        sb_logic.Clear();
        sb_logic = null;

        //string baseClassName = "UIBase";

        //GenerateContent(obj, className, path, generatePath, sb_logic, baseClassName);
    }

    private static Class CreateNewClass(ref Dictionary<string, Class> classes, string cls, string var)
    {
        string clsName = cls + "__Generate";
        if (var.Length > 0)
        {
            if (var.IndexOf(".") > 0)
            {
                var var_ = var.Replace(".", "_");
                if (!var_.StartsWith("_"))
                {
                    var_ = "_" + var_;
                }
                clsName = cls + "__Generate" + var_;
            }
            else
            {
                clsName = cls + "__Generate" + "_" + var;
            }
        }


        if (!classes.ContainsKey(clsName))
        {
            Class newClass = new Class();
            newClass.name = clsName;
            if (clsName == cls + "__Generate")
                newClass.super = string.Empty;
            else
                newClass.super = typeof(GameObject).FullName;
            newClass.fileds = new Dictionary<string, ClassFiled>();

            classes[clsName] = newClass;
        }

        if (var.Length > 0)
        {
            string var2 = string.Empty;
            string filedName = var;

            int indexOf = var.LastIndexOf(".");
            if (indexOf > 0)
            {
                var2 = var.Substring(0, indexOf);
                filedName = var.Substring(indexOf + 1, var.Length - indexOf - 1);
            }

            Class cls2 = CreateNewClass(ref classes, cls, var2);
            if (!cls2.fileds.ContainsKey(filedName))
            {
                ClassFiled classFiled = new ClassFiled();
                classFiled.name = filedName;
                classFiled.type = clsName;
                cls2.fileds[filedName] = classFiled;
            }
        }

        return classes[clsName];

    }

    private static void AddClassField(ref Dictionary<string, Class> classes, string cls, string filed, string type)
    {
        string var = string.Empty;
        string filedName = filed;
        int indexOf = filed.LastIndexOf(".");
        if (indexOf > 0)
        {
            var = filed.Substring(0, indexOf);
            filedName = filed.Substring(indexOf + 1, filed.Length - indexOf - 1);
        }
        Class newClass = CreateNewClass(ref classes, cls, var);
        if (!newClass.fileds.ContainsKey(filedName))
        {
            ClassFiled classFiled = new ClassFiled();
            classFiled.name = filedName;
            classFiled.type = type;
            newClass.fileds[filedName] = classFiled;
        }

    }

    private static StringBuilder classesToString(ref Dictionary<string, Class> classes, string clsName)
    {
        StringBuilder sb = new StringBuilder();
        clsName = clsName + "__Generate";
        foreach (var cls in classes.Values)
        {
            if (cls.fileds.Count == 0)
            {
                continue;
            }
            string str = string.Empty;

            if (cls.super.Length > 0)
            {
                if (cls.super == typeof(GameObject).FullName)
                {
                    str += string.Format("---@class {0}\r\n", cls.name);
                    str += string.Format("---@field public {0} {1}\r\n", "gameObject", typeof(GameObject).FullName);
                }
                else
                    str += string.Format("---@class {0} : {1}\r\n", cls.name, cls.super);
            }
            else
                str += string.Format("---@class {0}\r\n", cls.name);

            foreach (var filed in cls.fileds.Values)
            {
                string type = filed.type;
                if (classes.ContainsKey(type) && classes[type].fileds.Count == 0)
                {
                    type = classes[type].super;
                }

                string p = "public";
                if (cls.name == clsName)
                    p = "private";
                str += string.Format("---@field {0} {1} {2}\r\n", p, filed.name, type);
            }

            if (cls.name == clsName)
                sb.Append(str);
            else
            {
                str += "\r\n";
                sb.Insert(0, str);
            }
        }

        return sb;
    }

    private static void GenerateMap(GameObject obj, string className, string path, string luaPath, int type = 0)
    {
        StringBuilder sb_logic = new StringBuilder();

        string baseClassName = "UIViewBase";
        string viewName = className + "View";
        string logic = string.Empty;

        Dictionary<string, Class> classes = new Dictionary<string, Class>();
        AddClassField(ref classes, className, "gameObject", typeof(GameObject).FullName);
        AddClassField(ref classes, className, "transform", typeof(Transform).FullName);

        nullStr.Clear();
        nullPeerStr.Clear();

        StringBuilder sb = new StringBuilder();

        if (type == 0)
        {
            sb.Append(string.Format("local {0} = class(\"{1}\", require(\"{2}\"))\r\n", viewName, viewName, baseClassName));
        }
        else
        {
            sb.Append(string.Format("local {0} = class(\"{1}\")\r\n", viewName, viewName));
        }
        sb.Append("\r\n");

        sb.Append(string.Format("function {0}:ctor()\r\n", viewName));
        sb.Append("end\r\n");
        sb.Append("\r\n");

        sb.Append("---@private\r\n");
        sb.Append(string.Format("function {0}:SetActive(result)\r\n", viewName));
        sb.Append("\tself.gameObject:SetActive(result)\r\n");
        sb.Append("end\r\n");

        sb.Append("---@private\r\n");
        sb.Append(string.Format("function {0}:InitGenerate(Root, data)\r\n", viewName));
        sb.Append("\tself.transform = Root\r\n");
        sb.Append("\tself.inited = true\r\n");
        sb.Append("\r\n");
        if (type == 0)
        {
            sb.Append("\tif self.super.Init then\r\n");
            sb.Append("\t\tself.super.Init(self)\r\n");
            sb.Append("\tend\r\n");
        }
        sb.Append("\tlocal tmp\r\n");
        sb.Append("\r\n");

        StringBuilder tmpsb = new StringBuilder();
        StringBuilder funcsb = new StringBuilder();
        int funcIndex = 0;
        Func<StringBuilder, bool> addFuncString = builder =>
        {
            if (builder.Length > 0)
            {
                ++funcIndex;
                funcsb.Append("---@private\r\n");
                funcsb.Append(string.Format("function {0}:InitGenerate__{1}(Root, data)\r\n", viewName, funcIndex));
                funcsb.Append(builder);
                funcsb.Append("end\r\n");
                funcsb.Append("\r\n");
                builder.Clear();
            }

            return true;
        };
        Func<string, Transform, bool> doInit = null;
        doInit = (parentName, trans) =>
        {
            bool bcontinue = true;

            foreach (Transform child in trans)
            {
                if (child.parent != obj.transform && child.parent.GetComponent<UIGridViewMark>() != null) continue;

                string name = CheckUnityTYpe(false, obj, path, parentName, child, tmpsb, ref logic, className, out bcontinue, ref classes);
                addFuncString(tmpsb);
                if (bcontinue)
                    doInit(name, child);
            }
            return true;
        };
        bool ttt = true;
        CheckUnityTYpe(true, obj, path, string.Empty, obj.transform, tmpsb, ref logic, className, out ttt, ref classes);
        addFuncString(tmpsb);
        doInit(string.Empty, obj.transform);

        for (int i = 0; i < funcIndex; i++)
        {
            sb.Append(string.Format("\tself:InitGenerate__{0}(Root,data)\r\n", i + 1));
        }

        sb.Append("\r\n");
        sb.Append("\r\n");
        sb.Append("end\r\n");
        sb.Append("\r\n");
        sb.Append(funcsb);

        sb.Append("---@private\r\n");
        sb.Append(string.Format("function {0}:GenerateDestroy()\r\n", viewName));
        /*foreach (var str in nullPeerStr)
        {
            sb.Append(str);
        }*/
        for (int i = nullPeerStr.Count - 1; i >= 0;--i)
        {
            sb.Append(nullPeerStr[i]);
        }
        foreach (var str in nullStr)
        {
            sb.Append(str);
        }
        sb.Append("\tself.transform = nil\r\n");
        sb.Append("\tself.gameObject = nil\r\n");
        sb.Append("\tself.inited = false\r\n");
        sb.Append("end\r\n");

        sb.Append(string.Format("return {0}", viewName));


        sb.Insert(0, classesToString(ref classes, className));

        using (StreamWriter textWriter = new StreamWriter(path, false, new UTF8Encoding(false)))
        {
            string rtStr = string.Format("return {0}", className);
            logic = logic.Replace(rtStr, "");
            logic += "\r\n";
            logic += rtStr + "\r\n";
            int indexOf = logic.IndexOf("\r\n\r\n\r\n");
            while (indexOf != -1)
            {
                logic = logic.Replace("\r\n\r\n\r\n", "\r\n\r\n");
                indexOf = logic.IndexOf("\r\n\r\n\r\n");
            }

            StringBuilder GenerateFieldStr = new StringBuilder();
            GenerateFieldStr.Append(string.Format("---@class {0}\r\n", className));
            GenerateFieldStr.Append(string.Format("---##################### 【{0} Generate Field】  Start #####################\r\n", className));
            GenerateFieldStr.Append(string.Format("---自动生成代码变量声明\r\n"));
            GenerateFieldStr.Append(string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Generate Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className));

            StringBuilder CustomFieldStr = new StringBuilder();
            CustomFieldStr.Append(string.Format("---##################### 【{0} Custom Field】  Start #####################\r\n", className));
            CustomFieldStr.Append(string.Format("---TODO 自定义变量声明在这里: ---@field [public|protected|private] field_name FIELD_TYPE[|OTHER_TYPE]\r\n"));
            CustomFieldStr.Append(string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Custom Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className));

            string GenerateFieldEnd = string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Generate Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className);
            string CustomFieldEnd = string.Format("---%%%%%%%%%%%%%%%%%%%%% 【{0} Custom Field】 End %%%%%%%%%%%%%%%%%%%%%\r\n", className);

            string s = string.Format("---@class {0} : {0}__Generate\r\n", className);


            int GenerateFieldEndIndex = logic.IndexOf(GenerateFieldEnd);
            int CustomFieldEndIndex = logic.IndexOf(CustomFieldEnd);

            if (CustomFieldEndIndex != -1)
            {
                //如果已经有了
                //需要更新Generate
                //TODO
                if (GenerateFieldEndIndex != -1)
                {
                    logic = logic.Replace(GenerateFieldStr.ToString(), s);
                }
            }
            else
            {
                //如果没有
                logic = s + CustomFieldStr.ToString() + logic;
            }


            textWriter.Write(logic);
            textWriter.Flush();
            textWriter.Close();
        }

        using (StreamWriter textWriter = new StreamWriter(path, false, new UTF8Encoding(false)))
        {
            textWriter.Write(sb.ToString());
            textWriter.Flush();
            textWriter.Close();
        }
    }

    private static void CheckRepeadUIName(GameObject depObj, string uiName, string path)
    {
        if (!uiNodes.ContainsKey(depObj))
        {
            uiNodes[depObj] = new Dictionary<string, string>();
        }
        Dictionary<string, string> dictionary = uiNodes[depObj];
        if (dictionary.ContainsKey(uiName))
        {
            Debug.Log(string.Format("UI名不能重复, {0} 重复节点: {1} {2}", depObj.name, dictionary[uiName], path));
            UnityEditor.EditorUtility.DisplayDialog("提示", string.Format("UI名不能重复, {0} 重复节点: {1} {2}", depObj.name, dictionary[uiName], path), "OK");
        }
        else
        {
            dictionary[uiName] = path;
        }
    }

    private static string CheckUnityTYpe(bool bTop, GameObject topObj, string fPath, string path, Transform trans, StringBuilder sb, ref string logic, string className, out bool bcontinue, ref Dictionary<string, Class> classes)
    {
        string name = string.Empty;
        if (path != String.Empty)
            name = path + "/" + trans.name;
        else
            name = trans.name;
        string ErroName = name;
        if (bTop)
        {
            ErroName = name;
            name = "Root";
        }

        bcontinue = true;

        UINode uiNode = trans.GetComponent<UINode>();
        if (uiNode && uiNode.enabled)
        {
            List<string> tmpNodes = new List<string>();
            string uiName = string.Empty;
            if (uiNode && uiNode.enabled)
            {
                uiName = trimName(uiNode.UIName);
            }
            if (uiName == string.Empty)
            {
                //UnityEditor.EditorUtility.DisplayDialog("提示", string.Format("UI名不能为空, {0}", currPrefabPath), "OK");
                uiName = getComponentArgNameWithName(trimName(trans.name));
            }
            sb.Append("--[[\r\n");
            sb.Append(string.Format("\t{0}\r\n", name));
            sb.Append("--]]\r\n");
            string varName = string.Empty;
            if (!bTop)
            {
                sb.Append(string.Format("\tlocal tmp = Root:Find(\"{0}\").gameObject\r\n", name));

                if (uiNode && uiNode.enabled)
                {
                    sb.Append(string.Format("\tif tolua.getpeer(tmp) == nil then\r\n"));
                    sb.Append(string.Format("\t\ttolua.setpeer(tmp, {{}})\r\n"));
                    sb.Append("\tend\r\n");
                    int depNum = 0;
                    if (uiNode.depObjs != null)
                    {
                        foreach (var depObj in uiNode.depObjs)
                        {
                            if (depObj)
                            {
                                depNum++;
                            }
                        }
                    }
                    //DepObjs
                    if (depNum == 0)
                    {
                        CheckRepeadUIName(topObj, uiName, ErroName);
                        if (trans.GetComponent<UIGridViewMark>() != null)
                        {
                            UIGridViewMark item = trans.GetComponent<UIGridViewMark>();
                            string gridItemName = item.GridItemName;
                            if (string.IsNullOrEmpty(item.GridItemName))
                            {
                                UnityEngine.Object parentObject = PrefabUtility.GetCorrespondingObjectFromSource(item.gameObject);
                                gridItemName = parentObject != null ? parentObject.name : item.gameObject.name;
                            }
                            gridItemName = gridItemName.Substring(0, 1).ToUpper() + gridItemName.Substring(1);
                            sb.Append(string.Format("\tself.{0} = CommonUtil.BindGridViewItem2LuaStatic(\"{1}\", tmp)\r\n", uiName, gridItemName));
                            sb.Append(string.Format("\tself.{0}.prefabName = \"{1}\"\r\n", uiName, item.GridItemName));
                            nullStr.Add(string.Format("\tif self.{0}.GenerateDestroy ~= nil then\r\n", uiName));
                            nullStr.Add(string.Format("\t\tself.{0}:GenerateDestroy()\r\n", uiName));
                            nullStr.Add(string.Format("\tend\r\n", uiName));
                        }
                        else
                        {
                            sb.Append(string.Format("\tself.{0} = tmp\r\n", uiName));
                        }

                        if (uiNode.activeType == ActiveType.Active)
                        {
                            sb.Append(string.Format("\tself.{0}:SetActive(true)\r\n", uiName));
                        }
                        else if (uiNode.activeType == ActiveType.Inactive)
                        {
                            sb.Append(string.Format("\tself.{0}:SetActive(false)\r\n", uiName));
                        }

                        nullStr.Add(string.Format("\tif tolua.getpeer(self.{0}) ~= nil then\r\n", uiName));
                        nullStr.Add(string.Format("\t\ttolua.setpeer(self.{0}, nil)\r\n", uiName));
                        nullStr.Add(string.Format("\tend\r\n", uiName));
                        nullStr.Add(string.Format("\tself.{0} = nil\r\n", uiName));
                       
                        varName = string.Format("self.{0}", uiName);
                        CreateNewClass(ref classes, className, uiName);
                        tmpNodes.Add(uiName);
                    }
                    else
                    {
                        foreach (var depObj in uiNode.depObjs)
                        {
                            if (depObj)
                            {
                                List<string> paramStrs = new List<string>();

                                Func<List<string>, UINode, string, bool> func = null;
                                func = (list, dep, parmPath) =>
                                {
                                    if (dep)
                                    {
                                        if (dep.gameObject == topObj)
                                            ;
                                        else
                                        {
                                            string s = trimName(dep.UIName);
                                            if (s == string.Empty)
                                            {
                                                s = getComponentArgNameWithName(trimName(dep.name));
                                            }
                                            parmPath = "." + s + parmPath;
                                        }
                                        bool end = false;
                                        if (dep.gameObject == topObj)
                                            end = true;
                                        else
                                        {
                                            if (dep.depObjs == null || dep.depObjs.Length == 0)
                                                end = true;
                                        }
                                        if (end)
                                        {
                                            list.Add(parmPath);
                                        }
                                        else
                                        {
                                            foreach (var value in dep.depObjs)
                                            {
                                                func(list, value, parmPath);
                                            }
                                        }

                                    }
                                    else
                                    {
                                        list.Add(parmPath);
                                    }
                                    return true;
                                };

                                func(paramStrs, depObj, string.Empty);

                                foreach (var str in paramStrs)
                                {
                                    //sb.Append(string.Format("\tself{0}.{1} = tmp\r\n", str, uiName));
                                    if (trans.GetComponent<UIGridViewMark>() != null)
                                    {
                                        UIGridViewMark item = trans.GetComponent<UIGridViewMark>();
                                        string gridItemName = item.GridItemName;
                                        if (string.IsNullOrEmpty(item.GridItemName))
                                        {
                                            UnityEngine.Object parentObject = PrefabUtility.GetCorrespondingObjectFromSource(item.gameObject);
                                            gridItemName = parentObject != null ? parentObject.name : item.gameObject.name;
                                        }
                                        gridItemName = gridItemName.Substring(0, 1).ToUpper() + gridItemName.Substring(1);
                                        sb.Append(string.Format("\tself{0}.{1} = CommonUtil.BindGridViewItem2LuaStatic(\"{2}\", tmp)\r\n", str, uiName, gridItemName));
                                        sb.Append(string.Format("\tself{0}.{1}.prefabName = \"{2}\"\r\n", str, uiName, gridItemName));

                                        string destroy = string.Format("\tif self{0}.{1}.GenerateDestroy ~= nil then\r\n\t\tself{0}.{1}:GenerateDestroy()\r\n\tend\r\n", str, uiName, str, uiName);
                                        string peer = string.Format("\tif tolua.getpeer(self{0}.{1}) ~= nil then\r\n\t\ttolua.setpeer(self{0}.{1}, nil)\r\n\tend\r\n", str, uiName, str, uiName);

                                        nullPeerStr.Add(peer);
                                        nullPeerStr.Add(destroy);
                                     
                                        //nullPeerStr.Add(string.Format("\tif self{0}.{1}.GenerateDestroy ~= nil then\r\n", str, uiName));
                                        //nullPeerStr.Add(string.Format("\t\tself{0}.{1}:GenerateDestroy()\r\n", str, uiName));
                                        //nullPeerStr.Add("\tend\r\n");
                                    }
                                    else
                                    {
                                        sb.Append(string.Format("\tself{0}.{1} = tmp\r\n", str, uiName));
                                        string peer = string.Format("\tif tolua.getpeer(self{0}.{1}) ~= nil then\r\n\t\ttolua.setpeer(self{0}.{1}, nil)\r\n\tend\r\n", str, uiName, str, uiName);
                                        nullPeerStr.Add(peer);
                                    }

                                    if (uiNode.activeType == ActiveType.Active)
                                    {
                                        sb.Append(string.Format("\tself{0}.{1}:SetActive(true)\r\n", str, uiName));
                                    }
                                    else if (uiNode.activeType == ActiveType.Inactive)
                                    {
                                        sb.Append(string.Format("\tself{0}.{1}:SetActive(false)\r\n", str, uiName));
                                    }

                                    //nullPeerStr.Add(string.Format("\tif tolua.getpeer(self{0}.{1}) ~= nil then\r\n", str, uiName));
                                    //nullPeerStr.Add(string.Format("\t\ttolua.setpeer(self{0}.{1}, nil)\r\n", str, uiName));
                                    //nullPeerStr.Add("\tend\r\n");

                                    string s = string.Format("{0}.{1}", str, uiName);
                                    CreateNewClass(ref classes, className, s.Substring(1, s.Length - 1));
                                    tmpNodes.Add(s.Substring(1, s.Length - 1));
                                    if (varName == string.Empty)
                                    {
                                        varName = string.Format("self{0}.{1}", str, uiName);
                                    }
                                }

                                CheckRepeadUIName(depObj.gameObject, uiName, ErroName);
                            }
                        }
                    }
                }
            }

            for (int i = 0; i < uiNode.keys.Count; i++)
            {
                string type = uiNode.keys[i];
                bool value = uiNode.values[i];
                if (!value)
                {
                    continue;
                }
                if (bTop)
                {
                    uiName = getComponentArgName(type);
                    CheckRepeadUIName(topObj, uiName, ErroName);
                }

                //Button
                //Toggle
                //Slider
                //Scrollbar
                //Dropdown
                //InputField
                //RectTranform
                //Text
                //Image
                //RawImage
                //ScrollRect
                //CanvasGroup
                //Other
                CheckUnityTYpe_Default(varName, bTop, type, uiName, name, trans, sb, ref logic, className, ref tmpNodes, ref classes);
            }

            foreach (var typeName in functions.Keys)
            {
                bool needCode = false;
                for (int i = 0; i < uiNode.keys.Count; i++)
                {
                    if (uiNode.keys[i] == typeName && !uiNode.values[i])
                    {
                        needCode = true;
                        break;
                    }
                }
                if (needCode)
                {
                    sb.Append("\r\n");
                    SetComponentCode(bTop, uiName, sb, typeName, className, ref tmpNodes, ref classes);
                }
            }
        }

        return name;
    }

    private static void CheckUnityTYpe_Default(string varName, bool bTop, string typeFullName, string uiName, string name, Transform trans, StringBuilder sb, ref string logic, string className, ref List<string> tmpNodes, ref Dictionary<string, Class> classes)
    {
        sb.Append("\r\n");
        SetComponentCode(bTop, uiName, sb, typeFullName, className, ref tmpNodes, ref classes);
    }

    private static string trimName(string name)
    {
        string trim = name.Replace(" ", "");
        trim = trim.Replace("\r", "");
        trim = trim.Replace("\n", "");
        trim = trim.Replace("\t", "");
        return trim;
    }

    public static string getComponentArgName(string typeFullName)
    {
        string name = typeFullName;
        int indexOf = name.LastIndexOf(".");
        if (indexOf != -1)
        {
            name = name.Substring(indexOf + 1, name.Length - indexOf - 1);
        }
        return getComponentArgNameWithName(name);
    }

    public static string getComponentArgNameWithName(string str)
    {
        return str.Substring(0, 1).ToLower() + str.Substring(1, str.Length - 1);
    }

    public static string getComponentTypeName(string fullName)
    {
        if (ComponentTypes.ContainsKey(fullName))
        {
            return "Enum.TypeInfo." + ComponentTypes[fullName];
        }
        else
        {
            string name = fullName;
            int indexOf = name.LastIndexOf(".");
            if (indexOf != -1)
            {
                name = name.Substring(indexOf + 1, name.Length - indexOf - 1);
            }
            return "Enum.TypeInfo." + name;
        }
    }

    private static void SetComponentCode(bool bTop, string uiName, StringBuilder sb, string fullName, string className, ref List<string> tmpNodes, ref Dictionary<string, Class> classes)
    {
        if (bTop)
        {
            string commonUI = getComponentArgName(fullName);
            sb.Append(string.Format("\tself.{0} = Root:GetComponent({1})\r\n", commonUI, getComponentTypeName(fullName)));
            if (getComponentTypeName(fullName).Equals("Enum.TypeInfo.Animator"))
            {
                sb.Append("\tself.animator.logWarnings = false\r\n");
            }
            AddClassField(ref classes, className, commonUI, fullName);
            if (functions.ContainsKey(fullName))
            {
                List<string> list = functions[fullName];
                foreach (var funcName in list)
                {
                    sb.Append(string.Format("\tself.{0}:{1}()\r\n", commonUI, funcName));
                }
            }
        }
        else
        {
            string componentStr = string.Format("tmp.{0}", getComponentArgName(fullName));
            //在这里对textMeshProUGUI特殊处理，将textMeshProUGUI替换成text
            string newcomponentStr = componentStr.Replace(TextMeshProString, TextString);
            sb.Append(string.Format("\t{0} = tmp:GetComponent({1})\r\n", newcomponentStr, getComponentTypeName(fullName)));
            if (getComponentTypeName(fullName).Equals("Enum.TypeInfo.Animator"))
            {
                sb.Append("\ttmp.animator.logWarnings = false\r\n");
            }
            string s = newcomponentStr.Substring(4, newcomponentStr.Length - 4);
            foreach (var node in tmpNodes)
            {
                AddClassField(ref classes, className, string.Format("{0}.{1}", node, s), fullName);
            }

            if (functions.ContainsKey(fullName))
            {
                List<string> list = functions[fullName];
                foreach (var funcName in list)
                {
                    sb.Append(string.Format("\t{0}:{1}()\r\n", componentStr, funcName));
                }
            }
        }

    }


    static Dictionary<string, Dictionary<string, string>> GetData(string content)
    {
        int linestart = 1;
        int rowstart = 1;
        string splitword = ",";

        string[] lineArray;
        string[] charArray;

        string text = content.Replace("\r\n", "@");
        lineArray = text.Split("@"[0]);
        //DebugHelper.LogWarning("[TableName: {0}]lineArray {1}",binAsset.name, lineArray[0]);
        string[] indexname = lineArray[1].Split(splitword[0]);
        Dictionary<string, Dictionary<string, string>> Table = new Dictionary<string, Dictionary<string, string>>();

        for (int i = linestart; i < lineArray.Length; ++i)
        {
            charArray = lineArray[i].Split(splitword[0]);
            if (charArray.Length > 0 && charArray[0] == string.Empty)
            {
                DebugHelper.LogWarning("[ConfigMgr. GetData] Empty Index {0} {1}", "UIConfig", i);
                continue;
            }

            Dictionary<string, string> Row = new Dictionary<string, string>();
            for (int j = 0; j < charArray.Length; ++j)
            {
                if (indexname[j] == "" || indexname[j] == string.Empty)
                {
                    DebugHelper.LogWarning("[ConfigMgr. GetData] Empty key {0} {1}", "UIConfig", j);
                    continue;
                }
                if (Row.ContainsKey(indexname[j]))
                {
                    DebugHelper.LogWarning("[ConfigMgr. GetData] {0} {1}", "UIConfig", indexname[j]);
                    continue;
                }
                Row.Add(indexname[j], charArray[j]);
            }
            if (Table.ContainsKey(charArray[0]))
            {
                DebugHelper.LogWarning("[ConfigMgr. GetData] {0} {1} {2}", "UIConfig", i, lineArray[i - 1]);
                continue;
            }
            Table.Add(charArray[0], Row);
        }
        return Table;
    }
    static UICfgData? GetUIConfig(string name)
    {
        try
        {
            if (UIConfigData.Count == 0)
            {
                if (Application.isPlaying)
                {
                    try
                    {
                        LuaState luaState = LuaMgr.Instance.luaState;
                        LuaForEach<int, LuaTable>(luaState, c_UICfgPath, InitUIConfig);

                        foreach (var data in UIConfigData)
                        {
                            UICfgData data1 = data.Value;
                            if (data1.name.Equals(name))
                            {
                                return data1;
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        Debug.LogException(e);
                    }
                }
                else
                {
                    using (LuaState luaState = new LuaState())
                    {
                        try
                        {
                            luaState.Start();
                            // LuaForEach<string, LuaTable>(luaState, c_LanguagePackagePath, InitLanguagePackage);
                            LuaForEach<int, LuaTable>(luaState, c_UICfgPath, InitUIConfig);

                            foreach (var data in UIConfigData)
                            {
                                UICfgData data1 = data.Value;
                                if (data1.name.Equals(name))
                                {
                                    return data1;
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            Debug.LogException(e);
                        }
                    }
                }
            }
            else
            {
                foreach (var data in UIConfigData)
                {
                    UICfgData data1 = data.Value;
                    if (data1.name.Equals(name))
                    {
                        return data1;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }

        return null;
    }

    private static void InitUIConfig(int key, LuaTable value)
    {
        if (UIConfigData.ContainsKey(key))
        {
            Debug.LogError(c_UICfgPath + "存在相同的Id ：" + key);
            return;
        }
        UICfgData roleCfgData = new UICfgData()
        {
            id = key,
            name = value.RawGet<string, string>("name"),
            res_path = value.RawGet<string, string>("res_path"),
        };
        UIConfigData.Add(key, roleCfgData);
    }

    private static void LuaForEach<K, V>(LuaState luaState, string luaFile, Action<K, V> foreachFun)
    {
        using (LuaTable luaTable = luaState.DoFile<LuaTable>(luaFile))
        {
            try
            {
                using (LuaDictTable<K, V> luaDictTable = luaTable.ToDictTable<K, V>())
                {
                    try
                    {
                        foreach (var item in luaDictTable)
                        {
                            foreachFun(item.Key, item.Value);
                        }
                    }
                    catch (Exception e)
                    {
                        Debug.LogException(e);
                    }
                }
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
        }
    }

    static void PackageUINodeGOPath(UINode node, ref string path)
    {
        if (node.UIName == string.Empty)
        {
            node.UIName = getComponentArgNameWithName(trimName(node.gameObject.name));
        }
        path = "." + path;
        path = node.UIName + path;
        if (node.depObjs.Length > 0)
        {
            UINode node1 = node.depObjs[0];
            PackageUINodeGOPath(node1, ref path);
        }
        else
        {
            path = path.Substring(0, path.Length - 1);
        }
    }

    [MenuItem("GameObject/FindUINodeGOPath", false, 21)]
    public static void FindUINodeGOPath()
    {
        GameObject[] gameObjects = Selection.gameObjects;
        if (gameObjects.Length == 0) return;

        GameObject go = gameObjects[0];

        UINode node = go.GetComponent<UINode>();
        if (node == null)
        {
            DebugHelper.LogError("该对象不存在UINode 组件，请添加上再操作!");
            return;
        }

        string path = string.Empty;
        node.FindUINodeGOPath(ref path);

        string rootName = "";
        Transform[] parents = go.GetComponentsInParent<Transform>();
        if (parents != null)
        {
            foreach (var parent in parents)
            {
                if (parent.parent == null || parent.parent.name.Equals("UIRoot") || parent.parent.name.Equals("UIRoot (Environment)"))
                {
                    rootName = parent.name;
                    break;
                }
            }
        }
        DebugHelper.LogError(rootName);
        UICfgData? config = GetUIConfig(rootName);
        if (config == null)
        {
            DebugHelper.LogError("[GenerateLua error] {0} {1} {2}", "UIConfig", rootName, "isnt exist");
            return;
        }

        UICfgData data1 = config.Value;

        int uiId = data1.id;

        DebugHelper.LogError("所选对象 界面 路径 为:  " + path + "   uiname  " + rootName  + "  uiId  " + uiId);
    }
}