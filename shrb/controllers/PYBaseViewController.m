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

    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
//    [requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    //self.requestOperationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json;charset=UTF-8", @"text/json", @"text/javascript", @"text/plain", @"text/html;charset=utf-8", nil];
    
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
