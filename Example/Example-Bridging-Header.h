//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 友盟
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 友盟统计组件
//#import <UMShare/UMShare.h>             // U-Share核心SDK
//#import <UShareUI/UShareUI.h>           // U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#ifdef DEBUG
#import <UMCommonLog/UMCommonLogHeaders.h>
#endif
// Bugly
#import <Bugly/Bugly.h>                 // Bugly 崩溃分析组件

// 七牛
//#import "AFNetworking/AFNetworking.h"
//#import "Qiniu/QiniuSDK.h"
//#import "HappyDNS/HappyDNS.h"

#if !(TARGET_IPHONE_SIMULATOR)
// 乐橙/大华摄像头
#import "LCOpenSDK/LCOpenSDK_Api.h"
#import "LCOpenSDK/LCOpenSDK_AudioTalk.h"
#import "LCOpenSDK/LCOpenSDK_ConfigWifi.h"
#import "LCOpenSDK/LCOpenSDK_DeviceInit.h"
#import "LCOpenSDK/LCOpenSDK_Download.h"
#import "LCOpenSDK/LCOpenSDK_DownloadListener.h"
#import "LCOpenSDK/LCOpenSDK_EventListener.h"
#import "LCOpenSDK/LCOpenSDK_LoginManager.h"
#import "LCOpenSDK/LCOpenSDK_PlayWindow.h"
#import "LCOpenSDK/LCOpenSDK_TalkerListener.h"
#import "LCOpenSDK/LCOpenSDK_Utils.h"
// 京东智能 SDK
#import <SCMSDK/SCMSDK.h>
// 京东智能 门内机
#import "Integration/IndoorVideoPhone/SCMInterphoneManager.h"
#import "Integration/IndoorVideoPhone/DongDong/DongDongManager.h"
#endif
// CocoaDebug 日志宏定义
#ifdef DEBUG
    #define NSLog(fmt, ...) [ObjcLog logWithFile:__FILE__ function:__FUNCTION__ line:__LINE__ color:[UIColor whiteColor] unicodeToChinese:NO message:(fmt), ##__VA_ARGS__]
#else
    #define NSLog(fmt, ...) nil
#endif
