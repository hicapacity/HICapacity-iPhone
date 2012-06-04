//
//  EventDetailsViewController.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailsViewController : UIViewController

@property (strong, nonatomic) Event *event;

@property (weak, nonatomic) IBOutlet UILabel *eventSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescText;
@end
