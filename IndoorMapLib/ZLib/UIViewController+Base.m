//
//  UIViewController+Base.m
//  小说搜搜看
//
//  Created by Kevin Chou on 15-4-28.
//  Copyright (c) 2015年 com.nowsilence.sousou. All rights reserved.
//

#import "UIViewController+Base.h"

#import "NavIndoorMapViewController.h"


#import "NavConstants.h"


@implementation UIViewController (Base)


- (void)setLeftButton:(UIButton *)button
{
//    return;
    if (!button)
    {
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = nil;
        
        return;
    }
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                      target:nil
                                                      action:nil];
        negativeSeperator.width = -16;
        
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator, leftBarButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem animated:NO];
    }
}

- (void)setRightButton:(UIButton *)button
{
//    return;
    if (!button)
    {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        return;
    }
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                      target:nil
                                                      action:nil];
        //negativeSeperator.width = -10;
        negativeSeperator.width = -10;
        
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightBarButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:NO];
    }
}

- (void)setSearchControl:(UITextField*)keyWordTF searchBtn:(UIButton*)searchBtn
{
    CGFloat fWidth = SCREEN_WIDTH - 40;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fWidth, 44)];
//    [titleView setBackgroundColor:[UIColor redColor]];
//    [titleView setAlpha:0.7];
    
    CGFloat xPos = 7.;
    CGFloat yPos = 0;
    CGFloat fkeyWordTFWidth = fWidth - 50 - 10;
    CGFloat fkeyWordTFHeight = 35.;
    [keyWordTF setFrame:CGRectMake(xPos, yPos, fkeyWordTFWidth, fkeyWordTFHeight)];
    CGPoint center = keyWordTF.center;
    center.y = titleView.center.y;
    [keyWordTF setCenter:center];
    [titleView addSubview:keyWordTF];
    
    xPos = xPos + fkeyWordTFWidth + 3;
    CGFloat fSearchBtnWidth = 45;
    [searchBtn setFrame:CGRectMake(xPos, yPos, fSearchBtnWidth, fkeyWordTFHeight + 5)];
    center = searchBtn.center;
    center.y = titleView.center.y;
    [searchBtn setCenter:center];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:UIColorFromRGB(0xf0068B7) forState:UIControlStateNormal];
//    [searchBtn setBackgroundColor:[UIColor blackColor]];
    
    [titleView addSubview:searchBtn];
    
    [self.navigationItem setTitleView:titleView];
    
    return;
}

- (void)setIndoorMapRightButton:(UIButton *)searchButton routeBtn:(UIButton*)routeBtn
{
    //    return;
    if (!searchButton && !routeBtn)
    {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = nil;
        
        return;
    }
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    [rightView setBackgroundColor:[UIColor redColor]];
//    [rightView setAlpha:0.7];
    
    [rightView addSubview:searchButton];
    
    CGRect frame = searchButton.frame;
    frame.size.width += 5;
    frame.size.height += 5;
    CGPoint center = searchButton.center;
    center.y = rightView.center.y;
    [searchButton setCenter:center];

    
    [routeBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [rightView addSubview:routeBtn];
    center = routeBtn.center;
    center.y = searchButton.center.y;
    [routeBtn setCenter:center];
    
//    [routeBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                      target:nil
                                                      action:nil];
        negativeSeperator.width = -10;
        
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightBarButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:NO];
    }
}


#pragma mark 显示提示信息
- (void)showToast:(NSString *)text delay:(float)delay
{
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [aler show];
}

- (void)showToast:(NSString *)text
{
    [self showToast:text delay:0];
}

- (void)showToast:(NSString *)text completionBlock:(void (^)(void))completionBlock
{
    double delayInSeconds = 1.f;
    
    [self  showToast:text delay:delayInSeconds];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completionBlock();
    });
}

- (void)showNetHud:(NSString *)text
{
}

- (void)setMapButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"navmap.bundle/images/map_btn"];
    
    btn.frame = kcr(0, 0, image.size.width, image.size.height);
    
    [btn setImage:image forState:UIControlStateNormal];
    
    [btn addTarget:self
            action:@selector(mapButonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightButton:btn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)mapButonClicked
{
    
}

- (void)addBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"navmap.bundle/images/back_btn"];
    
    btn.frame = kcr(0, 0, image.size.width / 4 * 6, image.size.height / 5 * 6);
    
    [btn setImage:image forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self
            action:@selector(backward) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLeftButton:btn];
}

- (void)backward
{
    if ([self isKindOfClass:[NavIndoorMapViewController class]]) {
        NavIndoorMapViewController *indoorVC = (NavIndoorMapViewController*)self;
        [indoorVC BackToPreView];
    }
    
    if(![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark 旋转控制

-(NSUInteger)supportedInterfaceOrientations
{
    //    [self setMyLayout];
    return UIInterfaceOrientationMaskPortrait;
}

/**
 *  这个方法在写在viewcontroller中，在视图出现之前调用。需要注意一个地方，
 *  如果这个viewcontroller是navigationcontroller容器中的，它将永远不会被调用，
 *  只会调用navigationcontroller中的-(BOOL)shouldAutorotate。
 */
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    //    [self setMyLayout];//检测到旋转时就会被调用
}

/**
 *  为了兼容IOS6以前的版本而保留的方法
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
    //    return YES;//即在IOS6.0以下版本，支持所用方向的旋屏
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
#pragma clang diagnostic pop

- (UILabel *)infoLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:kcr(0, 0, SW, 44)];
    
    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor grayColor];
    
    label.shadowColor = [UIColor whiteColor];
    
    label.shadowOffset = CGSizeMake(0, 1);
    
    label.text = text;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}
@end
