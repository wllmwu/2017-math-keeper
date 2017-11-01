//
//  WMKCalculatorHistoryTableViewCell.m
//  Math Keeper
//
//  Created by Bill Wu on 8/8/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKCalculatorHistoryTableViewCell.h"

@implementation WMKCalculatorHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.numberLabel.text];
}

@end
