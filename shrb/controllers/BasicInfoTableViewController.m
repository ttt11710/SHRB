//
//  BasicInfoTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BasicInfoTableViewController.h"
#import "SVProgressShow.h"
#import "Const.h"
#import "TBUser.h"

@interface BasicInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;


@property (nonatomic,strong)AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation BasicInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
    [self creatReq];
    [self loadData];
    [self initTableView];
}

- (void)initView
{
    self.userImageBtn.layer.cornerRadius = 10;
    self.userImageBtn.layer.masksToBounds = YES;
}

- (void)creatReq
{
    self.requestOperationManager=[AFHTTPRequestOperationManager manager];
    
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *serializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    self.requestOperationManager.responseSerializer=serializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:10*60];
    self.requestOperationManager.requestSerializer=requestSerializer;
}

- (void)loadData
{
    NSString *url2=[baseUrl stringByAppendingString:@"/user/v1.0/info?"];
    [self.requestOperationManager POST:url2 parameters:@{@"userId":[TBUser currentUser].userId,@"token":[TBUser currentUser].token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"user info operation = %@ JSON: %@", operation,responseObject);
        self.phoneLabel.text = responseObject[@"user"][@"phone"];
        self.passwordTextField.text = responseObject[@"user"][@"password"];
        self.passwordTextField.secureTextEntry = YES;
        self.emailLabel.text = responseObject[@"user"][@"email"];
        if (self.emailLabel.text.length == 0) {
            self.emailLabel.text = @"未填写";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:++++%@",error.localizedDescription);
    }];
}

- (void)initTableView
{
    self.tableView.backgroundColor = shrbTableViewColor;
    //删除多余线
    self.tableView.tableFooterView =[[UIView alloc]init];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0? 130:44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 ) {
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ResetPasswordView"];
//        [viewController setModalPresentationStyle:UIModalPresentationFullScreen];
//        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - 改头像
- (IBAction)userImageBtnPressed:(id)sender {
    UIImagePickerControllerSourceType sourceType ;
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.barTintColor = [UIColor blackColor];
    [imagePicker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 改变状态栏颜色
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [SVProgressShow showSuccessWithStatus:@"头像修改成功！"];
   // [self.tableView reloadData];
}

@end
