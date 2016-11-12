//
//  NavFloorBtn.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/6/18.
//  Copyright (c) 2015年 nv. All rights reserved.
//

#define LeftBtn1_width      27.f
#define LeftBtn2_height     20.f

#import "NavFloorBtn.h"


@interface NavFloorBtn ()
{
    UIView *_mainView;
    CGPoint _parOrgPoint;
}
@end

@implementation NavFloorBtn


-(void)setInfo:(CGPoint)parOrgPoint MainView:(UIView*)mainView
{
    _mainView = mainView;
    _parOrgPoint = parOrgPoint;
    
    CGRect parFrame = self.frame;
    parFrame.origin.y = parOrgPoint.y + parFrame.origin.y;
    parFrame.origin.x = parOrgPoint.x;
    [self setFrameInMainView:parFrame];
    
    CGPoint leftCenter = CGPointZero;
    leftCenter.x = parOrgPoint.x;
    leftCenter.y = parFrame.origin.y + parFrame.size.height / 2;
    [self setLeftEdgeCenter:leftCenter];
    
    [self caculateLeft1BtnFrame];
    
    [self caculateLeft2BtnFrame];
    
    return;
}

-(void)caculateLeft1BtnFrame
{
    CGRect frame = CGRectZero;
    frame.origin.x = _leftEdgeCenter.x - LeftBtn1_width;
    frame.origin.y = _leftEdgeCenter.y - LeftBtn2_height / 2.f;
    
    frame.size.width = LeftBtn1_width;
    frame.size.height = LeftBtn2_height;
    
    [self setLeft1BtnFrame:frame];
    
    return;
}

-(void)caculateLeft2BtnFrame
{
    CGRect frame = CGRectZero;
    frame.origin.x = _leftEdgeCenter.x - LeftBtn1_width * 2;
    frame.origin.y = _leftEdgeCenter.y - LeftBtn2_height / 2.f;
    
    frame.size.width = LeftBtn1_width;
    frame.size.height = LeftBtn2_height;
    
    [self setLeft2BtnFrame:frame];
    
    return;
}

// 1:起点    2:终点
-(void)show1LeftBtn:(NSInteger)nType
{
    [self cleanLeftBtn];    
//    _left1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _left1Btn = [[UIImageView alloc] init];
//    _left1Btn.enabled = NO;
    [_left1Btn setFrame:_left1BtnFrame];
    NSString *imageName;
    if (nType == 1) {
        imageName = @"navmap.bundle/images/nav_start_point";
    }
    else if (nType == 2)
    {
        imageName = @"navmap.bundle/images/nav_end_point";
    }
    else{
        return;
    }
    UIImage * image = [UIImage imageNamed:imageName];
//    [_left1Btn setImage:image forState:UIControlStateNormal];
    [_left1Btn setImage:image];
    
    [_mainView addSubview:_left1Btn];
    
    return;
}

// 左侧显示2个icon的场合，最左侧为终点图标、其次为起点图标.
-(void)show2LeftBtn
{
    [self cleanLeftBtn];
    // 起点
    [self show1LeftBtn:1];
    
//    _left2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _left2Btn = [[UIImageView alloc] init];
//    [_left2Btn setEnabled:NO];
    
    [_left2Btn setFrame:_left2BtnFrame];
    NSString *imageName = @"navmap.bundle/images/nav_end_point";
    UIImage * image = [UIImage imageNamed:imageName];
//    [_left2Btn setImage:image forState:UIControlStateNormal];
    [_left2Btn setImage:image];
    
    [_mainView addSubview:_left2Btn];
    
    return;
}

-(void)cleanLeftBtn
{
    if (_left1Btn) {
        [_left1Btn removeFromSuperview];
    }
    
    if (_left2Btn) {
        [_left2Btn removeFromSuperview];
    }
    
    return;
}

// 显示隐藏
-(void)animaHide
{
    if (_left1Btn) {
        CGRect frame = _left1Btn.frame;
        frame.origin.y = _parOrgPoint.y;
        [_left1Btn setFrame:frame];
        [_left1Btn setHidden:YES];
    }
    
    if (_left2Btn) {
        CGRect frame = _left2Btn.frame;
        frame.origin.y = _parOrgPoint.y;
        [_left2Btn setFrame:frame];
        [_left2Btn setHidden:YES];
    }
    
    return;
}

// 动画显示
-(void)animaShow
{
    if (_left1Btn) {
        [_left1Btn setFrame:_left1BtnFrame];
        [_left1Btn setHidden:NO];
    }
    
    if (_left2Btn) {
        [_left2Btn setFrame:_left2BtnFrame];
        [_left2Btn setHidden:NO];
    }
    return;
}
@end
