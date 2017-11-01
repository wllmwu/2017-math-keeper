//
//  WMKFormulaViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKFormulaViewController.h"
#import "WMKEditManager.h"
#import "WMKNewFormulaTableViewController.h"
#import <iosMath/MTFontManager.h>
#import <iosMath/MTMathListBuilder.h>

@interface WMKFormulaViewController ()

@end

@implementation WMKFormulaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set up MTMathUILabel properties for displaying formula
    self.formulaLabel = [[MTMathUILabel alloc] init];
    self.formulaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.formulaLabel.textAlignment = kMTTextAlignmentCenter;
    self.formulaLabel.font = [[MTFontManager fontManager] termesFontWithSize:30];
    self.formulaLabel.contentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.view addSubview:self.formulaLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.formulaLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel]-32-[formulaLabel]-32-[noteLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"nameLabel" : self.nameLabel, @"formulaLabel" : self.formulaLabel, @"noteLabel" : self.noteLabel}]];
    
    // set up ad view
    self.adView.adUnitID = @"ca-app-pub-8611059613472162/6897901996";
    self.adView.rootViewController = self;
    self.adView.adSize = kGADAdSizeLargeBanner;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adView loadRequest:request];
    
    // set up share button
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(shareFormula:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load and display formula data
    NSDictionary *dataDictionary = [WMKEditManager loadData];
    NSString *category = [[dataDictionary objectForKey:@"Categories"] objectAtIndex:self.categoryIndex];
    self.categoryLabel.numberOfLines = 0;
    if (self.subcategoryIndex == -1) { // not in a subcategory?
        self.categoryLabel.text = [NSString stringWithFormat:@"%@ >", category];
    }
    else {
        NSString *subcategory = [[[dataDictionary objectForKey:@"Subcategories"] objectAtIndex:self.categoryIndex] objectAtIndex:self.subcategoryIndex];
        self.categoryLabel.text = [NSString stringWithFormat:@"%@ > %@ >", category, subcategory];
    }
    [self.categoryLabel sizeToFit];
    NSDictionary *formula;
    if (self.subcategoryIndex > -1) { // subcategory formula?
        formula = [[[[dataDictionary objectForKey:@"SubcategoryFormulas"] objectAtIndex:self.categoryIndex] objectAtIndex:self.subcategoryIndex] objectAtIndex:self.formulaIndex];
    }
    else { // category formula
        formula = [[[dataDictionary objectForKey:@"CategoryFormulas"] objectAtIndex:self.categoryIndex] objectAtIndex:self.formulaIndex];
    }
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.text = [formula objectForKey:@"name"];
    [self.nameLabel sizeToFit];
    self.formulaLabel.latex = [formula objectForKey:@"equation"];
    if ([[formula objectForKey:@"note"] isEqualToString:@""]) { // note is blank?
        self.formulaNote = nil;
        self.noteLabel.hidden = YES;
    }
    else { // note exists
        self.formulaNote = [formula objectForKey:@"note"];
        self.noteLabel.hidden = NO;
        self.noteLabel.numberOfLines = 0;
        self.noteLabel.text = [NSString stringWithFormat:@"Note:\n\t%@", self.formulaNote];
        [self.noteLabel sizeToFit];
    }
    if (self.isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite1"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite0"] forState:UIControlStateNormal];
    }
    
    CGFloat formulaFontSize = 30;
    [self.formulaLabel sizeToFit];
    while (self.formulaLabel.frame.size.width >= self.view.frame.size.width) { // reduce font size if too long
        formulaFontSize -= 4;
        self.formulaLabel.font = [[MTFontManager fontManager] termesFontWithSize:formulaFontSize];
        [self.formulaLabel sizeToFit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FormulaToNewFormula"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        WMKNewFormulaTableViewController *destination = (WMKNewFormulaTableViewController *)[[navigationController viewControllers] firstObject];
        destination.categoryIndex = self.categoryIndex;
        destination.subcategoryIndex = self.subcategoryIndex;
        destination.formulaIndex = self.formulaIndex;
        destination.editName = self.nameLabel.text;
        destination.editEquation = self.formulaLabel.mathList;
        destination.editNote = self.formulaNote;
        destination.isEditingFormula = YES;
    }
}

- (IBAction)favoriteToggled:(UIButton *)sender {
    if (self.isFavorite) { // removing from Favorites?
        self.isFavorite = NO;
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite0"] forState:UIControlStateNormal];
    }
    else { // adding to Favorites
        self.isFavorite = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"Favorite1"] forState:UIControlStateNormal];
    }
    [WMKEditManager toggleFavoriteForFormulaAtIndex:self.formulaIndex inCategory:self.categoryIndex inSubcategory:self.subcategoryIndex withValue:self.isFavorite];
}

- (void)shareFormula:(UIBarButtonItem *)sender {
    UIAlertController *shareSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [shareSheet addAction:[UIAlertAction actionWithTitle:@"Edit formula" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"FormulaToNewFormula" sender:nil];
    }]];
    [shareSheet addAction:[UIAlertAction actionWithTitle:@"Save to camera roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIGraphicsBeginImageContextWithOptions(self.formulaLabel.bounds.size, NO, 0);
        [self.formulaLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *originalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // draw image a second time, because image context flips it along the y-axis
        CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, originalImage.CGImage);
        UIImage *flippedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(flippedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    [shareSheet addAction:[UIAlertAction actionWithTitle:@"Copy to clipboard as LaTeX" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *latex = [NSString stringWithString:[MTMathListBuilder mathListToString:self.formulaLabel.mathList]];
        [[UIPasteboard generalPasteboard] setString:latex];
        
        // confirm success
        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Copied to clipboard" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:successAlert animated:YES completion:nil];
    }]];
    [shareSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:shareSheet animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (error) {
        successAlert.title = @"Could not save image";
    }
    else {
        successAlert.title = @"Image saved";
    }
    [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:successAlert animated:YES completion:nil];
}

- (IBAction)didEdgePanLeft:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
