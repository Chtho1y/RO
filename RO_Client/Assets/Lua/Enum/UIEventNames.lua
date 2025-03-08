local x = 1
local function id()
    local old_x = x
    x = x + 1
    return old_x
end

local UIEventNames = {
    EID_Connect_GameServer_Success = id(),
    NEED_CREATE_ROLE = id(), -- 创角界面 创角通知
    NICK_NAME_CREATED = id(),  -- 玩家名字创建完成
    ENTER_BATTLE = id(), --创角完成 进入战斗
    DESTROY_ALL_MODEL = id(), --删除主角和伙伴界面 预览的模型
    SWICH_PARTNER_HERO = id(),  --伙伴界面 左右切换按钮通知
    SWICH_PARTNER_VIEW =  id(), --伙伴界面切换刷新
    REFRESH_COIN_AND_JOBEXP = id(),  --刷新 货币和伙伴经验
    REFRESH_COIN_AND_DIAMOND = id(),  --刷新 银币和金币
    REFRESH_ROLE_LV = id(),  -- 刷新英雄等级
    COIN_CHANGED = id(),  -- 金币改变
    DIAMOND_CHANGED = id(),  -- 钻石改变
    ROLE_LV_CHANGED = id(),    -- 英雄等级改变
    ROLE_EXP_CHANGED = id(),  -- 英雄验改变 （当等级改变，而经验未改变时，也会有该消息）
    JOB_LV_CHANGED = id() ,     -- 职业等级改变
    JOB_EXP_CHANGED = id(),  -- 职业经验改变 （当职业等级改变，而经验未改变时，也会有该消息）
    ROLE_HERO_SPIRIT_CHANGED = id(), -- 玩家英灵值变化(不放背包的资源)
    REFRESH_TRAIN_ATTRS = id(), --刷新 伙伴 属性
    ACTOR_SERVER_CHANGE_ATTRS = id(), --角色属性改变
    ADVENCE_SUCCESS = id(), -- 伙伴进阶成功
    EID_BOSS_Battle_End = id(),
    EID_BOSS_SPAWNED = id(),      --boss出生
    EID_CLONE_NEW_BOSS = id(),
    FRUIT_USE_SUCC=id(),        --属性果实使用成功
    REFRESH_IDOL_MYFANS_INFO = id(),    --偶像祭刷新粉丝数据
    REFRESH_FASN_REWARD_INFO = id(),    --刷新粉丝回馈数据
    REFRESH_DAYS_REWARD_INFO = id(),    --刷新每日奖励信息 
    REFRESH_RANK_MODEL_INFO = id(),     --刷新偶像祭模型信息
    REFRESH_VOTE_VIEW_INFO = id(),      --刷新投票界面
    REFRESH_SUPPORTTIPSVIEW = id(),      --偶像季刷新玩家票数数据打开应援界面
    STAR_SIGN_CHANGE = id(), --占星结果改变
    STAR_SIGN_INIT = id(), --占星初始化数据
    REFRESH_CARD_SUIT = id(), --刷新卡片祝福
    TITLE_WEARER_DISBOARD_NOTICE = id(),  --称号激活卸下消息
    EID_TITLE_CHANGE             = id(),              --称号数据刷新消息
    TITLE_ACTIVE_REDPOINT_NOTICE = id(),
    ACTIVITY_PAGECLOSE = id(),
    
    CURRENY_CHANGED = id(),

    EID_BATTLE_WIN = id(),
    EID_BATTLE_FAILED = id(),    --战斗失败
    EID_FORCEBATTLE_FAILED = id(),    --强制战斗失败
    UI_BATTLE_NORMAL_NTF = id(), --战斗界面恢复到正常界面
    EID_NEXT_BATTLE = id(),  --下一场战斗
    EID_CONTINUE_BATTLE = id(),    --继续当前战斗
    EID_SHOW_BOSS_RAGE = id(),
    EID_SHOW_BOSS_RAGE_LEFTTIME = id(),    --狂暴倒计时
    EID_BOSS_IN_RAGE = id(),  --boss进入狂暴
    EID_HIDE_LEVEL_NAME = id(),        --隐藏关卡名字
    EID_REFRESH_RAGE_LEFTTIME = id(),    --刷新狂暴倒计时
    EID_REFRESH_REWARD_TIME = id(),
    EID_SHOW_SKIP_BATTLE = id(),              --显示跳过战斗
    EID_Battle_UI_VISIBLE = id(),
    EID_Refresh_Enemy_Fighter_Life = id(),
    EID_Refresh_Enemy_Fighter_Sp = id(),
    EID_Fetch_BattleRecord_Success = id(),
    EID_Challenge_Boss_Fight_ACK = id(),
    EID_Show_Notices = id(),
    EID_REFRESH_ONLINETIME_CHANGESTATE = id(), --在线奖励 状态改变

    PARTNER_BATTLE_REQ_SUCCESS = id(), -- 伙伴上阵成功
    PARTNER_BATTLE_CHANGE_INDEX = id(), -- 伙伴上阵成功 修改伙伴列表 索引
    PARTNER_STRENGTH_SUCCESS = id(), -- 伙伴突破成功
    HERO_ATTR_ADD_SUCCESS = id(), -- 主角属性加点成功
    ERROR_DESC_DISPLAY = id(), -- 操作错误tips提示
    ADD_ATTR_DISPLAY = id(), -- 属性增加tip提示
    EQUIP_CHANGE = id(), -- 装备改变消息
    ITEM_CHANGE = id(), -- 道具改变消息
    WISHBOX_SLOT_CHANGE = id(),  --许愿槽位刷新消息
    WISHBOX_SLOT_SHOWANIMATION = id(),  --使用许愿宝箱播放动画消息
    CHIP_CHANGE = id(), -- 伙伴碎片改变消息
    CARD_CHANGE = id(), -- 卡片改变消息
    MAIN_UI_ROLE_REDPOINT_NOTICE = id(), -- 主界面角色红点通知
    MAIN_CHANGE_BUTTONS_STATE = id(),    --主界面上有几个按钮是跟着UI面板改变的
    HERO_EQUIP_REFRESH = id(), -- 主角面板 装备刷新
    REFRESH_HERO_UI = id(), -- 刷新 角色界面
    EQUIP_TIPS_UPDATE = id(), -- 更新装备tips
    UIMAINVIEW_CHANGE_NOTICE = id(), -- 主界面UI切换通知
    OTHER_CLICK_CLOSE_EQUIP_TIPS = id(), -- 点击到其它地方时，需要装备tips关闭
    EID_SHOW_BOSS_WARNING = id(),     --设置boss warning显示与否
    EID_SHOW_PVP_PRESSPOINT =  id(),   --压制点
    ONE_KEY_EQUIP_REDPOINT_NOTICE = id(),     --角色面板 装备一键升级 红点通知
    EQUIP_FORGE_SUCCESS = id(),     --装备锻造成功
    EID_SKILL_SLOT_CHANGED = id(),  --更新技能槽位信息
    EID_SKILL_CHANGED = id(), -- 技能已改变（包含解锁和升级）
    EID_SKILL_RESET_LV_COUNT_CHANGED = id(), -- 重置技能等级次数变化
    EID_EQUIP_AND_ITEM_ADD = id(), -- 获得道具和装备数量增加，就表示有新道具和装备获得
    EID_EQUIP_AND_ITEM_ADD_LIST = id(),
    EID_PARTER_ADD = id(), -- 获得伙伴增加，就表示有新伙伴获得
    EID_FASHION_ADD = id(), -- 获得时装增加，就表示有新时装获得
    EID_REPLACE_SKILL_SUCCESS = id(),       --替换技能成功
    SLOT_REFINE_LV_UP_SUCCESS = id(),       --槽位精炼升级成功
    HERO_LIST_CHANGE_NOTICE = id(),       --英雄列表 变动通知
    EID_PARTENR_SKILL_REFRESH = id(),    --英雄技能的刷新
    CARD_LIST_REFRESH = id(),    --卡片列表刷新
    CARD_RECREATE_REFRESH = id(),    --卡片重置刷新
    CARD_DECOMPOSE_REFRESH = id(),    --卡片分解刷新
    CARD_TRANS_REFRESH = id(),        --卡片转移刷新
    RESET_CARD_DECOMPOSE_CACHE_COUNTS = id(),  --重置卡片分解缓存数量
    GET_ONE_BIG_CARD_AFTER_RECREATE = id(),  --重置卡片 显示获得新卡
    GET_ONE_BIG_CARD_AFTER_COMPOSE = id(),  --合成卡片 显示获得新卡
    DISPLAY_MAIN_TOP = id(),  --main顶部显示状态
    DISPLAY_MAIN_BOTTOM = id(),  --main底部显示状态
    STAGEGOAL_AWARDED = id(),  --阶段目标 奖励领取
    GOT_ITEM_ANIM = id(), --获得 入包事件
    EXCHANGEPET_NTF = id(),    --宠物兑换回包通知
    CHIPREWARD_ISNOTICE_CHANHE = id(), --集字活动是否通知红点改变消息

    UI_PAGE_IN_END_NTF = id(),  --UI page 进入动画结束通知
    UI_PAGE_OUT_END_NTF = id(),  --UI page 退出动画结束通知

    GOT_ITEM_ANIM_END_NOTIFY = id(), --入包事件结束通知

    GOT_ANIM_TYPE_END_NOTIFY = id(), --入包事件结束通知 传入类型

    STAGEGOAL_DISPLAY = id(), --阶段目标 显示隐藏
    STAGEGOAL_DATA_REFRESH = id(), --阶段目标 数据刷新

    EID_LEVEL_CHANGED = id(), -- 当前战斗的关卡发生变化了 （进入新关卡等）

    HERO_LV_CHANGED = id(), -- 英雄等级发生变化（包含主角和伙伴）


    -- 红点
    RED_POINT_NOTICE = id(), -- 红点有变化
    RED_POINT_MGR_NOTICE = id(), -- 红点管理器通知

    -- 大地图
    BIGMAP_SELF_RANK_CHANGED = id(), -- 在大地图上自身的排名变化了
    BIGMAP_TOPPLAYER_RANK_CHANGED = id(), -- 在大地图上前几名的玩家排名变化了
    BIGMAP_ENTER_NEXTMAP_START = id(), -- 开始大地图上进入下一个地图表现
    BIGMAP_ENTER_NEXTMAP_END = id(), -- 大地图进入下一个地图完成

    -- 伙伴碎片
    RESET_CHIP_DECOMPOSE_CACHE_COUNTS = id(),  --重置伙伴碎片分解缓存数量

    -- 主界面提示功能的显示和隐藏
    MAIN_VIEW_SET_ATTR_BTN = id(),    -- 主界面提示分配属性的按钮
    MAIN_VIEW_UP_SKILL_BTN = id(),    -- 主界面提示升级技能的按钮

    -- 时装相关
    FASHION_WEAR_CHANGE = id(),     -- 时装穿戴发生变化
    FASHION_LIST_CHANGE = id(),       -- 时装图鉴发生变化
    FASHION_ROLE_MAIN_VIEW_CHANGE = id(), -- 预览时，通知主角界面刷新时装
    FASHION_BACK_ROLE_MAIN_VIEW = id(), -- 服装更换界面返回主角界面
    FASHION_LV_UP_CHANGE = id(),       -- 时装升级
    FASHION_WASH_CHANGE = id(),       -- 时装洗练

    --界面跳转
    UI_FILLCONTENT_COMPELETED = id(),    --界面初始化完成通知
    UI_CLOSE_COMPELETED = id(), --界面关闭完成通知

    --开启新功能
    UI_FUNCLOCK_OPEN_NTF = id(),
    UI_VIP_FUNCLOCK_OPEN_NTF = id(),
    UI_BATTLE_FUNC_OPEN_NTF = id(),

    UI_MAIN_TOP_RES_TYPE = id(), --主界面 顶部资源显示

    FIGHTPOWER_REFRESH = id(), --战力刷新
    SIDEFIGHTPOWER_REFRESH = id(), --未上阵战力刷新
    FIGHTPOWER_REFRESH_TIPS = id(), --战力刷新Tips
    FIGHTPOWER_PARTNER_ACK = id(),

    EID_BATTLE_INCOME_ACK = id(),
    EID_CRUISE_CHANGED = id(),
    EID_ADVANCESKILLEXP_CHANGED = id(),
    EID_HANG_TIME = id(),

    EID_Loading_Begin = id(),
    EID_Loading_Complete = id(),
    EID_Loading_Progress = id(),
    EID_Loading_Close = id(),
    EID_Loaded_Page_OK = id(),

    --寻宝
    START_TREASURE_SLOT = id(),
    NEW_TREASURE_MESSAGE = id(),
    BOX_TREASURE_OPEN_SUCCESS = id(),
    REFRESH_TREASURE_CRUISE = id(),

    --转职
    HERO_JOB_CHANGE_SUCCESS = id(),
    ROLE_JOB_CHANGE_SUCCESS = id(),
    JOB_CHANGE_SUCCESS = id(),
    JOB_CHANGE_SUCCESS_OVER = id(),

    -- 玩家头像
    USER_HEADPROTRAIT_DATA_TIDY = id(),    --整理头像数据之后
    USER_HEADPROTRAIT_DATA_CHANGED = id(), -- 玩家头像数据变化
    USER_HEADPROTRAIT_CHANGED = id(), -- 玩家使用的头像改变了
    EID_Used_New_HeadFrame = id(),
    EID_Refresh_HeadFrame_RP = id(),

    --战斗
    EID_Dojo_Versus_End = id(),        --对战结束
    EID_Refresh_Tower_Match_Team = id(),      --刷新匹配数据
    EID_Refresh_Tower_Match_Team_Failed = id(),    --匹配失败
    EID_Refresh_Arena_Season_Rank_List = id(),   --刷新竞技场赛季排名数据
    EID_Refresh_Arena_Season_LeftTime = id(),     --刷新赛季剩余时间
    EID_Refresh_Arena_Season_End = id(),                 --当前赛季倒计时结束赛季
    EID_Refresh_Arena_Team_FightPower = id(),     --刷新队伍战斗力
    EID_Refresh_Arena_Data_Change = id(),    
    EID_Refresh_Cast_Skill = id(),
    EID_Refresh_Fighter_Life = id(),
    EID_Refresh_Fighter_Sp = id(),
    EID_Refresh_Boss_Life = id(),
    EID_Refresh_Boss_Dead = id(),
    EID_Refresh_Boss_Buff = id(),
    EID_Refresh_Boss_Skill = id(),
    EID_Refresh_Boss_Remove_Buff = id(),
    EID_Refresh_Skill_CD = id(),
    EID_SELECT_ROLE = id(),
    EID_ENTER_CREATE_ROLE = id(),
    EID_Show_Fighter = id(),
    EID_Add_New_BattleLog = id(),
    EID_CLEAR_New_BattleLog = id(),--清空战斗日志
    EID_Refresh_BattleStatistics = id(),
    EID_Enable_Scroll_Skill_Pnl = id(),
    EID_Scroll_Skill_Pnl = id(),
    
    EID_CLOSED_ACTIVATIONCODE = id(),
    EID_USED_ACTIVATIONCODE = id(),
    EID_CREATE_ROLE_FAILED = id(),
    EID_REFRESH_CLIMBINGTOWER_DATA = id(),
    EID_Refresh_ClimbingTower_RankDetailData = id(),
    EID_Refresh_ClimbingTower_RankData = id(),
    EID_ClimbingTower_BattleEndAck = id(),
    EID_Refresh_ClimbingTower_FriendInfo = id(),
    EID_SC_GET_OTHER_PLAYER_BRIEF_INFO_ACK = id(),
    GUILD_DEMON_GET_OTHER_PLAYER_BRIEF_INFO_ACK =id(),
    IDOL_GET_OTHER_PLAYER_BRIEF_INFO_ACK = id(),
    EID_REFRESH_PEAKTOWER_WIN_DATA = id(),
    EID_CHANGE_TOWER_SHOW_REFRESH = id(),

    EID_Refresh_SkillExpBattle_SlotData = id(),
    EID_Evil_Refresh_Success = id(),
    EID_Evil_Refresh_Failed = id(),
    EID_Evil_Refresh_LeftRefreshCDTime = id(),
    EID_Evil_Refresh_SlotCDTime = id(),
    EID_Evil_Confirm_Challenge = id(),
    EID_SHUT_TIMEBATTLE = id(),
    EID_Set_UINode_Vis = id(),
    EID_FIGHTING_START = id(),
    EID_Refresh_Player_Buff = id(),
    EID_Remove_Player_Buff = id(),


    EID_Dojo_UIPart_Loaded = id(),
    EID_Challenge_Evil_Ok = id(),
    EID_ROLE_EVIL_EXP_CHANGED = id(),
    EID_ROLE_EVIL_Level_CHANGED = id(),
    EID_CLOSE_POPGOT_PAGE = id(),
    EID_PAGE_REDPOINT_NTF = id(),

    EID_CHALLENGE_AUTO = id(),

    --好友相关事件
    EID_Update_FriendDataList = id(),        --更新好友界面数据列表
    EID_Refresh_FriendData = id(),              --更新好友界面数据
    EID_Show_SearchFriendData = id(),        --显示检索数据

    --活动
    EID_Open_Activity_Refresh = id(),
    EID_Activity_Data_Change = id(),
    EID_Activity_Day_Change = id(),
    EID_Activity_FirstRecharge_Change = id(),
    EID_Activity_Daily_Comulative_Refresh = id(),

    --邮件
    REFRESH_MAILS = id(),
    READ_MAIL = id(),
    REWARD_MAIL = id(),

    --主界面 升级按钮 升阶按钮
    BTN_BASE_DISPLAY = id(),
    BTN_JOB_DISPLAY = id(),

    --BOSS战斗时通知主界面改变状态
    BOSS_BATTLE_STATUS = id(),
    NEW_LEVEL_INCREASE_NTF = id(), --新关卡效率显示通知

    PARTNER_ACTIVE_SUCCESS = id(),
    PARTNER_ACTIVE_SUCCESS_OVER = id(),

    -- 世界boss
    WORLD_BOSS_LIST_CHANGED = id(),  -- 世界boss列表变化
    WORLD_BOSS_ROLL_POINT_LIST_CHANGED = id(), -- 选择的世界boss Roll点的列表
    -- WORLD_BOSS_ROLL_POINT_CHANGED = id(),
    WORLD_BOSS_PLAYER_CHANGED = id(),
    WORLD_BOSS_HP_CHANGED = id(),      -- 世界boss血量变化了 （正常来说是服务器下发才有这消息）
    WORLD_BOSS_SERVER_KICKOUT_BATTLE = id(), -- 服务器通知客户端退出世界boss战斗
    WORLD_BOSS_CHALLENGE_COUNT_CHANGED = id(), -- 世界boss总挑战次数变化

    --赛季事件
    SEASON_OPEN_NTF = id(),
    SEASON_EXCHANGE_NTF = id(),
    SEASON_EXCHANGE_NTF_MAIN = id(),
    SEASON_MINUTE_UPDATE = id(),

    --商店
    SHOP_DATA_CHANGED = id(), -- 商店数据已刷新
    SHOP_BUY_SUCCESS = id(),  --购买成功

    --卢恩商店
    RUNE_SHOP_DATA_CHANGED = id(), -- 商店数据已刷新
    RUNE_SHOP_REWARDS_DATA_CHANGED = id(), -- 战令数据已刷新
    --剧情事件触发
    UISTORY_CONDITION_TRIGGER = id(),
    UISTORY_UI_START_OR_OVER = id(),
    STORY_DATA_CHANGED = id(),  --  剧情存储的数据变化了，获得服务器数据变化后触发

    --聊天
    REFRESH_WOLRD_CHAT = id(),
    REFRESH_PRIVATE_CHAT = id(),
    PRIVATER_CHAT_BTN_DISPLAY = id(),
    REFRESH_PRIVATE_BRIEFINFO = id(),
    --头像交互
    AFTER_REFRESH_NAME = id(),  --刷新名字
    AFTER_REFRESH_HEAD = id(),  --刷新头像
    ROLE_MODEL_STATE = id(),      --通知RoleMain界面改变模型的显示状态
    REFRESH_IDOL_RANK_PLAYER_RANK_INFO = id(),
    REFRESH_IDOL_FANS_PLAYER_RANK_INFO = id(),

    --主角升级属性刷新
    REFRESH_HERO_LVUP_ATTR = id(),

    --签到
    AFTER_GET_SIGN_UP_ACK = id(),    --获取签到信息之后
    REFRESH_SIGN_UP_ACK = id(),        --刷新签到信息之后
    AFTER_SIGN_UP_ACK = id(),            --签到完成之后
    BATTLE_WIN_CLOSE = id(),

    --强制引导
    UI_FORCE_GUIDE_DISPLAY = id(),  --强制引导通知
    UI_FORCE_GUIDE_TRIGGER = id(),  --强制引导触发
    UI_FORCE_GUIDE_OVER = id(),  --强制引导结束

    --任务
    UI_TASK_CHANGE = id(),      --任务发生了改变
    UI_CLOSE_TASK_PAGE = id(),  --关闭任务界面
    UI_CLOSEED_TASK_PAGE = id() ,-- 任务界面关闭
    UI_TASK_JUMP = id(),--任务跳转

    --红点解锁刷新
    RED_POINT_UNLOCK_NTF = id(),

    --世界聊天关闭
    WORLD_CHAT_UI_CLOSE = id(),

    --GM公告
    GM_SCROLL_NOTICE = id(),

    -- 公会大厅
    GUILD_LOBBY_PLAYER_INFO_CHANGED = id(), -- 进入公会大厅中的玩家信息刷新了

    --战斗loading结束
    BATTLE_LOADING_COMPELETED = id(),

    --卡槽红点
    CARDSLOT_REDPOINT_ROLE_UI_NTF = id(),

    --公会
    GUILD_LOGIN_SUCCESS = id(), -- 公会登录成功 （主要是公会基本数据下发完成）
    GUILD_RECOMMEND_LIST_CHANGED = id(), -- 公会推荐列表刷新
    GUILD_SEARCH_LIST_CHANGED = id(), -- 公会查询列表刷新
    GUILD_CREATE_SUCCESS = id(), -- 公会创建成功
    GUILD_OTHER_MORE_INFO_CHANGED = id(), -- 查看公会详细信息成功
    GUILD_SELF_MORE_INFO_CHANGED = id(), -- 自身公会的详细信息变化
    GUILD_MEMBER_MORE_INFO_CHANGED = id(),    -- 公会成员详细信息变化
    GUILD_SUBMIT_APPLY_CHANGED = id(), -- 玩家申请进入或取消申请公会
    GUILD_DISBAND_SUCCESS = id(),    -- 公会解散成功
    GUILD_QUIT_SUCCESS = id(), -- 公会退出成功
    GUILD_QUIT_CD_CHANGED = id(), -- 公会退会的CD变化（下一次可加入公会的CD）
    GUILD_ENTER_SUCCESS = id(),    -- 进入公会成功
    GUILD_KICKOUT_SUCCESS = id(),    -- 被踢出公会成功
    GUILD_NOTICE_CHANGED = id(), -- 公会公告变化
    GUILD_NAME_CHANGED= id(), -- 公会名字变化
    GUILD_BADGE_CHANGED = id(), -- 公会徽章变化
    GUILD_ACTIVE_CHANGED = id(), -- 公会的活跃值变化
    GUILD_RECUIT_CHANGED = id(), -- 公会招人信息变化
    GUILD_GET_AUDIT_APPLY_BASE_LIST_CHANGED = id(), -- 公会申请基本列表返回
    GUILD_GET_AUDIT_APPLY_LIST_CHANGED = id(), -- 公会申请列表改变了
    GUILD_GET_OTHER_PLAYER_BRIEF_INFO_ACK = id(), -- 公会玩家信息到达
    GUILD_LOG_CHANGED = id(), -- 公会log信息变化
    GUILD_HUNT_BOSS_LIST_CHANGED = id(), -- 公会狩猎的Boss列表变化了
    GUILD_HUNT_BOSS_BATTLE_LOG_CHANGED = id(), -- 公会狩猎的boss战斗日志变化
    GUILD_HUNT_MASTER_REWARD_CHANGED = id(), -- 公会狩猎大师奖励变化了
    GUILD_HUNT_BOSS_SUMMON_CHANGED = id(), -- 公会狩猎的boss被召唤出来了 （目前只有主动召唤才有）
    GUILD_HUNT_BOSS_HURT_CHANGED = id(),      -- 公会狩猎的boss伤害变化了
    GUILD_CP_RANK_LIST_CHANGED = id(),         -- 公会贡献值排行榜变化了

    -- 公会战
    GUILD_WAR_OPEN_STATE_CHANGED = id(), -- 公会战开启关闭状态变化了
    GUILD_WAR_MATCH_MAP_CHANGED = id(), -- 公会战对战表变化了
    GUILD_WAR_BATTLE_FIELD_INFO_CHANGED = id(), -- 公会战战场基本数据变化了
    GUILD_WAR_BATTLE_FIELD_ENDED = id(), -- 公会战当前战场结束了
    GUILD_WAR_BATTLE_SCORE_DATA_CHANGED = id(), -- 公会战积分数据变化了
    GUILD_WAR_BATTLE_AREA_DATA_CHANGED = id(), -- 公会战位置数据变化了
    GUILD_WAR_BATTLE_SELF_DATA_CHANGED = id(), -- 公会战自身数据变化了
    GUILD_WAR_BATTLE_LOG_DATA_CHANGED = id(),
    GUILD_WAR_BATTLE_RANK_DATA_CHANGED = id(),
    REFRESH_DEMON_RANK_INFO = id(), -- 公会魔王BOSS排行榜刷新消息
    REFRESH_DEMON_PLAYER_RANK_INFO = id(), -- 公会魔王BOSS玩家信息排行刷新消息
    REFRESH_DEMON_VIEW_INFO = id(),     --公会魔王BOSS主界面刷新消息
    REFRESH_DEMON_FIGHT_VIEW_INFO = id(), --公会魔王BOSS购买次数刷新消息

    --筛选
    FILTER_NTF = id(),

    CARD_HANDBOOK_REWARD_REFRESH = id(),
    CARD_HANDBOOK_RANK_REFRESH = id(),

    --Pet
    PET_ATTR_CHANGE_NTF = id(),
    PET_LVUP_REFRESH_NTF = id(),
    PET_ADVENCE_REFRESH_NTF = id(),
    PET_SKILLUP_REFRESH_NTF = id(),
    PET_SKILLUP_SUCCESS_NTF = id(),
    PET_DECOMPOSE_SUCCESS_NTF = id(),
    PET_BATTLE_SUCCESS_NTF = id(),

    PET_RELATION_OPEN_NTF = id(),
    PET_RELATION_CHANGE_NTF = id(),
    PET_RELATION_CHANGE_SUCCESS_NTF = id(),
    PET_FRIEND_SUPPORT_OPEN_NTF = id(),
    PET_MY_SUPPORT_CHANGE_NTF = id(),
    PET_MY_SUPPORT_CHANGE_SUCCESS_NTF = id(),
    PET_HANDBOOK_REWARD_REFRESH = id(),
    PET_DETAIL_QUERY_SUCCESS = id(),

    --头像框发生了改变
    HEAD_FRAME_CHANGE = id(),
    EID_REFRESH_MINTIPS = id(),

    --远征之门
    EID_Expedition_RefreshData = id(),
    EID_Expedition_EnterMap_Success = id(),
    EID_Expedition_ChallengeBoss_Success = id(),
    EID_Expedition_UIPart_Loaded = id(),
    EID_Expedition_GET_OTHER_PLAYER_BRIEF_INFO = id(),
    EID_Expedition_REFRESH_HELP_LOG = id(),
    EID_Expedition_ResetData = id(),
    EID_Refresh_Expedition_RankData = id(),
    EID_Expedition_RefreshScroe = id(),
    --抽卡召唤
    SUMMON_DATA_CHANGED = id(),
    SUMMON_AGAIN_DATA_CHANGED = id(),

    -- Vip
    VIP_EXP_CHANGED = id(), -- Vip经验值变化
    VIP_LV_CHANGED = id(), -- Vip等级变化

    -- 百人道场
    HUNDRED_DOJO_CHALLENGE_NUM_CHANGED = id(),
    HUNDRED_DOJO_BASE_TIME_CHANGED = id(),
    HUNDRED_DOJO_SELF_AREA_DATA_CHANGED = id(),
    HUNDRED_DOJO_OTHER_AREA_DATA_CHANGED = id(),
    HUNDRED_DOJO_LOG_CHANGED = id(),
    HUNDRED_DOJO_GET_REWARD_COMPLETED = id(),
    HUNDRED_DOJO_QUERY_AREA_DATA_COMPLETED = id(),
    HUNDRED_DOJO_LOCATION_AREA_CHANGED = id(),
    HUNDRED_DOJO_SLOGAN_CHANGED = id(),

    -- 支付
    PAY_CLIENT_COMPLETED = id(), -- 客户端收到第三方支付完成 （不能用这个来判定实际支付后的获得）
    PAY_SERVER_COMPLETED = id(), -- 服务端推送到支付完成 (不一定是当前支付的结果)
    PAY_TOTAL_RECHARGE_CHANGED = id(), -- 累计充值变化
    PAY_DAY_RECHARGE_CHANGED = id(), -- 当日充值变化

    ROLE_UI_REDPOINT_CHANGE = id(),

    CLOSE_NEW_FUNC_PAGE = id(),

    SIGN_UP_SUCCESS = id(),
    ACTIVITY_SIGN_SUCCESS = id(),

    BATTLE_CHALLENGE_TIME_REFRESH = id(),

    FRIEND_INVITATION_MASTER_INFO_REFRESH = id(),
    FRIEND_INVITATION_QUERY_MASTER_INFO = id(),
    FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO = id(),
    FRIEND_INVITATION_QUERY_STUDENT_SINGLE_INFO = id(),
    FRIEND_INVITATION_QUERY_STUDENT_LIST_INFO_REFRESH = id(),

    LIMIT_RECHARGE_OPEN_NTF = id(),
    LIMIT_RECHARGE_OPEN_UI_NTF = id(),
    LIMIT_RECHARGE_PAY_SUCCESS_NTF = id(),

    SEASON_NOTICE_CLOSE_NTF = id(),
    SEASON_RANK_CHANGED_NTF = id(),

    --冲榜入口显示状态
    RANK_ACTIVITY_DISPLAY_NTF = id(),
    RANK_ACTIVITY_REWARD_SUCCESS_NTF = id(),

    --收集屋道具升级返回
    KEEPSAKE_LEVEL_UP_SUCCESS_NTF = id(),
    --兑换码成功
    EXCHANGE_REWARD_SUCCESS = id(),

    --问卷调查成功
    QUESTION_REWARD_SUCCESS = id(),

    --当前Server改变
    CURRENT_SERVER_CHANGED = id(),
    CURRENT_SPECIAL_INFO_CHANGED = id(),

    --精彩活动 全局数据刷新
    ACTIVITY_GLOBAL_REFRESH = id(),

    --战令悬赏入口显示状态
    AIRSHIP_ACTIVITY_DISPLAY_NTF = id(),

    --转盘
    TRUNWHELL_EVENT_CLOSE_REWARD = id(),--关闭本轮
    TRUNWHELL_EVENT_LOG_ACK = id(),--获奖日志
    TRUNWHELL_EVENT_LOG_NTF = id(),--添加获奖日志
    TRUNWHELL_EVENT_REFRESH_ACK = id(),--刷新道具
    TRUNWHELL_EVENT_OPEN_REWARD_ACK = id(),--本轮开始
    TRUNWHELL_EVENT_REWARD_ACK = id(),--收到奖励

    --红包现金刷新
    RED_ENVELOPE_REMAIN_TIME_REFRESH = id(),
    RED_ENVELOPE_CASH_EXCHANGE_SUCCESS = id(), --现金红包兑换成功

    --宠物冲榜数据刷新
    PET_RANK_QUERY_ACK_REFRESH = id(),
    --技能压制冲榜数据刷新
    SKILL_RANK_QUERY_ACK_REFRESH = id(),

    --宠物印记
    PET_STAMP_LEVEL_UP_REFRESH = id(),
    PET_STAMP_SLOT_REFRESH = id(),

    -- 远航试炼
    VOYAGE_CHALLENGE_NUM_CHANGED = id(),
    VOYAGE_NUM_CHANGED = id(),
    VOYAGE_AIRSHIP_CHANGED = id(),
    VOYAGE_SELF_AIRSHIP_DATA_CHANGED = id(),
    VOYAGE_RANK_CHANGED = id(),
    VOYAGE_CHECK_AIRSHIP_CHANGED = id(),
    VOYAGE_LOG_CHANGED = id(),
    VOYAGE_LOCATION_CHANGED = id(),

    DOJO_CHALLENGE_RESULT_CHANGED = id(),
    --神器事件
    SKILL_EQUIP_LV_UP_REFRESH = id(),
    SKILL_EQUIP_SLOT_REFRESH = id(),
    SKILL_EQUIP_SLOT_LVUP_REFRESH = id(),
    SKILL_EQUIP_DECOMPOSE_REFRESH = id(),
    SKILL_EQUIP_REFORGE_SUCCESS = id(),
    SKILL_EQUIP_POOL_REFRESH = id(),
    EID_SKILL_EQUIP_ADD_LIST = id(),
    SKILL_EQUIP_SHIFT_REFRESH = id(),

    --伙伴形象刷新
    PARTNER_EQUIP_REFRESH = id(),
    SKILL_EQUIP_RP_REFRESH = id(),

    --pvp爬塔战斗结束
    EID_SHUT_PVPCIMBINGBATTLE = id(),

    --宠物契约
    QIYUE_PET_CHANGE_SUCCESS = id(),
    QIYUE_TOGGLE_JUMP_TRIGGER = id(),
    QUERY_PET_QIYUE_ATTRS_SUCCESS = id(),

    COMBINE_SERVER_TIME_CHANGED = id(),
    COMBINE_SERVER_CONTENT_CHANGED = id(),

    TT_RECORD_START = id(),
    TT_RECORD_FINISH = id(),
}

return UIEventNames