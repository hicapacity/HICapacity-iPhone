//
//  PostContentViewController.h
//  HI Capacity
//
//  Created by Anthony Kinsey on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostContentViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *post;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIWebView *contentLabel;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
