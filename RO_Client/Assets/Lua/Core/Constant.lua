local Constant = {
    -- 下面的注释取消，则默认连接该服务器(私服)
    SERVER_FORCE_INFO = {
        ServerId = 1,
        ServerName = "初心之旅",
        Ip = "127.0.0.1",
        Port = {21001},
        State = 1
    },

    DefaultLayer = "Default",
    ModelLayer = "Model",

    OpenPay = true,

    HeroLeaderIcon = "FrameNew/label_main",
    HeroBattleIcon = "FrameNew/label_battling",

    MaxAdvenceCount = 6,
    MaxQualityCount = 5,
    MaxRankIndex = 10, -- 英灵殿排行榜的最大页数

    Quality_White_Bg_Icon = "Common/img_equipbg_white",
    Quality_White_Frame_Icon = "FrameNew/frame_item_gray",
    Quality_White_Head_Frame_Icon = "FrameNew/frame_partner_gray",

    -- Quality_Bg_Icons = {"FrameNew/img_headbg_green", "FrameNew/img_headbg_blue", "FrameNew/img_headbg_purple", "FrameNew/img_headbg_orange", "FrameNew/img_headbg_red"},

    PetSkillLvStar_Icons = {"FrameNew/frame_star_purple", "FrameNew/frame_star_gold", "FrameNew/frame_star_red"},
    Quality_NatureBg_Icons = {"FrameNew/frame_headframe_green", "FrameNew/frame_headframe_blue",
                              "FrameNew/frame_headframe_purple", "FrameNew/frame_headframe_gold",
                              "FrameNew/frame_headframe_red"},
    Quality_Frame_Icons = {"FrameNew/frame_item_green", "FrameNew/frame_item_blue", "FrameNew/frame_item_purple",
                           "FrameNew/frame_item_gold", "FrameNew/frame_item_red"},

    Quality_Item_Bg_Icons = {"Common/img_equipbg_green", "Common/img_equipbg_blue", "Common/img_equipbg_purple",
                             "Common/img_equipbg_orange", "Common/img_equipbg_red"},
    Quality_Item_Frame_Icons = {"Common/img_equipframe_green", "Common/img_equipframe_blue",
                                "Common/img_equipframe_purple", "Common/img_equipframe_orange",
                                "Common/img_equipframe_red"},

    CardLocation_Icons = {"Cards/ic_card_hat", "Cards/ic_card_clothes", "Cards/ic_card_weapon", "Cards/ic_card_cloak",
                          "Cards/ic_card_shoes", "Cards/ic_card_jewelry"},

    Card_Quality_Icons = {"FrameNew/ic_card_blue", "FrameNew/ic_card_purple", "FrameNew/ic_card_gold"},
    Card_Quality_L_Icons = {"FrameNew/ic_card_blue_l", "FrameNew/ic_card_purple_l", "FrameNew/ic_card_gold_l"},

    Pet_Quality_Bg_Icons = {"FrameNew/frame_advence_normal", "FrameNew/frame_advence_normal",
                            "FrameNew/frame_advence_mini", "FrameNew/frame_advence_mvp"},
    Pet_Quality_Text_Colors = {"<color=#3c73ab>%s</color>", "<color=#3c73ab>%s</color>", "<color=#893b86>%s</color>",
                               "<color=#d4682e>%s</color>"},

    Quality_Chip_Frame_Icons = {"FrameNew/frame_ptnpiece_green", "FrameNew/frame_ptnpiece_blue",
                                "FrameNew/frame_ptnpiece_purple", "FrameNew/frame_ptnpiece_gold",
                                "FrameNew/frame_ptnpiece_red"},

    Quality_Role_Frame_Default_Icons = "RoleList/List_Head_Frame_White",
    Quality_Role_Frame_Size = {{164, 304}, {164, 304}, {164, 304}, {164, 304}, {164, 304}, {164, 304}, {164, 336}},
    Quality_Lead_Role_Icon = "RoleList/List_Head_Frame_Lead",

    -- 装备品质划分规则
    -- [1] = {2, 3} 
    -- 1.表示装备表中的品质值
    -- 2.表示边框颜色（绿，蓝，紫，金，红）
    -- 3.表示级别（Ⅰ、Ⅱ、Ⅲ、Ⅳ、Ⅴ）
    Quality_Equip_Divide = {
        [1] = {1, 1},
        [2] = {1, 2},
        [3] = {1, 3},
        [4] = {2, 1},
        [5] = {2, 2},
        [6] = {2, 3},
        [7] = {3, 1},
        [8] = {3, 2},
        [9] = {3, 3},
        [10] = {4, 1},
        [11] = {4, 2},
        [12] = {4, 3},
        [13] = {5, 1},
        [14] = {5, 2},
        [15] = {5, 3}
    },

    -- 主城角色行走速度(m/s)
    GuildLobby_WalkSpeed = 5,
    -- 主城角色跑速度(m/s)
    GuildLobby_RunSpeed = 10,
    -- 主城角色转向速度(rad/s)
    GuildLobby_TurnSpeed = 10,

    -- Quality_Equip_LV_Des = {"Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ", "Ⅴ"},
    Quality_Equip_LV_Icons = {"FrameNew/num_quip_1", "FrameNew/num_quip_2", "FrameNew/num_quip_3",
                              "FrameNew/num_quip_4", "FrameNew/num_quip_5"},

    Quality_CardBg_Default_Icon = "FrameNew/frame_equip_plus_gray",
    Quality_CardBg_Icons = {"FrameNew/frame_equip_green", "FrameNew/frame_equip_blue", "FrameNew/frame_equip_purple",
                            "FrameNew/frame_equip_gold", "FrameNew/frame_equip_red"},
    Quality_CardType_Icons = {"FrameNew/lable_card_normal", "FrameNew/lable_card_mini", "FrameNew/lable_card_mvp"},
    Quality_Card_Icons = {"FrameNew/lable_card_normal", "FrameNew/lable_card_normal", "FrameNew/lable_card_mini",
                          "FrameNew/lable_card_mvp"},
    Quality_EquipPlus_Icons = {"FrameNew/frame_equip_plus_green", "FrameNew/frame_equip_plus_blue",
                               "FrameNew/frame_equip_plus_purple", "FrameNew/frame_equip_plus_gold",
                               "FrameNew/frame_equip_plus_red"},

    Quality_Role_PlusFrame_Defaut_Icons = "RoleList/list_head_frame_plus_white",
    Quality_Role_PlusFrame_Icons = {"RoleList/list_head_frame_plus_green", "RoleList/list_head_frame_plus_blue",
                                    "RoleList/list_head_frame_plus_purple", "RoleList/list_head_frame_plus_gold",
                                    "RoleList/list_head_frame_plus_red", "RoleList/list_head_frame_plus_red",
                                    "RoleList/list_head_frame_plus_gold"},

    Paper_Sex_Icons = {"FrameNew/frame_girl", "FrameNew/frame_boy"},

    Quality_Treasure_Icons = {"Jobs/ic_job_sword_s", "Jobs/Jobicon_Achemist", "Jobs/Jobicon_Archer",
                              "Jobs/Jobicon_Assassin", "Jobs/Jobicon_Blacksmith"},

    Hero_Job_Icons = {"Jobs/Jobicon_Sword", "Jobs/Jobicon_Thief", "Jobs/Jobicon_Archer", "Jobs/Jobicon_Mage",
                      "Jobs/Jobicon_Acolyte"},

    Quality_FX = {"UI/FX_UI_ItemIcon_Purple", "UI/FX_UI_ItemIcon_Yellow", "UI/FX_UI_ItemIcon_Red"},

    Card_Debries_Icons = {"FrameNew/frame_cardpiece_normal", "FrameNew/frame_cardpiece_normal",
                          "FrameNew/frame_cardpiece_mini", "FrameNew/frame_cardpiece_mvp"},
    Pet_Debries_Icons = {"FrameNew/frame_petpiece_normal", "FrameNew/frame_petpiece_normal",
                         "FrameNew/frame_petpiece_mini", "FrameNew/frame_petpiece_mvp"},
    SkillEquip_Debries_Icons = {"FrameNew/frame_artifactpiece_normal", "FrameNew/frame_artifactpiece_normal",
                                "FrameNew/frame_artifactpiece_mini", "FrameNew/frame_artifactpiece_mvp"},

    Pet_Stamp_Slot_Icons = {"PetStamp/ic_petpos_01", "PetStamp/ic_petpos_02", "PetStamp/ic_petpos_03",
                            "PetStamp/ic_petpos_04", "PetStamp/ic_petpos_05", "PetStamp/ic_petpos_06"},
    Pet_Stamp_Bless_Icons = {"PetStamp/ic_petblessing_01", "PetStamp/ic_petblessing_02", "PetStamp/ic_petblessing_03",
                             "PetStamp/ic_petblessing_04", "PetStamp/ic_petblessing_05", "PetStamp/ic_petblessing_06"},
    Pet_Stamp_Bless_Active_Icons = {"PetStamp/ic_pet_active_gray", "PetStamp/ic_pet_active_green",
                                    "PetStamp/ic_pet_active_blue", "PetStamp/ic_pet_active_purple",
                                    "PetStamp/ic_pet_active_gold", "PetStamp/ic_pet_active_red"},

    UIGrayName = "UIGray",
    UIFrameQualityName = "UIFx_LiuGuang_01",

    WhiteColor = {1, 1, 1, 1},
    RedColor = {0.89, 0.34, 0.36, 1},
    GrayColor = {0.53, 0.53, 0.53, 1},
    GreenColor = {0.28, 0.84, 0.13, 1},
    DeepGreenColor = {0, 0.7, 0.41, 1},
    BrownColor = {0.76, 0.63, 0.65, 1},
    BlueColor = {0.03, 0.55, 1, 1},
    PurpleColor = {0.87, 0.33, 0.91, 1},
    GoldColor = {1, 0.59, 0, 1},

    EquipList_Equiped_Color = {1, 0.89, 0.62, 1},
    EquipList_NoEquiped_Color = {0.85, 0.82, 0.72, 1},

    DefaultColorSymbolText = "#c078df5",
    RedColorSymbolText = "#cff1616",
    GrayColorSymbolText = "#c9c9c9c",
    OrangeColorSymbolText = "#cef8701",

    DefaultColorText = "<color=#555e74>%s</color>",
    RedColorText = "<color=#ff1616>%s</color>",
    PinkColorText = "<color=#fe5478>%s</color>",
    GrayColorText = "<color=#9c9c9c>%s</color>",
    DarkColorText = "<color=#5e5e5e>%s</color>",
    GreenColorText = "<color=#00ab65>%s</color>",
    DeepGreenColorText = "<color=#00892a>%s</color>",
    BrownColorText = "<color=#774f2f>%s</color>",
    DeepBlueText = "<color=#555e74>%s</color>",
    OrangeColorText = "<color=#ef8701>%s</color>",
    BlueColorText = "<color=#078df5>%s</color>",
    PurpleColorText = "<color=#c230ff>%s</color>",
    GoldenColorText = "<color=#ff9600>%s</color>",

    ColorTextArray = {"<color=#00ab65>%s</color>", "<color=#078df5>%s</color>", "<color=#c230ff>%s</color>",
                      "<color=#ff9600>%s</color>", "<color=#ff4b14>%s</color>"},
    ChatSystemColorArray = {"#c00ab65%s", "#c078df5%s", "#cc230ff%s", "#cff9600%s", "#cff4b14%s"},

    Quality_PetFrame_Icons = {"FrameNew/frame_head_green", "FrameNew/frame_head_blue", "FrameNew/frame_head_purple",
                              "FrameNew/frame_head_gold", "FrameNew/frame_head_red"},
    Pet_Star_Text_Color = {"<color=#893b86>%s</color>", "<color=#d4682e>%s</color>", "<color=#bd2933>%s</color>"},
    Pet_Star_Icons = {"FrameNew/frame_star_purple", "FrameNew/frame_star_gold", "FrameNew/frame_star_red"},

    Lang_Attack = "AttackPercent",

    CARD_SLOT_LIMIT = 4,

    --- 角色升级是否显示去分配属性的按钮
    ROLE_LV_STATUS_SAVE_KEY = 'UIMainView_RoleLv_Status',
    --- 职业升级是否显示去升级技能的按钮
    JOB_LV_STATUS_SAVE_KEY = 'UIMainView_JobLv_Status',
    --- 选择的ServerIndex
    SELECT_SERVER_INDEX_KEY = 'ServerIndex',
    AGREEMENT_RECORD_KEY = 'AgreementRecord',

    CHAT_BYTE_LIMIT = 135,

    StageGoalMaxPoints = 5,

    OneDaySeconds = 24 * 60 * 60,

    IsDebug = false,

    CurServerType = "5", -- 当前服务器类型：1---内网; 2---外网; 3---版署服务器; 4---先锋服务器; 5---quicksdk服务器

    Natural_Icons = "Natures/nature_",
    Natural_Unknow_Icon = "Natures/nature_unknow",

    MainPlayerStrengthLevel = 100, -- 主角的突破等级，目前是100

    MyPetSupportLimit = 6,

    PartnerStrengthEffectPath = {"Hero/Common/Chant/Fx_JiaoDiGuangHuan_01", "Hero/Common/Chant/Fx_JiaoDiGuangHuan_02",
                                 "Hero/Common/Chant/Fx_JiaoDiGuangHuan_03", "Hero/Common/Chant/Fx_JiaoDiGuangHuan_04",
                                 "Hero/Common/Chant/Fx_JiaoDiGuangHuan_05", "Hero/Common/Chant/Fx_JiaoDiGuangHuan_06",
                                 "Hero/Common/Chant/Fx_JiaoDiGuangHuan_07", "Hero/Common/Chant/Fx_JiaoDiGuangHuan_08",
                                 "Hero/Common/Chant/Fx_JiaoDiGuangHuan_09", "Hero/Common/Chant/Fx_JiaoDiGuangHuan_010"},

    -- 进阶相关显示
    Quality_Role_Frame_Icons = {"RoleList/List_Head_Frame_Green", "RoleList/List_Head_Frame_Blue",
                                "RoleList/List_Head_Frame_Purple", "RoleList/List_Head_Frame_Gold",
                                "RoleList/List_Head_Frame_Red", "RoleList/List_Head_Frame_seven",
                                "RoleList/List_Head_Frame_eight", "RoleList/List_Head_Frame_nine",
                                "RoleList/List_Head_Frame_ten", "RoleList/List_Head_Frame_eleven",
                                "RoleList/List_Head_Frame_twelve", "RoleList/List_Head_Frame_thirteen",
                                "RoleList/List_Head_Frame_fourteen"},

    Quality_HeadFrame_Icons = {"FrameNew/frame_partner_green", "FrameNew/frame_partner_blue",
                               "FrameNew/frame_partner_purple", "FrameNew/frame_partner_gold",
                               "FrameNew/frame_partner_red", "FrameNew/frame_partner_seven",
                               "FrameNew/frame_partner_eight", "FrameNew/frame_partner_nine",
                               "FrameNew/frame_partner_ten", "FrameNew/frame_partner_eleven",
                               "FrameNew/frame_partner_twelve", "FrameNew/frame_partner_thirteen",
                               "FrameNew/frame_partner_fourteen"}, -- TODO：第100个数据是frame_head_lead，这是之前的主角标识，目前策划不能确定主角是否要突破，所以暂时主角的边框也放成一级突破的边框
    Quality_HeadFrame_Lead_Icon = "FrameNew/frame_head_gray",
    SkillEquipMaxStarLimit = 5 -- 神器最大星数5
}

return Constant
