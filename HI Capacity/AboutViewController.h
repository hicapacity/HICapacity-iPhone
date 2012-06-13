//
//  AboutViewController.h
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)mapButtonClicked:(id)sender;

@end
