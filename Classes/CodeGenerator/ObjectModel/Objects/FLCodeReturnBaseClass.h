// 
// FLCodeReturnBaseClass.h
// 
// DO NOT MODIFY!! Modifications will be overwritten.
// Generated by: Mike Fullerton @ 6/27/13 5:46 PM with PackMule (3.0.0.31)
// 
// Project: FishLamp Code Generator
// 
// Copyright 2013 (c) GreenTongue Software LLC, Mike Fullerton
// The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 

#import "FLCodeElement.h"

@interface FLCodeReturnBaseClass : FLCodeElement {
@private
    id _returns;
}

@property (readwrite, strong, nonatomic) id returns;

- (id) initWithReturns:(id) returns;
+ (id) codeReturn;
+ (id) codeReturn:(id) returns;

@end
