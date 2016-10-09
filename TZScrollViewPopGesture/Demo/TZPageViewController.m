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
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) NSArray *viewControlls;
@property(nonatomic, strong) UIPageViewController *pageVC;
@end

@implementation TZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    [self configChildViewControllers];
    self.pageVC.dataSource = self;
    self.pageVC.delegate = self;
    
    self.pageVC.view.frame = self.view.bounds;
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC setViewControllers:@[self.viewControlls[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)configChildViewControllers {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < 6; i++) {
        TZSubScrollViewController *vc = [[TZSubScrollViewController alloc] init];
        vc.view.tag = i;
        [array addObject:vc];
    }
    self.viewControlls = array;
    self.index = 0;
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
    if(index == self.viewControlls.count -1) {
        return nil;
    }
    TZSubScrollViewController *vc = self.viewControlls[index + 1];
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(6_0) {
    return self.viewControlls.count;
}

@end



@implementation TZSubScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configScrollView];
}

- (void)configScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    scrollView.pagingEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
    CGFloat rgb = 40 * (self.view.tag + 1);
    scrollView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    [self.view addSubview:scrollView];
    
    // scrollView需要支持侧滑返回
    [self tz_addPopGestureToView:scrollView];
}

@end
