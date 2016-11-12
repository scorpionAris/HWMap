//
//  NavigationBarView.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/12.
//  Copyright © 2015年 nv. All rights reserved.
//

#import "NavigationBarView.h"
#import "NavConstants.h"
#import "NavIndoorMapViewController.h"


// 按钮宽度
#define Back_Btn_Width      30.


// 分隔线
#define Separate_Line_Height    20.
#define Separate_Line_Width    1.


@interface NavigationBarView ()<UITextFieldDelegate>
{
    // 左侧的返回按钮
    UIButton *_leftBackBtn;
    
    // 左侧的竖分隔线
    UIImageView *_leftVerSeparateView;
    
    // 关键字搜索框
    UITextField *_searchTextField;
    
    // 右侧的竖分隔线
    UIImageView *_rightVerSeparateView;
    
    // 右侧的快捷搜索按钮
    UIButton *_rightSearchBtn;
    
}
@end


@implementation NavigationBarView

#define offset_dis      12

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init
        [self setBackgroundColor:[UIColor whiteColor]];
        // 返回按钮
        CGFloat fWidth = frame.size.height;
        CGFloat fHeight = fWidth;
        _leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect btnFrame = kcr(0, 0, fWidth, fHeight);
        [_leftBackBtn setFrame:btnFrame];
        [_leftBackBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navback"] forState:UIControlStateNormal];
        [_leftBackBtn addTarget:self action:@selector(backToPreView:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBackBtn setImageEdgeInsets:UIEdgeInsetsMake(offset_dis, offset_dis, offset_dis, offset_dis)];
        [self addSubview:_leftBackBtn];
        
    }
    
    return self;
}

// 返回按钮事件
-(void)backToPreView:(id)sender
{
    if ([_navDelegate respondsToSelector:@selector(backToPreViewClick:)]) {
        [_navDelegate backToPreViewClick:sender];
    }
    return;
}

// 快捷查询
-(void)quickSearch:(id)sender
{
    if ([_navDelegate respondsToSelector:@selector(quickSearchClick:)]) {
        [_navDelegate quickSearchClick:sender];
    }
    return;
}

#pragma mark   UITextFieldDelegate

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_navDelegate respondsToSelector:@selector(navTextFieldDidBeginEditing:)]) {
        [_navDelegate navTextFieldDidBeginEditing:textField];
    }
    
    NavIndoorMapViewController *mapVC = [self getSourceViewController];
    if (mapVC) {

    }
    return;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    return;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NavIndoorMapViewController*)getSourceViewController
{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           
           object != nil) {
        
        object = [object nextResponder];
        
    }
    
    UIViewController *uc=(UIViewController*)object;
    if ([uc isKindOfClass:[NavIndoorMapViewController class]])
    {
        return (NavIndoorMapViewController*)uc;
    }
    
    return nil;
}
@end
