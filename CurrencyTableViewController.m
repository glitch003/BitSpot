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
    }
    return self;
}
- (void) reloadTableData{
    [self.refreshControl performSelector:@selector(endRefreshing) withObject:Nil afterDelay:1];
    
    if(par.viewingUSD){
        [par convertBTCToUSD];
    }else{
        [par convertUSDToBTC];
    }
    
    
    [self.tableView reloadData];
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
    [refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Pull to refresh all" ]];
    self.refreshControl = refreshControl;
}

- (void) refreshAll{
    [par setAllCurrencies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell.textLabel.text = ((Currency*)[ad.currencies objectAtIndex:[indexPath row]]).name;
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
        price.text = ((Currency*)[ad.currencies objectAtIndex:[indexPath row]]).price;
        price.textAlignment = NSTextAlignmentRight;
        price.tag = 3;
        
        
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
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Currency *c = [ad.currencies objectAtIndex:[indexPath row]];
    c.price = @"Loading...";
    [self reloadTableData];
    
    if(c.idNum == 0 || c.idNum == 1 || c.idNum == 3 || c.idNum == 4){
        [par setCurrencyBTC];
    }else if(c.idNum == 2){
        [par setCurrencyBTCEUR];
    }else if(c.idNum == 5 || c.idNum == 6 || c.idNum == 8 || c.idNum == 9){
        [par setCurrencyMetals];
    }else if(c.idNum == 7){
        [par setCurrencyMetalsPalladium];
    }
    
    
   
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
