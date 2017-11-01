//
//  WMKMathKeyboardRootView.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKMathKeyboardRootView.h"
#import <iosMath/MTMathListIndex.h>

@implementation WMKMathKeyboardRootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isLowerCase = YES;
    self.contentScrollView.delegate = self;
    
    // initialize all keyboards
    NSBundle *bundle = [NSBundle mainBundle];
    self.numbersKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab1" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.numbersKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.numbersKeyboard.widthAnchor constraintEqualToConstant:150].active = YES;
    self.operatorsKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab2" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.operatorsKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.operatorsKeyboard.widthAnchor constraintEqualToConstant:350].active = YES;
    self.relationsKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab3" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.relationsKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.relationsKeyboard.widthAnchor constraintEqualToConstant:350].active = YES;
    self.symbolsKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab4" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.symbolsKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.symbolsKeyboard.widthAnchor constraintEqualToConstant:300].active = YES;
    self.functionsKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab5" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.functionsKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.functionsKeyboard.widthAnchor constraintEqualToConstant:250].active = YES;
    self.alphabetKeyboard = (WMKMathKeyboard *)[[UINib nibWithNibName:@"WMKMathKeyboardTab6" bundle:bundle] instantiateWithOwner:self options:nil][0];
    [self.alphabetKeyboard.heightAnchor constraintEqualToConstant:200].active = YES;
    [self.alphabetKeyboard.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
    self.keyboards = @[self.numbersKeyboard, self.operatorsKeyboard, self.relationsKeyboard, self.symbolsKeyboard, self.functionsKeyboard, self.alphabetKeyboard];
    self.currentTab = 0;
    self.currentKeyboard = self.numbersKeyboard;
    [self.numbersTabButton setSelected:YES];
    for (WMKMathKeyboard *keyboard in self.keyboards) {
        keyboard.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addArrangedSubview:keyboard];
    }
}

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

+ (WMKMathKeyboardRootView *)sharedInstance {
    static WMKMathKeyboardRootView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSBundle mainBundle] loadNibNamed:@"WMKMathKeyboardRootView" owner:nil options:nil][0];
    });
    return instance;
}

- (IBAction)tabButtonPressed:(UIButton *)sender {
    [self switchTab:sender.tag];
    switch (sender.tag) {
        case 0:
            [self.contentScrollView setContentOffset:self.numbersKeyboard.frame.origin animated:YES];
            break;
        case 1:
            [self.contentScrollView setContentOffset:self.operatorsKeyboard.frame.origin animated:YES];
            break;
        case 2:
            [self.contentScrollView setContentOffset:self.relationsKeyboard.frame.origin animated:YES];
            break;
        case 3:
            [self.contentScrollView setContentOffset:self.symbolsKeyboard.frame.origin animated:YES];
            break;
        case 4:
            [self.contentScrollView setContentOffset:self.functionsKeyboard.frame.origin animated:YES];
            break;
        case 5:
            [self.contentScrollView setContentOffset:self.alphabetKeyboard.frame.origin animated:YES];
            break;
        default:
            break;
    }
}

- (void)switchTab:(NSInteger)tabNumber {
    // deselect all tab buttons
    [self.numbersTabButton setSelected:NO];
    [self.operatorsTabButton setSelected:NO];
    [self.relationsTabButton setSelected:NO];
    [self.symbolsTabButton setSelected:NO];
    [self.functionsTabButton setSelected:NO];
    [self.alphabetTabButton setSelected:NO];
    
    // select tab button which was tapped and scroll to corresponding position
    self.currentTab = tabNumber;
    switch (tabNumber) {
        case 0:
            [self.numbersTabButton setSelected:YES];
            self.currentKeyboard = self.numbersKeyboard;
            break;
        case 1:
            [self.operatorsTabButton setSelected:YES];
            self.currentKeyboard = self.operatorsKeyboard;
            break;
        case 2:
            [self.relationsTabButton setSelected:YES];
            self.currentKeyboard = self.relationsKeyboard;
            break;
        case 3:
            [self.symbolsTabButton setSelected:YES];
            self.currentKeyboard = self.symbolsKeyboard;
            break;
        case 4:
            [self.functionsTabButton setSelected:YES];
            self.currentKeyboard = self.functionsKeyboard;
            break;
        case 5:
            [self.alphabetTabButton setSelected:YES];
            self.currentKeyboard = self.alphabetKeyboard;
            break;
        default:
            break;
    }
}

- (void)startedEditing:(UIView<UIKeyInput> *)label {
    for (WMKMathKeyboard *keyboard in self.keyboards) {
        keyboard.textView = label;
    }
}

- (void)finishedEditing:(UIView<UIKeyInput> *)label {
    for (WMKMathKeyboard *keyboard in self.keyboards) {
        keyboard.textView = nil;
    }
}

- (IBAction)backspacePressed:(UIButton *)sender {
    [self.currentKeyboard.textView deleteBackward];
}

- (IBAction)shiftPressed:(UIButton *)sender {
    [self.shiftButton setSelected:self.isLowerCase];
    if (self.isLowerCase) {
        for (WMKMathKeyboard *keyboard in self.keyboards) {
            [keyboard shiftUp];
        }
        [self.alphabetTabButton setTitle:@"ABCD" forState:UIControlStateNormal];
        [self.alphabetTabButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        self.isLowerCase = NO;
    }
    else {
        for (WMKMathKeyboard *keyboard in self.keyboards) {
            [keyboard shiftDown];
        }
        [self.alphabetTabButton setTitle:@"abcd" forState:UIControlStateNormal];
        [self.alphabetTabButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        self.isLowerCase = YES;
    }
}

- (IBAction)dismissPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.currentKeyboard.textView resignFirstResponder];
}

- (void)dismissKeyboard {
    [self.currentKeyboard.textView resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x < self.operatorsKeyboard.frame.origin.x - 100) { // stopped in numbers?
        [self switchTab:0];
    }
    else if (scrollView.contentOffset.x < self.relationsKeyboard.frame.origin.x - 100) { // stopped in operators?
        [self switchTab:1];
    }
    else if (scrollView.contentOffset.x < self.symbolsKeyboard.frame.origin.x - 100) { // stopped in relations?
        [self switchTab:2];
    }
    else if (scrollView.contentOffset.x < self.functionsKeyboard.frame.origin.x - 100) { // stopped in symbols?
        [self switchTab:3];
    }
    else if (scrollView.contentOffset.x < self.alphabetKeyboard.frame.origin.x - 100) { // stopped in functions?
        [self switchTab:4];
    }
    else { // stopped in alphabet
        [self switchTab:5];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < self.operatorsKeyboard.frame.origin.x - 100) { // stopped in numbers?
        [self switchTab:0];
    }
    else if (scrollView.contentOffset.x < self.relationsKeyboard.frame.origin.x - 100) { // stopped in operators?
        [self switchTab:1];
    }
    else if (scrollView.contentOffset.x < self.symbolsKeyboard.frame.origin.x - 100) { // stopped in relations?
        [self switchTab:2];
    }
    else if (scrollView.contentOffset.x < self.functionsKeyboard.frame.origin.x - 100) { // stopped in symbols?
        [self switchTab:3];
    }
    else if (scrollView.contentOffset.x < self.alphabetKeyboard.frame.origin.x - 100) { // stopped in functions?
        [self switchTab:4];
    }
    else { // stopped in alphabet
        [self switchTab:5];
    }
}

@end
