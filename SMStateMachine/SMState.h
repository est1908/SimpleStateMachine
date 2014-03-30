//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMAction.h"
#import "SMNode.h"

@class SMTransition;

@interface SMState : SMNode
- (id)initWithName:(NSString *)name;

- (void)setEntrySelector:(SEL)entrySel executeIn:(NSObject *)object;

- (void)setEntrySelector:(SEL)entrySel;

- (void)setEntrySelectors:(SEL)selectors,...NS_REQUIRES_NIL_TERMINATION;


- (void)setExitSelector:(SEL)exitSel executeIn:(NSObject *)object;

- (void)setExitSelector:(SEL)exitSel;

- (void)setExitSelectors:(SEL)firstSelector,...NS_REQUIRES_NIL_TERMINATION;



@property(nonatomic, strong) id<SMActionProtocol> entry;
@property(nonatomic, strong) id<SMActionProtocol> exit;

@end

