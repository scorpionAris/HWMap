//
//  NavUtils.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/3/20.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class NVPoint;
@interface NavUtils : NSObject

+(void)setAppStarted;

+(BOOL)isAppFirstStart;

+(void)setCityId:(NSString*)cityId;


+(void)setIndoorId:(NSString*)indoorId;


+(NSString*)getIndoorId;


#pragma mark 获取地图数据下城市存储全路径
+(NSString*)getCityMapDataDir;

#pragma mark 获取地图数据下商场存储全路径
+(NSString*)getBuildingMapDataDir;

#pragma mark 获取当前城市业务数据存储全路径
+(NSString*)getBussinessDBFullPath;

#pragma mark 获取样式文件路径
+(NSString*)getStyleFileDir;

// 获取下载文件存储全路径
+(NSString*)getBuildingMapDataZipFullPath;

// 读取PSF信息文件
+(NSDictionary*)readPSFInfo;


// 读取当前PSF版本号
+(NSString*)getLocalPsfVersion;

// 记录指定建筑的地图数据版本号
+(BOOL)savePSFVersion:(NSString*)buildingId newVersion:(NSString*)newVersion;

+ (NSUInteger) deviceSystemMajorVersion;

#pragma mark 增加或更新三方商场ID与四维图新室内ID的对应关系
+(BOOL)addMidToIndoorIdMap:(NSString*)mid indoorId:(NSString*)indoor;

#pragma mark 根据三方的室内图ID获取对应的四维图新使用的室内图ID
+(NSString*)getIndoorIdByMid:(NSString*)Mid;
+(NSString*)getMidByIndoorId:(NSString*)indoorId;

//判断字符串是否为空
+(BOOL)isBlank:(NSString*)str;
+(BOOL)isNotBlank:(NSString*)str;

// all 是否包含subString
+(BOOL)isContainsSubString:(NSString*)all sub:(NSString*)subString;


+(NSString*)checkVal:(NSString**)orgVal;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString*)dict:(NSDictionary*)dict forKey:(NSString*)key;

+ (id)dict:(NSDictionary*)dict forObject:(NSString*)key;

+ (NSString *)getBundlePath: (NSString *) assetName;
+ (NSBundle *)getBundle;


@end
