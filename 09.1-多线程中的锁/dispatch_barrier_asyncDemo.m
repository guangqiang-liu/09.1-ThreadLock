//
//  dispatch_barrier_asyncDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "dispatch_barrier_asyncDemo.h"

@interface dispatch_barrier_asyncDemo ()

@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation dispatch_barrier_asyncDemo

- (void)test {
    // 创建一个并发队列，注意：这里使用dispatch_barrier_async只能使用`dispatch_queue_create`创建一个并发队列，不能使用全局并发队列
    self.queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 10; i ++) {
        [self read];
        [self read];
        [self read];
        [self read];
        [self write];
    }
}

- (void)read {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"开始读");
    });
}

- (void)write {
    dispatch_barrier_async(self.queue, ^{
        // 开始加锁
        sleep(1);
        NSLog(@"开始写");
    });
}
@end
