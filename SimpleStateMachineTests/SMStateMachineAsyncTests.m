//
//  SMStateMachineAsyncTests.m
//  SimpleStateMachineTests
//
//  Created by Daniel Sanchez on 15/08/2018.
//

#import <XCTest/XCTest.h>
#import "../SMStateMachine/SMStateMachineAsync.h"

@interface SMStateMachineAsyncTests : XCTestCase

@end

@implementation SMStateMachineAsyncTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    dispatch_queue_t q = dispatch_queue_create("q", NULL);
    SMStateMachineAsync *fsm =[[SMStateMachineAsync alloc] init];
    fsm.serialQueue = q;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
