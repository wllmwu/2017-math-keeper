//
//  WMKNewFormulaTableViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKNewFormulaTableViewController.h"
#import "WMKEditManager.h"
#import "WMKMathKeyboardRootView.h"
#import <iosMath/MTMathList.h>
#import <iosMath/MTMathListBuilder.h>
//#import <MathEditor/MTMathKeyboardRootView.h>

@interface WMKNewFormulaTableViewController () <MTEditableMathLabelDelegate>

@end

@implementation WMKNewFormulaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.equationInput.delegate = self;
    self.equationInput.fontSize = 20;
    self.equationInput.keyboard = [WMKMathKeyboardRootView sharedInstance];
    self.equationCellHeight = 44.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isEditingFormula) {
        self.title = @"Edit Formula";
        self.nameInput.text = self.editName;
        self.equationInput.mathList = self.editEquation;
        [self resizeEquationInput:self.equationInput];
        self.noteInput.text = self.editNote;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        NSDictionary *data = [WMKEditManager loadData];
        if (self.subcategoryIndex >= 0) { // creating formula in a subcategory?
            NSString *category = [[data objectForKey:@"Categories"] objectAtIndex:self.categoryIndex];
            NSString *subcategory = [[[data objectForKey:@"Subcategories"] objectAtIndex:self.categoryIndex] objectAtIndex:self.subcategoryIndex];
            return [NSString stringWithFormat:@"Will be saved in \"%@ > %@\"", category, subcategory];
        }
        else { // creating formula in a category
            NSString *category = [[data objectForKey:@"Categories"] objectAtIndex:self.categoryIndex];
            return [NSString stringWithFormat:@"Will be saved in \"%@\"", category];
        }
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 44.0;
    }
    return self.equationCellHeight;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - MTEditableMathLabelDelegate

- (void)textModified:(MTEditableMathLabel *)label {
    CGSize mathSize = label.mathDisplaySize;
    
    // change height of the label and cell as needed
    CGFloat minHeight = 64;
    if (mathSize.height > self.equationInputHeight.constant - 4) {
        [label layoutIfNeeded]; // increase height
        [UIView animateWithDuration:0.5 animations:^{ // animate
            self.equationInputHeight.constant = mathSize.height + 10;
            [label layoutIfNeeded];
        }];
        self.equationCellHeight = self.equationInputHeight.constant + 23;
        [self.tableView reloadData];
        [self.equationInput becomeFirstResponder];
    }
    else if (mathSize.height < self.equationInputHeight.constant - 4) {
        CGFloat newHeight = MAX(mathSize.height + 10, minHeight);
        if (newHeight < self.equationInputHeight.constant) {
            [label layoutIfNeeded]; // decrease height
            [UIView animateWithDuration:0.5 animations:^{ // animate
                self.equationInputHeight.constant = newHeight;
                [label layoutIfNeeded];
            }];
            self.equationCellHeight = newHeight;
            [self.tableView reloadData];
            [self.equationInput becomeFirstResponder];
        }
    }
    
    // change font size of the label as needed
    if (mathSize.width > label.frame.size.width - 10) {
        label.fontSize *= 0.9; // decrease font size
    }
    else if (mathSize.width < label.frame.size.width - 4) {
        CGFloat fontSize = MIN(label.fontSize * 1.1, 20);
        if (fontSize > label.fontSize) {
            label.fontSize = fontSize; // increase font size
        }
    }
}

#pragma mark -

- (void)resizeEquationInput:(MTEditableMathLabel *)label {
    CGSize mathSize = label.mathDisplaySize;
    
    // change height of the label and cell as needed
    CGFloat minHeight = 64;
    if (mathSize.height > self.equationInputHeight.constant - 4) {
        [label layoutIfNeeded]; // increase height
        [UIView animateWithDuration:0.5 animations:^{ // animate
            self.equationInputHeight.constant = mathSize.height + 10;
            [label layoutIfNeeded];
        }];
        self.equationCellHeight = self.equationInputHeight.constant + 23;
        [self.tableView reloadData];
    }
    else if (mathSize.height < self.equationInputHeight.constant - 4) {
        CGFloat newHeight = MAX(mathSize.height + 10, minHeight);
        if (newHeight < self.equationInputHeight.constant) {
            [label layoutIfNeeded]; // decrease height
            [UIView animateWithDuration:0.5 animations:^{ // animate
                self.equationInputHeight.constant = newHeight;
                [label layoutIfNeeded];
            }];
            self.equationCellHeight = newHeight;
            [self.tableView reloadData];
        }
    }
    
    // change font size of the label as needed
    if (mathSize.width > label.frame.size.width - 10) {
        label.fontSize *= 0.9; // decrease font size
    }
    else if (mathSize.width < label.frame.size.width - 4) {
        CGFloat fontSize = MIN(label.fontSize * 1.1, 20);
        if (fontSize > label.fontSize) {
            label.fontSize = fontSize; // increase font size
        }
    }
}

- (IBAction)didCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didSave:(id)sender {
    NSString *mathString = [MTMathListBuilder mathListToString:self.equationInput.mathList];
    if ([self.nameInput.text length] > 0 && [self.equationInput.mathList.stringValue length] > 0) { // fields are not blank?
        if (self.isEditingFormula) {
            [WMKEditManager deleteFormulaAtIndex:self.formulaIndex inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex];
        }
        [WMKEditManager addFormulaAtIndex:self.formulaIndex withName:self.nameInput.text equation:mathString note:self.noteInput.text inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Name and equation cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
        [blankAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:blankAlert animated:YES completion:nil];
    }
}

@end
