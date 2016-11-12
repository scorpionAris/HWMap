//
//  Api.h
//  BaiduHtml5
//
//  Created by heb on 15-1-19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionInfo : NSObject

-(id)initWith:(NSString*)url actionName:(NSString*)actionName;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *actionName;

@end

@interface Api : NSObject

@property (nonatomic, strong) ActionInfo *actionInfo;

@property(nonatomic,copy)void (^callback)(NSString *respStr);

//用来监听下载错误
@property(nonatomic,copy)void(^failureHandler)(NSError *error);

-(instancetype)initWithTag:(NSString*)tag;
+(void)cancelRequestWithTag:(NSString*)tag;

-(void)checkMapVersionIndoorId:(NSString*)indoorId mid:(NSString*)mid mapVer:(NSString*)mapVer
                       wifiVer:(NSString*)wifiVer fmtGeoVer:(NSString*)fmtGeoVer fmtWifiVer:(NSString*)fmtWifiVer;



-(void)cancelRequest;


@end
