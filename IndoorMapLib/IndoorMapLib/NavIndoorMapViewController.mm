//
//  NavIndoorMapViewController.m
//  BaiLian_Map
//
//  Created by navinfoaec on 15/3/18.
//  Copyright (c) 2015年 sw. All rights reserved.
//

#import "NavIndoorMapViewController.h"

#import <glkit/GLKit.h>
#import "SWMapKit.h"

#import "ZipArchive.h"
#import "GlobalMan.h"
#import <CoreGraphics/CGGeometry.h>
#include <string>

#import "FileDownloader.h"
#import "ZipArchive.h"
#import "Api.h"

#import "NavConstants.h"
#import "SWGeometry.h"


#import "UIViewController+Base.h"
#import "UIView+Frame.h"
#import "RouteButton.h"
#import "FloorTopButton.h"

#import "NavFloorBtn.h"


#import "NavigationBarView.h"

#import "NavFloorBarView.h"

#import "NavUtils.h"
#import "NavShopBottomPopView.h"

#import "NavCommonUtil.h"


using namespace std;

extern NSMutableArray *g_floorList;


@interface NavIndoorMapViewController ()<SWMapViewDelegate,
UIAlertViewDelegate,
NavigationBarViewDelegate,
NavFloorBarViewDelegate
>
{
    SWMapView *mapView;
    // 地图加载是否成功
    BOOL bMapLoadSucc;

    
#pragma mark new
    NSArray *floors;
    int spaceId_;
    int floorIndex_;
    
    NSMutableArray *floorBtns;
    NSMutableDictionary *floorNameToBtnIndexDic;
    
    UIView *locationContainerView;
    
    NavShopBottomPopView *_ShopBottomPopView;
    
    // 0: 未选择   1:选择起点  2:选择终点
    NSInteger nPointType;
    CGPoint startPoint;
    CGPoint endPoint;
    
    UIButton *lastSelFloorBtn;
    
    // 记录楼层视图的原始尺寸
    CGRect floorSelectViewFrame;
    
    
    NSNumber *currStartMarkId;
    NSNumber *currEndMarkId;
    
    
    NSMutableArray *usedMarkArr;
    
    SWMark *startMark;
    SWMark *endMark;
    // 用户位置跟踪mark
    SWMark *postingMark;
    
    // 四维图新用的室内图ID，与三方使用的storeCode是一一对应关系
    NSString *m_IndoorId;
    
    NSDictionary *m_versionInfoDic;
    
    FileDownloader *m_fd;
    
    UIActivityIndicatorView  *locationAiv;
    // 0:未定位状态      1:正在获取位置状态      2:正在跟踪定位状态
    NSInteger nLocationBtnStatus;
    
    FileDownloader *_radioFd;
    
    NSMutableArray* sLinks;
    NSMutableArray* eLinks;
    
    //CurBuildingType
    NSString *CurBuildingType;
    
    UIButton *_navSearchBtn;
    UIButton *_navRouteBtn;

    
    NavigationBarView *_navigationBar;
    
    // add by niurg 2015.11.13 start
    // 路径规划按钮
    UIButton *_routeBtn;
    // 地图上清除覆盖物按钮
    UIButton *_mapCleanBtn;

    UIStatusBarStyle _statusBarStyle;
    NavFloorBarView *_floorBarView;
    // end
    
    NSString *_orgStoreCode;
}

@property (strong, nonatomic) SWPickInfo *currStartPickInfo;
@property (strong, nonatomic) SWPickInfo *currEndPickInfo;

// 商户
@property(nonatomic, strong)NSString *stallCode;

// (暂时未用，保留)
@property(nonatomic, strong)NSString *Type;


// 按下POP的商铺名称按钮
- (IBAction)ShowShopDetail:(id)sender;

-(BOOL)MapdataHandle;
@end

@implementation NavIndoorMapViewController

//@synthesize storeCode;

@synthesize CityId;

-(void)setStoreCode:(NSString *)storeCode
{
    if (storeCode.length <= 0)
    {
        _storeCode = storeCode;
    }
    else
    {
        _orgStoreCode = storeCode;
        NSInteger nStoreCode = [storeCode integerValue];
        _storeCode = [NSString stringWithFormat:@"%ld", nStoreCode];
    }
    
    return;
}

- (void)BackToPreView
{
    
    [Api cancelRequestWithTag:VERSION_CHECK_METHORD];
    [self releaseResource];
    
    return;
}


#pragma mark NavigationBarViewDelegate
// 返回按钮
-(void)backToPreViewClick:(id)sender
{
    [self BackToPreView];
    
    if(![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // add by niurg 2015.11.12 start
    {
        // 添加导航条
        CGFloat fXPos = 10;
        CGFloat fYPos = 20;
        CGFloat fWidth = 43;
        CGFloat fHeight = 43;
        _navigationBar = [[NavigationBarView alloc] initWithFrame:kcr(fXPos, fYPos, fWidth, fHeight)];
        [_navigationBar setNavDelegate:self];
        [_navigationBar setHidden:YES];
        [self.view addSubview:_navigationBar];
        
        
        // 添加路径规划按钮
        _routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_routeBtn setBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:0.8]];
        [_routeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_routeBtn setHidden:YES];
        [_routeBtn setTitle:@"路径规划" forState:UIControlStateNormal];
        
        fWidth = 80.;
        CGFloat fRightOffSet = 10.;
        fXPos = SW - fRightOffSet - fWidth;
        fYPos = fYPos + fHeight + 25.;
        [_routeBtn setFrame:kcr(fXPos, fYPos, fWidth, fHeight)];
        [_routeBtn addTarget:self action:@selector(routeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_routeBtn];

        
        // 添加地图清除按钮
        _mapCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapCleanBtn setBackgroundColor:[UIColor colorWithRed:1. green:1. blue:1. alpha:0.8]];
        [_mapCleanBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_mapCleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mapCleanBtn setHidden:YES];
        fYPos = fYPos + fHeight + 10.;
        [_mapCleanBtn setFrame:kcr(fXPos, fYPos, fWidth, fHeight)];
        [_mapCleanBtn addTarget:self action:@selector(cleanMapBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_mapCleanBtn];
        
    }
    // end
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ShowMarker:)
                                                 name:@"ShowMarker" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ShowSearchResust:)
                                                 name:@"ShowSearchResust" object:nil];
    
    [self MapdataHandle];
    
    // 初始为地图未加载状态
    bMapLoadSucc = NO;

    
    
    usedMarkArr = [NSMutableArray arrayWithCapacity:2];
    sLinks = nil;
    eLinks = nil;

    if(!self.CityId)
    {
        // 如果没有从上级页面传递过来建筑ID，那么就设置默认为北京的城市ID
        self.CityId=@"310000";
    }
    
    if(!self.storeCode)
    {
        return;
    }
    
    [NavUtils setCityId:self.CityId];
    
    NSString *indoorId = [NavUtils getIndoorIdByMid:_orgStoreCode];
    // end
    
    [NavUtils setIndoorId:indoorId];

    
    nPointType = 1;
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return;
}

#pragma mark 视图显示后，加载地图数据
-(void)viewDidAppear:(BOOL)animated
{
    // 加载本地地图数据,目前此方法只能在viewDidLoad里调用
    [self loadLocalMapData];

    return;
}

-(void)releaseResource
{

    if (mapView) {
        [mapView navCleanScene];
        mapView = nil;
    }
    
    if (m_fd) {
        [m_fd pause];
    }
    return;
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"mapView:%@", mapView);
    
}

#pragma mark
-(void)setInnerDrawing:(BOOL)bDrawing
{
    [SWMapView setIsDrawing:bDrawing];

    return;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self setInnerDrawing:YES];
    
    // 如果加载地图不成功可能需要顶部的返回按钮
    if(bMapLoadSucc)
    {
        // 只有在从子窗口返回时需要隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
    
    return;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setInnerDrawing:NO];
    
    self.navigationController.navigationBarHidden = NO;
    
    return;
}

-(void)dealloc
{
    // 不能在willDisapear里追加，因为当前窗口对象未释放
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseResource];
    return;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 楼层相关处理
// chg by niurg 2015.11.14 start
-(void)floorViewInit
{
    CGFloat fWidth = 49;
    CGFloat fHeight = 50;
    CGFloat xPos = 10.0;
    CGFloat yPos = 120.;
    _floorBarView  = [[NavFloorBarView alloc] initWithFrame:kcr(xPos, yPos, fWidth, fHeight)];
    [_floorBarView setMapView:mapView];
    [_floorBarView setNavDelegate:self];
    [_floorBarView initFloorView];
    [self.view addSubview:_floorBarView];
    
    return;
}

#pragma mark NavFloorBarViewDelegate楼层切换代理
-(void)floorSwitchBtnClickDeg:(UIButton*)sender
{
    [self floorSwitchBtnClick:sender];
    
    return;
}

-(void)floorSwitchBtnClick:(id)sender
{
    NavFloorBtn *btn=sender;
    
    if (lastSelFloorBtn != btn) {
        [mapView changeByFloorNum:btn.floorNum];
        
        [lastSelFloorBtn setBackgroundColor:[UIColor whiteColor]];
        [lastSelFloorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        lastSelFloorBtn = btn;
        // 设置背景颜色高亮
        [btn setBackgroundColor:UIColorFromRGB(0x4e95fc)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [mapView setNeedsDisplay];
    }
    
    return;
}

- (IBAction)setStart:(id)sender {
    [mapView setNeedsDisplay];
}

- (IBAction)setEnd:(id)sender {
    [mapView setNeedsDisplay];
}

-(void)unhighlight
{
    [mapView unHighLight:@"poi"];
    [mapView unHighLight:@"space"];
    
    return;
}

-(void)routeButtonClicked
{
    if (!_currStartPickInfo) {
        [self showToast:@"请选择起点"];
        [self cleanRouteInfo];
        return;
    }
    else if(!_currEndPickInfo)
    {
        [self showToast:@"请选择终点"];
        return;
    }
    [self searchBtnClickedDeg:nil];

    return;
}

-(BOOL)MapdataHandle
{
    // move map data to doucment dir
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:PATH_MAP_DATA];
    BOOL bFirstStart = [NavUtils isAppFirstStart];
    
    if ((!bRet) || bFirstStart)
    {
        // 本地无此文件，或者是程序升级后第一次启动(有文件)，则将此文件拷贝到本地目录。
        if (bFirstStart) {
            // 如果是升级后启动，则需要清除本地旧数据
            if (bRet) {
                NSError *err;
                BOOL bRet3 = [fileMgr removeItemAtPath:PATH_MAP_DATA error:&err];
                
            }
            [NavUtils setAppStarted];
        }
        
        //        NSString *zipFilePath = [[NSBundle mainBundle] pathForResource:@"mht_bl" ofType:@"zip"];
        bRet = YES;
        
        // unzip
        NSString *zipFilePath = [NavUtils getBundlePath: @"mht_bl.zip"];
        NSString *unZipTo = [NSString stringWithFormat:@"%@", PATH_CACHE_INFO];
        
        ZipArchive* zip = [[ZipArchive alloc] init];
        if( [zip UnzipOpenFile:zipFilePath] )
        {
            bRet = [zip UnzipFileTo:unZipTo overWrite:YES];
            if(NO == bRet)
            {
                return NO;
            }
            [zip UnzipCloseFile];
        }
        else {
            return NO;
        }

    }
    
    return YES;
}

- (NSString*)dict:(NSDictionary*)dict forKey:(NSString*)key
{
    NSString *value = [NavUtils dict:dict forKey:key];
    return value;
}

int getFloorNumByName2(const std::string& strName)
{
    std::string strFloorNum = strName.substr(1, strName.size() - 1);
    std::string str = strName.substr(0, 1);
    if(str == "F")
    {
        return atoi(strFloorNum.c_str());
    }
    else
    {
        int nFloor = atoi(strFloorNum.c_str());
        return -1 * nFloor;
    }
}


static int nMarkId = 100;
#pragma mark SWMapViewDelegate

-(void)SWMapView:(SWMapView *)MapView didClickAtPoint:(CGPoint)Screen MapPoint:(CGPoint *)Mappoint Graphics:(NSDictionary *)Graphics
{
    CGFloat floorNum = [mapView getCurFloorNum];
    SWPickInfo *swPickInfo = [mapView pickModel:Screen.x Y:Screen.y floorIndex:floorNum objs:@"overlay_mark,poi,space"];
    if ([NavUtils isContainsSubString:swPickInfo.strSpaceName sub:@"禁止区"]) {
        
        return;
    }
    else if ([swPickInfo.strSpaceType isEqualToString:@"9990"]) {
        
        return;
    }
    else if (swPickInfo.pickInfoType == PickObj_None)
    {
        return;
    }
    
    
    if (nPointType == 1) {
        // 获取起点
        [self cleanRouteInfo];
        self.currStartPickInfo = swPickInfo;
        [self addRouteMark:MARK_POINT_START x:_currStartPickInfo.dXPos y:_currStartPickInfo.dYPos type:MARK_ROUTE floor:swPickInfo.strFloorName];
        
    }
    else if(nPointType == 2)
    {
        // 终点
        self.currEndPickInfo = swPickInfo;
        [self addRouteMark:MARK_POINT_END x:_currEndPickInfo.dXPos y:_currEndPickInfo.dYPos type:MARK_ROUTE floor:swPickInfo.strFloorName];
    }
    
    if (nPointType == 1) {
        nPointType = 2;
    }
    else if(nPointType == 2)
    {
        nPointType = 1;
    }
    
    return;
}


-(void)SWMapView:(SWMapView *)MapView didDoubleClickAtPoint:(CGPoint)Screen MapPoint:(CGPoint *)Mappoint Graphics:(NSDictionary *)Graphics
{
    //    [mapView resetInitialZoomScale];
    return;
}

/*!
 @method
 @abstract 地图移动响应事件
 @discussion
 @param MapView       移动的地图对象
 @param point1        移动的起始点地图坐标
 @param point2        移动的终点地图坐标
 @param Graphics      移动位置的图形要素对象
 @result 无返回值
 */
-(void)SWMapView:(SWMapView *)MapView didPanPoint:(CGPoint)point1 EndPoint:(CGPoint *)point2 Graphics:(NSDictionary *)Graphics
{

}

#pragma mark 地图初始化完成
-(void)SWMapViewInitDidFinish:(SWMapView*)MapView
{
    // 地图数据加载成功
    bMapLoadSucc = YES;

    // 楼层控件需要在地图加载完成后才能创建
    [self floorViewInit];

    
    [self.view insertSubview:mapView atIndex:0];
    
    // 隐藏旧的导航栏
    self.navigationController.navigationBarHidden = YES;
    // 显示新的导航栏
    [_navigationBar setHidden:NO];
    [_routeBtn setHidden:NO];
    [_mapCleanBtn setHidden:NO];
    
     [_navSearchBtn setHidden:NO];
    [_navRouteBtn setHidden:NO];

    [mapView setZoomFactor:60];
    [MapView configLanguageShow:true bShowEN:true];
    
    [mapView layoutPOI:26 gap:30];
    UIColor *color = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51./255 alpha:51./255];
    [mapView setFont:24 minSize:24 maxSize:24 steps:1 color:color];
    
    [self checkMapVersion];
    
    return;
}


-(void)swithcFloorByFloorName:(NSString*)strFloorName
{
    if ([NavUtils isBlank:strFloorName]) {
        return;
    }
    
    for(NavFloorBtn *btn in _floorBarView.floorBtns)
    {
        if([btn.titleLabel.text isEqualToString:strFloorName])
        {
            [btn setBackgroundColor:UIColorFromRGB(0x4e95fc)];
            [lastSelFloorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            lastSelFloorBtn = btn;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            // 需要检查当前层是否在可视区域
            [_floorBarView moveBtnToVisible:btn];
            
        }
        else
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    return;
}


-(void)loadLocalMapData
{
    // 检查本地是否有离线数据
    // 获取本地数据的版本号
    NSString *localVersion = [NavUtils getLocalPsfVersion];
    if ([NavUtils isNotBlank:localVersion])
    {
        // 检查有无PSF文件
        NSString* mapDir = [NavUtils getBuildingMapDataDir];
        if ([NavUtils isBlank:mapDir]) {
            [self checkMapVersion];
            return;
        }
        NSString *mapPath = [mapDir stringByAppendingPathComponent:PSF_FILE_NAME];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:mapPath];
        if (bRet)
        {
            // 本地有数据
            if (!mapView)
            {
                [self initMap:nil];
            }
            return;
        }
        else{
            //去服务器检查下载
            [self checkMapVersion];
        }
    }
    else{
        // 不能获取本地版本号，则去服务器检查新版本
        [self checkMapVersion];
    }
    
    return;
}

#pragma mark  版本检查
-(void)checkMapVersion
{

    [Api cancelRequestWithTag:VERSION_CHECK_METHORD];
    Api *api=[[Api alloc] initWithTag:VERSION_CHECK_METHORD];
    __weak typeof(self) weakSelf = self;
    api.failureHandler=^(NSError *error){
        NSString *resStr = [NSString stringWithFormat:@"checkMapVersion res failure: %@", error.description];
        
    };
    
    
    api.callback=^(NSString *data){
        NSString *resStr = [NSString stringWithFormat:@"checkMapVersion: %@", data];

        dispatch_async(dispatch_get_main_queue(), ^(){

            if (data == nil || (data.length == 0)) {
                m_versionInfoDic = nil;
                // 网络检查版本错误
            }
            else{
                m_versionInfoDic = [NavUtils dictionaryWithJsonString:data];
                
                NSString *mapurl=[m_versionInfoDic objectForKey:@"mapurl"];
                
                if ((m_versionInfoDic == nil) || ([NavUtils isBlank:mapurl]))
                {
                    m_versionInfoDic = nil;
                    // 网络检查版本错误

                }
                else
                {
                    NSLog(@"mapUrl: %@ ", m_versionInfoDic);
                    
                    NSString *retCode = [m_versionInfoDic valueForKey:RET_CODE];
                    NSInteger code = [retCode integerValue];
                    if (([NavUtils isBlank:mapurl]) || (code < 0))
                    {

                    }
                    else
                    {

                        NSString *mid = [m_versionInfoDic valueForKey:@"mid"];
                        // 取得indoorid
                        NSNumber *indoorNum = [m_versionInfoDic valueForKey:@"indoorId"];
                        NSString *indoorId = [indoorNum stringValue];
                        if ([NavUtils isNotBlank:indoorId]) {
                            //
                            [NavUtils setIndoorId:indoorId];

                            m_IndoorId = indoorId;
                        }
                        
                        // 数据包大小
                        NSNumber * geoSize = [m_versionInfoDic valueForKey:RET_PSD_DATA_SIZE_BYTE];
                        NSInteger nGeoSize = [geoSize integerValue];
                        NSString *serVersion = [m_versionInfoDic valueForKey:RET_PSF_VERSION];
                        // 获取本地数据的版本号
                        NSString *localVersion = [NavUtils getLocalPsfVersion];
                        if ([localVersion length] > 0)
                        {
                            // 与服务器上的版本号比较
                            NSComparisonResult res = [serVersion compare:localVersion];
                            if (res == NSOrderedDescending)
                            {
                                // 服务器上的版本大于本地版本,则提示用户有新版本地图数据

                            }
                        }
                        else{
                            // 用户第一次下载，需要提示
                            [weakSelf showNeedDownloadAlertView:serVersion mapUrl:mapurl dataPacketSize:nGeoSize];
                        }
                        
                    }
                }
            }// data is nil
        });
        
    };
    
    // 获取对应的四维图新用内部ID
    NSString *indoorId = [NavUtils getIndoorIdByMid:_orgStoreCode];
    // end
    
    // 获取本地数据的版本号
    NSString *localPsfVer = [NavUtils getLocalPsfVersion];
    NSString *localWifiVer = @"";
    //
    NSString *sdkVer = [GlobalMan getSDKVersion];
    
    // SDK的数据格式版本号
    NSString *fmtGeo = [SWMapView getSDKVersion];

    NSString *fmtWifiVer = @"";
    
    m_versionInfoDic = nil;
    [api checkMapVersionIndoorId:indoorId mid:self.storeCode mapVer:localPsfVer wifiVer:localWifiVer fmtGeoVer:fmtGeo fmtWifiVer:fmtWifiVer];
    
    return;
}

-(void)showNeedDownloadAlertView:(NSString*)versionNum mapUrl:(NSString*)mapUrl dataPacketSize:(NSInteger)dataSize
{
    NSString *tipMsg = [NSString stringWithFormat:@"初次显示地图需要下载数据,是否下载？"];
    NSString *title = [NSString stringWithFormat:@"地图数据下载"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:tipMsg                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    
    alert.tag = dataSize;
    [alert show];
    
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        NSString *serVersion = [m_versionInfoDic valueForKey:RET_PSF_VERSION];
        NSString *mapDataUrl=[m_versionInfoDic objectForKey:@"mapurl"];
        
        [self downloadMap:mapDataUrl version:serVersion];
    }
    else{
        [self BackToPreView];
        [self dismissViewController];
        
    }
    return;
}

- (void)dismissViewController
{
    if(![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)downloadMap:(NSString *)mapUrl version:(NSString*)serVersion
{
    // 删除旧的数据
    NSString* mapPath = [NavUtils getBuildingMapDataZipFullPath];
    
    NSLog(@"%@", mapUrl);
    
    m_fd = [[FileDownloader alloc]init];
    m_fd.url=mapUrl; // @"http://1.93.11.172:8888/fileserver/310051_1.zip";
    
    m_fd.destPath=mapPath;
    m_fd.progressHandler=^(double progress){
        NSLog(@"%f",progress);
    };
    
    __block NSString *destPath = m_fd.destPath;
    __weak typeof(self) weakSelf = self;
    __weak NSDictionary *m_versionInfoDicTmp = m_versionInfoDic;
    __block NSString *weakStoreCode = _orgStoreCode;
    m_fd.completionHandler=^{
        // 下载完成之后才更新本地的ID对应关系
        // 取得mid
        NSString *mid = [m_versionInfoDicTmp valueForKey:@"mid"];
        // 取得indoorid
        NSNumber *indoorNum = [m_versionInfoDicTmp valueForKey:@"indoorId"];
        NSString *indoorId = [indoorNum stringValue];
        if ([NavUtils isNotBlank:indoorId]) {
            //
            [NavUtils setIndoorId:indoorId];

            [NavUtils addMidToIndoorIdMap:weakStoreCode indoorId:indoorId];
            // end
            
            m_IndoorId = indoorId;
        }
        
        NSString *dir = [NavUtils getBuildingMapDataDir];
        BOOL bRet = [weakSelf unzip:destPath toDir:dir];
        if (bRet) {
            // 下载、解压缩完成,记录版本号到本地
            [NavUtils savePSFVersion:weakSelf.storeCode newVersion:serVersion];
            [weakSelf initMap:nil];
        }
        else{
            // 解压缩失败

        }
    };
    BOOL bMapLoadSucc2 = bMapLoadSucc;
    m_fd.failureHandler=^(NSError *error){
        
        // 网络检查版本错误
        
    };
    
    [m_fd start];
    
}

-(BOOL)unzip:(NSString *)file toDir:(NSString *)path
{
    BOOL bRet = NO;
    // 检查path目录是否存在，如果不存在则创建
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    bRet = [fileMgr fileExistsAtPath:path];
    NSError *err;
    if (!bRet)
    {
        BOOL bRet2 = [fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if (!bRet2) {
            // 创建失败,一般情况非常少，暂时不处理
            return NO;
        }
    }
    else{
        // 删除旧的文件夹
        BOOL bRet2 = [fileMgr removeItemAtPath:path error:&err];
        if (!bRet2) {
            // 删除失败,一般情况非常少，暂时不处理
            return NO;
        }
        // 创建新的
        bRet2 = [fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if (!bRet2) {
            // 创建失败,一般情况非常少，暂时不处理
            return NO;
        }
    }
    
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:file] )
    {
        bRet = [zip UnzipFileTo:path overWrite:YES];
        if( NO == bRet )
        {
            // 解压缩失败
        }
        [zip UnzipCloseFile];
        
        // 删除下载的压缩文件
        BOOL bRet2 = [fileMgr removeItemAtPath:file error:&err];
        if (!bRet2) {
            // 删除失败,一般情况非常少，暂时不处理
        }
    }
    
    return bRet;
}

// 开始初始化地图
-(void)initMap:(NSString*)styleName
{
    
    CGRect viewRec = [self.view frame];

    if (mapView) {
        [mapView clearOverlayer];
        [mapView navCleanScene];
        
        [mapView removeFromSuperview];
        mapView = nil;
        CGRect frame = self.view.frame;
        frame.origin.y = NAV_BAR_HEIGHT;
        frame.size.height -= NAV_BAR_HEIGHT;
        mapView = [[SWMapView alloc] initWithFrame:frame];
        mapView.mapDelegate = self;
        
        CGFloat yOff = [[UIScreen mainScreen] scale] * 70.;
        
        
        [self.view  addSubview:mapView];
    }
    else {
        CGRect frame = self.view.frame;
        frame.origin.y = NAV_BAR_HEIGHT;
        frame.size.height -= NAV_BAR_HEIGHT;
        mapView = [[SWMapView alloc] initWithFrame:frame];
        CGFloat yOff = [[UIScreen mainScreen] scale] * 70.;
        mapView.mapDelegate = self;
        [self.view  addSubview:mapView];
    }
    viewRec = mapView.frame;

    viewRec = [self.navigationController.navigationBar frame];

    NSString* mapDir = [NavUtils getBuildingMapDataDir];
    NSString *mapPath = [mapDir stringByAppendingPathComponent:PSF_FILE_NAME];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:mapPath];
    
    if ([NavUtils isBlank:mapPath]) {
        // 是否为正常路径，防止崩溃的现象
        return;
    }
    bool bRet2 = [mapView openMap:mapPath styleName:@""];
    if (!bRet2) {
        // 地图打开失败
        return;
    }

    // 默认显示中文
    [mapView configLanguageShow:YES bShowEN:NO];

    return;
}


-(void)onFloorChanged:(int)floorIndex
{
    NSString *floorName = [mapView getFloorNameByIndex:floorIndex];

    for (UIButton *btn in floorBtns) {
        if(btn.tag==floorIndex){

            [btn setBackgroundColor:UIColorFromRGB(0x4e95fc)];
            
        }else{
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

#pragma mark 侧边栏

// 清除地图
-(void)cleanMapBtnClick
{
    [self cleanRouteInfo];

    [self unhighlight];

    // 删除路径规划标记
    [mapView deletaMarkByType:MARK_ROUTE];
    
    
    // 删除搜索结果标记
    [mapView deletaMarkByType:MARK_SEARCH_RESULT];
    
    [mapView clearRoute];

    return;
}


#pragma mark 商铺窗体显示
-(void)showBottomShopView:(BOOL)bShow :(SWPickInfo*)pickInfo :(NSString*)zhongTaiShopId
{
    if (!_ShopBottomPopView) {
        _ShopBottomPopView = [[NavShopBottomPopView alloc] initWithContainterView:self.view];
        [_ShopBottomPopView setMapView:mapView];
    }
    [_ShopBottomPopView setCurrPickInfo:pickInfo];
    
    NSString *zhongTaiShopId2 = nil;
    if ([NavUtils isBlank:zhongTaiShopId]) {
        // 获取在中台中存在的线上商铺ID
        SWSpaceInfo *srTmp = [mapView getSpaceInfoByID:pickInfo.nSpaceID];
    }
    else{
        zhongTaiShopId2 = zhongTaiShopId;
    }
    
    [_ShopBottomPopView setZhongTaiShopId:zhongTaiShopId2];
    
    [_ShopBottomPopView showMe:bShow];
    
    return;
}


#pragma mark NavBottomRouteSearchViewDelegate 路径搜索代理方法

// 添加路线起终点标注
#define MARK_SIZE_COMM       25.f
- (void)addRouteMark:(int)type x:(double)x y:(double)y type:(NSString*)markType floor:(NSString*)floorName
{
    SWMark *mark = nil;
    if (type == MARK_POINT_END)
    {
        mark = endMark;
    }
    else if(type == MARK_POINT_START)
    {
        mark = startMark;
    }
    else{
        return;
    }
    
    // 添加原有MARK
    if (mark)
    {
        [mapView deletaMark:mark.nFID];
    }
    
    // create new mark
    mark = [[SWMark alloc] init];
    [mark setNFID:nMarkId];
    [mark setXPos:x];
    [mark setYPos:y];
    
    int nScale = [[UIScreen mainScreen] scale];
    [mark setNImageWidth:MARK_SIZE_COMM * nScale];
    [mark setNImageHeight:MARK_SIZE_COMM * nScale];
    [mark setStrRelativeInfo:@"mark"];
    
    if (type == MARK_POINT_END)
    {
        endMark = mark;
        [mark setStrImageName:@"icon_nav_end.png"];
    }
    else if(type == MARK_POINT_START)
    {
        startMark = mark;
        [mark setStrImageName:@"icon_nav_start.png"];
    }
    
    [mark setStrMarkType:markType];
    if ([NavUtils isNotBlank:floorName]) {
        [mark setStrFloorName:floorName];
    }
    
    // add mark
    [mapView addMark:mark];
    nMarkId++;
    
    return;
}

-(void)searchBtnClickedDeg:(UIButton*)sender
{
    // 计算路径，并且显示到地图上
    
    NSMutableArray *linkList = [self.currEndPickInfo linklist];
    NSInteger nLinks = [linkList count];
    eLinks = nil;
    if (nLinks > 0)
    {
        eLinks = [[NSMutableArray alloc] init];
    }
    for(int i = 0; i < nLinks; ++i)
    {
        NSNumber * linkid = [self.currEndPickInfo.linklist objectAtIndex:i];
        [eLinks addObject: linkid];
    }
    
    nLinks = self.currStartPickInfo.linklist.count;
    sLinks = nil;
    if (nLinks > 0)
    {
        
        sLinks = nil;
        sLinks = [[NSMutableArray alloc] init];
    }
    for(int i = 0; i < nLinks; ++i)
    {
        NSNumber * linkid = [self.currStartPickInfo.linklist objectAtIndex:i];
        [sLinks addObject: linkid];
    }
    
    NSMutableArray *points = [mapView computeRoute:_currStartPickInfo.fFloorNum
                                     LongitudeFrom:_currStartPickInfo.dXPos
                                      LatitudeFrom:_currStartPickInfo.dYPos
                                         slinkList:sLinks
                                           FloorTo:_currEndPickInfo.fFloorNum
                                       LongitudeTo:_currEndPickInfo.dXPos
                                        LatitudeTo:_currEndPickInfo.dYPos
                                         elinkList:eLinks Type:0];
    
    if (points.count >0 )
    {
        
        if (startMark) {
            [usedMarkArr addObject:startMark];
        }
        if (endMark) {
            [usedMarkArr addObject:endMark];
        }
        
        NSInteger nFloorCnt = [mapView getFloorCount];
        if (nFloorCnt > 1) {
            // 多于1个楼层时才显示
            
        }
    }
    
//    [self cleanRouteInfo];
    
    return;
}

-(void)cleanRouteInfo
{
    // 下次从起点开始搜索
    nPointType = 1;
    
    // 删除路径规划标记
    [mapView deletaMarkByType:MARK_ROUTE];

    self.currEndPickInfo = nil;
    self.currStartPickInfo = nil;
    
    // 删除路线
    [mapView clearRoute];

    return;
}
@end
