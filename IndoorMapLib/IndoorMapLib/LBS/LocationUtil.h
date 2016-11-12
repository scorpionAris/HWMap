//
//  LocationUtil.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/4/9.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Server_Product,
    Server_SIT,
} emServer_Env;


@protocol MapUtilDelegate <NSObject>

-(void)setInnerDrawing:(BOOL)bDrawing;

@end


@interface LocationUtil : NSObject

@property(nonatomic, assign)id<MapUtilDelegate> mapDelegate;


/// 获取单例对象
+ (LocationUtil *)defaultInstance;


// bDrawing: YES:开始渲染   NO:暂停渲染
-(void)setDrawing:(BOOL)bDrawing;

@end
