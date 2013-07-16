//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMCommon.h"

@class SMTransition;
@class SMNode;

@interface SMStateMachineExecuteContext : NSObject
@property(nonatomic, weak) id<SMMonitorDelegate> monitor;
@property(nonatomic, weak) SMNode *curState;
@property(nonatomic, weak) NSObject *globalExecuteIn;
@end