//
//  UINavigationController+TZPop.h
//  让UIScrollView的滑动和侧滑返回并存——Demo
//
//  Created by 谭真 on 2016/10/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  2016.10.05 1.0.0版本

#import <UIKit/UIKit.h>

@interface UINavigationController (TZPopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end


@interface UIViewController (TZPopGesture)

@property (nonatomic, strong) UINavigationController *tz_naviVc;

- (void)tz_addPopGestureToView:(UIView *)view;

@end
