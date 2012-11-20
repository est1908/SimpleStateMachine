//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMState.h"

@implementation SMState

@synthesize name = _name;
@synthesize entry = _entry;
@synthesize exit = _exit;


- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)setEntrySelector:(SEL)entrySel executeIn:(NSObject *)object {
    self.entry = [SMAction actionWithSel:entrySel executeIn:object];
}

- (void)setExitSelector:(SEL)exitSel executeIn:(NSObject *)object {
    self.exit = [SMAction actionWithSel:exitSel executeIn:object];
}

- (void)setEntrySelector:(SEL)entrySel {
    self.entry = [SMAction actionWithSel:entrySel];
}

- (void)setExitSelector:(SEL)exitSel {
    self.exit = [SMAction actionWithSel:exitSel];
}


@end