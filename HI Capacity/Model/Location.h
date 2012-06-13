//
//  Location.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject<MKAnnotation> {
  CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
  
@end
