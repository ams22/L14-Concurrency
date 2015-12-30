//
//  GCDShowcase.m
//  Concurrency01
//
//  Created by Nikolay Morev on 27/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "GCDShowcase.h"
#import "NSNumber+EKStuff.h"

@implementation GCDShowcase

+ (GCDShowcase *)defaultShowcase {
    static GCDShowcase *showcase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showcase = [[GCDShowcase alloc] init];
    });
    return showcase;
}

- (NSUInteger)performComputationalyIntensiveTask {
    __block NSUInteger number;
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_sync(backgroundQueue, ^{
        number = [NSNumber nthPrime:10000];
    });
    return number;
}

- (void)performComputationalyIntensiveTaskOnCompletionOnBackgroundThread:(void (^)(NSUInteger number))completionBlock {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(backgroundQueue, ^{
        NSUInteger number = [self performComputationalyIntensiveTask];
        completionBlock(number);
    });
}

- (void)performComputationalyIntensiveTaskOnCompletion:(void (^)(NSUInteger number))completionBlock {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(backgroundQueue, ^{
        NSUInteger number = [self performComputationalyIntensiveTask];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(number);
        });
    });
}

@end
