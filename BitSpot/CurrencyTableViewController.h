//
//  CurrencyTableViewController.h
//  BitSpot
//
//  Created by Christopher Cassano on 4/5/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface CurrencyTableViewController : UITableViewController{
    NSMutableArray *items;
    BOOL viewingUSD;
    NSDate *beginRefresh;
}

@property (nonatomic) ViewController *par;

- (void) refreshAll;
- (void) reloadTableData;


@end
