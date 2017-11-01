//
//  WMKSearchTableViewCell.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iosMath/MTMathUILabel.h>

@interface WMKSearchTableViewCell : UITableViewCell

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) NSInteger subcategoryIndex;
@property (nonatomic) NSUInteger formulaIndex;
@property (nonatomic) BOOL isFavorite;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) MTMathUILabel *formulaLabel;

- (void)setupCategory;

@end
