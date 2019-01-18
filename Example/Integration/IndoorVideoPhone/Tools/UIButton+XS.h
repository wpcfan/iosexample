//
//  UIButton+XS.h
//  DemonstrationTestInformationAcquisitionSystem
//
//  Created by zhaoaoxun on 2017/12/3.
//  Copyright © 2017年 zhaoaoxun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 XS提供的UIButton快捷方法
 */
@interface UIButton (XS)

/**
 图片在上，文字在下

 @param spacing 间距
 */
- (void)topImageAndBottomTitle:(CGFloat)spacing;

/**
 文字在左，图片在右
 
 @param spacing 间距
 */
- (void)leftTitleAndRightImage:(CGFloat)spacing;

/**
 设置selected和normal状态下的文字颜色

 @param selectedColor selected状态下的文字颜色
 @param normalColor normal状态下的文字颜色
 */
- (void)setSelectedTitleColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor;

/**
 设置selected和normal状态下的图片

 @param selectedImage selected状态下的图片
 @param normalImage normal状态下的图片
 */
- (void)setSelectedImage:(UIImage *)selectedImage normalImage:(UIImage *)normalImage;

/**
 设置selected和normal状态下的文字

 @param selectedTitle selected状态下的文字
 @param normalTitle normal状态下的文字
 */
- (void)setSelectedTitle:(NSString *)selectedTitle normalTitle:(NSString *)normalTitle;

@end
