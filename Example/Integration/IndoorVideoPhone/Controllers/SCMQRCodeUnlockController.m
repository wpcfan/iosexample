//
//  SCMQRCodeUnlockController.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "SCMQRCodeUnlockController.h"
#import "UIButton+XS.h"
#import "XSQRCode.h"
#import "WXApiRequestHandler.h"
#import "XSAlertView.h"
#import <SCMSDK/SCMSDK.h>
#import "../Constants.h"

#define TIMELAB_FONT 12
#define TIMELAB_Y AutoSize(50 + 64)
#define QRCODEIMGV_WIDTH 173
#define REFRESHQRCODEBTN_WIDTH 87.5
#define REFRESHQRCODEBTN_HEIGHT 29.5
#define REFRESHQRCODEBTN_FONT 13.5
#define WEIXINSHAREBTN_WIDTH 100
#define WEIXINSHAREBTN_SPACE 10
#define WEIXINSHAREBTN_FONT 15.5
#define WEIXINSHAREBTN_HEIGHT (56 + WEIXINSHAREBTN_SPACE + WEIXINSHAREBTN_FONT)
#define WEIXINSHAREBTN_TO_BOTTOM AutoSize(50)
#define LINE_HEIGHT 0.5
#if !(TARGET_IPHONE_SIMULATOR)
@interface SCMQRCodeUnlockController () {
    int _minute; // 倒计时:分
    int _second; // 倒计时:秒
    NSTimer *_timer; // 倒计时timer
    UILabel *_timeLab; // 倒计时lab
    UIImageView *_qrcodeImgV; // 二维码
}

@end
#endif

#if !(TARGET_IPHONE_SIMULATOR)
@implementation SCMQRCodeUnlockController

static NSString *kImageTagName = @"WECHAT_TAG_JUMP_APP";
static NSString *kMessageExt = @"这是第三方带的测试字段";
static NSString *kMessageAction = @"<action>dotalist</action>";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码解锁";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    _minute = 14;
    _second = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerSelector) userInfo:nil repeats:YES];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, TIMELAB_Y, CGRectGetWidth(self.view.frame), TIMELAB_FONT)];
    _timeLab.text = @"二维码失效倒计时";
    _timeLab.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    _timeLab.font = [UIFont systemFontOfSize:TIMELAB_FONT];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLab];
    
    _qrcodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - QRCODEIMGV_WIDTH) / 2, CGRectGetMaxY(_timeLab.frame) + AutoSize(13.5), QRCODEIMGV_WIDTH, QRCODEIMGV_WIDTH)];
    _qrcodeImgV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_qrcodeImgV];
    _qrcodeImgV.image = [XSQRCode qrImageForString:self.qrcodeStr imageSize:_qrcodeImgV.frame.size.width logoImageSize:0];
    
    UIButton *refreshQrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshQrcodeBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - REFRESHQRCODEBTN_WIDTH) / 2, CGRectGetMaxY(_qrcodeImgV.frame) + AutoSize(17), REFRESHQRCODEBTN_WIDTH, REFRESHQRCODEBTN_HEIGHT);
    [refreshQrcodeBtn setSelectedTitle:@"重新生成" normalTitle:@"重新生成"];
    [refreshQrcodeBtn setSelectedTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] normalColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1]];
    refreshQrcodeBtn.titleLabel.font = [UIFont systemFontOfSize:REFRESHQRCODEBTN_FONT];
    [self setViewBorder:refreshQrcodeBtn color:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] radius:REFRESHQRCODEBTN_HEIGHT / 2 border:1];
    [refreshQrcodeBtn addTarget:self action:@selector(refreshQrcodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshQrcodeBtn];
    
    UIButton *weixinShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinShareBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - WEIXINSHAREBTN_WIDTH) / 2, CGRectGetHeight(self.view.frame) - WEIXINSHAREBTN_TO_BOTTOM - WEIXINSHAREBTN_HEIGHT, WEIXINSHAREBTN_WIDTH, WEIXINSHAREBTN_HEIGHT);
    [weixinShareBtn setSelectedImage:[UIImage imageNamed:@"weixinshare"] normalImage:[UIImage imageNamed:@"weixinshare"]];
    [weixinShareBtn setSelectedTitle:@"微信分享" normalTitle:@"微信分享"];
    [weixinShareBtn setSelectedTitleColor:[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1] normalColor:[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1]];
    weixinShareBtn.titleLabel.font = [UIFont systemFontOfSize:WEIXINSHAREBTN_FONT];
    [weixinShareBtn topImageAndBottomTitle:WEIXINSHAREBTN_SPACE];
    [weixinShareBtn addTarget:self action:@selector(weixinShareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinShareBtn];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 30, 0)];
    tipLab.text = @"门禁机扫描此二维码可开锁，您可以将此二维码分享给需要开门的朋友";
    tipLab.numberOfLines = 0;
    tipLab.font = [UIFont systemFontOfSize:WEIXINSHAREBTN_FONT];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1];
    [tipLab sizeToFit];
    tipLab.frame = CGRectMake(15, CGRectGetMinY(weixinShareBtn.frame) - AutoSize(20) - CGRectGetHeight(tipLab.frame), CGRectGetWidth(self.view.frame) - 30, CGRectGetHeight(tipLab.frame));
    [self.view addSubview:tipLab];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(tipLab.frame) - WEIXINSHAREBTN_TO_BOTTOM, CGRectGetWidth(self.view.frame), LINE_HEIGHT)];
    bottomLine.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1];
    [self.view addSubview:bottomLine];
}

// 倒计时触发方法
- (void)timerSelector {
    
    _second--;
    if (_second == 0) {
        _minute--;
        _second = 60;
    }
    
    NSString *secondStr;
    if (_second < 10) {
        secondStr = [NSString stringWithFormat:@"0%d", _second];
    } else {
        secondStr = [NSString stringWithFormat:@"%d", _second];
    }
    NSString *minuteStr;
    if (_minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%d", _minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%d", _minute];
    }
    _timeLab.text = [NSString stringWithFormat:@"二维码失效倒计时%@:%@", minuteStr, secondStr];
    
    if (_minute == 0 && _second == 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

// 重新生成触发方法
- (void)refreshQrcodeClick
{
    [XSAlertView showAlertInSuperView:self.view title:@"确认重新生成" text:@"重新生成二维码，原有二维码将失效，确认重新生成？" confirm:^{
        [self getShareQrcodeString];
    } cancel:nil];
}

// 微信分享触发方法
- (void)weixinShareClick
{
    BOOL isSuccess = [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(_qrcodeImgV.image) TagName:kImageTagName MessageExt:kMessageExt Action:kMessageAction ThumbImage:_qrcodeImgV.image InScene:WXSceneSession];
    NSLog(@"微信分享结果:%d", isSuccess);
    if (isSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 设置视图边框
- (void)setViewBorder:(UIView *)view color:(UIColor *)color radius:(float)radius border:(float)border
{
    //设置layer
    CALayer *layer=[view layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:radius];
    //设置边框线的宽
    [layer setBorderWidth:border];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
}


#pragma mark - 重新获取解锁串
- (void)getShareQrcodeString
{
    SCMControlModelV3 *modelV3 = [[SCMControlModelV3 alloc] init];
    modelV3.version = @"3.0";
    modelV3.guid = self.guid;
    modelV3.service =@"com.joylink.indoor_phone";
    modelV3.member = @"getShareQRCode";
    modelV3.type = @"funcs";
    
    SCMControlModelV3In* targetIn = [[SCMControlModelV3In alloc] init];
    targetIn.name = @"target";
    targetIn.type = @"s";
    targetIn.value = @"outdoor_unit";
    
    SCMControlModelV3In* timeIn = [[SCMControlModelV3In alloc] init];
    timeIn.name = @"time";
    timeIn.type = @"i";
    timeIn.value = @15;
    
    modelV3.in =@[targetIn, timeIn];
    
    [SCMCloudControlManager controlDeviceWithModelV2:nil modelV3:modelV3 version:@"3.0" success:^(NSDictionary *dict) {
        
        if ([dict[@"status"] integerValue] != 0) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机：获取二维码串失败\nerror:%@", dict];
            NSLog(@"%@", errorMsg);
//            [SCMToastTool toastText:errorMsg];
            return ;
        }
        
        NSString *errorMsg = [NSString stringWithFormat:@"对讲机：获取二维码串成功"];
        NSLog(@"%@", errorMsg);
//        [SCMToastTool toastText:errorMsg];
        
        NSString *resultStr = dict[@"result"];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *qrcodeStr;
        for (NSDictionary *outDict in result[@"out"]) {
            if ([outDict[@"name"] isEqualToString:@"QR_code_random"]) {
                qrcodeStr = outDict[@"data"];
            }
        }
        _qrcodeImgV.image = [XSQRCode qrImageForString:qrcodeStr imageSize:_qrcodeImgV.frame.size.width logoImageSize:0];
    } fail:^(NSError *error) {
        NSString *errorMsg = [NSString stringWithFormat:@"对讲机：获取二维码串失败\nerror:%@", error];
        NSLog(@"%@", errorMsg);
//        [SCMToastTool toastText:errorMsg];
    }];
}

@end
#endif
