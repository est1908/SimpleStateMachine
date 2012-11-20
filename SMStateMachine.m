
#import "SMStateMachine.h"

@interface SMStateMachine ()
@property(strong, nonatomic, readonly) NSMutableArray *states;
@property(strong, nonatomic) NSMutableArray *transitions;

- (SMTransition *)getTransitionFromState:(SMState *)from forEvent:(NSString *)event;
@end

@implementation SMStateMachine
@synthesize states = _states;
@synthesize transitions = _transitions;
@synthesize curState = _curState;
@synthesize globalExecuteIn = _globalExecuteIn;
@synthesize initialState = _initialState;
@synthesize monitor = _monitor;


- (SMState *)createState:(NSString *)name {
    SMState *state = [[SMState alloc] initWithName:name];
    [self.states addObject:state];
    return state;
}

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event {
    [self transitionFrom:fromState to:toState forEvent:event withAction:nil];
}

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withSel:(SEL)actionSel {
    [self transitionFrom:fromState to:toState forEvent:event withAction:[SMAction actionWithSel:actionSel]];
}

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withSel:(SEL)actionSel executeIn:(NSObject *)executeIn {
    [self transitionFrom:fromState to:toState forEvent:event withAction:[SMAction actionWithSel:actionSel executeIn:executeIn]];
}

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withAction:(SMAction *)action {
    SMTransition *transition = [[SMTransition alloc] init];
    transition.from = fromState;
    transition.to = toState;
    transition.event = event;
    transition.action = action;
    [self.transitions addObject:transition];
}

- (void)validate {
    if ([self.states count] == 0) {
        [NSException raise:@"Invalid statemachine" format:@"No states"];
    }
    if (_initialState == nil) {
        [NSException raise:@"Invalid statemachine" format:@"initialState is nil"];
    }
}

- (void)post:(NSString *)event {
    SMTransition *curTr = [self getTransitionFromState:_curState forEvent:event];
    if ([self.monitor respondsToSelector:@selector(receiveEvent:forState:foundTransition:)]) {
        [self.monitor receiveEvent:event forState:_curState foundTransition:curTr];
    }
    if (curTr != nil) {
        [_curState.exit executeWithGlobalObject:self.globalExecuteIn];
        _curState = curTr.to;
        [[curTr action] executeWithGlobalObject:self.globalExecuteIn];
        [_curState.entry executeWithGlobalObject:self.globalExecuteIn];
        if ([self.monitor respondsToSelector:@selector(didExecuteTransitionFrom:to:withEvent:)]) {
            [self.monitor didExecuteTransitionFrom:curTr.from to:curTr.to withEvent:event];
        }
    }
}

- (SMTransition *)getTransitionFromState:(SMState *)from forEvent:(NSString *)event {
    for (SMTransition *curTr in self.transitions) {
        if (curTr.from == from && [curTr.event isEqualToString:event]) {
            return curTr;
        }
    }
    return nil;
}


- (NSMutableArray *)states {
    if (_states == nil) {
        _states = [[NSMutableArray alloc] init];
    }
    return _states;
}

- (NSMutableArray *)transitions {
    if (_transitions == nil) {
        _transitions = [[NSMutableArray alloc] init];
    }
    return _transitions;
}

-(void)setInitialState:(SMState*)aState {
    _initialState = aState;
    if (_curState == nil) {
        _curState = _initialState;
    }
}

@end






