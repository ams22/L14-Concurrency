//
//  GCDShowcase.h
//  Concurrency01
//
//  Created by Nikolay Morev on 27/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDShowcase : NSObject

+ (GCDShowcase *)defaultShowcase;

- (NSUInteger)performComputationalyIntensiveTask;

- (void)performComputationalyIntensiveTaskOnCompletion:(void (^)(NSUInteger number))completionBlock;

- (void)performComputationalyIntensiveTaskOnCompletionOnBackgroundThread:(void (^)(NSUInteger number))completionBlock;

@end
