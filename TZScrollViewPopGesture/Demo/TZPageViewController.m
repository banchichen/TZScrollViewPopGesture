//
//  PageViewController.m
//  TZScrollViewPopGesture
//
//  Created by liuyuantao on 16/10/9.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZPageViewController.h"
#import "TZScrollViewController.h"
#import "UINavigationController+TZPopGesture.h"

@interface TZPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property(nonatomic, strong) NSArray *viewControlls;
@property(nonatomic, strong) UIPageViewController *pageVC;
@end

@implementation TZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    [self configChildViewControllers];

    self.pageVC.view.frame = self.view.bounds;
    [self.view addSubview:self.pageVC.view];
    [self.pageVC setViewControllers:@[self.viewControlls[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)configChildViewControllers {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < 4; i++) {
        TZSubScrollViewController *vc = [[TZSubScrollViewController alloc] init];
        vc.naviVc = self.navigationController;
        [array addObject:vc];
    }
    self.viewControlls = array;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (TZSubScrollViewController *vc in self.viewControlls) {
        if (!vc.naviVc) {
            vc.naviVc = self.navigationController;
            [self tz_addPopGestureToView:vc.scrollView];
        }
    }
}

#pragma mark-- UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControlls indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    TZSubScrollViewController *vc = self.viewControlls[index -1];
    vc.tz_naviVc = self.navigationController;
    return vc;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControlls indexOfObject:viewController];
    if (index == self.viewControlls.count - 1) {
        return nil;
    }
    TZSubScrollViewController *vc = self.viewControlls[index + 1];
    vc.tz_naviVc = self.navigationController;
    return vc;
}

@end



@implementation TZSubScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configScrollView];
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _scrollView.pagingEnabled = YES;
    CGFloat rgb = arc4random_uniform(200) / 256.0 + 0.2;
    _scrollView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb * 0.5 alpha:1.0];
    [self.view addSubview:_scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"我的背景色RGB值是%f",rgb];
}

- (void)setNaviVc:(UINavigationController *)naviVc {
    _naviVc = naviVc;
    self.tz_naviVc = self.naviVc;
//    [self tz_addPopGestureToView:_scrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self tz_addPopGestureToView:_scrollView];
}

@end
