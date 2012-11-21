
#import "SMStateMachine.h"

@interface SMStateMachine ()
@property(strong, nonatomic, readonly) NSMutableArray *states;
@end

@implementation SMStateMachine
@synthesize states = _states;
@synthesize curState = _curState;
@synthesize globalExecuteIn = _globalExecuteIn;
@synthesize initialState = _initialState;
@synthesize monitor = _monitor;


- (SMState *)createState:(NSString *)name {
    SMState *state = [[SMState alloc] initWithName:name];
    [self.states addObject:state];
    return state;
}

- (SMDecision *)createDecision:(NSString *)name withPredicateBlock:(SMDecisionBlock)block {
    return [[SMDecision alloc] initWithName:name andBlock:block];
}

- (SMDecision *)createDecision:(NSString *)name withPredicateBoolBlock:(SMBoolDecisionBlock)block {
    return [[SMDecision alloc] initWithName:name andBoolBlock:block];
}

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event {
    [self transitionFrom:fromState to:toState forEvent:event withAction:nil];
}

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withSel:(SEL)actionSel {
    [self transitionFrom:fromState to:toState forEvent:event withAction:[SMAction actionWithSel:actionSel]];
}

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withSel:(SEL)actionSel executeIn:(NSObject *)executeIn {
    [self transitionFrom:fromState to:toState forEvent:event withAction:[SMAction actionWithSel:actionSel executeIn:executeIn]];
}

- (void)trueTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState {
    [self transitionFrom:fromState to:toState forEvent:SM_EVENT_TRUE withAction:nil];
}

- (void)trueTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState withSel:(SEL)actionSel {
    [self transitionFrom:fromState to:toState forEvent:SM_EVENT_TRUE withAction:[SMAction actionWithSel:actionSel]];
}

- (void)falseTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState {
    [self transitionFrom:fromState to:toState forEvent:SM_EVENT_FALSE withAction:nil];
}

- (void)falseTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState withSel:(SEL)actionSel {
    [self transitionFrom:fromState to:toState forEvent:SM_EVENT_FALSE withAction:[SMAction actionWithSel:actionSel]];
}

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withAction:(SMAction *)action {
    SMTransition *transition = [[SMTransition alloc] init];
    transition.from = fromState;
    transition.to = toState;
    transition.event = event;
    transition.action = action;
    [fromState _addTransition:transition];
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
    SMStateMachineExecuteContext *context = [[SMStateMachineExecuteContext alloc] init];
    context.globalExecuteIn = self.globalExecuteIn;
    context.monitor = self.monitor;
    context.curState = _curState;
    [_curState _postEvent:event withContext:context];
    _curState = context.curState;
}



- (NSMutableArray *)states {
    if (_states == nil) {
        _states = [[NSMutableArray alloc] init];
    }
    return _states;
}



-(void)setInitialState:(SMState*)aState {
    _initialState = aState;
    if (_curState == nil) {
        _curState = _initialState;
    }
}

@end






