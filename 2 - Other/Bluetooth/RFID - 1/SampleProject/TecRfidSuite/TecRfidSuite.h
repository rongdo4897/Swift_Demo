//
//  TecRfidSuite.h
//  TecRfidSuite
//
//  Created by T.Kubota[ASNO] on 2014/03/17.
//  Copyright (c) 2014年 TOSHIBA TEC CORPORATION. All rights reserved.
//
//  #060 2014/11/14 [ASNO]Y.Fukasawa iOS8/iPhone6対応、機能強化
//  #061 2015/04/27 [ASNO]H.Takagi UF-2200免許局対応
//  #062 2015/05/13 [ASNO]H.Takagi 複数フィルタ機能追加
//  #064 2015/06/19 [ASNO]T.Kubota OptionsPackにMultiFilterEnsure追加
//  #065 2015/06/19 [ASNO]T.Kubota MultiFilterEnsureの追加に伴い、SetFilterLengthメソッドの削除
//  #069 2015/09/03 [ASNO]H.Takagi セッションID,フィルタ設定値取得機能追加
//  #072 2016/01/12 [ASNO]H.Takagi トリガ状態監視機能追加
//  #073 2016/02/25 [ASNO]H.Takagi 電波上CRCチェック抜け対策
//  #075 2017/03/11 [ASNO]Y.Fukasawa G2iMタグ対応
//  #076 2017/03/14 [ASNO]Y.Fukasawa 1W対応
//  #077 2017/04/03 [ASNO]H.Takagi スキャナ対応
//  #078 2017/05/19 [ASNO]H.Takagi 業務別タグ読取モード設定対応
//  #080 2018/01/22 [ASNO]H.Takagi iOS11対応
//  #083 2018/07/10 [ASNO]H.Kobayashi 電波強度段階切替機能追加
//  #084 2018/08/17 [ASNO] H.Takagi フラグAB設定書き込み・取得機能追加
//  #086 2018/09/21 [ASNO] H.Takagi 位相技術対応
//  #087 2018/12/07 [ASNO] H.Takagi 位相機能不具合対応
//  #088 2018/12/07 [ASNO] H.Takagi 新規TDコマンド機能追加対応
//  #092 2019/06/20 [ASNO] Y.Fukasawa 誤読防止機能対応
//  #093 2020/02/20 [ASNO] H.Takagi TIDバンク読み取り機能追加
//  #095 2020/03/25 [ASNO] H.Takagi UF-3000デバイスUSB,BLE対応
//  #097 2020/08/31 [ASNO] H.Takagi UF-3000FW新機能対応
//  #100 2020/09/24 [ASNO] H.Takagi FW更新機能追加
//  #104 2021/07/09 [ASNO]CuongTV 特小局の最大出力の誤り訂正
//  #105 2021/07/22 [ASNO]CuongTV チャネル33_38の追加
//  #106 2021/07/20 [ASNO]CuongTV 二度読み設定対応
//  #107 2021/07/28 [ASNO]CuongTV タグ読み取り中、エラー発生時のEPCデータを読み捨てない対応
//  #108 2021/08/02 [ASNO]CuongTV フィルタ設定パフォーマンス改善
//  #109 2021/07/06 [ASNO]CuongTV QRコード中の漢字表示
//

#import <Foundation/Foundation.h>


/////////////////////////////////////////////////////////////////////
// ◆◆定義等
/////////////////////////////////////////////////////////////////////

//◆戻り値
#define OPOS_SUCCESS 0
#define OPOS_E_CLOSED 101
#define OPOS_E_CLAIMED 102
#define OPOS_E_NOTCLAIMED 103
#define OPOS_E_NOSERVICE 104
#define OPOS_E_DISABLED 105
#define OPOS_E_ILLEGAL 106
#define OPOS_E_NOHARDWARE 107
#define OPOS_E_OFFLINE 108
#define OPOS_E_NOEXIST 109
#define OPOS_E_EXISTS 110
#define OPOS_E_FAILURE 111
#define OPOS_E_TIMEOUT 112
#define OPOS_E_BUSY 113
#define OPOS_E_EXTENDED 114
#define OPOS_E_RUNNING 151
#define OPOS_E_NOTAG 152
#define OPOS_E_ARG 153
#define OPOS_E_NEGO 154
#define OPOS_E_BREAK 155
#define OPOS_E_UNAVAILABLE 156 //#086 ADD
#define OPOS_E_EXCEPTION 201
#define OPOS_E_RES 301
#define OPOS_E_OPT 401
#define OPOS_E_READFILE 501//#077 ADD
#define OPOS_E_WRITEFILE 502//#078 ADD

//#078 ADD Start
/** バーコードスキャナ搭載機種未判定 */
#define INDEFINITE_SCANNER_ERROR 2
/** バーコードスキャナ未搭載機種 */
#define NON_AVAILABLE_SCANNER_ERROR 3
/** タグ読取モード設定機能搭載機種未判定 */
#define INDEFINITE_TAGREADMODE_ERROR 4
/** タグ読取モード設定対応端末ではない */
#define NON_AVAILABLE_TAGREADMODE_ERROR 5
//#078 ADD End
//#092 ADD Start
/** 誤読防止機能機能搭載機種未判定 */
#define INDEFINITE_TRUNCATE_ERROR 0
/** 誤読防止機能対応端末ではない */
#define NON_AVAILABLE_TRUNCATE_ERROR 1
//#092 ADD End

//◆ステータス
#define OPOS_S_CLOSED 1
#define OPOS_S_IDLE 2
#define OPOS_S_BUSY 3

//◆引数指定値
//◇タイムアウト無限待ち
#define OPOS_FOREVER -1

//◇通信タイムアウト最大[ms]
#define COMMUNI_MAX_TIMEOUT 600000

//◇Q値 最小-最大
#define Q_MIN 0
#define Q_MAX 15
//#060 Add Start
//#062 Add Start
//◇SelectMultipleTagEnable/SelectMultipleTagDisable用
//フィルタマスクサイズ
#define FILTER_MASK_TOTAL_SIZE  544
//#108 add start
//フィルタ1つあたりのサイズ
#define FILTER_SIZE  224
//#108 add end
//インデクサ最小値・最大値
//#define SELECT_INDEXER_MIN  0
#define SELECT_INDEXER_MAX  7
//サイズ最小値[bit]
#define SELECT_SIZE_MIN     1
//マスクレングスデフォルト値[bit]
#define FILTER_LENGTH     64
//マルチフィルタ用の倍数ビット数
#define FILTER_JUST       32
//#062 Add End
//#073 Add Start
//二度読み用最大保持時間デフォルト値[ms]
#define TWICE_DUPLICATE_TIME     60000
//二度読み用最大件数デフォルト値
#define TWICE_DUPLICATE_BUFLEN     10000
//#073 Add End
//◇ログサイズ
#define LOG_DEFAULT_SIZE_MB 10
#define LOG_MIN_SIZE_MB     1
#define LOG_MAX_SIZE_MB     999
//#060 Add End
/////////////////////////////////////
// "ReadTags" Methods Constants
/////////////////////////////////////////////////////////////////////
#define RFID_RT_ID                 1    // Read only the ID data
#define RFID_RT_FULLUSERDATA       2    // Read the full UserData
#define RFID_RT_PARTIALUSERDATA    4    // Read the defined partial UserData
#define RFID_RT_ID_FULLUSERDATA    3    // Read the ID and full UserData
#define RFID_RT_ID_PARTIALUSERDATA 5    // Read the ID and the defined partial UserData
#define RFID_RT_TID 6   // Read the ID and the defined partial TIDData //#093 Add

/////////////////////////////////////////////////////////////////////
// Dictionary Pack key
/////////////////////////////////////////////////////////////////////
//TagPack
#define KTP_TAGID @"TagID"
#define KTP_USERDATA @"TagUserData"
#define KTP_CRC @"TagCRC"
#define KTP_PC @"TagPC"
#define KTP_RSSI @"TagRSSI"
#define KTP_EPCEX @"TagEpcEx"   //#075 ADD
#define KTP_TIDDATA @"TagTIDData"//#093 Add
//#086 ADD Start
#define KTP_ANTENNA @"TagAntenna"
#define KTP_POWER @"TagPower"
#define KTP_FREQUENCY @"TagFrequency"
#define KTP_PHASE @"TagPhase"
#define KTP_READ_TIME @"TagReadTime"
//#086 ADD End
#define KTP_EXDATA @"TagEXData"//#087 ADD

//RssiPack
#define KRP_CH05 @"RssiCh05"
#define KRP_CH11 @"RssiCh11"
#define KRP_CH17 @"RssiCh17"
#define KRP_CH23 @"RssiCh23"
#define KRP_CH24 @"RssiCh24"
#define KRP_CH25 @"RssiCh25"
#define KRP_CH26 @"RssiCh26"
#define KRP_CH27 @"RssiCh27"
#define KRP_CH28 @"RssiCh28"
#define KRP_CH29 @"RssiCh29"
#define KRP_CH30 @"RssiCh30"
#define KRP_CH31 @"RssiCh31"
#define KRP_CH32 @"RssiCh32"
//#105 Add Start
#define KRP_CH33 @"RssiCh33"
#define KRP_CH34 @"RssiCh34"
#define KRP_CH35 @"RssiCh35"
#define KRP_CH36 @"RssiCh36"
#define KRP_CH37 @"RssiCh37"
#define KRP_CH38 @"RssiCh38"
//#105 Add End

//オプション設定キー
#define KOP_TIMEOUT @"Timeout"
#define KOP_ZERO_FIRE @"ZeroFire"
#define KOP_LOG_OUTPUT @"LogOutput"
#define KOP_LOG_LEVEL @"LogLevel"
#define KOP_LOG_SIZE @"LogSize"                         //#060 Add
#define KOP_FULL_USER_DATA_SIZE @"FullUserDataSize"
#define KOP_MULTI_FILTER_ENSURE @"MultiFilterEnsure"    //#064 ADD
#define KOP_TWICE_DUPLICATE_ENABLE @"TwiceDuplicateEnable"//#073ADD
#define KOP_TWICE_DUPLICATE_TIME @"TwiceDuplicateTime"    //#073 ADD
#define KOP_TWICE_DUPLICATE_BUFLEN @"TwiceDuplicateBufLen" //#073 ADD

//#100 Add Start
#define KOP_FW_RETRY_COUNT @"FWRetryCount"
#define KOP_FW_REWRITE_MODE @"FWReWriteMode"
//FW書き換えモード移行リトライ回数
#define FW_RETRY_COUNT_DEFAULT 3
//FW書き換えモードデフォルト値
#define FW_REWRITE_MODE_DEFAULT 0
//#100 Add End

//#077 ADD Start
/** BarcodePackキー */
#define KBP_BARCODE_TYPE @"Type"
#define KBP_BARCODE_LENGHT @"Lenght"
#define KBP_BARCODE_VALUE @"Barcode"
#define KBP_BARCODE_HEXVALUE @"BarcodeHex"//#109 Add
/** SdkOptionPackキー */
#define KSP_SOUND_FILE1 @"SoundFile1"
#define KSP_SOUND_FILE2 @"SoundFile2"
#define KSP_SOUND_MODE @"SoundMode"
/** SdkOptionPackデフォルト値 */
#define KSP_SOUND_FILE1_DEFAULT @"default1.mp3"
#define KSP_SOUND_FILE2_DEFAULT @"default2.mp3"
#define KSP_SOUND_MODE_DEFAULT @"0"
//#077 ADD End

//#095 Add Start
#define UF2200_DEVICE @"UF-2200"
#define UF3000_DEVICE @"UF-3000"
//#095 Add End

/////////////////////////////////////////////////////////////////////
// Type define
/////////////////////////////////////////////////////////////////////

//接続状態
typedef NS_ENUM(NSUInteger,ConnectState){
    ConnectStateNone = 0, // 未接続状態
    ConnectStateOnline = 1, // 接続状態
    ConnectStateOffline = 2 // 切断された状態
};

//#095 Add Start
/** 通信モード */
typedef NS_ENUM(NSUInteger,CommunicationMode){
    /** 通信モード未設定 */
    CommunicationModeNone = 0,
    /** SPP通信モード */
    CommunicationModeSPP = 1,
    /** USB通信モード */
    CommunicationModeUSB = 2,
    /** BLE通信モード */
    CommunicationModeBLE = 3
};
//#095 Add End

//トリガースイッチモードのタイプ
typedef NS_ENUM(NSUInteger,TrigModeType){
    TrigModeTypeRealtime = 1, // 押している間だけ ON
    TrigModeTypeHold = 2, // ホールドモード
    TrigModeTypeNone = 3 //トリガースイッチ無効
};

typedef NS_ENUM(NSInteger,EnergyType){
    EnergyTypeNon = 0, // スリープしない
    EnergyTypeSav = 1 // 電波停止３秒後にスリープ
};

typedef NS_ENUM(NSInteger,ReportSuppleType){
    ReportSuppleTypeNon = 0, // 付加しない
    ReportSuppleTypeAgc = 1  // タグリード時に、電波強度を付加
};

//#083 ADD START
//電波強度段階
typedef NS_ENUM(NSUInteger,WaveStrengthStage) {
    WaveStrengthStage16 = 0,//16段階
    WaveStrengthStage256 = 1//256段階
};
//#083 ADD END

//#084 ADD START
//フラグAB設定
typedef NS_ENUM(NSUInteger,FlagABValue) {
    FlagAB = 0,//A,B両方
    FlagA = 1,//Aのみ
    FlagB = 2//Bのみ
};
//#084 ADD END

//2014.06.17 ADD Start
//ロック対象フィールドのタイプ
typedef NS_ENUM(NSUInteger,LockFieldType){
    LockFieldTypeEPC =    0x00000001, // EPC領域
    LockFieldTypeUser =   0x00000002, // User領域
    LockFieldTypeKillPW = 0x00000004  // Killパスワード領域
};
//2014.06.17 ADD End
//#062 Add Start
typedef NS_ENUM(NSUInteger, SelectCondition){
    SelectIncluding = 0,
    SelectExclusion = 2,
};
//#062 Add End

// 2 度読み照合
typedef NS_ENUM(NSInteger, TwiceDuplicate){
    TwiceDuplicateDisable = 0,  // 無効
    TwiceDuplicateEnable = 1    // 有効
};
//#078 ADD Start
/** タグ読取ミラー副搬送波タイプ */
typedef NS_ENUM(NSUInteger,TagReadMillerType){
    /** Miller2 */
    Miller2Type = 1,
    /** Miller4（デフォルト） */
    Miller4Type = 2,
    /** Miller8 */
    Miller8Type = 3
};
/** タグ読取速度タイプ */
typedef NS_ENUM(NSUInteger,TagReadSpeedType){
    /** FM0 */
    FM0Type = 0,
    /** Miller 中速（デフォルト） */
    MediumSpeedType = 1,
    /** Miller 高速 */
    HighSpeedType = 2,  //#092 UPD(カンマ付加)
    //#092 ADD Start
    /** Miller 低速 */
    LowSpeedType = 3,
    /** FM0 中速 */
    //#097 Change Start
//    FM0MediumSpeedType = 4
    //#092 ADD End
    FM0MediumSpeedType = 4,
    /** FM0 250K */
    FM0250KSpeedType = 5,
    /** FM0 300K */
    FM0300KSpeedType = 6
    //#097 Change End
};
/** スキャナ対応判定状態 */
typedef NS_ENUM(NSUInteger,ScannerDecision){
    /** 不定状態 */
    IndefiniteScannerState = 0,
    /** スキャナ未対応 */
    NonAvailableScanner = 1,
    /** スキャナ対応機種 */
    AvailableScanner = 2
};
/** タグ読取モード対応判定状態 */
typedef NS_ENUM(NSUInteger,TagReadModeDecision){
    /** 不定状態 */
    IndefiniteTagReadModeState = 0,
    /** タグ読取モード未対応 */
    NonAvailableTagReadMode = 1,
    /** タグ読取モード対応機種 */
    AvailableTagReadMode = 2
};
//#078 ADD End
//#092 ADD Start
/** 誤読防止機能対応判定状態 */
typedef NS_ENUM(NSUInteger,TruncateDecision){
    /** 不定状態 */
    IndefiniteTruncateState = 0,
    /** 誤読防止機能未対応 */
    NonAvailableTruncate = 1,
    /** 誤読防止機能対応機種 */
    AvailableTruncate = 2
};
//#078 ADD End

//#086 ADD Start
/** レポート有無設定 */
typedef NS_ENUM(NSUInteger,ReportSetting){
    /** レポートなし */
    NoReport = 0,
    /** レポートあり */
    Report = 1
};

/** アンテナ重複チェック有無設定 */
typedef NS_ENUM(NSUInteger,DuplicateCheckSetting){
    /** アンテナ重複チェックあり */
    DuplicateCheck = 0,
    /** アンテナ重複チェックなし */
    NoDuplicateCheck = 1
};

//#106 Add Start
/** 二度読み設定対応 */
typedef NS_ENUM(NSUInteger,DoubleReadModeSetting){
    /** 全てのタグを応答 */
    DoubleReadModeDisable = 0,
    /** 重複タグのみ応答 */
    DoubleReadModeEnable = 1
};
//#106 Add End
// CH番号
typedef NS_ENUM(NSUInteger, ChannelNumber){
    ChannelNumber05 = 5,
    ChannelNumber11 = 11,
    ChannelNumber17 = 17,
    ChannelNumber23 = 23,
    ChannelNumber24 = 24,
    ChannelNumber25 = 25,
    ChannelNumber26 = 26,
    ChannelNumber27 = 27,
    ChannelNumber28 = 28,
    ChannelNumber29 = 29,
    ChannelNumber30 = 30,
    ChannelNumber31 = 31,
    ChannelNumber32 = 32,
    //#105 Add Start
    ChannelNumber33 = 33,
    ChannelNumber34 = 34,
    ChannelNumber35 = 35,
    ChannelNumber36 = 36,
    ChannelNumber37 = 37,
    ChannelNumber38 = 38
    //#105 Add End
};
//#086 ADD End

/////////////////////////////////////////////////////////////////////
// 周波数チャネルタイプ
/////////////////////////////////////////////////////////////////////
// 共通
typedef NS_ENUM(NSUInteger, FrequencyChannelType){
    FrequencyChannelTypeAuto = 1001 // 自動
};

// 特定小電力用
typedef NS_ENUM(NSUInteger, FrequencyLowChannelType){
    FrequencyLowChannelTypeCh05 = 1, // CH5 選択
    FrequencyLowChannelTypeCh11 = 2, // CH11 選択
    FrequencyLowChannelTypeCh17 = 3, // CH17 選択
    FrequencyLowChannelTypeCh23 = 4, // CH23 選択
    FrequencyLowChannelTypeCh24 = 5, // CH24 選択
    FrequencyLowChannelTypeCh25 = 6, // CH25 選択
    FrequencyLowChannelTypeCh26 = 7, // CH26 選択
    FrequencyLowChannelTypeCh27 = 8, // CH27 選択
    FrequencyLowChannelTypeCh28 = 9, // CH28 選択
    FrequencyLowChannelTypeCh29 = 10,// CH29 選択
    FrequencyLowChannelTypeCh30 = 11,// CH30 選択
    FrequencyLowChannelTypeCh31 = 12,// CH31 選択
    FrequencyLowChannelTypeCh32 = 13, // CH32 選択
    //#105 Add Start
    FrequencyLowChannelTypeCh33 = 14, // CH33 選択
    FrequencyLowChannelTypeCh34 = 15, // CH34 選択
    FrequencyLowChannelTypeCh35 = 16, // CH35 選択
    FrequencyLowChannelTypeCh36 = 17, // CH36 選択
    FrequencyLowChannelTypeCh37 = 18, // CH37 選択
    FrequencyLowChannelTypeCh38 = 19 // CH38 選択
    //#105 Add End
};

// 登録局用
typedef NS_ENUM(NSUInteger, FrequencyHighChannelType){
    FrequencyHighChannelTypeCh05 = 1, // CH5 選択
    FrequencyHighChannelTypeCh11 = 2, // CH11 選択
    FrequencyHighChannelTypeCh17 = 3, // CH17 選択
    FrequencyHighChannelTypeCh23 = 4, // CH23 選択
    FrequencyHighChannelTypeCh24 = 5, // CH24 選択
    FrequencyHighChannelTypeCh25 = 6  // CH25 選択
};

//#061 Add Start
// 免許局用
typedef NS_ENUM(NSUInteger, FrequencyLicenseChannelType){
    FrequencyLicenseChannelTypeCh05 = 1, // CH5 選択
    FrequencyLicenseChannelTypeCh11 = 2, // CH11 選択
    FrequencyLicenseChannelTypeCh17 = 3, // CH17 選択
    FrequencyLicenseChannelTypeCh23 = 4, // CH23 選択
};
//#061 Add End

/////////////////////////////////////////////////////////////////////
// 出力レンジ
/////////////////////////////////////////////////////////////////////
// 特定小電力用
typedef NS_ENUM(NSUInteger,PowerLowRange){
    LowRangePower125mW = 19, // 特定小電力用 125mW
    LowRangePower97mW  = 18, // 特定小電力用 97mW
    LowRangePower75mW  = 17, // 特定小電力用 75mW
    LowRangePower58mW  = 16, // 特定小電力用 58mW
    LowRangePower45mW  = 15, // 特定小電力用 45mW
    LowRangePower35mW  = 14, // 特定小電力用 35mW
    LowRangePower27mW  = 13, // 特定小電力用 27mW
    LowRangePower21mW  = 12, // 特定小電力用 21mW
    LowRangePower16mW  = 11, // 特定小電力用 16mW
    LowRangePower13mW  = 10, // 特定小電力用 13mW
    LowRangePower9_8mW = 9,  // 特定小電力用 9.8mW
    LowRangePower7_6mW = 8,  // 特定小電力用 7.6mW
    LowRangePower5_9mW = 7,  // 特定小電力用 5.9mW
    LowRangePower4_6mW = 6,  // 特定小電力用 4.6mW
    LowRangePower3_6mW = 5,  // 特定小電力用 6.6mW
    LowRangePower2_8mW = 4,  // 特定小電力用 2.8mW
    LowRangePower2_1mW = 3,  // 特定小電力用 2.1mW
    LowRangePower1_7mW = 2,  // 特定小電力用 1.7mW
    LowRangePower1_3mW = 1,  // 特定小電力用 1.3mW
    LowRangePower1_0mW = 0   // 特定小電力用 1.0mW
};


// 登録局用
typedef NS_ENUM(NSUInteger,PowerHighRange){
    HighRangePower500mW = 26, // 登録局用 500mW
    HighRangePower410mW = 25, // 登録局用 410mW
    HighRangePower336mW = 24, // 登録局用 336mW
    HighRangePower276mW = 23, // 登録局用 276mW
    HighRangePower226mW = 22, // 登録局用 226mW
    HighRangePower186mW = 21, // 登録局用 186mW
    HighRangePower152mW = 20, // 登録局用 152mW
    HighRangePower125mW = 19, // 登録局用 125mW
    HighRangePower97mW  = 18, // 登録局用 97mW
    HighRangePower75mW  = 17, // 登録局用 75mW
    HighRangePower58mW  = 16, // 登録局用 58mW
    HighRangePower45mW  = 15, // 登録局用 45mW
    HighRangePower35mW  = 14, // 登録局用 35mW
    HighRangePower27mW  = 13, // 登録局用 27mW
    HighRangePower21mW  = 12, // 登録局用 21mW
    HighRangePower16mW  = 11, // 登録局用 16mW
    HighRangePower13mW  = 10, // 登録局用 13mW
    HighRangePower9_8mW = 9,  // 登録局用 9.8mW
    HighRangePower7_6mW = 8,  // 登録局用 7.6mW
    HighRangePower5_9mW = 7,  // 登録局用 5.9mW
    HighRangePower4_6mW = 6,  // 登録局用 4.6mW
    HighRangePower3_6mW = 5,  // 登録局用 6.6mW
    HighRangePower2_8mW = 4,  // 登録局用 2.8mW
    HighRangePower2_1mW = 3,  // 登録局用 2.1mW
    HighRangePower1_7mW = 2,  // 登録局用 1.7mW
    HighRangePower1_3mW = 1,  // 登録局用 1.3mW
    HighRangePower1_0mW = 0   // 登録局用 1.0mW
};

//#061 Add Start
// 免許局用
typedef NS_ENUM(NSUInteger,PowerLicenseRange){
    LicenseRangePower500mW = 26, // 免許局用 500mW
    LicenseRangePower410mW = 25, // 免許局用 410mW
    LicenseRangePower336mW = 24, // 免許局用 336mW
    LicenseRangePower276mW = 23, // 免許局用 276mW
    LicenseRangePower226mW = 22, // 免許局用 226mW
    LicenseRangePower186mW = 21, // 免許局用 186mW
    LicenseRangePower152mW = 20, // 免許局用 152mW
    LicenseRangePower125mW = 19, // 免許局用 125mW
    LicenseRangePower97mW  = 18, // 免許局用 97mW
    LicenseRangePower75mW  = 17, // 免許局用 75mW
    LicenseRangePower58mW  = 16, // 免許局用 58mW
    LicenseRangePower45mW  = 15, // 免許局用 45mW
    LicenseRangePower35mW  = 14, // 免許局用 35mW
    LicenseRangePower27mW  = 13, // 免許局用 27mW
    LicenseRangePower21mW  = 12, // 免許局用 21mW
    LicenseRangePower16mW  = 11, // 免許局用 16mW
    LicenseRangePower13mW  = 10, // 免許局用 13mW
    LicenseRangePower9_8mW = 9,  // 免許局用 9.8mW
    LicenseRangePower7_6mW = 8,  // 免許局用 7.6mW
    LicenseRangePower5_9mW = 7,  // 免許局用 5.9mW
    LicenseRangePower4_6mW = 6,  // 免許局用 4.6mW
    LicenseRangePower3_6mW = 5,  // 免許局用 6.6mW
    LicenseRangePower2_8mW = 4,  // 免許局用 2.8mW
    LicenseRangePower2_1mW = 3,  // 免許局用 2.1mW
    LicenseRangePower1_7mW = 2,  // 免許局用 1.7mW
    LicenseRangePower1_3mW = 1,  // 免許局用 1.3mW
    LicenseRangePower1_0mW = 0   // 免許局用 1.0mW
};
//#061 Add End
//#076 Add Start
// スキャナ搭載UF-2200 特定小電力用(JP4)
typedef NS_ENUM(NSUInteger,ScanPowerLowRange){
    ScanLowRangePower125mW = 19, // スキャナ搭載特定小電力用(JP4) 125mW
    ScanLowRangePower97mW  = 18, // スキャナ搭載特定小電力用(JP4) 97mW
    ScanLowRangePower75mW  = 17, // スキャナ搭載特定小電力用(JP4) 75mW
    ScanLowRangePower58mW  = 16, // スキャナ搭載特定小電力用(JP4) 58mW
    ScanLowRangePower45mW  = 15, // スキャナ搭載特定小電力用(JP4) 45mW
    ScanLowRangePower35mW  = 14, // スキャナ搭載特定小電力用(JP4) 35mW
    ScanLowRangePower27mW  = 13, // スキャナ搭載特定小電力用(JP4) 27mW
    ScanLowRangePower21mW  = 12, // スキャナ搭載特定小電力用(JP4) 21mW
    ScanLowRangePower16mW  = 11, // スキャナ搭載特定小電力用(JP4) 16mW
    ScanLowRangePower13mW  = 10, // スキャナ搭載特定小電力用(JP4) 13mW
    ScanLowRangePower9_8mW = 9,  // スキャナ搭載特定小電力用(JP4) 9.8mW
    ScanLowRangePower7_6mW = 8,  // スキャナ搭載特定小電力用(JP4) 7.6mW
    ScanLowRangePower5_9mW = 7,  // スキャナ搭載特定小電力用(JP4) 5.9mW
    ScanLowRangePower4_6mW = 6,  // スキャナ搭載特定小電力用(JP4) 4.6mW
    ScanLowRangePower3_6mW = 5,  // スキャナ搭載特定小電力用(JP4) 6.6mW
    ScanLowRangePower2_8mW = 4,  // スキャナ搭載特定小電力用(JP4) 2.8mW
    ScanLowRangePower2_1mW = 3,  // スキャナ搭載特定小電力用(JP4) 2.1mW
    ScanLowRangePower1_7mW = 2,  // スキャナ搭載特定小電力用(JP4) 1.7mW
    ScanLowRangePower1_3mW = 1,  // スキャナ搭載特定小電力用(JP4) 1.3mW
    ScanLowRangePower1_0mW = 0   // スキャナ搭載特定小電力用(JP4) 1.0mW
};

// スキャナ搭載UF-2200 登録局用(JP6)
typedef NS_ENUM(NSUInteger,ScanPowerHighRange){
    ScanHighRangePower1000mW = 31, // スキャナ搭載登録局用(JP6) 1000mW
    ScanHighRangePower900mW = 30, // スキャナ搭載登録局用(JP6) 900mW
    ScanHighRangePower800mW = 29, // スキャナ搭載登録局用(JP6) 800mW
    ScanHighRangePower700mW = 28, // スキャナ搭載登録局用(JP6) 700mW
    ScanHighRangePower600mW = 27, // スキャナ搭載登録局用(JP6) 600mW
    ScanHighRangePower500mW = 26, // スキャナ搭載登録局用(JP6) 500mW
    ScanHighRangePower410mW = 25, // スキャナ搭載登録局用(JP6) 410mW
    ScanHighRangePower336mW = 24, // スキャナ搭載登録局用(JP6) 336mW
    ScanHighRangePower276mW = 23, // スキャナ搭載登録局用(JP6) 276mW
    ScanHighRangePower226mW = 22, // スキャナ搭載登録局用(JP6) 226mW
    ScanHighRangePower186mW = 21, // スキャナ搭載登録局用(JP6) 186mW
    ScanHighRangePower152mW = 20, // スキャナ搭載登録局用(JP6) 152mW
    ScanHighRangePower125mW = 19, // スキャナ搭載登録局用(JP6) 125mW
    ScanHighRangePower97mW  = 18, // スキャナ搭載登録局用(JP6) 97mW
    ScanHighRangePower75mW  = 17, // スキャナ搭載登録局用(JP6) 75mW
    ScanHighRangePower58mW  = 16, // スキャナ搭載登録局用(JP6) 58mW
    ScanHighRangePower45mW  = 15, // スキャナ搭載登録局用(JP6) 45mW
    ScanHighRangePower35mW  = 14, // スキャナ搭載登録局用(JP6) 35mW
    ScanHighRangePower27mW  = 13, // スキャナ搭載登録局用(JP6) 27mW
    ScanHighRangePower21mW  = 12, // スキャナ搭載登録局用(JP6) 21mW
    ScanHighRangePower16mW  = 11, // スキャナ搭載登録局用(JP6) 16mW
    ScanHighRangePower13mW  = 10, // スキャナ搭載登録局用(JP6) 13mW
    ScanHighRangePower9_8mW = 9,  // スキャナ搭載登録局用(JP6) 9.8mW
    ScanHighRangePower7_6mW = 8,  // スキャナ搭載登録局用(JP6) 7.6mW
    ScanHighRangePower5_9mW = 7,  // スキャナ搭載登録局用(JP6) 5.9mW
    ScanHighRangePower4_6mW = 6,  // スキャナ搭載登録局用(JP6) 4.6mW
    ScanHighRangePower3_6mW = 5,  // スキャナ搭載登録局用(JP6) 6.6mW
    ScanHighRangePower2_8mW = 4,  // スキャナ搭載登録局用(JP6) 2.8mW
    ScanHighRangePower2_1mW = 3,  // スキャナ搭載登録局用(JP6) 2.1mW
    ScanHighRangePower1_7mW = 2,  // スキャナ搭載登録局用(JP6) 1.7mW
    ScanHighRangePower1_3mW = 1,  // スキャナ搭載登録局用(JP6) 1.3mW
    ScanHighRangePower1_0mW = 0   // スキャナ搭載登録局用(JP6) 1.0mW
};

// スキャナ搭載UF-2200 免許局用(JP5)
typedef NS_ENUM(NSUInteger,ScanPowerLicenseRange){
    ScanLicenseRangePower1000mW = 31, // スキャナ搭載免許局用(JP5) 1000mW
    ScanLicenseRangePower900mW = 30, // スキャナ搭載免許局用(JP5) 900mW
    ScanLicenseRangePower800mW = 29, // スキャナ搭載免許局用(JP5) 800mW
    ScanLicenseRangePower700mW = 28, // スキャナ搭載免許局用(JP5) 700mW
    ScanLicenseRangePower600mW = 27, // スキャナ搭載免許局用(JP5) 600mW
    ScanLicenseRangePower500mW = 26, // スキャナ搭載免許局用(JP5) 500mW
    ScanLicenseRangePower410mW = 25, // スキャナ搭載免許局用(JP5) 410mW
    ScanLicenseRangePower336mW = 24, // スキャナ搭載免許局用(JP5) 336mW
    ScanLicenseRangePower276mW = 23, // スキャナ搭載免許局用(JP5) 276mW
    ScanLicenseRangePower226mW = 22, // スキャナ搭載免許局用(JP5) 226mW
    ScanLicenseRangePower186mW = 21, // スキャナ搭載免許局用(JP5) 186mW
    ScanLicenseRangePower152mW = 20, // スキャナ搭載免許局用(JP5) 152mW
    ScanLicenseRangePower125mW = 19, // スキャナ搭載免許局用(JP5) 125mW
    ScanLicenseRangePower97mW  = 18, // スキャナ搭載免許局用(JP5) 97mW
    ScanLicenseRangePower75mW  = 17, // スキャナ搭載免許局用(JP5) 75mW
    ScanLicenseRangePower58mW  = 16, // スキャナ搭載免許局用(JP5) 58mW
    ScanLicenseRangePower45mW  = 15, // スキャナ搭載免許局用(JP5) 45mW
    ScanLicenseRangePower35mW  = 14, // スキャナ搭載免許局用(JP5) 35mW
    ScanLicenseRangePower27mW  = 13, // スキャナ搭載免許局用(JP5) 27mW
    ScanLicenseRangePower21mW  = 12, // スキャナ搭載免許局用(JP5) 21mW
    ScanLicenseRangePower16mW  = 11, // スキャナ搭載免許局用(JP5) 16mW
    ScanLicenseRangePower13mW  = 10, // スキャナ搭載免許局用(JP5) 13mW
    ScanLicenseRangePower9_8mW = 9,  // スキャナ搭載免許局用(JP5) 9.8mW
    ScanLicenseRangePower7_6mW = 8,  // スキャナ搭載免許局用(JP5) 7.6mW
    ScanLicenseRangePower5_9mW = 7,  // スキャナ搭載免許局用(JP5) 5.9mW
    ScanLicenseRangePower4_6mW = 6,  // スキャナ搭載免許局用(JP5) 4.6mW
    ScanLicenseRangePower3_6mW = 5,  // スキャナ搭載免許局用(JP5) 6.6mW
    ScanLicenseRangePower2_8mW = 4,  // スキャナ搭載免許局用(JP5) 2.8mW
    ScanLicenseRangePower2_1mW = 3,  // スキャナ搭載免許局用(JP5) 2.1mW
    ScanLicenseRangePower1_7mW = 2,  // スキャナ搭載免許局用(JP5) 1.7mW
    ScanLicenseRangePower1_3mW = 1,  // スキャナ搭載免許局用(JP5) 1.3mW
    ScanLicenseRangePower1_0mW = 0   // スキャナ搭載免許局用(JP5) 1.0mW
};
//#076 Add End

//#097 Add Start
 /** F-3000特定小電力用(JP1)出力値 */
//注意事項
//UF3000LowRangePower186mWを設定した場合、
//実際はUF-3000ハードウェアの出力は157mW(電波法上の特小局の最大出力)となります。
//SDK2.0.1よりUF3000LowRangePower157mWの定義を追加                
typedef NS_ENUM(NSInteger, UF3000PowerLowRange){
    UF3000LowRangePower186mW = 21, // F-3000特定小電力用(JP1) 157mW
    UF3000LowRangePower157mW = 21, // F-3000特定小電力用(JP1) 157mW //#104 Add
    UF3000LowRangePower152mW = 20, // F-3000特定小電力用(JP1) 152mW
    UF3000LowRangePower125mW = 19, // UF-3000特定小電力用(JP1) 125mW
    UF3000LowRangePower97mW  = 18, // UF-3000特定小電力用(JP1) 97mW
    UF3000LowRangePower75mW  = 17, // UF-3000特定小電力用(JP1) 75mW
    UF3000LowRangePower58mW  = 16, // UF-3000特定小電力用(JP1) 58mW
    UF3000LowRangePower45mW  = 15, // UF-3000特定小電力用(JP1) 45mW
    UF3000LowRangePower35mW  = 14, // UF-3000特定小電力用(JP1) 35mW
    UF3000LowRangePower27mW  = 13, // UF-3000特定小電力用(JP1) 27mW
    UF3000LowRangePower21mW  = 12, // UF-3000特定小電力用(JP1) 21mW
    UF3000LowRangePower16mW  = 11, // UF-3000特定小電力用(JP1) 16mW
    UF3000LowRangePower13mW  = 10, // UF-3000特定小電力用(JP1) 13mW
    UF3000LowRangePower9_8mW = 9,  // UF-3000特定小電力用(JP1) 9.8mW
    UF3000LowRangePower7_6mW = 8,  // UF-3000特定小電力用(JP1) 7.6mW
    UF3000LowRangePower5_9mW = 7,  // UF-3000特定小電力用(JP1) 5.9mW
    UF3000LowRangePower4_6mW = 6,  // UF-3000特定小電力用(JP1) 4.6mW
    UF3000LowRangePower3_6mW = 5,  // UF-3000特定小電力用(JP1) 6.6mW
    UF3000LowRangePower2_8mW = 4,  // UF-3000特定小電力用(JP1) 2.8mW
    UF3000LowRangePower2_1mW = 3,  // UF-3000特定小電力用(JP1) 2.1mW
    UF3000LowRangePower1_7mW = 2,  // UF-3000特定小電力用(JP1) 1.7mW
    UF3000LowRangePower1_3mW = 1,  // UF-3000特定小電力用(JP1) 1.3mW
    UF3000LowRangePower1_0mW = 0,   // UF-3000特定小電力用(JP1) 1.0mW
    UF3000LowRangePower0_7mW = -1,  // UF-3000特定小電力用(JP1) 0.7mW
    UF3000LowRangePower0_5mW = -2,  // UF-3000特定小電力用(JP1) 0.5mW
};
 /** UF-3000登録局用(JP3)出力値 */
typedef NS_ENUM(NSInteger, UF3000PowerHighRange){
    UF3000HighRangePower1000mW = 31, // UF-3000登録局用(JP3) 1000mW
    UF3000HighRangePower900mW = 30, // UF-3000登録局用(JP3) 900mW
    UF3000HighRangePower800mW = 29, // UF-3000登録局用(JP3) 800mW
    UF3000HighRangePower700mW = 28, // UF-3000登録局用(JP3) 700mW
    UF3000HighRangePower600mW = 27, // UF-3000登録局用(JP3) 600mW
    UF3000HighRangePower500mW = 26, // UF-3000登録局用(JP3) 500mW
    UF3000HighRangePower410mW = 25, // UF-3000登録局用(JP3) 410mW
    UF3000HighRangePower336mW = 24, // UF-3000登録局用(JP3) 336mW
    UF3000HighRangePower276mW = 23, // UF-3000登録局用(JP3) 276mW
    UF3000HighRangePower226mW = 22, // UF-3000登録局用(JP3) 226mW
    UF3000HighRangePower186mW = 21, // UF-3000登録局用(JP3) 186mW
    UF3000HighRangePower152mW = 20, // UF-3000登録局用(JP3) 152mW
    UF3000HighRangePower125mW = 19, // UF-3000登録局用(JP3) 125mW
    UF3000HighRangePower97mW  = 18, // UF-3000登録局用(JP3) 97mW
    UF3000HighRangePower75mW  = 17, // UF-3000登録局用(JP3) 75mW
    UF3000HighRangePower58mW  = 16, // UF-3000登録局用(JP3) 58mW
    UF3000HighRangePower45mW  = 15, // UF-3000登録局用(JP3) 45mW
    UF3000HighRangePower35mW  = 14, // UF-3000登録局用(JP3) 35mW
    UF3000HighRangePower27mW  = 13, // UF-3000登録局用(JP3) 27mW
    UF3000HighRangePower21mW  = 12, // UF-3000登録局用(JP3) 21mW
    UF3000HighRangePower16mW  = 11, // UF-3000登録局用(JP3) 16mW
    UF3000HighRangePower13mW  = 10, // UF-3000登録局用(JP3) 13mW
    UF3000HighRangePower9_8mW = 9,  // UF-3000登録局用(JP3) 9.8mW
    UF3000HighRangePower7_6mW = 8,  // UF-3000登録局用(JP3) 7.6mW
    UF3000HighRangePower5_9mW = 7,  // UF-3000登録局用(JP3) 5.9mW
    UF3000HighRangePower4_6mW = 6,  // UF-3000登録局用(JP3) 4.6mW
    UF3000HighRangePower3_6mW = 5,  // UF-3000登録局用(JP3) 6.6mW
    UF3000HighRangePower2_8mW = 4,  // UF-3000登録局用(JP3) 2.8mW
    UF3000HighRangePower2_1mW = 3,  // UF-3000登録局用(JP3) 2.1mW
    UF3000HighRangePower1_7mW = 2,  // UF-3000登録局用(JP3) 1.7mW
    SUF3000HighRangePower1_3mW = 1,  // UF-3000登録局用(JP3) 1.3mW
    UF3000HighRangePower1_0mW = 0,  // UF-3000登録局用(JP3) 1.0mW
    UF3000HighRangePower0_7mW = -1,  // UF-3000登録局用(JP3) 0.7mW
    UF3000HighRangePower0_5mW = -2,  // UF-3000登録局用(JP3) 0.5mW
};
 /** UF-3000免許局用(JP2)出力値 */
typedef NS_ENUM(NSInteger,UF3000PowerLicenseRange){
    UF3000LicenseRangePower1000mW = 31, // UF-3000免許局用(JP2) 1000mW
    UF3000LicenseRangePower900mW = 30, // UF-3000免許局用(JP2) 900mW
    UF3000LicenseRangePower800mW = 29, // UF-3000免許局用(JP2) 800mW
    UF3000LicenseRangePower700mW = 28, // UF-3000免許局用(JP2) 700mW
    UF3000LicenseRangePower600mW = 27, // UF-3000免許局用(JP2) 600mW
    UF3000LicenseRangePower500mW = 26, // UF-3000免許局用(JP2) 500mW
    UF3000LicenseRangePower410mW = 25, // UF-3000免許局用(JP2) 410mW
    UF3000LicenseRangePower336mW = 24, // UF-3000免許局用(JP2) 336mW
    UF3000LicenseRangePower276mW = 23, // UF-3000免許局用(JP2) 276mW
    UF3000LicenseRangePower226mW = 22, // UF-3000免許局用(JP2) 226mW
    UF3000LicenseRangePower186mW = 21, // UF-3000免許局用(JP2) 186mW
    UF3000LicenseRangePower152mW = 20, // UF-3000免許局用(JP2) 152mW
    UF3000LicenseRangePower125mW = 19, // UF-3000免許局用(JP2) 125mW
    UF3000LicenseRangePower97mW  = 18, // UF-3000免許局用(JP2) 97mW
    UF3000LicenseRangePower75mW  = 17, // UF-3000免許局用(JP2) 75mW
    UF3000LicenseRangePower58mW  = 16, // UF-3000免許局用(JP2) 58mW
    UF3000LicenseRangePower45mW  = 15, // UF-3000免許局用(JP2) 45mW
    UF3000LicenseRangePower35mW  = 14, // UF-3000免許局用(JP2) 35mW
    UF3000LicenseRangePower27mW  = 13, // UF-3000免許局用(JP2) 27mW
    UF3000LicenseRangePower21mW  = 12, // UF-3000免許局用(JP2) 21mW
    UF3000LicenseRangePower16mW  = 11, // UF-3000免許局用(JP2) 16mW
    UF3000LicenseRangePower13mW  = 10, // UF-3000免許局用(JP2) 13mW
    UF3000LicenseRangePower9_8mW = 9,  // UF-3000免許局用(JP2) 9.8mW
    UF3000LicenseRangePower7_6mW = 8,  // UF-3000免許局用(JP2) 7.6mW
    UF3000LicenseRangePower5_9mW = 7,  // UF-3000免許局用(JP2) 5.9mW
    UF3000LicenseRangePower4_6mW = 6,  // UF-3000免許局用(JP2) 4.6mW
    UF3000LicenseRangePower3_6mW = 5,  // UF-3000免許局用(JP2) 6.6mW
    UF3000LicenseRangePower2_8mW = 4,  // UF-3000免許局用(JP2) 2.8mW
    UF3000LicenseRangePower2_1mW = 3,  // UF-3000免許局用(JP2) 2.1mW
    UF3000LicenseRangePower1_7mW = 2,  // UF-3000免許局用(JP2) 1.7mW
    SUF3000LicenseRangePower1_3mW = 1,  // UF-3000免許局用(JP2) 1.3mW
    UF3000LicenseRangePower1_0mW = 0,  // UF-3000免許局用(JP2) 1.0mW
    UF3000LicenseRangePower0_7mW = -1,  // UF-3000免許局用(JP2) 0.7mW
    UF3000LicenseRangePower0_5mW = -2,  // UF-3000免許局用(JP2) 0.5mW
};

 /** USB充電状態 */
typedef NS_ENUM(NSUInteger, USBCharging) {
     /** USB充電禁止 */
    USBChargingDisable= 0,
     /** USB充電許可 */
    USBChargingEnable= 1
};
 /** バッテリー充電状態 */
typedef NS_ENUM(NSUInteger, ChargingState) {
     /** 状態未取得 */
    NoChargingStatus= 0,
     /** ACアダプタ充電中 */
    ChargingACAdapter= 1,
     /** USB充電中 */
    ChargingUSB = 2,
     /** 充電中でない */
    NotCharging= 3
};
 /** 熱制御設定 */
typedef NS_ENUM(NSUInteger, ThermalControl) {
     /**最高出力を制限 */
    ThermalControlON = 0,
     /** 制限なし（グリップありと同じ） */
    ThermalControlOFF = 1
};
 /** アンテナ偏波指定*/
typedef NS_ENUM(NSUInteger, AntennaPolarization) {
     /** 両方偏波で読み取りを行う。 */
    BothPolarization= 0,
     /** 垂直のみ */
    VerticalPolarization= 1,
     /** 水平のみ */
    HorizontalPolarization= 2,
     /** 指定不可（パラメータエラーとなる） */
    NotSpecified= 3
};
//#097 Add End

/////////////////////////////////////////////////////////////////////
// callback Type define
/////////////////////////////////////////////////////////////////////
typedef void (^DataEventHandler)(NSDictionary* tagList);
typedef void (^ErrorEventHandler)(int resultCode, int resultCodeExtended);
typedef void (^ConnectionEventHandler)(ConnectState state);
typedef void (^ResultCallbackHandler)(int resultCode, int resultCodeExtended);
typedef void (^ResultTagCallbackHandler)(int resultCode, int resultCodeExtended, NSDictionary* tagList);
typedef void (^TriggerEventHandler)(int triggerSwState);//#072 add
typedef void (^ReadBarcodeCallback)(NSDictionary* barcodePack, int resultCode, int resultCodeExtended);//#077 add
typedef void (^TagReadModeCallback)(int tagSpeed,int millerSubCarrier,int resultCode, int resultCodeExtended);//#078 add
//#086 ADD Start
typedef void (^ExtendedEPCCallback)(int phase,int rssi,int antenna,int resultCode, int resultCodeExtended);
typedef void (^AntennaDuplicateCheckCallback)(int checked,int resultCode, int resultCodeExtended);
//#086 ADD End
//#097 Add Start
typedef void (^USBChargingCallback)(unsigned int charging,int resultCode, int resultCodeExtended);
typedef void (^AntennaPolarizationCallback)(unsigned int polarization,int resultCode, int resultCodeExtended);
typedef void (^ThermalControlCallback) (unsigned int control,int resultCode, int resultCodeExtended);
typedef void (^BatteryExtendedDataCallback)(unsigned int level, unsigned int chargingState,int resultCode, int resultCodeExtended);
//#097 Add End
//#100 Add Start
typedef void (^FWUpdateEventHandler)(long progress);
typedef void (^FWUpdateResultCallbackHandler)(NSString *updatedVersion,int resultCode, int resultCodeExtended);
//#100 Add End
//#106 Add Start
typedef void (^DoubleReadModeCallback)(unsigned int mode, int resultCode, int resultCodeExtended);
//#106 Add End
/////////////////////////////////////////////////////////////////////
// ◆◆クラス定義
/////////////////////////////////////////////////////////////////////
@interface TecRfidSuite : NSObject

//◆プロパティ
@property (readonly) int OpenResult;
@property (readonly) int ResultCode;
@property (readonly) int ResultCodeExtended;
@property BOOL DataEventEnabled;
@property BOOL DeviceEnabled; 
@property (readonly) int State;
@property (readonly) int ConnectionState;
@property (readonly) BOOL ContinuousReadMode;
@property (readonly) int communicationMode;//#095 Add
/** 電波出力自動調整モード */
@property (readonly) BOOL powerAutomaticAdjustmentMode;//#088 ADD
@property unsigned int ReadTimerInterval;
@property (readonly) BOOL Claimed;
/** スキャナ対応判定状態 */
@property (readonly) int isAvailableScanner;//#077 ADD
/** タグ読取対応機種判定状態 */
@property (readonly) int isAvailableTagReadMode;//#078 ADD
/** タグ読取対応機種判定状態 */
@property (readonly) int isAvailableTruncate;//#092 ADD
//◆メソッド定義
- (id) init;

-(int)ClaimDevice:(NSString*)connectionString callback:(ConnectionEventHandler)callback;

-(int)ClearInput;

-(int)ClearOutput;

-(int)Close;

-(int)Open:(NSString*)deviceName;

-(int) ReleaseDevice;

-(int)DisableTag:(NSString*)tagID timeout:(int)timeout killPassword:(NSString*)killPassword callback:(ResultCallbackHandler)callback;

-(int) LockTag:(NSString*)tagID timeout:(int)timeout accessPassword:(NSString*)accessPassword lockFieldType:(unsigned int)lockFieldType callback:(ResultCallbackHandler)callback;

-(int) UnlockTag:(NSString*)tagID timeout:(int)timeout accessPassword:(NSString*)accessPassword lockFieldType:(unsigned int)lockFieldType callback:(ResultCallbackHandler)callback;

-(int)ReadTags:(int)cmd tagID:(NSString*)tagID filterID:(NSString*)filterID filtermask:(NSString*)filtermask start:(unsigned int)start length:(unsigned int)length timeout:(int)timeout callback:(ResultTagCallbackHandler)callback;

-(int)StartReadTags:(NSString*)filterID filtermask:(NSString*)filtermask timeout:(int)timeout
          dataEvent:(DataEventHandler)dataEvent errorEvent: (ErrorEventHandler)errorEvent;

-(int)StopReadTags:(ResultCallbackHandler)callback;

-(int)WriteTagData:(NSString*)tagID userData:(NSString*)userData start:(unsigned int)start timeout:(int)timeout password:(NSString*)password callback:(ResultCallbackHandler)callback;

-(int)WriteTagID:(NSString*)sourceID destID:(NSString*)destID start:(unsigned int)start timeout:(int)timeout password:(NSString*)password callback:(ResultCallbackHandler)callback;

-(int)WriteTagAccessPassword:(NSString*)tagID accessPassword:(NSString*)accessPassword timeout:(int)timeout oldPassword:(NSString*)oldPassword callback:(ResultCallbackHandler)callback;

-(int)WriteTagKillPassword:(NSString*)tagID killPassword:(NSString*)killPassword timeout:(int)timeout accessPassword:(NSString*)accessPassword callback:(ResultCallbackHandler)callback;

-(int)TakeContinuousTag:(NSMutableDictionary*)tagList;

-(int)GetBatteryLevel:(void(^)(unsigned int level,int resultCode, int resultCodeExtended))callback;

-(int)GetTriggerSwMode:(void(^)(int trigMode,int resultCode, int resultCodeExtended))callback;

-(int)SetTriggerSwMode:(int)trigMode callback:(ResultCallbackHandler)callback;

-(int)GetPower:(void(^)(int powerLevel,int resultCode, int resultCodeExtended))callback;

-(int)SetPower:(int)powerLevel callback:(ResultCallbackHandler)callback;

-(int)GetQValue:(void(^)(int valueQ,int resultCode, int resultCodeExtended))callback;

-(int)SetQValue:(int)valueQ callback:(ResultCallbackHandler)callback;

-(int)GetFrequency:(void(^)(int frequencyChannel,NSArray* autoFrequencyList,int resultCode, int resultCodeExtended))callback;

-(int)SetFrequency:(int)frequencyChannel autoFrequencyList:(NSArray*)autoFrequencyList callback:(ResultCallbackHandler)callback;

-(int)GetCarrierSenseLevel:(void(^)(NSDictionary* carrierSensePack,int resultCode, int resultCodeExtended))callback;

-(int)GetRssi:(void(^)(NSDictionary* rssiPack,int resultCode, int resultCodeExtended))callback;

-(int)GetBluetoothList:(NSMutableArray*)adressArray;

-(int)GetFirmwareVer:(void(^)(NSString* firmVer,int resultCode, int resultCodeExtended))callback;

-(int)GetOptions:(NSMutableDictionary*)options;

-(int)SetOptions:(NSDictionary*)options;

-(int)GetSavingEnergy:(void(^)(int energy,int resultCode, int resultCodeExtended))callback;

-(int)SetSavingEnergy:(int)energy callback:(ResultCallbackHandler)callback;

-(int)SaveMemory:(ResultCallbackHandler)callback;

-(int)SelectTagEnable:(NSString*)filter offset:(unsigned int)offset size:(unsigned int)size callback:(ResultCallbackHandler)callback;

-(int)SelectTagDisable:(ResultCallbackHandler)callback;

-(int)SetReportSupplement:(ReportSuppleType)modeType callback:(ResultCallbackHandler)callback;

-(int)SetSessionID:(unsigned int)sessionID callback:(ResultCallbackHandler)callback;
-(int)GetSessionID:(void(^)(unsigned int sessionID,int resultCode, int resultCodeExtended))callback;//#069 ADD

-(int)RecoveryFactoryShipping:(ResultCallbackHandler)callback;

-(int)ModuleReset:(ResultCallbackHandler)callback;
//#062 Add Start
-(int)SelectMultipleTagEnable:(int)indexer filter:(NSString*)filter offset:(unsigned int)offset size:(unsigned int)size
                    condition:(int)condition callback:(ResultCallbackHandler)callback;
-(int)SelectMultipleTagDisable:(int)indexer callback:(ResultCallbackHandler)callback;
-(int)SelectMultipleTagAllDisable:(ResultCallbackHandler)callback;
//- (void)SetFilterLength:(int)filterLength callback:(ResultCallbackHandler)callback;//#065 DEL
//#062 Add End
-(int)GetFilterInfo:(int)indexer callback:(void(^)(NSString* filter,unsigned int offset,unsigned int size,unsigned int condition,int resultCode, int resultCodeExtended))callback;//#069 ADD
-(int)StartMonitoringTriggerSwState:(int)monitoringInterval triggerEvent:(TriggerEventHandler)triggerEvent errorEvent:(ErrorEventHandler)errorEvent;//#072 ADD
//-(void)StopMonitoringTriggerSwState:(void(^)())callback;//#072 ADD #080 DEL
-(void)StopMonitoringTriggerSwState:(void(^)(void))callback;//#080 ADD
//#077 ADD Start
-(int)getTriggerSwModeBarcode:(void(^)(int trigMode,int resultCode, int resultCodeExtended))callback;
-(int)setTriggerSwModeBarcode:(int)trigMode callback:(ResultCallbackHandler)callback;
-(int)startReadBarcode:(ReadBarcodeCallback)callback;
-(int)stopReadBarcode:(ResultCallbackHandler)callback;
-(int)getSdkOptions:(NSMutableDictionary**)options;
-(int)setSdkOptions:(NSDictionary*)options;
//#077 ADD End
//#078 ADD Start
-(int)getTagReadMode:(TagReadModeCallback)callback;
-(int)setTagReadMode:(int)tagSpeed millerSubCarrier:(int)millerSubCarrier callback:(ResultCallbackHandler)callback;
-(int)enableModelCheckProperty:(ResultCallbackHandler)callback;
//#078 ADD End
-(int)setWaveStrengthStage:(WaveStrengthStage)stage callback:(ResultCallbackHandler)callback;//#083 ADD
//#084 ADD Start
-(int)setFlagAB:(unsigned int)flag callback:(ResultCallbackHandler)callback;
-(int)getFlagAB:(void(^)(unsigned int flag,int resultCode, int resultCodeExtended))callback;
//#084 ADD End
//#086 ADD Start
-(int)setReportExtendedEPC:(int)phase rssi:(int)rssi antenna:(int)antenna callback:(ResultCallbackHandler)callback;
-(int)getReportExtendedEPC:(ExtendedEPCCallback)callback;
-(int)setAntennaDuplicateCheck:(int)checked callback:(ResultCallbackHandler)callback;
-(int)getAntennaDuplicateCheck:(AntennaDuplicateCheckCallback)callback;
//#086 ADD End
//#088 ADD Start
-(int)startPowerAutomaticAdjustmentMode:(ResultCallbackHandler)callback;
-(int)stopPowerAutomaticAdjustmentMode:(ResultCallbackHandler)callback;
//#088 ADD End
//#092 ADD Start
-(int)getMisreadingPreventionSettings:(void(^)(int readingID, int resultCode, int resultCodeExtended))callback;
-(int)setMisreadingPreventionSettings:(int)readingID callback:(ResultCallbackHandler)callback;
//#092 ADD End
//#095 Add Start
-(int)startScanDeviceBLE;
-(int)stopScanDeviceBLE;
//#095 Add End
//#097 Add Start
-(int)getUSBCharging:(USBChargingCallback)callback;
-(int)setUSBCharging:(int)charging callback:(ResultCallbackHandler)callback;
-(int)getAntennaPolarization:(AntennaPolarizationCallback)callback;
-(int)setAntennaPolarization:(int)polarization callback:(ResultCallbackHandler)callback;
-(int)getThermalControl:(ThermalControlCallback)callback;
-(int)setThermalControl:(int)control callback:(ResultCallbackHandler)callback;
-(int)getBatteryExtendedData:(BatteryExtendedDataCallback)callback;
//#097 Add End
//#100 Add Start
-(int)getFWFileVersion:(NSString*)FWfile FWFileVersion:(NSString**)version;
-(int)updateFW:(NSString*)FWfile callback:(FWUpdateResultCallbackHandler)callback updateEvent:(FWUpdateEventHandler)updateEvent;
//#100 Add End
//#106 Add Start
-(int)getDoubleReadMode:(DoubleReadModeCallback)callback;
-(int)setDoubleReadMode:(int)checked callback:(ResultCallbackHandler)callback;
//#106 Add End
-(int)GetRssiEx:(void(^)(NSDictionary* rssiPack,int resultCode, int resultCodeExtended))callback;//#105 Add

@end
