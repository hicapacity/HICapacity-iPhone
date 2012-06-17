//
//  PostsViewController.m
//  HI Capacity
//
//  Created by Anthony Kinsey on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostsViewController.h"
#import "HTTPEngine.h"
#import "PostContentViewController.h"
#import "SVProgressHUD.h"
#import "Post.h"

@interface PostsViewController ()
- (void) showLoading;
- (void) dismissLoading:(BOOL)error;
@end

@implementation PostsViewController

@synthesize posts;
@synthesize postTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Load HI Capacity logo
  UIImage *image = [UIImage imageNamed: @"logo"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  self.navigationItem.titleView = imageView;
  
  // Start loading spinner
  [self showLoading];
  
  NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
  [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
  [headerFields setValue:@"application/json" forKey:@"Accept"];
  HTTPEngine *httpEngine = [[HTTPEngine alloc] initWithHostName:@"hicapacity.org" customHeaderFields:headerFields];
  [httpEngine posts:nil :^(NSMutableArray *returnedPosts) {
    posts = returnedPosts;
    [postTableView reloadData];
    [self dismissLoading:NO]; // Stop loading spinner
  }
            onError:^(NSError *error) {
              // please handle the error
              [self dismissLoading:YES]; // Stop loading spinner
            }];
  
}

- (void)viewDidUnload
{
  [self setPostTableView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  // Configure the cell...
  Post *post = [posts objectAtIndex:[indexPath row]];
  [[cell textLabel] setText:[post title]];
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
  [dateFormat setDateFormat:@"MMM d yyyy"];
  [[cell detailTextLabel] setText:[dateFormat stringFromDate:[post date]]];
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"PushPost"])
  {
    PostContentViewController *postContentViewController = [segue destinationViewController];
    [postContentViewController setPost:[posts objectAtIndex:[[postTableView indexPathForSelectedRow] row]]];
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
  // PostContentViewController *postContentViewController = [[PostContentViewController alloc] initWithNibName:nil bundle:nil];
  // postContentViewController setPost:<#(NSDictionary *)#>
}

- (void) showLoading {
  [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeNone];
  [[[self view] subviews]makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:FALSE]];
}

- (void) dismissLoading:(BOOL)error {
  if (error) {
    [SVProgressHUD dismissWithError:@"Unable to load data."];
  }
  else {
    [SVProgressHUD dismiss];
  }
  [[[self view] subviews]makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:TRUE]];
}

@end
