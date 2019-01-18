//
//  DongDongManager.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/25.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DongDongManager : NSObject

+ (DongDongManager *)shareDongDongManager;

/**
 初始化语音视频通话
 */
- (void)initVideo;

/**
 开始语音视频通话

 @param view 视频画面
 @param ip 设备端ip地址
 @param port 设备端端口号
 */

/**
 开始语音视频通话

 @param view 视频画面
 @param remoteIp 设备端ip地址
 @param remotePort 设备端端口号
 @param localPort 本机端口号
 */
- (void)startVideoWithView:(UIView *)view remoteIp:(NSString *)remoteIp remotePort:(int)remotePort localPort:(int)localPort;

/**
 结束语音视频通话
 */
- (void)stopVideo;

@end
