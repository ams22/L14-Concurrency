//
//  ViewController.m
//  Concurrency01
//
//  Created by Nikolay Morev on 24/12/15.
//  Copyright © 2015 Nikolay Morev. All rights reserved.
//

#import "ViewController.h"
#import "CounterIncrementorOperation.h"
#import "GCDShowcase.h"
#import "NSNumber+EKStuff.h"
#import "ComputationalyIntensiveOperation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (weak, nonatomic) NSOperation *currentOperation;

@end

@implementation ViewController

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CounterIncrementorOperation *operation = [[CounterIncrementorOperation alloc] init];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (IBAction)calculate:(id)sender {
//    [self calculateSynchronously];
//    [self calculateAsynchronously];
//    [self performAsynchronousJobSynchronously];
//    [self calculateThreeResults];
//    [self calculateWithBlockOperation];
//    [self calculateWithOperation];
}

- (void)calculateSynchronously {
    GCDShowcase *showcase = [GCDShowcase defaultShowcase];
    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];
    NSUInteger number = [showcase performComputationalyIntensiveTask];
    hideActivityIndicator();
    [self setResult:number];
}

- (void)calculateAsynchronously {
    // Осторожно: пользователь может нажать кнопку несколько раз пока вычисления выполняются.
    // Нужно предусмотреть это.

    GCDShowcase *showcase = [GCDShowcase defaultShowcase];
    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];
    [showcase performComputationalyIntensiveTaskOnCompletion:^(NSUInteger number) {
        hideActivityIndicator();
        [self setResult:number];
    }];
}

- (void)performAsynchronousJobSynchronously {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    GCDShowcase *showcase = [GCDShowcase defaultShowcase];
    __block NSUInteger result;
    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];
    [showcase performComputationalyIntensiveTaskOnCompletionOnBackgroundThread:^(NSUInteger number) {
        result = number;
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    hideActivityIndicator();
    [self setResult:result];
}

- (void)calculateThreeResults {
    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];
    __block NSUInteger result;
    GCDShowcase *showcase = [GCDShowcase defaultShowcase];

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    [showcase performComputationalyIntensiveTaskOnCompletion:^(NSUInteger number) {
        result += number;
        dispatch_group_leave(group);
    }];

    dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        result += [NSNumber nthPrime:10000];
    });

    dispatch_group_enter(group);
    [showcase performComputationalyIntensiveTaskOnCompletion:^(NSUInteger number) {
        result += number;
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        hideActivityIndicator();
        [self setResult:result];
    });
}

- (void)calculateWithBlockOperation {
    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];

    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSUInteger number = [NSNumber nthPrime:10000];
        dispatch_async(dispatch_get_main_queue(), ^{
            hideActivityIndicator();
            [self setResult:number];
        });
    }];

    [self.operationQueue addOperation:operation];
}

- (void)calculateWithOperation {
    if (self.currentOperation) {
        [self.currentOperation cancel];
        return;
    }

    ComputationalyIntensiveOperation *operation = [[ComputationalyIntensiveOperation alloc] init];

    void (^hideActivityIndicator)(void) = [self showLoadingIndicatorUntilBlockCalled];

    __weak typeof(operation) weakOperation = operation;
    operation.completionBlock = ^{
        __strong typeof(operation) operation = weakOperation;
        dispatch_async(dispatch_get_main_queue(), ^{
            hideActivityIndicator();
            if (!operation.cancelled) {
                [self setResult:operation.result];
            }
        });
    };
    [self.operationQueue addOperation:operation];
    self.currentOperation = operation;
}

#pragma mark -

- (void (^)(void))showLoadingIndicatorUntilBlockCalled {
    __weak UIActivityIndicatorView *activityIndicator = self.activityIndicator;
    [activityIndicator startAnimating];
    return ^{
        [activityIndicator stopAnimating];
    };
}

- (void)setResult:(NSUInteger)number {
    self.resultLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.resultLabel.text = nil;
        } completion:nil];
    });
}

@end
