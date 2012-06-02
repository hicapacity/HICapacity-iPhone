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
  NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  [formatter setLocale:enUSPOSIXLocale];
  [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  
  id startObj = [json valueForKey:@"start"];
  id startTimeString = [startObj valueForKey:@"dateTime"];
  
  // must strip out colon in the time zone portion of the string or it will fail to parse!
  NSRange lastColon = [startTimeString rangeOfString:@":" options:NSBackwardsSearch];
  NSString *modifiedStartTimeString = [startTimeString stringByReplacingCharactersInRange:lastColon withString:@""];
  
  startTime = [formatter dateFromString:modifiedStartTimeString];
  
  // there is not always an end time for an event, must check
  id endObj = [json valueForKey:@"end"];
  if (endObj != nil) {
    id endTimeString = [endObj valueForKey:@"dateTime"];
    // must strip out colon in the time zone portion of the string or it will fail to parse!
    NSRange lastColon = [startTimeString rangeOfString:@":" options:NSBackwardsSearch];
    NSString *modifiedEndTimeString = [endTimeString stringByReplacingCharactersInRange:lastColon withString:@""];
    endTime = [formatter dateFromString:modifiedEndTimeString];    
  }
  
  return self;
}

@end
