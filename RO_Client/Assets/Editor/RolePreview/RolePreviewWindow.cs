using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.Compilation;
using UnityEditor.Experimental.GraphView;
using LuaInterface;

namespace RO.Editor
{
    public class RolePreviewWindow : EditorWindow, ISearchWindowProvider
    {
        [MenuItem("RO_Tool/主角预览")]
        private static RolePreviewWindow OpenWindow()
        {
            var window = EditorWindow.GetWindow<RolePreviewWindow>("主角预览");
            window.minSize = new Vector2(260, 280);
            return window;
        }

        [DidReloadScripts]
        private static void OnScriptReload()
        {
            var windows = Resources.FindObjectsOfTypeAll(typeof(RolePreviewWindow));
            foreach (var window in windows)
            {
                try
                {
                    ((RolePreviewWindow)window).OnDisable();
                    ((RolePreviewWindow)window).OnEnable();
                }
                catch
                {
                    DestroyImmediate(window);
                }
            }
        }

        public enum SearchTreeType
        {
            None,
            RoleCfg,
            FashionCfg,
        }

        public enum SexType
        {
            Man = 2,
            Woman = 1,
        }

        public enum HandWeaponType
        {
            Right = 1,
            Left = 2,
            Double = 3,
        }

        public enum FashionSlotType
        {
            HeadTop = 1,        // 头上
            HeadMiddle = 2,     // 头中
            HeadBottom = 3,     // 头下
            Cloth = 4,          // 衣服
            Weapon = 5,         // 武器
            BodyBack = 6,       // 背部
            HairStyle = 7,      // 发型
            Pupil = 8,          // 瞳孔
        }

        public enum SkinSlotType
        {
            HeadTop = 1,        // 头上
            HeadMiddle = 2,     // 头中
            HeadBottom = 3,     // 头下
            Cloth = 4,          // 衣服
            LeftHand = 5,       // 左手
            RightHand = 6,      // 右手
            BodyBack = 7,       // 背部
            HairStyle = 8,      // 发型
            Pupil = 9,          // 瞳孔
            HairColor = 101,    // 头发颜色
            Face = 1000,        // 脸型
        }

        public enum RoleInEnvType
        {
            Battle = 1,
            GuildLobby = 2,
            CreateRole = 3,
            RoleMainView = 4,
            Transfer = 5,
        }


        public struct RoleCfgData
        {
            public int id;
            public string name;
            public int avatarId;
            public SexType sex;
            public int leftWeaponId;
            public int rightWeaponId;
            public int clothId;
            public int hairId;
            public int eyeId;
            public int headTopId;
            public int headMiddleId;
            public int headBottomId;
            public int bodyBackId;
            public string battleCtrl;
            public string cityCtrl;
            public string createShowCtrl;
            public string roleShowCtrl;
            public string transferShowCtrl;
        }

        public struct FashionCfgData
        {
            public int id;
            public string name;
            public int avatarId;
            public int extAvatarId;
            public bool hideHair;
            public FashionSlotType fashionSlotType;
        }

        public struct RoleAvatarCfgData
        {
            public int id;
            public string avatarPrefab;
            public Vector3? position;
            public Quaternion? quaternion;
            public Vector3? scale;
        }

        public struct AvatarCfgData
        {
            public int id;
            public string avatarPrefab;
        }

        public class PopupData
        {
            private List<string> m_NameLs = new List<string>();
            private List<int> m_IdLs = new List<int>();
            public string[] names;
            public int[] ids;

            public void Add(string name, int id)
            {
                m_NameLs.Add(name);
                m_IdLs.Add(id);
            }

            public void Normalize()
            {
                names = m_NameLs.ToArray();
                ids = m_IdLs.ToArray();
                m_NameLs.Clear();
                m_IdLs.Clear();
            }
        }

        private const string c_GlobalCfgPath = "Assets/Content/Config/GlobalCfg.csv";
        private const string c_RoleCfgPath = "Assets/Lua/Config/RoleCfg.lua";
        private const string c_FashionCfgPath = "Assets/Lua/Config/FashionCfg.lua";
        private const string c_RoleAvatarCfgPath = "Assets/Lua/Config/RoleAvatarCfg.lua";
        private const string c_AvatarCfgPath = "Assets/Lua/Config/AvatarCfg.lua";
        private const string c_LanguagePackagePath = "Assets/Content/Config/LanguagePackage_cn.csv";

        private bool m_Inited = false;
        private string m_DefaultMaleBaseAvatarPrefab = "";
        private string m_DefaultFemaleBaseAvatarPrefab = "";
        private int m_DefaultMaleFaceAvatarId = -1;
        private int m_DefaultFemaleFaceAvatarId = -1;
        private Dictionary<int, RoleCfgData> m_RoleCfgMap = new Dictionary<int, RoleCfgData>();
        private Dictionary<int, FashionCfgData> m_FashionCfgMap = new Dictionary<int, FashionCfgData>();
        private Dictionary<int, RoleAvatarCfgData> m_RoleAvatarCfgMap = new Dictionary<int, RoleAvatarCfgData>();
        private Dictionary<int, AvatarCfgData> m_AvatarCfgMap = new Dictionary<int, AvatarCfgData>();
        private Dictionary<string, string> m_LanguageMap = new Dictionary<string, string>();

        private List<SearchTreeEntry> m_RoleCfgSearchTree = new List<SearchTreeEntry>();
        private Dictionary<FashionSlotType, List<SearchTreeEntry>> m_FashionCfgSearchTree = new Dictionary<FashionSlotType, List<SearchTreeEntry>>();
        private SearchTreeType m_SearchTreeType = SearchTreeType.None;
        private FashionSlotType m_SearchTreeFashionSlotType = FashionSlotType.HeadTop;

        private int m_CurrentRoleCfgId = -1;
        private RoleInEnvType m_CurrentRoleInEnvType = RoleInEnvType.Battle;
        private Dictionary<FashionSlotType, int> m_EquipFashionMap = new Dictionary<FashionSlotType, int>();

        private Dictionary<FashionSlotType, string> m_FashionSlotTypeNameMap = new Dictionary<FashionSlotType, string>()
        {
            [FashionSlotType.HeadTop] = "头上",
            [FashionSlotType.HeadMiddle] = "头中",
            [FashionSlotType.HeadBottom] = "头下",
            [FashionSlotType.Cloth] = "衣服",
            [FashionSlotType.Weapon] = "武器",
            [FashionSlotType.BodyBack] = "背部",
            [FashionSlotType.HairStyle] = "发型",
            [FashionSlotType.Pupil] = "瞳孔",
        };

        private Dictionary<FashionSlotType, SkinSlotType> m_FashionSlotToSkinSlotMap = new Dictionary<FashionSlotType, SkinSlotType>()
        {
            [FashionSlotType.HeadTop] = SkinSlotType.HeadTop,
            [FashionSlotType.HeadMiddle] = SkinSlotType.HeadMiddle,
            [FashionSlotType.HeadBottom] = SkinSlotType.HeadBottom,
            [FashionSlotType.Cloth] = SkinSlotType.Cloth,
            [FashionSlotType.BodyBack] = SkinSlotType.BodyBack,
            [FashionSlotType.HairStyle] = SkinSlotType.HairStyle,
            [FashionSlotType.Pupil] = SkinSlotType.Pupil,
        };

        private Dictionary<SkinSlotType, string> m_SkinSlotBindBone = new Dictionary<SkinSlotType, string>()
        {
            [SkinSlotType.HeadTop] = "Head_Point",
            [SkinSlotType.HeadMiddle] = "Head_Point",
            [SkinSlotType.HeadBottom] = "Head_Point",
            [SkinSlotType.Cloth] = "Bip001 Spine1",
            [SkinSlotType.LeftHand] = "LHand_Point",
            [SkinSlotType.RightHand] = "RHand_Point",
            [SkinSlotType.BodyBack] = "Back_Point",
            [SkinSlotType.HairStyle] = "Bip001 Head",
            [SkinSlotType.Pupil] = "Bip001 Head",
        };

        private GameObject m_CurrentGo;
        private Dictionary<string, Transform> m_CurrentGoBoneMap = new Dictionary<string, Transform>();
        private Dictionary<SkinSlotType, List<Renderer>> m_BaseSkinSlotTypeMap = new Dictionary<SkinSlotType, List<Renderer>>();
        private Dictionary<SkinSlotType, List<Renderer>> m_ExtSkinSlotTypeMap = new Dictionary<SkinSlotType, List<Renderer>>();

        private void OnEnable()
        {
            InitConfig();
            CompilationPipeline.assemblyCompilationStarted += OnAssemblyCompilationStarted;
            CompilationPipeline.assemblyCompilationFinished += OnAssemblyCompilationFinished;
        }

        private void OnDisable()
        {
            CompilationPipeline.assemblyCompilationStarted -= OnAssemblyCompilationStarted;
            CompilationPipeline.assemblyCompilationFinished -= OnAssemblyCompilationFinished;
            DisposeModel();
            m_CurrentRoleCfgId = -1;
            m_CurrentRoleInEnvType = RoleInEnvType.Battle;
            m_Inited = false;
        }

        private void OnFocus()
        {
            if (m_CurrentGo)
            {
                Selection.activeObject = m_CurrentGo;
            }
        }

        private void OnAssemblyCompilationStarted(string path)
        {
            if (path.EndsWith("Assembly-CSharp-Editor.dll"))
                DisposeModel();
        }

        private void OnAssemblyCompilationFinished(string path, CompilerMessage[] messages)
        {
            if (path.EndsWith("Assembly-CSharp-Editor.dll"))
                CreateModel();
        }

        private void OnGUI()
        {
            if (!m_Inited)
            {
                GUILayout.FlexibleSpace();
                EditorGUILayout.HelpBox("配置初始化失败，请检查相关配置", MessageType.Error);
                GUILayout.FlexibleSpace();
                return;
            }

            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("当前角色的使用环境", GUILayout.MaxWidth(100));
            var newRoleInEnvType = (RoleInEnvType)EditorGUILayout.EnumPopup(m_CurrentRoleInEnvType);
            if (newRoleInEnvType != m_CurrentRoleInEnvType)
            {
                m_CurrentRoleInEnvType = newRoleInEnvType;
                RefreshAnimator();
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("选择角色基础模型", GUILayout.MaxWidth(100));
            string roleCfgName = "无";
            if (m_RoleCfgMap.ContainsKey(m_CurrentRoleCfgId))
            {
                roleCfgName = m_RoleCfgMap[m_CurrentRoleCfgId].name;
            }
            GUIContent content = EditorGUIUtility.TrTempContent(roleCfgName);
            GUIStyle style = "MiniPullDown";
            Rect rect = GUILayoutUtility.GetRect(content, style);
            if (EditorGUI.DropdownButton(rect, content, FocusType.Passive, style))
            {
                OpenSearchWindw(EditorGUIUtility.GUIToScreenPoint(new Vector2(rect.xMin, rect.yMax)), SearchTreeType.RoleCfg);
            }
            EditorGUILayout.EndHorizontal();

            EditorGUI.BeginDisabledGroup(!m_RoleCfgMap.ContainsKey(m_CurrentRoleCfgId));

            EditorGUILayout.Separator();
            for (FashionSlotType fashionSlotType = FashionSlotType.HeadTop; fashionSlotType <= FashionSlotType.Pupil; fashionSlotType++)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("选择 " + m_FashionSlotTypeNameMap[fashionSlotType] + " 时装", GUILayout.MaxWidth(100));
                string fashionCfgName = "无";
                if (m_EquipFashionMap.ContainsKey(fashionSlotType))
                {
                    int id = m_EquipFashionMap[fashionSlotType];
                    if (m_FashionCfgMap.ContainsKey(id))
                    {
                        fashionCfgName = m_FashionCfgMap[id].name;
                    }
                }
                content = EditorGUIUtility.TrTempContent(fashionCfgName);
                rect = GUILayoutUtility.GetRect(content, style);
                if (EditorGUI.DropdownButton(rect, content, FocusType.Passive, style))
                {
                    OpenSearchWindw(EditorGUIUtility.GUIToScreenPoint(new Vector2(rect.xMin, rect.yMax)), SearchTreeType.FashionCfg, fashionSlotType);
                }
                EditorGUILayout.EndHorizontal();
                EditorGUILayout.Space();
            }
            EditorGUILayout.Separator();

            EditorGUI.EndDisabledGroup();
        }


        #region Init Config

        private void InitConfig()
        {
            ShowNotification(EditorGUIUtility.TrTempContent("读取配置中"));
            m_Inited = false;
            m_DefaultMaleFaceAvatarId = -1;
            m_DefaultFemaleFaceAvatarId = -1;
            m_RoleCfgMap.Clear();
            m_FashionCfgMap.Clear();
            m_RoleAvatarCfgMap.Clear();
            m_AvatarCfgMap.Clear();
            m_LanguageMap.Clear();
            try
            {
                TextAsset textAsset = AssetDatabase.LoadAssetAtPath<TextAsset>(c_LanguagePackagePath);
                string text = textAsset.text;
                string[] lines = text.Split('\n');
                for (int i = 3, iMax = lines.Length; i < iMax; i++)
                {
                    string line = lines[i];
                    if (string.IsNullOrEmpty(line)) continue;
                    string[] values = line.Split(',');
                    if (values.Length < 2) continue;
                    if (string.IsNullOrEmpty(values[0])) continue;
                    if (m_LanguageMap.ContainsKey(values[0]))
                    {
                        Debug.LogError(c_LanguagePackagePath + "存在相同的Id ：" + values[0]);
                        continue;
                    }
                    m_LanguageMap.Add(values[0], values[1]);
                }

                textAsset = AssetDatabase.LoadAssetAtPath<TextAsset>(c_GlobalCfgPath);
                text = textAsset.text;
                lines = text.Split('\n');
                for (int i = 3, iMax = lines.Length; i < iMax; i++)
                {
                    string line = lines[i];
                    if (string.IsNullOrEmpty(line)) continue;
                    string[] values = line.Split(',');
                    if (values.Length < 5) continue;
                    if (string.IsNullOrEmpty(values[0])) continue;
                    switch (values[0])
                    {
                        case "42":
                            int.TryParse(values[2], out m_DefaultMaleFaceAvatarId);
                            break;
                        case "43":
                            int.TryParse(values[2], out m_DefaultFemaleFaceAvatarId);
                            break;
                        case "44":
                            m_DefaultMaleBaseAvatarPrefab = values[3];
                            break;
                        case "45":
                            m_DefaultFemaleBaseAvatarPrefab = values[3];
                            break;
                    }
                }

                using (LuaState luaState = new LuaState())
                {
                    try
                    {
                        luaState.Start();
                        // LuaForEach<int, LuaTable>(luaState, c_GlobalCfgPath, InitFaceConfig);
                        LuaForEach<int, LuaTable>(luaState, c_RoleCfgPath, InitRoleConfig);
                        LuaForEach<int, LuaTable>(luaState, c_FashionCfgPath, InitFashionConfig);
                        LuaForEach<int, LuaTable>(luaState, c_RoleAvatarCfgPath, InitRoleAvatarConfig);
                        LuaForEach<int, LuaTable>(luaState, c_AvatarCfgPath, InitAvatarConfig);
                        m_Inited = true;
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

            m_RoleCfgSearchTree.Clear();
            List<int> m_ManIds = new List<int>();
            List<int> m_WomanIds = new List<int>();
            foreach (var item in m_RoleCfgMap)
            {
                if (item.Value.sex == SexType.Man)
                {
                    m_ManIds.Add(item.Key);
                }
                else
                {
                    m_WomanIds.Add(item.Key);
                }
            }
            m_ManIds.Sort();
            m_WomanIds.Sort();
            int level = 0;
            SearchTreeGroupEntry rootEntry = new SearchTreeGroupEntry(new GUIContent("性别"), level);
            m_RoleCfgSearchTree.Add(rootEntry);
            level++;
            SearchTreeGroupEntry manEntry = new SearchTreeGroupEntry(new GUIContent("男"), level);
            manEntry.userData = SexType.Man;
            m_RoleCfgSearchTree.Add(manEntry);
            level++;
            for (int i = 0, iMax = m_ManIds.Count; i < iMax; i++)
            {
                int id = m_ManIds[i];
                SearchTreeEntry itemEntry = new SearchTreeEntry(new GUIContent(m_RoleCfgMap[id].name));
                itemEntry.level = level;
                itemEntry.userData = m_RoleCfgMap[id];
                m_RoleCfgSearchTree.Add(itemEntry);
            }
            level--;
            SearchTreeGroupEntry womanEntry = new SearchTreeGroupEntry(new GUIContent("女"), level);
            level++;
            m_RoleCfgSearchTree.Add(womanEntry);
            for (int i = 0, iMax = m_WomanIds.Count; i < iMax; i++)
            {
                int id = m_WomanIds[i];
                SearchTreeEntry itemEntry = new SearchTreeEntry(new GUIContent(m_RoleCfgMap[id].name));
                itemEntry.userData = m_RoleCfgMap[id];
                itemEntry.level = level;
                m_RoleCfgSearchTree.Add(itemEntry);
            }
            level--;
            level--;
            Dictionary<FashionSlotType, List<int>> dic = new Dictionary<FashionSlotType, List<int>>();
            foreach (var item in m_FashionCfgMap)
            {
                List<int> ls;
                if (!dic.TryGetValue(item.Value.fashionSlotType, out ls))
                {
                    ls = new List<int>();
                    dic.Add(item.Value.fashionSlotType, ls);
                }
                ls.Add(item.Key);
            }

            level = 0;
            m_FashionCfgSearchTree.Clear();
            for (FashionSlotType fashionSlotType = FashionSlotType.HeadTop; fashionSlotType <= FashionSlotType.Pupil; fashionSlotType++)
            {
                List<SearchTreeEntry> ls = new List<SearchTreeEntry>();
                SearchTreeGroupEntry groupEntry = new SearchTreeGroupEntry(new GUIContent(m_FashionSlotTypeNameMap[fashionSlotType]), level);
                groupEntry.userData = fashionSlotType;
                ls.Add(groupEntry);
                level++;
                SearchTreeEntry nullEntry = new SearchTreeEntry(new GUIContent("空"));
                nullEntry.level = level;
                nullEntry.userData = fashionSlotType;
                ls.Add(nullEntry);
                if (dic.ContainsKey(fashionSlotType))
                {
                    List<int> ids = dic[fashionSlotType];
                    ids.Sort();
                    for (int i = 0, iMax = ids.Count; i < iMax; i++)
                    {
                        int id = ids[i];
                        SearchTreeEntry itemEntry = new SearchTreeEntry(new GUIContent(m_FashionCfgMap[id].name));
                        itemEntry.userData = m_FashionCfgMap[id];
                        itemEntry.level = level;
                        ls.Add(itemEntry);
                    }
                }
                m_FashionCfgSearchTree.Add(fashionSlotType, ls);
                level--;
            }

            RemoveNotification();
        }

        private void InitFaceConfig(int key, LuaTable value)
        {
            if (key == 42)
            {
                m_DefaultMaleFaceAvatarId = value.RawGet<string, int>("IVal");
            }
            else if (key == 43)
            {
                m_DefaultFemaleFaceAvatarId = value.RawGet<string, int>("IVal");
            }
            else if (key == 44)
            {
                m_DefaultMaleBaseAvatarPrefab = value.RawGet<string, string>("SVal");
            }
            else if (key == 45)
            {
                m_DefaultFemaleBaseAvatarPrefab = value.RawGet<string, string>("SVal");
            }
        }
        private void InitRoleConfig(int key, LuaTable value)
        {
            if (m_RoleCfgMap.ContainsKey(key))
            {
                Debug.LogError(c_RoleCfgPath + "存在相同的Id ：" + key);
                return;
            }
            RoleCfgData roleCfgData = new RoleCfgData()
            {
                id = key,
                name = value.RawGet<string, string>("Name"),
                avatarId = value.RawGet<string, int>("AvatarId"),
                sex = (SexType)value.RawGet<string, int>("Sex"),
                leftWeaponId = value.RawGet<string, int>("LeftWeapon"),
                rightWeaponId = value.RawGet<string, int>("RightWeapon"),
                clothId = value.RawGet<string, int>("ClothId"),
                hairId = value.RawGet<string, int>("Hair"),
                eyeId = value.RawGet<string, int>("Eye"),
                headTopId = value.RawGet<string, int>("HeadTop"),
                headMiddleId = value.RawGet<string, int>("HeadMiddle"),
                headBottomId = value.RawGet<string, int>("HeadBottom"),
                bodyBackId = value.RawGet<string, int>("BodyBackId"),
                battleCtrl = value.RawGet<string, string>("BattleCtrl"),
                cityCtrl = value.RawGet<string, string>("CityCtrl"),
                createShowCtrl = value.RawGet<string, string>("CreateShowCtrl"),
                roleShowCtrl = value.RawGet<string, string>("RoleShowCtrl"),
                transferShowCtrl = value.RawGet<string, string>("TransferShowCtrl"),
            };
            if (m_LanguageMap.ContainsKey(roleCfgData.name))
            {
                roleCfgData.name = roleCfgData.id + "  (" + m_LanguageMap[roleCfgData.name] + ")";
            }
            else
            {
                roleCfgData.name = roleCfgData.id + "  (" + roleCfgData.name + ")";
            }
            m_RoleCfgMap.Add(key, roleCfgData);
        }
        private void InitFashionConfig(int key, LuaTable value)
        {
            if (m_FashionCfgMap.ContainsKey(key))
            {
                Debug.LogError(c_FashionCfgPath + "存在相同的Id ：" + key);
                return;
            }
            FashionCfgData fashionCfgData = new FashionCfgData()
            {
                id = key,
                name = value.RawGet<string, string>("FashionName"),
                avatarId = value.RawGet<string, int>("RoleAvatarID"),
                extAvatarId = value.RawGet<string, int>("ExtRoleAvatarID"),
                hideHair = value.RawGet<string, bool>("FashionHideHair"),
                fashionSlotType = (FashionSlotType)value.RawGet<string, int>("FashionLocation"),
            };
            if (m_LanguageMap.ContainsKey(fashionCfgData.name))
            {
                fashionCfgData.name = fashionCfgData.id + "  (" + m_LanguageMap[fashionCfgData.name] + ")";
            }
            else
            {
                fashionCfgData.name = fashionCfgData.id + "  (" + fashionCfgData.name + ")";
            }
            m_FashionCfgMap.Add(key, fashionCfgData);
        }
        private void InitRoleAvatarConfig(int key, LuaTable value)
        {
            if (m_RoleAvatarCfgMap.ContainsKey(key))
            {
                Debug.LogError(c_RoleAvatarCfgPath + "存在相同的Id ：" + key);
                return;
            }
            RoleAvatarCfgData roleAvatarCfgData = new RoleAvatarCfgData()
            {
                id = key,
                avatarPrefab = value.RawGet<string, string>("AvatarPrefab"),
            };
            LuaTable childValue = value.RawGet<string, LuaTable>("ModelPosition");
            if (childValue != null)
                roleAvatarCfgData.position = LuaTableToVector3(childValue);
            childValue = value.RawGet<string, LuaTable>("ModelRotation");
            if (childValue != null)
                roleAvatarCfgData.quaternion = Quaternion.Euler(LuaTableToVector3(childValue));
            childValue = value.RawGet<string, LuaTable>("ModelScale");
            if (childValue != null)
                roleAvatarCfgData.scale = LuaTableToVector3(childValue);

            m_RoleAvatarCfgMap.Add(key, roleAvatarCfgData);
        }

        private void InitAvatarConfig(int key, LuaTable value)
        {
            if (m_AvatarCfgMap.ContainsKey(key))
            {
                Debug.LogError(c_AvatarCfgPath + "存在相同的Id ：" + key);
                return;
            }
            AvatarCfgData avatarCfgData = new AvatarCfgData()
            {
                id = key,
                avatarPrefab = value.RawGet<string, string>("AvatarPrefab"),
            };
            m_AvatarCfgMap.Add(key, avatarCfgData);
        }

        private void InitLanguagePackage(string key, LuaTable value)
        {
            if (m_LanguageMap.ContainsKey(key))
            {
                Debug.LogError(c_LanguagePackagePath + "存在相同的Id ：" + key);
                return;
            }
            string language = value.RawGet<string, string>("Language");
            m_LanguageMap.Add(key, language);
        }

        private void LuaForEach<K, V>(LuaState luaState, string luaFile, Action<K, V> foreachFun)
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

        private Vector3 LuaTableToVector3(LuaTable luaArrayTable)
        {
            Vector3 value = Vector3.zero;
            value.x = ((luaArrayTable[1] != null) ? (luaArrayTable.RawGetIndex<float>(1)) : 0);
            value.y = ((luaArrayTable[2] != null) ? (luaArrayTable.RawGetIndex<float>(2)) : 0);
            value.z = ((luaArrayTable[3] != null) ? (luaArrayTable.RawGetIndex<float>(3)) : 0);
            return value;
        }

        #endregion

        #region Search Windw
        private void OpenSearchWindw(Vector2 alginPos, SearchTreeType searchTreeType, FashionSlotType fashionSlotType = FashionSlotType.HeadTop)
        {
            m_SearchTreeType = searchTreeType;
            m_SearchTreeFashionSlotType = fashionSlotType;
            if (m_SearchTreeType == SearchTreeType.None) return;
            SearchWindowContext context = new SearchWindowContext(alginPos + new Vector2(120, 16));
            SearchWindow.Open(context, this);
        }

        #region ISearchWindowProvider
        public List<SearchTreeEntry> CreateSearchTree(SearchWindowContext context)
        {
            if (m_SearchTreeType == SearchTreeType.RoleCfg)
            {
                return m_RoleCfgSearchTree;
            }
            if (m_SearchTreeType == SearchTreeType.FashionCfg)
            {
                return m_FashionCfgSearchTree[m_SearchTreeFashionSlotType];
            }
            return null;
        }

        public bool OnSelectEntry(SearchTreeEntry SearchTreeEntry, SearchWindowContext context)
        {
            if (m_SearchTreeType == SearchTreeType.RoleCfg)
            {
                if (SearchTreeEntry.userData == null)
                {
                    if (m_CurrentRoleCfgId != -1)
                    {
                        m_CurrentRoleCfgId = -1;
                        m_EquipFashionMap.Clear();
                        CreateModel();
                    }
                }
                else
                {
                    RoleCfgData roleCfgData = (RoleCfgData)SearchTreeEntry.userData;
                    int id = roleCfgData.id;
                    if (m_CurrentRoleCfgId != id)
                    {
                        m_CurrentRoleCfgId = id;
                        m_EquipFashionMap.Clear();
                        CreateModel();
                    }
                }
            }
            else if (m_SearchTreeType == SearchTreeType.FashionCfg)
            {
                if (SearchTreeEntry.userData is FashionSlotType)
                {
                    m_EquipFashionMap.Remove((FashionSlotType)SearchTreeEntry.userData);
                    RefreshModel();
                }
                else
                {
                    FashionCfgData fashionCfgData = (FashionCfgData)SearchTreeEntry.userData;
                    if (m_EquipFashionMap.ContainsKey(fashionCfgData.fashionSlotType))
                    {
                        if (m_EquipFashionMap[fashionCfgData.fashionSlotType] != fashionCfgData.id)
                        {
                            m_EquipFashionMap[fashionCfgData.fashionSlotType] = fashionCfgData.id;
                            RefreshModel();
                        }
                    }
                    else
                    {
                        m_EquipFashionMap.Add(fashionCfgData.fashionSlotType, fashionCfgData.id);
                        RefreshModel();
                    }
                }
            }
            m_SearchTreeType = SearchTreeType.None;
            Repaint();
            return true;
        }
        #endregion
        #endregion

        #region Model
        private void CreateModel()
        {
            DisposeModel();
            if (!m_RoleCfgMap.ContainsKey(m_CurrentRoleCfgId)) return;
            RoleCfgData roleCfgData = m_RoleCfgMap[m_CurrentRoleCfgId];
            string avatarPrefab = ((roleCfgData.sex == SexType.Man) ? m_DefaultMaleBaseAvatarPrefab : m_DefaultFemaleBaseAvatarPrefab);
            if (string.IsNullOrEmpty(avatarPrefab)) return;
            GameObject sourceGo = AssetDatabase.LoadAssetAtPath<GameObject>(Constants.ModelPath + "/" + avatarPrefab + ".prefab");
            if (!sourceGo) return;
            m_CurrentGo = Instantiate(sourceGo);
            m_CurrentGo.transform.SetParent(null);
            m_CurrentGo.transform.localPosition = Vector3.zero;
            m_CurrentGo.transform.localRotation = Quaternion.identity;
            m_CurrentGo.transform.localScale = Vector3.one;
            BuildBoneMap(m_CurrentGo.transform.Find("Bip001"));
            // 脸
            int faceAvatarId = -1;
            faceAvatarId = ((roleCfgData.sex == SexType.Man) ? m_DefaultMaleFaceAvatarId : m_DefaultFemaleFaceAvatarId);
            if (m_RoleAvatarCfgMap.ContainsKey(faceAvatarId))
            {
                var roleAvatarCfg = m_RoleAvatarCfgMap[faceAvatarId];
                GameObject faceGo = AssetDatabase.LoadAssetAtPath<GameObject>(Constants.ModelPath + "/" + roleAvatarCfg.avatarPrefab + ".prefab");
                m_BaseSkinSlotTypeMap.Add(SkinSlotType.Face, BindGo(SkinSlotType.Face, faceGo, roleAvatarCfg.position, roleAvatarCfg.quaternion, roleAvatarCfg.scale));
            }

            RefreshAnimator();
            RefreshModel();
            RefreshPreviewGo();
        }

        private void DisposeModel()
        {
            m_CurrentGoBoneMap.Clear();
            m_BaseSkinSlotTypeMap.Clear();
            m_ExtSkinSlotTypeMap.Clear();
            if (!m_CurrentGo) return;
            GameObject.DestroyImmediate(m_CurrentGo);
            m_CurrentGo = null;
        }

        private void RefreshAnimator()
        {
            if (!m_CurrentGo) return;
            Animator animator = m_CurrentGo.GetComponent<Animator>();
            if (!animator)
            {
                animator = m_CurrentGo.AddComponent<Animator>();
            }
            RoleCfgData roleCfgData = m_RoleCfgMap[m_CurrentRoleCfgId];
            string controllerPath = null;
            if (m_CurrentRoleInEnvType == RoleInEnvType.Battle)
                controllerPath = roleCfgData.battleCtrl;
            else if (m_CurrentRoleInEnvType == RoleInEnvType.GuildLobby)
                controllerPath = roleCfgData.cityCtrl;
            else if (m_CurrentRoleInEnvType == RoleInEnvType.CreateRole)
                controllerPath = roleCfgData.createShowCtrl;
            else if (m_CurrentRoleInEnvType == RoleInEnvType.RoleMainView)
                controllerPath = roleCfgData.roleShowCtrl;
            else if (m_CurrentRoleInEnvType == RoleInEnvType.Transfer)
                controllerPath = roleCfgData.transferShowCtrl;
            if (!string.IsNullOrEmpty(controllerPath))
            {
                var controller = AssetDatabase.LoadAssetAtPath<RuntimeAnimatorController>(Constants.AnimatorPath + "/" + controllerPath + ".controller");
                if (controller)
                {
                    animator.runtimeAnimatorController = controller;
                    return;
                }
            }
            animator.runtimeAnimatorController = null;
        }

        private void RefreshModel()
        {
            if (!m_CurrentGo) return;
            RoleCfgData roleCfgData = m_RoleCfgMap[m_CurrentRoleCfgId];
            // 找是否有互斥的数据 （目前是头发）
            bool isHideHair = false;
            if (m_EquipFashionMap.ContainsKey(FashionSlotType.HeadTop))
            {
                int fashionId = m_EquipFashionMap[FashionSlotType.HeadTop];
                if (m_FashionCfgMap.ContainsKey(fashionId))
                {
                    isHideHair = m_FashionCfgMap[fashionId].hideHair;
                }
            }

            for (FashionSlotType fashionSlotType = FashionSlotType.HeadTop; fashionSlotType <= FashionSlotType.Pupil; fashionSlotType++)
            {
                int avatarId = 0;
                if (fashionSlotType == FashionSlotType.Weapon)
                {
                    RemoveSkinSlotType(m_BaseSkinSlotTypeMap, SkinSlotType.LeftHand);
                    RemoveSkinSlotType(m_BaseSkinSlotTypeMap, SkinSlotType.RightHand);
                    if (roleCfgData.leftWeaponId != 0)
                    {
                        if (m_EquipFashionMap.ContainsKey(fashionSlotType))
                        {
                            int fashionId = m_EquipFashionMap[fashionSlotType];
                            if (m_FashionCfgMap.ContainsKey(fashionId))
                            {
                                avatarId = m_FashionCfgMap[fashionId].avatarId;
                            }
                        }
                        if (avatarId == 0)
                        {
                            avatarId = roleCfgData.leftWeaponId;
                        }
                        if (m_RoleAvatarCfgMap.ContainsKey(avatarId))
                        {
                            var roleAvatarCfg = m_RoleAvatarCfgMap[avatarId];
                            GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(Constants.ModelPath + "/" + roleAvatarCfg.avatarPrefab + ".prefab");
                            m_BaseSkinSlotTypeMap.Add(SkinSlotType.LeftHand, BindGo(SkinSlotType.LeftHand, go, roleAvatarCfg.position, roleAvatarCfg.quaternion, roleAvatarCfg.scale));
                        }
                    }
                    avatarId = 0;
                    if (roleCfgData.rightWeaponId != 0)
                    {
                        if (m_EquipFashionMap.ContainsKey(fashionSlotType))
                        {
                            int fashionId = m_EquipFashionMap[fashionSlotType];
                            if (m_FashionCfgMap.ContainsKey(fashionId))
                            {
                                avatarId = m_FashionCfgMap[fashionId].extAvatarId;
                            }
                        }
                        if (avatarId == 0)
                        {
                            avatarId = roleCfgData.rightWeaponId;
                        }
                        if (m_RoleAvatarCfgMap.ContainsKey(avatarId))
                        {
                            var roleAvatarCfg = m_RoleAvatarCfgMap[avatarId];
                            GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(Constants.ModelPath + "/" + roleAvatarCfg.avatarPrefab + ".prefab");
                            m_BaseSkinSlotTypeMap.Add(SkinSlotType.RightHand, BindGo(SkinSlotType.RightHand, go, roleAvatarCfg.position, roleAvatarCfg.quaternion, roleAvatarCfg.scale));
                        }
                    }
                }
                else
                {
                    if (m_EquipFashionMap.ContainsKey(fashionSlotType))
                    {
                        int fashionId = m_EquipFashionMap[fashionSlotType];
                        if (m_FashionCfgMap.ContainsKey(fashionId))
                        {
                            avatarId = m_FashionCfgMap[fashionId].avatarId;
                        }
                    }
                    if (avatarId == 0)
                    {
                        avatarId = GetDefaultAvatarId(roleCfgData, fashionSlotType);
                    }
                    SkinSlotType skinSlotType = m_FashionSlotToSkinSlotMap[fashionSlotType];
                    if (skinSlotType == SkinSlotType.HairStyle && isHideHair)
                    {
                        avatarId = 0;
                    }
                    RemoveSkinSlotType(m_BaseSkinSlotTypeMap, skinSlotType);
                    if (m_RoleAvatarCfgMap.ContainsKey(avatarId))
                    {
                        var roleAvatarCfg = m_RoleAvatarCfgMap[avatarId];
                        GameObject go = AssetDatabase.LoadAssetAtPath<GameObject>(Constants.ModelPath + "/" + roleAvatarCfg.avatarPrefab + ".prefab");
                        m_BaseSkinSlotTypeMap.Add(skinSlotType, BindGo(skinSlotType, go, roleAvatarCfg.position, roleAvatarCfg.quaternion, roleAvatarCfg.scale));
                    }
                }
            }
        }

        private void RemoveSkinSlotType(Dictionary<SkinSlotType, List<Renderer>> map, SkinSlotType skinSlotType)
        {
            if (map.ContainsKey(skinSlotType))
            {
                if (map[skinSlotType] != null)
                {
                    foreach (var item in map[skinSlotType])
                    {
                        GameObject.DestroyImmediate(item.gameObject);
                    }
                }
                map.Remove(skinSlotType);
            }
        }

        private int GetDefaultAvatarId(RoleCfgData roleCfgData, FashionSlotType fashionSlotType)
        {
            if (fashionSlotType == FashionSlotType.HeadTop)
                return roleCfgData.headTopId;
            else if (fashionSlotType == FashionSlotType.HeadMiddle)
                return roleCfgData.headMiddleId;
            else if (fashionSlotType == FashionSlotType.HeadBottom)
                return roleCfgData.headBottomId;
            // else if (fashionSlotType == FashionSlotType.Weapon)
            //     return roleCfgData.leftWeaponId;
            else if (fashionSlotType == FashionSlotType.Cloth)
                return roleCfgData.clothId;
            else if (fashionSlotType == FashionSlotType.BodyBack)
                return roleCfgData.bodyBackId;
            else if (fashionSlotType == FashionSlotType.HairStyle)
                return roleCfgData.hairId;
            else if (fashionSlotType == FashionSlotType.Pupil)
                return roleCfgData.eyeId;
            return 0;
        }

        private List<Renderer> BindGo(SkinSlotType skinSlotType, GameObject go, Vector3? pos, Quaternion? quaternion, Vector3? scale)
        {
            if (!m_CurrentGo) return null;
            if (!go) return null;
            bool needDestroy = true;
            var sourceTrans = go.transform;
            go = GameObject.Instantiate(go);
            var trans = go.transform;
            Transform parentTrans = null;
            if (m_SkinSlotBindBone.ContainsKey(skinSlotType))
            {
                if (m_CurrentGoBoneMap.ContainsKey(m_SkinSlotBindBone[skinSlotType]))
                {
                    parentTrans = m_CurrentGoBoneMap[m_SkinSlotBindBone[skinSlotType]];
                }
                else
                {
                    parentTrans = m_CurrentGo.transform;
                }
            }
            else
            {
                parentTrans = m_CurrentGo.transform;
            }
            trans.SetParent(parentTrans);
            trans.localPosition = ((pos.HasValue) ? pos.Value : sourceTrans.localPosition);
            trans.localRotation = ((quaternion.HasValue) ? quaternion.Value : sourceTrans.localRotation);
            trans.localScale = ((scale.HasValue) ? scale.Value : sourceTrans.localScale);

            Renderer[] renderers = go.GetComponentsInChildren<Renderer>();
            List<Renderer> ls = new List<Renderer>();
            foreach (var renderer in renderers)
            {
                var mrTrans = renderer.transform;
                if (mrTrans == trans)
                {
                    needDestroy = false;
                }
                if (renderer is SkinnedMeshRenderer)
                {
                    mrTrans.SetParent(m_CurrentGo.transform);
                    ls.Add(BindSMR(renderer as SkinnedMeshRenderer));
                }
                else
                {
                    mrTrans.SetParent(parentTrans);
                    mrTrans.gameObject.layer = m_CurrentGo.layer;
                    ls.Add(renderer);
                }
            }
            if (needDestroy)
            {
                GameObject.DestroyImmediate(go);
            }

            return ls;
        }

        private SkinnedMeshRenderer BindSMR(SkinnedMeshRenderer smr)
        {
            smr.transform.SetParent(m_CurrentGo.transform);
            smr.transform.localPosition = Vector3.zero;
            smr.transform.localRotation = Quaternion.identity;
            smr.transform.localScale = Vector3.one;
            smr.gameObject.layer = m_CurrentGo.layer;
            var rootBone = smr.rootBone;
            if (rootBone)
            {
                if (m_CurrentGoBoneMap.ContainsKey(rootBone.name))
                {
                    smr.rootBone = m_CurrentGoBoneMap[rootBone.name];
                }
                else
                {
                    smr.rootBone = null;
                }
            }
            Transform[] bones = smr.bones;
            for (int i = 0, iMax = bones.Length; i < iMax; i++)
            {
                if (bones[i])
                {
                    if (m_CurrentGoBoneMap.ContainsKey(bones[i].name))
                    {
                        bones[i] = m_CurrentGoBoneMap[bones[i].name];
                    }
                    else
                    {
                        bones[i] = null;
                    }
                }
            }
            smr.bones = bones;
            return smr;
        }

        private void BuildBoneMap(Transform root)
        {
            if (!root) return;
            if (m_CurrentGoBoneMap.ContainsKey(root.name))
            {
                return;
            }
            m_CurrentGoBoneMap.Add(root.name, root);
            for (int i = 0, iMax = root.childCount; i < iMax; i++)
            {
                BuildBoneMap(root.GetChild(i));
            }
        }
        #endregion

        #region Preview
        private void RefreshPreviewGo()
        {
            if (!m_CurrentGo) return;
            Selection.activeObject = m_CurrentGo;
        }
        #endregion
    }
}
