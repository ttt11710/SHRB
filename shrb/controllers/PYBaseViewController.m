//
//  PYBaseViewController.m
//  shrb
//
//  Created by PayBay on 15/8/3.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import "PYBaseViewController.h"

@interface PYBaseViewController ()

@end

@implementation PYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer=[AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
