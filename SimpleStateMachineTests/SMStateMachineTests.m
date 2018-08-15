//
//  SMStateMachineTests.m
//  SimpleStateMachineTests
//
//  Created by Daniel Sanchez on 15/08/2018.
//

#import <XCTest/XCTest.h>
#import "../SMStateMachine/SMStateMachineAsync.h"

@interface SMStateMachineTests: XCTestCase <SMMonitorDelegate>

@end

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
    XCTAssertNotNil(sm, @"sm is nil");
}

- (void)testSimpleState
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *state1 = [sm createState:@"state1"];
    XCTAssertEqualObjects(state1.name, @"state1", @"Invalid state name");
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
    XCTAssertEqualObjects(sm.curState.name, @"state1", @"Invalid current state");
}

- (void)testValidateNoStates
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    XCTAssertThrows([sm validate], @"Check for no initial state");
}

- (void)testValidateNoInitialState
{
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *state1 = [sm createState:@"state1"];
    XCTAssertNotNil(state1, @"state1 is nil");
    XCTAssertThrows([sm validate], @"Check for no initial state");
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
    XCTAssertEqual(_counter, 1, @"Entry action not executed");
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
    XCTAssertEqual(_counter, 1, @"Exit action not executed");
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
    XCTAssertEqual(_counter, 1, @"Transition action not executed");
}


-(void)State1Entry{
    [_string appendString:@"State1Entry;"];
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
    XCTAssertEqualObjects(_string, @"State1Exit;TransAction;State2Entry;", @"Invalid calling sequence");
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
    XCTAssertEqualObjects(_string, @"State1Exit;TransAction;State2Entry;", @"Invalid calling sequence");
}

- (void)receiveEvent:(NSString *)event forState:(SMNode *)curState foundTransition:(SMTransition *)transition {
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
    XCTAssertEqual(_counter, 2, @"Monitor willExecuteTransitionFrom not executed");
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
    XCTAssertEqual(_counter, 3, @"Monitor receiveEvent not executed");
}


- (void)didExecuteTransitionFrom:(SMNode *)from to:(SMNode *)to withEvent:(NSString *)event {
    _counter++;
    XCTAssertEqualObjects(from.name, @"initial", @"Invalid from state");
    XCTAssertEqualObjects(to.name, @"state1", @"Invalid to state");
    XCTAssertEqualObjects(event, @"event1", @"Invalid event");
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
    XCTAssertEqual(_counter, 2, @"Monitor willExecuteTransitionFrom not executed");
}

-(void)testDecision1{
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    sm.globalExecuteIn = self;
    
    SMDecision *decision = [sm createDecision:@"decicson" withPredicateBlock:^(){
        return @"decisionEvent1";
    }];
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setEntrySelector:@selector(State1Entry)];
    [state2 setEntrySelector:@selector(State2Entry)];
    [sm transitionFrom:initial to:decision forEvent:@"event1"];
    [sm transitionFrom:decision to:state1 forEvent:@"decisionEvent1"];
    [sm transitionFrom:decision to:state2 forEvent:@"decisionEvent2"];
    [sm post:@"event1"];
    XCTAssertEqualObjects(_string, @"State1Entry;", @"Invalid calling sequence");
}

-(void)testDecision2{
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    sm.globalExecuteIn = self;
    
    SMDecision *decision = [sm createDecision:@"decicson" withPredicateBlock:^(){
        return @"decisionEvent2";
    }];
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setEntrySelector:@selector(State1Entry)];
    [state2 setEntrySelector:@selector(State2Entry)];
    [sm transitionFrom:initial to:decision forEvent:@"event1"];
    [sm transitionFrom:decision to:state1 forEvent:@"decisionEvent1"];
    [sm transitionFrom:decision to:state2 forEvent:@"decisionEvent2"];
    [sm post:@"event1"];
    XCTAssertEqualObjects(_string, @"State2Entry;", @"Invalid calling sequence");
}

-(void)testBoolDecision{
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    SMState *initial = [sm createState:@"initial"];
    sm.initialState =  initial;
    sm.globalExecuteIn = self;
    
    SMDecision *decision = [sm createDecision:@"decicson" withPredicateBoolBlock:^(){
        return NO;
    }];
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setEntrySelector:@selector(State1Entry)];
    [state2 setEntrySelector:@selector(State2Entry)];
    [sm transitionFrom:initial to:decision forEvent:@"event1"];
    [sm trueTransitionFrom:decision to:state1];
    [sm falseTransitionFrom:decision to:state2];
    [sm post:@"event1"];
    XCTAssertEqualObjects(_string, @"State2Entry;", @"Invalid calling sequence");
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

// An internal loopback "transition" does not change the state, but does execute the transition action.
-(void)testInternalLoopbackTransition{
    NSString* const kEventLoopback = @"loopback";
    _string = [[NSMutableString alloc] init];
    SMStateMachine* sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self;
    SMState* state = [sm createState:@"state"];
    sm.initialState = state;
    [state setEntrySelector:@selector(State1Entry)];
    [state setExitSelector:@selector(State1Exit)];
    [sm internalTransitionFrom:state forEvent:kEventLoopback withSel:@selector(TransAction)];
    [sm post:kEventLoopback];
    XCTAssertEqualObjects(_string, @"TransAction;", @"Only the transition action should execute");
}

// An external loopback transition leaves the current state, only to return to the same state.
// This executes the state's exit action, followed by the transition action, and finally the state's entry action.
-(void)testExternalLoopbackTransition{
    NSString* const kEventLoopback = @"loopback";
    _string = [[NSMutableString alloc] init];
    SMStateMachine* sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self;
    SMState* state = [sm createState:@"state"];
    sm.initialState = state;
    [state setEntrySelector:@selector(State1Entry)];
    [state setExitSelector:@selector(State1Exit)];
    [sm transitionFrom:state to:state forEvent:kEventLoopback withSel:@selector(TransAction)];
    [sm post:kEventLoopback];
    XCTAssertEqualObjects(_string, @"State1Exit;TransAction;State1Entry;", @"Invalid calling sequence");
}

- (void)testComplexAction
{
    _string = [[NSMutableString alloc] init];
    SMStateMachine *  sm = [[SMStateMachine alloc] init];
    sm.globalExecuteIn = self;
    SMState *initial = [sm createState:@"initial"];
    sm.initialState = initial;
    SMState *state1 = [sm createState:@"state1"];
    SMState *state2 = [sm createState:@"state2"];
    [state1 setExitSelectors:@selector(State1Exit), @selector(State1Exit),nil];
    [state2 setEntrySelectors:@selector(State2Entry), @selector(State2Entry), nil];
    [sm transitionFrom:initial to:state1 forEvent:@"event1"];
    [sm transitionFrom:state1 to:state2 forEvent:@"event2" withSelectors:@selector(TransAction),@selector(TransAction), nil];
    [sm post:@"event1"];
    [sm post:@"event2"];
    XCTAssertEqualObjects(_string, @"State1Exit;State1Exit;TransAction;TransAction;State2Entry;State2Entry;", @"Invalid calling sequence");
}

@end
