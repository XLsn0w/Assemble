//
//  ViewController.m
//  Assemble
//
//  Created by TimeForest on 2019/1/16.
//  Copyright © 2019 TimeForest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_signal(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
//    当我们在处理多线程的时候，如果想控制并发线程的数量，我们会使用NSOperationQueue的maxConcurrentOperationCount来进行控制，所以遇到此类问题，我们一般会使用NSOperation+ NSOperationQueue来解决。
//    我们也可以使用GCD来解决这个问题，就是配合dispatch_semaphore来使用。
//    dispatch_semaphore就是信号量，在以前的Linux开发中就已经用过。信号量是一个整形值，在初始化的时候分配一个初始值，支持两个操作信号通知和等待。


//    当一个信号量被通知dispatch_semaphore_signal，计数会加1；
//    如果一个线程等待一个信号量dispatch_semaphore_wait，线程会被阻塞，直到计数器>0，此时开始运行，并且对信号量减1。
    
//    dispatch_semaphore_wait中的参数timeout表示超时时间，如果等待期间没有获取到信号量或者信号量的值一直为0，
//    那么等到timeout时，其所处线程自动执行其后语句。
//    可取值为：DISPATCH_TIME_NOW和 DISPATCH_TIME_FOREVER，我们也可以自己设置一个dispatch_time_t的时间值，表示超时时间为这个时间之后。
//
//
//
//    DISPATCH_TIME_NOW：超时时间为0，表示忽略信号量，直接运行
//    ** DISPATCH_TIME_FOREVER**：超时时间为永远，表示会一直等待信号量为正数，才会继续运行

    
    
}

/**获取用户权限列表**/
- (void)getUserPermissionData
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userId"] = [NSUserDefault objectForKey:UserId];
    params[@"sessionKey"] = [NSUserDefault objectForKey:SessionKey];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    params[@"data"] = dict.JSONString;
    
    [WGHttpTool postWithURL:RequestUrlStr(getFunctionListByUserId) parameters:params success:^(id json) {
        
        NSLog(@"获取用户权限列表");
        dispatch_semaphore_signal(sema);
        
    } failure:^(NSError *error) {
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

/**获取工作台配置数据**/
- (void)getDeskSettingData
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userId"] = [SNUserDefault objectForKey:UserId];
    params[@"sessionKey"] = [SNUserDefault objectForKey:SessionKey];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"type"] = @"1";
    dict[@"enabled"] = @"1";
    dict[@"workbenchConfigureVersion"] = @"2";
    params[@"data"] = dict.JSONString;
    
    [WGHttpTool postWithURL:RequestUrlStr(getUserWorkbenchConfigureListByCondition) parameters:params success:^(id json) {
        
        NSLog(@"获取工作台配置数据");
        dispatch_semaphore_signal(sema);
        
    } failure:^(NSError *error) {
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

/**获取工作台数据**/
- (void)getDeskDetailData
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userId"] = [SNUserDefault objectForKey:UserId];
    params[@"sessionKey"] = [SNUserDefault objectForKey:SessionKey];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"startIndex"] = @"0";
    dict[@"length"] = @"5";
    params[@"data"] = dict.JSONString;
    
    [WGHttpTool postWithURL:RequestUrlStr(getNewWorkbenchData) parameters:params success:^(id json) {
        
        NSLog(@"获取工作台数据");
        dispatch_semaphore_signal(sema);
        
    } failure:^(NSError *error) {
        
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    dispatch_group_t group = dispatch_group_create();
    ///这里有个注意点就是,如果你用的是全局队列的话,那么网络请求就不会按顺序执行了,所以这里的队列一定要自己手动创建
    dispatch_queue_t queue = dispatch_queue_create("com.xlsn0w.queue", DISPATCH_QUEUE_CONCURRENT);
    
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        
        [self getUserPermissionData];
    });
    
    dispatch_barrier_async(queue, ^{
        
    });
    
    dispatch_group_async(group, queue, ^{
        
        [self getDeskSettingData];
    });
    
    dispatch_barrier_async(queue, ^{
        
    });
    
    dispatch_group_async(group, queue, ^{
        
        [self getDeskDetailData];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"数据加载完成");
    });
}

@end
