//
//  UIButton+XS.m
//  DemonstrationTestInformationAcquisitionSystem
//
//  Created by zhaoaoxun on 2017/12/3.
//  Copyright © 2017年 zhaoaoxun. All rights reserved.
//

#import "UIButton+XS.h"

@implementation UIButton (XS)

- (void)topImageAndBottomTitle:(CGFloat)spacing {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0, 0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

- (void)leftTitleAndRightImage:(CGFloat)spacing {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, 0, imageSize.width);
}

- (void)setSelectedImage:(UIImage *)selectedImage normalImage:(UIImage *)normalImage {
    [self setImage:selectedImage forState:UIControlStateSelected];
    [self setImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:normalImage forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)selectedColor normalColor:(UIColor *)normalColor {
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
    [self setTitleColor:selectedColor forState:UIControlStateSelected|UIControlStateHighlighted];
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitle:(NSString *)selectedTitle normalTitle:(NSString *)normalTitle {
    [self setTitle:selectedTitle forState:UIControlStateSelected];
    [self setTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];
    [self setTitle:normalTitle forState:UIControlStateNormal];
    [self setTitle:normalTitle forState:UIControlStateHighlighted];
}

@end
