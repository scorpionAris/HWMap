//
//  FloorTopButton.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/6/1.
//  Copyright (c) 2015年 nv. All rights reserved.
//

#import "FloorTopButton.h"

@interface FloorTopButton ()
{
    UILabel *_posTitle;
}
@end

@implementation FloorTopButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initControl
{
    CGRect tileFrame = self.frame;
    tileFrame.origin.x = 0;
    tileFrame.origin.y = 0;
    tileFrame.size.height = tileFrame.size.height / 3 * 2;
    
    _posTitle = [[UILabel alloc] initWithFrame:tileFrame];
    [_posTitle setFont:[UIFont systemFontOfSize:18]];
    [_posTitle setTextColor:[UIColor whiteColor]];
    [_posTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_posTitle];
    
    return;
}

-(void)setLabelTitle:(NSString*)title
{
    if (_posTitle) {
        [_posTitle setText:title];
    }
    return;
}

@end
