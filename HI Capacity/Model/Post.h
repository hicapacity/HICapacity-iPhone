//
//  Post.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *content;

- (id) initWithDictionary:(NSDictionary *)json;

@end
