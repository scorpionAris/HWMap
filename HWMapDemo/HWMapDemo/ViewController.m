//
//  ViewController.m
//  HWMapDemo
//
//  Created by kevin_darren on 16/11/12.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import <HWMap/HWMap.h>

#pragma mark - buildingInfo
@interface buildingInfo : NSObject
@property (copy, nonatomic) NSString *buildingName;
@property (copy, nonatomic) NSString *buildingID;

+ (instancetype)infoWithName:(NSString *)name andID:(NSString *)ID;

@end

@implementation buildingInfo

- (instancetype)initWithName:(NSString *)name andID:(NSString *)ID {
    self = [super init];
    if (self) {
        self.buildingName = name;
        self.buildingID = ID;
    }
    
    return self;
}

+ (instancetype)infoWithName:(NSString *)name andID:(NSString *)ID {
    return [[self alloc] initWithName:name andID:ID];
}

@end

#pragma mark - viewController
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *buildingInfoArr;
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation ViewController
#pragma mark - lazyLoad
-(UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44;
        tableView.backgroundColor = [UIColor whiteColor];
        [self hiddingExtraSeperatorLineWithTableView:tableView];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.view.mas_height);
        }];
    }
    
    return _tableView;
}

- (NSMutableArray *)buildingInfoArr {
    if (!_buildingInfoArr) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:[buildingInfo infoWithName:@"H1" andID:@"440306"]];
        [arr addObject:[buildingInfo infoWithName:@"H2" andID:@"440307"]];
        [arr addObject:[buildingInfo infoWithName:@"H3" andID:@"440308"]];
        [arr addObject:[buildingInfo infoWithName:@"H4" andID:@"440309"]];
        
        _buildingInfoArr = arr;
    }
    
    return _buildingInfoArr;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buildingInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        buildingInfo *item = self.buildingInfoArr[indexPath.row];
        cell.textLabel.text = item.buildingName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - hiddingExtraSeperatorLine
- (void)hiddingExtraSeperatorLineWithTableView:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}


@end
