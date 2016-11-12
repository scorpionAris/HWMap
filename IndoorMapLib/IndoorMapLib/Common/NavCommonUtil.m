//
//  NavCommonUtil.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/12/17.
//  Copyright © 2015年 nv. All rights reserved.
//

#import "NavCommonUtil.h"

@implementation NavCommonUtil

+ (NavCommonUtil *)shareInstance
{
    static NavCommonUtil *navCu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navCu = [[NavCommonUtil alloc] init];
        
        NSLog(@"创建静态对象: NavCommonUtil");
    });
    return navCu;
}

@end
