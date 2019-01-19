//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 友盟统计组件
#import <Bugly/Bugly.h>                 // Bugly 崩溃分析组件

// 七牛
//#import "AFNetworking/AFNetworking.h"
//#import "Qiniu/QiniuSDK.h"
//#import "HappyDNS/HappyDNS.h"

#ifdef TARGET_OS_IPHONE
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

#import <SCMSDK/SCMSDK.h>               // 京东智能 SDK
// 京东智能 门内机
#import "Integration/IndoorVideoPhone/SCMInterphoneManager.h"
#import "Integration/IndoorVideoPhone/DongDong/DongDongManager.h"
#endif
// Crypto
//#import <CommonCrypto/CommonHMAC.h>
// CocoaDebug 日志宏定义
#ifdef DEBUG
#define NSLog(fmt, ...) [CocoaDebug objcLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] :NSStringFromSelector(_cmd) :__LINE__ :(fmt, ##__VA_ARGS__) :[UIColor whiteColor]]
#else
#define NSLog(fmt, ...) nil
#endif
