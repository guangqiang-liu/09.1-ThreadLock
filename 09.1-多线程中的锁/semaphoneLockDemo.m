//
//  semaphoneLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "semaphoneLockDemo.h"

@interface semaphoneLockDemo ()

@property (nonatomic, strong) dispatch_semaphore_t semaphone;
@end

@implementation semaphoneLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _semaphone = dispatch_semaphore_create(3);
    }
    return self;
}

- (void)ticketTest {
    for (NSInteger i = 0; i < 20; i ++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (void)test {
    
    // 如果信号量的值>0，信号量的值就-1，然后执行后面的代码，DISPATCH_TIME_FOREVER：一直等
    // 如果信号量的值<=0，此时就进入休眠，等待信息量的值变成>0
    dispatch_semaphore_wait(self.semaphone, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"1212");
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphone);
}
@end
