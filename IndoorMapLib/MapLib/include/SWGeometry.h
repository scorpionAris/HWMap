//
//  SWGeometry.h
//  nimap_ios_lib
//
//  Created by navinfoaec on 14-1-15.
//  Copyright (c) 2014年 navinfoaec. All rights reserved.
//
/*!
 @header SWGeometry.h
 @abstract 地图上图形要素相关类定义文件
 @author niurg
 @version 1.00 2014/01/15 Creation
 */


#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIColor.h>

/*!
 @enum
 @abstract 地图上图形要素枚举类型定义
 @constant Geometry_Point       点要素
 @constant Geometry_Mark        注记要素
 @constant Geometry_LineString  线字符串
 @constant Geometry_Polygon     多边形
 @constant Geometry_Building    建筑物
 @constant Geometry_POI         POI数据
 */
typedef enum{
    GEometry_nil = -1,
    Geometry_Point = 0,
    Geometry_Mark = 1,
    Geometry_LineString = 2,
    Geometry_Polygon = 3,
    Geometry_Building = 4,
    Geometry_POI = 5

}enumGeometry;
//=============================================================
/*!
 @struct
 @abstract 显示范围
 */
typedef struct {
    double MinX;
    double MaxX;
    double MinY;
    double MaxY;
}SWExtent;
//=============================================================
/*!
 @class
 @abstract 图形要素基类定义
 */
@interface SWGeometry : NSObject
{
    @protected
    NSInteger m_Projection;
}

/*!
 @property
 @abstract 图形要素类型属性
 */
@property(nonatomic, assign)enumGeometry nType;
/*!
 @property
 @abstract 图形要素FID属性
 */
@property(nonatomic, assign)NSUInteger nFID;
/*!
 @property
 @abstract 图形要素风格属性
 */
@property(nonatomic, strong)NSString* StyleValue;
/*!
 @property
 @abstract 图形要素投影属性
 */
@property(nonatomic, assign)NSInteger nProjection;
/*!
 @property
 @abstract 图形要素是否存储属性
 */
@property(nonatomic, assign)BOOL bIsSave;

/*!
 @property
 @abstract 图形要素是否可见
 */
@property(nonatomic, assign)BOOL bIsVisible;

/*!
 @property
 @abstract 对象显示范围
 */
@property(nonatomic, assign)SWExtent stExtent;

/*!
 @method
 @abstract 初始化
 @discussion
 @result 成功返回对象，失败返回nil。
 */
-(id)init;

@end
//=============================================================
/*!
 @class
 @abstract 点状图形要素类定义
 */
@interface SWPoint : SWGeometry
{
    
}

-(id)initWith:(CGFloat)x yPos:(CGFloat)y;

-(id)initWith:(CGFloat)x yPos:(CGFloat)y zPos:(CGFloat)z floorNum:(CGFloat)fFloorNum;

//计算点p到线段p1和p2之间的垂足, distance为当前点到垂足的距离 posType返回垂足的类型，0为垂足在线段中间，1为线段的起点，2为线段的终点
+(SWPoint*)computePointOnLine:(SWPoint*)point startPos:(SWPoint*)startPos endPos:(SWPoint*)endPos distance:(double*)distance posType:(int*)posType;

/*!
 @property
 @abstract x坐标
 */
@property(nonatomic, assign)CGFloat xPos;

/*!
 @property
 @abstract y坐标
 */
@property(nonatomic, assign)CGFloat yPos;

/*!
 @property
 @abstract z坐标
 */
@property(nonatomic, assign)CGFloat zPos;

/*!
 @property
 @abstract 楼层号
 */
@property(nonatomic, assign)CGFloat fFloorNum;

@end
//=============================================================
/*!
 @class
 @abstract 注记图形要素类定义
 */
@interface SWLabel : SWPoint
{
    
}

/*!
 @property
 @abstract 文字信息
 */
@property(nonatomic, strong)NSString *Text;

/*!
 @property
 @abstract 字体大小
 */
@property(nonatomic, assign)NSInteger nFontSize;

/*!
 @property
 @abstract 字体颜色
 */
@property(nonatomic, strong)UIColor *FontColor;

/*!
 @property
 @abstract 文本长度
 */
@property(nonatomic, assign)NSInteger nTextLen;

/*!
 @property
 @abstract 是否更改
 */
@property(nonatomic, assign)BOOL bTextChange;

/*!
 @property
 @abstract 新行字符
 */
@property(nonatomic, assign)unsigned char cNewLineChar;

/*!
 @property
 @abstract 新行字符索引
 */
@property(nonatomic, assign)NSInteger NewLineCharIndex;

@end
//=============================================================

/*!
 @property
 @abstract 拾取的空间单元类型
 @param     Mark_UnKnown            未知类型
 @param     Mark_Comm               普通标注类型
 @param     Mark_Comm_Sel           普通标注选中类型
 @param     Mark_Start_Point        起点标注
 @param     Mark_End_Point          终点标注
 @param     Mark_Promotion          促销标注
 */
typedef enum:NSUInteger
{
    Mark_UnKnown = 1,
    Mark_Comm,          // 查询结果-非选中状态
    Mark_Comm_Sel,      // 选中标注
    Mark_Start_Point,   // 起点标注
    Mark_End_Point,     // 终点标注
    Mark_Location,      // 定位标注
    Mark_Promotion      // 促销标注
}emMarkType;


/*!
 @class
 @abstract 注记图形要素类定义
 @discussion 添加一个SWMark对象的示例代码如下：
 SWMark *mark = [[SWMark alloc] init];
 static NSInteger nMarkId = 0;
 [mark setNFID:nMarkId];
 nMarkId++;
 [mark setFloorName:floorName];
 [mark setXPos:x];
 [mark setYPos:y];
 [mark setNImageWidth:25];
 [mark setNImageHeight:25];
 [mark setImageName:@"icon_mark.png"];
 [mapView addMark:mark];
 */
@interface SWMark : SWLabel
{
    
}

/*!
 @property
 @abstract 标注对象所在楼层名称
 */
@property(nonatomic, strong)NSString* strFloorName;

/*!
 @property
 @abstract 标注图标宽度，必须与高度一致且为2的幂次方.
 */
@property(nonatomic, assign)NSInteger nImageWidth;

/*!
 @property
 @abstract 标注图标高度，必须与宽度一致且为2的幂次方.
 */
@property(nonatomic, assign)NSInteger nImageHeight;

/*!
 @property
 @abstract 自定义标注图标的名称，标注图标文件必须放至在资源包【mht_bl/mapdata/cache/】目录下
 */
@property(nonatomic, strong)NSString* strImageName;

/*!
 @property
 @abstract 相关的附属信息,为JSON字符串，定义如下：
 (1.) mark_type  标注的类型，参照枚举类型emMarkType.
 (2.) rel_model_id    标注关联的POI或SPACE的ID值，如果没有关系任何几何元素，则为MARK的ID值，长整型值.
 (3.) rel_model_name    标注关联的POI或SPACE的名称
 (4.) rel_promotion_id  标注关联的促销ID

 样例一：查询商铺结果，非选中状态，商铺KFC的ID值为2001009，则JSON字符串为：
 @"{"mark_type": 1, "rel_model_id" : 2001009, "rel_model_name" : "KFC"}"
 */
@property(nonatomic, strong)NSString* strRelativeInfo;

/*!
 @property
 @abstract Mark类型
 */
@property(nonatomic, strong)NSString* strMarkType;

@end
//=============================================================
/*!
 @class
 @abstract 字符串图形要素类定义
 */
@interface SWLineString : SWGeometry
{
}

/*!
 @property
 @abstract 坐标点数组
 */
@property (nonatomic, readonly) NSMutableArray *Points;

/*!
 @property
 @abstract 颜色
 */
@property(nonatomic, strong)UIColor *Color;

/*!
 @property
 @abstract 颜色透明度
 */
@property(nonatomic, assign)CGFloat fColorOpacity;

/*!
 @property
 @abstract 行颜色
 */
@property(nonatomic, strong)UIColor *LineColor;

/*!
 @property
 @abstract 行颜色透明度
 */
@property(nonatomic, assign)CGFloat fLineColorOpacity;

/*!
 @property
 @abstract 行宽度
 */
@property(nonatomic, assign)NSInteger nLineWidth;

/*!
 @method
 @abstract 初始化
 @discussion
 @result 成功返回对象，失败返回nil。
 */
-(id)init;

/*!
 @method
 @abstract 添加一个点
 @discussion
 @param Point   需要添加的点
 @result 无返回值
 */
-(void)AddPoint:(SWPoint*)Point;

/*!
 @method
 @abstract 修改一个点
 @discussion
 @param Point   需要修改的点
 @param nIndex  点的索引
 @result 无返回值
 */
-(void)SetPoint:(SWPoint*)Point Index:(NSInteger)nIndex;

/*!
 @method
 @abstract 删除一个点
 @discussion
 @param nIndex  点的索引
 @result 无返回值
 */
-(void)RemovePoint:(NSInteger)nIndex;


@end


