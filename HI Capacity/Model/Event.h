//
//  Event.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

- (id) initWithDictionary:(NSDictionary *)json;

@end
