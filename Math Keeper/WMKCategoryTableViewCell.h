//
//  WMKCategoryTableViewCell.h
//  Math Keeper
//
//  Created by Bill Wu on 7/4/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKCategoryTableViewCell : UITableViewCell

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) NSInteger subcategoryIndex;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;

@end
