//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMStateMachineExecuteContext.h"


@interface SMNode : NSObject
@property(nonatomic, readonly, strong) NSString *name;

- (id)initWithName:(NSString *)name;
- (void)_postEvent:(NSString *)event withContext:(SMStateMachineExecuteContext *)context;
- (void)_entryWithContext:(SMStateMachineExecuteContext *)context;
- (void)_exitWithContext:(SMStateMachineExecuteContext *)context;

- (void)_addTransition:(SMTransition *)transition;
- (SMTransition *)_getTransitionForEvent:(NSString *)event;

@end