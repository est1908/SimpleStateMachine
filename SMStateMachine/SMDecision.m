//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMDecision.h"
#import "SMCommon.h"
#import "SMTransition.h"


@implementation SMDecision
@synthesize block = _block;


- (id)initWithName:(NSString *)name andBlock:(SMDecisionBlock)block {
    self = [super initWithName:name];
    if (self) {
        _block = block;
    }
    return self;
}

- (id)initWithName:(NSString *)name andBoolBlock:(SMBoolDecisionBlock)block {
    self = [super initWithName:name];
    if (self) {
        _block = ^{
          BOOL res = block();
          return res ? SM_EVENT_TRUE : SM_EVENT_FALSE;
        };
    }
    return self;
}

- (void)_entryWithContext:(SMStateMachineExecuteContext *)context {
    if (_block == nil){
        [NSException raise:SMEXCEPTION format:@"Block must be set"];
        return;
    }
    NSString *eventToPost = self.block();
    SMTransition *curTr = [self _getTransitionForEvent:eventToPost];
    if (curTr == nil){
        [NSException raise:SMEXCEPTION format:@"Invalid event for this decision"];
        return;
    }
    if ([context.monitor respondsToSelector:@selector(receiveEvent:forState:foundTransition:)]) {
        [context.monitor receiveEvent:eventToPost forState:self foundTransition:curTr];
    }
    context.curState = curTr.to;

    [[curTr action] executeWithGlobalObject:context.globalExecuteIn];
    [context.curState _entryWithContext:context];
    if ([context.monitor respondsToSelector:@selector(didExecuteTransitionFrom:to:withEvent:)]) {
        [context.monitor didExecuteTransitionFrom:curTr.from to:context.curState withEvent:eventToPost];
    }


}

- (void)_exitWithContext:(SMStateMachineExecuteContext *)context {
    [super _exitWithContext:context];
}

- (void)_postEvent:(NSString *)event withContext:(SMStateMachineExecuteContext *)context {
    [NSException raise:SMEXCEPTION format:@"Post event not supported in desicions"];
}


@end