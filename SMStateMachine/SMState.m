//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMState.h"
#import "SMTransition.h"
#import "SMCompositeAction.h"

@implementation SMState

@synthesize entry = _entry;
@synthesize exit = _exit;


- (id)initWithName:(NSString *)name {
    return [super initWithName:name];
}

- (void)setEntrySelector:(SEL)entrySel executeIn:(NSObject *)object {
    self.entry = [SMAction actionWithSel:entrySel executeIn:object];
}

- (void)setExitSelector:(SEL)exitSel executeIn:(NSObject *)object {
    self.exit = [SMAction actionWithSel:exitSel executeIn:object];
}

- (void)setEntrySelector:(SEL)entrySel {
    self.entry = [SMAction actionWithSel:entrySel];
}

- (void)setEntrySelectors:(SEL)firstSelector,...{
    va_list args;
    va_start(args, firstSelector);
    self.entry = [SMCompositeAction actionWithFirstSelector:firstSelector andVaList:args];
    va_end(args);
}

- (void)setExitSelector:(SEL)exitSel {
    self.exit = [SMAction actionWithSel:exitSel];
}

- (void)setExitSelectors:(SEL)firstSelector,...{
    va_list args;
    va_start(args, firstSelector);
    self.exit = [SMCompositeAction actionWithFirstSelector:firstSelector andVaList:args];
    va_end(args);
}

- (void)_postEvent:(NSString *)event withContext:(SMStateMachineExecuteContext *)context {
    SMTransition *curTr = [self _getTransitionForEvent:event];
    if ([context.monitor respondsToSelector:@selector(receiveEvent:forState:foundTransition:)]) {
        [context.monitor receiveEvent:event forState:self foundTransition:curTr];
    }
    if (curTr != nil) {
        const BOOL shouldChangeStates = (nil != curTr.to);
        
        // Exit the old state.
        if (shouldChangeStates) {
            [self _exitWithContext:context];
            context.curState = curTr.to;
        }
        
        // Execute the transition action.
        [[curTr action] executeWithGlobalObject:context.globalExecuteIn];
        
        // Enter the new state.
        if (shouldChangeStates) {
            [context.curState _entryWithContext:context];
        }
        
        // Inform the monitor.
        if ([context.monitor respondsToSelector:@selector(didExecuteTransitionFrom:to:withEvent:)]) {
            [context.monitor didExecuteTransitionFrom:curTr.from to:context.curState withEvent:event];
        }
    }

}

- (void)_entryWithContext:(SMStateMachineExecuteContext *)context {
    [self.entry executeWithGlobalObject:context.globalExecuteIn];
}

- (void)_exitWithContext:(SMStateMachineExecuteContext *)context {
    [self.exit executeWithGlobalObject:context.globalExecuteIn];
}





@end