//
//  WMKCalculatorKeypad.h
//  Math Keeper
//
//  Created by Bill Wu on 8/10/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMKCalculatorKeypadDelegate <NSObject>

- (void)switchToPageOne;
- (void)switchToPageTwo;
- (void)clearButtonPressed;
- (void)deleteButtonPressed;
- (void)parenthesisButtonPressed;
- (void)enterButtonPressed;
- (void)secondaryButtonPressed;
- (void)degreeRadianButtonPressed;
- (void)positiveNegativeButtonPressed;
//- (void)naturalLogButtonPressed;

- (void)insertDigit:(NSInteger)tag;
- (void)insertNumber:(NSInteger)tag;
- (void)calculateWithAdditionalInput:(NSInteger)tag;
- (void)calculateWithoutInput:(NSInteger)tag;

@end

@interface WMKCalculatorKeypad : UIView <UIInputViewAudioFeedback>

@property (nonatomic, weak) id <WMKCalculatorKeypadDelegate> delegate;

@property (nonatomic, strong) NSDictionary *initialAttributes;
@property (nonatomic, strong) NSDictionary *superscriptAttributes;
@property (nonatomic, strong) NSDictionary *subscriptAttributes;

@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UIButton *enterButton;
@property (nonatomic, weak) IBOutlet UIButton *squareButton;
@property (nonatomic, weak) IBOutlet UIButton *secondaryButton;
@property (nonatomic, weak) IBOutlet UIButton *sinButton;
@property (nonatomic, weak) IBOutlet UIButton *cosButton;
@property (nonatomic, weak) IBOutlet UIButton *tanButton;
@property (nonatomic, weak) IBOutlet UIButton *degreeRadianButton;
@property (nonatomic, weak) IBOutlet UIButton *yRootButton;
@property (nonatomic, weak) IBOutlet UIButton *sinhButton;
@property (nonatomic, weak) IBOutlet UIButton *coshButton;
@property (nonatomic, weak) IBOutlet UIButton *tanhButton;
@property (nonatomic, weak) IBOutlet UIButton *randomButton;
@property (nonatomic, weak) IBOutlet UIButton *yPowerButton;
@property (nonatomic, weak) IBOutlet UIButton *eToXButton;
@property (nonatomic, weak) IBOutlet UIButton *tenToXButton;
//@property (nonatomic, weak) IBOutlet UIButton *lnButton;
@property (nonatomic, weak) IBOutlet UIButton *logButton;

- (IBAction)switchToPageOne:(UIButton *)sender;
- (IBAction)switchToPageTwo:(UIButton *)sender;
- (IBAction)clearButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;
- (IBAction)parenthesisButtonPressed:(UIButton *)sender;
- (IBAction)enterButtonPressed:(UIButton *)sender;
- (IBAction)secondaryButtonPressed:(UIButton *)sender;
- (IBAction)degreeRadianButtonPressed:(UIButton *)sender;
- (IBAction)positiveNegativeButtonPressed:(UIButton *)sender;
//- (IBAction)naturalLogButtonPressed:(UIButton *)sender;

- (IBAction)digit:(UIButton *)sender;
- (IBAction)number:(UIButton *)sender;
- (IBAction)operationWithAdditionalInput:(UIButton *)sender;
- (IBAction)operationWithoutInput:(UIButton *)sender;

- (void)updateClearButtonForEmptyEntry:(BOOL)isEntryEmpty emptyExpression:(BOOL)isExpressionEmpty emptyHistory:(BOOL)isHistoryEmpty;
- (void)updateSecondaryButtons:(BOOL)isSecondary;
- (void)updateDegreeRadianButtonForRadians:(BOOL)isRadians;
- (void)updateEnterButton:(BOOL)shouldBeParenthesis;

@end
