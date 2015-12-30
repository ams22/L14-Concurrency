//
//  CounterIncrementor.m
//  Concurrency01
//
//  Created by Nikolay Morev on 26/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "CounterIncrementor.h"
#import <libkern/OSAtomic.h>

@interface CounterIncrementor ()
@property (nonatomic) NSInteger numberOfIterations;
@end

@implementation CounterIncrementor

- (instancetype)initWithNumberOfIterations:(NSInteger)numberOfIterations {
    if (self = [super init]) {
        _numberOfIterations = numberOfIterations;
    }
    return self;
}

- (NSInteger)countSerial {
    return [self incrementCounterSeriallyUsingBlock:^(NSInteger *counter) {
        (*counter)++;
    }];
}

- (NSInteger)countWithRaceCondition {
    return [self incrementCounterConcurrentlyUsingBlock:^(NSInteger *counter) {
        (*counter)++;
    }];
}

- (NSInteger)countWithAtomicOperations {
    return [self incrementCounterConcurrentlyUsingBlock:^(NSInteger *counter) {
        OSAtomicAdd32(1, (int32_t *)counter);
    }];
}

- (NSInteger)countWithSerialQueue {
    return [self incrementCounterConcurrentlyUsingBlock:^(NSInteger *counter) {
        (*counter)++;
    } onQueue:dispatch_queue_create("serial queue", DISPATCH_QUEUE_SERIAL)];
}

- (NSInteger)countWithSynchronized {
    return [self incrementCounterConcurrentlyUsingBlock:^(NSInteger *counter) {
        @synchronized(self) {
            (*counter)++;
        }
    }];
}

- (NSInteger)countWithLock {
    __block NSLock *lock = [[NSLock alloc] init];
    return [self incrementCounterConcurrentlyUsingBlock:^(NSInteger *counter) {
        [lock lock];
        (*counter)++;
        [lock unlock];
    }];
}

- (NSInteger)countWithDispatchApplyAtomicAdd {
    return [self incrementCounterConcurrentlyUsingDispatchApply:^(NSInteger *counter) {
        OSAtomicAdd32(1, (int32_t *)counter);
    }];
}

- (NSInteger)countWithDispatchApplyLock {
    return [self incrementCounterConcurrentlyUsingDispatchApply:^(NSInteger *counter) {
        @synchronized(self) {
            (*counter)++;
        }
    }];
}

- (NSInteger)incrementCounterConcurrentlyUsingBlock:(void (^)(NSInteger *counter))block {
    return [self incrementCounterConcurrentlyUsingBlock:block onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (NSInteger)incrementCounterConcurrentlyUsingBlock:(void (^)(NSInteger *counter))block onQueue:(dispatch_queue_t)queue {
    __block NSInteger counter = 0;

    dispatch_group_t group = dispatch_group_create();
    for (NSInteger iteration = 0; iteration < _numberOfIterations; iteration++) {
        dispatch_group_async(group, queue, ^{
            block(&counter);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    return counter;
}

- (NSInteger)incrementCounterConcurrentlyUsingDispatchApply:(void (^)(NSInteger *counter))block {
    __block NSInteger counter = 0;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(_numberOfIterations, queue, ^(size_t _) {
        block(&counter);
    });

    return counter;
}

- (NSInteger)incrementCounterSeriallyUsingBlock:(void (^)(NSInteger *counter))block {
    __block NSInteger counter = 0;

    for (NSInteger iteration = 0; iteration < _numberOfIterations; iteration++) {
        block(&counter);
    }

    return counter;
}

@end
