//
//  XSQRCode.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/9.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XSQRCode : NSObject

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

@end
