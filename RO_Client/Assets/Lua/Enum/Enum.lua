local Enum = {
    SceneLoadedType = {
        Main_Scene_Loaded = 0,
        SubScene_Loaded = 1,
    },

    UIPageName = {
        UILoading = 1,
        UIMain = 2,
        UILogin = 3,
        UIBattle = 4,
        UIRoleList = 5,
        UIRolePt = 6,
        UIGM = 7,
        UIRoleMain = 8,
        UIAttrAddTips = 9,
        UIErrorTips = 10,
        UIBag = 11,
        UIItemTips = 12,
        UIEquipTips = 13,
        UIEquipList = 14,
        -- UIMainCity = 15,
        UIForge1 = 16,
        UIForgePop = 17,
        UIPOPGot = 18,
        UIBattleReward = 19,
        UIBattleBossBox = 20,

        UIEquipRefineTips = 23,

        UIRefineExtraPop = 25,
        UICardTips = 26,
        UICardListTips = 27,
        UICardList = 28,
        UICardGot = 29,
        UICardDecomposeTips = 30,
        UICardItemTips = 31,
        UICardEquipList = 32,
        UICardProduceNotice = 33,
        UICreateRole = 34,
        UIBagCardListTips = 35,
        UIChangeLine = 36,
        UIGuide = 37,
        UIPOPGotAnims = 40,
        UIPopGotSingle = 41,
        UIChipRoom = 42,
        UIChipDecomposeTips = 43,
        UIChipProduceNotice = 44,
        UIBattleWin = 45,
        UIParterGot = 46,
        UIFightPowerTips = 47,
        UIRoleMain1 = 48,
        UIRoleNaturePoint = 52,
        UIQuickBattle = 53,
        UITreasures = 55,
        UIRoleStrength = 56,
        UISettings = 57,
        UIRoleChangeJob = 59,
        UIDojo2D = 60,
        UIDojoMatch = 62,
        UIDojoBattle = 63,
        UIDojoBattleWin = 64,
        UIDojoBattleFail = 65,
        UINoticeTips = 66,
        UIDojoExit = 67,
        UIDojoReward = 68,
        UIDojoRank = 69,
        UIDojoBuyTimes = 70,
        UIMailBox = 71,
        UIMail = 72,
        UINewbieBattle = 73,
        UINewCreateRole = 74,
        UIStartLoading = 75,

        -- 世界boss
        UIWorldBossBattle = 80,
        UIWorldBossList = 81,
        UIWorldBossReward = 82,

        -- 时装界面
        UIFashion = 91,
        UIFashionTotal = 92,
        UIFashionGot = 93,
        UIFashionCompose = 94,
        UIFashionPaperTips = 95,

        UIWaiting = 100,        --网络重连界面
        UIClimbingTower = 101,
        UIClimbingTowerLevelInfo = 102,
        UIClimbingTowerFriendInfo = 103,
        UIClimbingTowerRank = 104,
        UIClimbingTowerBattle = 105,
        UIClimbingTowerBattleWin = 106, 
        UIClimbingTowerBattleFailed = 107,
        UIBattleReplay = 108,       --战报界面
        UIBattleStatistics = 109,       --战斗统计
        UIBattleBossTips = 110,         --boss简介界面
        

        -- 技能相关界面
        UISkillSettings = 111,
        UISkillPreview = 112,
        UISkillResetTips = 113,

        UIBigMap = 120,
        UIWorldMap = 121,

        -- 统一弹窗
        UISuccessTips = 131,

        UISkillExpBattle = 132,
        UISkillExpBattleBattle = 133,
        UISkillExpCost = 134,

        --2D主城
        UIMainCity1 = 140,

        UISeason = 141,
        UIChat = 142,
        UIChatPrivate = 143,
        UIPrivateChatBtn = 144,
        
        UIMinTips = 145,        --mintips
        UIFriendList = 150,     -- 好友界面
        UIActivationCodePage = 152, --激活码界面

        UIRoleMessage = 154,   --头像交互界面
        UIChangeName = 155,    --改名界面
        UIChangeHead = 156,    --改头像界面
        UINotifyTips = 158,    --服务器停服状态下弹出的公告界面
        UINotifyActivityTips = 159,--游戏内的公告界面，其中还有活动的相关内容
        UISign2 = 162,          --签到界面的动画界面
        UIForceGuide = 164,     --强引导
        UITaskNew = 165,        --新的任务界面
        UITransPerform = 166,
        UIDojoBadgeUp = 167,  --出现在主城和迅游界面的控制按钮
        UIPartnerLvUp = 168, -- 伙伴升级界面
        UISignIn = 169,         --签到界面
        UICreateName = 170,     --创建名字界面
        UIPlayRule = 171,       -- 游戏规则界面
        UIFilter = 172,       -- 筛选界面

        UICardHandBook = 173,       -- 卡片图鉴
        UICardHandBook1 = 174,
        UICardHandBook2 = 175,
        UIChangeHeadFrame = 176,

        UIExchange = 177,

        UIFuncMenu = 179,
        UIGuildLobby = 180,
        UIGuildRecommend = 181,
        UIGuildCreate = 182,
        UIGuildChangeBadge = 183,
        UIGuildInfo = 184,
        UIGuildMain = 185,
        UIGuildLog = 186,
        UIGuildAuditApply = 187,
        UIGuildSettings = 188,
        UIGuildChangeName = 189,

        UIPetRoot = 190,
        UIPetLvUp = 191,
        UIPetAttribute = 192,
        UIPetAdvence = 193,
        UIPetMats = 194,
        UIPetDecompose = 195,

        UIStory = 2000,
        UIStorySkip = 2001,
        UIStoryPlayVideo = 2002,
        UIChapter = 2003,

        UIAntiCheatMsgWnd = 2100,--加速弹窗
        UIRewardsBuyTips = 319,--高级战令购买弹窗
    },

    ParamState = {
        None = 1,
        Success = 2,
        Fail = 3,
    },

    --服务器状态
    ServerState = {
        Hot = 0,    --火爆
        Crowd = 1,  --拥挤
        Free = 2,   --空闲
        Full = 4, -- 已满
        Maintain = 5,   --维护
        Beta = 6,
    },

    --更换服务器界面页签
    ChangeServerPageType = {
        Recommend = 1, -- 推荐
        All = 2,       -- 所有
    },

    UIType = {
        Total = 0, -- 全屏窗口
        MAIN = 1, --主界面
        TotalWin = 2, --全屏弹窗
        Tips = 3, -- tips
        Normal = 4, -- 普通提示
        Story = 5, --剧情
        Global = 6, -- 全局功能界面
        Loading = 7, --loading
        System = 8, --系统提示
        Top = 9, --最上层
    },

    UISibling = {
        20,-- 全屏窗口 初始sibling
        1000,--主界面 初始sibling
        2000, --弹出全屏
        3000,-- tips 初始sibling
        4000,-- 普通提示
        5000,-- 剧情
        6000,-- 全局功能界面
        7000,-- loading
        8000,-- 系统提示
        9000,-- top 最上层的显示
    },

    --状态机
    StateEnum = {
        IdleState = {name = "Idle", stateId = 0},
        LoadingState = {name = "Loading", stateId = 1},
        LoginState = {name = "Login", stateId = 2},
        CreateRoleState = { name = "CreateRole", stateId = 3},
        BattleState = {name = "Battle", stateId = 4},
        DojoState = {name="Dojo",stateId = 5},
        BossBattleState = {name="BossBattle",stateId = 6},
        TimeBattleState = {name="TimeBattle",stateId = 7},
        GuildLobbyState = {name="GuildLobbyState",stateId = 8},
    },

    FilterType = {
        AND = 0,
        OR = 1,
    },

    HeroAttrType = {
        STR = 1,
        AGI = 2,
        INT = 3,
        VIT = 4,
        DEX = 5,
        LUK = 6,
        Life = 7,
        Sp = 8,
        Attack = 9,
        MagicAttack = 10,
        Defense = 11, 
        MagicDefense = 12,
        Hit = 13,
        Dodge = 14,
        Crit = 15,
        Ten = 16,
        AttackSpeed = 17,
        CastAcceleration = 18,
        MaxHp = 19,
        MaxSp = 20,
        RealHurt = 21,

        STR_Percent = 31,
        AGI_Percent = 32,
        INT_Percent = 33,
        VIT_Percent = 34,
        DEX_Percent = 35,
        LUK_Percent = 36,
        Life_Percent = 37,
        Sp_Percent = 38,
        Attack_Percent = 39,
        MagicAttack_Percent = 40,
        Defense_Percent = 41,
        MagicDefense_Percent = 42,
        Hit_Percent = 43,
        Dodge_Percent = 44,
        Crit_Percent = 45,
        Ten_Percent = 46,
        AttackSpeed_Percent = 47,
        CastAcceleration_Percent = 48,
        MaxHp_Percent = 49,
        MaxSp_Percent = 50,
        RealHurt_Percent = 51,

        Nature_None_Damage_Percent = 71,
        Nature_Water_Damage_Percent = 72,
        Nature_Ground_Damage_Percent = 73,
        Nature_Fire_Damage_Percent = 74,
        Nature_Wind_Damage_Percent = 75,
        Nature_Saint_Damage_Percent = 76,
        Nature_Dark_Damage_Percent = 77,
        Nature_Read_Damage_Percent = 78,

        Nature_None_AntiDamage_Percent = 81,
        Nature_Water_AntiDamage_Percent = 82,
        Nature_Ground_AntiDamage_Percent = 83,
        Nature_Fire_AntiDamage_Percent = 84,
        Nature_Wind_AntiDamage_Percent = 85,
        Nature_Saint_AntiDamage_Percent = 86,
        Nature_Dark_AntiDamage_Percent = 87,
        Nature_Read_AntiDamage_Percent = 88,

        Penetration_Percent = 91,
        Magic_Penetration_Percent = 92,
        PhysicDamage_Percent = 93,
        MagicDamage_Percent = 94,
        Anti_PhysicDamage_Percent = 95,
        Anti_MagicDamage_Percent = 96,
        CritDamage_Percent = 97,
        PhysicDamageReflect_Percent = 98,
        MagicDamageReflect_Percent = 99,
        FixedSingTime_Percent = 100,
        VariableSingTime_Percent = 101,

    },

    TypeInfo = {
        Int32 = typeof(System.Int32),
        Image = typeof(UnityEngine.UI.Image),
        RectTransform = typeof(UnityEngine.RectTransform),
        Animator = typeof(UnityEngine.Animator),
        Button = typeof(UnityEngine.UI.Button),
        Text = typeof(UnityEngine.UI.Text),
        RawImage = typeof(UnityEngine.UI.RawImage),
        Toggle = typeof(UnityEngine.UI.Toggle),
        Slider = typeof(UnityEngine.UI.Slider),
        InputField = typeof(UnityEngine.UI.InputField),
        ScrollRect = typeof(UnityEngine.UI.ScrollRect),
        CanvasGroup = typeof(UnityEngine.CanvasGroup),
        Canvas = typeof(UnityEngine.Canvas),
        DOTween = typeof(DG.Tweening.DOTween),
        GameObject = typeof(UnityEngine.GameObject),
        Transform = typeof(UnityEngine.Transform),
        Renderer = typeof(UnityEngine.Renderer),
        Graphic = typeof(UnityEngine.UI.Graphic),
        Component = typeof(UnityEngine.Component),
        LoopHorizontalScrollRect = typeof(UnityEngine.UI.LoopHorizontalScrollRect),
        LoopVerticalScrollRect = typeof(UnityEngine.UI.LoopVerticalScrollRect),
        RepeatButton = typeof(UnityEngine.UI.RepeatButton),
        CheckInputLength = typeof(CheckInputLength),
        Dropdown = typeof(UnityEngine.UI.Dropdown),
        LayoutElement = typeof(UnityEngine.UI.LayoutElement),
        GridLayoutGroup = typeof(UnityEngine.UI.GridLayoutGroup),
        VerticalLayoutGroup = typeof(UnityEngine.UI.VerticalLayoutGroup),
        HorizontalLayoutGroup = typeof(UnityEngine.UI.HorizontalLayoutGroup),
        MeshFilter = typeof(UnityEngine.MeshFilter),
        CUIPolygon = typeof(CUIPolygon),
        TextMeshProUGUI = typeof(TMPro.TextMeshProUGUI),
        UILocalizeScript = typeof(UILocalizeScript),
        ButtonTriggerAnimation = typeof(ButtonTriggerAnimation),
        UIEventHandler = typeof(UIEventHandler),
        UIJoystick = typeof(UIJoystick),
        UIEventTriggerListener = typeof(UIEventTriggerListener),
        ToggleGroup = typeof(UnityEngine.UI.ToggleGroup),
        UIDragItem = typeof(UIDragItem),
        Animation = typeof(UnityEngine.Animation),
        LoopGridView = typeof(SuperScrollView.LoopGridView),
        LoopListView = typeof(SuperScrollView.LoopListView),
        UIParticle = typeof(UIExtensions.UIParticle),
        RollingNumberText = typeof(RollingNumberText),
        Scrollbar = typeof(UnityEngine.UI.Scrollbar),
        ActorParam = typeof(ActorParam),
        BuffParam = typeof(BuffParam),
        SkillParam = typeof(SkillParam),
        HairClrParam = typeof(HairColorParam),
        BodyPartParam = typeof(BodyPartParam),
        ServerFighterParam = typeof(ServerFighterParam),
        ActorData = typeof(ActorData),
        ReorderableList = typeof(RO.ReorderableList),
        SlideHorizontalLayoutGroup = typeof(SlideHorizontalLayoutGroup),
        SlideVerticalLayoutGroup = typeof(SlideVerticalLayoutGroup),
        SwitchSprite = typeof(SwitchSprite),
        LoopScrollRectDragEventInherit = typeof(LoopScrollRectDragEventInherit),
        TMP_InputField = typeof(TMPro.TMP_InputField),
        SymbolText = typeof(WXB.SymbolText),
        ContentSizeFitter = typeof(UnityEngine.UI.ContentSizeFitter),
        SlideGridLayoutGroup = typeof(SlideGridLayoutGroup),
        UIBigMapLine = typeof(UIBigMapLine),
        UIRaycastNoDraw = typeof(UIRaycastNoDraw),
        UIGridViewMark = typeof(UIGridViewMark),
        UIPlayVideo = typeof(UIPlayVideo),
        GuideMask = typeof(GuideMask),
        SymbolTextEvent = typeof(WXB.SymbolTextEvent),
        UIEffectCfg = typeof(UIEffectCfg),
        BattleEndCondition = typeof(BattleEndCondition),
        ValType = typeof(ValType),
        SkeletonGraphic = typeof(Spine.Unity.SkeletonGraphic),
        UIImageSwitchSprite = typeof(UIImageSwitchSprite),
        RolRectTransform = typeof(RolRectTransform),
        UiLoopAutoMove = typeof(UiLoopAutoMove),
        WentingCanvasWebVewPrefab = typeof(Vuplex.WebView.WentingCanvasWebVewPrefab),
    },

    NetErrorCode = {
        ERROR_OK = 0,
        ERROR_FAIL = 1,
        ERROR_RELOGIN = 2,
        ERROR_ROLE_NOT_FOUND = 3,
        ERROR_RES_NOT_ENOUGH = 5,
        ERROR_ROLE_NOT_FOUND_NEED_ACTIVE_CODE = 11,
        ERROR_ROLE_ACTIVE_CODE_ERROR = 12,
        ERROR_ROLE_ACTIVECODE_USED = 13,
        ERROR_ROLE_BANED = 19,
        ERROR_ROLE_INVALID = 20,
        ERROR_GAME_VERSION = 24,
        ERROR_SDK_ACCOUNT_INVALID = 29,
        ERROR_SERVER_MAINAIN = 31,
        ERROR_SERVER_KICK_CHEAT = 32,
        ERROR_ROLE_CAN_NOT_REGISTER = 35,
        ERROR_CHAT_WORLD_TARGET_OFFLINE = 304,
        ERROR_GUILD_NOT_IN_GUILD = 516,
        ERROR_GUILD_IN_GUILD = 517,
        ERROR_PET_BATTLE_REPEATED = 543,
        ERROR_PAY_PRODUCTION_MODE = 661,
        ERROR_PAY_GOOD_PRICE_FREE = 662,
        ERROR_GUILDBATTLE_NOT_IN_GUILDBATTLE = 863,
        ERROR_GUILDBATTLE_CUR_BATTLE_FINISH = 864,
        ERROR_GUILDBATTLE_CUR_BATTLE_NOT_BEGIN = 865,
        ERROR_ROLE_BANED_TYPE_PERSONALCHAT = 902,
        ERROR_CROSS_YUANHANGTRIAL_REFRESH_FAILED = 2806,
    },

    FilterEleType = {
        All = 0,
        Nothing = 1,
        Water = 2,
        Earth = 3,
        Fire = 4,
        Wind = 5,
        Holy = 6,
        Dark = 7,
    },

    ItemIndex = {
        PartnerStone = 100,
    },

    ActionNotiveType = {
        AutoAttrPointLack = 100001,
        NoSuitableEquip = 100002,
        CoinLack = 100003,
        MetaLack = 100004,
        NoCanUpEquip = 100005,
        RefineSuccess = "RefineSuccess",
        RefineFailure = "RefineFailure",
        CardUnloadTips = "CardUnloadTips",
    },

    --转盘动画
    TrunWheelAniName = 
    {
	    TrunStart = "TrunStart",		--播放开始动画
	    TrunRefresh1 = "TrunRefresh1",	--播放刷新动画开始
	    TrunRefresh2 = "TrunRefresh2",	--播放刷新动画结束
    },

    --- 玩家其他资源(不放背包的资源) CfgId(道具表id)
    RoleResType = {
        HeroSpirit = 12
    },

    -- 道具类型
    ItemType = {
        Coin = 1,
        Diamond = 2,
        RoleBaseExp = 3,
        RoleJobExp = 4,
        ParterExp = 5,
        Equip = 6,
        Item = 7,
        ParterChip = 8,
        Card = 9,
        FashionPaper = 10,      
        SkillExp = 11,          --技能经验
        HeroSpirit = 12,        --英灵币
        Card_Reslove = 13,      --卡片分解
        Parter = 14,            --获取英雄
        SkillBook = 15,         --技能书
        Gift = 16,              --礼包
        EvilExp = 17,           --恶魔值
        HeadFrame = 18,         --头像框

        PetExp = 19,
        PetStone = 20,
        Pet = 21,
        Compose = 22,           --合成道具
        GuildStone = 24,        --公会币
        RecruitStone = 25,      --招募币
        VipExp = 26,            --Vip经验
        Income = 27,            --获得对应挂机时间的指定收益道具
        HundredDojoStone = 28,  --百人道场货币
        Cangpin          = 31,  --藏品
        OptionalGift = 32,      --自选礼包
        GuildCP = 33,           --公会贡献点
        GuildWarStone = 34,     --公会战货币
        VipProof = 41,          --Vip凭证
        RuneShopExploreUnlock = 42,    --飞艇解锁道具
        SkillEquipSlotMat = 44, --神器槽位材料
        PetCrystal = 45,        --宠物水晶
        PetStamp = 46,          --宠物印记
        AdvanceSkillExp = 47,   --高级技能经验
        SkillEquip = 48,        --神器类型
        TitleMaterial = 49,        --称号激活材料类型
        WishBox       = 51,         --许愿宝箱
        OptionalWishBox = 52,     --自选许愿宝箱
        LootingPrizeItem = 152,  --夺宝令
    },

    -- 道具Ids
    ItemIds = {
        Coin = 1,
        Diamond = 2,
        RoleJobExp = 4,
        ParterExp = 5,
        SkillExp = 11,
        Box = 14,
        PetExp = 19,
        HundredDojoStone = 28,
        GuildCP = 33,
        AngelTear = 100,
        Recruit = 109,
        FateClinch = 110,
        KeepSakeExchange = 31,
        Cash = 40,
        PetCrystal = 45,
        SkillEquipTransItem = 237,
        QiyueItem = 264,
    },

    -- GridViewItem的道具项 根据所在位置显示会不一样
    ItemIEnterType = {
        Bag = 1,  -- 在包裹里
        ItemTips = 2,  -- 在道具tips上
        HeroEquip = 3,  -- 英雄装备展示
        EquipForge = 4,  -- 英雄装备锻造
        EquipForgePop = 5, --装备一件锻造 预览
        Cost = 6, --消耗类型
        EquipedCard = 7, --已装备卡片
        NoEquipedCard = 8, --未装备卡片
        EquipRefine = 9, --装备精炼
        CardRecreate = 10, --卡片重置
        CardCompose = 11, --卡片合成
        CardTips = 12, --卡片tips
        FashionChange = 20, -- 换时装
        FashionBook = 21,   -- 时装图鉴
        GotAnim = 22,   --获得动画
        Treasure = 23, --寻宝
        RoleStrength = 24, --伙伴突破
        CardSelectedRecreate = 25, --卡片重置
        CardSelectedCompose = 26, --卡片合成
        Mail = 27, --邮件
        Season = 28, --赛季
        Battle = 29,
        WorldChat = 30, --世界聊天
        PrivateChat = 31, --世界聊天
        System = 32, --系统
        Attr = 33,  --tips 基础属性标记
        CostMat = 34, --tips 消耗材料标记
        Partner = 35, --伙伴

        StageGoal = 36,
        BattleWin = 37,
        PopGot = 38,

        PetRoot = 40,
        Pet = 41,
        PetMats = 42,
        PetRelation = 43,
        PetSupport = 44,
        PetQiyueMat = 45,

        EquipTips = 45,

        PetStamp = 46,

        SkillEquip = 47, --神器
    },

    SlotEquipType = {
        Head = 1,
        Body = 2,
        Weapon = 3,
        Wrap = 4,
        Shoes = 5,
        Jew = 6,
    },

    JobWeaponMap = {
      Sword = 1,
      Katar = 2,
      Bow = 3,
      Staff = 4,
      Priest = 5,
    },

    ForgeType = {
        Sword = 1,
        Katar = 2,
        Bow = 3,
        Staff = 4,
        Priest = 5,
        Head = 6,
        Body = 7,
        Wrap = 8,
        Shoes = 9,
        Jew = 10,
    },

    -- 主界面页面类型，主要用于其它页面发消息去切换主界面
    MainViewPageType = {
        Town = 1,
        Adventure = 2,
        Battle = 3,
        Role = 4,
        Pub = 5,
    },

    -- 背包页面类型，主要用于其它页面发消息去切换背包页面
    BagViewPageType = {
        Equip = 1,
        Item = 2,
        Card = 3,
        SkillEquip = 4,
    },

    BigMapEnterType = {
        Default = 1,
        DropPoint = 2,
        NextLevel = 3,
    },

    ExecuteSequenceType = {
        Func = 1,
        Listener = 2,
        UIViewFunc = 3,
        Interval = 4,
        FuncAfterListener = 5,
        UIViewFuncAfterListener = 6,
    },

    TableSortRule =
    {
        Up = true,
        Down = false,
    },

    CollectType = {
        Card = 1,
        Pet = 2,
        KeepSake = 3,
    },

    CardType = {
        NORMAL = 1,
        MINIBOSS = 2,
        MVP = 3,
    },

    CollectQualityType = {
        ALL = 1,
        NORMAL = 2,
        MINIBOSS = 3,
        MVP = 4,
    },

    EntityType = {
        MinePlayer = 0,
        OtherPlayer = 1,
    },

    -- 资源类型， 根据不同类型，提交不同的加载请求给资源加载管理器
    ResourceType = {
        GameObject = 1,
        TextAsset = 2,
        AudioClip = 3,
        VideoClip = 4,
        Texture2D = 5,
        PlayableAsset = 6,
        Material = 7,
        Sprite = 8,
        AnimatorController = 9,
        SingleSprite = 10,
        SingleGameObject = 11,
    },

    --- 时装部位类型
    FashionSlotType = {
        HeadTop = 1,        -- 头上
        HeadMiddle = 2,     -- 头中
        HeadBottom = 3,     -- 头下
        Cloth = 4,          -- 衣服
        Weapon = 5,         -- 武器
        BodyBack = 6,       -- 背部
        HairStyle = 7,      -- 发型
        Pupil = 8,          -- 瞳孔
    },

    --- 主角模型替换模型的部位类型
    SkinSlotType = {
        HeadTop = 1,        -- 头上
        HeadMiddle = 2,     -- 头中
        HeadBottom = 3,     -- 头下
        Cloth = 4,          -- 衣服
        LeftHand = 5,       -- 左手
        RightHand = 6,      -- 右手
        BodyBack = 7,       -- 背部
        HairStyle = 8,      -- 发型
        Pupil = 9,          -- 瞳孔
        HairColor = 101,    -- 头发颜色
        Face = 1000,        -- 脸型
    },

    --- 主角模型绑定骨骼位置 , 头发颜色和眼睛不绑定骨骼
    SkinSlotBindBone = {
        [1] = 'Head_Point',
        [2] = 'Head_Point',
        [3] = 'Head_Point',
        [4] = 'Bip001 Spine1',
        [5] = 'LHand_Point',
        [6] = 'RHand_Point',
        [7] = 'Back_Point',
        [8] = 'Bip001 Head',
        [9] = 'Bip001 Head',
    },

    -- 角色使用的环境
    RoleInEnvType = {
        Battle = 1,
        GuildLobby = 2,
        CreateRole = 3,
        RoleMainView = 4,
        Transfer = 5,
        FashionView = 6,
        PetLvUp = 7,
    },

    AttrChangeSource = {
        Equip = 1,
        Card = 2,
    },

    CardFuncType = {
        Recreate = 1,
        Compose = 2,
        Trans = 3,
    },

    --- 性别类型
    SexType = {
        Woman = 1,
        Man = 2,
    },

    --- 手持武器的类型
    HandWeaponType = {
        Right = 1,
        Left = 2,
        Double = 3,
    },

    PrefabNames = {
        InfoItem = "InfoItem",
        EquipItem = "IconItem",
        ItemItem = "IconItem",
        IconSmallItem = "IconSmallItem",
        ChipItem = "ChipItem",
        CardIconItem = "IconItem",
        EquipBaseAttrItem = "EquipBaseAttrItem",
        CardItem = "CardItem",
        CardSlotItem = "CardSlotItem",
        EquipSuitAttrItem = "EquipSuitAttrItem",
        CardListAttrItem = "CardListAttrItem",
        EquipRefineLvItem = "EquipRefineLvItem",
        CardAttrItem = "CardAttrItem",
        CardListEquippedItem = "CardListEquippedItem",
        CardListItem = "CardListItem",
        GotCoinItem = "GotCoinItem",
        ParterItem = "HeadItem",
        AttrTipItem = "AttrTipItem",
        EquipComposeItem = "EquipComposeItem",
        ChatTextItem = "ChatTextItem",
        PrivateChatItem = "PrivateChatItem",
        RedPointItem = "RedPointItem",
        LevelIncreaseItem = "LevelIncreaseItem",
        CardComposeItem = "CardComposeItem",
        RankShopRewardIconItem = "RankShopRewardIconItem",
    },

    RedPointEnum = {
        None = 0,
        EquipRefineRP = 1,
        EquipForgeRP = 2,
        EquipDressRP = 3,
        FashionNewRP = 4,
        SkillUnlockRP = 5,
        CardSlotRP = 6,
        RecruitRP = 7,
        RecommendRP = 8,
        CardEmptyRP = 9,
        CardLvUpRP = 10,
        SkillEquip = 11,
    },

    UIJumpType = {
      SingleUI = 1,
    },

    UIJumpParamType = {
        None = 0,
        Hero = 1,
        Partner = 2,
    },

    UIGuideSource = {
        StageGoal = 1,
    },

    HeroRPSource = {
        Main = 1,
        HeadIcon = 2,
        EquipDress = 3,
        EquipForge = 4,
    },

    TreasureConditionType = {
        Nature = 1,
        Quality = 2,
    },

    SlotBoxState = {
        None = 0,
        NoOpen = 1,
        Opened = 2,
    },

    ActivityType = {
        ACTIVITY_TYPE_FIRST_RECHARGE = 1,               --首充活动
        ACTIVITY_TYPE_DAILY_CUMULATIVE_RECHARGE = 2,    --每日累充活动
        ACTIVITY_TYPE_DAILY_RECHARGE = 3,				--每日充值
        ACTIVITY_TYPE_14_Days_LOGIN = 4,				--14日登录
        ACTIVITY_TYPE_14_Days_Task = 5,                 --14日目标任务
        ACTIVITY_TYPE_HUNDRED_Task = 6,                 --百元大礼包
        ACTIVITY_TYPE_FESTIVAL_REWARD = 7,              --双旦活动
        ACTIVITY_TYPE_SHOP = 8,                         --活动商店
        ACTIVITY_TYPE_CASH_SHOP = 9,                    --现金商店
        ACTIVITY_TYPE_GOD_DESS = 10,
        ACTIVITY_TYPE_PET_REWARD = 11,              --宠物兑换
        ACTIVITY_TYPE_KING_TASK = 12,                   --国王活动
        ACTIVITY_TYPE_SPRING_BATTLE = 0,                --踏青活动
        ACTIVITY_TYPE_61_Days = 13,                     --61 儿童节
        ACTIVITY_TYPE_SUMMON = 14,                      --限时活动召唤类型
        ACTIVITY_TYPE_SIGN = 15,                     --暑期签到活动
        ACTIVITY_TYPE_LIMIT_REWARD = 100,
    },

    --- 技能类型
    SkillType = {
        Active = 1,     -- 主动技能
        Passive = 2,    -- 被动技能
    },

    --品质类型
    QualityType = {
        Gray = 0,       --灰色
        Green = 1,      --绿色
        Blue = 2,       --蓝色
        Purple = 3,     --紫色
        Gold = 4,       --金色
        Red = 5,        --红色
    },

    TaskStateType = {
        NoCompeleted = 0,
        CompletedAndNoReceive = 1,
        Received = 2,
    },

    InvitationTaskStateType = {
        CompletedAndNoReceive = 0,
        NoCompeleted = 1,
        Received = 2,
    },

    TaskType={
        NONE = 0,
        Base_Level             = 1, --主角Base等级                  [1:主角base等级]
        Job_Level              = 2, --job等级                       [2:job等级 ]
        Job_Stage              = 3, --完成转职，对应转职阶段          [3:转职阶段]
        Hero_Level_Num         = 4, --任意N个伙伴等级达到X级          [4:X级:伙伴个数]
        Hero_LevelUp_Count     = 5, --升级任意伙伴N次                 [5:升级次数]
        Hero_Power_Num         = 6, --N个伙伴战力达到指定数值          [6:战力值:伙伴个数]
        Equip_Level_Num        = 8, --任意N件装备精炼等级达到X级       [8:x级:N件装备]
        Equip_Level_Count      = 9, --精炼任意装备N次                 [9:精炼次数]
        Equip_Forge_Count      = 10, --合成任意装备N次                 [10:合成次数]
        Level_Battle_Count       = 11, --通关指定关卡                    [11:关卡ID:关卡次数]
        Skill_Slot_Level_Up_Count = 13, --升级任意技能槽N次             [13:升级技能槽次数]
        Total_Power               = 14, --总战力达到指定数值            [14:总战力值]
        Battle_Tower_Count        = 15, --爬塔次数                     [15:爬塔次数]
        Battle_Boss_Count         = 16, --普通boss战次数                   [16:普通boss战次数]
        Remain_Skill_Point        = 17, --剩余技能点                    [17:剩余技能点]
        Role_Equip_Forge_Count    = 18, --主角全身装备精炼等级达到N      [18:角色装备精练等级]
        Part_Equip_Forge_Count    = 19, --N个伙伴装备精炼等级达到X       [19:伙伴装备精练等级]
        Role_Quick_Battle_Count   = 20, --快速战斗次数                   [20:快速战斗次数]
        Role_Use_Item_Count       = 21, --使用特定道具数量               [21:使用特定道具数量]
        Hero_Total_Num            = 22, --获得N个数量的任意伙伴          [22:获得N个数量的任意伙伴]
        Hero_Id_Level             = 23, --指定伙伴达到指定等级            [23:伙伴等级:伙伴ID]
        Battle_Boss_Reward_Count  = 24, --挑战普通boss奖励次数(关卡挑战成功次数)  [24:关卡挑战成功次数]
        
        Get_Online_Box_Count      = 25, --挂机奖励
        Arena_Battle_Start_Count  = 26, --英灵殿
        Evil_Fight_Count          = 28, --恶魔协会战斗次数
        Silver_Consumption_Count  = 30, --银币消耗
        Gold_Consumption_Count    = 31, --金币消耗
        Arena_Battle_Win_Count    = 32, --英灵殿胜利次数
        Climbing_Tower_Count      = 33, --爬塔次数
        Card_Composed_Count       = 35, --卡片合成次数
        Card_Reset_Count          = 36, --卡片重置次数
        Climbing_Tower_Level      = 37, --爬塔通过层数
        PK_Win_Count              = 38, --竞技场胜利次数
        Get_Silver_Count          = 39, --获得银币数量
        Get_Suit_Count            = 40, --累计获得时装数量
        Get_Card_Count            = 41, --累计获得卡片数量
        Eve_Card_Num                = 67,     -- 卡片抽卡累加
        Eve_Pet_Num                 = 68,     -- 宠物抽卡累加
        Eve_Fight_value             = 69,     -- 最高战力提升
        Eve_Merge_Equip             = 70,     -- 合并指定装备id
        Eve_Merge_Card              = 71,     -- 合并指定卡片

        Eve_DaoChange_Win_Add  = 87,     -- 道场累计胜利次数
        Eve_Pet_Id_Cnt  = 88,     -- 拥有指定宠物数量 （包括羁绊）
        Eve_Arean_Dan  = 89,     -- 英灵殿达到指定的段位
        Eve_Pet_Battle_Quality_cnt  = 90,     --        X个上阵的宠物装备6件X品质的宠物印记

        -- TODO:暂时服务器没有该任务，后续ID被占用，或者服务器有改类型任务，则需要通知策划修改所有的解锁ID
        VIP_Level                 = 1000, --VIP等级
        No_Pay                    = 1001,
        Pay_Total_Recharge        = 1002,

    },

    --任务跳转界面的枚举
    TaskJumpType = {
        BattlePage          = 1,    --战斗迅游界面
        RolePage            = 2,    --角色界面
        WeaponHousePage     = 3,    --武器屋
        TowerPage           = 4,    --试炼爬塔界面
        HeroPage            = 5,    --英灵殿
        AlliancePage        = 6,    --工会
        DevilAlliancePage   = 7,    --恶魔协会
        ShopPage            = 8,    --普通商店
        HeroShopPage        = 9,    --英灵殿商店
        CardHousePage       = 10,   --卡片屋
        Fashion             = 11,   --时装
        ChallengerHouse     = 12,   --挑战者大厅
        Guild               = 13,   --公会
        ActivityPage        = 14,
        TitleMaterials        = 15, --称号消耗道具类型
    },

    CompetitionName = {
        "CompetitionName1", "CompetitionName2"
    },

    UIStoryCondType = {
        PartnerGot = 1,
        FirstUIOpen = 2,
        GotGoalAward = 3,
        FirstSceneEnter = 4,
    },

    StoryType = {
        Dlg = 1,
        EnterNewMap = 2,
    },

    StoryChapterState = {
        NotStart = 0,
        Start = 1,
        End = 2,
    },

    -- 剧情小节的事件类型
    StorySectionEventType = {
        UnlockFunc = 1,     -- 功能解锁
        UnlockHangBox = 2, -- 挂机宝箱，因为表现不一样，特殊处理
        GotItem = 3,        -- 获得道具
        PlayAnim = 4,       -- 播放动画
        GuardBoss = 5,      -- 关底boss
        UnlockTask = 6,     -- 解锁任务，因为表现不一样，特殊处理
    },

    -- 剧情小节使用的美术资源类型
    StorySectionArtType = {
        Icon = 1,          -- 同一表现，换图标
        Prefab = 2,        -- 独立的预制体
    },

    ChatDataType = {
        Private = 1,
        World = 2,
        Guild = 3,
    },

    ChatSubType = {
      None = 0,
      Expedition = 1,
    },

    ExpeditionHelpSource = {
      Private = 1,
      Guild = 3,
    },

    ChatChannel = {
        World = 1,
        Guild = 2,
        System = 3,
        BattleRecord = 4,
    },

    ChatSystemType = {
        Loggedin = 0,
        PassMap = 1,
        Hero = 2,
        Box = 3,
        Item = 4,
        ArenaWinStreak = 5,
        WorldBoss = 6,
        Guild = 7,
        Competition = 8, --赛季系
        ActCollection = 9,
        TurnWheelPrize = 10,   --播报三赛季转盘获得
        GoddessLike = 11,
        StarDivine  = 12,  --占星季播报
        ItemExchange = 13, --兑换活动播报
        ActivityWheel = 14, --活动转盘播报
        GuildDemonBoss = 15, -- 公会魔王BOSS播报
        IdolGiftBroad = 16, -- 偶像馈赠播报

        TimeLimitDel = 100,
    },

    FriendTogglePageType = {
        InterestList = 1,  --我的关注
        FansList = 2,      --我的粉丝
        BlackList = 3,     --黑名单
        FriendRecommend = 4,     --添加好友
        FriendInvitation = 5, --邀请好友
        ClimbingTower  = 6,  --爬塔数据列表
        ExpedtionHelpLog = 7,   --远征之门救助信息数据
        GuildDemonPlayerInfo = 8,   --魔王公会BOSS公会玩家信息数据
        GuildDemonMvpInfo =9,       --魔王公会BOSS公会MVP信息数据
        IdolRankInfo = 11,          --偶像季排行信息
        IdolFansInfo = 12,          --偶像祭粉丝信息
        TempPlayerBirefInfos = 13,  --偶像祭前3名粉丝信息
        PrivateChatBriefQuery = 100, -- 私聊对象 信息查询
        GuildPlayerBriefQuery = 101, -- 公会玩家信息
        InvitationStudentListQuery = 102, --拉新学生列表信息查询
        InvitationStudentSingleQuery = 103, --拉新单独学生信息查询
    },

    FriendStatusType = {
        MyInterest = 1,     --我关注的
        MyFans = 2,         --关注我的
        All = 3,            --互关
    },

    UITipsType = {
        Item = 1,
        Skill = 2,
        HolidayCollectionWord = 3,
    },

    TipsEnterType = {
        None = 0,
        BaseAttr = 1,
        Cost = 2,
        BtnOK = 3,
        BtnEquip = 4,
        BtnInfo = 5,
        BtnDecompose = 6,
        BtnCompose = 7,
        BtnOpen = 8,
        BtnMake = 9,
        BtnInsertCard = 10,
        SliderBox = 11,
        SliderBoxCondition = 12,    --打开需要条件的按钮
        SliderComs = 13,
        BtnUse = 14,                --使用
        BtnGoto = 15,                --前往
        BtnBoxCompose = 16,
        ItemNumber = 17,          --可获得道具
    },

    EquipTypeName = { "Hat",	--帽子
                      "Clothing",	--衣服
                      "Weapon",	--武器
                      "Cloak",	--披肩
                      "Shoes",	--鞋子
                      "Ornament",	--饰品
    },

    HeadFrameState = {
        Loss = 1,       --未获得，包括开启这个头像框的道具也未获得
        GotItem = 2,    --已获得开启头像框的道具，但是没有开启头像框
        GotFrame = 3,   --已经开启了头像框
        Using= 4,       --正在使用中
    },

    HeadFrameChange = {
        Change = 1,     --头像框发生了改变
        OutOfTime = 2,  --头像框超时了
    },

    --IconItem的角标
    FromType = {
        Extra = 1,   --额外获得
    },

    RPType = {
        New = 1,
        Equipment = 2,
        LvUp = 3,
        Refine = 4,
        RedPoint = 5,
        Hart = 6,
        Recommend = 7,
        PrivateChat = 8,
        CardSlot = 9,
        CardOpen = 10,
    },

    RPNotifyType = {
        None = 0,
        NewSkill = 1,
        EquipDress = 2,
        EquipLvUp = 3,
        EquipRefine = 4,
        LeaderAttr = 5,
        LeaderTransfer = 6,
        PtTransfer = 7,
        NewFashion = 8,
        PtBreak = 9,
        PtRecruit = 10,
        SignIn = 11,
        Transfer = 12,
        Task = 14,
        TaskDaily = 15,
        TaskWeekly = 16,
        TaskMain = 17,
        EvilBattle = 18,
        NewMail = 19,
        Friend = 20,
        PrivateChat = 21,
        CardSlot = 22,
        PtAttr = 23,
        CardEmpty = 24,
        CardLvUp = 25,
        CardCollect = 26,
        PetCollection = 27,
        HeadFrame = 28,
        PetLvUp = 29,
        PetAdvance = 30,
        PetSkillUp = 31,
        PetRelation = 32,
        GuildAuditApply = 33,
        GuildHuntBoss = 34,
        FortnightLogin = 35,
        FortnightTaskReward = 36,
        Expedition = 37,
        Summon = 38,
        FirstRecharge = 39,
        HundredRecharge = 40,
        RuneShopDaily = 41,
        RuneShopWeek = 42,
        RuneShopMonth = 43,
        BagItem = 44,
        TowerRankChanged = 45,
        TowerRankCanReward = 46,
        ArenaRankChanged = 47,
        ArenaRankCanReward = 48,
        HundredDojo = 49,
        LimitRecharge = 50,
        HundredDojoReward = 51,
        DailyRecharge = 52,
        MapRankChanged = 53,
        MapRankCanReward = 54,
        KeepSakeCollect = 55,
        ActivityCollect = 56,
        FashionLvUp = 57,
        RuneShopRewards = 58,
        OnlineRewards = 59,
        PetRankChanged = 60,
        PetRankCanReward = 61,
        ActivityGoddess = 62,
        PetStampInsert = 63,
        PetStampLvUp = 64,
        PetStampAdvance = 65,
        ActivitySpring = 66,        
        RuneShopLimitGift = 67,
        KingTask = 68,
        SkillRankCanReward = 69,
        VoyageCanChallage = 70,
        Activity61Days = 71,
        SkillEquip = 72,
        TitleRedPoint = 73,
        GuildDemonBoss = 74,
        PetQiyueFunc = 75,
        WishSlotItem   = 76,
    },

    LevelIncreaseType = {
        BaseExp = "Common/ic_res_expbase",
        PartnerExp = "Common/ic_res_exppt",
        Zeny = "Common/ic_res_coinz",
        SkillExp = "Common/ic_res_counter",
    },
    --记录玩家设置的内容
    SettingsTag = {
        Music = "Music",    --音乐的音量
        Sound = "Sound",    --音效的音量
        MusicMute = "MusicMute",  --音乐是否静音,0代表不静音，1代表静音
        SoundMute = "SoundMute",  --音效是否静音,0代表不静音，1代表静音
    },
    --商品类型
    GoodsType = {
        SundryGoods = 1,    --杂货店
        HeroGoods = 2       --英灵殿
    },
    --商品限购类型
    LimitBuyType = {
        NoLimit = 0,    --不限购
        Forever = 1,    --永久限购
        Daily = 2,      --每日限购
        Time = 3,       --时间段限购
        Week = 4,       --每周限购
        Special = 5,    --黑市限购 （特殊限购类型）
    },
    -- 卢恩商店类型
    RuneShopType = {
        MonthCard = 1,  -- 月卡
        Gifts = 2,      -- 礼包
        LimitTime = 3,  -- 限时
        RushTower = 4,  -- 爬塔冲榜
        RushArena = 5,  -- 爬塔冲榜
        RushMap = 6,    -- 推图冲榜
        Rewards = 7,    -- 探索（战令悬赏）
        GuildWar = 8,   -- 公会战
        RushPet  = 9,   --宠物冲榜商店
        RushSkill = 10, --技能冲榜商店
        IdolShop     = 11, --偶像祭
    },
    -- 卢恩商店子类型 （只有在为礼包页签时才有效）
    RuneShopSubType = {
        Daily = 1,      -- 日礼包
        Week = 2,       -- 周礼包
        Month = 3,      -- 月礼包
        Gold = 4,       -- 金币礼包
    },
    --任务标签
    TaskTag = {
        Daily   = 1,  --日常任务
        Weekly  = 2,  --周常任务
        Main    = 3,  --主线任务
    },
    --任务是否已经领取
    TaskState = {
        NotGot = 0, --未获得
        Got = 1,    --获得但是没有领取
        GotAndHas = 2,  --获得而且已经领取了
    },
    --星期
    WeekDay = {
        Mon = 1,    --周一
        Tue = 2,    --周二
        Wed = 3,    --周三
        Thu = 4,    --周四
        Fri = 5,    --周五RushArena
        Sat = 6,    --周六
        Sun = 7,    --周日
    },

    --强制引导触发枚举
    ForceGuideTriggerEnum = {
        BattleWin = 1,
        Story = 2,
        FuncOpen = 3,
        FGGroupId = 4,
    },

    JobRecommend = {
        {4},
        {5},
        {1},
        {1},
        {2},
    },

    MailType = {
        None = 0,
        GM = 1,
        System = 2,
        Boss = 3,
        Arena = 4,
        Competition = 5,
        GuildBoss = 6,
        Expedition = 7,
        Activeities = 8,
        Invitation = 9,
        VipLevelUp = 10,
        Pay = 11,
        GuildWarHight = 16,
        GuildWarNormal = 17,
        GuildWarScore = 18,
        GuildWarKiller = 19,
        GuildDemonBoss = 25,
        IdolMail       = 26,
    },

    Alignment = {
        UpperLeft = 0,
        UpperCenter = 1,
        UpperRight = 2,
        MiddleLeft = 3,
        MiddleCenter = 4,
        MiddleRight = 5,
        LowerLeft = 6,
        LowerCenter = 7,
        LowerRight = 8
    },

    ListLoadingStatus = {
        None = 0,
        WaitContinureDrag = 1,
        WaitRelease = 2,
        WaitLoad = 3,
        Loaded = 4,
    },

    GuildDataState = {
        NoData = 0,     -- 必要的公会数据还未收到
        NoGuild = 1,    -- 无公会
        HasGuild = 2,   -- 有公会
    },

    --在线奖励
    EnumOnineState =
    {
        RunTime = 0,       --倒计时
        Receive = 1,       --可领取
        ToDayFinished = 2,    --今日领取完毕
    },

    --- 公会职位类型
    GuildPostType = {
        None = 0,           -- 无职位
        VicePresident = 1,  -- 副会长
        President = 2,      -- 会长
    },

    --- 公会管理类型
    GuildManageType = {
        AuditApply = 1,     -- 入会申请
        Settings = 2,       -- 信息设置
        Mail = 3,           -- 全员邮件
        List = 4,           -- 公会列表
        Dismiss = 5,        -- 解散公会
        Exit = 6            -- 退出公会
    },

    --- 公会人员操作类型
    GuildPeopleHandleType = {
        UpPresident = 1,        -- 提升为会长
        UpVicePresident = 2,    -- 提升为副会长
        DownMember = 3,         -- 降为成员
        PrivateChat = 4,        -- 私聊
        SeeInfo = 5,            -- 查看信息
        Interest = 6,           -- 关注
        CancelInterest = 7,     -- 取消关注
        Kickout = 8,            -- 请离公会
    },

    GuildLogType = {
        AuditEnter = 1,         -- 被审核允许进入公会
        Kickout = 2,            -- 被踢出公会
        Exit = 3,               -- 玩家离开公会
        UpVicePresident = 4,    -- 提升为副会长
        DownMember = 5,         -- 降为成员
        UpPresident = 6,        -- 提升为会长
        Enter = 7,              -- 不需要审核直接进入了公会
        EliteBoss = 8,          -- 精英boss开启
        AutoDownPresident = 9,  -- 自动降会长
    },

    GuildEnterVerifyType = {
        Ban = 1,            -- 不允许进入
        NeedVerify = 2,     -- 需要验证
        NotVerify = 3,      -- 随意进入
    },

    GuildAduitApplyType = {
        Allow = 1,      -- 允许
        Refuse = 2,     -- 拒绝
        Untreated = 3,  -- 未处理
    },

    GuildAduitApplyHandleType = {
        One = 0,
        AllAllow = 1,
        AllRefuse = 2,
    },

    GuildHuntBossType = {
        Normal = 1,     -- 普通boss
        Elite = 2,      -- 精英boss
    },

    GuildWarMatchMapState = {
        None = 0,
        Start = 1,
        OneReady = 2,
        One = 3,
        TwoWait = 4,
        TwoReady = 5,
        Two = 6,
        ThreeWait = 7,
        ThreeReady = 8,
        Three = 9,
        Result = 10,
        End = 11,
    },

    HundredDojoAreaType = {
        FirstArea = 1,
        SuperArea = 2,
        OneLvArea = 3,
        TwoLvArea = 4,
        ThreeArea = 5,
        FourArea = 6,
    },

    HundredDojoFunType = {
        Normal = 1,
        Box = 2,
    },

    BattleBtnState = {
        Skill = 0,
        Fellow = 1,
        Pet = 2,
        RoleModel = 3,
    },

    --仅用于区分
    UIChatRootType = {
        Battle = 0,
        World = 1,
        System = 2,
    },

    JobNamesEnum = {
        "JobName_10010",
        "JobName_40010",
        "JobName_30010",
        "JobName_20010",
        "JobName_50010",
    },

    PetRelationConditionType = {
        Type = 1,
        Advence = 2,
        Nature = 3,
    },

    ActorUidField = {
        Hero = 0,
        Pet = 100,
    },

    ActivityRewardState = {
        NotGot = 0, --未获得
        Got = 1,    --获得但是没有领取
        GotAndHas = 2,  --获得而且已经领取了
    },

    -- 发起支付的错误
    InitPayErrorCode = {
        Success = 0,
        OperateFreq = 1,    -- 发起支付过于频繁
        Paying = 2,         -- 还在支付中（上一个支付未结束）
        ValidPay = 3,       -- 无效支付（参数不对）
    },

    DropSource = {
        Shop = 8,
        Gift = 10,
        WorldBoss = 12,
        Recharge = 22,
        Summon = 23,
    },

    UnlockChargeType = {
        None                    = 0,
        ZenyOnceCost            = 1, --银币一次性消耗        资源不够      [5:银币一次性消耗]
        ClimbTowerLevel         = 2, --试炼之塔        达到第X层         [2:层数]
        SkillLevelUp            = 3, --技能升级        资源不够          [4:角色等级:当前剩余可分配的技能经验小于X]
        BaseLevel               = 4, --角色等级        等级达到X         [3:角色等级]
        DrawCardMVP             = 5, --抽卡        获得MVP               [6:当5连抽，获得指定的MVP卡片的时候，触发限时特惠礼包]
        DrawPetMVP              = 6, --抽宠        获得MVP               [7:当5连抽，获得指定的MVP宠物的时候，触发限时特惠礼包]
        BattleLevel             = 7, --主线关卡        达到指定关卡       [1:关卡]
        ShopNormalRMBCost       = 8, --普通商店        金币消耗数量        [8:金币消耗数量]
        ArenaShopCost           = 9, --英灵殿商店        功勋消耗数量        [9:功勋消耗数量]
        GuildShopCost           = 10, --公会商店        公会币消耗数量      [10:公会币消耗数量]
        SpecialShopRMB          = 11, --黑市商店        金币消耗数量        [11:金币消耗数量]
        PetShopCost             = 12, --宠物商店        分解石消耗数量       [12:分解石消耗数量]
        DrawCardSpecial         = 14,
        DrawPetSpecial          = 15,
        PayAmount               = 16,
        HeroStrength            = 17,
        HeroLevel               = 18,
    },

    RankActivitiesType = {
        ClimbingTower = 1,   --爬塔
        Dojo = 2, --英灵殿
        MapProgress = 3, --推图进度
        Pet = 4, --宠物
        Skill = 5, --技能压制等级
    },

    ActivitiesItemType = {
      SecondSeason = 2,
      SeasonForeverItem = 4,
      HolidayCollectionWord = 5,
      ForeverItem = 6,
      DelayOpenItem = 7,
    },

    HeroExtGoesShowType = {
        God_Art = 1, -- 神器
        Strength_Halo = 2,  --进阶光环

        --宠物
        Pet_Qiyue = 10, --契约球
    },
    
    UnlimitTowerType = {
        ClimbingTower = 0,
        PeakTower = 1,
    }
}

do
    Enum.EquipForgeType = {
        {1, "Knife", Enum.SlotEquipType.Weapon},
        {2, "Katar", Enum.SlotEquipType.Weapon},
        {3, "Bow", Enum.SlotEquipType.Weapon},
        {4, "MagicWand", Enum.SlotEquipType.Weapon},
        {5, "Wand", Enum.SlotEquipType.Weapon},
        {6, "Hat", Enum.SlotEquipType.Head},
        {7, "Clothing", Enum.SlotEquipType.Body},
        {8, "Cloak", Enum.SlotEquipType.Wrap},
        {9, "Shoes", Enum.SlotEquipType.Shoes},
        {10, "Ornament", Enum.SlotEquipType.Jew},
    }

    Enum.RPPrefab = {
        [Enum.RPType.New] = "UINewRP",
        [Enum.RPType.Equipment] = "UIEquipRP",
        [Enum.RPType.LvUp] = "UILvUpRP",
        [Enum.RPType.Refine] = "UIRefineRP",
        [Enum.RPType.RedPoint] = "UIRedPointRP",
        [Enum.RPType.Hart] = "UIHartRP",
        [Enum.RPType.Recommend] = "UIRecommendRP",
        [Enum.RPType.PrivateChat] = "UIPrivateChatRP",
        [Enum.RPType.CardSlot] = "UICardSlotRP",
        [Enum.RPType.CardOpen] = "UICardOpenRP",
    }

    Enum.FashionSlotToSkinSlot = {
        [Enum.FashionSlotType.HeadTop]     = Enum.SkinSlotType.HeadTop,
        [Enum.FashionSlotType.HeadMiddle]  = Enum.SkinSlotType.HeadMiddle,
        [Enum.FashionSlotType.HeadBottom]  = Enum.SkinSlotType.HeadBottom,
        [Enum.FashionSlotType.Cloth]       = Enum.SkinSlotType.Cloth,
        [Enum.FashionSlotType.BodyBack]    = Enum.SkinSlotType.BodyBack,
        -- 武器情况特殊
        -- [Enum.FashionSlotType.Weapon]      = { Enum.SkinSlotType.LeftHand, Enum.SkinSlotType.RightHand }
        [Enum.FashionSlotType.HairStyle]   = Enum.SkinSlotType.HairStyle,
        [Enum.FashionSlotType.Pupil]       = Enum.SkinSlotType.Pupil,
    }
end

return Enum