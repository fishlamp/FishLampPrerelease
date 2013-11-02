//
//  FLErrorTests.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLErrorTests.h"
#import "NSError+FLExtras.h"
#import "FishLampMinimum.h"

@implementation FLErrorTests

- (void) testCancelError {
    NSError* error  = [NSError cancelError];
    FLAssert(error.isCancelError);
}

@end
