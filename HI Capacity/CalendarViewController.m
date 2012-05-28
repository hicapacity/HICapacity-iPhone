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


- (void)viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate month]];
}

- (void)viewWillAppear:(BOOL)animated {
//  [[[self navigationController] navigationBar] setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
  //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
  //[dateFormatter setDateFormat:@"dd.MM.yy"]; 
  //NSDate *d = [dateFormatter dateFromString:@"02.05.11"]; 
  //[dateFormatter release];
  //[self.monthView selectDate:d];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
  [dataArray removeAllObjects]; // clear the array, waiting for new data to return
  
  NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
  [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
  [headerFields setValue:@"application/json" forKey:@"Accept"];
  HTTPEngine *httpEngine = [[HTTPEngine alloc] initWithHostName:@"www.googleapis.com" customHeaderFields:headerFields];
  [httpEngine eventsFrom:startDate to:lastDate onCompletion:^(NSMutableArray *returnedEvents) {
    // reload table data
    [returnedEvents enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
      Event *e = [[Event alloc] initWithDictionary:[returnedEvents objectAtIndex:index]];
      [dataArray addObject:e];
    }];
    [[self tableView] reloadData]; // new events are in, reload table
  }
                 onError:^(NSError *error) {
                   NSLog(@"%@", error);
                 }];
//	[self generateRandomDataForStartDate:startDate endDate:lastDate];
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
  
	
  
	NSArray *ar = [dataDictionary objectForKey:[self.monthView dateSelected]];
	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
	
  return cell;
	
}


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES){
		
		int r = arc4random();
		if(r % 3==1){
			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil] forKey:d];
			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
			
		}else if(r%4==1){
			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",nil] forKey:d];
			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
			
		}else
			[self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}

@end
