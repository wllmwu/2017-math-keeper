//
//  WMKMainCollectionViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface WMKMainCollectionViewController : UICollectionViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@interface WMKMainCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *categories;

- (UIImage *)lookForImageForCategory:(NSString *)category;
- (UIColor *)filterColorForIndex:(NSUInteger)categoryIndex;
- (UIColor *)textColorForIndex:(NSUInteger)categoryIndex;

@end
