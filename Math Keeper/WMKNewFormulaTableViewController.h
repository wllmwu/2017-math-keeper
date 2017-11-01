//
//  WMKNewFormulaTableViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iosMath/MTMathList.h>
#import <MathEditor/MTEditableMathLabel.h>

@interface WMKNewFormulaTableViewController : UITableViewController

@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic) NSInteger subcategoryIndex;
@property (nonatomic) NSUInteger formulaIndex;

@property (nonatomic) BOOL isEditingFormula;
@property (nonatomic, strong) NSString *editName;
@property (nonatomic, strong) MTMathList *editEquation;
@property (nonatomic, strong) NSString *editNote;

@property (nonatomic, weak) IBOutlet UITextField *nameInput;
@property (nonatomic, weak) IBOutlet MTEditableMathLabel *equationInput;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *equationInputHeight;
@property (nonatomic) CGFloat equationCellHeight;
@property (nonatomic, weak) IBOutlet UITextField *noteInput;

- (void)resizeEquationInput:(MTEditableMathLabel *)label;
- (IBAction)didCancel:(id)sender;
- (IBAction)didSave:(id)sender;

@end
