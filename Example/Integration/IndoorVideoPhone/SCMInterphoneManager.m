//
//  SCMInterphoneManager.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "SCMInterphoneManager.h"
#import "SCMCallReminderController.h"
#import "SCMQRCodeUnlockController.h"
#import "XSGetIpAddress.h"
#import <SCMSDK/SCMSDK.h>

#define INDOOR_PHONE @"com.joylink.indoor_phone"
#define CALLING @"calling"
#define CALLING_RESPONSE @"calling_response"

typedef void(^registerSignalSuccessBlock)();
typedef void(^registerSignalFailBlock)(NSError *error);

@interface SCMInterphoneManager () {
    UINavigationController *_navVC;
    SCMCallReminderController *_callReminderVC;
    
    NSDictionary *_service;
    NSNotification *_notification;
}

@property (nonatomic, assign) BOOL isOpenCallReminder; // 标记已经打开来电提醒页

@end

@implementation SCMInterphoneManager

// 单例
+ (SCMInterphoneManager *)shareInterphoneManager {
    static SCMInterphoneManager *_interphoneManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _interphoneManager = [[super allocWithZone:NULL] init];
        _interphoneManager.isOpenCallReminder = NO;
    });
    return _interphoneManager;
}

// 局域网注册calling信号
- (void)registerCallingSignalInLanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController {
    
    _service = serviceInfo;
    
    _navVC = navController;
    [self registerSignalInLanWithGuid:guid serviceInfo:serviceInfo signalName:CALLING];
}

// 局域网注册calling_response信号
- (void)registerCallingResponseSignalInLanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController {
    
    _navVC = navController;
    [self registerSignalInLanWithGuid:guid serviceInfo:serviceInfo signalName:CALLING_RESPONSE];
}

// 局域网调用SDK接口去注册信号
- (void)registerSignalInLanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo signalName:(NSString *)signalName {
    
    // 添加通知，接收信号
    [self addObserver];
    
    // 获取对讲机的服务原型
    [SCMLanDeviceControl getServiceInfo:serviceInfo success:^(NSDictionary *aServiceInfo) {
        
        NSString *errorMsg = @"对讲机（局域网）：获取com.joylink.indoor_phone服务原型成功";
        NSLog(@"%@", errorMsg);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SCMToastTool toastText:errorMsg];
            NSLog(@"%@",errorMsg);
        });
        // 注册局域网信号
        [SCMLanDeviceControl registerSignalWithGuid:guid service:INDOOR_PHONE signalName:signalName serviceInfo:aServiceInfo success:^(NSDictionary *dict) {
            
            NSString *data;
            for (NSDictionary *outDict in dict[@"out"]) {
                if ([outDict[@"name"] isEqualToString:@"msg"]) {
                    data = outDict[@"data"];
                }
            }
            if (![dict[@"errorMsg"] isEqualToString:@"com.joylink.ok"] || ![data isEqualToString:@"com.joylink.ok"]) {
                NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：注册%@信号失败\nerror:%@", signalName, dict];
                NSLog(@"%@", errorMsg);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SCMToastTool toastText:errorMsg];
                    NSLog(@"%@",errorMsg);
                });
                return ;
            }
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：注册%@信号成功", signalName];
            NSLog(@"%@", errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SCMToastTool toastText:errorMsg];
                NSLog(@"%@",errorMsg);
            });
        } fail:^(NSError *error) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：注册%@信号失败\nerror:%@", signalName, error];
            NSLog(@"%@", errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SCMToastTool toastText:errorMsg];
                NSLog(@"%@",errorMsg);
            });
        }];
    } fail:^(NSError *error) {
        NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：获取com.joylink.indoor_phone服务原型失败\nerror:%@", error];
        NSLog(@"%@", errorMsg);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SCMToastTool toastText:errorMsg];
            NSLog(@"%@",errorMsg);
        });
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////

// 广域网注册calling信号
- (void)registerCallingSignalInWanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController {
    
    _navVC = navController;
    [self registerSignalInWanWithGuid:guid serviceInfo:serviceInfo signalName:CALLING];
}

// 广域网注册calling_response信号
- (void)registerCallingResponseSignalInWanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController {
    
    _navVC = navController;
    [self registerSignalInWanWithGuid:guid serviceInfo:serviceInfo signalName:CALLING_RESPONSE];
}

// 广域网，先判断长链接状态，再去订阅信号
- (void)registerSignalInWanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo signalName:(NSString *)signalName {
    
    if ([[SCMLongConnectManager sharedSCMLongConnectManager] isConnecting]) {
        
        // 已建立长链接，去订阅信号
        [self registerWanSignalWithGuid:guid serviceInfo:serviceInfo signalName:signalName];
    } else {
        
        // 未建立长链接，接收长链接状态改变的通知
        [[NSNotificationCenter defaultCenter] addObserverForName:SCMSocketLongConnectStatuChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            NSDictionary *userInfo = note.userInfo;
            if (userInfo) {
                SCM_LONG_CONNECT_STATUS status = [userInfo[@"status"] integerValue];
                if (status == SCM_LONG_CONNECT_STATUS_CONNECTING) {
                    // 接到长链接建立成功的通知后，去订阅信号
                    [self registerWanSignalWithGuid:guid serviceInfo:serviceInfo signalName:signalName];
                }
            }
        }];
    }
}

// 添加通知，接收信号
- (void)addObserver {
    if (!_notification) {
        _notification = [[NSNotificationCenter defaultCenter] addObserverForName:SCMSocketLongConnectDidReceivedDevicesDataNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            if (note && note.userInfo) {
                [self receiveNotification:note];
            }
        }];
    }
    
}
- (void)removeObserver{
    if (_notification) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notification];
    }
}
// 广域网调用SDK接口去注册信号
- (void)registerWanSignalWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo signalName:(NSString *)signalName {
    
    // 添加通知，接收信号
    [self addObserver];
    
    // 获取对讲机的服务原型
    [SCMCloudControlManager getServiceInfoWithServiceName:INDOOR_PHONE srv_version:serviceInfo[@"version"] success:^(NSDictionary *data) {
        
        if ([data[@"status"] integerValue] != 0) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：获取com.joylink.indoor_phone服务原型失败\nerror:%@", data];
            NSLog(@"%@", errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SCMToastTool toastText:errorMsg];
                NSLog(@"%@",errorMsg);
            });
            return ;
        }
        NSString *resultStr = data[@"result"];
        NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *serviceInfo = [resultDict[@"services"] firstObject];
        
        // 注册广域网信号
        [[SCMLongConnectManager sharedSCMLongConnectManager] registerSignalGuid:guid serviceInfo:serviceInfo serviceName:INDOOR_PHONE signalName:signalName success:^(NSDictionary *result) {

            if (![result[@"errorMsg"] isEqualToString:@"com.joylink.ok"]) {
                NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：注册%@信号失败\nerror:%@", signalName, result];
                NSLog(@"%@", errorMsg);
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SCMToastTool toastText:errorMsg];
                    NSLog(@"%@",errorMsg);
                });
                return ;
            }
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：注册%@信号成功", signalName];
            NSLog(@"%@", errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SCMToastTool toastText:errorMsg];
                NSLog(@"%@",errorMsg);
            });
        } fail:^(NSError *error){
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：注册%@信号失败\nerror:%@", signalName, error];
            NSLog(@"%@", errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SCMToastTool toastText:errorMsg];
                NSLog(@"%@",errorMsg);
            });
        }];
    } fail:^(NSError *error) {
        NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：获取服务原型失败\nerror:%@", error];
        NSLog(@"%@", errorMsg);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SCMToastTool toastText:errorMsg];
            NSLog(@"%@",errorMsg);
        });
    }];
}

// 处理收到的广域网和局域网信号
- (void)receiveNotification:(NSNotification *)notification {
    /*
    {
        "sessionId": -1,
        "guid": "000000002BD5AC92EBC4B9588AEA1E4A",
        "service": "com.joylink.indoor_phone",
        "srcType": 1,
        "member": {
            "type": "signal",
            "name": "calling"
        },
        "in": [{
            "data": "outdoor_visitor",
            "len": 16,
            "name": "from",
            "type": "s"
        }, {
            "data": "value",
            "len": 6,
            "name": "info",
            "type": "s"
        }, {
            "data": "value",
            "len": 6,
            "name": "icon",
            "type": "s"
        }, {
            "data": "192.168.199.218",
            "len": 16,
            "name": "ip",
            "type": "s"
        }, {
            "data": 9000,
            "len": 4,
            "name": "port",
            "type": "i"
        }],
        "errorMsg": "com.joylink.ok"
    }
     ----------------------------------------------------------------
    {
        "sessionId": -1,
        "guid": "000000002BD5AC92EBC4B9588AEA1E4A",
        "service": "com.joylink.indoor_phone",
        "srcType": 1,
        "member": {
            "type": "signal",
            "name": "calling_response"
        },
        "in": [{
            "data": "hang_up",
            "len": 8,
            "name": "act",
            "type": "s"
        }],
        "errorMsg": "com.joylink.ok"
    }
     ----------------------------------------------------------------
     {
     "sessionId":    -1,
     "guid":    "000000002146F413AFCD0DE8C89C2EE8",
     "service":    "com.joylink.indoor_phone",
     "srcType":    0,
     "member":    {
     "type":    "signal",
     "name":    "calling"
     },
     "in":    [{
     "data":    "outdoor_visitor",
     "len":    16,
     "name":    "from",
     "type":    "s"
     }, {
     "data":    "value",
     "len":    6,
     "name":    "info",
     "type":    "s"
     }, {
     "data":    "value",
     "len":    6,
     "name":    "icon",
     "type":    "s"
     }, {
     "data":    "192.168.199.220",
     "len":    16,
     "name":    "ip",
     "type":    "s"
     }, {
     "data":    9000,
     "len":    4,
     "name":    "port",
     "type":    "i"
     }],
     "errorMsg":    "com.joylink.ok"
     }
     
     */
    NSString *guid = notification.userInfo[@"guid"];
    NSDictionary *member = notification.userInfo[@"member"];
    NSString *type = member[@"type"];
    if ([type isEqualToString:@"signal"]) {
        NSString *name = member[@"name"];
        
        // 收到calling信号展示来电提醒页
        if ([name isEqualToString:CALLING]) {
            NSString *signalIp; // 信号携带的ip
            NSString *signalCheckIp; // 取ip前三位进行接下来的比较
            NSNumber *port; // 信号携带port
            for (NSDictionary *inDict in notification.userInfo[@"in"]) {
                if ([inDict[@"name"] isEqualToString:@"ip"]) {
                    signalIp = inDict[@"data"];
                    NSArray *ipArr = [signalIp componentsSeparatedByString:@"."];
                    signalCheckIp = [NSString stringWithFormat:@"%@.%@.%@", ipArr[0], ipArr[1], ipArr[2]];
                }
                if ([inDict[@"name"] isEqualToString:@"port"]) {
                    port = inDict[@"data"];
                }
            }
            
            // 手机的ip地址
            NSString *ip = [XSGetIpAddress localWiFiIPAddress];
            NSArray *ipArr = [ip componentsSeparatedByString:@"."];
            NSString *checkIp = [NSString stringWithFormat:@"%@.%@.%@", ipArr[0], ipArr[1], ipArr[2]];
            
            // 判断是否在同一局域网中
            BOOL isSameLan = [signalCheckIp isEqualToString:checkIp];
            
            // 打开来电提醒页
            [self openCallReminderController:_navVC isSameLan:isSameLan guid:guid gwGuid:_gwGuid ip:signalIp port:port];
        }
        
        // 收到calling_response信号关闭来电提醒页
        if ([name isEqualToString:CALLING_RESPONSE]) {
            /*
             {
             "sessionId":    -1,
             "guid":    "000000002146F413AFCD0DE8C89C2EE8",
             "service":    "com.joylink.indoor_phone",
             "srcType":    1,
             "member":    {
             "type":    "signal",
             "name":    "calling_response"
             },
             "in":    [{
             "data":    "hang_up",
             "len":    8,
             "name":    "act",
             "type":    "s"
             }],
             "errorMsg":    "com.joylink.ok"
             }
             */
            NSArray *In = notification.userInfo[@"in"];
            NSString *name;
            NSString *actData;
            for (NSDictionary *inDict in In) {
                name = inDict[@"name"];
                if ([name isEqualToString:@"act"]) {
                    actData = inDict[@"data"];
                    if ([actData isEqualToString:@"hang_up"]) {
                        [self closeCallReminderController];
                    }
                }
            }
        }
    }
}

// 打开来电提醒页
- (void)openCallReminderController:(UINavigationController *)navController isSameLan:(BOOL)isSameLan guid:(NSString *)guid gwGuid:(NSString *)gwGuid ip:(NSString *)ip port:(NSNumber *)port {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.isOpenCallReminder) {
                self.isOpenCallReminder = YES;
                SCMCallReminderController *callReminderVC = [[SCMCallReminderController alloc] init];
                _callReminderVC = callReminderVC;
                callReminderVC.isSameLan = isSameLan;
                callReminderVC.guid = guid;
                callReminderVC.ip = ip;
                callReminderVC.port = port;
                callReminderVC.gwGuid = gwGuid;
                
                callReminderVC.service = _service;
                
                [navController pushViewController:callReminderVC animated:YES];
            }
        });
}

// 关闭来电提醒页
- (void)closeCallReminderController {
    
    if (self.isOpenCallReminder) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:5];
        [_callReminderVC.navigationController popViewControllerAnimated:YES];
    }
}

- (void)delayMethod
{
    self.isOpenCallReminder = NO;
}

// 展示二维码解锁页
- (void)showQRCodeUnlockController:(UINavigationController *)navController qrcodeStr:(NSString *)qrcodeStr guid:(NSString *)guid {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SCMQRCodeUnlockController *qrcodeUnlockVC = [[SCMQRCodeUnlockController alloc] init];
        qrcodeUnlockVC.qrcodeStr = qrcodeStr;
        qrcodeUnlockVC.guid = guid;
        [navController pushViewController:qrcodeUnlockVC animated:YES];
    });
}

@end
