//
//  WMKCalculatorViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 8/8/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKCalculatorViewController.h"
#import "WMKCalculatorHistoryTableViewCell.h"
#import <math.h>

@interface WMKCalculatorViewController ()

@end

@implementation WMKCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSBundle *bundle = [NSBundle mainBundle];
    self.pageOne = (WMKCalculatorKeypad *)[[UINib nibWithNibName:@"WMKCalculatorPage1" bundle:bundle] instantiateWithOwner:self options:nil][0];
    self.pageOne.delegate = self;
    self.pageTwo = (WMKCalculatorKeypad *)[[UINib nibWithNibName:@"WMKCalculatorPage2" bundle:bundle] instantiateWithOwner:self options:nil][0];
    self.pageTwo.delegate = self;
    [self addFullSizeView:self.pageOne to:self.calculatorKeypad];
    [self addFullSizeView:self.pageTwo to:self.calculatorKeypad];
    [self.calculatorKeypad bringSubviewToFront:self.pageOne];
    
    self.resultHistory = [[NSMutableArray alloc] init];
    self.expression = [[NSMutableArray alloc] init];
    self.entry = @"0";
    self.entryNumber = [NSDecimalNumber zero];
    self.isEntryTemporary = NO;
    self.isEntryEmpty = YES;
    self.isExpressionTemporary = NO;
    self.isExpressionEmpty = YES;
    self.isHistoryEmpty = YES;
    self.isErrorState = NO;
    self.lastSelectedTableIndex = 0;
    self.isSecondary = NO;
    self.isRadians = NO;
    self.nestedParentheses = 0;
    
    self.radiansConstraint = [NSLayoutConstraint constraintWithItem:self.entryLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.expressionLabel
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.2
                                                           constant:0];
    self.radiansConstraint.active = NO;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.entryLabel addGestureRecognizer:gestureRecognizer];
    
    // set up ad view
    self.adView.adUnitID = @"ca-app-pub-8611059613472162/6319193789";
    self.adView.rootViewController = self;
    self.adView.adSize = kGADAdSizeBanner;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMKCalculatorHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.numberLabel.text = [self.resultHistory objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WMKCalculatorHistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
    self.lastSelectedTableIndex = indexPath.row;
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Insert value" action:@selector(insertFromHistory)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:cell.frame inView:cell.superview];
    menuController.menuItems = @[menuItem];
    [menuController setMenuVisible:YES animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized && [recognizer.view becomeFirstResponder]) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:recognizer.view.frame inView:recognizer.view.superview];
        menuController.menuItems = nil;
        [menuController setMenuVisible:YES animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - WMKCalculatorKeypad delegate

- (void)switchToPageOne {
    [self.calculatorKeypad bringSubviewToFront:self.pageOne];
}

- (void)switchToPageTwo {
    [self.calculatorKeypad bringSubviewToFront:self.pageTwo];
}

- (void)clearButtonPressed {
    if (!self.isEntryEmpty) {
        [self setAsEntry:@"0"];
        self.isEntryTemporary = NO;
        self.isEntryEmpty = YES;
        self.isErrorState = NO;
    }
    else if (!self.isExpressionEmpty) {
        [self.expression removeAllObjects];
        [self updateExpressionLabel];
        self.nestedParentheses = 0;
        [self updateEnterButton];
        self.isExpressionEmpty = YES;
    }
    else if (!self.isHistoryEmpty) {
        [self.resultHistory removeAllObjects];
        [self.historyTableView reloadData];
        self.isHistoryEmpty = YES;
    }
    [self updateClearButton];
}

- (void)deleteButtonPressed {
    if (!self.isErrorState) {
        [self clearExpressionIfNeeded];
        if (![self.entry isEqualToString:@"0"]) {
            [self setAsEntry:[self.entry substringToIndex:([self.entry length] - 1)]];
        }
        if ([self.entry isEqualToString:@""]) {
            [self setAsEntry:@"0"];
        }
    }
}

- (void)parenthesisButtonPressed {
    if (!self.isErrorState) {
        [self clearExpressionIfNeeded];
        if ([[self.expression lastObject] isEqualToString:@")"]) {
            [self addToExpression:@"\u00d7"];
        }
        [self addToExpression:@"("];
        self.isExpressionTemporary = NO;
        self.nestedParentheses++;
        self.isExpressionEmpty = NO;
        [self updateClearButton];
        [self updateEnterButton];
    }
}

- (void)enterButtonPressed {
    if (!self.isErrorState) {
        if (self.nestedParentheses > 0) {
            [self addToExpression:self.entry];
            [self addToExpression:@")"];
            self.nestedParentheses--;
            [self updateEnterButton];
        }
        else if ([self expressionEndsInOperator]) {
            [self addToExpression:self.entry];
            self.isExpressionTemporary = YES;
        }
        
        NSString *current = self.entry;
        if (!self.isExpressionEmpty && self.nestedParentheses == 0) {
            self.isEntryEmpty = NO;
            self.isEntryTemporary = YES;
            [self performCalculation];
            if (![current isEqualToString:self.entry]) {
                [self addToHistory:self.entry];
            }
        }
        [self updateClearButton];
    }
}

- (void)secondaryButtonPressed {
    if (self.isSecondary) {
        self.isSecondary = NO;
    }
    else {
        self.isSecondary = YES;
    }
    [self.pageTwo updateSecondaryButtons:self.isSecondary];
}

- (void)degreeRadianButtonPressed {
    if (self.isRadians) {
        self.isRadians = NO;
        self.radiansLabel.text = nil;
        self.radiansConstraint.active = NO;
        self.degreesConstraint.active = YES;
    }
    else {
        self.isRadians = YES;
        self.radiansLabel.text = @"Rad";
        self.degreesConstraint.active = NO;
        self.radiansConstraint.active = YES;
    }
    [self.pageTwo updateDegreeRadianButtonForRadians:self.isRadians];
}

- (void)positiveNegativeButtonPressed {
    if (!self.isErrorState) {
        [self clearExpressionIfNeeded];
        if ([self.entry containsString:@"-"]) {
            [self setAsEntry:[self.entry stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }
        else {
            [self setAsEntry:[NSString stringWithFormat:@"-%@", self.entry]];
        }
    }
}

/*
- (void)naturalLogButtonPressed {
    if (!self.isErrorState) {
        [self clearExpressionIfNeeded];
        double currentValue = [self.entry doubleValue];
        // natural log (base e)
        double ln = log10(currentValue) / log10(M_E);
        [self setAsEntry:[NSString stringWithFormat:@"%g", ln]];
        self.isEntryTemporary = YES;
        [self updateClearButton];
    }
}
*/

- (void)insertDigit:(NSInteger)tag {
    [self clearExpressionIfNeeded];
    switch (tag) {
        case 10:
            // insert decimal point if it doesn't already have one
            if (self.isEntryTemporary) {
                [self setAsEntry:@"0."];
                self.isEntryTemporary = NO;
            }
            else if (![self.entry containsString:@"."]) {
                [self setAsEntry:[self.entry stringByAppendingString:@"."]];
            }
            break;
        default:
            // insert tag as a digit
            if ([self.entry isEqualToString:@"0"] || self.isEntryTemporary) {
                [self setAsEntry:@""];
            }
            else if ([self.entry isEqualToString:@"-0"]) {
                [self setAsEntry:@"-"];
            }
            [self setAsEntry:[self.entry stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)tag]]];
            self.isEntryTemporary = NO;
            break;
    }
    
    if (tag != 0) {
        self.isEntryEmpty = NO;
        [self updateClearButton];
    }
    self.isErrorState = NO;
}

- (void)insertNumber:(NSInteger)tag {
    [self clearExpressionIfNeeded];
    switch (tag) {
        case 0:
            // insert pi
            [self setAsEntry:@"3.14159265358979"];
            break;
        case 1:
            // insert e
            [self setAsEntry:@"2.71828182845905"];
            break;
        case 2:
            // insert random
            srand48(time(0));
            [self setAsEntry:[NSString stringWithFormat:@"%g", drand48()]];
            break;
        default:
            break;
    }
    
    self.isEntryTemporary = YES;
    self.isEntryEmpty = NO;
    [self updateClearButton];
    self.isErrorState = NO;
}

- (void)calculateWithAdditionalInput:(NSInteger)tag {
    if (!self.isErrorState) {
        [self clearExpressionIfNeeded];
        
        if (![(NSString *)[self.expression lastObject] isEqualToString:@")"]) {
            [self addToExpression:self.entry];
        }
        switch (tag) {
            case 0:
                // add
                [self addToExpression:@"+"];
                break;
            case 1:
                // subtract
                [self addToExpression:@"\u2212"];
                break;
            case 2:
                // multiply
                [self addToExpression:@"\u00d7"];
                break;
            case 3:
                // divide
                [self addToExpression:@"\u00f7"];
                break;
            case 4:
                // exponent
                [self addToExpression:@"^"];
                break;
            case 5:
                // root
                [self addToExpression:@"^"];
                [self addToExpression:@"("];
                [self addToExpression:@"1"];
                [self addToExpression:@"\u00f7"];
                self.nestedParentheses++;
                [self updateEnterButton];
                break;
            case 6:
                // EE
                [self addToExpression:@"\u00d7"];
                [self addToExpression:@"10"];
                [self addToExpression:@"^"];
                break;
            default:
                break;
        }
        
        self.isEntryTemporary = YES;
        self.isExpressionTemporary = NO;
        self.isExpressionEmpty = NO;
        [self performCalculation];
    }
}

- (void)calculateWithoutInput:(NSInteger)tag {
    if (!self.isErrorState) {
        if (![self expressionEndsInOperator] && self.nestedParentheses == 0) {
            self.isExpressionTemporary = YES;
        }
        [self clearExpressionIfNeeded];
        NSDecimalNumber *currentEntry = [NSDecimalNumber decimalNumberWithString:self.entry];
        NSExpression *expression = nil;
        switch (tag) {
            case 0:
                // square
                expression = [NSExpression expressionWithFormat:@"%@ * %@", currentEntry, currentEntry];
                //[self setAsEntry:[NSString stringWithFormat:@"%g", (currentEntry * currentEntry)]];
                break;
            case 1:
                // square root
                if ([currentEntry doubleValue] < 0.0) {
                    [self setAsEntry:@"Error"];
                    self.isErrorState = YES;
                }
                else {
                    expression = [NSExpression expressionWithFormat:@"%@ ** 0.5", currentEntry];
                    //result = [expression expressionValueWithObject:nil context:nil];
                    //[self setAsEntry:[result stringValue]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", sqrt(currentEntry)]];
                }
                break;
            case 2:
                // reciprocal
                if ([currentEntry doubleValue] == 0.0) {
                    [self setAsEntry:@"Error"];
                    self.isErrorState = YES;
                }
                else {
                    expression = [NSExpression expressionWithFormat:@"1 / %@", currentEntry];
                    //result = [expression expressionValueWithObject:nil context:nil];
                    //[self setAsEntry:[result stringValue]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", (1.0 / currentEntry)]];
                }
                break;
            case 3:
                // factorial
                [self setAsEntry:[self factorialOf:currentEntry]];
                break;
            case 4:
                if (self.isSecondary) {
                    // inverse sine
                    if (self.isRadians) {
                        [self setAsEntry:[self asin:currentEntry]];
                    }
                    else {
                        [self setAsEntry:[self stringRadiansToDegrees:[self asin:currentEntry]]];
                    }
                }
                else {
                    // sine
                    if (!self.isRadians) {
                        currentEntry = [self degreesToRadians:currentEntry];
                    }
                    [self setAsEntry:[self sin:currentEntry]];
                }
                break;
            case 5:
                if (self.isSecondary) {
                    // inverse cosine
                    if (self.isRadians) {
                        [self setAsEntry:[self acos:currentEntry]];
                    }
                    else {
                        [self setAsEntry:[self stringRadiansToDegrees:[self acos:currentEntry]]];
                    }
                }
                else {
                    // cosine
                    if (!self.isRadians) {
                        currentEntry = [self degreesToRadians:currentEntry];
                    }
                    [self setAsEntry:[self cos:currentEntry]];
                }
                break;
            case 6:
                if (self.isSecondary) {
                    // inverse tangent
                    if (self.isRadians) {
                        [self setAsEntry:[self atan:currentEntry]];
                    }
                    else {
                        [self setAsEntry:[self stringRadiansToDegrees:[self atan:currentEntry]]];
                    }
                }
                else {
                    // tangent
                    if (!self.isRadians) {
                        currentEntry = [self degreesToRadians:currentEntry];
                    }
                    [self setAsEntry:[self tan:currentEntry]];
                }
                break;
            case 7:
                if (self.isSecondary) {
                    // inverse h sine
                    [self setAsEntry:[self asinh:currentEntry]];
                }
                else {
                    // h sine
                    [self setAsEntry:[self sinh:currentEntry]];
                }
                break;
            case 8:
                if (self.isSecondary) {
                    // inverse h cosine
                    [self setAsEntry:[self acosh:currentEntry]];
                }
                else {
                    // h cosine
                    [self setAsEntry:[self cosh:currentEntry]];
                }
                break;
            case 9:
                if (self.isSecondary) {
                    // inverse h tangent
                    [self setAsEntry:[self atanh:currentEntry]];
                }
                else {
                    // h tangent
                    [self setAsEntry:[self tanh:currentEntry]];
                }
                break;
            case 10:
                // e to x
                expression = [NSExpression expressionWithFormat:@"2.718281828459045 ** %@", currentEntry];
                //result = [expression expressionValueWithObject:nil context:nil];
                //[self setAsEntry:[result stringValue]];
                break;
            case 11:
                if (self.isSecondary) {
                    // 2 to x
                    expression = [NSExpression expressionWithFormat:@"2 ** %@", currentEntry];
                    //result = [expression expressionValueWithObject:nil context:nil];
                    //[self setAsEntry:[result stringValue]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", pow(2.0, currentEntry)]];
                }
                else {
                    // 10 to x
                    expression = [NSExpression expressionWithFormat:@"10 ** %@", currentEntry];
                    //result = [expression expressionValueWithObject:nil context:nil];
                    //[self setAsEntry:[result stringValue]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", pow(10.0, currentEntry)]];
                }
                break;
            case 12:
                // natural log (base e)
                expression = [NSExpression expressionForFunction:@"ln:" arguments:@[[NSExpression expressionForConstantValue:currentEntry]]];
                //result = [expression expressionValueWithObject:nil context:nil];
                //[self setAsEntry:[result stringValue]];
                //[self setAsEntry:[NSString stringWithFormat:@"%g", log10(currentEntry) / log10(M_E)]];
                break;
            case 13:
                if (self.isSecondary) {
                    // log base 2
                    [self setAsEntry:[self logBase:[NSDecimalNumber decimalNumberWithString:@"2"] of:currentEntry]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", log2(currentEntry)]];
                }
                else {
                    // log base 10
                    expression = [NSExpression expressionForFunction:@"log:" arguments:@[[NSExpression expressionForConstantValue:currentEntry]]];
                    //result = [expression expressionValueWithObject:nil context:nil];
                    //[self setAsEntry:[result stringValue]];
                    //[self setAsEntry:[NSString stringWithFormat:@"%g", log10(currentEntry)]];
                }
                break;
            default:
                break;
        }
        if (expression) {
            NSDecimalNumber *result = [expression expressionValueWithObject:nil context:nil];
            [self setAsEntry:[result stringValue]];
        }
        
        if (self.isExpressionEmpty && !self.isErrorState) {
            [self addToHistory:self.entry];
        }
    }
    
    self.isEntryTemporary = YES;
    self.isEntryEmpty = NO;
    //self.isExpressionEmpty = NO;
    [self updateClearButton];
}

#pragma mark -

- (void)addFullSizeView:(UIView *)view to:(UIView *)parent {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [parent addSubview:view];
    [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views]];
    [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views]];
}

- (void)addToHistory:(NSString *)result {
    if (![result isEqualToString:@"Error"]) {
        [self.resultHistory addObject:result];
        [self.historyTableView reloadData];
        [self.historyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.resultHistory count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        self.isHistoryEmpty = NO;
    }
}

- (void)clearExpressionIfNeeded {
    if (self.isExpressionTemporary || self.isErrorState) {
        [self.expression removeAllObjects];
        [self updateExpressionLabel];
        self.isExpressionEmpty = YES;
        self.isExpressionTemporary = NO;
        self.isErrorState = NO;
    }
}

- (void)addToExpression:(NSString *)item {
    [self.expression addObject:item];
    [self updateExpressionLabel];
}

- (void)updateExpressionLabel {
    self.expressionLabel.text = [NSString stringWithFormat:@" %@", [self.expression componentsJoinedByString:@" "]];
}

- (void)setAsEntry:(NSString *)entry {
    if ([entry isEqualToString:@"Error"]) {
        self.entry = entry;
        self.entryLabel.text = entry;
        self.isErrorState = YES;
        return;
    }
    
    NSMutableArray *array = [[entry componentsSeparatedByString:@"e"] mutableCopy];
    NSString *mantissa = [array objectAtIndex:0];
    if ([mantissa containsString:@"."] && [[mantissa stringByReplacingOccurrencesOfString:@"." withString:@""] length] > 15) {
        mantissa = [mantissa substringToIndex:16]; // include decimal
        [array setObject:mantissa atIndexedSubscript:0];
        entry = [array componentsJoinedByString:@"e"];
    }
    if ([[mantissa stringByReplacingOccurrencesOfString:@"." withString:@""] length] <= 15) {
        self.entry = entry;
        self.entryLabel.text = entry;
    }
}

- (void)insertFromHistory {
    [self clearExpressionIfNeeded];
    [self setAsEntry:[self.resultHistory objectAtIndex:self.lastSelectedTableIndex]];
}

- (void)performCalculation {
    // fix the expression so that NSExpression works correctly
    NSMutableArray *currentExpression = [NSMutableArray arrayWithArray:self.expression];
    if ([self expressionEndsInOperator]) {
        [currentExpression removeObjectAtIndex:([currentExpression count] - 1)];
    }
    for (int i = 0; i < [currentExpression count]; i++) {
        NSString *item = [currentExpression objectAtIndex:i];
        if (![@[@"+", @"\u2212", @"\u00d7", @"\u00f7", @"^", @"(", @")"] containsObject:item] && ![item containsString:@"."]) { // item is an integer?
            [currentExpression setObject:[item stringByAppendingString:@".0"] atIndexedSubscript:i];
        }
    }
    NSString *calculation = [[currentExpression componentsJoinedByString:@" "] stringByAppendingString:@" "];
    calculation = [calculation stringByReplacingOccurrencesOfString:@"\u2212" withString:@"-"];
    calculation = [calculation stringByReplacingOccurrencesOfString:@"\u00d7" withString:@"*"];
    calculation = [calculation stringByReplacingOccurrencesOfString:@"\u00f7" withString:@"/"];
    calculation = [calculation stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    calculation = [calculation stringByReplacingOccurrencesOfString:@") (" withString:@")*("];
    calculation = [calculation stringByReplacingOccurrencesOfString:@"e+" withString:@"*10**"];
    if ([calculation containsString:@"e-"]) {
        calculation = [calculation stringByReplacingOccurrencesOfString:@"e" withString:@"*10**("];
        self.nestedParentheses++;
    }
    for (int i = 0; i < self.nestedParentheses; i++) {
        calculation = [calculation stringByAppendingString:@")"];
    }
    
    if ([calculation containsString:@"/ 0 "]) {
        [self setAsEntry:@"Error"];
        self.isErrorState = YES;
        return;
    }
    @try {
        NSExpression *expression = [NSExpression expressionWithFormat:calculation];
        NSNumber *result = [expression expressionValueWithObject:nil context:nil];
        [self setAsEntry:[result stringValue]];
    }
    @catch (NSException *exception) {
        [self setAsEntry:@"Error"];
        self.isErrorState = YES;
    }
}

- (BOOL)expressionEndsInOperator {
    NSArray *operators = @[@"+", @"\u2212", @"\u00d7", @"\u00f7", @"^"];
    if ([operators containsObject:[self.expression lastObject]]) {
        return YES;
    }
    return NO;
}

- (NSString *)factorialOf:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    double factorial;
    if (xdouble != floor(xdouble)) { // is not an integer?
        self.isErrorState = YES;
        return @"Error";
    }
    else if (xdouble == 0.0 || xdouble == 1.0) {
        factorial = 1.0;
    }
    else if (xdouble < 0.0) {
        factorial = -1.0;
    }
    else {
        NSDecimalNumber *one = [NSDecimalNumber one];
        factorial = xdouble * [[self factorialOf:[x decimalNumberBySubtracting:one]] doubleValue];
    }
    return [NSString stringWithFormat:@"%g", factorial];
}

- (NSString *)logBase:(NSDecimalNumber *)base of:(NSDecimalNumber *)x {
    NSExpression *logExpression = [NSExpression expressionForFunction:@"log:" arguments:@[[NSExpression expressionForConstantValue:x]]];
    NSDecimalNumber *logOfX = (NSDecimalNumber *)[logExpression expressionValueWithObject:nil context:nil];
    logExpression = [NSExpression expressionForFunction:@"log:" arguments:@[[NSExpression expressionForConstantValue:base]]];
    NSDecimalNumber *logOfBase = (NSDecimalNumber *)[logExpression expressionValueWithObject:nil context:nil];
    logExpression = [NSExpression expressionWithFormat:@"%@ / %@", logOfX, logOfBase];
    NSDecimalNumber *result = [logExpression expressionValueWithObject:nil context:nil];
    return [result stringValue];
}

- (NSString *)sin:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    return [NSString stringWithFormat:@"%g", sin(xdouble)];
}

- (NSString *)cos:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    return [NSString stringWithFormat:@"%g", cos(xdouble)];
}

- (NSString *)tan:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    return [NSString stringWithFormat:@"%g", tan(xdouble)];
}

- (NSString *)asin:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    if (xdouble < -1.0 || xdouble > 1.0) {
        self.isErrorState = YES;
        return @"Error";
    }
    return [NSString stringWithFormat:@"%g", asin(xdouble)];
}

- (NSString *)acos:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    if (xdouble < -1.0 || xdouble > 1.0) {
        self.isErrorState = YES;
        return @"Error";
    }
    return [NSString stringWithFormat:@"%g", acos(xdouble)];
}

- (NSString *)atan:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    return [NSString stringWithFormat:@"%g", atan(xdouble)];
}

- (NSString *)sinh:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    double eToX = pow(M_E, xdouble);
    double eToNegX = pow(M_E, 0.0 - xdouble);
    double result = (eToX - eToNegX) / 2.0;
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)cosh:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    double eToX = pow(M_E, xdouble);
    double eToNegX = pow(M_E, 0.0 - xdouble);
    double result = (eToX + eToNegX) / 2.0;
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)tanh:(NSDecimalNumber *)x {
    double result = [[self sinh:x] doubleValue] / [[self cosh:x] doubleValue];
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)asinh:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    double squirt = sqrt((xdouble * xdouble) + 1.0);
    double result = log(xdouble + squirt);
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)acosh:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    if (xdouble < 1.0) {
        self.isErrorState = YES;
        return @"Error";
    }
    double squirt = sqrt((xdouble * xdouble) - 1.0);
    double result = log(xdouble + squirt);
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)atanh:(NSDecimalNumber *)x {
    double xdouble = [x doubleValue];
    if (xdouble <= -1.0 || xdouble >= 1.0) {
        self.isErrorState = YES;
        return @"Error";
    }
    double quotient = (1.0 + xdouble) / (1.0 - xdouble);
    double result = log(quotient) / 2.0;
    return [NSString stringWithFormat:@"%g", result];
}

- (NSString *)stringRadiansToDegrees:(NSString *)radians {
    if ([radians isEqualToString:@"Error"]) {
        return radians;
    }
    NSDecimalNumber *rad = [NSDecimalNumber decimalNumberWithString:radians];
    return [NSString stringWithFormat:@"%@", [self radiansToDegrees:rad]];
}

- (NSDecimalNumber *)radiansToDegrees:(NSDecimalNumber *)radians {
    double rad = [radians doubleValue];
    NSString *result = [NSString stringWithFormat:@"%g", (rad * (180.0 / M_PI))];
    return [NSDecimalNumber decimalNumberWithString:result];
}

- (NSDecimalNumber *)degreesToRadians:(NSDecimalNumber *)degrees {
    double deg = [degrees doubleValue];
    NSString *result = [NSString stringWithFormat:@"%g", (deg * (M_PI / 180.0))];
    return [NSDecimalNumber decimalNumberWithString:result];
}

- (void)updateClearButton {
    [self.pageOne updateClearButtonForEmptyEntry:self.isEntryEmpty emptyExpression:self.isExpressionEmpty emptyHistory:self.isHistoryEmpty];
    [self.pageTwo updateClearButtonForEmptyEntry:self.isEntryEmpty emptyExpression:self.isExpressionEmpty emptyHistory:self.isHistoryEmpty];
}

- (void)updateEnterButton {
    [self.pageOne updateEnterButton:(self.nestedParentheses != 0)];
}

@end
