//
//  SCMCallReminderController.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//
#if !(TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>

/**
 来电提醒页、视频通话页
 */
@interface SCMCallReminderController : UIViewController

/// 是否在同一局域网下
@property (nonatomic, assign) BOOL isSameLan;
/// 设备的guid，用来走控制指令
@property (nonatomic, copy) NSString *guid;
/// 设备的ip，用来走控制指令
@property (nonatomic, copy) NSString *ip;
/// 设备的port，用来走控制指令
@property (nonatomic, strong) NSNumber *port;

@property (nonatomic, strong) NSDictionary *service;

@property(nonatomic, strong)NSString *gwGuid;//网关guid

@end
#endif
