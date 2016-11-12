//
//  NavigationBarView.h
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/12.
//  Copyright © 2015年 nv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarViewDelegate <NSObject>

// 返回按钮
-(void)backToPreViewClick:(id)sender;

// 快捷查询
-(void)quickSearchClick:(id)sender;

- (void)navTextFieldDidBeginEditing:(UITextField *)textField;

@end

@interface NavigationBarView : UIView

@property(nonatomic, strong)id<NavigationBarViewDelegate> navDelegate;

@end
