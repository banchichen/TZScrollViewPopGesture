//
//  UINavigationController+TZPop.h
//  让UIScrollView的滑动和侧滑返回并存——Demo
//
//  Created by 谭真 on 2016/10/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  2016.10.14 1.0.3版本

#import <UIKit/UIKit.h>

@interface UINavigationController (TZPopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end


@interface UIViewController (TZPopGesture)

- (void)tz_addPopGestureToView:(UIView *)view;

@end
