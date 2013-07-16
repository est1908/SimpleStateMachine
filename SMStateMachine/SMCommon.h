//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SMTransition;
@class SMNode;

#define SMEXCEPTION @"SMEXCEPTION"


@protocol SMMonitorDelegate <NSObject>
@optional
- (void)receiveEvent:(NSString *)event forState:(SMNode *)curState foundTransition:(SMTransition*)transition;
- (void)didExecuteTransitionFrom:(SMNode *)from to:(SMNode *)to withEvent:(NSString *)event;
@end
