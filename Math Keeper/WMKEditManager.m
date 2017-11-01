//
//  WMKEditManager.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKEditManager.h"

@implementation WMKEditManager

+ (NSDictionary *)loadData {
    // get filepath of either EditedFormulas.plist or DefaultFormulas.plist, depending on whether the app has been edited
    NSString *path;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"edited"]) { // "edited" key exists or is YES?
        // use EditedFormulas.plist in Documents sandbox
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
        //NSLog(@"edited");
    }
    else {
        // use DefaultFormulas.plist in app bundle
        path = [[NSBundle mainBundle] pathForResource:@"DefaultFormulas" ofType:@"plist"];
        [defaults setBool:YES forKey:@"edited"]; // use EditedFormulas.plist in the future
        [defaults synchronize];
        
        // copy data from DefaultFormulas.plist to EditedFormulas.plist
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *newPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        newPath = [newPath stringByAppendingPathComponent:@"EditedFormulas.plist"];
        [dictionary writeToFile:newPath atomically:YES];
        //NSLog(@"default");
    }
    
    // read data from the .plist file
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *categories = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"Categories"]];
    NSMutableArray *subcategories = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"Subcategories"]];
    NSMutableArray *categoryFormulas = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"CategoryFormulas"]];
    NSMutableArray *subcategoryFormulas = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"SubcategoryFormulas"]];
    
    // search through all formulas and aggregate those that are in Favorites
    NSMutableArray *favoriteFormulas = [[NSMutableArray alloc] init];
    for (int i = 0; i < [categoryFormulas count]; i++) {
        NSArray *category = (NSArray *)[categoryFormulas objectAtIndex:i];
        for (int j = 0; j < [category count]; j++) {
            NSDictionary *formula = (NSDictionary *)[category objectAtIndex:j];
            if ([[formula objectForKey:@"favorite"] boolValue]) {
                [formula setValue:[NSNumber numberWithInt:j] forKey:@"formulaIndex"];
                [formula setValue:[NSNumber numberWithInt:i] forKey:@"categoryIndex"];
                [formula setValue:[NSNumber numberWithInt:-1] forKey:@"subcategoryIndex"];
                [favoriteFormulas addObject:formula];
            }
        }
    }
    for (int i = 0; i < [subcategoryFormulas count]; i++) {
        NSArray *category = (NSArray *)[subcategoryFormulas objectAtIndex:i];
        for (int j = 0; j < [category count]; j++) {
            NSArray *subcategory = (NSArray *)[category objectAtIndex:j];
            for (int k = 0; k < [subcategory count]; k++) {
                NSDictionary *formula = (NSDictionary *)[subcategory objectAtIndex:k];
                if ([[formula objectForKey:@"favorite"] boolValue]) {
                    [formula setValue:[NSNumber numberWithInt:k] forKey:@"formulaIndex"];
                    [formula setValue:[NSNumber numberWithInt:i] forKey:@"categoryIndex"];
                    [formula setValue:[NSNumber numberWithInt:j] forKey:@"subcategoryIndex"];
                    [favoriteFormulas addObject:formula];
                }
            }
        }
    }
    favoriteFormulas = [[favoriteFormulas sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        // sort favorite formulas by names
        NSString *nameA = [(NSDictionary *)a objectForKey:@"name"];
        NSString *nameB = [(NSDictionary *)b objectForKey:@"name"];
        return [nameA compare:nameB];
    }] mutableCopy];
    
    // return as NSDictionary
    return @{
             @"Categories" : categories,
             @"Subcategories" : subcategories,
             @"CategoryFormulas" : categoryFormulas,
             @"SubcategoryFormulas" : subcategoryFormulas,
             @"FavoriteFormulas" : favoriteFormulas
             };
}

#pragma mark <Categories>

+ (void)addCategoryWithName:(NSString *)name inCategory:(NSInteger)categoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (categoryIndex > -1) { // adding subcategory?
        [[[dictionary objectForKey:@"Subcategories"] objectAtIndex:categoryIndex] addObject:name];
        [[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] addObject:@[]];
    }
    else { // adding category
        [[dictionary objectForKey:@"Categories"] addObject:name];
        [[dictionary objectForKey:@"Subcategories"] addObject:@[]];
        [[dictionary objectForKey:@"CategoryFormulas"] addObject:@[]];
        [[dictionary objectForKey:@"SubcategoryFormulas"] addObject:@[]];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)moveCategoryFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inCategory:(NSInteger)categoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (categoryIndex > -1) { // moving subcategory?
        NSString *subcategory = [[NSString alloc] initWithString:[[[dictionary objectForKey:@"Subcategories"] objectAtIndex:categoryIndex] objectAtIndex:fromIndex]];
        [[[dictionary objectForKey:@"Subcategories"] objectAtIndex:categoryIndex] removeObjectAtIndex:fromIndex];
        [[[dictionary objectForKey:@"Subcategories"] objectAtIndex:categoryIndex] insertObject:subcategory atIndex:toIndex];
        NSArray *subcategoryFormulas = [[NSArray alloc] initWithArray:[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:fromIndex]];
        [[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] removeObjectAtIndex:fromIndex];
        [[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] insertObject:subcategoryFormulas atIndex:toIndex];
    }
    else { // moving category
        NSString *category = [[NSString alloc] initWithString:[[dictionary objectForKey:@"Categories"] objectAtIndex:fromIndex]];
        [[dictionary objectForKey:@"Categories"] removeObjectAtIndex:fromIndex];
        [[dictionary objectForKey:@"Categories"] insertObject:category atIndex:toIndex];
        NSArray *categorySubcategories = [[NSArray alloc] initWithArray:[[dictionary objectForKey:@"Subcategories"] objectAtIndex:fromIndex]];
        [[dictionary objectForKey:@"Subcategories"] removeObjectAtIndex:fromIndex];
        [[dictionary objectForKey:@"Subcategories"] insertObject:categorySubcategories atIndex:toIndex];
        NSArray *categoryFormulas = [[NSArray alloc] initWithArray:[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:fromIndex]];
        [[dictionary objectForKey:@"CategoryFormulas"] removeObjectAtIndex:fromIndex];
        [[dictionary objectForKey:@"CategoryFormulas"] insertObject:categoryFormulas atIndex:toIndex];
        NSArray *categorySubcategoryFormulas = [[NSArray alloc] initWithArray:[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:fromIndex]];
        [[dictionary objectForKey:@"SubcategoryFormulas"] removeObjectAtIndex:fromIndex];
        [[dictionary objectForKey:@"SubcategoryFormulas"] insertObject:categorySubcategoryFormulas atIndex:toIndex];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)deleteCategoryAtIndex:(NSUInteger)index inCategory:(NSInteger)categoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (categoryIndex > -1) { // deleting subcategory?
        [[[dictionary objectForKey:@"Subcategories"] objectAtIndex:categoryIndex] removeObjectAtIndex:index];
        [[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] removeObjectAtIndex:index];
    }
    else { // deleting category
        for (NSString *subcategory in [[dictionary objectForKey:@"Subcategories"] objectAtIndex:index]) { // remove images of subcategories in this category
            [self deleteCategoryImageForCategory:subcategory inCategory:[[dictionary objectForKey:@"Categories"] objectAtIndex:index]];
        }
        [[dictionary objectForKey:@"Categories"] removeObjectAtIndex:index];
        [[dictionary objectForKey:@"Subcategories"] removeObjectAtIndex:index];
        [[dictionary objectForKey:@"CategoryFormulas"] removeObjectAtIndex:index];
        [[dictionary objectForKey:@"SubcategoryFormulas"] removeObjectAtIndex:index];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)saveCategoryImage:(UIImage *)image forCategory:(NSString *)name inCategory:(NSString *)categoryName {
    // build filepath for image in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", name];
    if (![categoryName isEqualToString:@""]) {
        fileName = [NSString stringWithFormat:@"%@-%@.png", categoryName, name];
    }
    path = [path stringByAppendingPathComponent:fileName];
    
    // write image data to filepath
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:path atomically:YES];
}

+ (void)deleteCategoryImageForCategory:(NSString *)name inCategory:(NSString *)categoryName {
    // build filepath for image in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", name];
    if (![categoryName isEqualToString:@""]) {
        fileName = [NSString stringWithFormat:@"%@-%@.png", categoryName, name];
    }
    path = [path stringByAppendingPathComponent:fileName];
    
    // delete image
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:path error:nil];
}

#pragma mark <Formulas>

+ (void)addFormulaAtIndex:(NSUInteger)index withName:(NSString *)name equation:(NSString *)equation note:(NSString *)note inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *formula = @{@"name" : name, @"equation" : equation, @"favorite" : @NO, @"note" : note};
    if (subcategoryIndex > -1) { // adding subcategory formula?
        [[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] insertObject:formula atIndex:index];
    }
    else { // adding category formula
        [[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] insertObject:formula atIndex:index];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)moveFormulaFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (subcategoryIndex > -1) { // moving subcategory formula?
        NSDictionary *formula = [[NSDictionary alloc] initWithDictionary:[[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] objectAtIndex:fromIndex]];
        [[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] removeObjectAtIndex:fromIndex];
        [[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] insertObject:formula atIndex:toIndex];
    }
    else { // moving category formula
        NSDictionary *formula = [[NSDictionary alloc] initWithDictionary:[[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:fromIndex]];
        [[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] removeObjectAtIndex:fromIndex];
        [[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] insertObject:formula atIndex:toIndex];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)editFormulaWithName:(NSString *)name equation:(NSString *)equation favorite:(BOOL)favorite note:(NSString *)note atIndex:(NSUInteger)formulaIndex inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *formula;
    if (subcategoryIndex > -1) { // editing subcategory formula?
        formula = [[NSMutableDictionary alloc] initWithDictionary:[[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] objectAtIndex:formulaIndex]];
    }
    else { // editing category formula
        formula = [[NSMutableDictionary alloc] initWithDictionary:[[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:formulaIndex]];
    }
    [formula setObject:name forKey:@"name"];
    [formula setObject:equation forKey:@"equation"];
    [formula setObject:[NSNumber numberWithBool:favorite] forKey:@"favorite"];
    [formula setObject:note forKey:@"note"];
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)deleteFormulaAtIndex:(NSUInteger)index inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (subcategoryIndex > -1) { // deleting subcategory formula?
        [[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] removeObjectAtIndex:index];
    }
    else { // deleting category formula
        [[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] removeObjectAtIndex:index];
    }
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

+ (void)toggleFavoriteForFormulaAtIndex:(NSUInteger)index inCategory:(NSUInteger)categoryIndex inSubcategory:(NSInteger)subcategoryIndex withValue:(BOOL)value {
    // get filepath of EditedFormulas.plist in Documents sandbox
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"EditedFormulas.plist"];
    
    // create and modify NSMutableDictionary from contents of file
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *formula;
    if (subcategoryIndex > -1) { // toggling subcategory formula?
        formula = [[[[dictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:subcategoryIndex] objectAtIndex:index];
    }
    else { // toggling category formula
        formula = [[[dictionary objectForKey:@"CategoryFormulas"] objectAtIndex:categoryIndex] objectAtIndex:index];
    }
    [formula setObject:[NSNumber numberWithBool:value] forKey:@"favorite"];
    
    // overwrite EditedFormulas.plist with new dictionary
    [dictionary writeToFile:path atomically:YES];
}

@end
