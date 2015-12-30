//
//  ComputationalyIntensiveOperation.m
//  Concurrency01
//
//  Created by Nikolay Morev on 27/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "ComputationalyIntensiveOperation.h"
#import "NSNumber+EKStuff.h"

@implementation ComputationalyIntensiveOperation

- (void)main {
    NSUInteger number = [self nthPrime:10000];
    self.result = number;
}

- (NSUInteger)nthPrime:(NSUInteger)n
{
    NSUInteger number = 1, count = 0, i = 0;

    while (count < n && !self.cancelled) {
        number = number + 1;
        for (i = 2; i <= number; i++) {
            if (number % i == 0) {
                break;
            }
        }
        if (i == number) {
            count = count + 1;
        }
    }

    return number;
}

@end
