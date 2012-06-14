//
//  AboutViewController.m
//  HI Capacity
//
//  Created by Julie Ann Sakuda on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  // Load HI Capacity logo
  UIImage *image = [UIImage imageNamed: @"logo"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
  self.navigationItem.titleView = imageView;
}

- (void)viewDidUnload
{
  [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
  // Lat/Lon for HICAP
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 21.29692165932583;
  zoomLocation.longitude= -157.85649240016937;
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200);
  MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
  [mapView setRegion:adjustedRegion animated:YES];
  
  Location *loc = [[Location alloc] initWithCoordinate:zoomLocation];
  [mapView addAnnotation:loc];
  
  UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc] 
                                    initWithTarget:self action:@selector(enlargeMap)];
  [mapView addGestureRecognizer:tapRec];
}

- (void)enlargeMap
{

  UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(shrinkMap)];          
  self.navigationItem.rightBarButtonItem = closeButton;
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.85];
  [self.mapView setFrame:(CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, mapView.frame.size.width, 370))];
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 21.29692165932583;
  zoomLocation.longitude= -157.85649240016937;
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
  MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
  [mapView setRegion:adjustedRegion];
  [UIView commitAnimations];
}

- (void)shrinkMap
{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.85];
  [self.mapView setFrame:(CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, mapView.frame.size.width, 101))];
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 21.29692165932583;
  zoomLocation.longitude= -157.85649240016937;
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200);
  MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
  [mapView setRegion:adjustedRegion];
  self.navigationItem.rightBarButtonItem = nil;
  [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)mapButtonClicked:(id)sender {
  // CID is for The Box Jelly, HICAP doesn't have its own CID
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps?cid=13799009640966807151"]];
}
@end
