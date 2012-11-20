//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMState.h"


@interface SMTransition : NSObject
@property(weak, nonatomic) SMState *from;
@property(weak, nonatomic) SMState *to;
@property(strong, nonatomic) NSString *event;
@property(strong, nonatomic) SMAction *action;
@end
