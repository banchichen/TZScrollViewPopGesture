//
//  TZNaviController.m
//  刷刷
//
//  Created by 谭真 on 16/1/24.
//  Copyright © 2016年 圣巴(上海)文化传播有限公司. All rights reserved.
//

#import "TZNaviController.h"

@interface TZNaviController ()
@end

@implementation TZNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_red"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    }
    viewController.view.backgroundColor = [UIColor whiteColor];
    [super pushViewController:viewController animated:YES];
}

- (void)back:(UIBarButtonItem *)item {
    [self popViewControllerAnimated:YES];
}

@end

