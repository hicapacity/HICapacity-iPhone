//
//  Event.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize summary;
@synthesize description;
@synthesize startTime;
@synthesize endTime;

- (id) init {
  self = [super init];
  return self;
}

- (id) initWithDictionary:(NSDictionary *)json {
  self = [self init];
  
  summary = [[json valueForKey:@"summary"] description];
  description = [[json valueForKey:@"description"] description];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
  
  id startObj = [json valueForKey:@"start"];
  startTime = [formatter dateFromString:[startObj valueForKey:@"dateTime"]];
  
  // there is not always an end time for an event, must check
  id endObj = [json valueForKey:@"end"];
  if (endObj != nil) {
    endTime = [formatter dateFromString:[endObj valueForKey:@"dateTime"]];    
  }
  
  return self;
}

@end
