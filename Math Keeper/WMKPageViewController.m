//
//  WMKPageViewController.m
//  Math Keeper
//
//  Created by Bill Wu on 8/7/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKPageViewController.h"

@interface WMKPageViewController ()

@end

@implementation WMKPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    self.pages = [[NSArray alloc] initWithObjects:[self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"], [self.storyboard instantiateViewControllerWithIdentifier:@"CalculatorViewController"], nil];
    
    [self setViewControllers:@[[self.pages objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewController delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    if (currentIndex == 0) {
        return nil;
    }
    return [self.pages objectAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    if (currentIndex == 1) {
        return nil;
    }
    return [self.pages objectAtIndex:1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
