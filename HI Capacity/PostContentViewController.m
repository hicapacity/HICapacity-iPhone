//
//  PostContentViewController.m
//  HI Capacity
//
//  Created by Anthony Kinsey on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostContentViewController.h"

@interface PostContentViewController ()

@end

@implementation PostContentViewController

@synthesize post;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize contentLabel;
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
    
    // Set the title of the view
    [self setTitle:[post objectForKey:@"title"]];
    
    // Set the post title label
    [titleLabel setText:[post objectForKey:@"title"]];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit]; // Shrink the frame to fit the text
    
    // Set spacing and get position of where to place next label
    int labelSpacing = 10;
    int newY = titleLabel.frame.size.height + titleLabel.frame.origin.y + labelSpacing;
    
    // Set the date label
    [dateLabel setText:[NSString stringWithFormat:@"(%@)", [post objectForKey:@"date"]]];
    
    // Adjust position of the date label
    CGRect frame = dateLabel.frame;
    frame.origin.y = newY;
    dateLabel.frame = frame;
    [dateLabel setNumberOfLines:0];
    [dateLabel sizeToFit];
    
    // Keep track of where to put the post content
    [contentLabel setText:[post objectForKey:@"content"]];
    newY = dateLabel.frame.size.height + dateLabel.frame.origin.y + labelSpacing;
    frame = contentLabel.frame;
    frame.origin.y = newY;
    contentLabel.frame = frame;
    [contentLabel setNumberOfLines:0];
    [contentLabel sizeToFit];
    
    // Calculate size of content and set contentSize for scrollview
    float sizeOfContent = 0;
    int i;
    for (i = 0; i < [scrollView.subviews count]; i++) {
        UIView *view =[scrollView.subviews objectAtIndex:i];
        sizeOfContent += view.frame.size.height;
    }
    
    // Set content size for scroll view
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, sizeOfContent);
    
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setContentLabel:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
