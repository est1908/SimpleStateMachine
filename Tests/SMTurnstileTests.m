//
// Created by est1908 on 12/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SMTurnstileTests.h"
#import "SMMonitorNSLog.h"


@interface  SMTurnstileTests()
@property (nonatomic) NSInteger returnCoinsCounter;
@property (nonatomic) BOOL isWorkTime;

@end

@implementation SMTurnstileTests
@synthesize returnCoinsCounter = _returnCoinsCounter;
@synthesize isWorkTime = _isWorkTime;


-(void)returnCoin{
    self.returnCoinsCounter++;
}

-(void)greenLightOn{

}

-(void)redLightOn{

}


-(void)testTurnstileWithDecision{
    //Create structure
    __weak id weakSelf = self;
    //strong ref to monitor object
    SMMonitorNSLog *nsLogMonitor =[[SMMonitorNSLog alloc] initWithSmName:@"Turnstile"];
    SMStateMachine *sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self; //execute all selectors on self object
    //log to NSLog
    sm.monitor = nsLogMonitor;
    SMState *opened = [sm createState:@"open"];
    SMState *closed = [sm createState:@"closed"];
    SMDecision *isWorkTime = [sm createDecision:@"isWorkTime" withPredicateBoolBlock:^(){
       return [weakSelf isWorkTime];
    }];
    sm.initialState = closed;
    [opened setEntrySelector:@selector(greenLightOn)];
    [closed setEntrySelector:@selector(redLightOn)];
    [sm transitionFrom:closed to:isWorkTime forEvent:@"coin"];
    [sm trueTransitionFrom:isWorkTime to:opened];
    [sm falseTransitionFrom:isWorkTime to:closed withSel:@selector(returnCoin)];
    [sm transitionFrom:opened to:closed forEvent:@"pass"];
    [sm transitionFrom:opened to:closed forEvent:@"timeout"];
    [sm transitionFrom:opened to:opened forEvent:@"coin" withSel:@selector(returnCoin)];
    [sm validate];

    //Usage
    self.isWorkTime = NO;
    self.returnCoinsCounter = 0;
    [sm post:@"coin"];
    STAssertEquals(1, self.returnCoinsCounter, nil);
    self.isWorkTime = YES;
    [sm post:@"coin"];
    STAssertEquals(1, self.returnCoinsCounter, nil);
    [sm post:@"coin"];
    STAssertEquals(2, self.returnCoinsCounter, nil);
}

@end