//
//  UINavigationController+TZPopGesture.m
//  让UIScrollView的滑动和侧滑返回并存——Demo
//
//  Created by 谭真 on 2016/10/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  2016.10.05 1.0.0版本

#import "UINavigationController+TZPopGesture.h"
#import <objc/runtime.h>

@implementation UINavigationController (TZPopGesture)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tzPop_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)tzPop_viewWillAppear:(BOOL)animated {
    [self tzPop_viewWillAppear:animated];
    // 只是为了触发tz_PopDelegate的get方法，获取到原始的interactivePopGestureRecognizer的delegate
    [self.tz_PopDelegate class];
    self.delegate = self;
}

- (id)tz_PopDelegate {
    id tz_PopDelegate = objc_getAssociatedObject(self, _cmd);
    if (!tz_PopDelegate) {
        tz_PopDelegate = self.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self, _cmd, tz_PopDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tz_PopDelegate;
}

- (UIPanGestureRecognizer *)tz_popGestureRecognizer {
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        // 侧滑返回手势 手势触发的时候，让target执行action
        id target = self.tz_PopDelegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pan;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
    return ret;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 让系统的侧滑返回生效
    self.interactivePopGestureRecognizer.enabled = YES;
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.tz_PopDelegate; // 不支持侧滑
    } else {
        self.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
    }
}

@end




@implementation UIViewController (TZPopGesture)

- (void)tz_addPopGestureToView:(UIView *)view {
    if (!self.navigationController) {
        // 在控制器转场的时候，self.navigationController可能是nil,这里用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tz_addPopGestureToView:view];
        });
    } else {
        UIPanGestureRecognizer *pan = self.navigationController.tz_popGestureRecognizer;
        [view addGestureRecognizer:pan];
    }
}

@end
