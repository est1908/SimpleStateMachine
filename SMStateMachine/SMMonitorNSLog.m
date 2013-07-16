//
//  Created by est1908 on 8/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMMonitorNSLog.h"


@interface SMMonitorNSLog()

@end


@implementation SMMonitorNSLog

- (id)initWithSmName:(NSString *)smName{
    self = [super init];
    if (self) {
        _smName = smName;
    }
    return self;
}

- (void)receiveEvent:(NSString *)event forState:(SMState *)curState foundTransition:(SMTransition *)transition {
  if (transition != nil) {
      NSLog(@"%@ start: %@ [%@] -> [%@]", self.smName, event, transition.from.name, transition.to.name);
  } else{
      NSLog(@"%@ transition not found for %@ in [%@]", self.smName, event, curState.name);
  }
}

- (void)didExecuteTransitionFrom:(SMState *)from to:(SMState *)to withEvent:(NSString *)event {
    NSLog(@"%@ finsh: %@ [%@] -> [%@]", self.smName, event, from.name, to.name);
}


@end