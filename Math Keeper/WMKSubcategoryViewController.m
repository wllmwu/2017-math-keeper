//
//  WMKSubcategoryViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKSubcategoryViewController.h"
#import "WMKEditManager.h"
#import "WMKFormulaViewController.h"
#import "WMKFormulaTableViewCell.h"
#import "WMKNewFormulaTableViewController.h"

@interface WMKSubcategoryViewController ()

@end

@implementation WMKSubcategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // set up ad view
    self.adView.adUnitID = @"ca-app-pub-8611059613472162/3069379769";
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
    self.subcategoryFormulas = [[[self.dataDictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:self.categoryIndex] objectAtIndex:self.subcategoryIndex]; // get names of formulas
    if (!self.subcategoryImage.image || self.isDefaultSubcategoryImage) { // look for subcategory image if it hasn't already been found or if it's the default
        self.isDefaultSubcategoryImage = NO;
        [self lookForSubcategoryImage];
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
    /*if (self.subcategoryImage.image && !self.isDefaultSubcategoryImage) { // image exists and is not default?
        self.xButton.hidden = !editing;
    }*/
}

- (void)lookForSubcategoryImage {
    NSString *imageName = [NSString stringWithFormat:@"%@-%@.png", [[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:self.categoryIndex], self.title];
    
    // look in Documents sandbox first for any user-added image
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:imageName];
    UIImage *subcategoryImage = [UIImage imageWithContentsOfFile:path];
    
    // look in main bundle for default image if none exists in Documents sandbox
    if (!subcategoryImage) {
        subcategoryImage = [UIImage imageNamed:imageName];
        self.isDefaultSubcategoryImage = YES;
    }
    
    // configure image view and buttons appropriately
    if (subcategoryImage) {
        if (self.isDefaultSubcategoryImage) {
            self.subcategoryImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            self.subcategoryImage.contentMode = UIViewContentModeScaleAspectFill;
            self.changeImageButton.hidden = NO;
            self.imageTableSpace.constant = 30;
        }
        [self.imageButton setTitle:nil forState:UIControlStateNormal];
        self.subcategoryImage.hidden = NO;
        self.subcategoryImage.image = subcategoryImage;
        self.imageHeight.constant = self.subcategoryImage.frame.size.width / 3; // set 3:1 width:height ratio
    }
    else {
        [self.imageButton setTitle:@"+Image" forState:UIControlStateNormal];
        self.imageHeight.constant = 50;
        self.subcategoryImage.hidden = YES;
        self.changeImageButton.hidden = YES;
        self.imageTableSpace.constant = 0;
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subcategoryFormulas count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.subcategoryFormulas count]) { // formula
        WMKFormulaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormulaCell" forIndexPath:indexPath];
        NSDictionary *formula = [self.subcategoryFormulas objectAtIndex:indexPath.row]; // [name, equation, favorite]
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
        cell.formulaIndex = indexPath.row;
        cell.categoryIndex = self.categoryIndex;
        cell.subcategoryIndex = self.subcategoryIndex;
        cell.backgroundColor = [self backgroundColorForIndex:indexPath.row];
        return cell;
    }
    else { // new formula
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFormulaCell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.subcategoryFormulas count]) { // is a formula cell?
        return 100.0;
    }
    return 44.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.subcategoryFormulas count]) { // is New Formula cell?
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Delete Item" message:@"Are you sure you want to delete this item? This cannot be undone!" preferredStyle:UIAlertControllerStyleAlert];
        [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]]; // do nothing
        [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // Delete the row from the data source
            [WMKEditManager deleteFormulaAtIndex:indexPath.row inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex];
            [self.subcategoryFormulas removeObjectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [WMKEditManager moveFormulaFromIndex:fromIndexPath.row toIndex:toIndexPath.row inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex];
    [self viewWillAppear:NO];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row >= [self.subcategoryFormulas count]) { // prevent moving New Formula Cell
        return [NSIndexPath indexPathForRow:([self.subcategoryFormulas count] - 1) inSection:0];
    }
    return proposedDestinationIndexPath;
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [WMKEditManager saveCategoryImage:chosenImage forCategory:self.title inCategory:[[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:self.categoryIndex]];
    [self lookForSubcategoryImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SubcategoryToFormula"]) { // triggered by a formula cell?
        // get sender and destination
        WMKFormulaTableViewCell *senderCell = (WMKFormulaTableViewCell *)sender;
        WMKFormulaViewController *destination = (WMKFormulaViewController *)[segue destinationViewController];
        
        // pass index of formula to destination
        destination.categoryIndex = senderCell.categoryIndex;
        destination.subcategoryIndex = senderCell.subcategoryIndex;
        destination.formulaIndex = senderCell.formulaIndex;
        destination.isFavorite = senderCell.isFavorite;
    }
    else if ([segue.identifier isEqualToString:@"SubcategoryToNewFormula"]) { // triggered by New Formula cell?
        // get destination and pass index of subcategory
        UINavigationController *navigationController = (UINavigationController *)[segue destinationViewController];
        WMKNewFormulaTableViewController *destination = (WMKNewFormulaTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
        destination.categoryIndex = self.categoryIndex;
        destination.subcategoryIndex = self.subcategoryIndex;
        destination.formulaIndex = [self.subcategoryFormulas count];
    }
}

#pragma mark -

- (IBAction)didEdgePanLeft:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imageTapped:(UITapGestureRecognizer *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    UIAlertController *pickerTypeAlert = [UIAlertController alertControllerWithTitle:@"Select an image for this subcategory" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"From photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];
    [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"From camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = NO;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];
    if (self.subcategoryImage.image && !self.isDefaultSubcategoryImage) {
        [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"Remove image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:@"Remove image?" message:@"Are you sure you want to remove this image?" preferredStyle:UIAlertControllerStyleAlert];
            [imageAlert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [WMKEditManager deleteCategoryImageForCategory:self.title inCategory:[[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:self.categoryIndex]];
                self.subcategoryImage.image = nil;
                self.isDefaultSubcategoryImage = NO;
                [self lookForSubcategoryImage];
            }]];
            [imageAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:imageAlert animated:YES completion:nil];
        }]];
    }
    [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // present action sheet as popover on iPads
        [pickerTypeAlert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *presenter = [pickerTypeAlert popoverPresentationController];
        presenter.sourceView = self.imageButton;
        presenter.sourceRect = self.imageButton.bounds;
    }
    [self presentViewController:pickerTypeAlert animated:YES completion:nil];
}

@end
