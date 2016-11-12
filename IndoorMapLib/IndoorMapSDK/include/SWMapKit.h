//
//  SWMapKit.h
//  nimap_ios_lib
//
//  Created by navinfoaec on 14-1-7.
//  Copyright (c) 2014年 navinfoaec. All rights reserved.
//
/*!
 @header SWMapKit
 @abstract 显示地图的视图相关类定义文件
 @author niurg
 @version 1.00 2014/01/10 Creation
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <glkit/GLKit.h>
#import "SWGeometry.h"

/*!
 @enum
 @abstract 指南针位置枚举类型定义
 @constant CompassLeftTop       左上
 @constant CompassLeftBottom    左下
 @constant CompassRightTop      右上
 @constant CompassRightBottom   右下
 */
typedef enum
{
    Compass_None = 0,
    CompassLeftTop,
    CompassLeftBottom,
    CompassRightTop,
    CompassRightBottom
}CompassLocation;

/*!
 @property
 @abstract 指北针的属性信息
 @param BOOL    visible             是否可见
 @param CompassLocation    loc      位置
 @param CGFloat marginX    x边距
 @param CGFloat marginY    y边距
 */
typedef struct _stCompassLocation
{
    BOOL			visible;
    CompassLocation	loc;
    CGFloat			marginX;
    CGFloat			marginY;
}stCompassLocation;

/*!
 @property
 @abstract 拾取的空间单元类型
 @param     PickObj_None            未选中任何空间单元
 @param     PickObj_Floor           楼层面
 @param     PickObj_Poi             设施
 @param     PickObj_Space           空间面
 @param     PickObj_Overlay_Mark        覆盖物标注
 @param     PickObj_Overlay_Polyline    覆盖物线
 */
typedef enum
{
    PickObj_None = 0,
    PickObj_Floor,
    PickObj_Poi,
    PickObj_Space,
    PickObj_Overlay_Mark,
    PickObj_Overlay_Polyline
}emPickObjType;


/*!
 @class
 @abstract 坐标点类
 */
@interface SWNVPoint : NSObject

/*!
 @property
 @abstract 空间单元的中心点位置X坐标
 */
@property(nonatomic, assign)double dXPos;

/*!
 @property
 @abstract 空间单元的中心点位置Y坐标
 */
@property(nonatomic, assign)double dYPos;

/*!
 @property
 @abstract 楼层号
 */
@property(nonatomic, assign)CGFloat floorNum;
@end

///////////////
/*!
 @class
 @abstract 地图比例尺控制类
 */
@interface SWScaleExtent : NSObject

/*!
 @property
 @abstract 最小缩放级别
 */
@property(nonatomic, assign)double dMinScale;

/*!
 @property
 @abstract 最大缩放级别
 */
@property(nonatomic, assign)double dMaxScale;

/*!
 @property
 @abstract 楼层号，根据具体场景决定是否有效
 */
@property(nonatomic, assign)CGFloat floorNum;

@end

/////////////////////////////////////////////////////////
/*!
 @class
 @abstract 空间面信息类
 */
@interface SWSpaceInfo : NSObject

/*!
 @property
 @abstract 空间单元名称
 */
@property(nonatomic, strong)NSString* strSpaceName;
/*!
 @property
 @abstract 空间单元类型代码
 */
@property(nonatomic, strong)NSString* strSpaceType;
/*!
 @property
 @abstract 空间单元Code(铺位唯一ID，可用于与业务数据对接)
 */
@property(nonatomic, strong)NSString* strSpaceCode;

/*!
 @property
 @abstract 空间单元的所有顶点位置坐标
 */
@property(nonatomic, strong)NSArray *pointList;

/*!
 @property
 @abstract 空间单元的中心点位置X坐标
 */
@property(nonatomic, assign)double dSpaceCenterX;
/*!
 @property
 @abstract 空间单元的中心点位置Y坐标
 */
@property(nonatomic, assign)double dSpaceCenterY;
/*!
 @property
 @abstract 空间单元ID
 */
@property(nonatomic, assign)NSInteger nSpaceID;

/*!
 @property
 @abstract 空间单元的楼层名称
 */
@property(nonatomic, strong)NSString* strFloorName;

/*!
 @property
 @abstract 空间单元的楼层号
 */
@property(nonatomic, assign)CGFloat fFloorNum;
/*!
 @property
 @abstract 空间单元的相关Link列表，用于路径规划。
 */
@property(nonatomic, strong) NSMutableArray* linklist;
/*!
 @property
 @abstract 相关的附属信息
 */
@property(nonatomic, strong)NSString* strRelativeInfo;
@end

/////////////////////////////////////////////////////////
/*!
 @class
 @abstract 点选的空间单元信息类
 */
@interface SWPickInfo : NSObject

/*!
 @property
 @abstract 拾取的空间单元类型
 @param emPickObjType   pickInfoType 是否可见
 */
@property(nonatomic, assign)emPickObjType pickInfoType;
/*!
@property
@abstract 空间单元名称
*/
@property(nonatomic, strong)NSString* strSpaceName;
/*!
 @property
 @abstract 空间单元类型代码
 */
@property(nonatomic, strong)NSString* strSpaceType;
/*!
 @property
 @abstract 空间单元的Code(摊位ID)
 */
@property(nonatomic, strong)NSString* strSpaceCode;
/*!
 @property
 @abstract 空间单元的中心点位置X坐标
 */
@property(nonatomic, assign)double dXPos;
/*!
 @property
 @abstract 空间单元的中心点位置Y坐标
 */
@property(nonatomic, assign)double dYPos;
/*!
 @property
 @abstract 空间单元的ID号
 */
@property(nonatomic, assign)NSInteger nSpaceID;
/*!
 @property
 @abstract 空间单元的相关Links，用于路径规划
 */
@property(nonatomic, strong) NSMutableArray* linklist;
/*!
 @property
 @abstract 相关的附属信息
 */
@property(nonatomic, strong)NSString* strRelativeInfo;

/*!
 @property
 @abstract 楼层名称
 */
@property(nonatomic, strong)NSString* strFloorName;

/*!
 @property
 @abstract 楼层号
 */
@property(nonatomic, assign)CGFloat fFloorNum;

@end

/////////////////////////////////////////////////////////
/*!
 @class
 @abstract POI信息类
 */
@interface SWPOIInfo : NSObject

/*!
 @property
 @abstract POI名称
 */
@property(nonatomic, strong)NSString* strPOIName;
/*!
 @property
 @abstract POI类型
 */
@property(nonatomic, strong)NSString* strPOIType;

/*!
 @property
 @abstract POI的中心点位置X坐标
 */
@property(nonatomic, assign)double dCenterX;
/*!
 @property
 @abstract POI的中心点位置Y坐标
 */
@property(nonatomic, assign)double dCenterY;
/*!
 @property
 @abstract POI唯一ID
 */
@property(nonatomic, assign)NSInteger nPOIID;

/*!
 @property
 @abstract POI的楼层名称
 */
@property(nonatomic, strong)NSString* strFloorName;

/*!
 @property
 @abstract POI的楼层号
 */
@property(nonatomic, assign)CGFloat fFloorNum;

/*!
 @property
 @abstract 空间单元的相关Links，用于路径规划
 */
@property(nonatomic, strong) NSMutableArray* linklist;

@end
//////////////////////////////////////////////////////////


@protocol SWMapViewDelegate;

/*!
 @class
 @abstract 地图视图类
 */
@interface SWMapView : GLKView<GLKViewDelegate, UIGestureRecognizerDelegate>

/*!
 @property
 @abstract 地图视图类的代理
 */
@property (nonatomic, assign) id<SWMapViewDelegate> mapDelegate;

/*!
 @method
 @abstract 打开地图数据
 @discussion
 @param NSString* strPathFileName 数据文件全路径
 @param NSString* styleName 样式文件全路径
 @result 成功返回YES，失败返回NO.
 */
-(BOOL)openMap:(NSString*)strPathFileName styleName:(NSString*)styleName;

/*!
 @method
 @abstract 设置地图的初始角度
 @discussion
 @param double angle 初始旋转角度
 @result 无返回值
 */
-(void)setDefaultMapAngle:(double) angle;

/*!
 @method
 @abstract 设置是否绘制地图
 @discussion
 @param BOOL bDrawing 是否绘制地图，APP进入后台时,通过此方法停止地图的渲染，重新进入前台需要通过此方法开始地图的渲染。
 @result 无返回值
 */
+(void) setIsDrawing:(BOOL)bDrawing;

/*!
 @method
 @abstract 设置指南针在屏幕上的显示属性
 @discussion
 @param stCompassLocation stCompassInfo 显示属性值
 @result 无返回值
 */
-(void)setCompassInfo:(stCompassLocation)stCompassInfo;

/*!
 @method
 @abstract 获取指南针在屏幕上的显示属性
 @discussion
 @param 无
 @result 返回指南针当前的显示属性
 */
-(stCompassLocation)getCompassInfo;

/*!
 @method
 @abstract 设置DPI.
 @discussion
 @param nDPI	设备DPI值
 @result 无返回值
 */
-(void)setDPI:(NSInteger)nDPI;

/*!
 @method
 @abstract 设置POI布局.
 @discussion
 @param nSize	POI大小.	Unit: Pixel.
 @param nGap	POI间距.	Unit: Pixel.
 @result 无返回值
 */
-(void)layoutPOI:(NSInteger)nSize gap:(NSInteger)nGap;

/*!
 @method
 @abstract 设置字体文件的名称
 @discussion
 @param	NSString*   strFontFile		字体文件的名称
 @result 无返回值
 */
-(void)setFontFile:(NSString*)strFontFile;

/*!
 @method
 @abstract 设置字体显示属性。		Unit: Pixel
 @discussion
 @param	NSInteger   nSize		基准大小.
 @param	NSInteger   nMinSize	最小尺寸.
 @param	NSInteger   nMaxSize	最大尺寸.
 @param	NSInteger   nSteps		最小、最大尺寸的总步长数量.
 @param	UIColor*    color		文字颜色
 @result 无返回值
 */
-(void)setFont:(NSInteger)nSize minSize:(NSInteger)nMinSize maxSize:(NSInteger)nMaxSize steps:(NSInteger)nSteps color:(UIColor*)color;

/*!
 @method
 @abstract 设置注记锚点属性。
 @discussion
 @param	bShow	是否显示.
 @param	nSize	尺寸.	Unit: Pixel
 @param	color	颜色.
 @result 无返回值
 */
-(void)setAnnoAnchor:(BOOL)bShow size:(NSInteger)nSize color:(UIColor*)color;

/*!
 @method
 @abstract 设置手势缩放灵敏度
 @discussion
 @param float zoomFactor 缩放因数
 @result 无返回值
 */
-(void)setZoomFactor:(float)zoomFactor;

/*!
 @method
 @abstract 设置地图显示的比例尺范围，调用此方法后需要调用saveBuildingInfo，来将此参数存储下来.
 @discussion
 @param SWScaleExtent scaleEx 当前地图的最大、最小比例尺
 @result 无返回值
 */
-(void)setScaleRange:(SWScaleExtent*)scaleEx;

/*!
 @method
 @abstract 将之前设置的比例尺参数保存到buildingInfo文件
 @discussion
 @param SWScaleExtent scaleEx 当前地图的最大、最小比例尺
 @result 无返回值
 */
-(void)saveBuildingInfo;

/*!
 @method
 @abstract 获取地图显示的比例尺范围
 @discussion
 @param 无
 @result 返回当前地图比例尺范围
 */
-(SWScaleExtent*)getScaleRange;


/*!
 @method
 @abstract 清空场景资源，在更新地图时用于重新打开地图之前的清空操作。
 @discussion
 @result 无
 */
-(void)navCleanScene;

/*!
 @method
 @abstract 恢复默认缩放比例
 @discussion
 @result 无
 */
-(void)resetDefautlZoomScale;

/*!
 @method
 @abstract 获取当前地图的数据格式版本号
 @discussion
 @result 成功返回版本号
 */
+(CGFloat)getGeoFmtVersion;

/*!
 @method
 @abstract 获取当前地图SDK版本号
 @discussion
 @result 成功返回版本号
 */
+(NSString*)getSDKVersion;

@end

@class SWGeometry;
/*!
 @class
 @abstract 地图类中室内图相关处理接口
 */
@interface SWMapView(IndoorMapKit)

/*!
 @method
 @abstract 获取当前显示的建筑物的名称
 @discussion
 @result 成功返回建筑的名称，失败返回nil。
 */
-(NSString*)getCurrBuildingName;

/*!
 @method
 @abstract 获取当前显示的建筑物的类型
 建筑物的分类代码
 商场     200000
 家居     300000
 超市     199999
 停车场    400000
 机场     700000
 @discussion
 @result 成功返回建筑的类型，失败返回nil。
 */
-(NSString*)getCurBuildingType;

/*!
 @method
 @abstract 获取指定索引的建筑物的楼层总数量
 @discussion
 @result 成功返回指定索引的建筑的楼层总数量
 */
-(NSInteger)getFloorCount;

/*!
 @method
 @abstract 获取当前楼层号
 @discussion
 @result 返回楼层号，失败返回值小于-10000.0。支持跃层楼层号，比如1.5代表1层半
 */
-(CGFloat)getCurFloorNum;

/*!
 @method
 @abstract 通过楼层号切换楼层
 @discussion
 @param CGFloat fFloorNum     楼层号
 @result 无返回值
 */
-(void)changeByFloorNum:(CGFloat)fFloorNum;

/*!
 @method
 @abstract 通过楼层名称切换楼层
 @discussion
 @param NSString strFloorName  楼层名称
 @result 无返回值
 */
-(void)changeByFloorName:(NSString*)strFloorName;

/*!
 @method
 @abstract 通过楼层号获取当前建筑物的楼层名称
 @discussion
 @param CGFloat fFloorNum     楼层号
 @result 成功返回建筑物的楼层名称，失败返回nil。
 */
-(NSString*)getFloorName:(CGFloat)fFloorNum;

/*!
 @method
 @abstract 通过楼层索引获取当前建筑物的楼层名称
 @discussion
 @param NSInteger index     楼层索引
 @result 成功返回建筑物的楼层名称，失败返回nil。
 */
-(NSString*)getFloorNameByIndex:(NSInteger)index;

/*!
 @method
 @abstract 获取指定建筑物的指定楼层号
 @discussion
 @param NSString floorName     楼层名称
 @result 成功返回建筑物的楼层号，失败返回-10000.0
 */
-(CGFloat)getFloorNumByName:(NSString*)floorName;

/*!
 @method
 @abstract 获取指定建筑物的指定楼层号
 @discussion
 @param NSInteger floorIndex     楼层索引
 @result 成功返回建筑物的楼层号，失败返回-10000。
 */
-(CGFloat)getFloorNumByIndex:(NSInteger)floorIndex;

/*!
 @method
 @abstract      根据楼层号获取指定楼层的信息
 @param CGFloat fFloorNum    楼层号
 @discussion
 @result 楼层面信息对象
 */
-(SWSpaceInfo*)getFloorInfo:(CGFloat)fFloorNum;


/*!
 @method
 @abstract      根据楼层号获取指定楼层的所有空间单元列表
 @param CGFloat fFloorNum    楼层号
 @discussion
 @result 所有空间单元列表，元素类型为SWSpaceInfo.
 */
-(NSArray*) getAllSpaces:(CGFloat)fFloorNum;

/*!
 @method
 @abstract      根据楼层号获取指定楼层的所有POI列表
 @param CGFloat fFloorNum    楼层号
 @discussion
 @result 获取的所有POI列表，元素类型为SWPOIInfo.
 */
-(NSArray*)getAllPOIs:(CGFloat)fFloorNum;

/*!
 @method
 @abstract      添加标注
 @param SWMark Mark    标注对象
 @discussion    标注图标的宽度必须相同，并且为2的幂次方大小.
 @result 无返回值
 */
-(void)addMark:(SWMark*)Mark;

/*!
 @method
 @abstract      根据ID删除标注对象
 @param NSInteger nID    标注对象ID
 @discussion
 @result 无返回值
 */
-(void)deletaMark:(NSInteger)nID;

/*!
 @method
 @abstract 删除指定类型的所有标注对象
 @param NSString strType    标注对象类型
 @discussion
 @result 无返回值
 */
-(void)deletaMarkByType:(NSString*)strType;


/*!
 @method
 @abstract 清除当前地图视图上的所有Overlayer对象
 @discussion
 @result 无返回值
 */
-(void)clearOverlayer;

/*!
 @method
 @abstract 清除当前地图视图上的路径对象
 @discussion
 @result 无返回值
 */
-(void)clearRoute;

/*!
 @method
 @abstract 高亮显示一组对象
 @param NSArray objIdList 对象ID数组,需要是同一类型的对象
 @param NSString objTypes  对象的类型，比如"space"、"poi"等，只能同时指定一个对象类型.
 @discussion
 @result 无返回值
 */
-(void)highLight:(NSArray*)objIdList objType:(NSString*)objTypes;

/*!
 @method
 @abstract 去除指定类型的对象高亮显示
 @param NSString objTypes  对象的类型，比如"space"、"poi"等，只能同时指定一个对象类型.
 @discussion
 @result 无返回值
 */
-(void)unHighLight:(NSString*)objTypes;

/*!
 @method
 @abstract 根据摊位ID返回空间单元ID列表，
 @param NSString strSpaceCode 摊位ID（铺位号）
 @discussion
 @result 返回空间单元ID列表
 */
-(NSMutableArray*)getSpaceIDListByCode:(NSString*) strSpaceCode;

/*!
 @method
 @abstract 通过ID获取空间单元的信息
 @param NSInteger spaceId 空间单元ID
 @discussion
 @result 返回空间单元的信息对象
 */
-(SWSpaceInfo*)getSpaceInfoByID:(NSInteger)spaceId;

/*!
 @method
 @abstract 通过id获取POI的信息
 @param NSInteger poiId POI的唯一ID
 @discussion
 @result 返回POI的信息
 */
-(SWPOIInfo*)getPOIInfoByID:(NSInteger)poiId;

/*!
 @method
 @abstract 更新一个或多个空间单元LOGO图标。
 @param NSMutableArray vecIDLogName  一个数组，数据成员为NSDictionary<NSString,NSString>对象，其中Key为空间单元ID,Value为Logo图标名称,Logo图标存放在PSF目录下的【logo】文件夹中.
 @discussion
 @result 无返回值
 */
-(void)updateLogo:(NSMutableArray*)vecIDLogName;

/*!
 @method
 @abstract 屏幕坐标转换为本地墨卡托坐标
 @param NSInteger xWin 屏幕坐标X
 @param NSInteger yWin 屏幕坐标Y
 @discussion
 @result CGPoint 返回本地墨卡托坐标
 */
-(CGPoint)ScreenToLocalMercator:(NSInteger) xWin y:(NSInteger)yWin;
/*!
 @method
 @abstract 本地墨卡托坐标转换为屏幕坐标
 @param double xn 本地墨卡托坐标X
 @param double yn 本地墨卡托坐标Y
 @discussion
 @result CGPoint 返回屏幕坐标
 */
-(CGPoint)LocalMercatorToScreen:(double) xn y:(double)yn;

/*!
 @method
 @abstract 经纬度坐标转换为墨卡托坐标
 @param xWin 经度
 @param yWin 纬度
 @discussion
 @result CGPoint 返回墨卡托坐标x,y
 */
-(CGPoint)LonLatToMercator:(double) longitude lat:(double)latitude;

/*!
 @method
 @abstract 经纬度坐标转换为本地墨卡托坐标
 @param xWin 经度
 @param yWin 纬度
 @discussion
 @result CGPoint 返回本地墨卡托坐标x,y
 */
-(CGPoint)LonLatToLocalMercator:(double)longitude lat:(double)latitude;

 /*!
 @method
 @abstract 墨卡托坐标转换为经纬度坐标
 @param double Xn 墨卡托坐标X
 @param double Yn 墨卡托坐标Y
 @discussion
 @result CGPoint 返回经纬度坐标
 */
-(CGPoint)MercatorToLonLat:(double) Xn y:(double) Yn;
/*!
 @method
 @abstract 本地墨卡托坐标转换为墨卡托坐标
 @param double Xn 本地局部坐标X
 @param double Yn 本地局部坐标Y
 @discussion
 @result CGPoint 返回墨卡托坐标
 */
-(CGPoint) LocalMercatorToMercator:(double) Xn y:(double) Yn;
/*!
 @method
 @abstract 墨卡托坐标转换为本地墨卡托坐标
 @param double Xn 墨卡托坐标X
 @param double Yn 墨卡托坐标Y
 @discussion
 @result CGPoint 返回本地墨卡托坐标
 */
-(CGPoint) MercatorToLocalMercator:(double) Xn y:(double) Yn;

/*!
 @method
 @abstract 本地墨卡托坐标转换为经纬度坐标
 @param double Xn 本地墨卡托坐标X
 @param double Yn 本地墨卡托坐标Y
 @discussion
 @result CGPoint 返回经纬度坐标
 */
-(CGPoint) LocalMercatorToLonLat:(double)Xn y:(double)Yn;

/*!
 @method
 @abstract 设置地图中心点
 @param double xn 本地墨卡托坐标X
 @param double yn 本地墨卡托坐标Y
 @discussion
 @result    无
 */
-(void) setMapCenter:(double) xn y:(double)yn;

/*!
 @method
 @abstract 获取地图中心点
 @discussion
 @result    地图中心点，以本地墨卡托坐标表示
 */
-(CGPoint)getMapCenter;

/*!
 @method
 @abstract 获取整个场景的范围
 @discussion
 @result    场景的范围
 */
-(SWExtent)getSceneBoundingBox;

/*!
 @method
 @abstract 获取当前像素比例
 @discussion
 @result    当前像素比例
 */
-(CGFloat)getPixelScale;

/*!
 @method
 @abstract 恢复指南针初始设置
 @discussion
 @result    无
 */
-(void)resetCompass;

/*!
 @method
 @abstract 设置指定的空间单元为屏幕中心
 @param NSInteger nSpaceId 空间单元ID
 @param BOOL bScale 是否缩放
 @discussion
 @result    无
 */
-(void) setSpaceCenter:(NSInteger)nSpaceId isScale:(BOOL)bScale;

/*!
 @method
 @abstract 获取指定空间单元的中心点位置坐标
 @param NSInteger nSpaceId 空间单元ID
 @discussion
 @result    空间单元位置坐标，以本地默卡托坐标表示
 */
-(CGPoint) getSpaceCenter:(NSInteger)nSpaceId;

/*!
 @method
 @abstract 获取初始的像素比例
 @discussion
 @result
 */
-(CGFloat) getAllPixelScale;

/*!
 @method
 @abstract 判断是否在楼层区域内
 @param double Xn 墨卡托X坐标
 @param double Yn 墨卡托Y坐标
 @discussion
 @result
 */
-(bool) isInFloor:(NSString*)FloorName  xn:(double)Xn yn:(double) Yn;

/*!
 @method
 @abstract 设置英文和中文是否显示
 @param BOOL isShowCH 是否显示中文
 @param BOOL isShowEN 是否显示英文
 @discussion
 @result    无
 */
-(void) configLanguageShow:(BOOL)isShowCH  bShowEN:(BOOL)isShowEN;

/*!
 @method
 @abstract 取得分类代码
 @discussion
 @result    分类代码，key【poiCodes】下为所有POI的类别码，key【spaceCodes】下为所有面的分类代码.
 */
-(NSDictionary*)getDataTypeName;

/*!
 @method
 @abstract 获取距离当前点最近的中分类空间单元
 @param NSString* strClass 空间单元类别
 @param NSString* strFloorName 楼层名称
 @param float fCurPosX 当前点位置
 @param float fCurPosY 当前点位置
 @discussion
 @result    空间单元信息
 */
-(SWSpaceInfo*)getNearestSpace:(NSString*)strClass floorname:(NSString*)strFloorName X:(float)fCurPosX Y:(float)fCurPosY;

/*!
 @method
 @abstract 计算经过若干导航点的路径
 @param fStartFloor 起始点楼层索引
 @param startPos 起始点坐标
 @param endFloor 终点楼层索引
 @param endPos   终点坐标
 @param midPoints 途经点坐标数组，元素类型为SWPoint
 @param bShow       是否显示
 @discussion
 @result
 返回1，表示有路径.
 返回0，无路径
 返回-1，搜索失败
 */
-(NSInteger)computeNaviPathEx:(CGFloat)fStartFloor startPos:(CGPoint)startPos endFloor:(CGFloat)fEndFloor endPos:(CGPoint)endPos midPoints:(NSArray*)midPoints bShow:(BOOL)bShow;

/*!
 @method
 @abstract 根据距离缩放地图
 @param CGFloat dist 缩放距离
 @discussion
 @result    无
 */
-(void)zoom:(CGFloat)dist;


/*!
 @method
 @abstract 以当前地图范围作为参考进行地图缩放.
 @param CGFloat 缩放系数. 指地图缩放后单位长度与缩放前单位长度的比例关系.例如：fator=2, 则缩小一倍, fator=0.5, 则放大一倍。
 @discussion
 @result    无
 */
-(void)zoomByRatio:(CGFloat)fator;

/*!
 @method
 @abstract 平移地图
 @param CGFloat xOffSet x偏移值,单位: Meter.
 @param CGFloat yOffSet y偏移值,单位: Meter.
 @discussion
 @result    无
 */
-(void)pan:(CGFloat)xOffSet yOffSet:(CGFloat)yOffSet;

/*!
 @method
 @abstract 修改指定空间单元的属性
 @param NSInteger spaceid 空间单元ID
 @param NSString strName 空间单元名称
 @param NSString strCHName 中文名称
 @param NSString strENName 英文名称
 @param NSString strSpaceType 空间单元类型代码
 @discussion
 @result    无
 */
-(void) updateSpaceAttr:(NSInteger)spaceid name:(NSString*)strName chName:(NSString*)strCHName enName:(NSString*)strENName type:(NSString*)strSpaceType;


/*!
 @method
 @abstract 点选
 @discussion
 @param x    屏幕坐标x
 @param y    屏幕坐标y
 @param floorIndex    楼层号
 @param objs    可被拾取对象.  使用英文逗号分隔，目标被拾取的顺序与排列顺序一致,可被拾取的对象包括: floor, poi, space, overlay_mark, overlay_polyline 等, 不区分大小写.
 @result 对象信息
 */
-(SWPickInfo*) pickModel:(NSInteger)x Y:(NSInteger)y floorIndex:(CGFloat)floorNum objs:(NSString*)objs;

/*!
 @method
 @abstract 关键字/分类搜索功能
 @discussion
 @param NSString    keyWord     关键字，可以为空字符串
 @param NSString    keyFields   过滤条件1：keyword所匹配的字段。包括 namech(中文名), nameen(英文名),name(名称), shopcde(铺位编号).  例如："name,nameen"表示仅搜索名称与中文名
 @param NSString    typeCode    过滤条件2：分类代码，通过getDataTypeName接口获取，可以为空字符串
 @param CGFloat     floorNum    过滤条件3：楼层号，搜索全部楼层值设置为-10000.0
 @param CGFloat     xPos        过滤条件4：搜索区域中心点坐标（全局墨卡托坐标）
 @param CGFloat     yPos        过滤条件5：搜索区域中心点坐标（全局墨卡托坐标）
 @param double      dDist       过滤条件6：搜索区域半径与中心点距离,单位: Meter。如果dist小于0.0值,则表示无搜索范围限制.
 @param NSInteger   nPageSize   页大小，用于分页处理
 @param NSInteger   nPageIndex  获取第几页的数据,从0开始。
 @result 成功返回搜索结果数据，失败返回nil。
 */
-(NSDictionary*)search:(NSString*)keyWord keyFields:(NSString*)keyFields typeCode:(NSString*)typeCode floorNum:(CGFloat)floorNum xPos:(double)xPos yPos:(double)yPos dist:(double)dDist pageSize:(NSInteger)nPageSize pageIndex:(NSInteger)nPageIndex;

/*!
 @method
 @abstract 获取当前地图比例尺
 @discussion
 @result 返回当前地图比例尺
 */
-(CGFloat)getScale;

/*!
 @method
 @abstract 设置当前地图比例尺
 @discussion
 @result 无返回值
 */
-(void)setScale:(CGFloat)scale;

#pragma mark 路径规划
/*!
 @method
 @abstract 路径搜索
 @discussion
 @param CGFloat fFloorFrom       起点楼层号
 @param double  dLongFrom        起点经度坐标
 @param double  dLongFrom        起点纬度坐标
 @param NSMutableArray  sLinkList        起始点的相关Link列表,【getSpaceInfoByID】接口获取的空间单元信息SWSpaceInfo.linklist参数值.
 @param CGFloat fFloorTo       终点楼层
 @param double  dLongFrom        终点经度坐标
 @param double  dLongFrom        终点纬度坐标
 @param NSMutableArray  eLinkList        终点的相关Link列表,【getSpaceInfoByID】接口获取的空间单元信息里SWSpaceInfo.linklist参数值
 @param NSInteger   Type             路径类型       暂未使用
 @result 
  返回list对象，表示有路径.
  返回nil，无路径
 */
-(NSMutableArray*)computeRoute:(CGFloat)fFloorFrom LongitudeFrom:(double)dLongFrom LatitudeFrom:(double)dLatiFrom slinkList:(NSMutableArray*)slinks FloorTo:(CGFloat)fFloorTo LongitudeTo:(double)dLongTo LatitudeTo:(double)dLatiTo elinkList:(NSMutableArray*)elinks Type:(NSInteger)nType;

/*!
 @method
 @abstract 计算球面两点两点间距离.
 @discussion
 @param double lon1  第一点经度
 @param double lait1  第一点纬度
 @param double lon2  第二点经度 
 @param double lati2  第二点纬度
 @result 球面两点间的距离
 */
-(double)getGeoDistance:(double)lon1 lati1:(double)lati1 lon2:(double)lon2 lati2:(double)lati2;

/*!
 @method
 @abstract 导入样式文件
 @discussion
 @param NSString styleName  样式文件绝对路径，如果为空则显示默认样式.(目录此接口暂不使用，如果需要更新样式文件，那么重新加载地图即可)
 @result 无返回值
 */
-(NSInteger)importStyleFromJson:(NSString*)styleName;

@end

/*!
 @protocol
 @abstract MapView的Delegate，mapView通过此类来通知用户对应的事件
 @discussion
 */
@protocol SWMapViewDelegate <NSObject>
@optional
#pragma mark 地图点击响应事件
/*!
 @method
 @abstract 地图单击响应事件
 @discussion
 @param MapView       单击的地图对象
 @param Screen        单击的屏幕坐标
 @param Mappoint      单击的地图坐标
 @param Graphics      单击位置的图形要素对象
 @result 无返回值
 */
-(void)SWMapView:(SWMapView *)MapView didClickAtPoint:(CGPoint)Screen MapPoint:(CGPoint *)Mappoint Graphics:(NSDictionary *)Graphics;

/*!
 @method
 @abstract 地图双击响应事件
 @discussion
 @param MapView       双击的地图对象
 @param Screen        双击的屏幕坐标
 @param Mappoint      双击的地图坐标
 @param Graphics      双击位置的图形要素对象
 @result 无返回值
 */
-(void)SWMapView:(SWMapView *)MapView didDoubleClickAtPoint:(CGPoint)Screen MapPoint:(CGPoint *)Mappoint Graphics:(NSDictionary *)Graphics;

/*!
 @method
 @abstract 地图移动响应代理事件
 @discussion
 @param recognizer       手势对象
 @result 无返回值
 */
-(void)SWMapViewPan:(UIPanGestureRecognizer *)recognizer;

/*!
 @method
 @abstract 地图缩放手势响应事件
 @discussion
 @param MapView       移动的地图对象
 @param recognizer    手势对象
 @result 无返回值
 */
-(void)SWMapView:(SWMapView *)MapView handlePinch:(UIPinchGestureRecognizer*)recognizer;

/*!
 @method
 @abstract 地图引擎初始化完成，已经开始正常渲染。
 @discussion
 @param MapView       地图对象
 @result 无返回值
 */
-(void)SWMapViewInitDidFinish:(SWMapView*)MapView;

@end
