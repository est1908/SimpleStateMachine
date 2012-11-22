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

-(void)dropTimingEvent:(NSString *)event{
    if ([self.allowedTimingEvents containsObject:event]){
        [self.allowedTimingEvents removeObject:event];
    }
}

-(void)postAsync:(NSString *)event after:(NSUInteger)milliseconds {
    __weak SMStateMachineAsync* weakSelf = self;
    [self.allowedTimingEvents addObject:event];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, milliseconds * NSEC_PER_MSEC);
    dispatch_after(timeout, dispatch_get_main_queue(), ^{
        if ([weakSelf.allowedTimingEvents containsObject:event]){
            [weakSelf.allowedTimingEvents removeObject:event];
            [weakSelf postAsync:event];
        }
    });
}

-(NSMutableArray *)allowedTimingEvents {
    if (_allowedTimingEvents == nil){
        _allowedTimingEvents = [[NSMutableArray alloc] init];
    }
    return _allowedTimingEvents;
}


@end