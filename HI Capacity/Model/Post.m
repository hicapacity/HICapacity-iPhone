//
//  Post.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize title;
@synthesize date;
@synthesize content;

- (id) init {
  self = [super init];
  return self;
}

- (id) initWithDictionary:(NSDictionary *)json {
  self = [self init];
  
  title = [[json valueForKey:@"title"] description];
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
  [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
  [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
  date = [dateFormat dateFromString:[json objectForKey:@"date"]];  
  
  content = [[json valueForKey:@"content"] description];
  
  return self;
}

@end
