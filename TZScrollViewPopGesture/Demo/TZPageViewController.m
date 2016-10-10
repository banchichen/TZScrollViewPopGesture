//
//  PageViewController.m
//  TZScrollViewPopGesture
//
//  Created by liuyuantao on 16/10/9.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZPageViewController.h"
#import "UINavigationController+TZPopGesture.h"

@interface TZPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property(nonatomic, strong) NSArray *viewControlls;
@property(nonatomic, strong) UIPageViewController *pageVC;
@end

@implementation TZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPageVc];
    [self configChildViewControllers];
    [self.pageVC setViewControllers:@[self.viewControlls[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

/*
 UIPageViewController情况有些特殊，在切换显示不同的UIViewController时，当前显示的视图是交替变化的。
 我们为了支持侧滑返回，是把侧滑手势加在当前显示的可滑动视图上，这样侧滑手势才能发挥作用。
 
 在此案例中，四个TZSubScrollViewController交替显示，接受到滑动事件的，是TZSubScrollViewController的scrollView,因此
 我们把侧滑手势加在TZSubScrollViewController的scrollView上即可。
 
 1.0.2版本前我没有考虑到这种情况，侧滑手势是一个导航控制器只有一个，为了适配这种情况，我将侧滑手势配置成了一个控制器只有一个，这样就好了。
 */
- (void)configPageVc {
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    
    [self addChildViewController:self.pageVC];
    self.pageVC.view.frame = self.view.bounds;
    [self.view addSubview:self.pageVC.view];
}

- (void)configChildViewControllers {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < 4; i++) {
        TZSubScrollViewController *vc = [[TZSubScrollViewController alloc] init];
        [array addObject:vc];
    }
    self.viewControlls = array;
}

#pragma mark-- UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControlls indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    TZSubScrollViewController *vc = self.viewControlls[index -1];
    return vc;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControlls indexOfObject:viewController];
    if (index == self.viewControlls.count - 1) {
        return nil;
    }
    TZSubScrollViewController *vc = self.viewControlls[index + 1];
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
    
    // scrollView需要支持侧滑返回
    [self tz_addPopGestureToView:_scrollView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"我的背景色RGB值是%f",rgb];
}

@end
