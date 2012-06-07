//
//  EventDetailsViewController.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

@synthesize event;
@synthesize eventSummaryLabel;
@synthesize eventTimeLabel;
@synthesize eventDescText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  // Set the title of the view
//  [self setTitle:[event summary]];
  [[self eventSummaryLabel] setText:[event summary]];
  [[self eventDescText] setText:[event description]];

  // Create the date/time text
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"EEEE, MMMM d yyyy h:mm z"];
  [formatter setTimeZone:[NSTimeZone systemTimeZone]];
  [[self eventTimeLabel] setText:[formatter stringFromDate:[event startTime]]];
}

- (void)viewDidUnload
{
  [self setEventSummaryLabel:nil];
  [self setEventDescText:nil];
  [self setEventTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
