//
//  WMKEditMainTableViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/4/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKEditMainTableViewController.h"
#import "WMKEditManager.h"
#import "WMKCategoryTableViewCell.h"

@interface WMKEditMainTableViewController ()

@end

@implementation WMKEditMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load data
    self.categories = [[WMKEditManager loadData] objectForKey:@"Categories"]; // get names of categories
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)lookForImageForCategory:(NSString *)category {
    NSString *imageName = [NSString stringWithString:category];
    
    // look in Documents sandbox first for any user-added image
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:imageName];
    UIImage *categoryImage = [UIImage imageWithContentsOfFile:path];
    
    // look in main bundle for default image if none exists in Documents sandbox
    if (!categoryImage) {
        categoryImage = [UIImage imageNamed:imageName];
    }
    
    return categoryImage;
}

- (BOOL)isUserImageForCategory:(NSString *)category {
    NSString *imageName = [NSString stringWithString:category];
    
    // look in Documents sandbox for any user-added image
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:imageName];
    UIImage *categoryImage = [UIImage imageWithContentsOfFile:path];
    
    if (categoryImage) {
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.categories count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.categories count]) {
        WMKCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.categories objectAtIndex:indexPath.row];
        cell.categoryImageView.image = [self lookForImageForCategory:[self.categories objectAtIndex:indexPath.row]];
        return cell;
    }
    else {
        return [tableView dequeueReusableCellWithIdentifier:@"NewCategoryCell" forIndexPath:indexPath];
    }
}

/*
 * this table view is always in edit mode, so rows can never be selected
 * instead, there is cell with a button that does the same thing
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.categories count]) { // New Category cell
        UIAlertController *newCategoryAlert = [UIAlertController alertControllerWithTitle:@"New Category" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [newCategoryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) { // create text field for name of new category
            textField.placeholder = @"Name";
            textField.clearButtonMode = UITextFieldViewModeAlways;
            textField.borderStyle = UITextBorderStyleNone;
            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        }];
        [newCategoryAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]]; // do nothing
        [newCategoryAlert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = newCategoryAlert.textFields.firstObject;
            BOOL nameTaken = NO;
            for (NSString *category in self.categories) { // check if name is already used
                if ([textField.text isEqualToString:category]) {
                    nameTaken = YES;
                    break;
                }
            }
            if (nameTaken) {
                UIAlertController *takenAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"That category already exists!" preferredStyle:UIAlertControllerStyleAlert];
                [takenAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:takenAlert animated:YES completion:nil];
            }
            else if ([textField.text length] == 0) { // name is blank?
                UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Name cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
                [blankAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:blankAlert animated:YES completion:nil];
            }
            else {
                [WMKEditManager addCategoryWithName:textField.text inCategory:-1];
                [self viewWillAppear:YES];
            }
        }]];
        [self presentViewController:newCategoryAlert animated:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
 */

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath {
    self.categoryImageIndex = indexPath.row;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    UIAlertController *pickerTypeAlert = [UIAlertController alertControllerWithTitle:@"Select an image for this category" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
    if ([self isUserImageForCategory:[self.categories objectAtIndex:indexPath.row]]) {
        [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"Remove image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UIAlertController *imageAlert = [UIAlertController alertControllerWithTitle:@"Remove image?" message:@"Are you sure you want to remove this image?" preferredStyle:UIAlertControllerStyleAlert];
            [imageAlert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [WMKEditManager deleteCategoryImageForCategory:[self.categories objectAtIndex:indexPath.row] inCategory:@""];
                [self.tableView reloadData];
            }]];
            [imageAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:imageAlert animated:YES completion:nil];
        }]];
    }
    [pickerTypeAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:pickerTypeAlert animated:YES completion:nil];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == [self.categories count]) { // Favorites or Search category or New Category cells
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
            if (indexPath.row < [self.categories count]) {
                [WMKEditManager deleteCategoryAtIndex:indexPath.row inCategory:-1];
                if ([self isUserImageForCategory:[self.categories objectAtIndex:indexPath.row]]) {
                    [WMKEditManager deleteCategoryImageForCategory:[self.categories objectAtIndex:indexPath.row] inCategory:@""];
                }
                [self.categories removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }]];
        [self presentViewController:deleteAlert animated:YES completion:nil];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [WMKEditManager moveCategoryFromIndex:fromIndexPath.row toIndex:toIndexPath.row inCategory:-1];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.row < [self.categories count]) { // moving a category cell?
        if (proposedDestinationIndexPath.row == 0 || proposedDestinationIndexPath.row == 1) { // prevent moving Favorites and Search category cells
            return [NSIndexPath indexPathForRow:2 inSection:0];
        }
        else if (proposedDestinationIndexPath.row >= [self.categories count]) { // prevent moving New Category cell
            return [NSIndexPath indexPathForRow:([self.categories count] - 1) inSection:0];
        }
    }
    return proposedDestinationIndexPath;
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [WMKEditManager saveCategoryImage:chosenImage forCategory:[self.categories objectAtIndex:self.categoryImageIndex] inCategory:@""];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

- (IBAction)createNewCategory:(UIButton *)sender {
    UIAlertController *newCategoryAlert = [UIAlertController alertControllerWithTitle:@"New Category" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [newCategoryAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) { // create text field for name of new category
        textField.placeholder = @"Name";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.borderStyle = UITextBorderStyleNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    }];
    [newCategoryAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]]; // do nothing
    [newCategoryAlert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = newCategoryAlert.textFields.firstObject;
        BOOL nameTaken = NO;
        for (NSString *category in self.categories) { // check if name is already used
            if ([textField.text isEqualToString:category]) {
                nameTaken = YES;
                break;
            }
        }
        if (nameTaken) {
            UIAlertController *takenAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"That category already exists!" preferredStyle:UIAlertControllerStyleAlert];
            [takenAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:takenAlert animated:YES completion:nil];
        }
        else if ([textField.text length] == 0) { // name is blank?
            UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Name cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
            [blankAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:blankAlert animated:YES completion:nil];
        }
        else {
            [WMKEditManager addCategoryWithName:textField.text inCategory:-1];
            [self viewWillAppear:YES];
        }
    }]];
    [self presentViewController:newCategoryAlert animated:YES completion:nil];
}

- (IBAction)finishedEditing:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
