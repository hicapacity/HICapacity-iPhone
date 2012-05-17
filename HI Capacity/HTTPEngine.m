#import "HTTPEngine.h"
@implementation HTTPEngine

-(MKNetworkOperation*) posts:
                onCompletion:(PostsResponseBlock) completionBlock
                     onError:(MKNKErrorBlock) errorBlock {
  MKNetworkOperation *op = [self operationWithPath:@"posts.json"
                                            params:nil 
                                        httpMethod:@"GET"];
  [op onCompletion:^(MKNetworkOperation *completedOperation) {
    NSDictionary *responseDictionary = [completedOperation responseJSON];
    NSMutableArray *posts = [responseDictionary objectForKey:@"posts"];
    
    if([completedOperation isCachedResponse]) {
      NSLog(@"Data from cache %@", responseDictionary);
    }
    else {
      NSLog(@"Data from server %@", responseDictionary);
    }
    completionBlock(posts);
  }
           onError:^(NSError* error) {
             errorBlock(error);
           }];
  [self enqueueOperation:op];
  return op;
}

@end
