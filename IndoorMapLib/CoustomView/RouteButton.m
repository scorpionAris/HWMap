//
//  RouteButton.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/6/1.
//  Copyright (c) 2015年 nv. All rights reserved.
//

#import "RouteButton.h"
#import "NavConstants.h"

#define BOTTOM_VIEW_HEIGHT      100

@interface RouteButton ()
{
    UIImageView *_posImage;
    UILabel *_posTitle;
}

@end

@implementation RouteButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initControl
{
    CGFloat btnHeight = (BOTTOM_VIEW_HEIGHT - 3 * 5) / 2;
    CGFloat iconHeight = btnHeight - 2 * 3;
    CGFloat iconWidth = iconHeight / 5 * 3;
    _posImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, iconWidth, iconHeight)];
    [self addSubview:_posImage];
    
    CGFloat xPos = _posImage.frame.origin.x + _posImage.frame.size.width ;
    iconWidth = self.frame.size.width - iconWidth - 2;
    _posTitle = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 5, iconWidth, iconHeight)];
    [_posTitle setFont:[UIFont systemFontOfSize:18]];
    [_posTitle setTextColor:[UIColor blackColor]];
    [self addSubview:_posTitle];

    return;
}

-(void)setPosImage:(UIImage *)image
{
    // 添加起点图标
    if (_posImage) {
        [_posImage setImage:image];
    }
    
    return;
}
-(void)setPosTitle:(NSString*)title
{
    if (_posTitle) {
        [_posTitle setText:title];
    }
    
    if (([title isEqualToString:ROUTE_SEL_START_TIP]) || ([title isEqualToString:ROUTE_SEL_END_TIP])) {
        [_posTitle setTextColor:[UIColor grayColor]];
    }
    else{
        [_posTitle setTextColor:[UIColor blackColor]];
    }
    return;
}

@end
