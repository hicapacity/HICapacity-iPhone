//
//  CalendarViewController.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "NSDate+TKCategory.h"
#import "HTTPEngine.h"
#import "Event.h"
#import "EventDetailsViewController.h"
#import "SVProgressHUD.h"

@interface CalendarViewController ()
- (void) showLoading;
- (void) dismissLoading:(BOOL)error;
@end

@implementation CalendarViewController

@synthesize dataArray, dataDictionary;

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [self setUseSundayFirst:YES];
  return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate month]];
  // Load HI Capacity logo
  UIImage *image = [UIImage imageNamed: @"logo"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  self.navigationItem.titleView = imageView;
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]];
}

- (void)viewDidAppear:(BOOL)animated {
  // Deselect any selected table row there may be
  [[super tableView] deselectRowAtIndexPath:[[super tableView] indexPathForSelectedRow] animated:animated];
  [super viewWillAppear:animated];
  
  // Check if operation is still running, if it is show the loading box again
  if (runningOp != nil && [runningOp isExecuting]) {
    [self showLoading];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  // Hide the loading box?
  [self dismissLoading:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
  if ([lastStartDate isSameDay:startDate] && [lastEndDate isSameDay:lastDate]) {
    // Do not query again. The query dates match. This happens if the table is manually reloaded.
    // The table will be manually reloaded after the async call to the Google Calendar API is returned.
    return dataArray;
  }
  
  // Dates don't match, need to perform a new asynchronous query
  [self showLoading];
  
  // Cancel any previous query
  if (runningOp != nil) {
    [runningOp cancel];
  }
  
  // keep track of the last start and end dates queried for
  lastStartDate = startDate;
  lastEndDate = lastDate;
  
  [dataArray removeAllObjects]; // clear the array, waiting for new data to return
  
  NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
  [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
  [headerFields setValue:@"application/json" forKey:@"Accept"];
  HTTPEngine *httpEngine = [[HTTPEngine alloc] initWithHostName:@"www.googleapis.com" customHeaderFields:headerFields];
  runningOp = [httpEngine eventsFrom:startDate to:lastDate onCompletion:^(NSMutableArray *returnedEvents) {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:startDate];
    
    NSDate *ds = [cal dateFromComponents:comp];
    
    NSMutableArray *datesArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *eventsDictionary = [[NSMutableDictionary alloc] init];
    
    // Init offset components to increment days in the loop by one each time
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    
    
    while (YES) {      
      // Is the date beyond the last date? If so, exit the loop.
      // NSOrderedDescending = the left value is greater than the right
      if ([ds compare:lastDate] == NSOrderedDescending) {
        break;
      }
      NSMutableArray *eventsFound = [self getEventsForDate:ds from:returnedEvents];
      
      if ([eventsFound count] > 0) {
        [eventsDictionary setObject:eventsFound forKey:ds];
        
        [datesArray addObject:[NSNumber numberWithBool:YES]];
      }
      else {
        // no events found
        [datesArray addObject:[NSNumber numberWithBool:NO]];    
      }
      
      // Increment day using offset components (ie, 1 day in this instance)
      ds = [cal dateByAddingComponents:offsetComponents toDate:ds options:0];
    }
    [self setDataArray:datesArray];
    [self setDataDictionary:eventsDictionary];
    [[self monthView] reload]; // reload the month view since new events were loaded
    
    [self dismissLoading:NO];
    runningOp = nil;
  }
                 onError:^(NSError *error) {
                   NSLog(@"%@", error);
                   [self dismissLoading:YES];
                   runningOp = nil;
                 }]; // end of completion block
	return dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
//	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
//	
//	NSLog(@"Date Selected: %@",myTimeZoneDay);
	
	[self.tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
  Event *event = [ar objectAtIndex:indexPath.row];
  cell.textLabel.text = [event summary];
	
  return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // trigger the segue programatically, the table is not in the storyboard because it is from the Tapku lib
  
  [self performSegueWithIdentifier:@"PushEventDetails" sender:self];
}

- (NSMutableArray *) getEventsForDate:(NSDate *)date from:(NSMutableArray *)queriedEvents {
  NSMutableArray *events = [[NSMutableArray alloc] init];
  
  [queriedEvents enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
    Event *e = [queriedEvents objectAtIndex:index];

    NSDate *startTime = [e startTime];
    if ([date isSameDay:startTime]) {
      [events addObject:e];
    }
   else if ([startTime compare:date] == NSOrderedDescending) {
     // events returned from Google Calendar are in ascending order
     // if the event time is greater than the date we are checking, we can break out of the enumeration
     *stop = YES;
   }
  }];
  
  return events;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"PushEventDetails"])
  {
    NSDate *selectedDate = [[self monthView] dateSelected];
    NSMutableArray *events = [dataDictionary objectForKey:selectedDate];
    NSInteger selectedIndex = [[[self tableView] indexPathForSelectedRow] row];
    
    EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
    [eventDetailsViewController setEvent:[events objectAtIndex:selectedIndex]];
  }
}

- (void)viewDidUnload {
  [super viewDidUnload];
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
