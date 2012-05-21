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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZZ"]; 
    NSDate *newDate = [dateFormat dateFromString:[post objectForKey:@"date"]];  
    [dateFormat setDateFormat:@"EEEE, d MMM yyyy h:mm"];
    [dateLabel setText:[NSString stringWithFormat:@"(%@)", [dateFormat stringFromDate:newDate]]];
    
    // Adjust position of the date label
    CGRect frame = dateLabel.frame;
    frame.origin.y = newY;
    dateLabel.frame = frame;
    [dateLabel setNumberOfLines:0];
    [dateLabel sizeToFit];
    
    // Set settings on the UIWebView
    [contentLabel setOpaque:FALSE];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    
    // Set the content of the UIWebView and set it's y position
    [contentLabel loadHTMLString:[post objectForKey:@"content"] baseURL:nil];
    newY = dateLabel.frame.size.height + dateLabel.frame.origin.y + labelSpacing;
    frame = contentLabel.frame;
    frame.origin.y = newY; 
    contentLabel.frame = frame;
    
    //Disable bounce scroll on UIWebView
    for(UIView *tmpView in ((UIWebView *)contentLabel).subviews){
        if([tmpView isKindOfClass:[UIScrollView class] ]){
            ((UIScrollView*)tmpView).scrollEnabled = NO;
            ((UIScrollView*)tmpView).bounces = NO;
            break;
        }
    }
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //This will resize the content of the webview
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setContentLabel:nil];
    [self setScrollView:nil];
    [self setContentLabel:nil];
    [self setContentLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
