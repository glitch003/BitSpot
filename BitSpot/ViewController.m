//
//  ViewController.m
//  BitSpot
//
//  Created by Christopher Cassano on 4/5/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Currency.h"
#import "AppDelegate.h"
#import "CurrencyTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize details;

- (void)viewDidLoad
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    currencies = [[NSMutableArray alloc] init];
    ad.currencies = currencies;

    
    
    curList = [[CurrencyTableViewController alloc] init];
    curList.view.layer.cornerRadius = 6;
    curList.par = self;
    
    [self.view addSubview:curList.view];
    
    [curList refreshAll];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    
    title = [[UILabel alloc] init];
    [self.view addSubview:title];
    
    [title setText:@"BitSpot"];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    title.textColor = [UIColor whiteColor];
    title.layer.cornerRadius = 6;
    
    details = [[UILabel alloc] init];
    [self.view addSubview:details];
    
    details.backgroundColor = [UIColor clearColor];
    details.textColor = [UIColor whiteColor];
    details.font = [UIFont systemFontOfSize:12];
    details.textAlignment = NSTextAlignmentCenter;
    details.text = @"Tap to change to BTC.";
    
    
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    bannerView.hidden = NO;
    bannerView.delegate = self;
    bannerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bannerView];
}

- (void) viewWillLayoutSubviews{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGSize sRect = [ad currentScreenSize];
    
    curList.view.frame = CGRectMake(10, 60, sRect.width - 20, sRect.height - 140);
    
    title.frame = CGRectMake(50, 5, sRect.width - 100, 30);
    details.frame = CGRectMake(10, 35, sRect.width - 20, 20);
    
    bannerView.frame = CGRectMake(0, sRect.height - 70, 320, 50);
    
}



- (void) downloadCurrencies{

    
    NSURL *url = [NSURL URLWithString:@"http://guywithhands.com/~chris/values.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [currencies removeAllObjects];
        
        for(NSDictionary *jsonCur in JSON){
            Currency *c = [Currency alloc];
            c.name = [jsonCur objectForKey:@"name"];
            c.price = [self formatValue:[jsonCur objectForKey:@"price"] withFormat:[jsonCur objectForKey:@"priceformat"]];
            c.btcname = [jsonCur objectForKey:@"btcname"];
            c.btcprice = [self formatValue:[jsonCur objectForKey:@"btcprice"] withFormat:[jsonCur objectForKey:@"btcpriceformat"]];
            c.btcsuffix = [jsonCur objectForKey:@"btcsuffix"];
            
            [currencies addObject:c];
        }
        
        [curList reloadTableData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        [curList.refreshControl endRefreshing];
        [curList.refreshControl performSelector:@selector(setAttributedTitle:) withObject:[[NSAttributedString alloc] initWithString:@"Pull to refresh" ] afterDelay:0.5];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: error.localizedDescription
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
    [operation start];
    
}


/*price format mapping:
 0 = currencyformatter
 1 = printf("%g");
 2 = decimal style formatter
 3 = printf("%.2f");
 4 = no formatting
 */
- (NSString*) formatValue: (NSString*) val withFormat:(NSString*)format{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if([format isEqualToString:@"0"]){
        //currency formatter
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        return [formatter stringFromNumber:[NSNumber numberWithFloat:[val floatValue]]];
    }else if([format isEqualToString:@"1"]){
        //printf("%g");
        return [NSString stringWithFormat:@"%g",[val floatValue]];
    }else if([format isEqualToString:@"2"]){
        //decimal style formatter
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [formatter stringFromNumber:[NSNumber numberWithFloat:[val floatValue]]];
    }else if([format isEqualToString:@"3"]){
        //printf("%.2f");
        return [NSString stringWithFormat:@"%.2f",[val floatValue]];
    }else if([format isEqualToString:@"4"]){
        //no formatting
        return val;
    }
    
    return val;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)bannerViewActionShouldBegin:
(ADBannerView *)banner
               willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
}


@end
