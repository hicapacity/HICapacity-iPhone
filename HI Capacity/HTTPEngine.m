#import "HTTPEngine.h"
#import "Event.h"
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
    
//    if([completedOperation isCachedResponse]) {
//      NSLog(@"Data from cache %@", responseDictionary);
//    }
//    else {
//      NSLog(@"Data from server %@", responseDictionary);
//    }
    completionBlock(posts);
  }
           onError:^(NSError* error) {
             errorBlock(error);
           }];
  [self enqueueOperation:op];
  return op;
}

-(MKNetworkOperation*) eventsFrom:(NSDate *)startDate 
                               to:(NSDate *)endDate 
                     onCompletion:(EventsResponseBlock)completionBlock 
                          onError:(MKNKErrorBlock)errorBlock {
  NSMutableDictionary *paramsBody = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @"startTime", @"orderBy", @"true", @"singleEvents", @"AIzaSyDR5Hb48TfsF-jfYy1UWgyd_ocSjSBW1B8", @"key", nil];
  [paramsBody setObject:@"description,items(description,end,htmlLink,start,summary),kind,summary,timeZone,updated" forKey:@"fields"];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
  
  [paramsBody setObject:[formatter stringFromDate:startDate] forKey:@"timeMin"];
  [paramsBody setObject:[formatter stringFromDate:endDate] forKey:@"timeMax"];
  
  MKNetworkOperation *op = [self operationWithPath:@"calendar/v3/calendars/hicapacity.org_vgo8qpscrk4hif3veoka112434%40group.calendar.google.com/events"
                                            params:paramsBody 
                                        httpMethod:@"GET" 
                                               ssl:YES];
  [op onCompletion:^(MKNetworkOperation *completedOperation) {
    NSDictionary *responseDictionary = [completedOperation responseJSON];
    NSMutableArray *jsonEvents = [responseDictionary objectForKey:@"items"];
    
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:[jsonEvents count]];

    [jsonEvents enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
      Event *e = [[Event alloc] initWithDictionary:[jsonEvents objectAtIndex:index]];
      [events addObject:e];
    }];
    
    if([completedOperation isCachedResponse]) {
//      NSLog(@"Data from cache %@", responseDictionary);
    }
    else {
//      NSLog(@"Data from server %@", responseDictionary);
    }
    completionBlock(events);
  }
           onError:^(NSError* error) {
             errorBlock(error);
           }];
  [self enqueueOperation:op];
  return op;
}
@end
