//
//  LockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/11.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "LockDemo.h"

@interface LockDemo ()

@property (nonatomic, assign) int ticketCount;
@end

@implementation LockDemo

- (void)saleTicket {
    
    int oldCount = self.ticketCount;
    sleep(.2);
    oldCount --;
    self.ticketCount = oldCount;
    
    NSLog(@"还剩=%d张票在%@=线程执行任务", self.ticketCount, [NSThread currentThread]);
}

- (void)ticketTest {
    self.ticketCount = 15;
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行任务1
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 5; i ++) {
            [self saleTicket];
        }
    });
    
    // 异步执行任务2
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 5; i ++) {
            [self saleTicket];
        }
    });
    
    // 异步执行任务3
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 5; i ++) {
            [self saleTicket];
        }
    });
}
@end
