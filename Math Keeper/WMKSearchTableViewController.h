//
//  WMKSearchTableViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/4/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKSearchTableViewController : UITableViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *categoryFormulaResults;
@property (nonatomic, strong) NSMutableArray *subcategoryFormulaResults;

- (IBAction)didEdgePanLeft:(id)sender;

@end
