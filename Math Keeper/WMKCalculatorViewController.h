//
//  WMKCalculatorViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 8/8/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMKCalculatorEntryLabel.h"
#import "WMKCalculatorKeypad.h"
@import GoogleMobileAds;

@interface WMKCalculatorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, WMKCalculatorKeypadDelegate>

@property (nonatomic, strong) NSMutableArray<NSString *> *resultHistory;
@property (nonatomic, strong) NSMutableArray<NSString *> *expression;
@property (nonatomic, strong) NSString *entry;
@property (nonatomic, strong) NSDecimalNumber *entryNumber;
@property (nonatomic) BOOL isEntryTemporary;
@property (nonatomic) BOOL isEntryEmpty;
@property (nonatomic) BOOL isExpressionTemporary;
@property (nonatomic) BOOL isExpressionEmpty;
@property (nonatomic) BOOL isHistoryEmpty;
@property (nonatomic) BOOL isErrorState;
@property (nonatomic) NSUInteger lastSelectedTableIndex;

@property (nonatomic, weak) IBOutlet GADBannerView *adView;
@property (nonatomic, weak) IBOutlet UITableView *historyTableView;
@property (nonatomic, weak) IBOutlet UILabel *expressionLabel;
@property (nonatomic, weak) IBOutlet UILabel *radiansLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *degreesConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radiansConstraint;
@property (nonatomic, weak) IBOutlet WMKCalculatorEntryLabel *entryLabel;

@property (nonatomic) BOOL isSecondary;
@property (nonatomic) BOOL isRadians;
@property (nonatomic) NSUInteger nestedParentheses;

@property (nonatomic, strong) IBOutlet UIView *calculatorKeypad;
@property (nonatomic, strong) WMKCalculatorKeypad *pageOne;
@property (nonatomic, strong) WMKCalculatorKeypad *pageTwo;

- (void)addFullSizeView:(UIView *)view to:(UIView *)parent;

- (void)addToHistory:(NSString *)result;
- (void)clearExpressionIfNeeded;
- (void)addToExpression:(NSString *)item;
- (void)updateExpressionLabel;
- (void)setAsEntry:(NSString *)entry;
- (void)insertFromHistory;
- (void)performCalculation;
- (BOOL)expressionEndsInOperator;

- (NSString *)factorialOf:(NSDecimalNumber *)x;
- (NSString *)logBase:(NSDecimalNumber *)base of:(NSDecimalNumber *)x;
- (NSString *)sin:(NSDecimalNumber *)x;
- (NSString *)cos:(NSDecimalNumber *)x;
- (NSString *)tan:(NSDecimalNumber *)x;
- (NSString *)asin:(NSDecimalNumber *)x;
- (NSString *)acos:(NSDecimalNumber *)x;
- (NSString *)atan:(NSDecimalNumber *)x;
- (NSString *)sinh:(NSDecimalNumber *)x;
- (NSString *)cosh:(NSDecimalNumber *)x;
- (NSString *)tanh:(NSDecimalNumber *)x;
- (NSString *)asinh:(NSDecimalNumber *)x;
- (NSString *)acosh:(NSDecimalNumber *)x;
- (NSString *)atanh:(NSDecimalNumber *)x;
- (NSString *)stringRadiansToDegrees:(NSString *)radians;
- (NSDecimalNumber *)radiansToDegrees:(NSDecimalNumber *)radians;
- (NSDecimalNumber *)degreesToRadians:(NSDecimalNumber *)degrees;

- (void)updateClearButton;
- (void)updateEnterButton;

/*
// there must be a better way to do this
@property (nonatomic, weak) IBOutlet UIButton *buttonA5; // divide | 2nd
@property (nonatomic, weak) IBOutlet UIButton *buttonB1; // reciprocal | factorial
@property (nonatomic, weak) IBOutlet UIButton *buttonB2; // 7 | sine (inverse sine)
@property (nonatomic, weak) IBOutlet UIButton *buttonB3; // 8 | cosine (inverse cosine)
@property (nonatomic, weak) IBOutlet UIButton *buttonB4; // 9 | tangent (inverse tangent)
@property (nonatomic, weak) IBOutlet UIButton *buttonB5; // multiply | degree-radian toggle
@property (nonatomic, weak) IBOutlet UIButton *buttonC1; // square root | y root
@property (nonatomic, weak) IBOutlet UIButton *buttonC2; // 4 | hyperbolic sine (inverse hyperbolic sine)
@property (nonatomic, weak) IBOutlet UIButton *buttonC3; // 5 | hyperbolic cosine (inverse hyperbolic cosine)
@property (nonatomic, weak) IBOutlet UIButton *buttonC4; // 6 | hyperbolic tangent (inverse hyperbolic tangent)
@property (nonatomic, weak) IBOutlet UIButton *buttonC5; // subtract | random
@property (nonatomic, weak) IBOutlet UIButton *buttonD1; // square | y power
@property (nonatomic, weak) IBOutlet UIButton *buttonD2; // 1 | e
@property (nonatomic, weak) IBOutlet UIButton *buttonD3; // 2 | e to x power
@property (nonatomic, weak) IBOutlet UIButton *buttonD4; // 3 | 10 to x power (2 to x power)
@property (nonatomic, weak) IBOutlet UIButton *buttonD5; // add | EE
@property (nonatomic, weak) IBOutlet UIButton *buttonE2; // 0 | pi
@property (nonatomic, weak) IBOutlet UIButton *buttonE3; // decimal | natural logarithm (base y logarithm)
@property (nonatomic, weak) IBOutlet UIButton *buttonE4; // positive-negative toggle | base 10 logarithm (base 2 logarithm)
*/
@end
