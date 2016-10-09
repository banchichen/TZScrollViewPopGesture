//
//  TZHomeTableViewController.m
//  TZScrollViewPopGesture
//
//  Created by 谭真 on 2016/10/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZHomeViewController.h"
#import "TZScrollViewController.h"
#import "TZCollectionViewController.h"
#import "TZMapViewController.h"
#import "TZPageViewController.h"

@interface TZHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;
@end

@implementation TZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"TZScrollViewPopGesture";
    [self configTableView];
}

- (void)configTableView {
    _cellTitles = @[@"UIScrollView界面",@"UICollectionView界面",@"地图界面",@"UIPageViewController界面"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _cellTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [[TZScrollViewController alloc] init];
    } else if (indexPath.row == 1) {
        vc = [[TZCollectionViewController alloc] init];
    } else if (indexPath.row == 2) {
        vc = [[TZMapViewController alloc] init];
    } else if (indexPath.row == 3) {
        vc = [[TZPageViewController alloc] init];
    }
    vc.navigationItem.title = _cellTitles[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
