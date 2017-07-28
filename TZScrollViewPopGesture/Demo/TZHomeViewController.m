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

@interface TZHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellTitles2;
@end

@implementation TZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"TZScrollViewPopGesture";
    [self configTableView];
}

- (void)configTableView {
    _cellTitles = @[@"UIScrollView界面",@"UICollectionView界面",@"地图界面",@"UIPageViewController界面"];
    _cellTitles2 = @[@"测试拍照"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _cellTitles.count : _cellTitles2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = indexPath.section == 0 ? _cellTitles[indexPath.row] : _cellTitles2[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    CGFloat rgb = 244 / 255.0;
    header.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 20, header.frame.size.width, 30);
    label.font = [UIFont systemFontOfSize:14];
    rgb = 128 / 255.0;
    label.textColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    label.text = section == 0 ? @"    测试功能" : @"    测试兼容性";
    [header addSubview:label];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
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
    } else {
        // 测试拍照
        if (indexPath.row == 0) {
            [self pushImagePickerController];
        }
    }
}

#pragma mark - 点击事件

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
        imagePickerVc.sourceType = sourceType;
        imagePickerVc.delegate = self;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"拍照成功，拿到图片:%@",photo);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消拍照");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
