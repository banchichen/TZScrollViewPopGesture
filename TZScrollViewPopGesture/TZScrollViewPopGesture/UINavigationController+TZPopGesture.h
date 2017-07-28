//
//  UINavigationController+TZPop.h
//  让UIScrollView的滑动和侧滑返回并存——Demo
//
//  Created by 谭真 on 2016/10/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  2017.07.28 1.0.6版本

#import <UIKit/UIKit.h>

@interface UINavigationController (TZPopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end


@interface UIViewController (TZPopGesture)

/// 给view添加侧滑返回效果
- (void)tz_addPopGestureToView:(UIView *)view;

/// 禁止该页面的侧滑返回
@property (nonatomic, assign) BOOL tz_interactivePopDisabled;

@end
