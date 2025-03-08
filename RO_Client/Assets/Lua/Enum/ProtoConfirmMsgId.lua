    local ProtoConfirmMsgId = {
        	CS_RENAME_REQ                    = 1031,		--	改名 **CSRenameReq **login.proto **game [CSRenameReq][confirm]
	CS_PLAYER_INCOME_REQ             = 1171,		--	收益相关处理(online/offline) **CSPlayerIncomeReq **login.proto **game [CSPlayerIncomeReq][confirm]
	CS_PLAYER_BOSS_REWARD_REQ        = 1173,		--	挑战boss奖励 **CSPlayerBossRewardReq **login.proto **game [CSPlayerBossRewardReq][confirm]
	CS_ARENA_RESULT_REQ              = 1206,		--	挑战结果(失败/成功) **CSArenaResultReq **login.proto **game [CSArenaResultReq][confirm]
	CS_NEW_MAP_CARTOON_REQ           = 1256,		--	大地图动画 **CSNewMapCartoonReq **login.proto **game [CSNewMapCartoonReq][confirm]
	CS_CLIMBING_TOWER_END_REQ        = 1271,		--	CSClimbingTowerEndReq **CSClimbingTowerEndReq **login.proto **game [CSClimbingTowerEndReq][confirm]
	CS_GUILD_BOSS_CHALLENGE_REQ      = 1325,		--	挑战boss **CSGuildBossChallengeReq **login.proto **game,guild [CSGuildBossChallengeReq][confirm]

    }
    return ProtoConfirmMsgId
