//
//  synchronizedLockDemo.m
//  09.1-多线程中的锁
//
//  Created by 刘光强 on 2020/2/12.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "synchronizedLockDemo.h"

@implementation synchronizedLockDemo

- (void)saleTicket {
    // 根据传递的slef生成对应的锁，传入不同的对象，生成不同的锁，底层是mutex 递归锁
    @synchronized (self) {
        [super saleTicket];
    }
}
@end
