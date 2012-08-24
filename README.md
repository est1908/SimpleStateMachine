Simple State Machine written in Objective-C
==================

Very simple state machine written in Objective-C.
Support entry actions, exit actions for states and actions on transitions.

Usage example:

`//Create structure
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
`

`//Usage
[sm validate];
[sm post:@"coin"];
[sm post:@"pass"];
`

PS Feel free to contact me :)