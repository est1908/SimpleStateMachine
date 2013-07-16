//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMNode.h"


#define SM_EVENT_TRUE @"SM_TRUE"
#define SM_EVENT_FALSE @"SM_FALSE"

typedef NSString * (^SMDecisionBlock)();
typedef BOOL (^SMBoolDecisionBlock)();

@interface SMDecision : SMNode

@property (strong, nonatomic) SMDecisionBlock block;
- (id)initWithName:(NSString *)name andBlock:(SMDecisionBlock)block;
- (id)initWithName:(NSString *)name andBoolBlock:(SMBoolDecisionBlock)block;

@end