//
//  NavIndoorMapViewController.h
//  BaiLian_Map
//
//  Created by navinfoaec on 15/3/18.
//  Copyright (c) 2015年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavIndoorMapViewController : UIViewController

// 三方提供的城市ID(暂时未用，保留)
@property(nonatomic, strong)NSString *CityId;

// 三方提供的楼层ID（可选）
@property(nonatomic, strong)NSString *FloorId;

// 门店编码
@property(nonatomic, strong)NSString *storeCode;

/// 线上商户的铺位号，用于高亮显示铺位
@property(nonatomic, strong)NSString *placeNo;

/// 计算导航路径
-(void)autoComputeRoute;

- (void)BackToPreView;

-(void)releaseResource;

@end
