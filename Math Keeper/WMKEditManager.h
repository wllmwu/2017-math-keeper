//
//  WMKEditManager.h
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMKEditManager : NSObject

+ (NSDictionary *)loadData;

+ (void)addCategoryWithName:(NSString *)name inCategory:(NSInteger)categoryIndex;
+ (void)moveCategoryFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inCategory:(NSInteger)categoryIndex;
+ (void)deleteCategoryAtIndex:(NSUInteger)index inCategory:(NSInteger)categoryIndex;

+ (void)saveCategoryImage:(UIImage *)image forCategory:(NSString *)name inCategory:(NSString *)categoryName;
+ (void)deleteCategoryImageForCategory:(NSString *)name inCategory:(NSString *)categoryName;

+ (void)addFormulaAtIndex:(NSUInteger)index withName:(NSString *)name equation:(NSString *)equation note:(NSString *)note inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex;
+ (void)moveFormulaFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex;
+ (void)editFormulaWithName:(NSString *)name equation:(NSString *)equation favorite:(BOOL)favorite note:(NSString *)note atIndex:(NSUInteger)formulaIndex inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex;
+ (void)deleteFormulaAtIndex:(NSUInteger)index inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex;
+ (void)toggleFavoriteForFormulaAtIndex:(NSUInteger)index inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex withValue:(BOOL)value;

@end
