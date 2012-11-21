//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMNode.h"
#import "SMTransition.h"


@interface SMNode()
@property(strong, nonatomic) NSMutableArray *transitions;
@end

@implementation SMNode
@synthesize name = _name;
@synthesize transitions = _transitions;

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)_entryWithContext:(SMStateMachineExecuteContext *)context {

}

- (void)_exitWithContext:(SMStateMachineExecuteContext *)context {

}

- (void)_postEvent:(NSString *)event withContext:(SMStateMachineExecuteContext *)context {

}

- (void)_addTransition:(SMTransition *)transition {
    [self.transitions addObject:transition];
}

- (SMTransition *)_getTransitionForEvent:(NSString *)event {
    for (SMTransition *curTr in self.transitions) {
        if ([curTr.event isEqualToString:event]) {
            return curTr;
        }
    }
    return nil;
}


- (NSMutableArray *)transitions {
    if (_transitions == nil) {
        _transitions = [[NSMutableArray alloc] init];
    }
    return _transitions;
}


@end