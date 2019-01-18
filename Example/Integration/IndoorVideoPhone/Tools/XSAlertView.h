//
//  XSAlertView.h
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/10.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSAlertView : UIView

+ (void)showAlertInSuperView:(UIView *)superView title:(NSString *)title text:(NSString *)text confirm:(void(^)())confirm cancel:(void(^)())cancel;

@end
