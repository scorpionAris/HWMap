//
//  ShopModel.m
//  IndoorMapDemo
//
//  Created by Kevin Chou on 15/5/21.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+ (ShopModel *)parseWithDict:(NSDictionary *)dict
{
    ShopModel *model = [[ShopModel alloc] init];
    
    model.spaceId = [[dict objectForKey:@"spaceId"] integerValue];
    
    model.name = [dict objectForKey:@"name"];
    
    model.shopId = [dict objectForKey:@"shopId"];
    
    model.stallCode = [dict objectForKey:@"address"];
    
    return model;
}
@end
