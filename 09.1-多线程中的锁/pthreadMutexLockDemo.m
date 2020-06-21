//
//  pthreadMutexLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "pthreadMutexLockDemo.h"
#import <pthread.h>

@interface pthreadMutexLockDemo ()
    
@property (nonatomic, assign) pthread_mutex_t mutex;
@end

@implementation pthreadMutexLockDemo

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
        
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

- (void)saleTicket {
    // 加锁
    pthread_mutex_lock(&_mutex);
    
    [super saleTicket];
    
    // 解锁
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
}
@end
