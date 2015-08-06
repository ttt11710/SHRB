//
//  HotListSelectViewController.h
//  shrb
//
//  Created by PayBay on 15/8/4.
//  Copyright © 2015年 PayBay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotListSelectViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate >
{
    NSMutableArray *storeNamesArr;
    NSMutableArray *storePlistNameArr;
    UITableView *tableView;
    id __unsafe_unretained delegate1;
    UISearchDisplayController  *_mysearchDisplayController;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *storeNamesArr;
@property (nonatomic, retain) NSMutableArray *storePlistNameArr;

@end



