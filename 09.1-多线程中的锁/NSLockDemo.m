//
//  NSLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "NSLockDemo.h"

@interface NSLockDemo ()

@property (nonatomic, strong) NSLock *lock;
@end

@implementation NSLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)saleTicket {
    [self.lock lock];
    
    [super saleTicket];
    
    [self.lock unlock];
}
@end
