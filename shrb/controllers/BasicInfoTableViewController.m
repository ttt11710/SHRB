//
//  BasicInfoTableViewController.m
//  shrb
//
//  Created by PayBay on 15/6/16.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import "BasicInfoTableViewController.h"
#import "Const.h"

@interface BasicInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;

@end

@implementation BasicInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.userImageBtn.layer.cornerRadius = 10;
    self.userImageBtn.layer.masksToBounds = YES;
    
    self.tableView.backgroundColor = HexRGB(0xF1EFEF);
    
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
    return indexPath.row == 0?100:60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - imagePickerController delegate 发送图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
   // [self.tableView reloadData];
}

@end
