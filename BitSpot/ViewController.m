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

@synthesize viewingUSD;

- (void)viewDidLoad
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    currencies = [[NSMutableArray alloc] initWithCapacity:11];
    ad.currencies = currencies;
    //create all the currencies
    Currency *c = [Currency alloc];
    c.name = @"Bitcoin (USD)";
    c.price = @"Loading...";
    c.idNum = 0;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"mBTC (USD)";
    c.price = @"Loading...";
    c.idNum = 1;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"Bitcoin (EUR)";
    c.price = @"Loading...";
    c.idNum = 2;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"BTC Pizza Index";
    c.price = @"Loading...";
    c.idNum = 3;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"BTC Market Cap";
    c.price = @"Loading...";
    c.idNum = 4;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"Silver (oz)";
    c.price = @"Loading...";
    c.idNum = 5;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"Gold (oz)";
    c.price = @"Loading...";
    c.idNum = 6;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"Palladium (oz)";
    c.price = @"Loading...";
    c.idNum = 7;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    c = [Currency alloc];
    c.name = @"Platinum (oz)";
    c.price = @"Loading...";
    c.idNum = 8;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
//    c = [Currency alloc];
//    c.name = @"Oil";
//    c.price = @"Loading...";
//    c.idNum = 9;
//    c.hasBeenSet = NO;
//    [currencies addObject:c];
//    
    c = [Currency alloc];
    c.name = @"Gold:Silver Ratio";
    c.price = @"Loading...";
    c.idNum = 9;
    c.hasBeenSet = NO;
    [currencies addObject:c];
    
    curList = [[CurrencyTableViewController alloc] init];
    curList.view.layer.cornerRadius = 6;
    curList.par = self;
    
    [self.view addSubview:curList.view];
    
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
    details.text = @"Tap a value to refresh it.  Swipe to change to BTC.";
    viewingUSD = YES;
    
    
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    bannerView.hidden = NO;
    bannerView.delegate = self;
    bannerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bannerView];
    
    
    swipeRec = [[UISwipeGestureRecognizer alloc] init];
    swipeRec.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [curList.view addGestureRecognizer:swipeRec];
    
    [swipeRec addTarget:self action:@selector(userDidSwipe:)];
}

- (void) viewWillLayoutSubviews{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGSize sRect = [ad currentScreenSize];
    
    curList.view.frame = CGRectMake(10, 60, sRect.width - 20, sRect.height - 140);
    
    title.frame = CGRectMake(50, 5, sRect.width - 100, 30);
    details.frame = CGRectMake(10, 35, sRect.width - 20, 20);
    
    bannerView.frame = CGRectMake(0, sRect.height - 70, 320, 50);
    
}


- (void) viewDidAppear:(BOOL)animated{
    [self setAllCurrencies];
}

- (void) userDidSwipe:(UISwipeGestureRecognizer*)sender{
//    NSLog(@"swipe");
    if(viewingUSD){
        viewingUSD = NO;
        [self convertUSDToBTC];
        [curList reloadTableData];
        details.text = @"Tap a value to refresh it.  Swipe to change to USD.";
        
    }else{
        viewingUSD = YES;
        [self convertBTCToUSD];
        [curList reloadTableData];
        details.text = @"Tap a value to refresh it.  Swipe to change to BTC.";
        
    }
}

- (void) convertUSDToBTC{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!

    
    Currency *c = currencies[0];
    c.price = [NSString stringWithFormat:@"%g BTC", 1.0/c.priceFloat];
    c.name = @"US Dollar";
    
    c = currencies[1];
    c.price = [NSString stringWithFormat:@"%g mBTC", 1.0/c.priceFloat];
    c.name = @"US Dollar";
    
    c = currencies[2];
    c.price = [NSString stringWithFormat:@"%g BTC", 1.0/c.priceFloat];
    c.name = @"The Euro";
    
    c = currencies[3];
    c.price = [NSString stringWithFormat:@"%@ BTC", [formatter stringFromNumber:[NSNumber numberWithFloat:c.priceFloat/BTCValue]]];
    c.name = @"BTC Pizza Index";
    
    c = currencies[4];
    c.price = [NSString stringWithFormat:@"%@ BTC", [formatter stringFromNumber:[NSNumber numberWithFloat:c.priceFloat/BTCValue]]];
    c.name = @"Total in Circulation";
    
    c = currencies[5];
    c.price = [NSString stringWithFormat:@"%g BTC", c.priceFloat/BTCValue];
    c.name = @"Silver (oz)";
    
    c = currencies[6];
    c.price = [NSString stringWithFormat:@"%g BTC", c.priceFloat/BTCValue];
    c.name = @"Gold (oz)";
    
    c = currencies[7];
    c.price = [NSString stringWithFormat:@"%g BTC", c.priceFloat/BTCValue];
    c.name = @"Palladium (oz)";
    
    c = currencies[8];
    c.price = [NSString stringWithFormat:@"%g BTC", c.priceFloat/BTCValue];
    c.name = @"Platinum (oz)";
    
}

- (void) convertBTCToUSD{
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle]; // this line is important!
    
    for(Currency *c in currencies){
        if(c.idNum != 9 && c.idNum != 2 && c.hasBeenSet){
            c.price = [formatter stringFromNumber:[NSNumber numberWithFloat:c.priceFloat]];
        }else if(c.idNum == 2 && c.hasBeenSet){
            c.price = [NSString stringWithFormat:@"%.2f", c.priceFloat];
        }
    }
    
    Currency *c = currencies[0];
    c.name = @"Bitcoin (USD)";
    
    c = currencies[1];
    c.name = @"mBTC (USD)";
    
    c = currencies[2];
    c.name = @"Bitcoin (EUR)";
    
    c = currencies[4];
    c.name = @"BTC Market Cap";
    

}


- (void) setAllCurrencies{
    for(Currency *c in currencies){
        c.price = @"Loading...";
    }
    
    [self setCurrencyBTC];
    [self setCurrencyBTCEUR];
    [self setCurrencyMetals];
    [self setCurrencyMetalsPalladium];

    [curList reloadTableData];
}

- (void) setCurrencyBTC{
    //set BitcoinUSD
    NSURL *url = [NSURL URLWithString:@"http://data.mtgox.com/api/1/BTCUSD/ticker"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"returned: %@", [(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"]);
        float value = [[(NSDictionary*)[(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"value"] floatValue];
        
        BTCValue = value;
        
        //BTC
        Currency *c = currencies[0];
        c.price = [(NSDictionary*)[(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"display"];
        c.priceFloat  = value;
        c.hasBeenSet = YES;
        
        
        //mBTC
        c = currencies[1];
        c.price = [NSString stringWithFormat:@"$%01.2f", value/1000.0];
        c.priceFloat = value/1000;
        c.hasBeenSet = YES;
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle]; // this line is important!
        
        //Pizza index
        c = currencies[3];
        c.price = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:value*10000.0]]];
        c.priceFloat = value*10000.0;
        c.hasBeenSet = YES;
        
        [curList reloadTableData];
        
        NSURL *url2 = [NSURL URLWithString:@"http://blockchain.info/charts/total-bitcoins?format=json"];
        NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
        AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //        NSLog(@"returned: %@", JSON);
            
            NSArray *vals = [(NSDictionary*)JSON objectForKey:@"values"];
            
            
            int btcInCirc = [[[vals lastObject] objectForKey:@"y"] intValue];
            
            //Market cap
            Currency *c = currencies[4];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle]; // this line is important!
        
            
            c.price = [formatter stringFromNumber:[NSNumber numberWithInt: (int)(value*btcInCirc)]];
            c.priceFloat = (int)(value*btcInCirc);
            c.hasBeenSet = YES;
            
            //c.price = [NSString stringWithFormat:@"%.2f",[[(NSDictionary*)[(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"value"] floatValue] ];
            
            [curList reloadTableData];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error: %@", error);
        }];
        [operation2 start];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
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


- (void) setCurrencyBTCEUR{
    //set BitcoinEUR
    NSURL *url = [NSURL URLWithString:@"http://data.mtgox.com/api/1/BTCEUR/ticker"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"returned: %@", [(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"]);
        
        
        //Euros
        Currency *c = currencies[2];
        c.price = [NSString stringWithFormat:@"%.2f",[[(NSDictionary*)[(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"value"] floatValue] ];
        c.priceFloat = [[(NSDictionary*)[(NSDictionary*)[(NSDictionary*)JSON objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"value"] floatValue];
        c.hasBeenSet = YES;
        
        [curList reloadTableData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
    }];
    [operation start];
}

- (void) setCurrencyMetals{
    //set BitcoinUSD
    NSURL *url = [NSURL URLWithString:@"http://services.packetizer.com/spotprices/?f=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"returned: %@", JSON);
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle]; // this line is important!
        
        float goldPrice = [[JSON objectForKey:@"gold"] floatValue];
        float silverPrice = [[JSON objectForKey:@"silver"] floatValue];
        float platinumPrice = [[JSON objectForKey:@"platinum"] floatValue];
        
        //gold
        Currency *c = currencies[6];
        c.price = [formatter stringFromNumber:[NSNumber numberWithFloat:goldPrice]];
        c.priceFloat = goldPrice;
        c.hasBeenSet = YES;
        
        //silver
        c = currencies[5];
        c.price = [formatter stringFromNumber:[NSNumber numberWithFloat:silverPrice]]; 
        c.priceFloat = silverPrice;
        c.hasBeenSet = YES;
        
        //platinum
        c = currencies[8];
        c.price = [formatter stringFromNumber:[NSNumber numberWithFloat:platinumPrice]];
        c.priceFloat = platinumPrice;
        c.hasBeenSet = YES;
        
        //gold:silver ratio
        c = currencies[9];
        c.price = [NSString stringWithFormat:@"1 : %.2f", goldPrice/silverPrice];
        c.priceFloat = goldPrice/silverPrice;
        c.hasBeenSet = YES;
        
        [curList reloadTableData];
        
    }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        
    }];
    [operation start];
}

- (void) setCurrencyMetalsPalladium{
    //set BitcoinUSD
    NSURL *url = [NSURL URLWithString:@"http://guywithhands.com/~chris/metals.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"returned: %@", JSON);
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle]; // this line is important!
        
        float bid = [[[JSON objectForKey:@"Palladium"] objectForKey:@"bid"] floatValue];
        float ask = [[[JSON objectForKey:@"Palladium"] objectForKey:@"ask"] floatValue];
        
        float avg = (bid+ask)/2;
        
        //palladium
        Currency *c = currencies[7];
        c.price = [formatter stringFromNumber:[NSNumber numberWithFloat:avg]];
        c.priceFloat = avg;
        c.hasBeenSet = YES;

        
        [curList reloadTableData];
        
    }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error: %@", error);
        
    }];
    [operation start];
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
