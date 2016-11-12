//
//  FileDownloader.h
//  BaiduHtml5
//
//  Created by heb on 15-1-19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileDownloader : NSObject

//下载的远程url(连接到服务器的路径)
@property(nonatomic,strong)NSString *url;
//下载后的存储路径（文件下载到什么地方）
@property(nonatomic,strong)NSString *destPath;

@property(nonatomic,strong)NSDictionary *userInfoDic;
//是否正在下载(只有下载器内部清楚)
@property(nonatomic,readonly,getter = isDownloading)BOOL Downloading;
//用来监听下载进度
@property(nonatomic,copy)void (^progressHandler)(double progress);
//用来监听下载完成
@property(nonatomic,copy)void (^completionHandler)();
//用来监听下载错误
@property(nonatomic,copy)void(^failureHandler)(NSError *error);
-(void)pause;
-(void)start;



@end
