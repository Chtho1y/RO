

public struct AntiCheatCfg
{
    public const float c_fTimeScaleCheckTime = 3.0f;       //timescale 检测间隔(s)
    public const float c_fTimeSysteCheckTime = 0.0f;       //系统时间  检测间隔(s)
    public const float c_fTimeScaleMaxValidTime = 2.0f;    //最大有效速度
    public const float c_fTimeScaleNorlValidTime = 1.0f;   //正常速度
    public const int c_nTimeSysteMaxDurationTime = 10;      //服務器时间间隔-本地时间间隔 最大时差(s)
    public const float c_fErrorTime = -1.0f;
    public const string c_strUIPageWndId = "2100";           //错误窗口
    public const float c_fDeltaServerTime = 65f;          //網絡延遲 大於延遲 不計算加速排除網絡延遲嚴重的誤判65 - 62 = 3s延迟)
}

public enum EnAntiCheatType
{
    enSystemTime = 0,   //检测系统时间
    enScaleTime,        //检测加速速率
    enDefault,          //必须在最下面 用于默认跟数量
}

