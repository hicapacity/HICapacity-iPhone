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
@synthesize scrollView;

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
  
  [[self scrollView] setContentSize:CGSizeMake(320, 515)];
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [self setScrollView:nil];
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
  if(self.navigationItem.rightBarButtonItem == nil)
    [self.navigationItem setRightBarButtonItem: closeButton animated:YES];

  [self.scrollView setContentOffset:CGPointZero animated:YES];
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
  [UIView commitAnimations];
  [self.navigationItem setRightBarButtonItem: nil animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidDisappear:(BOOL)animated
{
  [self shrinkMap];
  [super viewDidDisappear:NO];
}

- (IBAction)mapButtonClicked:(id)sender {
  // CID is for The Box Jelly, HICAP doesn't have its own CID
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps?cid=13799009640966807151"]];
}
@end
