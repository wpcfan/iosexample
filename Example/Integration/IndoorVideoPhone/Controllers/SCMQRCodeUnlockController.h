//
//  SCMQRCodeUnlockController.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 二维码开锁页
 */
@interface SCMQRCodeUnlockController : UIViewController

/// 设备的guid，用来生成二维码
@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *qrcodeStr;

@end
