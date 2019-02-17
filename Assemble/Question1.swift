//
//  Question1.swift
//  Assemble
//
//  Created by XLsn0w on 2019/2/17.
//  Copyright © 2019 TimeForest. All rights reserved.
//
/*

1、说一下Objective-C的反射机制；
 系统Foundation框架为我们提供了一些方法反射的API，我们可以通过这些API执行将字符串转为SEL等操作。由于OC语言的动态性，这些操作都是发生在运行时的。
 // SEL和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromSelector(SEL aSelector);
 FOUNDATION_EXPORT SEL NSSelectorFromString(NSString *aSelectorName);
 // Class和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromClass(Class aClass);
 FOUNDATION_EXPORT Class __nullable NSClassFromString(NSString *aClassName);
 // Protocol和字符串转换
 FOUNDATION_EXPORT NSString *NSStringFromProtocol(Protocol *proto) NS_AVAILABLE(10_5, 2_0);
 FOUNDATION_EXPORT Protocol * __nullable NSProtocolFromString(NSString *namestr) NS_AVAILABLE(10_5, 2_0);
 通过这些方法，我们可以在运行时选择创建那个实例，并动态选择调用哪个方法。这些操作甚至可以由服务器传回来的参数来控制，我们可以将服务器传回来的类名和方法名，实例为我们的对象。
 // 假设从服务器获取JSON串，通过这个JSON串获取需要创建的类为ViewController，并且调用这个类的getDataList方法。
 Class class = NSClassFromString(@"ViewController");
 ViewController *vc = [[class alloc] init];
 SEL selector = NSSelectorFromString(@"getDataList");
 [vc performSelector:selector];
 
 反射机制使用技巧
 
 假设有一天公司产品要实现一个需求：根据后台推送过来的数据，进行动态页面跳转，跳转到页面后根据返回到数据执行对应的操作。///类名和方法名
 
2、block的实质是什么？有几种block？分别是怎样产生的？
 A：block就是一个结构体，里面有isa指针指向自己的类（global malloc stack），有desc结构体描述block的信息，__forwarding指向自己或堆上自己的地址，如果block对象截获变量，这些变量也会出现在block结构体中。最重要的block结构体有一个函数指针，指向block代码块。block结构体的构造函数的参数，包括函数指针，描述block的结构体，自动截获的变量（全局变量不用截获），引用到的__block变量。(__block对象也会转变成结构体)
 block代码块在编译的时候会生成一个函数，函数第一个参数是前面说到的block对象结构体指针。执行block，相当于执行block里面__forwarding里面的函数指针。
 
 
3、__block修饰的变量为什么能在block里面能改变其值？
 __block 所起到的作用就是只要观察到该变量被 block 所持有,就将“外部变量”在栈中的内存地址放到了堆中。进而在block内部也可以修改外部变量的值。
 
4、说一下线程之间的通信。
 //开启一个全局队列的子线程
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 //1. 开始请求数据
 //...
    // 2. 数据请求完毕
    //我们知道UI的更新必须在主线程操作，所以我们要从子线程回调到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
 
    //我已经回到主线程更新
   });
 
 });
 
5、你们应用的崩溃率是多少？
6、说一下hash算法。
 散列表（Hash table，也叫哈希表），是依据关键码值(Key value)而直接进行訪问的数据结构。也就是说，它通过把关键码值映射到表中一个位置来訪问记录，以加快查找的速度。这个映射函数叫做散列函数，存放记录的数组叫做散列表。
 
7、NSDictionary的实现原理是什么？
 
8、你们的App是如何处理本地数据安全的（比如用户名的密码）？
 
9、遇到过BAD_ACCESS的错误吗？你是怎样调试的？
10、什么是指针常量和常量指针？
11、不借用第三个变量，如何交换两个变量的值？要求手动写出交换过程。
12、若你去设计一个通知中心，你会怎样设计？
13、如何去设计一个方案去应对后端频繁更改的字段接口？
14、KVO、KVC的实现原理
15、用递归算法求1到n的和
16、category为什么不能添加属性？
17、说一下runloop和线程的关系。
18、说一下autoreleasePool的实现原理。
19、说一下简单工厂模式，工厂模式以及抽象工厂模式？
20、如何设计一个网络请求库？
21、说一下多线程，你平常是怎么用的？
22、说一下UITableViewCell的卡顿你是怎么优化的？
23、看过哪些三方库？说一下实现原理以及好在哪里？
24、说一下HTTP协议以及经常使用的code码的含义。
25、设计一套缓存策略。
26、设计一个检测主线和卡顿的方案。
27、说一下runtime，工作是如何使用的？看过runtime源码吗？
28、说几个你在工作中使用到的线程安全的例子。
29、用过哪些锁？哪些锁的性能比较高？
30、说一下HTTP和HTTPs的请求过程？
31、说一下TCP和UDP
32、说一下静态库和动态库之间的区别
33、load和initialize方法分别在什么时候调用的？
34、NSNotificationCenter是在哪个线程发送的通知？
35、用过swift吗？如果没有，平常有学习吗？
36、说一下你对架构的理解？
37、为什么一定要在主线程里面更新UI？

 */
