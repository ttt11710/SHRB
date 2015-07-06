//
//  CityListViewController.h
//  citylistdemo
//
//  Created by BW on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityListViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate >  {
    NSDictionary *cities;  
    NSMutableArray *keys;
    id __unsafe_unretained delegate1;
    UITableView *tableView;
    
    UISearchDisplayController  *_mysearchDisplayController;
    
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDictionary *cities;  
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, assign) id delegate1;

@end

@protocol CityListViewControllerProtocol
- (void) citySelectionUpdate:(NSString*)selectedCity;
- (NSString*) getDefaultCity;
@end

