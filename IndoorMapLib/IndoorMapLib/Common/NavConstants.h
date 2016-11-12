//
//  NavConstants.h
//  BaiduHtml5
//
//  Created by navinfoaec on 15/3/20.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "NavUtils.h"


#ifndef BaiduHtml5_constants_h
#define BaiduHtml5_constants_h

#define Server_HuaWei

#define _DEMO_

#ifdef _TEST_SERVER_

#else

#endif

#define SERVER_URL_SIT  

#define SERVER_URL_RELEASE

// KEY
#define API_KEY     @"b25f75e537894bd58dc923fd2a7ae6e7"


#define SEARCH_PARAM_VALUE      @"17"


#define BOTTOM_VIEW_HEIGHT      100

// 导航栏高度
#define NAV_BAR_HEIGHT      0


#define SERVER_LOCATION             @""

#define SERVER_GET_MAC              @""


// PSF文件名
#define     PSF_FILE_NAME   @"index.dat"

#define IS_IOS_8 ([NavUtils deviceSystemMajorVersion] >= 8)
#define IS_IOS_7 ([NavUtils deviceSystemMajorVersion] >= 7)


#define HEIGHT_SWITCH_BTN 30
#define WIDTH_FLOOR_BTN 40
#define HEIGHT_FLOOR_BTN 30

// 顶部新地图数据包提示条的高度
#define MAP_DATA_UPDATE_TIP_VIEW_HEIGTH       30

#define CLOSE_BTN_WIDTH        23
#define CLOSE_BTN_HEIGTH        22

///  用户文档目录
#define PATH_DOCUMENT_INFO [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]

///  系统缓存目录
#define PATH_CACHE_INFO [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]

/// 保存地图数据的目录
#define PATH_MAP_DATA [PATH_CACHE_INFO stringByAppendingPathComponent:@"mht_bl"]

/// 保存优惠/促销数据的文档目录
#define PATH_COUPON_ACTIVITY_DATA [PATH_CACHE_INFO stringByAppendingPathComponent:@"promotionData"]

// 网络请求
#define RET_CODE        @"returnCode"

#define RET_PSF_VERSION @"mapver"

// 地图数据包大小，以字节为单位
#define RET_PSD_DATA_SIZE_BYTE  @"geoSize"

#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height


// 检查指定参数是否为空，如果为空则设置为@""
#define CHECK_STR(PARA) [NavUtils checkVal:(PARA)];


#define RETURN_CODE         @"returnCode"
#define res_Code         @"resCode"
#define res_Code_OK     @"00100000"


#define SEG_MID             @"mid"
#define SEG_INDOOR_ID       @"indoorId"

#define SEG_STORE_CODE      @"storeCode"

#define SEG_MAP_VER         @"mapver"
#define SEG_WIFI_VER        @"wifiver"

#define SEG_PSF_FMT_VER     @"fmtGeoVer"
#define SEG_WIFI_FMT_VER    @"fmtWifiVer"

#define SEG_DATA_TYPE       @"WifiDataType"
#define SEG_APP_VERSION     @"appVersion"

#define SEG_DEVICE_DPI      @"dpi"

#define SEG_KEY             @"key"
#define SEG_RECORDS         @"records"
#define SEG_MAC             @"mac"
#define SEG_USERNAME        @"username"
#define SEG_DEVICE          @"device"


#define VERSION_CHECK_METHORD   @"mapVersion"



//--

//
#define SEG_TIME        @"time"


#define checkStoreIndoorMap     @"checkStoreIndoorMap"

//
typedef NS_ENUM(UInt8, emRouteMarkType){
    // 普通
    MARK_POINT_END = 1,
    // 定位
    MARK_POINT_START,
    // 当前选中点
    MARK_POINT_CURRENT_SEL,
    // 未选中点
    MARK_POINT_NO_SEL
};


// 起始点、终止点标记
#define MARK_ROUTE          @"MARK_ROUTE"


// 搜索结果
#define MARK_SEARCH_RESULT         @"MARK_SEARCH_RESULT"


#define ROUTE_SEL_START_TIP      @"请选择起点"
#define ROUTE_SEL_END_TIP        @"请选择终点"



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define SW ([UIScreen mainScreen].bounds.size.width)

#define SH ([UIScreen mainScreen].bounds.size.height)


#define kcp(x,y) CGPointMake(x,y)

#define kcr(x,y,w,h) CGRectMake(x,y,w,h)


#endif
