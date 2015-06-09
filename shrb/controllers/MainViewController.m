//
//  MainViewController.m
//  shrb
//
//  Created by PayBay on 15/6/9.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cardViewBtn:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"cardView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)meViewBtn:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"meView"];
    [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
