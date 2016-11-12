//
//  NavFloorBtn.h
//  IndoorMapLib
//
//  Created by navinfoaec on 15/6/18.
//  Copyright (c) 2015年 nv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavFloorBtn : UIButton

// 楼层名称
@property(nonatomic, strong)NSString *floorName;

// 楼层号
@property(nonatomic, assign)NSInteger floorNum;

@property(nonatomic, assign)CGRect frameInMainView;

@property(nonatomic, assign)CGPoint leftEdgeCenter;

/// 楼层左侧的第一个按钮区域
@property(nonatomic, assign)CGRect left1BtnFrame;
//@property(nonatomic, strong)UIButton *left1Btn;
@property(nonatomic, strong)UIImageView *left1Btn;

/// 楼层左侧的第二个按钮区域(起点、终点在同一层的场合使用)
@property(nonatomic, assign)CGRect left2BtnFrame;
//@property(nonatomic, strong)UIButton *left2Btn;
@property(nonatomic, strong)UIImageView *left2Btn;

-(void)setInfo:(CGPoint)parOrgPoint MainView:(UIView*)mainView;

// 1:起点    2:终点
-(void)show1LeftBtn:(NSInteger)nType;

// 左侧显示2个icon的场合，最左侧为终点图标、其次为起点图标.
-(void)show2LeftBtn;

-(void)cleanLeftBtn;

// 显示隐藏
-(void)animaHide;
// 动画显示
-(void)animaShow;
@end
