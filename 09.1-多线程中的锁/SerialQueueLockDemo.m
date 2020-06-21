//
//  SerialQueueLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "SerialQueueLockDemo.h"

@interface SerialQueueLockDemo ()

@property (nonatomic, strong) dispatch_queue_t tickeetQueue;
@end

@implementation SerialQueueLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _tickeetQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)saleTicket {
    dispatch_sync(self.tickeetQueue, ^{
        [super saleTicket];
    });
}
@end
