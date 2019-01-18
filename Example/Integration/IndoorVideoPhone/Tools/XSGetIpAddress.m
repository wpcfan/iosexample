//
//  XSGetIpAddress.m
//  SCMSDKDemo
//
//  Created by zhaoaoxun on 2018/1/9.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "XSGetIpAddress.h"
#import <net/if.h> // 获取ip地址
#import <ifaddrs.h>
#import <arpa/inet.h>

#define NETWORK_PORT @"en0"

@implementation XSGetIpAddress

+ (NSString *)localWiFiIPAddress {
    
    NSString *_ipStr = nil;
    NSDictionary *ipDic = [self getIPAddresses];
    if (ipDic && [ipDic isKindOfClass:[NSDictionary class]]) {
        NSString *ipv4Key = [NSString stringWithFormat:@"%@/IPv4", NETWORK_PORT];
        NSString *ipv6Key = [NSString stringWithFormat:@"%@/IPv6", NETWORK_PORT];
        NSString *ipv4 = [ipDic objectForKey:ipv4Key];
        NSString *ipv6 = [ipDic objectForKey:ipv6Key];
        if (ipv4 && [ipv4 isKindOfClass:[NSString class]]) {
            _ipStr = ipv4;
        }else if(ipv6 && [ipv6 isKindOfClass:[NSString class]]){
            _ipStr = ipv6;
        }
        
    }
    return _ipStr;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags &IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue;// deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN,INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type =nil;
                if(addr->sin_family ==AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = @"IPv4";
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = @"IPv6";
                    }
                }
                if(type) {
                    NSString *key  = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

@end
