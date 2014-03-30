//
// Created by est1908 on 11/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SMActionProtocol.h"


@interface SMAction : NSObject<SMActionProtocol>

+ (SMAction *)actionWithSel:(SEL)sel;

+ (SMAction *)actionWithSel:(SEL)sel executeIn:(NSObject *)executeInObj;

- (id)initWithSel:(SEL)sel executeIn:(NSObject *)executeInObj;

- (id)initWithSel:(SEL)sel;

- (void)execute;

@property(nonatomic, readonly) SEL sel;
@property(nonatomic, readonly, weak) NSObject *executeInObj;

@end