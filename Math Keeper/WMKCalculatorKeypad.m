//
//  WMKCalculatorKeypad.m
//  Math Keeper
//
//  Created by Bill Wu on 8/10/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKCalculatorKeypad.h"
#import "WMKCalculatorViewController.h"

@implementation WMKCalculatorKeypad

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.width == 320) { // is iPhone 5, 5s, or SE?
        self.sinButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.cosButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.tanButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.sinhButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.coshButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.tanhButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
        self.randomButton.titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightThin];
    }
    
    self.initialAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.superscriptAttributes = @{NSBaselineOffsetAttributeName : @10, NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]};
    self.subscriptAttributes = @{NSBaselineOffsetAttributeName : @-10, NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]};
    
    NSMutableAttributedString *xSquared = [[NSMutableAttributedString alloc] initWithString:@"x2" attributes:self.initialAttributes];
    [xSquared setAttributes:self.superscriptAttributes range:NSMakeRange(1, 1)];
    [self.squareButton setAttributedTitle:xSquared forState:UIControlStateNormal];
    
    NSMutableAttributedString *secondary = [[NSMutableAttributedString alloc] initWithString:@"2nd" attributes:self.initialAttributes];
    [secondary setAttributes:self.superscriptAttributes range:NSMakeRange(1, 2)];
    [self.secondaryButton setAttributedTitle:secondary forState:UIControlStateNormal];
    
    NSMutableAttributedString *yRoot = [[NSMutableAttributedString alloc] initWithString:@"y\u221ax" attributes:self.initialAttributes];
    [yRoot setAttributes:self.superscriptAttributes range:NSMakeRange(0, 1)];
    [self.yRootButton setAttributedTitle:yRoot forState:UIControlStateNormal];
    
    NSMutableAttributedString *yPower = [[NSMutableAttributedString alloc] initWithString:@"xy" attributes:self.initialAttributes];
    [yPower setAttributes:self.superscriptAttributes range:NSMakeRange(1, 1)];
    [self.yPowerButton setAttributedTitle:yPower forState:UIControlStateNormal];
    
    NSMutableAttributedString *eToX = [[NSMutableAttributedString alloc] initWithString:@"ex" attributes:self.initialAttributes];
    [eToX setAttributes:self.superscriptAttributes range:NSMakeRange(1, 1)];
    [self.eToXButton setAttributedTitle:eToX forState:UIControlStateNormal];
    
    NSMutableAttributedString *tenToX = [[NSMutableAttributedString alloc] initWithString:@"10x" attributes:self.initialAttributes];
    [tenToX setAttributes:self.superscriptAttributes range:NSMakeRange(2, 1)];
    [self.tenToXButton setAttributedTitle:tenToX forState:UIControlStateNormal];
}

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark -

- (IBAction)switchToPageOne:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate switchToPageOne];
}

- (IBAction)switchToPageTwo:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate switchToPageTwo];
}

- (IBAction)clearButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate clearButtonPressed];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate deleteButtonPressed];
}

- (IBAction)parenthesisButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate parenthesisButtonPressed];
}

- (IBAction)enterButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate enterButtonPressed];
}

- (IBAction)secondaryButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate secondaryButtonPressed];
}

- (IBAction)degreeRadianButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate degreeRadianButtonPressed];
}

- (IBAction)positiveNegativeButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate positiveNegativeButtonPressed];
}

/*
- (IBAction)naturalLogButtonPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate naturalLogButtonPressed];
}
*/

- (IBAction)digit:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate insertDigit:sender.tag];
}

- (IBAction)number:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate insertNumber:sender.tag];
}

- (IBAction)operationWithAdditionalInput:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate calculateWithAdditionalInput:sender.tag];
}

- (IBAction)operationWithoutInput:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.delegate calculateWithoutInput:sender.tag];
}

#pragma mark -

- (void)updateClearButtonForEmptyEntry:(BOOL)isEntryEmpty emptyExpression:(BOOL)isExpressionEmpty emptyHistory:(BOOL)isHistoryEmpty {
    if (!isEntryEmpty) {
        [self.clearButton setTitle:@"CE" forState:UIControlStateNormal];
    }
    else if (!isHistoryEmpty && isExpressionEmpty) {
        [self.clearButton setTitle:@"CH" forState:UIControlStateNormal];
    }
    else {
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    }
}

- (void)updateSecondaryButtons:(BOOL)isSecondary {
    if (isSecondary) {
        [self.secondaryButton setBackgroundImage:[UIImage imageNamed:@"Background-DarkGray_selected"] forState:UIControlStateNormal];
        
        NSDictionary *superAttrs;
        CGFloat cosh;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.width == 320) { // is iPhone 5, 5s, or SE?
            superAttrs = @{NSBaselineOffsetAttributeName : @7, NSFontAttributeName : [UIFont systemFontOfSize:12 weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]};
            cosh = 17;
        }
        else {
            superAttrs = self.superscriptAttributes;
            cosh = 20;
        }
        
        NSMutableAttributedString *inverseSin = [[NSMutableAttributedString alloc] initWithString:@"sin-1" attributes:self.initialAttributes];
        [inverseSin setAttributes:superAttrs range:NSMakeRange(3, 2)];
        [self.sinButton setAttributedTitle:inverseSin forState:UIControlStateNormal];
        
        NSMutableAttributedString *inverseCos = [[NSMutableAttributedString alloc] initWithString:@"cos-1" attributes:self.initialAttributes];
        [inverseCos setAttributes:superAttrs range:NSMakeRange(3, 2)];
        [self.cosButton setAttributedTitle:inverseCos forState:UIControlStateNormal];
        
        NSMutableAttributedString *inverseTan = [[NSMutableAttributedString alloc] initWithString:@"tan-1" attributes:self.initialAttributes];
        [inverseTan setAttributes:superAttrs range:NSMakeRange(3, 2)];
        [self.tanButton setAttributedTitle:inverseTan forState:UIControlStateNormal];
        
        NSMutableAttributedString *inverseSinh = [[NSMutableAttributedString alloc] initWithString:@"sinh-1" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [inverseSinh setAttributes:superAttrs range:NSMakeRange(4, 2)];
        [self.sinhButton setAttributedTitle:inverseSinh forState:UIControlStateNormal];
        
        NSMutableAttributedString *inverseCosh = [[NSMutableAttributedString alloc] initWithString:@"cosh-1" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:cosh weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [inverseCosh setAttributes:superAttrs range:NSMakeRange(4, 2)];
        [self.coshButton setAttributedTitle:inverseCosh forState:UIControlStateNormal];
        
        NSMutableAttributedString *inverseTanh = [[NSMutableAttributedString alloc] initWithString:@"tanh-1" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightThin], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [inverseTanh setAttributes:superAttrs range:NSMakeRange(4, 2)];
        [self.tanhButton setAttributedTitle:inverseTanh forState:UIControlStateNormal];
        
        NSMutableAttributedString *twoToX = [[NSMutableAttributedString alloc] initWithString:@"2x" attributes:self.initialAttributes];
        [twoToX setAttributes:self.superscriptAttributes range:NSMakeRange(1, 1)];
        [self.tenToXButton setAttributedTitle:twoToX forState:UIControlStateNormal];
        
        NSMutableAttributedString *logBaseY = [[NSMutableAttributedString alloc] initWithString:@"logy" attributes:self.initialAttributes];
        [logBaseY setAttributes:self.subscriptAttributes range:NSMakeRange(3, 1)];
        //[self.lnButton setAttributedTitle:logBaseY forState:UIControlStateNormal];
        
        NSMutableAttributedString *logBaseTwo = [[NSMutableAttributedString alloc] initWithString:@"log2" attributes:self.initialAttributes];
        [logBaseTwo setAttributes:self.subscriptAttributes range:NSMakeRange(3, 1)];
        [self.logButton setAttributedTitle:logBaseTwo forState:UIControlStateNormal];
    }
    else {
        [self.secondaryButton setBackgroundImage:[UIImage imageNamed:@"Background-DarkGray"] forState:UIControlStateNormal];
        
        [self.sinButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.cosButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.tanButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.sinhButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.coshButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.tanhButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        NSMutableAttributedString *tenToX = [[NSMutableAttributedString alloc] initWithString:@"10x" attributes:self.initialAttributes];
        [tenToX setAttributes:self.superscriptAttributes range:NSMakeRange(2, 1)];
        [self.tenToXButton setAttributedTitle:tenToX forState:UIControlStateNormal];
        
        //[self.lnButton setAttributedTitle:nil forState:UIControlStateNormal];
        
        [self.logButton setAttributedTitle:nil forState:UIControlStateNormal];
    }
}

- (void)updateDegreeRadianButtonForRadians:(BOOL)isRadians {
    if (isRadians) {
        [self.degreeRadianButton setTitle:@"Deg" forState:UIControlStateNormal];
    }
    else {
        [self.degreeRadianButton setTitle:@"Rad" forState:UIControlStateNormal];
    }
}

- (void)updateEnterButton:(BOOL)shouldBeParenthesis {
    if (shouldBeParenthesis) {
        [self.enterButton setTitle:@")" forState:UIControlStateNormal];
    }
    else {
        [self.enterButton setTitle:@"=" forState:UIControlStateNormal];
    }
}

@end
