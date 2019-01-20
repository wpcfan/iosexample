//
//  SCMCallReminderController.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/8.
//  Copyright © 2018年 JD. All rights reserved.
//
#if !(TARGET_IPHONE_SIMULATOR)
#import "SCMCallReminderController.h"
#import "UIButton+XS.h"
#import "XSGetIpAddress.h"
#import "SCMInterphoneManager.h"
#import "DongDongManager.h"
#import <AVFoundation/AVFoundation.h>
#import <SCMSDK/SCMSDK.h>
#import "../Constants.h"

#define HEADERLAB_Y 80
#define HEADERLAB_FONT 15.5
#define CONTROLIMAGE_HEIGHT 56
#define PLAYERVIEW_HEIGHT AutoSize(278)
#define CONTROLBTN_MARGIN 10
#define CONTROLVIEW_HEIGHT CONTROLIMAGE_HEIGHT + CONTROLBTN_MARGIN + HEADERLAB_FONT
#define CONTROLVIEW_TO_BOTTOM 150

typedef NS_ENUM(NSUInteger, ControlInterphoneType) {
    ControlInterphoneTypeAnswer, // 接听
    ControlInterphoneTypeHangup, // 挂断
    ControlInterphoneTypeOpen, // 开锁
};

@interface SCMCallReminderController () {
    UILabel *_headerLab;
//    UILabel *_tipLab;
    UIView *_videoView;
    UIImageView *_callImgV;
    AVAudioSession *_audioSession;
}

@end
#endif

#if !(TARGET_IPHONE_SIMULATOR)
@implementation SCMCallReminderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DongDongManager shareDongDongManager] stopVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    
    _headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, HEADERLAB_Y, CGRectGetWidth(self.view.frame), HEADERLAB_FONT)];
    _headerLab.text = @"有人呼叫";
    _headerLab.textColor = [UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1];
    _headerLab.textAlignment = NSTextAlignmentCenter;
    _headerLab.font = [UIFont systemFontOfSize:HEADERLAB_FONT];
    [self.view addSubview:_headerLab];
    
    _callImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerLab.frame) + 29, CGRectGetWidth(self.view.frame), PLAYERVIEW_HEIGHT)];
    _callImgV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_callImgV];
    
    _videoView = [[UIView alloc] initWithFrame:_callImgV.frame];
    _videoView.hidden = YES;
    [self.view addSubview:_videoView];
    
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_callImgV.frame) + AutoSize(140), CGRectGetWidth(self.view.frame), CONTROLVIEW_HEIGHT)];
    [self.view addSubview:controlView];
    
    int count = 2;
    if (self.isSameLan) {
        count = 3;
    }

    for (int i = 0; i < count; i++) {
        
        UIButton *controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        controlBtn.frame = CGRectMake(((CGRectGetWidth(self.view.frame) - count * CONTROLIMAGE_HEIGHT) / (count + 1)) * (i + 1) + CONTROLIMAGE_HEIGHT * i, 0, CONTROLIMAGE_HEIGHT, CGRectGetHeight(controlView.frame));
        controlBtn.titleLabel.font = [UIFont systemFontOfSize:HEADERLAB_FONT];
        [controlBtn setSelectedTitleColor:[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1] normalColor:[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1]];
        controlBtn.tag = i;
        [controlBtn addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:controlBtn];
        
        if (i == 0) {
            [controlBtn setSelectedImage:[UIImage imageNamed:@"hangup"] normalImage:[UIImage imageNamed:@"hangup"]];
            [controlBtn setTitle:@"挂断" forState:UIControlStateNormal];
        }
        if (i == 1) {
            [controlBtn setSelectedImage:[UIImage imageNamed:@"unlock"] normalImage:[UIImage imageNamed:@"unlock"]];
            [controlBtn setTitle:@"开锁" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [controlBtn setSelectedImage:[UIImage imageNamed:@"handsfree"] normalImage:[UIImage imageNamed:@"connect"]];
            [controlBtn setSelectedTitle:@"接通" normalTitle:@"接通"];
        }
        [controlBtn topImageAndBottomTitle:CONTROLBTN_MARGIN];
    }
    
//    _tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMinY(controlView.frame) - CGRectGetMaxY(_callImgV.frame) - HEADERLAB_FONT) / 2 + CGRectGetMaxY(_callImgV.frame), CGRectGetWidth(self.view.frame), HEADERLAB_FONT)];
//    _tipLab.text = @"开锁成功";
//    _tipLab.textAlignment = NSTextAlignmentCenter;
//    _tipLab.font = [UIFont systemFontOfSize:HEADERLAB_FONT];
//    _tipLab.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
//    [self.view addSubview:_tipLab];
    
    [self getInterLastImage];
}

- (void)getInterLastImage
{
    [SCMCloudControlManager getInterPhoneLastImageWithGuid:self.gwGuid success:^(NSDictionary *result) {
        if (result) {
            NSLog(@"获取图片 result = %@",result);
            int status = [result[@"status"] intValue];
            if (status == 0) {
                NSDictionary *resultDic = result[@"result"];
                if (resultDic) {
                    NSString *url = resultDic[@"url"];
                    if (url) {
                        if (_callImgV) {
//                            [_callImgV setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
                        }
                    }
                }
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

// 几个按钮的触发方法
- (void)controlClick:(UIButton *)sender
{
    
#pragma mark - 挂断
    if (sender.tag == 0) {
        /*
         // 局域网
        [self lanControlInterphone:ControlInterphoneTypeHangup success:^{
         [[DongDongManager shareDongDongManager] stopVideo];
         
        } fail:^(NSError *error) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：挂断失败\nerror:%@", error];
            NSLog(@"%@", errorMsg);
            [SCMToastTool toastText:errorMsg];
        }];*/
        
        // 广域网
        [self controlInterphone:ControlInterphoneTypeHangup success:^(NSDictionary *dict) {
            [[DongDongManager shareDongDongManager] stopVideo];
            [[SCMInterphoneManager shareInterphoneManager] closeCallReminderController];
        } fail:^(NSError *error) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：挂断失败\nerror:%@", error];
            NSLog(@"%@", errorMsg);
//            [SCMToastTool toastText:errorMsg];
        }];
        
    }
    
#pragma mark - 开锁
    if (sender.tag == 1) {
        /*
        // 局域网
        [self lanControlInterphone:ControlInterphoneTypeOpen success:^{
            NSString *msg = @"对讲机（局域网）：开锁成功";
            [SCMToastTool toastText:msg];
        } fail:^(NSError *error) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：开锁失败\nerror:%@", error];
            NSLog(@"%@", errorMsg);
            [SCMToastTool toastText:errorMsg];
        }];*/
        
        // 广域网
        [self controlInterphone:ControlInterphoneTypeOpen success:^(NSDictionary *dict) {
            NSString *msg = @"对讲机（广域网）：开锁成功";
//            [AppUtils showSuccessMessage:@"已开门"];
//            [SCMToastTool toastText:msg];
        } fail:^(NSError *error) {
            NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：开锁失败\nerror:%@", error];
            NSLog(@"%@", errorMsg);
//            [SCMToastTool toastText:errorMsg];
        }];
    }
    
#pragma mark - 接通
    if (sender.tag == 2) {
        if (!sender.selected) {
            /*
            // 局域网
            [self lanControlInterphone:ControlInterphoneTypeAnswer success:^{
                [[DongDongManager shareDongDongManager] initVideo];
                [[DongDongManager shareDongDongManager] startVideoWithView:_videoView remoteIp:self.ip remotePort:[self.port intValue] localPort:[self.port intValue]];
                
                _headerLab.text = @"正在视频通话";
                _videoView.hidden = NO;
                sender.selected = YES;
            } fail:^(NSError *error) {
                NSString *errorMsg = [NSString stringWithFormat:@"对讲机（局域网）：接通失败\nerror:%@", error];
                NSLog(@"%@", errorMsg);
                [SCMToastTool toastText:errorMsg];
            }];*/
            
            
            // 广域网
            [self controlInterphone:ControlInterphoneTypeAnswer success:^(NSDictionary *dict) {
                
                [[DongDongManager shareDongDongManager] initVideo];
                [[DongDongManager shareDongDongManager] startVideoWithView:_videoView remoteIp:self.ip remotePort:[self.port intValue] localPort:[self.port intValue]];
                
                _headerLab.text = @"正在视频通话";
                _videoView.hidden = NO;
                sender.selected = YES;
                
            } fail:^(NSError *error) {
                NSString *errorMsg = [NSString stringWithFormat:@"对讲机（广域网）：接通失败\nerror:%@", error];
                NSLog(@"%@", errorMsg);
//                [SCMToastTool toastText:errorMsg];
            }];
            
            sender.enabled = NO;
        }
//        else {
//            // 切换听筒/扬声器
//            [self changeVoiceOutput:sender];
//        }
    }
}

// 广域网控制操作
- (void)controlInterphone:(ControlInterphoneType)type success:(void(^)(NSDictionary *dict))success fail:(void(^)(NSError *error))fail
{
    SCMControlModelV3 *modelV3 = [[SCMControlModelV3 alloc] init];
    modelV3.version = @"3.0";
    modelV3.guid = self.guid;
    modelV3.service = @"com.joylink.indoor_phone";
    
    if (type == ControlInterphoneTypeAnswer || type == ControlInterphoneTypeHangup) {
        modelV3.member = @"videoControl";
        modelV3.type = @"function";
        
        SCMControlModelV3In *cmdIn = [[SCMControlModelV3In alloc] init];
        cmdIn.name = @"cmd";
        cmdIn.type = @"s";
        if (type == ControlInterphoneTypeAnswer) {
            cmdIn.value = @"answer";
        }
        if (type == ControlInterphoneTypeHangup) {
            cmdIn.value = @"hang_up";
        }
        
        SCMControlModelV3In* portIn = [[SCMControlModelV3In alloc] init];
        portIn.name = @"port";
        portIn.type = @"i";
        portIn.value = self.port;
        
        SCMControlModelV3In* ipIn = [[SCMControlModelV3In alloc] init];
        ipIn.name = @"ip";
        ipIn.type = @"s";
        ipIn.value = [XSGetIpAddress localWiFiIPAddress];
        
        modelV3.in =@[cmdIn, ipIn, portIn];
    }
    
    if (type == ControlInterphoneTypeOpen) {
        modelV3.member = @"outdoor_unit";
        modelV3.type = @"property";
        
        SCMControlModelV3In *In = [[SCMControlModelV3In alloc] init];
        In.name = @"outdoor_unit";
        In.type = @"s";
        In.value = @"on";
        
        modelV3.in = @[In];
    }
    [SCMCloudControlManager controlDeviceWithModelV2:nil modelV3:modelV3 version:@"3.0" success:^(NSDictionary *dict) {
        if ([dict[@"status"] integerValue] != 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:dict[@"error"]];
            if (fail) {
                fail(error);
            }
            return ;
        }
        if (success) {
            success(dict[@"result"]);
        }
    } fail:fail];

}

// 局域网控制操作
- (void)lanControlInterphone:(ControlInterphoneType)type success:(void(^)())success fail:(void(^)(NSError *error))fail
{
    NSArray *inArr;
    if (type == ControlInterphoneTypeHangup || type == ControlInterphoneTypeAnswer) {
        NSString *cmdData;
        if (type == ControlInterphoneTypeHangup) {
            cmdData = @"hang_up";
        }
        if (type == ControlInterphoneTypeAnswer) {
            cmdData = @"answer";
        }
        NSDictionary *cmd = @{
                              @"name":@"cmd",
                              @"data":cmdData,
                              @"type":@"s",
                              @"len":@(cmdData.length)
                              };
        NSDictionary *port = @{
                               @"name":@"port",
                               @"data":self.port,
                               @"type":@"i",
                               @"len":@4
                               };
        NSString *localIp = [XSGetIpAddress localWiFiIPAddress];
        NSDictionary *ip = @{
                             @"name":@"ip",
                             @"data":localIp,
                             @"type":@"s",
                             @"len":@(localIp.length)
                             };
        inArr = @[cmd, port, ip];
        [SCMLanDeviceControl functionControlWithService:self.service functionName:@"videoControl" inArray:inArr success:^(NSDictionary *result) {
            if (success) {
                success();
            }
        } fail:fail];
    }
    
    if (type == ControlInterphoneTypeOpen) {
        NSDictionary *In = @{
                              @"name":@"outdoor_unit",
                              @"data":@"on",
                              @"type":@"s",
                              @"len":@2
                              };
        [SCMLanDeviceControl propertyControl:self.service propertyName:@"outdoor_unit" inArray:@[In] success:^(NSDictionary *result) {
            if (success) {
                success();
            }
        } fail:fail];
    }
}

// 切换听筒/扬声器
- (void)changeVoiceOutput:(UIButton *)button
{
    if ([[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayback]) {
        //切换为听筒播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [button setImage:[UIImage imageNamed:@"handsfree"] forState:UIControlStateSelected];
    } else {
        //切换为扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [button setImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateSelected];
    }
}

@end
#endif
