//
//  ViewController.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/11.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "ViewController.h"
#import "OSSpinLockDemo.h"
#import "OSUnfairLockDemo.h"
#import "pthreadMutexLockDemo.h"
#import "pthreadMutexConditionLockDemo.h"
#import "NSLockDemo.h"
#import "NSConditionLockDemo.h"
#import "SerialQueueLockDemo.h"
#import "semaphoneLockDemo.h"
#import "synchronizedLockDemo.h"
#import "pthread_rwlockDemo.h"
#import "dispatch_barrier_asyncDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OSSpinLockDemo *sspLock = [[OSSpinLockDemo alloc] init];
    [sspLock ticketTest];
    
//    OSUnfairLockDemo *unfairLock = [[OSUnfairLockDemo alloc] init];
//    [unfairLock ticketTest];
    
//    pthreadMutexLockDemo *pthreadMutexDemo = [[pthreadMutexLockDemo alloc] init];
//    [pthreadMutexDemo ticketTest];
    
//    pthreadMutexConditionLockDemo *mutexConLock = [[pthreadMutexConditionLockDemo alloc] init];
//    [mutexConLock ticketTest];
    
//    NSLockDemo *nslock = [[NSLockDemo alloc] init];
//    [nslock ticketTest];
    
//    NSConditionLockDemo *conLock = [[NSConditionLockDemo alloc] init];
//    [conLock ticketTest];
    
//    SerialQueueLockDemo *serialQueue = [[SerialQueueLockDemo alloc] init];
//    [serialQueue ticketTest];
    
//    semaphoneLockDemo *semophoneLock = [[semaphoneLockDemo alloc] init];
//    [semophoneLock ticketTest];
    
//    synchronizedLockDemo *synchLock = [[synchronizedLockDemo alloc] init];
//    [synchLock ticketTest];
    
//    pthread_rwlockDemo *rwlock = [[pthread_rwlockDemo alloc] init];
//    [rwlock test];
    
//    dispatch_barrier_asyncDemo *barrierAsync = [[dispatch_barrier_asyncDemo alloc] init];
//    [barrierAsync test];
}
@end
