//
//  PostsViewController.h
//  HI Capacity
//
//  Created by Anthony Kinsey on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsViewController : UITableViewController<UITableViewDelegate> {
  MKNetworkOperation *runningOp;
}

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *postTableView;

@end
