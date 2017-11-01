//
//  WMKMathKeyboard.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKMathKeyboard : UIView <UIInputViewAudioFeedback>

@property (nonatomic, weak) UIView<UIKeyInput> *textView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *numbers;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *operations;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *relations;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *letters;
@property (nonatomic) IBOutlet UIButton *logWithBaseKey;
@property BOOL isLatinAlphabet;

// the following buttons have alternate keys, which are toggled by pressing shift
@property (nonatomic, weak) IBOutlet UIButton *decimalButton;
@property (nonatomic, weak) IBOutlet UILabel *decimalAltLabel;
@property (nonatomic, weak) IBOutlet UIButton *timesButton;
@property (nonatomic, weak) IBOutlet UILabel *timesAltLabel;
@property (nonatomic, weak) IBOutlet UIButton *plusMinusButton;
@property (nonatomic, weak) IBOutlet UILabel *plusMinusAltLabel;

- (IBAction)keyPressed:(UIButton *)sender;
- (IBAction)fractionPressed:(UIButton *)sender;
- (IBAction)exponentPressed:(UIButton *)sender;
- (IBAction)squareRootPressed:(UIButton *)sender;
- (IBAction)rootWithDegreePressed:(UIButton *)sender;
- (IBAction)absoluteValuePressed:(UIButton *)sender;
- (IBAction)logWithBasePressed:(UIButton *)sender;
- (IBAction)subscriptPressed:(UIButton *)sender;
- (IBAction)greekLatinPressed:(UIButton *)sender;

- (void)shiftDown;
- (void)shiftUp;

@end
