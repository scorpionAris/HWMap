//
//  Api.m
//  BaiduHtml5
//
//  Created by heb on 15-1-19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//



#import "Api.h"
#import "NavConstants.h"

#import "LocationUtil.h"
#import "NavCommonUtil.h"

#define WGS84LNG            @"wgs84Lng"
#define WGS84LAT            @"wgs84Lat"

#define DISTANCE            @"distance"
#define STORECODE           @"storeCode"

#define TIME_OUT        10

@implementation ActionInfo

-(id)initWith:(NSString*)url actionName:(NSString*)actionName
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

@end

@interface Api()<NSURLConnectionDataDelegate>
{
    NSURLConnection *conn;
    NSMutableString   *resDataBuffer;
    NSString *_tag;
}
@end

@implementation Api


-(instancetype)initWithTag:(NSString*)tag
{
    self = [super init];
    if (self) {
        _tag = tag;
    }
    return self;
}

+(void)cancelRequestWithTag:(NSString*)tag
{
    
    return;
}

-(NSString*)getHeader
{
    return @"{";
}

-(void)appendSeg:(NSString**)orgContent segName:(NSString*)segName segDoubleVal:(double)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : %lf ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : %lf ", *orgContent, segName, segVal];
    }
    return;
}
-(void)appendSeg:(NSString**)orgContent segName:(NSString*)segName segNumVal:(long long)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : %lld ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : %lld ", *orgContent, segName, segVal];
    }
    return;
}

-(void)appendSeg:(NSString**)orgContent segName:(NSString*)segName segVal:(NSString*)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : \"%@\" ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : \"%@\" ", *orgContent, segName, segVal];
    }
    
    return;
}

/// 添加记录集
-(void)appendRecordsSeg:(NSString**)orgContent segName:(NSString*)segName segVal:(NSString*)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    
    return;
}

-(void)appendSubSeg:(NSString**)orgContent segName:(NSString*)segName segVal:(NSString*)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    
    return;
}

-(void)appendListSeg:(NSString**)orgContent segName:(NSString*)segName segVal:(NSString*)segVal
{
    if([*orgContent length] <= 1)
    {
        *orgContent = [NSString stringWithFormat:@"%@ \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    else{
        *orgContent = [NSString stringWithFormat:@"%@, \"%@\" : %@ ", *orgContent, segName, segVal];
    }
    
    return;
}

-(void)appendTail:(NSString**)content
{
    *content = [NSString stringWithFormat:@"%@ }", *content];
    return ;
}
//------------

#pragma mark 地图数据、指纹数据版本检查
-(void)checkMapVersionIndoorId:(NSString*)indoorId mid:(NSString*)mid mapVer:(NSString*)mapVer
                       wifiVer:(NSString*)wifiVer fmtGeoVer:(NSString*)fmtGeoVer fmtWifiVer:(NSString*)fmtWifiVer
{
    NSString *content = [self getHeader];
    CHECK_STR(&mid);
    [self appendSeg:&content segName:SEG_MID segVal:mid];
    
    CHECK_STR(&indoorId);
    [self appendSeg:&content segName:SEG_INDOOR_ID segVal:indoorId];
    
    CHECK_STR(&mapVer);
    [self appendSeg:&content segName:SEG_MAP_VER segVal:mapVer];
    
    CHECK_STR(&wifiVer);
    [self appendSeg:&content segName:SEG_WIFI_VER segVal:wifiVer];
    
    CHECK_STR(&fmtGeoVer);
    [self appendSeg:&content segName:SEG_PSF_FMT_VER segVal:fmtGeoVer];
    
    CHECK_STR(&fmtWifiVer);
    [self appendSeg:&content segName:SEG_WIFI_FMT_VER segVal:fmtWifiVer];
    
    //[self appendSeg:&content segName:SEG_DATA_TYPE segVal:@"phone"];
    [self appendSeg:&content segName:SEG_DATA_TYPE segVal:@"pad"];

    
    
    [self appendSeg:&content segName:SEG_KEY segVal:API_KEY];
    
    [self appendTail:&content];
    
//    NSString *data=[NSString stringWithFormat:@"{\"mid\":%@, \"indoorId\":%@,\"mapver\":\"%@\",\"wifiver\":\"%@\"}",mid, indoorId, mapVer, wifiVer];
    NSLog(@"postUrl : %@", content);
    
    [self postUrl:VERSION_CHECK_METHORD reqData:content];
    
    return;
}

-(void)postUrl:(NSString *)funName reqData:(NSString *)data
{

//    if (resDataBuffer == nil)
    {
        resDataBuffer = nil;
        resDataBuffer = [NSMutableString stringWithCapacity:10];
    }
    
#ifdef Server_Bailian
    NSString *serverUrl = SERVER_URL_RELEASE;
    NSInteger nType = [[LocationUtil defaultInstance] getCurrServerEnv];
    if (nType == Server_SIT)
    {
        serverUrl = SERVER_URL_SIT;
    }
#endif
    
#ifdef Server_HuaWei
    NSString *serverUrl = [[NavCommonUtil shareInstance] serverApiUrl];
#endif
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@", serverUrl,funName];
    NSLog(@"--请求URL: %@", urlStr);
    NSLog(@"--请求体 : %@", data);
    
    ActionInfo *aci = [[ActionInfo alloc] initWith:urlStr actionName:funName];
    [self setActionInfo:aci];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
    [request setHTTPMethod:@"post"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
     queue:queue completionHandler:^(NSURLResponse *response, NSData *data,
                                     NSError *error)
     {
         
         if ([data length] >0 && (error == nil))
         {
             NSString *resData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"resData = %@", resData);
             if(self.callback){
                 self.callback(resData);
             }
         }
         else if (([data length] == 0) && (error == nil))
         {
             if(self.callback){
                 self.callback(nil);
             }
         }
         else if (error != nil)
         {
             NSLog(@"Error happened = %@", error);
             if (self.failureHandler) {//通知控制器，下载出错
                 self.failureHandler(error);
             }
         }
         
//
     }];

}


-(void)cancelRequest
{
    if (conn) {
        [conn cancel];
        self.failureHandler = nil;
        self.callback = nil;
    }
    
    return;
}

-(NSString*)postUrlSyn:(NSString *)funName reqData:(NSString *)data
{
#ifdef Server_Bailian
    NSString *serverUrl = SERVER_URL_RELEASE;
    NSInteger nType = [[LocationUtil defaultInstance] getCurrServerEnv];
    if (nType == Server_SIT)
    {
        serverUrl = SERVER_URL_SIT;
    }
#endif
    
#ifdef Server_HuaWei
    NSString *serverUrl = [[NavCommonUtil shareInstance] serverApiUrl];
#endif
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@", serverUrl,funName];
    
    NSLog(@"请求URL: %@", urlStr);
    NSLog(@"请求体 : %@", data);
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
    [request setHTTPMethod:@"post"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response;
    NSError *error;
    NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *dataStr=[[NSString alloc]initWithData:resData encoding:NSUTF8StringEncoding];
    
    return dataStr;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    return;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.callback){
        self.callback(resDataBuffer);
    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failureHandler) {//通知控制器，下载出错
        self.failureHandler(error);
    }
    
    return;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(self.callback){
        NSString *dataStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (dataStr != nil) {
            [resDataBuffer appendString:dataStr];
        }
        
        
    }
}
@end
