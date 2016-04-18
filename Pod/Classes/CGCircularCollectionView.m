//
//  CGCircularCollectionView.m
//  Pods
//
//  Created by guoshencheng on 4/15/16.
//
//

#import "CGCircularCollectionView.h"
#import "CGProtocolInterceptor.h"

static NSUInteger const ContentMultiplier = 4;

@interface CGCircularCollectionView ()

@property (nonatomic) BOOL circularImplicitlyDisabled;
@property (strong, nonatomic) NSIndexPath *historyIndexPath;
@property (assign, nonatomic) NSInteger historyIndex;

@end

@implementation CGCircularCollectionView{
    CAGradientLayer *_shadowLayer;
    CGProtocolInterceptor *_delegateInterceptor;
    CGProtocolInterceptor *_dataSourceInterceptor;
    BOOL _delegateRespondsToScrollViewDidScroll;
    BOOL _delegateRespondsToSizeForItemAtIndexPath;
    BOOL _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex;
    BOOL _delegateRespondsToMinimumLineSpacingForSectionAtIndex;
}

@synthesize circularDisabled = _explicitlyDisabled;

+ (instancetype)collectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

+ (instancetype)collectionView {
    return [[self alloc] init];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonCircularCollectionViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonCircularCollectionViewInit];
    }
    return self;
}

- (void)reloadData {
    CGPoint contentOffset = self.contentOffset;
    NSInteger index = contentOffset.x / [self collectionViewFlowLayout].itemSize.width;
    self.historyIndex = _itemCount ? index % _itemCount : 0;
    NSLog(@"realIndex:%@", @(self.historyIndex));
    [super reloadData];
    [self makeCenter];
}

#pragma mark - Accessors

- (void)setDataSource:(NSObject <UICollectionViewDataSource> *)dataSource {
    [super setDataSource:nil];
    _dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id)_dataSourceInterceptor];
}

- (void)setDelegate:(NSObject<UICollectionViewDelegateFlowLayout> *)delegate {
    [super setDelegate:nil];
    _delegateInterceptor.receiver = delegate;
    [super setDelegate:(id)_delegateInterceptor];
    _delegateRespondsToScrollViewDidScroll = [delegate respondsToSelector:@selector(scrollViewDidScroll:)];
    _delegateRespondsToSizeForItemAtIndexPath = [delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
    _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex = [delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)];
    _delegateRespondsToMinimumLineSpacingForSectionAtIndex = [delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)];
}

- (void)setCircularDisabled:(BOOL)circularDisabled {
    if (_explicitlyDisabled != circularDisabled) {
        _explicitlyDisabled = circularDisabled;
        [self reloadData];
    }
}

#pragma mark - Public Methods

- (BOOL)circularActive {
    return !_explicitlyDisabled && !_circularImplicitlyDisabled;
}

- (NSIndexPath *)normalizedIndexPath:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForItem:(_itemCount? indexPath.item % _itemCount : 0) inSection:indexPath.section];
}

#pragma mark - UICollectionViewDatasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(CGCircularCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSParameterAssert([collectionView isKindOfClass:[CGCircularCollectionView class]]);
    _itemCount = [_dataSourceInterceptor.receiver collectionView:collectionView numberOfItemsInSection:section];
    self.circularImplicitlyDisabled = [self disableCircularInternallyBasedOnContentSize];
    return [self circularActive]? _itemCount * ContentMultiplier : _itemCount;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_shadowLayer.hidden == NO) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _shadowLayer.position = scrollView.contentOffset;
        [CATransaction commit];
    }
    if (_delegateRespondsToScrollViewDidScroll) {
        [_delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
    [self recenterIfNecessary];
}

#pragma mark - Private Methods

- (void)commonCircularCollectionViewInit {
    NSSet *delegateProtocols = [NSSet setWithObjects:@protocol(UICollectionViewDelegate), @protocol(UIScrollViewDelegate), @protocol(UICollectionViewDelegateFlowLayout), nil];
    _delegateInterceptor = [CGProtocolInterceptor interceptorWithMiddleMan:self forProtocols:delegateProtocols];
    [super setDelegate:(id)_delegateInterceptor];
    _dataSourceInterceptor = [CGProtocolInterceptor interceptorWithMiddleMan:self forProtocol:@protocol(UICollectionViewDataSource)];
    [super setDataSource:(id)_dataSourceInterceptor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)recenterIfNecessary {
    if ([self circularActive]) {
        CGPoint currentOffset = self.contentOffset;
        CGFloat contentCenteredX = (self.contentSize.width - self.bounds.size.width) / 2.0f;
        CGFloat deltaFromCenter = currentOffset.x - contentCenteredX;
        CGFloat singleContentWidth = self.contentSize.width / ContentMultiplier;
        if (fabsf(deltaFromCenter) >= singleContentWidth ) {
            CGFloat correction = (deltaFromCenter > 0)? deltaFromCenter - singleContentWidth : deltaFromCenter + singleContentWidth;
            currentOffset.x = contentCenteredX + correction;
        }
        self.contentOffset = currentOffset;
    }
}

- (void)makeCenter {
    if ([self circularActive]) {
        CGPoint currentOffset = self.contentOffset;
        CGFloat contentCenteredX = (self.contentSize.width - self.bounds.size.width) / 2.0f;
        CGFloat deltaFromCenter = currentOffset.x - contentCenteredX;
        CGFloat singleContentWidth = self.contentSize.width / ContentMultiplier;
        if (fabsf(deltaFromCenter) >= singleContentWidth ) {
            CGFloat correction = (deltaFromCenter > 0)? deltaFromCenter - singleContentWidth : deltaFromCenter + singleContentWidth;
            currentOffset.x = contentCenteredX + correction;
        }
        self.contentOffset = currentOffset;
    }
}

- (BOOL)disableCircularInternallyBasedOnContentSize {
    CGSize requiredContentSize = [self calculateRequiredContentSize];
    CGSize spacingSize = [self calculateSpacingSize];
    return requiredContentSize.width + spacingSize.width < self.bounds.size.width;
}

- (CGSize)calculateRequiredContentSize {
    CGSize contentSize = CGSizeZero;
    CGSize largestItem = CGSizeZero;
    if (_delegateRespondsToSizeForItemAtIndexPath) {
        for (NSUInteger i = 0; i < _itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CGSize itemSize = [[self flowLayoutDelegate] collectionView:self layout:[self collectionViewFlowLayout] sizeForItemAtIndexPath:indexPath];
            contentSize.height += itemSize.height;
            contentSize.width += itemSize.width;
            if (itemSize.width > largestItem.width) {
                largestItem.width = itemSize.width;
            }
            if (itemSize.height > largestItem.height) {
                largestItem.height = itemSize.height;
            }
        }
    } else {
        contentSize.height += [self collectionViewFlowLayout].itemSize.height * _itemCount;
        contentSize.width += [self collectionViewFlowLayout].itemSize.width * _itemCount;
        largestItem = [self collectionViewFlowLayout].itemSize;
    }
    return CGSizeMake(contentSize.width - largestItem.width, contentSize.height - largestItem.height);
}

- (CGSize)calculateSpacingSize {
    CGFloat lineSpacing = _delegateRespondsToMinimumLineSpacingForSectionAtIndex? [[self flowLayoutDelegate] collectionView:self layout:[self collectionViewFlowLayout] minimumLineSpacingForSectionAtIndex:0] : (_itemCount * [self collectionViewFlowLayout].minimumLineSpacing);
    CGFloat interitemSpacing = _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex? [[self flowLayoutDelegate] collectionView:self layout:[self collectionViewFlowLayout] minimumInteritemSpacingForSectionAtIndex:0] : (_itemCount * [self collectionViewFlowLayout].minimumInteritemSpacing);
    return CGSizeMake(lineSpacing, interitemSpacing);
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    return (UICollectionViewFlowLayout *)self.collectionViewLayout;
}

- (id<UICollectionViewDelegateFlowLayout>)flowLayoutDelegate {
    return (id<UICollectionViewDelegateFlowLayout>)self.delegate;
}


@end
