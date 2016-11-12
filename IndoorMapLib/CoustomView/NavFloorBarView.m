//
//  NavFloorBarView.m
//  IndoorMapLib
//
//  Created by navinfoaec on 15/11/13.
//  Copyright © 2015年 nv. All rights reserved.
//

#import "NavFloorBarView.h"
#import "NavFloorBtn.h"
#import "NavConstants.h"

// 上下箭头按钮的高度
#define arrow_btn_height    15.
#define btn_In_Set          3.
#define up_btn_tag          100
#define down_btn_tag        101


#define floor_btn_width     40.

#define floor_btn_height    40.

@interface NavFloorBarView ()<UIScrollViewDelegate>
{
//    NSMutableArray *_floorBtns;
    NSMutableDictionary *_floorNameToBtnIndexDic;
//    CGRect _floorSelectViewFrame;
    UIScrollView *_floorBtnScrollView;
    
    // 当前选中的楼层按钮
    UIButton *_lastSelFloorBtn;
}
@end

@implementation NavFloorBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

// 移动指定楼层按钮到可视区域
-(void)moveBtnToVisible:(UIButton*)btn
{
    [_floorBtnScrollView scrollRectToVisible:btn.frame animated:YES];
    return;
}

-(void)initFloorView
{
    // 1.根据楼层个数设定控件的高度
    CGFloat fHeight = 0.f;
    NSInteger floorCnt = [_mapView getFloorCount];
    if (floorCnt > 5) {
        // 多于5个按钮的场合
        fHeight = arrow_btn_height * 2 + floor_btn_height * 5;
    }
    else{
        fHeight = arrow_btn_height * 2 + floor_btn_height * floorCnt;
    }
    
    CGRect frame = self.frame;
    frame.size.width = floor_btn_width;
    frame.size.height = fHeight;
    self.frame = frame;
    
    // 2. 添加上箭头按钮
    CGFloat xPos = 0.;
    CGFloat yPos = 0.;
    if (floorCnt > 5)
    {
        // 如果多于5个楼层时才会显示箭头
        UIButton *upArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = kcr(xPos, yPos, floor_btn_width, arrow_btn_height);
        [upArrowBtn setFrame:frame];
        [upArrowBtn setEnabled:NO];
        [upArrowBtn setTag:up_btn_tag];
        [upArrowBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navshang"] forState:UIControlStateNormal];
        [upArrowBtn setImageEdgeInsets:UIEdgeInsetsMake(btn_In_Set, btn_In_Set+5, btn_In_Set, btn_In_Set+5)];
        [self addSubview:upArrowBtn];
    }
    
    // 3.添加楼层滚动视图
    fHeight = fHeight - arrow_btn_height * 2;
    yPos = yPos + arrow_btn_height;
    CGRect scrFrame = kcr(xPos, yPos, floor_btn_width, fHeight);
    _floorBtnScrollView = [[UIScrollView alloc] initWithFrame:scrFrame];
    _floorBtnScrollView.showsVerticalScrollIndicator = NO;
//    _floorBtnScrollView.pagingEnabled = YES;
    _floorBtnScrollView.delegate = self;
    [self addSubview:_floorBtnScrollView];
    
    _floorBtns=[[NSMutableArray alloc]init];
    _floorNameToBtnIndexDic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    NSInteger nCurrFloorNum = [_mapView getCurFloorNum];
    for(int i=0;i<floorCnt;i++)
    {
        NavFloorBtn *btn = [NavFloorBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, i * floor_btn_height, floor_btn_width, floor_btn_height);
        
        NSString *floorName = [_mapView getFloorNameByIndex:i];
        if (nCurrFloorNum == i)
        {
            // 当前楼层
            [btn setBackgroundColor:UIColorFromRGB(0x4e95fc)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _lastSelFloorBtn = btn;
        }
        else{
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        
        [btn setTitle:floorName forState:UIControlStateNormal];
        [btn setTag:i];
        [btn setFloorName:floorName];
        
        CGFloat floorNum = [_mapView getFloorNumByIndex:i];
        [btn setFloorNum:floorNum];
        
        NSNumber *floorIndex = [NSNumber numberWithInteger:i];
        [_floorNameToBtnIndexDic setObject:floorIndex forKey:floorName];
        
        [btn addTarget:self action:@selector(floorSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_floorBtns addObject:btn];
        
        [_floorBtnScrollView addSubview:btn];
    }
    // 设置contentsize
    CGSize contentSize = CGSizeMake(floor_btn_width, floor_btn_height * floorCnt);
    [_floorBtnScrollView setContentSize:contentSize];
    // 初始显示选中楼层
    [_floorBtnScrollView scrollRectToVisible:_lastSelFloorBtn.frame animated:NO];
    
    // 4. 添加下箭头按钮
    if (floorCnt > 5)
    {
        // 如果多于5个楼层时才会显示箭头
        UIButton *downArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [downArrowBtn setEnabled:NO];
        [downArrowBtn setTag:down_btn_tag];
        [downArrowBtn setImageEdgeInsets:UIEdgeInsetsMake(btn_In_Set, btn_In_Set+2, btn_In_Set, btn_In_Set+2)];
        [downArrowBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navxia"] forState:UIControlStateNormal];
        yPos = yPos + fHeight;
        CGRect frame = kcr(xPos, yPos, floor_btn_width, arrow_btn_height);
        [downArrowBtn setFrame:frame];
        [self addSubview:downArrowBtn];
    }
    
    {
        // 初始为隐藏状态
//        [self setHidden:YES];
    }
    
    self.layer.cornerRadius=3.0f;
    // 加边框
    self.layer.borderColor = [[UIColor colorWithRed:1. green:1. blue:1. alpha:0.7] CGColor];
    self.layer.borderWidth = 1.f;

    return;
}

-(void)floorSwitchBtnClick:(UIButton*)btn
{
    if (_lastSelFloorBtn != btn)
    {
        [_lastSelFloorBtn setBackgroundColor:[UIColor whiteColor]];
        [_lastSelFloorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lastSelFloorBtn = btn;
        // 设置背景颜色高亮
//        [btn setBackgroundColor:[UIColor colorWithRed:0. green:0x68/255. blue:0xb7/255. alpha:1]];
        [btn setBackgroundColor:UIColorFromRGB(0x4e95fc)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ([_navDelegate respondsToSelector:@selector(floorSwitchBtnClickDeg:)]) {
        [_navDelegate floorSwitchBtnClickDeg:btn];
    }
    return;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffsetPoint = scrollView.contentOffset;
    NSLog(@"offset x:%lf, y:%lf", contentOffsetPoint.x, contentOffsetPoint.y);
    
    UIButton *upArrowBtn = (UIButton*)[self viewWithTag:up_btn_tag];
    UIButton *downArrowBtn = (UIButton*)[self viewWithTag:down_btn_tag];
    
    if (contentOffsetPoint.y < 5) {
        NSLog(@"to top");
        [upArrowBtn setHidden:YES];
    }
    else{
        [upArrowBtn setHidden:NO];
    }
    
    CGRect frame = scrollView.frame;
    if (contentOffsetPoint.y > scrollView.contentSize.height - frame.size.height - 5)
    {
        NSLog(@"scroll to the end");
        [downArrowBtn setHidden:YES];
    }
    else{
        [downArrowBtn setHidden:NO];
    }
    

    
    return;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    return;
}
//-(void)upBtnClick:(UIButton*)sender
//{
//    return;
//}
//
//-(void)downBtnClick:(UIButton*)sender
//{
//    return;
//}


@end
