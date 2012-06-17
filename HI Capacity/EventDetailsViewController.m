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
  // Load HI Capacity logo
  UIImage *image = [UIImage imageNamed: @"logo"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  self.navigationItem.titleView = imageView;
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]];
  
  // Remove padding from UITextView
  eventDescText.contentInset = UIEdgeInsetsMake(-11,-8,0,0);
  
  // Set and resize title label
  [[self eventSummaryLabel] setText:[event summary]];
  [eventSummaryLabel setNumberOfLines:0];
  [eventSummaryLabel sizeToFit]; // Shrink the frame to fit the text
  
  // Set spacing and get position of where to place next label
  int labelSpacing = 10;
  int newY = eventSummaryLabel.frame.size.height + eventSummaryLabel.frame.origin.y + labelSpacing;

  // Create the date/time text
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"EEEE, MMMM d yyyy h:mm a z"];
  [formatter setTimeZone:[NSTimeZone systemTimeZone]];
  [[self eventTimeLabel] setText:[formatter stringFromDate:[event startTime]]];
  
  // Adjust position of the date label
  CGRect frame = eventTimeLabel.frame;
  frame.origin.y = newY;
  eventTimeLabel.frame = frame;
  [eventTimeLabel setNumberOfLines:0];
  
  // Set Description text
  [[self eventDescText] setText:[event description]];
  
  // Adjust position of event description textview]
  newY = eventTimeLabel.frame.size.height + eventTimeLabel.frame.origin.y + labelSpacing;
  frame = eventDescText.frame;
  frame.origin.y = newY; 
  eventDescText.frame = frame;
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
