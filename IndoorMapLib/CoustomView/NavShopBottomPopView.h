//
//  NavShopBottomPopView.h
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/15.
//  Copyright © 2015年 nv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMapKit.h"


@protocol NavShopBottomPopViewDelegate <NSObject>

//
-(void)goToHearBtnClickDeg:(id)sender;

-(void)showStallCodeDetailDeg:(NSString*)shopCode;

@end

// 点击商铺，在底部弹出的商铺信息窗口
@interface NavShopBottomPopView : UIView

@property (assign, nonatomic) id<NavShopBottomPopViewDelegate> delegate;
@property (strong, nonatomic) SWPickInfo *currPickInfo;
@property(nonatomic,strong) SWMapView *mapView;
@property (strong, nonatomic) NSString *storeCode;

// 中台中的线上商铺ID
@property (strong, nonatomic) NSString *zhongTaiShopId;

+ (instancetype)instance:(UIView*)containterView;

// 底部路径搜索视图是否显示状态
@property (assign, nonatomic) BOOL bIsShowing;

- (instancetype)initWithContainterView:(UIView*)containterView;

-(void)showMe:(BOOL)bShow;

@end
