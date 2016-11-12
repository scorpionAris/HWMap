//
//  NavUtils.m
//  BaiduHtml5
//
//  Created by navinfoaec on 15/3/20.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "NavUtils.h"
#import <UIKit/UIKit.h>
#import "LocationUtil.h"
#import "NavConstants.h"

#define is_first_start      @"is_first_start"

NSString * _cityId;

NSString *_indoorId;

@implementation NavUtils

+(void)setAppStarted
{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    NSNumber *num = [[NSNumber alloc] initWithInteger:1];
    [user setObject:num forKey:is_first_start];
    [user synchronize];
    
    return;
}

+(BOOL)isAppFirstStart
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [defaults objectForKey:is_first_start];
    if (num == nil) {
        return YES;
    }
    NSInteger num2 = [num integerValue];
    if (num2 == 1) {
        return NO;
    }
    else{
        return YES;
    }
}


+(void)setCityId:(NSString*)cityId
{
    _cityId = cityId;
}

+(void)setIndoorId:(NSString*)indoorId
{
    _indoorId = indoorId;
}


+(NSString*)getIndoorId
{
    return _indoorId;
}
//

#pragma mark 获取地图数据下城市存储全路径
+(NSString*)getCityMapDataDir
{
    if ([NavUtils isBlank:_cityId]) {
        return nil;
    }
    NSString* mapPath = [NSString stringWithFormat:@"%@/mapdata/%@", PATH_MAP_DATA, _cityId];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:mapPath];
    NSError *err;
    if (!bRet)
    {
        [fileMgr createDirectoryAtPath:mapPath withIntermediateDirectories:YES attributes:nil error:&err];
    }
    
    return mapPath;
}

#pragma mark 获取地图数据下商场存储全路径
+(NSString*)getBuildingMapDataDir
{
    if ([NavUtils isBlank:_cityId]) {
        return nil;
    }
    if ([NavUtils isBlank:_indoorId]) {
        return nil;
    }
    NSString* mapPath = [NSString stringWithFormat:@"%@/mapdata/%@/%@", PATH_MAP_DATA, _cityId, _indoorId];
    NSLog(@"mapPath: %@", mapPath);
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:mapPath];
    NSError *err;
    if (!bRet)
    {
        [fileMgr createDirectoryAtPath:mapPath withIntermediateDirectories:YES attributes:nil error:&err];
    }
    
    return mapPath;
}

#pragma mark 获取当前城市业务数据存储全路径
+(NSString*)getBussinessDBFullPath
{
    if ([NavUtils isBlank:_cityId]) {
        return nil;
    }
    
    NSString *dbDir = [NavUtils getBuildingMapDataDir];
    if ([NavUtils isBlank:dbDir]) {
        return nil;
    }
    
    NSString *dbFullPath = [NSString stringWithFormat:@"%@/%@.db", dbDir, _indoorId];
    return dbFullPath;
}

#pragma mark 获取样式文件路径
+(NSString*)getStyleFileDir
{
    NSString* styleFilePath = [NSString stringWithFormat:@"%@/mapdata", PATH_MAP_DATA];
    NSLog(@"getStyleFileDir: %@", styleFilePath);
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:styleFilePath];
    NSError *err;
    if (!bRet)
    {
        [fileMgr createDirectoryAtPath:styleFilePath withIntermediateDirectories:YES attributes:nil error:&err];
    }
    
    return styleFilePath;
}

// 获取下载文件存储全路径
+(NSString*)getBuildingMapDataZipFullPath
{
    NSString *dir = [NavUtils getBuildingMapDataDir];
    NSString *fullPath = [dir stringByAppendingPathExtension:@"zip"];
    return fullPath;
}

//radiometa.json
// 读取PSF信息文件
+(NSDictionary*)readPSFInfo
{
    NSString *jsonDir = [NavUtils getBuildingMapDataDir];
    NSString *jsonPath = [jsonDir stringByAppendingString:@"/buildingInfo.json"];
    NSData * data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSDictionary *infoDic = nil;
    if (data) {
        NSError *err;
        infoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    
    return infoDic;
}


+(NSString*)getLocalPsfVersion
{
    NSString *version = nil;
    NSString *dir = [NavUtils getBuildingMapDataDir];
    if ([NavUtils isBlank:dir]) {
        return nil;
    }
    NSString *Json_path = [dir stringByAppendingPathComponent:@"info.json"];
    
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    if ([data length] > 0) {
        //==JsonObject
        NSError *error;
        NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
        
        version = [JsonObject valueForKey:RET_PSF_VERSION];
    }
    
    return version;
}

#pragma mark 增加或更新三方商场ID与四维图新室内ID的对应关系
+(BOOL)addMidToIndoorIdMap:(NSString*)mid indoorId:(NSString*)indoor
{
    BOOL bRet = NO;
    NSString *dir = [NavUtils getCityMapDataDir];
    NSString *Json_path = [dir stringByAppendingPathComponent:@"BuildingIdInfo.json"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSError *err;
    bRet = [fileMgr fileExistsAtPath:Json_path];
    // 检查有无文件
    if (bRet) {
        // 文件已经存在,则更新文件
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:Json_path];
        [dic setValue:indoor forKey:mid];
        [dic writeToFile:Json_path atomically:YES];
    }
    else{
        // 文件不存在，则创建并存储
        NSDictionary *idDic = @{mid:indoor};
        bRet = [idDic writeToFile:Json_path atomically:YES];
    }
    
    return bRet;
}

#pragma mark 根据三方的室内图ID获取对应的四维图新使用的室内图ID
+(NSString*)getIndoorIdByMid:(NSString*)Mid
{
    BOOL bRet = NO;
    NSString *indoorId = nil;
    // for test
//    NSString *indoorId = @"310003";
    
    NSString *dir = [NavUtils getCityMapDataDir];
    NSString *Json_path = [dir stringByAppendingPathComponent:@"BuildingIdInfo.json"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //    NSError *err;
    bRet = [fileMgr fileExistsAtPath:Json_path];
    if (bRet) {
        // 文件已经存在,则更新文件
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:Json_path];
        if (dic) {
            id val = [dic valueForKey:Mid];
            
            
            if (val) {
                if ([val isKindOfClass:[NSNumber class]]) {
                    indoorId = [val stringValue];
                }
                else{
                    indoorId = [dic valueForKey:Mid];
                }
            }

        }

        
    }
    
    return indoorId;
}

// add by niurg
+(NSString*)getMidByIndoorId:(NSString*)indoorId
{
    BOOL bRet = NO;
    // for test
    //    NSString *mid = @"1107";
    
    NSString *dir = [NavUtils getCityMapDataDir];
    NSString *Json_path = [dir stringByAppendingPathComponent:@"BuildingIdInfo.json"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //    NSError *err;
    bRet = [fileMgr fileExistsAtPath:Json_path];
    if (bRet) {
        // 文件已经存在,则更新文件
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:Json_path];
        if (dic) {
            for (id midTmp in dic.allKeys)
            {
                id indoorIdTmp = [dic objectForKey:midTmp];
                NSString *indoorIdStrTmp = nil;
                NSString *midStrTmp = nil;
                if ([indoorIdTmp isKindOfClass:[NSNumber class]])
                {
                    indoorIdStrTmp = [indoorIdTmp stringValue];
                }
                else if ([indoorIdTmp isKindOfClass:[NSString class]])
                {
                    indoorIdStrTmp = indoorIdTmp;
                }
                else{
                    continue;
                }
                
                if ([midTmp isKindOfClass:[NSNumber class]])
                {
                    midStrTmp = [midTmp stringValue];
                }
                else if ([midTmp isKindOfClass:[NSString class]])
                {
                    midStrTmp = midTmp;
                }
                else{
                    continue;
                }
                
                if ([indoorIdStrTmp isEqualToString:indoorId])
                {
                    return midStrTmp;
                }
                
            }
            // for loop end
            
        }
        
        
    }
    
    return indoorId;
}
// end


#pragma mark  记录指定建筑的地图数据版本号
+(BOOL)savePSFVersion:(NSString*)buildingId newVersion:(NSString*)newVersion
{
    BOOL bRet = NO;
    NSString *dir = [NavUtils getBuildingMapDataDir];
    NSString *Json_path = [dir stringByAppendingPathComponent:@"info.json"];
    NSString *jsonStr=[NSString stringWithFormat:@"{\"indoorId\":\"%@ \", \"mapver\":\"%@\",\"wifiver\":\"%@\"}", buildingId, newVersion, @""];
    
    NSData *JsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([JsonData length] > 0) {
        // 删除旧的版本号文件
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *err;
        bRet = [fileMgr fileExistsAtPath:Json_path];
        if (bRet) {
            BOOL bRet2 = [fileMgr removeItemAtPath:Json_path error:&err];
            if (!bRet2) {
                // 删除失败,一般情况非常少，暂时不处理
                return bRet;
            }
        }

        
        bRet = [JsonData writeToFile:Json_path atomically:YES];
    }
    
    return bRet;
}


// 设备主板本号
+ (NSUInteger) deviceSystemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}


//判断字符串是否为空
+(BOOL)isBlank:(NSString*)str
{
    if ((!str) || (str == nil) || ([str isEqual:[NSNull null]]) || ([str isEqualToString:@"null"]) ||
        ([str isEqualToString:@"(null)"]) || ([str isEqualToString:@"<null>"]) || ([str length] <= 0) ||
        ([str isKindOfClass:[NSNull class]]) ) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)isNotBlank:(NSString*)str
{
    BOOL bRet = [NavUtils isBlank:str];
    
    return !bRet;
}

// all 是否包含subString
+(BOOL)isContainsSubString:(NSString*)all sub:(NSString*)subString
{
    BOOL bRet = NO;
    
    if (IS_IOS_8) {
        bRet = [all containsString:subString];
    }
    else{
        NSRange ra = [all rangeOfString:subString];
        if (ra.location == NSNotFound) {
            bRet = NO;
        }
        else{
            bRet = YES;
        }
    }
    
    return bRet;
}
+(NSString*)checkVal:(NSString**)orgVal
{
    if ([NavUtils isBlank:*orgVal]) {
        *orgVal = @" ";
        return @" ";
    }
    return *orgVal;
}

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dict:(NSDictionary*)dict forKey:(NSString*)key
{
    NSString *value = [NSString stringWithFormat:@"%@",[dict valueForKey:key]];
    
    if (!value || [value isEqual:[NSNull null]] || [NavUtils isBlank:value] || [value isEqualToString:@"<null>"])
    {
        value = @"";
    }
    return value;
}

+ (id)dict:(NSDictionary*)dict forObject:(NSString*)key
{
    return [dict objectForKey:key];
}

#define BUNDLE_NAME @"navmap"

+ (NSBundle *)getBundle{
    
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: BUNDLE_NAME ofType: @"bundle"]];
}

+ (NSString *)getBundlePath: (NSString *) assetName{
    
    NSBundle *myBundle = [NavUtils getBundle];
    
    if (myBundle && assetName) {
        
        return [[myBundle resourcePath] stringByAppendingPathComponent: assetName];
    }
    
    return nil;
}

@end
