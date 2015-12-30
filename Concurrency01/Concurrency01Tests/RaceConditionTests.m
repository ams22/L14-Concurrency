//
//  RaceConditionTests.m
//  Concurrency01
//
//  Created by Nikolay Morev on 24/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CounterIncrementor.h"

@interface RaceConditionTests : XCTestCase

@property (nonatomic, strong) CounterIncrementor *incrementor;

@end

@implementation RaceConditionTests

- (void)setUp {
    [super setUp];
    self.incrementor = [[CounterIncrementor alloc] initWithNumberOfIterations:50000];
}

- (void)tearDown {
    self.incrementor = nil;
    [super tearDown];
}

- (void)testSerial {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countSerial]);
    }];
}

- (void)testRaceCondition {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithRaceCondition]);
    }];
}

- (void)testRaceCondition1 {
    __block NSInteger counter = 0;

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    for (NSInteger iteration = 0; iteration < 50000; iteration++) {
        dispatch_group_async(group, queue, ^{
            counter++;
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    NSLog(@"%li", (long)counter);
}

- (void)testWithAtomicOperations {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithAtomicOperations]);
    }];
}

- (void)testWithSerialQueue {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithSerialQueue]);
    }];
}

- (void)testWithWithSynchronized {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithSynchronized]);
    }];
}

- (void)testWithLock {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithLock]);
    }];
}

- (void)testWithDispatchApplyAtomicAdd {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithDispatchApplyAtomicAdd]);
    }];
}

- (void)testWithDispatchApplyLock {
    [self measureBlock:^{
        NSLog(@"%li", [self.incrementor countWithDispatchApplyLock]);
    }];
}

@end
