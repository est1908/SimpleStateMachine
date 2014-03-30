//
// Created by est1908 on 3/30/14.
//


#import "SMCompositeAction.h"
#import "SMAction.h"


@implementation SMCompositeAction {
    NSArray *_actions;

}
- (instancetype)initWithActions:(NSArray *)actions {
    self = [super init];
    if (self) {
        _actions = actions;
    }

    return self;
}

+ (instancetype)actionWithActionsArray:(NSArray *)actions {
    return [[self alloc] initWithActions:actions];
}

+ (instancetype)actionWithFirstSelector:(SEL)firstSel andVaList:(va_list)valist {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[SMAction actionWithSel:firstSel]];
    SEL curSel = nil;
    while ((curSel = va_arg(valist, SEL))) {
        [array addObject:[SMAction actionWithSel:curSel]];
    }
    return [self actionWithActionsArray:array];
}

- (void)executeWithGlobalObject:(NSObject *)globalExecuteInObj {
    for (id<SMActionProtocol> curAction in _actions){
        [curAction executeWithGlobalObject:globalExecuteInObj];
    }
}


@end