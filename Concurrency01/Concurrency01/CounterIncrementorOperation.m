//
//  CounterIncrementorOperation.m
//  Concurrency01
//
//  Created by Nikolay Morev on 26/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "CounterIncrementorOperation.h"
#import "CounterIncrementor.h"

@implementation CounterIncrementorOperation

- (void)main {
    CounterIncrementor *incrementor = [[CounterIncrementor alloc] initWithNumberOfIterations:500000];

    usleep(1000000);

    NSLog(@"%li", (long)[incrementor countSerial]);

    usleep(1000000);

    NSLog(@"%li", (long)[incrementor countWithRaceCondition]);

    usleep(1000000);

    NSLog(@"%li", (long)[incrementor countWithAtomicOperations]);

    usleep(1000000);
    
    NSLog(@"%li", (long)[incrementor countWithSerialQueue]);

    usleep(1000000);
    
    NSLog(@"%li", (long)[incrementor countWithSynchronized]);

    usleep(1000000);
    
    NSLog(@"%li", (long)[incrementor countWithLock]);

    usleep(1000000);
    
    NSLog(@"%li", (long)[incrementor countWithDispatchApplyAtomicAdd]);

    usleep(1000000);

    NSLog(@"%li", (long)[incrementor countWithDispatchApplyLock]);

    usleep(1000000);
    
    NSLog(@"done");
}

@end
