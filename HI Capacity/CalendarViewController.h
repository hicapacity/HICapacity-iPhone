//
//  CalendarViewController.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthTableViewController.h"

@interface CalendarViewController : TKCalendarMonthTableViewController {
  NSDate *lastStartDate;
  NSDate *lastEndDate;
  MKNetworkOperation *runningOp;
}

@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;

@end
