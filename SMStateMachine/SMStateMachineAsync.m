//
// Created by est1908 on 11/22/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMStateMachineAsync.h"


@interface SMStateMachineAsync()
@property (strong, nonatomic) NSMutableArray *allowedTimingEvents;
@end

@implementation SMStateMachineAsync



- (void)postAsync:(NSString *)event {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self post: event];
    });
}

-(void)dropTimingEvent:(NSString *)eventUuid {
    if ([self.allowedTimingEvents containsObject:eventUuid]){
        [self.allowedTimingEvents removeObject:eventUuid];
    }
}

-(NSString *)postAsync:(NSString *)event after:(NSUInteger)milliseconds {
    __weak SMStateMachineAsync* weakSelf = self;
    NSString *uuid = [self createUuid];
    [self.allowedTimingEvents addObject:uuid];
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, milliseconds * NSEC_PER_MSEC);
    dispatch_after(timeout, dispatch_get_main_queue(), ^{
        if ([weakSelf.allowedTimingEvents containsObject:uuid]){
            [weakSelf.allowedTimingEvents removeObject:uuid];
            [weakSelf postAsync:event];
        }
    });
    return uuid;
}

-(NSString *)createUuid{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString * res= (__bridge NSString *) (CFUUIDCreateString(kCFAllocatorDefault, uuid));
    return res;
}

-(NSMutableArray *)allowedTimingEvents {
    if (_allowedTimingEvents == nil){
        _allowedTimingEvents = [[NSMutableArray alloc] init];
    }
    return _allowedTimingEvents;
}


@end