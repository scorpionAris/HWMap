//
//  ShopModel.h
//  IndoorMapDemo
//
//  Created by Kevin Chou on 15/5/21.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Big_Kind_None,
    // 设施
    Big_Kind_POI,
    
    // 商铺分类
    Big_Kind_Space,
    
    // 商铺
    Big_Kind_Shop,
} emSearchBigType;

@interface ShopModel : NSObject
@property(nonatomic) NSInteger spaceId;

@property(nonatomic, assign)double dXPos;
@property(nonatomic, assign)double dYPos;

@property(nonatomic,assign)emSearchBigType nBigType;

@property(nonatomic,strong) NSString *type;

// poi:@"POI"   Space:@"SPACE"
@property(nonatomic,strong) NSString *dataType;

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *shopId;
@property(nonatomic,strong) NSString *stallCode;        // 和shop表、promotion表的address关联

@property(nonatomic,strong) NSString *floorName;

+ (ShopModel *)parseWithDict:(NSDictionary *)dict;
@end
