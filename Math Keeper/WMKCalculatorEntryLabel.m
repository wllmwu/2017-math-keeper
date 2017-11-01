//
//  WMKCalculatorEntryLabel.m
//  Math Keeper
//
//  Created by Bill Wu on 8/10/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKCalculatorEntryLabel.h"

@implementation WMKCalculatorEntryLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
