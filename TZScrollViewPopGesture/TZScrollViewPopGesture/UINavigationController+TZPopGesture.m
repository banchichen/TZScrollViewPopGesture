//
//  UINavigationController+TZPopGesture.m
//  让UIScrollView的滑动和侧滑返回并存——Demo
//
//  Created by 谭真 on 2016/10/4.
//  Copyright © 2016年 谭真. All rights reserved.
//  2017.07.28 1.0.6版本

#import "UINavigationController+TZPopGesture.h"
#import <objc/runtime.h>

@interface UINavigationController (TZPopGesturePrivate)
@property (nonatomic, weak, readonly) id tz_naviDelegate;
@property (nonatomic, weak, readonly) id tz_popDelegate;
@end

@implementation UINavigationController (TZPopGesture)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tzPop_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)tzPop_viewWillAppear:(BOOL)animated {
    [self tzPop_viewWillAppear:animated];
    // 只是为了触发tz_PopDelegate的get方法，获取到原始的interactivePopGestureRecognizer的delegate
    [self.tz_popDelegate class];
    // 获取导航栏的代理
    [self.tz_naviDelegate class];
    self.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.delegate = self.tz_naviDelegate;
    });
}

- (id)tz_popDelegate {
    id tz_popDelegate = objc_getAssociatedObject(self, _cmd);
    if (!tz_popDelegate) {
        tz_popDelegate = self.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self, _cmd, tz_popDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
    return tz_popDelegate;
}

- (id)tz_naviDelegate {
    id tz_naviDelegate = objc_getAssociatedObject(self, _cmd);
    if (!tz_naviDelegate) {
        tz_naviDelegate = self.delegate;
        if (tz_naviDelegate) {
            objc_setAssociatedObject(self, _cmd, tz_naviDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
    }
    return tz_naviDelegate;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if ([self.navigationController.transitionCoordinator isAnimated]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    UIViewController *vc = self.topViewController;
    if (vc.tz_interactivePopDisabled) {
        return NO;
    }
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    // NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
    return ret;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 转发给业务方代理
    if (self.tz_naviDelegate && ![self.tz_naviDelegate isEqual:self]) {
        if ([self.tz_naviDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
            [self.tz_naviDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
        }
    }
    // 让系统的侧滑返回生效
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.childViewControllers.count > 0) {
        if (viewController == self.childViewControllers[0]) {
            self.interactivePopGestureRecognizer.delegate = self.tz_popDelegate; // 不支持侧滑
        } else {
            self.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 转发给业务方代理
    if (self.tz_naviDelegate && ![self.tz_naviDelegate isEqual:self]) {
        if ([self.tz_naviDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
            [self.tz_naviDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
        }
    }
}

@end



@interface UIViewController (TZPopGesturePrivate)
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tz_popGestureRecognizer;
@end

@implementation UIViewController (TZPopGesture)

- (void)tz_addPopGestureToView:(UIView *)view {
    if (!view) return;
    if (!self.navigationController) {
        // 在控制器转场的时候，self.navigationController可能是nil,这里用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tz_addPopGestureToView:view];
        });
    } else {
        UIPanGestureRecognizer *pan = self.tz_popGestureRecognizer;
        if (![view.gestureRecognizers containsObject:pan]) {
            [view addGestureRecognizer:pan];
        }
    }
}

- (UIPanGestureRecognizer *)tz_popGestureRecognizer {
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        // 侧滑返回手势 手势触发的时候，让target执行action
        id target = self.navigationController.tz_popDelegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self.navigationController;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_ASSIGN);
    }
    return pan;
}

- (BOOL)tz_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTz_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(tz_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
