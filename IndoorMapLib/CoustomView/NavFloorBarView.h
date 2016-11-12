//
//  NavFloorBarView.h
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/13.
//  Copyright © 2015年 nv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMapKit.h"

@protocol NavFloorBarViewDelegate <NSObject>

-(void)floorSwitchBtnClickDeg:(UIButton*)sender;

@end

// 左侧的楼层控件
@interface NavFloorBarView : UIView

@property(nonatomic, strong)SWMapView *mapView;
@property(nonatomic, strong)NSMutableArray *floorBtns;

@property(nonatomic, assign)id<NavFloorBarViewDelegate> navDelegate;

-(void)initFloorView;

// 移动指定楼层按钮到可视区域
-(void)moveBtnToVisible:(UIButton*)btn;

@end
