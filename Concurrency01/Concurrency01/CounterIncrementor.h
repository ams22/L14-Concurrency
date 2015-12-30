//
//  CounterIncrementor.h
//  Concurrency01
//
//  Created by Nikolay Morev on 26/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CounterIncrementor : NSObject

- (instancetype)initWithNumberOfIterations:(NSInteger)numberOfIterations NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (NSInteger)countSerial;
- (NSInteger)countWithRaceCondition;
- (NSInteger)countWithAtomicOperations;
- (NSInteger)countWithSerialQueue;
- (NSInteger)countWithSynchronized;
- (NSInteger)countWithLock;
- (NSInteger)countWithDispatchApplyAtomicAdd;
- (NSInteger)countWithDispatchApplyLock;

@end
