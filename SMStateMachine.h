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

@class SMAction;
@class SMState;


@interface SMStateMachine : NSObject

- (SMState *)createState:(NSString *)name;

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event;

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withAction:(SMAction *)action;

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withSel:(SEL)actionSel;

- (void)transitionFrom:(SMState *)fromState to:(SMState *)toState forEvent:(NSString *)event withSel:(SEL)actionSel executeIn:(NSObject *)executeIn;

- (void)post:(NSString *)event;

- (void)validate;

@property(nonatomic, weak) NSObject *globalExecuteIn;
@property(nonatomic, readonly) SMState *curState;
@property(nonatomic) SMState *initialState;

@end

@interface SMState : NSObject
- (id)initWithName:(NSString *)name;

- (void)setEntrySelector:(SEL)entrySel executeIn:(NSObject *)object;

- (void)setEntrySelector:(SEL)entrySel;

- (void)setExitSelector:(SEL)exitSel executeIn:(NSObject *)object;

- (void)setExitSelector:(SEL)exitSel;

@property(nonatomic, readonly, strong) NSString *name;
@property(nonatomic, strong) SMAction *entry;
@property(nonatomic, strong) SMAction *exit;

@end


@interface SMAction : NSObject

+ (SMAction *)actionWithSel:(SEL)sel;

+ (SMAction *)actionWithSel:(SEL)sel executeIn:(NSObject *)executeInObj;

- (id)initWithSel:(SEL)sel executeIn:(NSObject *)executeInObj;

- (id)initWithSel:(SEL)sel;

- (void)execute;

- (void)executeWithGlobalObject:(NSObject *)globalExecuteInObj;

@property(nonatomic, readonly) SEL sel;
@property(nonatomic, readonly, weak) NSObject *executeInObj;

@end

@interface SMTransition : NSObject
@property(weak, nonatomic) SMState *from;
@property(weak, nonatomic) SMState *to;
@property(strong, nonatomic) NSString *event;
@property(strong, nonatomic) SMAction *action;
@end

