//
//  CateView.m
//  IndoorMapDemo
//
//  Created by Kevin Chou on 15/5/21.
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "CateView.h"
#import "UIView+Frame.h"
//#import "kCUIUtil.h"
#import "NavConstants.h"


#define kMarginLeftRight 70
#define kColNum 3

@protocol CateCellDelegate <NSObject>

- (void)didTagSeleted:(NSInteger)index cell:(UITableViewCell *)cell;

@end

@interface CateCell : UITableViewCell


@property(nonatomic,strong) NSArray *buttons;

@property(nonatomic,weak) id<CateCellDelegate> delegate;

- (void)setName:(NSString *)name tag:(NSInteger)tag loc:(NSInteger)loc;

@end

@interface CateView()<UITableViewDataSource,UITableViewDelegate,CateCellDelegate>
{
    CGRect _tableViewOrgFrame;
}
@property(nonatomic,strong) NSArray *data;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,copy) CateBlock block;

//@property(nonatomic,strong) UIImageView *arrowView;

//@property(nonatomic,strong) UIView *container;

@end

@implementation CateView

-(instancetype)initWithFrame:(CGRect)frame
{
    CGRect frame0 = kcr(0, 0, SW, SH);
    
    self = [super initWithFrame:frame0];
    if (self) {
        self.width = SW;
        self.height = SH;
        _tableViewOrgFrame = frame;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        
//        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_tableView];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        
        [self addGestureRecognizer:tap];

    }
    
    return self;
}

// 是否显示键盘
-(void)ShowkeyBoardWithHeight:(CGFloat)keyBoardHeight show:(BOOL)bShow
{
    CGRect frame = self.frame;
    CGRect tableViewFrame = _tableView.frame;
    if (bShow) {
        // 显示键盘
        frame.size.height = SH - keyBoardHeight;
         tableViewFrame.size.height = _tableViewOrgFrame.size.height - keyBoardHeight;
    }
    else{
        // 隐藏键盘
        frame.size.height = SH;
        tableViewFrame.size.height = _tableViewOrgFrame.size.height;
    }
    
    [self setFrame:frame];
    [_tableView setFrame:tableViewFrame];
    
    return;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Section0"];
        
        if (!view)
        {
            view = [[UIView alloc] initWithFrame:kcr(0, 0, tableView.width, 50)];
            
            //        view.backgroundColor = tableView.backgroundColor;
            view.backgroundColor = [UIColor whiteColor];
            
            // 【设施】前的图标
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = kcr(15, 0, 45, 49);
            [imageBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navsheshi"]  forState:UIControlStateNormal];
            [imageBtn setEnabled:NO];
            [imageBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [view addSubview:imageBtn];
            
            UILabel *label = [[UILabel alloc] initWithFrame:kcr(65, 0, view.width - 65, 50)];
            
            label.textColor = UIColorFromRGB(0x555555);
            
            label.font = [UIFont boldSystemFontOfSize:18];
            
            label.tag = 100;
            
            [view addSubview:label];
            
            //CGRect rect = kcr(label.x, label.maxY + 5, tableView.width - 30, .5f);
            CGRect rect = kcr(0, 49, SW, 1.f);
            
            UIView *lineView = [[UIView alloc] initWithFrame:rect];
            
            lineView.backgroundColor = UIColorFromRGB(0xdcdada);
            
            [view addSubview:lineView];
        }
        
        UILabel *label = (UILabel *)[view viewWithTag:100];
        
        NSDictionary *dict = [self.data objectAtIndex:section];
        
        label.text = [dict objectForKey:@"name"];
        
        return view;
    }
    else{
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Section1"];
        
        if (!view)
        {
            view = [[UIView alloc] initWithFrame:kcr(0, 0, tableView.width, 65)];
            
            //        view.backgroundColor = tableView.backgroundColor;
            view.backgroundColor = [UIColor whiteColor];
            UIView *subView = [[UIView alloc] initWithFrame:kcr(0, 0, tableView.width, 15)];
//            subView.backgroundColor = UIColorFromRGB(0xeeeeee);
            subView.backgroundColor = [UIColor whiteColor];
            [view addSubview:subView];
            
            // 【分类】前的图标
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imageBtn.frame = kcr(15, 15, 45, 49);
            [imageBtn setImage:[UIImage imageNamed:@"navmap.bundle/images2/navfenlei"]  forState:UIControlStateNormal];
            [imageBtn setEnabled:NO];
            [imageBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [view addSubview:imageBtn];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:kcr(65, 15, view.width - 65, 50)];
            
            label.textColor = UIColorFromRGB(0x555555);
            
            label.font = [UIFont boldSystemFontOfSize:18];
            
            label.tag = 100;
            
            [view addSubview:label];
            
            //CGRect rect = kcr(label.x, label.maxY + 5, tableView.width - 30, .5f);
            CGRect rect = kcr(0, 64, SW, 1.f);
            
            UIView *lineView = [[UIView alloc] initWithFrame:rect];
            
            lineView.backgroundColor = UIColorFromRGB(0xdcdada);
            
            [view addSubview:lineView];
        }
        
        UILabel *label = (UILabel *)[view viewWithTag:100];
        
        NSDictionary *dict = [self.data objectAtIndex:section];
        
        label.text = [dict objectForKey:@"name"];
        
        return view;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50.;
    }
    else
    {
        return 65.;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 100.;
//    }
//    else{
//        NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
//        CGFloat fHeight = 43.;
//        if (indexPath.row == 0) {
//            fHeight = 48.;
//        }
//        
//        return fHeight;
//    }
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }
    NSDictionary *dict = [self.data objectAtIndex:section];
    
    return ceil([[dict objectForKey:@"list"] count] / (float)kColNum);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nSection = indexPath.section;
//    if (nSection == 0) {
//        // 设施
//        static NSString * const CateCellIdenti = @"CateCell1";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CateCellIdenti];
//        
//        if (!cell)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                   reuseIdentifier:CateCellIdenti];
//            [cell setBackgroundColor:[UIColor whiteColor]];
//        }
//        
//        NavKuaiJieSearchView *kjSearchView = (NavKuaiJieSearchView*)[cell viewWithTag:1000];
//        if (!kjSearchView)
//        {
//            kjSearchView = [[NavKuaiJieSearchView alloc] initWithFrame:kcr(0, 0, SW, 90.)];
//            [kjSearchView setTag:1000];
//            [cell addSubview:kjSearchView];
//            [kjSearchView setMapView:_mapView];
//            [kjSearchView controlInit];
//            
//        }
//        
//        UIView *subView = (UIView*)[cell viewWithTag:1001];
//        if (!subView) {
//            subView = [[UIView alloc] initWithFrame:kcr(0, 90, SW, 10)];
//            [subView setBackgroundColor:[UIColor whiteColor]];
//            subView.tag = 1001;
//            [cell addSubview:subView];
//        }
//        return cell;
//    }
//    else
    {
        // 分类
        static NSString * const CateCellIdenti = @"CateCell";
        
        CateCell *cell = [tableView dequeueReusableCellWithIdentifier:CateCellIdenti];
        
        if (!cell)
        {
            cell = [[CateCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CateCellIdenti];
            cell.delegate = self;
        }
        
        NSInteger st = indexPath.row * kColNum;
        
        NSDictionary *sdict = [self.data objectAtIndex:indexPath.section];
        
        NSArray *array = [sdict objectForKey:@"list"];
        
        for (NSInteger i = st; i < st + kColNum; i++)
        {
            if (i < array.count)
            {
                NSInteger nTag = i;
                NSDictionary *dict = [array objectAtIndex:i];
                if (indexPath.section == 1) {
                    // tag 大于100为中分类搜索
                    nTag = i + 100;
                }
                [cell setName:[dict objectForKey:@"name"] tag:nTag loc:i - st];
            }
        }
        
        return cell;
    }

}

- (void)didTagSeleted:(NSInteger)index cell:(UITableViewCell *)cell
{
    if (self.block)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDictionary *sdict = [self.data objectAtIndex:indexPath.section];
        
        NSArray *array = [sdict objectForKey:@"list"];
        
        if (index >= 100) {
            NSInteger nIndex = index - 100;
            self.block([array objectAtIndex:nIndex], 1);
        }
        else{
            self.block([array objectAtIndex:index], 0);
        }
    }
    
    [self hide];
}

- (void)showWithData:(NSArray *)data completion:(CateBlock)completion
{
//    
    self.data = data;
    
    self.block = completion;
    
    _tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
    
    self.alpha = 1;
}

- (void)hide
{

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}

+ (instancetype)instance:(CGRect)frame
{
    static CateView *_sharedView = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedView = [[CateView alloc] initWithFrame:frame];
    });
    
    return _sharedView;
}
@end

@implementation CateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.backgroundColor = [UIColor whiteColor];

        int gap = 10;
        
        //float width = (SW - 10 - 10 - (kColNum - 1) * gap - kMarginLeftRight) / kColNum;
        float width = (SW - 10 - 10 - (kColNum - 1) * gap) / kColNum;

        
        UIImage *image = [UIImage imageNamed:@"navmap.bundle/images/cate_tag_line_bg"];
        
//        UIImage *imageH = [UIImage imageNamed:@"cate_tag_line_bg_h"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < kColNum; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = kcr(10 + (gap + width) * i, 10, width, 33);
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [btn setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
            btn.layer.borderWidth = 1.f;
            btn.layer.borderColor = [[UIColor colorWithRed:0xaa/255. green:0xaa/255. blue:0xaa/255. alpha:0.3] CGColor];
            btn.layer.cornerRadius = 10.;
            
//            UIImage *bImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            
//            [btn setBackgroundImage:bImage forState:UIControlStateNormal];
            
//            UIImage *hImage = [imageH resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//            
//            [btn setBackgroundImage:hImage forState:UIControlStateHighlighted];

            [btn addTarget:self
                    action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            
            [array addObject:btn];
        }
        
        self.buttons = array;
    }
    
    return self;
}

- (void)btnClicked:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTagSeleted:cell:)])
    {
        [self.delegate didTagSeleted:btn.tag cell:self];
    }
}

- (void)setName:(NSString *)name tag:(NSInteger)tag loc:(NSInteger)loc
{
    for (NSInteger i = loc + 1; i < kColNum; i++)
    {
        UIButton *btn = [self.buttons objectAtIndex:i];
        
        btn.hidden = YES;
    }
    
    if (loc < kColNum)
    {
        UIButton *btn = [self.buttons objectAtIndex:loc];
        
        btn.hidden = NO;
        
        btn.tag = tag;
        
        [btn setTitle:name forState:UIControlStateNormal];
    }
}
@end
