//
//  SMStateMachineAsyncTests.m
//  SMStateMachine
//
//  Created by Artem Kireev on 7/21/13.
//  Copyright (c) 2013 Codemasters International. All rights reserved.
//

#import "SMStateMachineAsyncTests.h"
#import "SMStateMachineAsync.h"

@implementation SMStateMachineAsyncTests

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

-(void)testCreate{

    dispatch_queue_t q = dispatch_queue_create("q", NULL);
    SMStateMachineAsync *fsm =[[SMStateMachineAsync alloc] init];
    fsm.serialQueue = q;
    
}

@end
