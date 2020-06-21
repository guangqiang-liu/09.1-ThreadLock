//
//  OSSpinLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/11.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo ()

@property (nonatomic, assign) OSSpinLock ossLock;
@end

@implementation OSSpinLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _ossLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)saleTicket {
    
    // 加锁，多线程加锁的原理就是造成线程阻塞，线程阻塞可以是线程休眠阻塞或者是线程while(1)死循环阻塞
    OSSpinLockLock(&_ossLock);
    
    [super saleTicket];
    
    // 解锁
    OSSpinLockUnlock(&_ossLock);
}
@end
