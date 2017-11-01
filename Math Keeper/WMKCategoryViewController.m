//
//  WMKCategoryViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/8/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKCategoryViewController.h"
#import "WMKEditManager.h"
#import "WMKSubcategoryViewController.h"
#import "WMKCategoryTableViewCell.h"
#import "WMKFormulaViewController.h"
#import "WMKFormulaTableViewCell.h"
#import "WMKNewFormulaTableViewController.h"

@interface WMKCategoryViewController ()

@end

@implementation WMKCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFavoritesCategory = [self.title isEqualToString:@"Favorites"];
    if (!self.isFavoritesCategory) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    // set up ad view
    self.adView.adUnitID = @"ca-app-pub-8611059613472162/9671760211";
    self.adView.rootViewController = self;
    self.adView.adSize = kGADAdSizeBanner;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load data
    self.dataDictionary = [WMKEditManager loadData];
    self.subcategories = [[self.dataDictionary objectForKey:@"Subcategories"] objectAtIndex:self.categoryIndex]; // get names of subcategories
    if (self.isFavoritesCategory) {
        self.categoryFormulas = [self.dataDictionary objectForKey:@"FavoriteFormulas"]; // get names of formulas
    }
    else {
        self.categoryFormulas = [[self.dataDictionary objectForKey:@"CategoryFormulas"] objectAtIndex:self.categoryIndex]; // get names of formulas
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (UIColor *)backgroundColorForIndex:(NSUInteger)categoryIndex {
    UIColor *backgroundColor;
    switch (categoryIndex % 2) {
        case 0:
            // light color
            backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            break;
        default:
            // dark color
            backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
            break;
    }
    return backgroundColor;
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (self.isFavoritesCategory) { // exclude new subcategory/formula cells
        return [self.categoryFormulas count];
    }
    return [self.subcategories count] + [self.categoryFormulas count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.subcategories count]) { // subcategory
        WMKCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubcategoryCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.subcategories objectAtIndex:indexPath.row];
        cell.categoryIndex = self.categoryIndex;
        cell.subcategoryIndex = indexPath.row;
        cell.backgroundColor = [self backgroundColorForIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row < [self.subcategories count] + [self.categoryFormulas count]) { // formula
        WMKFormulaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormulaCell" forIndexPath:indexPath];
        NSDictionary *formula = [self.categoryFormulas objectAtIndex:(indexPath.row - [self.subcategories count])]; // [name, equation, favorite]
        cell.nameLabel.text = [formula objectForKey:@"name"];
        cell.formulaLabel.latex = [formula objectForKey:@"equation"];
        if ([[formula objectForKey:@"favorite"] boolValue]) { // is in Favorites?
            cell.isFavorite = YES;
            [cell.favoriteButton setImage:[UIImage imageNamed:@"Favorite1"] forState:UIControlStateNormal];
        }
        else { // is not in Favorites
            cell.isFavorite = NO;
            [cell.favoriteButton setImage:[UIImage imageNamed:@"Favorite0"] forState:UIControlStateNormal];
        }
        if (self.isFavoritesCategory) {
            cell.formulaIndex = [(NSNumber *)[formula objectForKey:@"formulaIndex"] integerValue];
            cell.categoryIndex = [(NSNumber *)[formula objectForKey:@"categoryIndex"] integerValue];
            cell.subcategoryIndex = [(NSNumber *)[formula objectForKey:@"subcategoryIndex"] integerValue];
        }
        else {
            cell.formulaIndex = indexPath.row - [self.subcategories count];
            cell.categoryIndex = self.categoryIndex;
            cell.subcategoryIndex = -1;
        }
        cell.backgroundColor = [self backgroundColorForIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.row == [self.subcategories count] + [self.categoryFormulas count]) { // new subcategory
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewSubcategoryCell" forIndexPath:indexPath];
        return cell;
    }
    else { // new formula
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFormulaCell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.subcategories count]) { // is a subcategory cell?
        return 60.0;
    }
    else if (indexPath.row >= [self.subcategories count] && indexPath.row < [self.subcategories count] + [self.categoryFormulas count]) { // is a formula cell?
        return 100.0;
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.subcategories count] + [self.categoryFormulas count]) { // selected new subcategory cell?
        UIAlertController *newSubcategoryAlert = [UIAlertController alertControllerWithTitle:@"New Subcategory" message:[NSString stringWithFormat:@"Will be created in \"%@\"", self.title] preferredStyle:UIAlertControllerStyleAlert];
        [newSubcategoryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) { // create text field for name of new subcategory
            textField.placeholder = @"Name";
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.borderStyle = UITextBorderStyleNone;
            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        }];
        [newSubcategoryAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]]; // do nothing
        [newSubcategoryAlert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = newSubcategoryAlert.textFields.firstObject;
            BOOL nameTaken = NO;
            for (NSString *subcategory in self.subcategories) { // check if name is already used
                if ([textField.text isEqualToString:subcategory]) {
                    nameTaken = YES;
                    break;
                }
            }
            if (nameTaken) {
                UIAlertController *takenAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"That subcategory already exists!" preferredStyle:UIAlertControllerStyleAlert];
                [takenAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:takenAlert animated:YES completion:nil];
            }
            else if ([textField.text length] == 0) { // name is blank?
                UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Name cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
                [blankAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:blankAlert animated:YES completion:nil];
            }
            else {
                [WMKEditManager addCategoryWithName:textField.text inCategory:self.categoryIndex];
                [self viewWillAppear:YES];
            }
        }]];
        [self presentViewController:newSubcategoryAlert animated:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row >= [self.subcategories count] + [self.categoryFormulas count] || self.isFavoritesCategory) { // is New Subcategory or New Formula cell or is Favorites category?
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Delete Item" message:@"Are you sure you want to delete this item? This cannot be undone!" preferredStyle:UIAlertControllerStyleAlert];
        [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]]; // do nothing
        [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // Delete the row from the data source
            if (indexPath.row < [self.subcategories count]) { // deleted a subcategory?
                [WMKEditManager deleteCategoryAtIndex:indexPath.row inCategory:self.categoryIndex];
                [WMKEditManager deleteCategoryImageForCategory:[self.subcategories objectAtIndex:indexPath.row] inCategory:[[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:self.categoryIndex]];
                [self.subcategories removeObjectAtIndex:indexPath.row];
            }
            else if (indexPath.row < [self.subcategories count] + [self.categoryFormulas count]) { // deleted a formula?
                [WMKEditManager deleteFormulaAtIndex:(indexPath.row - [self.subcategories count]) inCategory:self.categoryIndex inSubcategory:-1];
                [self.categoryFormulas removeObjectAtIndex:(indexPath.row - [self.subcategories count])];
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self viewWillAppear:NO];
        }]];
        [self presentViewController:deleteAlert animated:YES completion:nil];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // disable swipe-to-delete while still allowing editing via edit button
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.row < [self.subcategories count]) { // moving a subcategory cell?
        [WMKEditManager moveCategoryFromIndex:fromIndexPath.row toIndex:toIndexPath.row inCategory:self.categoryIndex];
        [self viewWillAppear:NO];
    }
    else if (fromIndexPath.row < [self.subcategories count] + [self.categoryFormulas count]) { // moving a formula cell?
        [WMKEditManager moveFormulaFromIndex:(fromIndexPath.row - [self.subcategories count]) toIndex:(toIndexPath.row - [self.subcategories count]) inCategory:self.categoryIndex inSubcategory:-1];
        [self viewWillAppear:NO];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.row < [self.subcategories count]) { // moving a subcategory cell?
        if (proposedDestinationIndexPath.row >= [self.subcategories count]) { // prevent moving into formulas
            return [NSIndexPath indexPathForRow:([self.subcategories count] -1) inSection:0];
        }
    }
    else { // moving a formula cell
        if (proposedDestinationIndexPath.row < [self.subcategories count]) { // prevent moving into subcategories
            return [NSIndexPath indexPathForRow:[self.subcategories count] inSection:0];
        }
        else if (proposedDestinationIndexPath.row >= [self.subcategories count] + [self.categoryFormulas count]) { // prevent moving New Subcategory and New Formula cells
            return [NSIndexPath indexPathForRow:([self.subcategories count] + [self.categoryFormulas count] -1) inSection:0];
        }
    }
    return proposedDestinationIndexPath;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"CategoryToSubcategory"]) { // triggered by a subcategory cell?
        // get sender and destination
        WMKCategoryTableViewCell *senderCell = (WMKCategoryTableViewCell *)sender;
        WMKSubcategoryViewController *destination = [segue destinationViewController];
        
        // pass name and index of subcategory to destination
        destination.title = senderCell.nameLabel.text;
        destination.categoryIndex = senderCell.categoryIndex;
        destination.subcategoryIndex = senderCell.subcategoryIndex;
    }
    else if ([segue.identifier isEqualToString:@"CategoryToFormula"]) { // triggered by a formula cell?
        // get sender and destination
        WMKFormulaTableViewCell *senderCell = (WMKFormulaTableViewCell *)sender;
        WMKFormulaViewController *destination = (WMKFormulaViewController *)[segue destinationViewController];
        
        // pass index of formula to destination
        destination.formulaIndex = senderCell.formulaIndex;
        destination.categoryIndex = senderCell.categoryIndex;
        destination.subcategoryIndex = senderCell.subcategoryIndex;
        destination.isFavorite = senderCell.isFavorite;
    }
    else if ([segue.identifier isEqualToString:@"CategoryToNewFormula"]) { // triggered by New Formula cell?
        // get destination and pass index of category
        UINavigationController *navigationController = (UINavigationController *)[segue destinationViewController];
        WMKNewFormulaTableViewController *destination = (WMKNewFormulaTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
        destination.categoryIndex = self.categoryIndex;
        destination.subcategoryIndex = -1;
        destination.formulaIndex = [self.categoryFormulas count];
    }
}

#pragma mark -

- (IBAction)didEdgePanLeft:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
