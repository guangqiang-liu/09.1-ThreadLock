//
//  pthreadMutexConditionLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "pthreadMutexConditionLockDemo.h"
#import <pthread.h>

@interface pthreadMutexConditionLockDemo ()
    
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t con;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation pthreadMutexConditionLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 初始化属性
//        pthread_mutex_t attr;
//        pthread_mutexattr_init(&attr);
//        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
//
//        // 初始化锁
//        pthread_mutex_init(&_mutex, &attr);
//
//        // 销毁属性
//        pthread_mutexattr_destroy(&attr);
        
        // pthread_mutex_init 第二个参数可以参NULL
        pthread_mutex_init(&_mutex, NULL);
        pthread_cond_init(&_con, NULL);
        
        _data = [NSMutableArray array];
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
    pthread_mutex_lock(&_mutex);
    
    if (!self.data.count) {
        
        // 线程等待
        pthread_cond_wait(&_con, &_mutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"删除元素");
    
    // 解锁
    pthread_mutex_unlock(&_mutex);
}

- (void)add {
    // 加锁
    pthread_mutex_lock(&_mutex);
    
    [self.data addObject:@"111"];
    NSLog(@"添加元素");
    
    // 唤醒等待的线程
    pthread_cond_signal(&_con);
    
    // 解锁
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_con);
}
@end
