//
//  CurrencyTableViewController.m
//  BitSpot
//
//  Created by Christopher Cassano on 4/5/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import "CurrencyTableViewController.h"
#import "AppDelegate.h"
#import "Currency.h"
#import "ViewController.h"

@interface CurrencyTableViewController ()

@end

@implementation CurrencyTableViewController

@synthesize par;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        viewingUSD = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshAll) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl = refreshControl;
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..." ]];
    [refreshControl beginRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshAll{
    beginRefresh = [NSDate date];
    [par downloadCurrencies];
}

- (void) reloadTableData{
    double timePassed = [beginRefresh timeIntervalSinceNow] * -1000.0;
    
    NSLog(@"begin refresh: %f", timePassed);
    
    if(timePassed >= 1000){
        //immediately end the spinning wheel
        [self.refreshControl endRefreshing];
    }else{
        //wait a second to hide the spinning wheel
        
        //unless this is the first run
        if([self.refreshControl.attributedTitle.string isEqualToString:@"Loading..."]){
            [self.refreshControl endRefreshing];
        }else{
            [self.refreshControl performSelector:@selector(endRefreshing) withObject:Nil afterDelay:1];
        }
        
           
    }
    
    if([self.refreshControl.attributedTitle.string isEqualToString:@"Loading..."]){
        [self.refreshControl performSelector:@selector(setAttributedTitle:) withObject:[[NSAttributedString alloc] initWithString:@"Pull to refresh" ] afterDelay:0.5];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    // Return the number of rows in the section.
    return [ad.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    // Configure the cell...
    if([indexPath row] < [ad.currencies count]){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        
        UILabel *price;
        if([cell viewWithTag:3]){
            price = (UILabel*)[cell viewWithTag:3];
        }else{
            price  = [[UILabel alloc] init];
            [cell addSubview:price];
        }
        price.font = [UIFont systemFontOfSize:14];
        price.backgroundColor = [UIColor clearColor];
        price.frame = CGRectMake(0, 0, cell.bounds.size.width - 30, cell.bounds.size.height);
        price.textAlignment = NSTextAlignmentRight;
        price.tag = 3;
        
        Currency *c = ((Currency*)[ad.currencies objectAtIndex:[indexPath row]]);
        if(viewingUSD){
            cell.textLabel.text = c.name;
            price.text = c.price;
        }else{
            cell.textLabel.text = c.btcname;
            price.text = [NSString stringWithFormat:@"%@%@",c.btcprice, c.btcsuffix];
        }

    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(viewingUSD){
        par.details.text = @"Tap to change to USD.";
        viewingUSD = NO;
    }else{
        par.details.text = @"Tap to change to BTC.";
        viewingUSD = YES;
    }
    [self reloadTableData];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
