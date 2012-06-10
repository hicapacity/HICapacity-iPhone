#import "AppDelegate.h"
#import "HTTPEngine.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  UIImageView *splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch"]];
  [self.window.rootViewController.view addSubview:splash];
  
  [UIView animateWithDuration:0.75 
                   animations:^{
                     splash.alpha = 0;
                   }
                   completion:^(BOOL finished) {
                     [splash removeFromSuperview];
                   }];
  
  // Navigation bar background
  UIImage *navbg = [[UIImage imageNamed:@"navbar"] 
                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
  // Set the background image for *all UINavigationBars
  [[UINavigationBar appearance] setBackgroundImage:navbg 
                                     forBarMetrics:UIBarMetricsDefault];
  
  [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
  // [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]]; 
  [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
  UIImage *tabIndicatorImage = [[UIImage imageNamed:@"selected"] 
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
  [[UITabBar appearance] setSelectionIndicatorImage:tabIndicatorImage];
  [[UIScrollView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]]];
  [[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise"]]];
  
  [[UIApplication sharedApplication] 
   setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
