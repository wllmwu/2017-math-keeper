//
//  WMKCategoryViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/8/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface WMKCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) BOOL isFavoritesCategory;
@property (nonatomic, strong) NSMutableArray *subcategories;
@property (nonatomic, strong) NSMutableArray *categoryFormulas;
@property (nonatomic, strong) NSDictionary *dataDictionary;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet GADBannerView *adView;

- (UIColor *)backgroundColorForIndex:(NSUInteger)categoryIndex;
- (IBAction)didEdgePanLeft:(id)sender;

@end
