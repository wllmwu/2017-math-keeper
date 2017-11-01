//
//  WMKSettingsTableViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKSettingsTableViewController.h"
#import "WMKEditManager.h"

@interface WMKSettingsTableViewController ()

@end

@implementation WMKSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return 44;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self.tableView numberOfSections] - 1) { // is last section (Restore Defaults)?
        UIAlertController *restoreDefaultsAlert = [UIAlertController alertControllerWithTitle:@"Keep user-created items?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [restoreDefaultsAlert addAction:[UIAlertAction actionWithTitle:@"Yes, keep things I have created" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"DefaultFormulas" ofType:@"plist"];
            NSDictionary *defaultsDictionary = [[NSDictionary alloc] initWithContentsOfFile:defaultsPath];
            NSString *editedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            editedPath = [editedPath stringByAppendingPathComponent:@"EditedFormulas.plist"];
            NSDictionary *editedDictionary = [[NSDictionary alloc] initWithContentsOfFile:editedPath];
            
            NSMutableArray *defaultCategories = [defaultsDictionary objectForKey:@"Categories"];
            NSMutableArray *defaultCategoryFormulas = [defaultsDictionary objectForKey:@"CategoryFormulas"];
            NSMutableArray *defaultSubcategories = [defaultsDictionary objectForKey:@"Subcategories"];
            NSMutableArray *defaultSubcategoryFormulas = [defaultsDictionary objectForKey:@"SubcategoryFormulas"];
            NSMutableArray *editedCategories = [editedDictionary objectForKey:@"Categories"];
            NSMutableArray *editedCategoryFormulas = [editedDictionary objectForKey:@"CategoryFormulas"];
            NSMutableArray *editedSubcategories = [editedDictionary objectForKey:@"Subcategories"];
            NSMutableArray *editedSubcategoryFormulas = [editedDictionary objectForKey:@"SubcategoryFormulas"];
            for (int i = 2; i < [defaultCategories count]; i++) {
                // compare default and edited categories
                NSString *category = [defaultCategories objectAtIndex:i];
                if (![editedCategories containsObject:category]) {
                    [editedCategories addObject:category];
                    [editedCategoryFormulas addObject:[[NSMutableArray alloc] init]];
                    [editedSubcategories addObject:[[NSMutableArray alloc] init]];
                    [editedSubcategoryFormulas addObject:[[NSMutableArray alloc] init]];
                }
                NSInteger i2 = [editedCategories indexOfObject:category];
                
                // compare default and edited category formulas
                NSArray *defaultCategoryArray = [defaultCategoryFormulas objectAtIndex:i];
                if ([[editedCategoryFormulas objectAtIndex:i2] count] == 0) {
                    [editedCategoryFormulas replaceObjectAtIndex:i2 withObject:[[NSMutableArray alloc] init]];
                }
                NSMutableArray *editedCategoryFormulaArray = [editedCategoryFormulas objectAtIndex:i2];
                for (int j = 0; j < [defaultCategoryArray count]; j++) {
                    NSDictionary *categoryFormula = [defaultCategoryArray objectAtIndex:j];
                    if (![editedCategoryFormulaArray containsObject:categoryFormula]) {
                        [editedCategoryFormulaArray addObject:categoryFormula];
                    }
                }
                
                // compare default and edited subcategories
                NSArray *defaultSubcategoryArray = [defaultSubcategories objectAtIndex:i];
                if ([[editedSubcategories objectAtIndex:i2] count] == 0) {
                    [editedSubcategories replaceObjectAtIndex:i2 withObject:[[NSMutableArray alloc] init]];
                }
                NSMutableArray *editedSubcategoryArray = [editedSubcategories objectAtIndex:i2];
                if ([[editedSubcategoryFormulas objectAtIndex:i2] count] == 0) {
                    [editedSubcategoryFormulas replaceObjectAtIndex:i2 withObject:[[NSMutableArray alloc] init]];
                }
                for (int j = 0; j < [defaultSubcategoryArray count]; j++) {
                    NSString *subcategory = [defaultSubcategoryArray objectAtIndex:j];
                    if (![editedSubcategoryArray containsObject:subcategory]) {
                        [editedSubcategoryArray addObject:subcategory];
                        [[editedSubcategoryFormulas objectAtIndex:i2] addObject:[[NSMutableArray alloc] init]];
                    }
                    NSInteger j2 = [editedSubcategoryArray indexOfObject:subcategory];
                    
                    // compare default and edited subcategory formulas
                    NSArray *defaultSubcategoryFormulaArray = [[defaultSubcategoryFormulas objectAtIndex:i] objectAtIndex:j];
                    if ([[[editedSubcategoryFormulas objectAtIndex:i2] objectAtIndex:j2] count] == 0) {
                        [[editedSubcategoryFormulas objectAtIndex:i2] replaceObjectAtIndex:j2 withObject:[[NSMutableArray alloc] init]];
                    }
                    NSMutableArray *editedSubcategoryFormulaArray = [[editedSubcategoryFormulas objectAtIndex:i2] objectAtIndex:j2];
                    for (int k = 0; k < [defaultSubcategoryFormulaArray count]; k++) {
                        NSDictionary *subcategoryFormula = [defaultSubcategoryFormulaArray objectAtIndex:k];
                        if (![editedSubcategoryFormulaArray containsObject:subcategoryFormula]) {
                            [editedSubcategoryFormulaArray addObject:subcategoryFormula];
                        }
                    }
                }
            }
            
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
            if ([editedDictionary writeToFile:editedPath atomically:YES]) {
                successAlert.title = @"Defaults were restored";
            }
            else {
                successAlert.title = @"Defaults could not be restored";
            }
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }]];
        [restoreDefaultsAlert addAction:[UIAlertAction actionWithTitle:@"No, reset the app" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"edited"];
            [defaults synchronize];
            
            // remove all files from Documents sandbox
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSError *error = nil;
            NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSArray *files = [fileManager contentsOfDirectoryAtPath:docsDirectory error:nil];
            UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
            while ([files count] > 0) {
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:docsDirectory error:&error];
                if (error) {
                    successAlert.title = @"Defaults could not be restored";
                }
                else {
                    for (NSString *path in contents) {
                        NSString *fullPath = [docsDirectory stringByAppendingPathComponent:path];
                        [fileManager removeItemAtPath:fullPath error:&error];
                        files = [fileManager contentsOfDirectoryAtPath:docsDirectory error:nil];
                    }
                    successAlert.title = @"Defaults were restored";
                }
            }
            [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:successAlert animated:YES completion:nil];
        }]];
        [restoreDefaultsAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:restoreDefaultsAlert animated:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark -

- (IBAction)didFinish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
