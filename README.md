Simple State Machine written in Objective-C
==================

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Very simple state machine written in Objective-C.  

**Features:**  

* Entry actions
* Exit actions
* Actions on transitions
* Decisions
* Asynchronous mode
* Timing events in asynchronous mode
* Logging


Turnstile example
--------

	//Create structure  
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
 	[sm transitionFrom:opened to:opened forEvent:@"coin" withSel:@selector(returnCoin)];    


	//Usage
	[sm validate];  
	[sm post:@"coin"];  
	[sm post:@"pass"];



Decision example
--------


	//Create structure  
    __weak id weakSelf = self;  
    SMStateMachine *sm = [[SMStateMachine alloc] init];  
    sm.globalExecuteIn = self; //execute all selectors on self object  
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
    STAssertEquals(2, self.returnCoinsCounter, nil);`

Logging example
--------

For enable logging you need to set the **monitor** property of fsm object to **SMMonitorDelegate** protocol implementation.  
You can use the default **SMMonitorNSLog** implementation or write your own.  

**_Attention!_** You need to have strong reference to you monitor object, because the fsm monitor property descrived as _@property(nonatomic, weak) id &lt;SMMonitorDelegate> monitor;_  



    //strong ref to monitor object
    SMMonitorNSLog *nsLogMonitor =[[SMMonitorNSLog alloc] initWithSmName:@"Turnstile"];
    SMStateMachine *sm = [[SMStateMachine alloc] init]; 
    //log to NSLog
    sm.monitor = nsLogMonitor;
    ...





PS Feel free to contact me :)
