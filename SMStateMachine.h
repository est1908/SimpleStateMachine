//
//  SMStateMachine.h
//  Simple State Machine
//
//  Created by Artem Kireev on 6/26/12.
//  Copyright (c) 2012 Artem Kireev. All rights reserved.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/est1908/SimpleStateMachine
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <Foundation/Foundation.h>
#import "SMState.h"
#import "SMAction.h"
#import "SMTransition.h"
#import "SMDecision.h"


@interface SMStateMachine : NSObject

- (SMState *)createState:(NSString *)name;

- (SMDecision *)createDecision:(NSString *)name withPredicateBlock:(SMDecisionBlock)block;

- (SMDecision *)createDecision:(NSString *)name withPredicateBoolBlock:(SMBoolDecisionBlock)block;

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event;

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withAction:(SMAction *)action;

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withSel:(SEL)actionSel;

- (void)transitionFrom:(SMNode *)fromState to:(SMNode *)toState forEvent:(NSString *)event withSel:(SEL)actionSel executeIn:(NSObject *)executeIn;

- (void)trueTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState;
- (void)trueTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState withSel:(SEL)actionSel;
- (void)falseTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState;
- (void)falseTransitionFrom:(SMDecision *)fromState to:(SMNode *)toState withSel:(SEL)actionSel;

- (void)internalTransitionFrom:(SMNode *)fromState forEvent:(NSString *)event withAction:(SMAction *)action;
- (void)internalTransitionFrom:(SMNode *)fromState forEvent:(NSString *)event withSel:(SEL)actionSel;
- (void)internalTransitionFrom:(SMNode *)fromState forEvent:(NSString *)event withSel:(SEL)actionSel executeIn:(NSObject *)executeIn;

- (void)post:(NSString *)event;

- (void)validate;

@property(nonatomic, weak) NSObject *globalExecuteIn;
@property(nonatomic, readonly) SMNode *curState;
@property(nonatomic) SMNode *initialState;
@property(nonatomic, weak) id <SMMonitorDelegate> monitor;

@end





