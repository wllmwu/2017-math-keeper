//
//  WMKCategoryCollectionViewCell.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImageView;
@property (nonatomic, weak) IBOutlet UIImageView *filterImageView;

@end
