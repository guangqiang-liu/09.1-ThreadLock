//
//  pthread_rwlockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "pthread_rwlockDemo.h"
#import "pthread.h"

@interface pthread_rwlockDemo ()

@property (nonatomic, assign) pthread_rwlock_t rwlock;
@end

@implementation pthread_rwlockDemo

- (void)test {
    // 初始化锁
    pthread_rwlock_init(&_rwlock, NULL);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self read];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self write];
        });
    }
}

- (void)read {
    
    // 读加锁
    pthread_rwlock_rdlock(&_rwlock);
    
    sleep(1);
    
    NSLog(@"开始读");
    
    // 解锁
    pthread_rwlock_unlock(&_rwlock);
}

- (void)write {
    // 写加锁
    pthread_rwlock_wrlock(&_rwlock);
    
    sleep(1);
    
    NSLog(@"开始写");
    
    // 解锁
    pthread_rwlock_unlock(&_rwlock);
}

- (void)dealloc {
    // 销毁锁
    pthread_rwlock_destroy(&_rwlock);
}
@end
