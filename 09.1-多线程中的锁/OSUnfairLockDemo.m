//
//  OSUnfairLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

@interface OSUnfairLockDemo ()

@property (nonatomic, assign) os_unfair_lock lock;
@end

@implementation OSUnfairLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)saleTicket {
    // 加锁
    os_unfair_lock_lock(&_lock);
    
    [super saleTicket];
    // 解锁
    os_unfair_lock_unlock(&_lock);
}
@end
