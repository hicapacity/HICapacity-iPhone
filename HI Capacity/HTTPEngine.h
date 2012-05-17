#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface HTTPEngine : MKNetworkEngine

typedef void (^PostsResponseBlock)(NSMutableArray *);

-(MKNetworkOperation*) posts:
                onCompletion:(PostsResponseBlock) completionBlock
                     onError:(MKNKErrorBlock) errorBlock;

@end
