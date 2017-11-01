//
//  WMKFormulaTableViewCell.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKFormulaTableViewCell.h"
#import "WMKEditManager.h"
#import <iosMath/MTFontManager.h>

@implementation WMKFormulaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // set up MTMathUILabel properties for displaying formula
    self.formulaLabel = [[MTMathUILabel alloc] init];
    self.formulaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formulaLabel.textAlignment = kMTTextAlignmentLeft;
    self.formulaLabel.font = [[MTFontManager fontManager] termesFontWithSize:20];
    self.formulaLabel.contentInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    
    // add constraints for formula label
    [self.contentView addSubview:self.formulaLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[formulaLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"formulaLabel":self.formulaLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel][formulaLabel]-7-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"nameLabel":self.nameLabel, @"formulaLabel":self.formulaLabel}]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)favoriteToggled:(UIButton *)sender {
    if (self.isFavorite) { // removing from Favorites?
        self.isFavorite = NO;
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite0"] forState:UIControlStateNormal];
    }
    else { // adding to Favorites
        self.isFavorite = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite1"] forState:UIControlStateNormal];
    }
    [WMKEditManager toggleFavoriteForFormulaAtIndex:self.formulaIndex inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex withValue:self.isFavorite];
}

@end
