//
//  CateView.h
//  IndoorMapDemo
//
//  Created by Kevin Chou on 15/5/21.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMapKit.h"

/// nType:0 搜索POI   1:搜索中分类
typedef void (^CateBlock)(NSDictionary *dict, NSInteger nType);

@interface CateView : UIView

@property(nonatomic,strong) SWMapView *mapView;

+ (instancetype)instance:(CGRect)frame;

- (void)hide;

- (void)showWithData:(NSArray *)data completion:(CateBlock)completion;

// 是否显示键盘
-(void)ShowkeyBoardWithHeight:(CGFloat)keyBoardHeight show:(BOOL)bShow;

@end
