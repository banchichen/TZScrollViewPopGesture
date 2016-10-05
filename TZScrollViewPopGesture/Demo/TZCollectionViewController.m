//
//  TZCollectionViewController.m
//  TZScrollViewPopGesture
//
//  Created by 谭真 on 2016/10/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZCollectionViewController.h"
#import "UINavigationController+TZPopGesture.h"

@interface TZCollectionViewController ()
@end

@implementation TZCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    collectionView.contentSize = CGSizeMake(1000, 0);
    collectionView.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:collectionView];
    
    // collectionView需要支持侧滑返回
    [self tz_addPopGestureToView:collectionView];
}

@end
