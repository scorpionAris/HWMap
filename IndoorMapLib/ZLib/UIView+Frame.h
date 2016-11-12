//
//  UIView+Frame.h
//  BookReader
//
//  Created by Kevin Chou on 14-6-13.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define TT_FIX_CATEGORY_BUG(name) @interfaceTT_FIX_CATEGORY_BUG_##name @end@implementatio TT_FIX_CATEGORY_BUG_##name @end

@interface UIView (Frame)

@property(nonatomic,readwrite) CGFloat x;

@property(nonatomic,readwrite) CGFloat y;

@property(nonatomic,readwrite) CGFloat width;

@property(nonatomic,readwrite) CGFloat  height;

@property(nonatomic,readwrite) CGSize size;

@property(nonatomic,readonly) CGFloat maxX;

@property(nonatomic,readonly) CGFloat maxY;

@end
