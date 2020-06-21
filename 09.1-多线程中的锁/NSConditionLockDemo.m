//
//  NSConditionLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "NSConditionLockDemo.h"

@interface NSConditionLockDemo ()
    
@property (nonatomic, strong) NSConditionLock *conLock;
@end

@implementation NSConditionLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        _conLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)ticketTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(remove) object:nil] start];
    
    sleep(2);
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(add) object:nil] start];
}

- (void)remove {
    // 加锁
    [self.conLock lockWhenCondition:1];
    
    NSLog(@"删除元素");
    
    // 解锁
    [self.conLock unlockWithCondition:2];
}

- (void)add {
    
    // 加锁
    [self.conLock lockWhenCondition:2];
    
    NSLog(@"添加元素");

    // 解锁
    [self.conLock unlock];
}
@end
