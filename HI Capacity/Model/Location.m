//
//  Location.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
  if ((self = [super init])) {
    _coordinate = coordinate;
  }
  return self;
}

@end
