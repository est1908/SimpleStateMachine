//
// Created by est1908 on 3/30/14.
//


#import <Foundation/Foundation.h>
#import "SMActionProtocol.h"


@interface SMCompositeAction : NSObject<SMActionProtocol>


- (instancetype)initWithActions:(NSArray *)actions;
+ (instancetype)actionWithActionsArray:(NSArray *)actions;
+ (instancetype)actionWithFirstSelector:(SEL)firstSel andVaList:(va_list)valist;

@end