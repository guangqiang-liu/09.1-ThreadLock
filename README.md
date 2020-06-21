# 09.1-多线程中的各种锁操作

我们在平时的开发过程中可能会遇到多个线程并发同时访问同一资源的情况，例如数据库的存取操作，或者是文件的读写操作，像这种多个线程同时访问同一资源就会容易产生资源竞争，导致数据错乱的问题，解决这种问题我们一般会选择使用线程同步技术，也就是对这同一资源进行加锁解锁操作，iOS中的锁主要有以下几种：

* OSSpinLock(在iOS10已经废弃了)
* os_unfair_lock
* pthread_mutex_t
* pthread_cond_t
* NSLock
* NSConditionLock
* @synchronized
* dispatch_semaphore_t：信号量也可以作为锁来使用
* dispatch_sync(DISPATCH_QUEUE_SERIAL)：使用串行同步队列也可以作为锁来使用

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093033@2x.png)

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093112@2x.png)

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093137@2x.png)

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093214@2x.png)

下面我们就逐一对上面列出的锁进行简单地使用示例说明

`OSSpinLock`基本用法：

```
@interface OSSpinLockDemo ()

@property (nonatomic, assign) OSSpinLock ossLock;
@end

@implementation OSSpinLockDemo

- (instancetype)init {
    if (self = [super init]) {
    		// 初始化自旋锁
        _ossLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)test {
    
    // 加锁
    OSSpinLockLock(&_ossLock);
    
    // 需要加锁的代码放在加锁和解锁语句中间，例如下面的NSLog打印
    NSLog(@"加锁代码");
    
    // 解锁
    OSSpinLockUnlock(&_ossLock);
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093738@2x.png)

`os_unfair_lock`基本用法：

```
@interface OSUnfairLockDemo ()

@property (nonatomic, assign) os_unfair_lock lock;
@end

@implementation OSUnfairLockDemo

- (instancetype)init {
    if (self = [super init]) {
    	// 初始化锁
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)test {
    // 加锁
    os_unfair_lock_lock(&_lock);
    
    // 需要加锁的代码
    
    // 解锁
    os_unfair_lock_unlock(&_lock);
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093555@2x.png)

`pthread_mutex_t`基本用法：

```
@interface pthreadMutexLockDemo ()
    
@property (nonatomic, assign) pthread_mutex_t mutex;
@end

@implementation pthreadMutexLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // 初始化属性
//        pthread_mutex_t attr;
//        pthread_mutexattr_init(&attr);
			// PTHREAD_MUTEX_DEFAULT：是普通互斥锁
			// PTHREAD_MUTEX_RECURSIVE：递归锁
//        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
//
//        // 初始化锁
//        pthread_mutex_init(&_mutex, &attr);
//
//        // 销毁属性
//        pthread_mutexattr_destroy(&attr);
        
        // 最简单的初始化方式是第二个参数直接填NULL即可
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

- (void)test {
    // 加锁
    pthread_mutex_lock(&_mutex);
    
    // 需要加锁的代码
    
    // 解锁
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc {
	// 销毁锁
    pthread_mutex_destroy(&_mutex);
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093611@2x.png)

`pthread_cond_t`基本使用：

```
@interface pthreadMutexConditionLockDemo ()
    
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t con;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation pthreadMutexConditionLockDemo

- (instancetype)init {
    if (self = [super init]) {
        // pthread_mutex_init 第二个参数可以参NULL
        pthread_mutex_init(&_mutex, NULL);
        pthread_cond_init(&_con, NULL);
        
        _data = [NSMutableArray array];
    }
    return self;
}

- (void)test {
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
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093641@2x.png)

`NSLock`基本用法：

```
@interface NSLockDemo ()

@property (nonatomic, strong) NSLock *lock;
@end

@implementation NSLockDemo

- (instancetype)init {
    if (self = [super init]) {
    		// 初始化锁
        _lock = [[NSLock alloc] init];
    }
    return self;
}

- (void)test {
	 // 加锁
    [self.lock lock];
    
    // 加锁的代码
    
    // 解锁
    [self.lock unlock];
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-093656@2x.png)

`NSConditionLock`：基本用法

```
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

- (void)test {
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
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-095730@2x.png)

`@synchronized`基本用法：

```
@implementation synchronizedLockDemo

- (void)test {
    // 根据传递的slef生成对应的锁，传入不同的对象生成不同的锁，底层是mutex 递归锁
    @synchronized (self) {
        // 需要加锁的代码
    }
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-100032@2x.png)

`dispatch_semaphore_t`基本用法：

```
@interface semaphoneLockDemo ()

@property (nonatomic, strong) dispatch_semaphore_t semaphone;
@end

@implementation semaphoneLockDemo

- (instancetype)init {
    if (self = [super init]) {
    		// 初始化信号量，1表示同时只能有1个线程来执行任务
        _semaphone = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)test {
    for (NSInteger i = 0; i < 20; i ++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(doTask) object:nil] start];
    }
}

- (void)doTask {
    
    // 如果信号量的值>0，信号量的值就-1，然后执行后面的代码，DISPATCH_TIME_FOREVER：一直等
    // 如果信号量的值<=0，此时就进入休眠，等待信息量的值变成>0
    dispatch_semaphore_wait(self.semaphone, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"1212");
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphone);
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-095753@2x.png)

`dispatch_sync(DISPATCH_QUEUE_SERIAL)`基本用法：

```
@interface SerialQueueLockDemo ()

@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@end

@implementation SerialQueueLockDemo

- (instancetype)init {
    if (self = [super init]) {
        _tickeetQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)test {
    dispatch_sync(self.tickeetQueue, ^{
        // 加锁的代码
    });
}
@end
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-100632@2x.png)

上面我们列举了iOS中的几种锁，但是有的锁已经废弃了，有的锁性能上存在些问题，那么我们在平时的开发中会选用哪种锁来使用比较合适尼，这里根据大量的三方框架和苹果底层框架中使用到的锁的情况来看，`NSLock`，`pthread_mutex`，`dispatch_semaphore`是出现频次最多的

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-101458@2x.png)

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-101511@2x.png)

---

上面我们介绍的这些锁对于多个异步线程同时访问同一资源时，使用这些锁来进行线程同步确实是可以解决问题，但是如果我们是对文件进行读写操作，这时上面的锁就不太适合使用了，因为文件读写操作的特点是可以同时读，但是不能同时写，也不能在读的时候进行写操作，也不能在写的时候进行读操作，所以就有了下面的两种专门处理文件读写操作的锁：

* pthread_rwlock_t
* dispatch_barrier_async：异步栅栏也可以解决文件读写操作

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-101831@2x.png)

`pthread_rwlock_t`基本用法：

```
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
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-101901@2x.png)

`dispatch_barrier_async`：基本用法：

```
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
```

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200213-101914@2x.png)


讲解示例Demo地址：[https://github.com/guangqiang-liu/09.1-ThreadLock]()


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* iOS组件化开发实战项目(500+star)：**[https://github.com/guangqiang-liu/iOS-Component-Pro]()**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习