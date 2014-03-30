//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMState.h"


@interface SMTransition : NSObject
@property(weak, nonatomic) SMNode *from;
@property(weak, nonatomic) SMNode *to;
@property(strong, nonatomic) NSString *event;
@property(strong, nonatomic) id<SMActionProtocol> action;
@end
