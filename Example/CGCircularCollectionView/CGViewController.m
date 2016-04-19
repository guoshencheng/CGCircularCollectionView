//
//  CGViewController.m
//  CGCircularCollectionView
//
//  Created by guoshencheng on 04/15/2016.
//  Copyright (c) 2016 guoshencheng. All rights reserved.
//

#import "CGViewController.h"

@implementation UIColor (CGViewController)

+ (UIColor *)gray:(CGFloat)gray {
    return [UIColor colorWithRed:gray green:gray blue:gray alpha:1];
}

@end

@implementation UIScreen (CGViewController)

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end

@interface CGViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation CGViewController

+ (instancetype)create {
    CGViewController *viewController = [[CGViewController alloc] initWithNibName:@"CGViewController" bundle:nil];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layout = [UICollectionViewFlowLayout new];
    self.layout.minimumInteritemSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.itemSize = CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.sectionInset = UIEdgeInsetsZero;
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UICollectionViewCell *)collectionView:(CGCircularCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    NSIndexPath *real = [collectionView normalizedIndexPath:indexPath];
    cell.backgroundColor = [UIColor gray:1.0 / 5 * real.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

@end
