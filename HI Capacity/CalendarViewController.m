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

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize dataArray, dataDictionary;

- (id) initWithCoder:(NSCoder *)aDecoder {
  return [super initWithSunday:YES];
}

- (void)viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate month]];
}

- (void)viewWillAppear:(BOOL)animated {
//  [[[self navigationController] navigationBar] setHidden:YES];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
  if ([lastStartDate isSameDay:startDate] && [lastEndDate isSameDay:lastDate]) {
    return dataArray;
  }
  
  // Dates don't match, need to perform a new asynchronous query
  
  // keep track of the last start and end dates queried for
  lastStartDate = startDate;
  lastEndDate = lastDate;
  
  [dataArray removeAllObjects]; // clear the array, waiting for new data to return
//  NSLog(@"CLEARING DATA ARRAY");
  
  NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
  [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
  [headerFields setValue:@"application/json" forKey:@"Accept"];
  HTTPEngine *httpEngine = [[HTTPEngine alloc] initWithHostName:@"www.googleapis.com" customHeaderFields:headerFields];
  [httpEngine eventsFrom:startDate to:lastDate onCompletion:^(NSMutableArray *returnedEvents) {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:startDate];
    
    NSDate *ds = [cal dateFromComponents:comp];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    // Init offset components to increment days in the loop by one each time
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    
    
    while (YES) {
      NSLog(@"!!! %@", ds);
      
      // Is the date beyond the last date? If so, exit the loop.
      // NSOrderedDescending = the left value is greater than the right
      if ([ds compare:lastDate] == NSOrderedDescending) {
        break;
      }
      NSMutableArray *eventsFound = [self getEventsForDate:ds from:returnedEvents];
      
      if ([eventsFound count] > 0) {
//        [[self dataArray] addObject:[NSNumber numberWithBool:YES]];
//        [[self dataDictionary] setObject:eventsFound forKey:currentDate];
        [tempDict setObject:eventsFound forKey:ds];
        
        [temp addObject:[NSNumber numberWithBool:YES]];
        //        NSLog(@"%@ - Events found: %d", currentDate, [eventsFound count]);
        //        NSLog(@"ADDING YES");
      }
      else {
        // no events found
        [temp addObject:[NSNumber numberWithBool:NO]];
//        [[self dataArray] addObject:[NSNumber numberWithBool:NO]];
        //        NSLog(@"ADDING NO");        
      }
      
      // Increment day using offset components (ie, 1 day in this instance)
      ds = [cal dateByAddingComponents:offsetComponents toDate:ds options:0];
    }
    [self setDataArray:temp];
    [self setDataDictionary:tempDict];
    [[self monthView] reload]; // reload the month, new events in
  }
                 onError:^(NSError *error) {
                   NSLog(@"%@", error);
                 }];
	return dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@",myTimeZoneDay);
	
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
  
	NSLog(@"%d", indexPath.row);
  
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
//  NSLog(@"%@", ar);
  Event *event = [ar objectAtIndex:indexPath.row];
  NSLog(@"%@", event);
//  NSLog(@"%@", [[self monthView] dateSelected]);
  
//	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
  cell.textLabel.text = [event summary];
	
  return cell;
	
}

- (NSMutableArray *) getEventsForDate:(NSDate *)date from:(NSMutableArray *)queriedEvents {
  NSMutableArray *events = [[NSMutableArray alloc] init];
  
  [queriedEvents enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
    Event *e = [[Event alloc] initWithDictionary:[queriedEvents objectAtIndex:index]];

    NSDate *startTime = [e startTime];
    NSLog(@"%@", [e summary]);
    if ([date isSameDay:startTime]) {
      [events addObject:e];
    }
  }];
  
  return events;
}

@end
