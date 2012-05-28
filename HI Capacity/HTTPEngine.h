#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface HTTPEngine : MKNetworkEngine

typedef void (^PostsResponseBlock)(NSMutableArray *);
typedef void (^EventsResponseBlock)(NSMutableArray *);

-(MKNetworkOperation*) posts:
                onCompletion:(PostsResponseBlock) completionBlock
                     onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) eventsFrom:(NSDate *) startDate
                           to:(NSDate *) endDate
                           onCompletion:(EventsResponseBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;
@end
