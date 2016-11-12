//
//  FileDownloader.m
//  BaiduHtml5
//
//  Created by heb on 15-1-19.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "FileDownloader.h"
#import "NavConstants.h"

@interface FileDownloader() <NSURLConnectionDataDelegate>
{
    
}
//请求对象
@property(nonatomic,strong)NSURLConnection *cnnt;
//文件句柄
@property(nonatomic,strong)NSFileHandle *writeHandle;
//当前获取到的数据长度
@property(nonatomic,assign)long long currentLength;
//完整数据长度
@property(nonatomic,assign)long long sumLength;

@end

@implementation FileDownloader
//开始下载
-(void)start
{
    _Downloading=YES;
    
    //创建一个请求
    NSURL *URL=[NSURL URLWithString:self.url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    //设置请求头信息
    //self.currentLength字节部分重新开始读取
    NSString *value=[NSString stringWithFormat:@"bytes=%lld-",self.currentLength];
    [request setValue:value forHTTPHeaderField:@"Range"];
    
    //发送请求（使用代理的方式）
    self.cnnt=[NSURLConnection connectionWithRequest:request delegate:self];
    
}

//暂停下载
-(void)pause
{
    _Downloading=NO;
    //取消发送请求
    [self.cnnt cancel];
    self.cnnt=nil;
}

#pragma mark- NSURLConnectionDataDelegate代理方法
/*
 *当接收到服务器的响应（连通了服务器）时会调用
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
#warning 判断是否是第一次连接
    if (self.sumLength){
        return;
    }
    
    //1.创建文件存数路径
//    NSString *filePath = [Utils getBuildingMapDataZipFullPath];
//    NSString *filePath=[fileDir stringByAppendingPathComponent:DOWNLOAD_ZIP_NAME];
    
//    self.destPath=filePath;
    
    
    //2.创建一个空的文件,到沙盒中
    NSFileManager *mgr=[NSFileManager defaultManager];
    //刚创建完毕的大小是o字节
//    [mgr createFileAtPath:filePath contents:nil attributes:nil];
    [mgr createFileAtPath:self.destPath contents:nil attributes:nil];
    
    
    //3.创建写数据的文件句柄
//    self.writeHandle=[NSFileHandle fileHandleForWritingAtPath:filePath];
    self.writeHandle=[NSFileHandle fileHandleForWritingAtPath:self.destPath];

    //4.获取完整的文件长度
    self.sumLength=response.expectedContentLength;
}

/*
 *当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //累加接收到的数据长度
    self.currentLength+=data.length;
    //计算进度值
    double progress=(double)self.currentLength/self.sumLength;
    //    self.progress.progress=progress;
    if (self.progressHandler) {//传递进度值给block
        self.progressHandler(progress);
        
        //相当于在此处调用了下面的代码
        //        ^(double progress)
        //        {
        //            //把进度的值，传递到控制器中进度条，以进行显示
        //            vc.progress.progress=progress;
        //        };
    }
    
    
    //一点一点接收数据。
//    NSLog(@"接收到服务器的数据！---%d",data.length);
    //把data写入到创建的空文件中，但是不能使用writeTofile(会覆盖)
    //移动到文件的尾部
    [self.writeHandle seekToEndOfFile];
    //从当前移动的位置，写入数据
    [self.writeHandle writeData:data];
}

/*
 *当服务器的数据加载完毕时就会调用
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"下载完毕----%lld",self.sumLength);
    //关闭连接，不再输入数据在文件中
    [self.writeHandle closeFile];
    self.writeHandle=nil;
    
    //清空进度值
    self.currentLength=0;
    self.sumLength=0;
    
    if (self.completionHandler) {//下载完成通知控制器
        self.completionHandler();
        //相当于下面的代码
        //        ^{
        //            NSLog(@"下载完成");
        //            [self.btn setTitle:@"下载已经完成" forState:UIControlStateNormal];
        //        }
    }
    
}
/*
 *请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failureHandler) {//通知控制器，下载出错
        self.failureHandler(error);
        //相当于调用了下面的代码
        //        ^{
        //            NSLog(@"下载错误！");
        //        }
    }
}

@end
