//
//  WMKFormulaViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iosMath/MTMathUILabel.h>
@import GoogleMobileAds;

@interface WMKFormulaViewController : UIViewController

@property (nonatomic) NSUInteger formulaIndex;
@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) NSInteger subcategoryIndex;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, strong) NSString *formulaNote;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) MTMathUILabel *formulaLabel;
@property (nonatomic, weak) IBOutlet UILabel *noteLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet GADBannerView *adView;

- (IBAction)favoriteToggled:(UIButton *)sender;
- (void)shareFormula:(UIBarButtonItem *)sender;
- (IBAction)didEdgePanLeft:(id)sender;

@end
