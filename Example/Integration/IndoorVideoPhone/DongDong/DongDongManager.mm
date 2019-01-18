//
//  DongDongManager.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/25.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "DongDongManager.h"
#import "MyMediaStackCallback.hpp"

@implementation DongDongManager

JDRTCVideoMediaStack *media_stack_ = nullptr;

+ (DongDongManager *)shareDongDongManager {
    static DongDongManager *_dongDongManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dongDongManager = [[super allocWithZone:NULL] init];
    });
    return _dongDongManager;
}

- (void)initVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        MyMediaStackCallback callback;
        if (media_stack_ == NULL) {
            media_stack_ = JDRTCVideoMediaStack::Create(&callback, nullptr);
        }
        
    });
}

- (void)startVideoWithView:(UIView *)view remoteIp:(NSString *)remoteIp remotePort:(int)remotePort localPort:(int)localPort {
    
    VideoMediaInfo info;
    info.remote_ip = std::string([remoteIp UTF8String]);
    info.local_port = localPort;
    info.remote_port = remotePort;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (media_stack_ == NULL) {
            return ;
        }
        media_stack_->StartVideoView(info, (__bridge void*)(view));
    });
}

- (void)stopVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (media_stack_ == NULL) {
            return ;
        }
        media_stack_->StopVideoView();
    });
}

@end
