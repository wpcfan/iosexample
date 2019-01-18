//
//  XSAlertView.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/10.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "XSAlertView.h"
#import "../Constants.h"

#define ALERTVIEW_WIDTH AutoSize(292)
#define TITLELAB_HEIGHT AutoSize(50)
#define BTN_HEIGHT AutoSize(50)
#define LINE_HEIGHT 0.5

typedef void(^XSAlertViewReturnBlock)();

@interface XSAlertView () {
    UIView *_bgView;
    XSAlertViewReturnBlock _confirmBlock;
    XSAlertViewReturnBlock _cancelBlock;
}
@end

@implementation XSAlertView

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text superView:(UIView *)superView confirm:(void(^)())confirm cancel:(void(^)())cancel {
    if (self = [super init]) {
        
        _confirmBlock = confirm;
        _cancelBlock = cancel;
        
        _bgView = [[UIView alloc] initWithFrame:superView.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        [superView addSubview:_bgView];
        
        self.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - ALERTVIEW_WIDTH) / 2, AutoSize(172.5), ALERTVIEW_WIDTH, AutoSize(187));
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        
        [self setupUI:title text:text];
    }
    return self;
}

- (void)setupUI:(NSString *)title text:(NSString *)text {
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TITLELAB_HEIGHT)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15.5];
    titleLab.textColor = [UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1];
    [self addSubview:titleLab];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, CGRectGetHeight(self.frame) - BTN_HEIGHT, CGRectGetWidth(self.frame) / 2, BTN_HEIGHT);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
    [confirmBtn setTitleColor:[UIColor colorWithRed:103/255.0f green:159/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - BTN_HEIGHT, CGRectGetWidth(self.frame) / 2, BTN_HEIGHT);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
    [cancelBtn setTitleColor:[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(self.frame) - 30, CGRectGetMinY(confirmBtn.frame) - CGRectGetMaxY(titleLab.frame))];
    textLab.text = text;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:15.5];
    textLab.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    textLab.numberOfLines = 0;
    [self addSubview:textLab];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(self.frame), LINE_HEIGHT)];
    topLine.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1];
    [self addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(confirmBtn.frame) - LINE_HEIGHT, CGRectGetWidth(self.frame), LINE_HEIGHT)];
    bottomLine.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1];
    [self addSubview:bottomLine];
}

- (void)confirmClick:(UIButton *)sender {
    [self hide:sender];
    if (_confirmBlock) {
        _confirmBlock();
    }
}

- (void)cancelClick:(UIButton *)sender {
    [self hide:sender];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)hide:(UIButton *)sender {
    [self removeFromSuperview];
    [_bgView removeFromSuperview];
}

+ (void)showAlertInSuperView:(UIView *)superView title:(NSString *)title text:(NSString *)text confirm:(void(^)())confirm cancel:(void(^)())cancel {
    
    XSAlertView *alert = [[XSAlertView alloc] initWithTitle:title text:text superView:superView confirm:confirm cancel:cancel];
    [superView addSubview:alert];
}

@end
