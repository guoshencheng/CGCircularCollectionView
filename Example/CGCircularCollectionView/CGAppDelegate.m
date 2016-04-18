//
//  CGAppDelegate.m
//  CGCircularCollectionView
//
//  Created by guoshencheng on 04/15/2016.
//  Copyright (c) 2016 guoshencheng. All rights reserved.
//

#import "CGAppDelegate.h"
#import "CGViewController.h"

@implementation CGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CGViewController *viewController = [CGViewController create];
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
