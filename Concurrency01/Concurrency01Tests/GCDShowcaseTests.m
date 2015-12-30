//
//  GCDShowcaseTests.m
//  Concurrency01
//
//  Created by Nikolay Morev on 27/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCDShowcase.h"

@interface GCDShowcaseTests : XCTestCase

@property (nonatomic, strong) GCDShowcase *showcase;

@end

@implementation GCDShowcaseTests

- (void)setUp {
    [super setUp];
    self.showcase = [[GCDShowcase alloc] init];
}

- (void)tearDown {
    self.showcase = nil;
    [super tearDown];
}

- (void)testPerformComputationalyIntensiveTask {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion"];
    [self.showcase performComputationalyIntensiveTaskOnCompletion:^(NSUInteger number) {
        NSLog(@"%lu", (unsigned long)number);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
