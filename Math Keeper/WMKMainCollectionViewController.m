//
//  WMKMainCollectionViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKMainCollectionViewController.h"
#import "WMKEditManager.h"
#import "WMKCategoryViewController.h"
#import "WMKCategoryCollectionViewCell.h"
#import "WMKSearchTableViewCell.h"
#import "WMKNewFormulaTableViewController.h"

@interface WMKMainCollectionViewController ()

@end

@implementation WMKMainCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load data
    self.categories = [[WMKEditManager loadData] objectForKey:@"Categories"]; // get names of categories
    [self.collectionView reloadData];
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
    
    // use blank image if neither of above exist
    if (!categoryImage) {
        categoryImage = [UIImage imageNamed:@"Blank"];
    }
    
    return categoryImage;
}

- (UIColor *)filterColorForIndex:(NSUInteger)categoryIndex {
    UIColor *filterColor;
    switch (categoryIndex % 12) {
        case 0:
        case 7:
            // blue 1: 44,154,217
            filterColor = [UIColor colorWithRed:0.17255 green:0.60392 blue:0.85098 alpha:1.0];
            break;
        case 3:
        case 8:
            // blue 2: 50,129,176
            filterColor = [UIColor colorWithRed:0.19608 green:0.50588 blue:0.69020 alpha:1.0];
            break;
        case 4:
        case 11:
            // blue 3: 89,174,222
            filterColor = [UIColor colorWithRed:0.34902 green:0.68235 blue:0.87059 alpha:1.0];
            break;
        default:
            // pale blue: 200,220,205
            filterColor = [UIColor colorWithRed:0.78431 green:0.86275 blue:0.90980 alpha:1.0];
            break;
    }
    return filterColor;
}

- (UIColor *)textColorForIndex:(NSUInteger)categoryIndex {
    UIColor *textColor;
    switch (categoryIndex % 12) {
        case 0:
        case 3:
        case 4:
        case 7:
        case 8:
        case 11:
            // very pale blue: 205,241,242
            textColor = [UIColor colorWithRed:0.90980 green:0.94510 blue:0.94902 alpha:1.0];
            break;
        default:
            // dark blue: 34,56,67
            textColor = [UIColor colorWithRed:0.13333 green:0.21961 blue:0.26275 alpha:1.0];
            break;
    }
    return textColor;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MainToCategory"]) {
        // get sender and destination
        WMKCategoryCollectionViewCell *senderCell = (WMKCategoryCollectionViewCell *)sender;
        WMKCategoryViewController *destination = (WMKCategoryViewController *)[segue destinationViewController];
        
        // pass name and index of category to destination
        destination.title = senderCell.nameLabel.text;
        destination.categoryIndex = senderCell.categoryIndex;
    }
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    if ([self.categories count] % 2 == 1) {
        // add an extra blank cell if there are an odd number of categories
        return [self.categories count] + 1;
    }
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.categories count]) { // category
        WMKCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
        cell.nameLabel.text = [self.categories objectAtIndex:indexPath.row];
        cell.nameLabel.textColor = [self textColorForIndex:indexPath.row];
        UIImage *categoryImage = [self lookForImageForCategory:[self.categories objectAtIndex:indexPath.row]];
        if (categoryImage) {
            cell.categoryImageView.image = categoryImage;
            cell.filterImageView.backgroundColor = [self filterColorForIndex:indexPath.row];
        }
        else {
            cell.categoryImageView.backgroundColor = [self filterColorForIndex:indexPath.row];
        }
        cell.categoryIndex = indexPath.row;
        
        return cell;
    }
    else { // empty cell
        WMKCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCell" forIndexPath:indexPath];
        cell.filterImageView.backgroundColor = [self filterColorForIndex:indexPath.row];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Collection view delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width / 2, collectionView.frame.size.width / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) { // Search cell
        [self performSegueWithIdentifier:@"MainToSearch" sender:self];
    }
    else if (indexPath.row < [self.categories count]) { // category cell
        [self performSegueWithIdentifier:@"MainToCategory" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
