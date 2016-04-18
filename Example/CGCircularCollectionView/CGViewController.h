//
//  CGViewController.h
//  CGCircularCollectionView
//
//  Created by guoshencheng on 04/15/2016.
//  Copyright (c) 2016 guoshencheng. All rights reserved.
//

#import "CGCircularCollectionView.h"

@interface CGViewController : UIViewController

@property (weak, nonatomic) IBOutlet CGCircularCollectionView *collectionView;

+ (instancetype)create;

@end
