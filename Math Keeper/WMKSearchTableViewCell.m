//
//  WMKSearchTableViewCell.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKSearchTableViewCell.h"
#import "WMKEditManager.h"
#import <iosMath/MTFontManager.h>

@implementation WMKSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // set up MTMathUILabel properties for displaying formula
    self.formulaLabel = [[MTMathUILabel alloc] init];
    self.formulaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formulaLabel.textAlignment = kMTTextAlignmentLeft;
    self.formulaLabel.font = [[MTFontManager fontManager] termesFontWithSize:20];
    
    // add constraints for formula label
    [self.contentView addSubview:self.formulaLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[formulaLabel]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"formulaLabel" : self.formulaLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel][formulaLabel]-7-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"nameLabel" : self.nameLabel, @"formulaLabel" : self.formulaLabel}]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCategory {
    // change category label
    NSDictionary *data = [WMKEditManager loadData];
    NSString *category = [[data objectForKey:@"Categories"] objectAtIndex:self.categoryIndex];
    if (self.subcategoryIndex == -1) { // not in a subcategory?
        self.categoryLabel.text = [NSString stringWithFormat:@"%@ >", category];
    }
    else {
        NSString *subcategory = [[[data objectForKey:@"Subcategories"] objectAtIndex:self.categoryIndex] objectAtIndex:self.subcategoryIndex];
        self.categoryLabel.text = [NSString stringWithFormat:@"%@ > %@ >", category, subcategory];
    }
}

@end
