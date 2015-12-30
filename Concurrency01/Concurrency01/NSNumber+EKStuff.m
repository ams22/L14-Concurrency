//
//  NSNumber+EKStuff.m
//  Concurrency01
//
//  Created by Nikolay Morev on 27/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "NSNumber+EKStuff.h"

@implementation NSNumber (EKStuff)

+ (NSUInteger)nthPrime:(NSUInteger)n
{
    NSUInteger number = 1, count = 0, i = 0;

    while (count < n) {
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
