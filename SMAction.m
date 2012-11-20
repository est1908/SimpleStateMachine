//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMAction.h"

@implementation SMAction
@synthesize sel = _sel;
@synthesize executeInObj = _executeInObj;

+ (SMAction *)actionWithSel:(SEL)sel {
    return [[SMAction alloc] initWithSel:sel];
}

+ (SMAction *)actionWithSel:(SEL)sel executeIn:(NSObject *)executeInObj {
    return [[SMAction alloc] initWithSel:sel executeIn:executeInObj];
}


- (id)initWithSel:(SEL)sel executeIn:(NSObject *)executeInObj {
    self = [super init];
    if (self) {
        _sel = sel;
        _executeInObj = executeInObj;
    }
    return self;
}

- (id)initWithSel:(SEL)sel {
    return [self initWithSel:sel executeIn:nil];
}

- (void)execute {
    [self executeWithGlobalObject:nil];
}

- (void)executeWithGlobalObject:(NSObject *)globalExecuteInObj {
    if (self.sel == nil) {
        return;
    }
    NSObject *object = self.executeInObj != 0 ? self.executeInObj : globalExecuteInObj;
    if (object == nil) {
        [NSException raise:@"Invalid action" format:@"No one object to execute selector found"];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [object performSelector:self.sel];
#pragma clang diagnostic pop
}

@end
