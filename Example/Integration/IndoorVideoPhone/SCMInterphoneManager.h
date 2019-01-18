//
//  SCMInterphoneManager.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 对讲机管理类
 */
@interface SCMInterphoneManager : NSObject
@property(nonatomic, strong)NSString *gwGuid;

#pragma mark - 单例
+ (SCMInterphoneManager *)shareInterphoneManager;

#pragma mark - 注册信号
/**
 局域网注册calling信号

 @param guid guid
 @param serviceInfo 服务信息
 @param navController 导航控制器
 */
- (void)registerCallingSignalInLanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController;

/**
 局域网注册calling_response信号

 @param guid guid
 @param serviceInfo 服务信息
 @param navController 导航控制器
 */
- (void)registerCallingResponseSignalInLanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController;

/**
 广域网注册calling信号

 @param guid guid
 @param serviceInfo 服务信息
 @param navController 导航控制器
 */
- (void)registerCallingSignalInWanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController;

/**
 广域网注册calling_response信号

 @param guid guid
 @param serviceInfo 服务信息
 @param navController 导航控制器
 */
- (void)registerCallingResponseSignalInWanWithGuid:(NSString *)guid serviceInfo:(NSDictionary *)serviceInfo navController:(UINavigationController *)navController;

/**
 关闭来电提醒页
 */
- (void)closeCallReminderController;

/**
 展示二维码解锁页

 @param navController 导航控制器
 @param qrcodeStr 开锁串
 @param guid guid
 */
- (void)showQRCodeUnlockController:(UINavigationController *)navController qrcodeStr:(NSString *)qrcodeStr guid:(NSString *)guid;

- (void)removeObserver;
@end
