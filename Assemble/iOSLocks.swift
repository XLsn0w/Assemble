//
//  iOSLocks.swift
//  Assemble
//
//  Created by XLsn0w on 2019/2/17.
//  Copyright © 2019 TimeForest. All rights reserved.
//

/*
 
 iOS中的锁包括：
 @synchronized
 NSLock
 NSCondition
 NSConditionLock
 NSRecursiveLock
 pthread_mutex_t
 dispatch_semaphore_t
 OSSpinLock
 
 
 互斥锁: 是一种用于多线程编程中，防止两条线程同时对同一公共资源（比如全局变量）进行读写的机制。该目的通过将代码切片成一个一个的临界区而达成。
 互斥锁可以说是dispatch_semaphore在仅取值0/1时的特例
 
 1.NSLock：是Foundation框架中以对象形式暴露给开发者的一种锁，
 （Foundation框架同时提供了NSConditionLock，NSRecursiveLock，NSCondition）
 NSLock定义如下
 
 
 2.@synchronized ///防止不同的线程同时执行同一段代码。
 - (BOOL)isNetworkActivityOccurring {
 @synchronized(self) {
 return self.activityCount > 0;
 }
 }
 
 自旋锁：是用于多线程同步的一种锁，线程反复检查锁变量是否可用。
 由于线程在这一过程中保持执行，因此是一种忙等待。一旦获取了自旋锁，线程会一直保持该锁，直至显式释放自旋锁。
 自旋锁避免了进程上下文的调度开销，因此对于线程只会阻塞很短时间的场合是有效的。
 
 1.OSSpinLock  ///已经弃用
 2. os_unfair_lock 是苹果官方推荐的替换OSSpinLock的方案，但是它在iOS10.0以上的系统才可以调用。
 
 读写锁
 
 上文有说到，读写锁又称共享-互斥锁，
 pthread_rwlock：
 
 
 递归锁
 
 递归锁有一个特点，就是同一个线程可以加锁N次而不会引发死锁。
 1.NSRecursiveLock:
 
 条件锁
 
 1. NSCondition:
 
 - (void)wait;
 - (BOOL)waitUntilDate:(NSDate *)limit;
 - (void)signal;
 - (void)broadcast;
 
 遵循NSLocking协议，使用的时候同样是lock,unlock加解锁，
 wait是傻等，
 waitUntilDate:方法是等一会，都会阻塞掉线程，
 signal是唤起一个在等待的线程，
 broadcast是广播全部唤起。
 
 NSConditionLock
 
 - (void)lockWhenCondition:(NSInteger)condition;
 - (BOOL)tryLock;
 - (BOOL)tryLockWhenCondition:(NSInteger)condition;
 - (void)unlockWithCondition:(NSInteger)condition;
 - (BOOL)lockBeforeDate:(NSDate *)limit;
 - (BOOL)lockWhenCondition:(NSInteger)condition beforeDate:(NSDate *)limit;
 
 
 GCD信号量: 是一种更高级的同步机制，互斥锁可以说是dispatch_semaphore在仅取值0/1时的特例。信号量可以有更多的取值空间，用来实现更加复杂的同步，而不单单是线程间互斥。
 
 dispatch_semaphore:
 
 */
