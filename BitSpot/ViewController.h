//
//  ViewController.h
//  BitSpot
//
//  Created by Christopher Cassano on 4/5/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class CurrencyTableViewController;

@interface ViewController : UIViewController<ADBannerViewDelegate>{
    NSMutableArray *currencies;
    CurrencyTableViewController *curList;
    UILabel *title;
    ADBannerView *bannerView;
}
 @property (nonatomic) UILabel *details;

- (void) downloadCurrencies;

@end
