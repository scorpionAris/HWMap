//
//  LocationUtil.m
//  BaiduHtml5
//
//  Created by navinfoaec on 15/4/9.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "LocationUtil.h"


@implementation LocationUtil

+ (LocationUtil *)defaultInstance
{
    static LocationUtil *sharedLocationUtilInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationUtilInstance = [[self alloc] init];

        
    });
    return sharedLocationUtilInstance;
}


-(void)setDrawing:(BOOL)bDrawing
{
    if (_mapDelegate) {
        if ([_mapDelegate respondsToSelector:@selector(setInnerDrawing:)]) {
            [_mapDelegate setInnerDrawing:bDrawing];
        }
    }

    return;
}

@end
