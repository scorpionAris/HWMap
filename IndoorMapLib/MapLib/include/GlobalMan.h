//
//  GlobalMan.h
//  nimap_ios_lib
//
//  Created by navinfoaec on 14-4-25.
//  Copyright (c) 2014年 navinfoaec. All rights reserved.
//

/*!
 @header GlobalMan
 @abstract 全局信息
 @author niurg
 @version 1.00 2014/01/10 Creation
 */

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 全局信息类
 */
@interface GlobalMan : NSObject
+(NSStringEncoding)GetCurrentStringEncoding;


/*!
 @method
 @abstract 返回SDK的版本号
 @discussion
 @result 返回SDK的版本号 */
+(NSString*)getSDKVersion;

@end
