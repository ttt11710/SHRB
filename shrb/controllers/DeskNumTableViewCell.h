//
//  DeskNumTableViewCell.h
//  shrb
//
//  Created by PayBay on 15/6/29.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeskNumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *deskTextField;

+ (DeskNumTableViewCell *)shareDeskNumTableViewCell;
- (void)deskTextFieldResignFirstResponder:(NSSet *)touches;
- (void)deskTextFieldResignFirstResponder;

@end
