//
//  Created by est1908 on 8/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMStateMachine.h"


@interface SMMonitorNSLog : NSObject<SMMonitorDelegate>
@property (nonatomic, readonly, strong) NSString* smName;
- (id)initWithSmName:(NSString *)smName;
@end