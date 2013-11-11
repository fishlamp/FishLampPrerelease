//
//  FLTestableOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableOperation.h"
#import "FLTestCaseList.h"
#import "FLDispatchQueue.h"
#import "FLOperationContext.h"
#import "FLTestCaseOperation.h"

@interface FLTestableOperation ()
@property (readonly, strong, nonatomic) id<FLTestable> testableObject;
@property (readwrite, strong, nonatomic) NSMutableArray* queue;
@property (readwrite, strong, nonatomic) FLTestCaseOperation* currentTestCase;
- (void) willRunTestCases:(FLTestCaseList*) testCases;
- (void) didRunTestCases:(FLTestCaseList*) testCases;
@end

@implementation FLTestableOperation

@synthesize testableObject = _testableObject;
@synthesize queue =_queue;
@synthesize currentTestCase = _currentTestCase;


- (id) initWithTestable:(id<FLTestable>) testableObject {
	self = [super init];
	if(self) {
        FLAssertNotNil(testableObject);
		_testableObject = FLRetain(testableObject);
    }
	return self;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject  {
   return FLAutorelease([[[self class] alloc] initWithTestable:testableObject]);
}

#if FL_MRC
- (void)dealloc {
    [_queue release];
	[_testableObject release];
	[super dealloc];
}
#endif

- (NSString*) testName {
    return [_testableObject testName];
}

- (void) willRunTestCases:(FLTestCaseList*) testCases {
    if([_testableObject respondsToSelector:@selector(willRunTestCases:)]) {
        [_testableObject willRunTestCases:testCases];
    }
}

- (void) didRunTestCases:(FLTestCaseList*) testCases {

    if([_testableObject respondsToSelector:@selector(didRunTestCases:)]) {
        [_testableObject didRunTestCases:testCases];
    }
}

- (id) resultForTest {

    for(FLTestCaseOperation* testCase in self.testableObject.testCaseList) {
       if(!testCase.result.passed) {
            return FLFailedResult;
       }
    }

    return FLSuccessfulResult;

}

#define kPadWidth [@"starting" length]

- (void) finishedTest:(FLTestCaseOperation*) testCase
           withResult:(FLPromisedResult) withResult {

    [[FLTestLoggingManager instance] appendTestCaseOutput:testCase];
    [[FLTestLoggingManager instance] outdent:nil];


    if(testCase.isDisabled) {
        NSString* reason = testCase.disabledReason;
        if(![reason length]) {
            reason = @"NO REASON";
        }
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@ (%@)",
            [NSString stringWithLeadingPadding_fl:@"DISABLED"
                                     minimumWidth:kPadWidth],
                                     testCase.testCaseName, reason];
    }
    else if(testCase.result.passed) {
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"Passed" minimumWidth:kPadWidth], testCase.testCaseName];
    }
    else {
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"FAILED" minimumWidth:kPadWidth], testCase.testCaseName ];
    }
    [self.testableObject setCurrentTestCase:nil];

    [FLBackgroundQueue queueTarget:self action:@selector(beginNextTest)];
}

- (void) beginNextTest {

    if(_queue.count > 0) {

        FLTestCaseOperation* currentTestCase = [_queue objectAtIndex:0];
        [_queue removeObjectAtIndex:0];
        FLAssertNotNil(currentTestCase);

        id<FLTestable> testable = self.testableObject;
        FLAssertNotNil(testable);

        testable.currentTestCase = currentTestCase;

        if(!currentTestCase.isDisabled) {
            [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@",
                [NSString stringWithLeadingPadding_fl:@"Starting" minimumWidth:kPadWidth],
                currentTestCase.testCaseName];
        }

        [[FLTestLoggingManager instance] indent:nil];

        __block FLTestableOperation* SELF = FLRetain(self);
        __block FLTestCaseOperation* testCase = FLRetain(currentTestCase);
        [self.context queueOperation:testCase
                          completion:^(FLPromisedResult result) {

            [SELF finishedTest:testCase withResult:result];

            FLReleaseWithNil(SELF);
            FLReleaseWithNil(testCase);
        }];

    }
    else {

        [self didRunTestCases:self.testableObject.testCaseList];

        [self setFinishedWithResult:[self resultForTest]];
    }
}

- (void) startOperation {

    [self willRunTestCases:self.testableObject.testCaseList];

    NSArray* startList = FLCopyWithAutorelease(self.testableObject.testCaseList.testCaseArray);
    for(FLTestCaseOperation* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase prepareTestCase];
    }

    // the list is now prepared and ordered.
    self.queue = FLMutableCopyWithAutorelease(self.testableObject.testCaseList.testCaseArray);

    [FLBackgroundQueue queueTarget:self action:@selector(beginNextTest)];
}



@end