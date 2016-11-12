//
//  NavShopBottomPopView.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/15.
//  Copyright © 2015年 nv. All rights reserved.
//

#import "NavShopBottomPopView.h"
#import "NavConstants.h"

#define bottom_row_height       38.

#define will_go_btn_size        80.

@interface NavShopBottomPopView ()
{
    UIView *_containterView;
    BOOL bHasYouhuiView;
    CGRect _meFrame;
}
@end

@implementation NavShopBottomPopView

+ (instancetype)instance:(UIView*)containterView
{
    static NavShopBottomPopView *_sharedView = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedView = [[NavShopBottomPopView alloc] initWithContainterView:containterView];
    });
    
    return _sharedView;
}

- (instancetype)initWithContainterView:(UIView*)containterView
{
    self = [super init];
    if (self) {
        // 底部视图，初始设置为隐藏状态(屏幕下方)
#ifdef _DEMO_
        self.frame = kcr(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOTTOM_VIEW_HEIGHT);
#else
        self.frame = kcr(0, SCREEN_HEIGHT - NAV_BAR_HEIGHT, SCREEN_WIDTH, BOTTOM_VIEW_HEIGHT)];
#endif
        _bIsShowing = NO;
        _containterView = containterView;
        [self initControl];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)setZhongTaiShopId:(NSString *)zhongTaiShopId
{
    if (zhongTaiShopId.length <= 0) {
        return;
    }
    _zhongTaiShopId = zhongTaiShopId;
    
    return;
}

-(void)setCurrPickInfo:(SWPickInfo *)currPickInfo
{
    if (!currPickInfo) {
        return;
    }
    _currPickInfo = currPickInfo;
    // 根据业务数据调整视图
    {
        // 有优惠/促销
        CGRect frame = self.frame;
        if (frame.size.height < (_meFrame.size.height + bottom_row_height - 1))
        {
            //
            frame.size.height = _meFrame.size.height + bottom_row_height;
            self.frame = frame;
        }

        // 1.添加水平分隔线
        CGFloat fXPos = 20.f;
//        UILabel *shopNumberLabel = (UILabel*)[self viewWithTag:103];
        UILabel *shopNumberLabel = (UILabel*)[self viewWithTag:103];
        CGFloat fYpos = shopNumberLabel.frame.origin.y + shopNumberLabel.frame.size.height + 8.;
        CGFloat fWidth = SW - fXPos * 2;
        CGFloat fHeight = 1.;
        UIView *lineH = (UIView*)[self viewWithTag:1041];
        if (!lineH) {
            lineH = [[UIView alloc] initWithFrame:kcr(fXPos, fYpos, fWidth, fHeight)];
            [lineH setTag:1041];
        }
        [lineH setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        [self addSubview:lineH];
        
        {
            // 1.添加促销活动
            UIView *youhuiView = (UIView*)[self viewWithTag:10400 + 1];
            if (youhuiView) {
                [youhuiView removeFromSuperview];
            }
            // 计算X起始
            fWidth = 80.f;
            fXPos = (SW / 2. - fWidth) / 2.f;
            
            // 2.添加分隔线
            UIView *lineV = [self viewWithTag:10400 + 3];
            if (!lineV)
            {
                //
                fXPos = SW / 2;
                CGFloat fHeight = 22.f;
                fWidth = 1.;
                fYpos = (self.frame.size.height - bottom_row_height) + (bottom_row_height - fHeight) / 2;
                lineV = [[UIView alloc] initWithFrame:kcr(fXPos, fYpos, fWidth, fHeight)];
                [self addSubview:lineV];
                [lineV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
                [lineV setTag:10403];
            }
            
            // 3.添加优惠
            youhuiView = (UIView*)[self viewWithTag:10400 + 2];
            if (youhuiView) {
                [youhuiView removeFromSuperview];
            }
            // 计算X起始
            fWidth = 80.f;
            fXPos = SW / 2. + (SW / 2 - fWidth) / 2;
        }
        
    }

    // 添加【到这去】按钮
    UIButton *goToHearBtn = (UIButton*)[_containterView viewWithTag:10500];
    if (goToHearBtn) {
        [goToHearBtn removeFromSuperview];
    }
    goToHearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goToHearBtn setTag:10500];
    CGFloat fWidth = will_go_btn_size;
    CGFloat fHeight = fWidth;
    CGFloat fYpos = self.frame.origin.y - fHeight / 2.;
    
    CGFloat fXPos = SW - fWidth - 10.;
    [goToHearBtn setFrame:kcr(fXPos, fYpos, fWidth, fHeight)];
    [goToHearBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navdaozhequ"] forState:UIControlStateNormal];
    [goToHearBtn addTarget:self action:@selector(goToHearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_containterView addSubview:goToHearBtn];
    [_containterView bringSubviewToFront:goToHearBtn];
    
    //
    [self updateBussinessData];
    return;
}


-(void)youHuiClick:(UITapGestureRecognizer*)ges
{
    UIView *youhuiView = ges.view;
    NSInteger nTag = youhuiView.tag;
    if (nTag == 10401) {
        // 促销活动
    }
    else if (nTag == 10402)
    {
        // 优惠券
        
    }
    
    // 这里显示线上商铺详情
    if ([_delegate respondsToSelector:@selector(showStallCodeDetailDeg:)])
    {
        NSString *param = [NSString stringWithFormat:@"type=%@&id=%@",SEARCH_PARAM_VALUE, _zhongTaiShopId];
        [_delegate showStallCodeDetailDeg:param];
    }
    
    
    return;
}
// 设置业务数据
-(void)updateBussinessData
{
    if (!_currPickInfo) {
        return;
    }
    // 1.商铺名称设置
    UILabel *shopNameLabel = (UILabel*)[self viewWithTag:102];
    if (shopNameLabel) {
        [shopNameLabel setText:_currPickInfo.strSpaceName];
    }
    else{
        [shopNameLabel setText:@"选择位置"];
    }
    
    // 2.楼层号、铺位号设置
    if (_mapView) {
        NSMutableString *totalStr = [NSMutableString stringWithCapacity:0];
        NSInteger nCurrFloorNum = [_mapView getCurFloorNum];
        NSString *floorName = [_mapView getFloorName:nCurrFloorNum];
        if (floorName.length > 0) {
            [totalStr appendString:floorName];
        }
        //
        NSString *strSpaceType = _currPickInfo.strSpaceType;
        if([strSpaceType hasPrefix:@"10"]){
            // 以10开头为POI，则不显示铺位号
        }
        else{
            SWSpaceInfo *srTmp = [_mapView getSpaceInfoByID:_currPickInfo.nSpaceID];
            
            if([NavUtils isNotBlank:srTmp.strSpaceCode])
            {
                if (srTmp.strSpaceCode.length > 0) {
                    [totalStr appendString:@" 铺位号:"];
                    [totalStr appendString:srTmp.strSpaceCode];
                }
            }
        }
        
        
        UILabel *shopNumberLabel = (UILabel*)[self viewWithTag:103];
        if (shopNumberLabel) {
            //
            [shopNumberLabel setText:totalStr];
        }
    }
    

    return;
}

-(void)youHuiBtnClick:(UIButton*)sender
{
    return;
}

-(void)initControl
{
    // 1.第一行添加左右定位图标
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navmap.bundle/images2/navdianpuqian.png"]];
    [iconIV setTag:101];
    
    CGFloat fXPos = 10.f;
    CGFloat fYpos = 10.f;
    CGFloat fWidth = 20.f;
    CGFloat fHeight = 20.f;
    CGRect frame = kcr(fXPos, fYpos, fWidth, fHeight);
    [iconIV setFrame:frame];
    [self addSubview:iconIV];
    
    // 2.添加第一行商铺名称
    fXPos = fXPos + fWidth + 5;
    fWidth = SW - fXPos - 80.f;
    fYpos = iconIV.center.y - fHeight / 2.f;
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:kcr(fXPos, fYpos, fWidth, fHeight)];
    [shopNameLabel setTag:102];
    shopNameLabel.userInteractionEnabled = YES;
    [shopNameLabel setTextAlignment:NSTextAlignmentLeft];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopNameClick)];
    [shopNameLabel addGestureRecognizer:tap];
    [self addGestureRecognizer:tap];
    [self addSubview:shopNameLabel];
    
    // 3.添加第二行楼层号及商铺铺位号
    fYpos = fYpos + fHeight + 5;
    UILabel *shopNumberLabel = [[UILabel alloc] initWithFrame:kcr(fXPos, fYpos, fWidth, fHeight)];
    [shopNumberLabel setTag:103];
    [shopNumberLabel setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [shopNumberLabel setFont:[UIFont systemFontOfSize:12]];
    [shopNumberLabel setText:@"1F  2065"];
    [self addSubview:shopNumberLabel];
    
    _meFrame = self.frame;
    _meFrame.size.height = fYpos + fHeight + 10;
    self.frame = _meFrame;
    
    // 4.添加优惠/促销信息
    bHasYouhuiView = NO;
    [_containterView addSubview:self];
    
    return;
}

-(void)shopNameClick
{
    // 这里显示线上商铺详情
    if ([_delegate respondsToSelector:@selector(showStallCodeDetailDeg:)])
    {
        NSString *param = [NSString stringWithFormat:@"type=%@&id=%@",SEARCH_PARAM_VALUE, _zhongTaiShopId];
        [_delegate showStallCodeDetailDeg:param];
    }
    return;
}

-(void)showShopDetail
{
    // 这里显示线上商铺详情
    if ([_delegate respondsToSelector:@selector(showStallCodeDetailDeg:)])
    {
        NSString *param = [NSString stringWithFormat:@"type=%@&id=%@",SEARCH_PARAM_VALUE, _zhongTaiShopId];
        [_delegate showStallCodeDetailDeg:param];
    }
    
    return;
}
-(void)goToHearBtnClick:(id)sender
{
    // 1.关闭自身窗口
    [self showMe:NO];
    
    // 2.通知上层，显示路径规划窗口
    if ([_delegate respondsToSelector:@selector(goToHearBtnClickDeg:)]) {
        //
        [_delegate goToHearBtnClickDeg:sender];
    }
    
    return;
}

-(void)showMe:(BOOL)bShow
{
    if (_bIsShowing == bShow) {
        return;
    }
    
    _bIsShowing = bShow;
    UIButton *goToHearBtn = (UIButton*)[_containterView viewWithTag:10500];
    CGRect goBtnFrame = goToHearBtn.frame;
    if(bShow)
    {
        // 显示
        [_containterView bringSubviewToFront:self];
        [_containterView bringSubviewToFront:goToHearBtn];
        
        // 动画弹出
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect frame = self.frame;
        frame.origin.y -= (self.frame.size.height);
        [self setFrame:frame];
        
        goBtnFrame.origin.y -= (self.frame.size.height);
        [goToHearBtn setFrame:goBtnFrame];
        [goToHearBtn setHidden:NO];
        [UIView commitAnimations];
        
    }
    else{
        // 动画隐藏
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect frame = self.frame;
        frame.origin.y += (self.frame.size.height);
        [self setFrame:frame];
        
        goBtnFrame.origin.y += (self.frame.size.height);
        [goToHearBtn setFrame:goBtnFrame];
        [goToHearBtn setHidden:YES];
        [UIView commitAnimations];
    }
    return;
}

@end
