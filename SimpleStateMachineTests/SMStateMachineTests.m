//
//  SMStateMachineTests.m
//  SimpleStateMachineTests
//
//  Created by Artem Kireev on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SMStateMachineTests.h"
#import "SMStateMachine.h"

@implementation SMStateMachineTests {
    NSInteger _counter;
    NSMutableString * _string;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEmpty
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    STAssertNotNil(sm, @"sm is nil");
}

- (void)testSimpleState
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *state1 = [sm createState:@"state1"];
    STAssertEqualObjects(state1.name, @"state1", @"Invalid state name");
}

- (void)testInitial
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"Initial"];
    SMState *state1 = [sm createState:@"state1"];
    sm.initialState = initial;
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
}

- (void)testSimpleSM
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    SMState *state1 = [sm createState:@"state1"];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm post:@"event1"];
    STAssertEqualObjects(sm.curState.name, @"state1", @"Invalid current state");
}

- (void)testValidateNoStates
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    STAssertThrows([sm validate], @"Check for no initial state");
}

- (void)testValidateNoInitialState
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *state1 = [sm createState:@"state1"];
    STAssertNotNil(state1, @"state1 is nil");
    STAssertThrows([sm validate], @"Check for no initial state");
}

-(void)simpleMethod {
    _counter++;
}

- (void)testEntryExecute
{
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    [state1 setEntrySelector:@selector(simpleMethod) executeIn:self];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm post:@"event1"];
    STAssertEquals(_counter, 1, @"Entry action not executed");
}

- (void)testExitExecute
{
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setExitSelector:@selector(simpleMethod) executeIn:self];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm transitionFrom:state1 to:state2 forEvent:@"event2"];
    [sm post:@"event1"];
    [sm post:@"event2"];
    STAssertEquals(_counter, 1, @"Exit action not executed");
}

- (void)testExecuteActionOnTransition
{
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    [sm transitionFrom:initial to:state1 forEvent:@"event1" withSel:@selector(simpleMethod) executeIn:self];
    [sm post:@"event1"];
    STAssertEquals(_counter, 1, @"Transition action not executed");
}

-(void)State1Exit{
    [_string appendString:@"State1Exit;"];
}
-(void)TransAction{
    [_string appendString:@"TransAction;"];
}
-(void)State2Entry{
    [_string appendString:@"State2Entry;"];
}

- (void)testExecuteSequence
{
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setExitSelector:@selector(State1Exit) executeIn:self];
    [state2 setEntrySelector:@selector(State2Entry) executeIn:self];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm transitionFrom:state1 to:state2 forEvent:@"event2" withSel:@selector(TransAction) executeIn:self];
    [sm post:@"event1"];
    [sm post:@"event2"];
    STAssertEqualObjects(_string, @"State1Exit;TransAction;State2Entry;", @"Invalid calling sequence");
}

-(void)testGlobalExecuteIn {
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self;
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setExitSelector:@selector(State1Exit)];
    [state2 setEntrySelector:@selector(State2Entry)];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm transitionFrom:state1 to:state2 forEvent:@"event2" withSel:@selector(TransAction)];
    [sm post:@"event1"];
    [sm post:@"event2"];
    STAssertEqualObjects(_string, @"State1Exit;TransAction;State2Entry;", @"Invalid calling sequence");
}

- (void)receiveEvent:(NSString *)event foundTransition:(SMTransition *)transition {
    _counter++;
}

-(void)testMonitorReceiveEventFoundTransition {
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    sm.monitor = self;
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    SMState *state1 = [sm createState:@"state1"];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm post:@"event1"];
    STAssertEquals(_counter, 2, @"Monitor willExecuteTransitionFrom not executed");
}

-(void)testMonitorReceiveEventFoundTransition_NoTransitionsFound {
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    sm.monitor = self;
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    SMState *state1 = [sm createState:@"state1"];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm post:@"unknown"];
    [sm post:@"unknown"];
    [sm post:@"unknown"];
    STAssertEquals(_counter, 3, @"Monitor receiveEvent not executed");
}


- (void)didExecuteTransitionFrom:(SMState *)from to:(SMState *)to withEvent:(NSString *)event {
    _counter++;
    STAssertEqualObjects(from.name, @"initial", @"Invalid from state");
    STAssertEqualObjects(to.name, @"state1", @"Invalid to state");
    STAssertEqualObjects(event, @"event1", @"Invalid event");
}

-(void)testMonitorDidExecuteTransitionFrom {
    _counter = 0;
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    sm.monitor = self;
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    SMState *state1 = [sm createState:@"state1"];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm post:@"event1"];
    STAssertEquals(_counter, 2, @"Monitor willExecuteTransitionFrom not executed");
}


-(void)beep{
    NSLog(@"Beep");
}

-(void)greenLightOn{
    NSLog(@"greenLightOn");
}

-(void)redLightOn{
    NSLog(@"redLightOn");
}

//turnstile
-(void)testFowWiKi{
    //Create
    SMStateMachine *sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self; //execute all selectors on self object
    SMState *opened = [sm createState:@"open"];
    SMState *closed = [sm createState:@"closed"];
    sm.initialState = closed;
    [opened setEntrySelector:@selector(greenLightOn)];
    [closed setEntrySelector:@selector(redLightOn)];
    [sm transitionFrom:closed to:opened forEvent:@"coin"];
    [sm transitionFrom:opened to:closed forEvent:@"pass"];
    [sm transitionFrom:opened to:closed forEvent:@"timeout"];
    [sm transitionFrom:opened to:opened forEvent:@"coint" withSel:@selector(beep)];

    //Usage
    [sm validate];
    [sm post:@"coin"];
    [sm post:@"pass"];
}


@end
