# <center>RO项目说明</center>
## 目录结构说明
### 常规目录
| 路径 | 说明 |
|:-------|:-------|
| [Assets](#Assets) | 游戏主体资源
| BMFont          | 位图字体工具 (已废弃)
| Build           | 编译目标版本使用到的资源路径
| Library         | Unity工具自身的存放的数据路径
| Packages        | Unity第三方库引用描述文件
| ProjectSettings | Unity项目的设置存放路径
| ProtocolGen     | google protobuf 转lua 的工具
| .gitignore      | git忽略设置文件
### 临时目录
| 路径 | 说明 |
|:-------|:-------|
| assetbundle     |ab输出的临时路径
| assetbundleBak  |ab输出的缓存路径
| Logs            |Packages工具日志路径
| obj             |C#编译的临时路径
| Temp            |Unity工具自身的存放的临时数据路径 


#### Assets
| 路径 | 说明 |
|:-------|:-------|
| _Discard        |存放过期或将要过期的资源
| AppInfo         |编译时才使用的资源 （图标和闪屏）
| ArtScript       |特效使用的脚本
| CinemachinePostProcessingV2 |镜头控制插件
| [Content](#Assets/Content)         |游戏中使用到的美术资源（基本上所有的美术资* 都在里面，除场景资源）
| Editor          |自定义的编辑工具
| Flux            |技能编辑器引用的插件
| Gizmos          
| [Lua](#lua部分代码说明)             |游戏的lua代码
| LuaProfilerClient   |lua性能分析器
| LuaTools        |csv转lua配置工具
| MeshBaker       |Mesh合并工具
| Plugins         |插件目录
| Resources       |由于游戏都走AB加载，基本不再有什么资源放入
| Scenes          |所有的场景和相关资源
| Shaders         |游戏中自定义的Shader
| [Src](#C#部分代码说明)             |游戏的C#代码
| T4M             |T4M工具
| T4MOBJ
| TextMesh Pro    |TextMesh默认资源
| ToLua           |tolua相关代码
| game.unity      |游戏启动场景
| relogin.unity   |游戏进入重登时的场景
| *.unity         |剩下的一些测试场景（只和编辑有关，和运行无关）

##### Assets/Content
| 目录 | 说明 |
|:-------|:-------|
| Audio           |音频资源
| Config          |csv配置表，C#中使用的配置表
| Fonts           |字体文件
| Icons           |游戏中的Icon，策划配置，程序加载显示
| Lua             |编译时，lua临时缓存路径 因为.lua文件无法直接打ab包，转.txt
| Materials       |通用材质球
| PosProfiles     |PostProcess效果的配置 (目前只用于创角)
| Prefabs         |所有程序直接使用的Prefab
| Raw_Art         |美术的原始资源 （比如Prefab引用到的资源，程序不直接调用）
| TimeLine        |TimeLine配置 （游戏中暂未用上）
| ToLua           |编译时，tolua临时缓存路径 因为.lua文件无法直接打ab包，转.txt
| Xml             |xml配置，C#中使用的配置（包含技能，场景出生点等配置）


## Unity项目中自定义工具说明

| 菜单项 | 说明 |
|:-------|:-------|
|Assets/CheckSceneDep | 检查场景依赖
|Assets/设置PackingTag | 手动设置图集合并Tag
|Assets/OptModel      | 优化模型
|Assets/SaveRTToPPNG  | 把RenderTexture转PNG
|Assets/FindImageReferences |找出图片被谁引用
|Assets/FindMatReferences |找出材质球被引用
|Assets/CheckFileName |查看文件全名
|Assets/RO/清理Animator |清理预制体上默认的Animator组件
|Assets/更新动画数据    |
|Assets/ExportMesh           | 导出成Mesh文件
|Assets/GenerateLuaClass     | 对某个UI预制体生成标准化脚本
|SkillTool/Frame Event Panel/Open Editor | 技能编辑器
|SkillTool/启动训练营测试   |测试技能（未再维护，功能缺失）
|[快捷启动]/[启动游戏] |快速启动游戏
|Lua/*  |tolua工具（用于生成lua调用C#的绑定文件）
|Cinemachine/* | Cinemachine工具
|RO_Tool/* |RO项目中特殊工具
|AssetBundle/* |不再使用设定AssetsLabels来生成AB，已淘汰
|AssetBundle/打包工具 |用于打包版本
|Tools/* |包含一些小工具

## C#部分代码说明
```flow
game.scene=>start: game.scene
Start=>operation: Start(GameMgr.cs)
是否启动=>condition: 是否启动
StartLaunch=>operation: StartLaunch(LaunchLoadMgr.cs)
Update=>operation: Update(GameMgr.cs)
EnterLuaLogin=>operation: EnterLuaLogin(GameMgr.cs)
是否退出游戏=>condition: 是否退出游戏
QuitGame=>end: QuitGame(GameMgr.cs)

game.scene->Start->是否启动

是否启动(yes)->StartLaunch->EnterLuaLogin->Update->是否退出游戏
是否启动(no)->Update->是否退出游戏

是否退出游戏(yes)->QuitGame
是否退出游戏(no)->Update

```
**C#部分的主体逻辑如上流程**

GameMgr.cs 	C#与lua层交互。c#层面战斗开始入口，销毁。
相关战斗功能函数： 
1. 重登、断线重连：ReLogin （负责：销毁战斗、清空战斗数据。）流程:停止战斗、通知lua层UI 、lua层处理完毕、调回C#层 清理数据
2. 设置属性数据：SetTeamData（负责：同步战斗角色相关属性数据）流程：由lua层调用通知修改、分为强制同步，与延迟同步。强制同步：如果在战斗中会结束战斗同步属性属性、刷新加载相关技能、时装。延迟同步：设置为脏标记、下次战斗开始时同步相关属性、技能加载、时装等。
3. 更新技能数据：UpdateTeamSkills（负责更新角色技能信息）流程：停止当前战斗、强制同步刷新技能或标记为脏标记下次战斗开始时同步刷新技能
4. 战斗入口：PreloadBattle 、PreloadVersusBattle、PreloadBossBattle、PreloadTimeBattle（负责新的战斗开始）流程：停止当前战斗、设置当前战斗角色属性、创建新的战斗实例、启动战斗
5. 战斗结束：ShutDownBattle（负责停止 当前战斗）包含是否销毁操作、用于断线时的操作、只停止战斗、后UI层处理完成后、在执行销毁操作
6. 负责逻辑层打断正常停止战斗 ForceStopBattle（在战斗流程中，正常打断返回战斗结束、具体停止操作对应不同战斗实例的重载）
7. 游戏速度：SetGameSpeed、SaveGameSpeed（设置游戏速度、以及设置保存游戏速度）

BattleSystemNew.cs  c#层战斗管理、负责管理整场战斗
相关战斗功能函数： 
1.	相关战斗事件注册：Start （负责注册监听相关战斗事件、以及初始化）流程：现有初始化战斗飘字管理器、监听战斗事件、设置游戏速度
2.	战斗总更新：Update (c#层面所有战斗更新)
UpdateLogic更新战斗逻辑层（目前更新战斗实例逻辑）换算为帧时间更新
UpdateTrigger更新触发层（目前更新全局事件处理新手定制战斗）
UpdateElse更新其他（目前战斗item掉落 表现）
3．最后更新：LateUpdate用于camera 表现更新
4. 战斗统计：GetBattleStatistics、HasBattleStatistics （获取战斗统计、用于UI界面显示）
5. 获取战斗剩余时间：GetLeftFightingTime （只在time模式的战斗有效）
6. 开始战斗实例：StartBattle、StartVersusBattle、StartBossBattle、StartTimeBattle、StartNewbieBossBattle（设置战斗结束条件、创建战斗实例并且开启）
7. 播放录像：ReplayTimeBattle（播放录像战斗、解析录像json、设置战斗结束条件、创建战斗实例且开始）
8. 下一场战斗：EnterNextBattle （巡游战斗中开始下一场战斗）
9. 获取出身点：GetFieldSummonPos （返回位置、角度）
10. 暫停戰鬥：DoPauseFight （更具不同戰鬥实例，有不同实现。供外部调用）暂停会记录暂停标记、已有暂停标记会停止逻辑更新、战斗逻辑状态切换
11. 给战斗添加战斗角色：AddActorToBossBattle（目前BOSS战斗用到、传递角色属性数据）对应BOSS战流程：如果战场不存在角色则创建战斗角色（通过角色管理添加角色） FighterMgr.AddFighter、同时异步加载角色f.Ctrl.AsyncLoad()、加载完成后放入战斗f.Spawn（初始化角色战斗属性、、）战斗落位EnterSeat、保存添加角色操作到录像
12. 异步加载角色完成回调OnFighterAsyncLoaded（目前使用在AddActorToBossBattle添加中设置回调）
13. 战斗角色操作：RemoveActorFromBossBattle、SetActorDead、SetActorDeadSyncBossLife（目前BOSS战斗实现）
14. 竞技场战斗相关：SetVersusActors、BeginVersus、
15. 解析角色参数实例化为角色属性：ParseTeamActors（根据ActorParam结构信息实例化角色属性）
16. 销毁当前战斗：DisposeCurrentBattle(清空实例)销毁资源对象、战斗角色对象、预加载池、相机、声音
17. 关闭当前战斗：ShutDownCurrentBattle（清空数据、参数代表是否销毁）1.停止战斗逻辑、引用置空、清空数据。2.如带有销毁标记调用销毁DisposeCurrentBattle
18. 播放录像：Replay（该接口使用在巡游BOSS模式录像）流程：停止当前巡游战斗、开启录像战斗
19. 清空战报：ClearBattleLog （清空本场战斗战斗日志）
20. 停止战斗：ForceStopBattle （目前部分战斗中实现打断、巡游战斗、巡游BOSS战、爬塔战斗）
21. 相机相关：SetBattleCamera、DisableBattleCamera、SetBossBattleCamera、SetFollowCamera、LookAtBattleFieldCenter、PerformStartCamera、EnterBossIntro、ExitBossIntro、ShowComingCamera、PlayComingCameraAnim、HideComingCamera、IsPlayingComingCamera、
22. 场景相关：ActiveSceneAnim（参数传递对象名。动画名。是否激活）ActiveSceneGo（激活场景对象）
23. UI相关：SetUINodeVis（设置激活UI节点、目前新手战斗中使用）、OnRefreshBattleOutput刷新UI战斗输入日志、RefreshStatistics  更新战报、RefreshMinimap刷新小地图
24. 战斗正式开始：OnFightingStart（所有战斗准备完成后。正式开始战斗）流程：开启战斗UI、设置战斗速度、通知战斗UI层开始战斗
25. 同步战斗角色属性数据SyncTeams（参数是否强制设置）标记为脏标记、战斗开始时会根据脏标记同步属性、或有强制标记为结束当前战斗、立刻同步属性、刷新时装、技能、角色模型等
26. 技能更新脏标记相关： ClearSkillDirty、UpdateTeamSkills、 CheckSkill、ForceSyncSkill
27. 职业技能脏标记相关：SetProfessionDirty、CheckProfession、
28. 角色属性脏标记 ：SetTeamData
29. 战斗事件相关：OnChallengeBoss（开始挑战巡游BOSS）OnCloneNewBoss（拷贝boss角色实例）OnBossSpawned（boss出身）OnBattleNewWave（巡游下一关通知）OnContinueBattle（继续当前关卡通知）OnShowBossRage（BOSS必杀）OnShowBossRageLeftTime（BOSS必杀时间通知）OnBossInRage（BOSS进入必杀）OnFighterHurt（角色被击伤害）OnFighterCastSkill（角色释放技能）OnShowBossBuffIcon（显示bossbuff）OnRemoveBuffIcon（移除bufficon）OnFighterLifeChanged（角色生命变化）¬ OnFighterEnergyChanged（sp变化）OnFighterSkillCDChanged（技能cd变化）OnShowFighter（显示角色、新手战用到）OnShowSkillPrefab（技能中加载prefab）OnCloseSkillPrefab（技能中关闭prefab）OnBattleUIVis（战斗UI显示）
30. lua调用战斗录像开始：ReplayBattle（解析战斗录像为json对象。根据json对象创建录像并且开启录像战斗）OnReplayEnd（录像结束.通知录像UI结束）23.战斗结束：OnBattleEnd（战斗结束处理）根据不同战斗类型处理不同战斗结束，分发不同UI战斗结果通知
31. 强制战斗结束：OnBattleForceStop 处理强制战斗结束的事件分发UI层
32. 战斗胜利：OnBattleWin 处理战斗胜利结果并通知对应UI层
33. 战斗失败：OnBattleFailed处理战斗失败结果并通知对应UI层
34. boss警告显示：ShowBossWarning
35. 巡游战斗开始巡游：OnBeginSearch（创建添加角色到战斗。设置跟随camera）
36. 异步加载角色完成后的通知：OnLoadTeam
37. 录像角色加载完成后的通知：OnReplayBattleLoadedOk
38. 开始加载角色处理：LoadRole（lua通知处理、加载标记设置、预加载角色load）
39. ui层创建角色的回调：OnLoadRoleCompleted
40. 刷新角色模型：NotifyRefreshRoleView脏标记、CheckRoleModel（根据脏标记bRoleModelDirty 是否更新由lua层更新RefreshRoleView）
41. 开始加载处理：OnLoadBegin（通知lua层加载开始）OnLoadComplete（加载完成通知lua）OnLoadProgress（加载进度lua通知）

Actor文件夹处理角色属性数据：
ActorDat.cs基类实现有：伙伴、主角、宠物。一级属性、二级属性、技能、avatar、buff、mark等相关数据。
ActorDataMgr.cs 角色属性管理：创建、移除、检查
BaseBattle.cs负责包含战斗整体（BattleField）逻辑控制、战斗角色管理、随机种子、战报、战斗事件注册和调度、
 (basebattle派生有TimeBattle.cs、VersusBattle.cs、LogicBattle.cs、BossBattle.cs)对应不同战斗类型

BaseBattleScene.cs负责战斗场景加载、出生点、战斗点、场景天空材质
（派生有：BossBattleScene、VersusBattleScene、TimeBattleScene、LogicBattleScene）

LogicField.cs 基础逻辑块 包含有位置信息以及操作（派生有: BattleField）

BattleField.cs负责战斗中某一阶段的逻辑模块.包含该模块战斗角色
（派生有: BossBattleField、VersusBattleField、LogicBattleField、TimeBattleField）


所有战斗组成：（差异业务逻辑不同、具体业务看需求）
Battle、BattleState、BattleField、BattleScene
1.	BattleState：创建管理多个战斗节点状态（战斗预加载、战斗开始、战斗中、战斗胜利、战斗失败、战斗结束）每个状态包含对应进入，退出。用于控制整场战斗（大的战场。包含有若干个小的子战斗）
2.	BattleField：创建管理每场战斗中的战斗逻辑节点状态（准备阶、过场、角色跑到战场、战斗、胜利、失败、结束）（大战场里面的子战斗）
3.	BattleScene:战斗场景的加载、出身点的获取、天空材质等
4.	Battle管理BattleField、BattleState、BattleScene、ActorData交互调度

FighterManager角色管理类：创建、销毁、复活
Fighter角色类：派生自LogicTransfor逻辑移动类
变量：FighterAi 角色AI控制（自动调用释放技能）
PassiveMove 移动控制
FighterStateData 角色状态数据
角色状态FighterState
角色技能数据FighterSkillStateData
角色buff管理FighterBuffManager
角色效果管理FighterBuffFunctionMgr
角色Mark管理MarkMgr
角色控制FighterGoCtrl

角色战斗属性PlayerActorBattleAttr 战斗中使用用到的属性，参与战斗计算
方法：CreateFighter根据ActorData角色属性创建。
          ForceIdle、ForceComing、ForceBreak设置切换角色状态
          ChaseTo 移动到Figher一定范围
          AutoMoveTo 移动到坐标
OnFightingStart 战斗开始通知调用：启用角色AI、关闭寻路、刷新角色HP、SP等UI操作
OnFightingEnd 战斗结束调用：关闭AI、清空角色BUFF和效果，开启寻路
CheckPassiveSkill 被动技能释放激活
DoPassiveSkill 指定释放激活一个被动技能
GetPassiveSkill 获取被动技能
OnEnterRage 狂暴状态的buff释放
GetAttrByType 获取角色属性
HaveBuffFunction 是否存在buff效果
RemoveFunctionByFunType 移除buff效果
GetBuffFunctionValue 获取buff效果对应值
GetMarkFunVal 获取mark对应值
Dispose 清空角色包含数据
Destroy 销毁角色
AutoRunToFieldFightPosition 是否可以跑向战斗点
CanMove 是否可移动判断
CastBuff 释放一个buff
GetSkill 获取技能
Spawn 战场出身：加载模型、设置出身位置、初始化战斗属性、初始化战斗状态
DoBeHit 被攻击：切换到被攻击状态
CanDoTriggerAction 是否可以切换到指定状态
CanDoSkill 是否可以释放该技能，判断是否在不可释放状态、是否CD未到、SP消耗是否足够、选取目标、距离内是否有目标、目标距离不够则移动到目标（同时判断是否可移动）
CheckDoSkill 是否可以释放技能，如果可以，释放。
ForceDoSkill 强制释放一个技能
ProcessTriggerSkillBuff 事件触发BUFF处理
ProcessTriggerBuff  被动技能的触发buff处理
AddTriggerBuffData 添加触发BUFF数据
CheckPassiveBuffCaster 是否可以触发被动效果判断
ProcessBeHit 被攻击处理
ProcessReflectDamage 反弹伤害处理
EndSkill 结束技能处理，参数是否被打断
ChangeSkill 替换技能
LoadSkills 技能预加载

战斗AI
FighterAi.cs Update优先检测释放技能其次检测释放普攻，技能释放成功取下一个技能继续尝试释放mFighter.CheckDoSkill

AI攻击流程：尝试释放技能、释放成功后累计下一个尝试释放、mFighter.CheckDoSkill是否可释放、mFighter.ProcessTrigger切换技能状态、进入角色Attack状态、进入状态后调用FighterSkillStateData.OnEnter释放角色技能、并记录当前释放技能相关信息、调用触发技能BUFF、BUFF中读取相关buff.XML配置文件、触发事件。BattleBuff.ProcessEvent处理相关事件

技能运行中FighterSkillStateData.UpdateFrame检测技能帧是否播放完毕并标记。外层Attack状态根据标记状态退出攻击状态.完成一次攻击
战斗buff

根据BUFF SkillActionFrameEvent 数据，更新帧事件。生命周期自身计算


## lua部分代码说明
```flow
OnConfigMgrInited=>start: OnConfigMgrInited(LaunchLoadMgr.cs)
InitMgr=>operation: InitMgr(LuaMgr.cs)
LuaMain:Init=>operation: LuaMain:Init(LuaMain.lua)
LuaMain:Start=>operation: LuaMain:Start(LuaMain.lua)
LuaMain:Update=>operation: LuaMain:Update(LuaMain.lua)
LuaMain:EnterLogin=>operation: LuaMain:EnterLogin(LuaMain.lua)

OnConfigMgrInited->InitMgr->LuaMain:Init->LuaMain:Start->LuaMain:Update->LuaMain:EnterLogin

```
**lua启动逻辑如上流程**

| 目录 | 说明 |
|:-------|:-------|
| Assets/Lua/Config |放置的lua配置文件
| Assets/Lua/Core   |启动文件，平台设置，通用设置等
| Assets/Lua/Entities   |早期做场景互动功能使用，当前版本无用
| Assets/Lua/Enum  |枚举数据
| Assets/Lua/ForceGuide |强制引导相关
| Assets/Lua/FSMState |lua中的状态机
| Assets/Lua/FuncUnlockCondition |功能解锁的判定条件
| Assets/Lua/GmCommond |gm工具
| Assets/Lua/Logic |游戏的逻辑数据保存地方
| Assets/Lua/Managers |一些调度的管理类
| Assets/Lua/Pb google |protobuf协议文件
| Assets/Lua/RedPoint | 红点逻辑
| Assets/Lua/System       | 通用功能
| Assets/Lua/UI         |所有的UI逻辑（vc）