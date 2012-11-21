//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMStateMachineExecuteContext.h"
#import "SMTransition.h"
#import "SMNode.h"


@implementation SMStateMachineExecuteContext
@synthesize monitor = _monitor;
@synthesize globalExecuteIn = _globalExecuteIn;
@synthesize curState = _curState;

@end