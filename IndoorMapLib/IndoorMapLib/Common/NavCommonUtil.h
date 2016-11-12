//
//  NavCommonUtil.h
//  IndoorMapLib
//
//  Created by navinfoaec on 15/12/17.
//  Copyright © 2015年 nv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavCommonUtil : NSObject

+ (NavCommonUtil *)shareInstance;

@property(nonatomic, strong)NSString *serverApiUrl;

@end
