//
//  WMKSearchTableViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/4/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKSearchTableViewController.h"
#import "WMKEditManager.h"
#import "WMKFormulaViewController.h"
#import "WMKSearchTableViewCell.h"

@interface WMKSearchTableViewController ()

@end

@implementation WMKSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dataDictionary = [WMKEditManager loadData];
    [self updateFilteredContentForSearch:@""];
    
    // set up search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.categoryFormulaResults count] + [self.subcategoryFormulaResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.categoryFormulaResults count]) { // category formula?
        WMKSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
        NSDictionary *formula = [self.categoryFormulaResults objectAtIndex:indexPath.row];
        cell.nameLabel.text = [formula objectForKey:@"name"];
        cell.formulaLabel.latex = [formula objectForKey:@"equation"];
        cell.isFavorite = [[formula objectForKey:@"favorite"] boolValue];
        NSArray *array = [self.dataDictionary objectForKey:@"CategoryFormulas"];
        for (int i = 0; i < [array count]; i++) {
            NSArray *categoryArray = [array objectAtIndex:i];
            for (int j = 0; j < [categoryArray count]; j++) {
                if ([formula isEqualToDictionary:[categoryArray objectAtIndex:j]]) {
                    cell.categoryIndex = i;
                    cell.formulaIndex = j;
                    break;
                }
            }
        }
        cell.subcategoryIndex = -1;
        [cell setupCategory]; // set up category label
        return cell;
    }
    else { // subcategory formula
        WMKSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
        NSDictionary *formula = [self.subcategoryFormulaResults objectAtIndex:(indexPath.row - [self.categoryFormulaResults count])];
        cell.nameLabel.text = [formula objectForKey:@"name"];
        cell.formulaLabel.latex = [formula objectForKey:@"equation"];
        cell.isFavorite = [[formula objectForKey:@"favorite"] boolValue];
        NSArray *array = [self.dataDictionary objectForKey:@"SubcategoryFormulas"];
        for (int i = 0; i < [array count]; i++) {
            NSArray *categoryArray = [array objectAtIndex:i];
            for (int j = 0; j < [categoryArray count]; j++) {
                NSArray *subcategoryArray = [categoryArray objectAtIndex:j];
                for (int k = 0; k < [subcategoryArray count]; k++) {
                    if ([formula isEqualToDictionary:[subcategoryArray objectAtIndex:k]]) {
                        cell.categoryIndex = i;
                        cell.subcategoryIndex = j;
                        cell.formulaIndex = k;
                        break;
                    }
                }
            }
        }
        [cell setupCategory]; // set up category label
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

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

#pragma mark - Search controller delegate and search results delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar.text lowercaseString];
    [self updateFilteredContentForSearch:searchString];
    [self.tableView reloadData];
}

- (void)updateFilteredContentForSearch:(NSString *)searchString {
    NSMutableArray *categoryFormulaResults = [[NSMutableArray alloc] init];
    NSMutableArray *subcategoryFormulaResults = [[NSMutableArray alloc] init];
    
    // search through category formulas
    NSArray *categoryFormulas = [self.dataDictionary objectForKey:@"CategoryFormulas"];
    for (int i = 0; i < [categoryFormulas count]; i++) {
        NSArray *categoryArray = [categoryFormulas objectAtIndex:i];
        for (int j = 0; j < [categoryArray count]; j++) {
            NSString *category = [[[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:i] lowercaseString];
            NSDictionary *formula = [categoryArray objectAtIndex:j];
            NSString *name = [(NSString *)[formula objectForKey:@"name"] lowercaseString];
            if ([searchString isEqualToString:@""] || [category containsString:searchString] || [name containsString:searchString]) {
                [categoryFormulaResults addObject:formula];
            }
        }
    }
    self.categoryFormulaResults = categoryFormulaResults;
    
    // search through subcategory formulas
    NSArray *subcategoryFormulas = [self.dataDictionary objectForKey:@"SubcategoryFormulas"];
    for (int i = 0; i < [subcategoryFormulas count]; i++) {
        NSArray *categoryArray = [subcategoryFormulas objectAtIndex:i];
        for (int j = 0; j < [categoryArray count]; j++) {
            NSArray *subcategoryArray = [categoryArray objectAtIndex:j];
            for (int k = 0; k < [subcategoryArray count]; k++) {
                NSString *category = [[[self.dataDictionary objectForKey:@"Categories"] objectAtIndex:i] lowercaseString];
                NSString *subcategory = [[[[self.dataDictionary objectForKey:@"Subcategories"] objectAtIndex:i] objectAtIndex:j] lowercaseString];
                NSDictionary *formula = [subcategoryArray objectAtIndex:k];
                NSString *name = [(NSString *)[formula objectForKey:@"name"] lowercaseString];
                if ([searchString isEqualToString:@""] || [category containsString:searchString] || [subcategory containsString:searchString] || [name containsString:searchString]) {
                    [subcategoryFormulaResults addObject:formula];
                }
            }
        }
    }
    self.subcategoryFormulaResults = subcategoryFormulaResults;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WMKSearchTableViewCell *senderCell = (WMKSearchTableViewCell *)sender;
    WMKFormulaViewController *destination = (WMKFormulaViewController *)[segue destinationViewController];
    
    // pass index of formula to destination
    destination.categoryIndex = senderCell.categoryIndex;
    destination.subcategoryIndex = senderCell.subcategoryIndex;
    destination.formulaIndex = senderCell.formulaIndex;
    destination.isFavorite = senderCell.isFavorite;
}

- (IBAction)didEdgePanLeft:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
