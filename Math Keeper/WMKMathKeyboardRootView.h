//
//  WMKMathKeyboardRootView.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMKMathKeyboard.h"
#import <MathEditor/MTEditableMathLabel.h>

static NSInteger const DEFAULT_KEYBOARD = 0;

@interface WMKMathKeyboardRootView : UIView<MTMathKeyboard, UIScrollViewDelegate>

@property (nonatomic) NSInteger currentTab;
@property (nonatomic) WMKMathKeyboard *currentKeyboard;
@property (nonatomic) IBOutlet UIButton *numbersTabButton;
@property (nonatomic) WMKMathKeyboard *numbersKeyboard;
@property (nonatomic) IBOutlet UIButton *operatorsTabButton;
@property (nonatomic) WMKMathKeyboard *operatorsKeyboard;
@property (nonatomic) IBOutlet UIButton *relationsTabButton;
@property (nonatomic) WMKMathKeyboard *relationsKeyboard;
@property (nonatomic) IBOutlet UIButton *symbolsTabButton;
@property (nonatomic) WMKMathKeyboard *symbolsKeyboard;
@property (nonatomic) IBOutlet UIButton *functionsTabButton;
@property (nonatomic) WMKMathKeyboard *functionsKeyboard;
@property (nonatomic) IBOutlet UIButton *alphabetTabButton;
@property (nonatomic) WMKMathKeyboard *alphabetKeyboard;
@property (nonatomic) NSArray<WMKMathKeyboard *> *keyboards;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UIStackView *contentView;
@property (nonatomic) IBOutlet UIButton *backspaceButton;
@property (nonatomic) IBOutlet UIButton *shiftButton;
@property (nonatomic) IBOutlet UIButton *dismissButton;
@property BOOL isLowerCase;

+ (WMKMathKeyboardRootView *)sharedInstance;
- (IBAction)tabButtonPressed:(UIButton *)sender;
- (void)switchTab:(NSInteger)tabNumber;
- (void)startedEditing:(UIView<UIKeyInput> *)label;
- (void)finishedEditing:(UIView<UIKeyInput> *)label;
- (IBAction)backspacePressed:(UIButton *)sender;
- (IBAction)shiftPressed:(UIButton *)sender;
- (IBAction)dismissPressed:(UIButton *)sender;
- (void)dismissKeyboard;

@end
