//
//  WMKEditMainTableViewController.h
//  Math Keeper
//
//  Created by Bill Wu on 7/4/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMKEditMainTableViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *categories;
@property NSUInteger categoryImageIndex;

- (UIImage *)lookForImageForCategory:(NSString *)category;
- (BOOL)isUserImageForCategory:(NSString *)category;
- (IBAction)createNewCategory:(UIButton *)sender;
- (IBAction)finishedEditing:(id)sender;

@end
