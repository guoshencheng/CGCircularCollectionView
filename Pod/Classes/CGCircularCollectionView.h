//
//  CGCircularCollectionView.h
//  Pods
//
//  Created by guoshencheng on 4/15/16.
//
//

#import <UIKit/UIKit.h>

@interface CGCircularCollectionView : UICollectionView

@property (nonatomic) NSUInteger itemCount;
@property (nonatomic) BOOL circularDisabled;
@property (nonatomic, readonly) BOOL circularActive;
- (NSIndexPath *)normalizedIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)circularIndexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout;
+ (instancetype)collectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout;
+ (instancetype)collectionView;

@end
