//
//  WMKPageViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 8/7/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKPageViewController : UIPageViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSArray *pages;

@end
