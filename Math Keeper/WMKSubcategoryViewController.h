//
//  WMKSubcategoryViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface WMKSubcategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) NSUInteger subcategoryIndex;
@property (nonatomic, strong) NSMutableArray *subcategoryFormulas;
@property (nonatomic, strong) NSDictionary *dataDictionary;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *subcategoryImage;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, weak) IBOutlet UIButton *imageButton;
@property (nonatomic, weak) IBOutlet UIButton *changeImageButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageTableSpace;
@property (nonatomic) BOOL isDefaultSubcategoryImage;
@property (nonatomic, strong) IBOutlet GADBannerView *adView;

- (void)lookForSubcategoryImage;
- (UIColor *)backgroundColorForIndex:(NSUInteger)categoryIndex;
- (IBAction)didEdgePanLeft:(id)sender;
- (IBAction)imageTapped:(id)sender;

@end
