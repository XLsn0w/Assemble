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
 * Plist文件
 * SQLite数据库文件
 * Keychain文件
 * 缓存文件
 * 日志文件
 
9、遇到过BAD_ACCESS的错误吗？你是怎样调试的？
 再次崩溃时会打印出如下
 
 -[__NSSetI release]: message sent to deallocated instance 0x1d4291b70
 
 如果崩溃是发生在当前调用栈，通过上面的做法，系统就会把崩溃原因定位到具体代码中。但是，如果崩溃不在当前调用栈，系统就仅仅只能把崩溃地址告诉我们，而没办法定位到具体代码，这样我们也没法去修改错误。这时就可以修改scheme，让xcode记录每个地址alloc的历史，这样我们就可以用命令把这个地址还原出来。如图：(跟设置NSZombieEnabled一样，添加MallocStackLoggingNoCompact，并且设置为YES)
 message sent to deallocated instance后会有一个内存地址，如:0×6497860,我们需要查看该地址的malloc history.查看方法，在原来的gdb下，使用”info malloc_history 0×6497860“即可显示malloc记录。但是新版的Xcode 不再支持，怎么办呢，我们还有terminal,使用终端的malloc_history命令，如”malloc_history 32009 0×6497860“即可显示。其中的32009是该进程的pid,根据这个malloc记录，可以大致定位出错信息的代码位置。
 Terminal中 输入
               malloc_history 32009 0xc9313d0 |grep 0xc9313d0
 
 
10、什么是指针常量和常量指针？
11、不借用第三个变量，如何交换两个变量的值？要求手动写出交换过程。
 a=b-a;
 
 b=b-a;
 
 a=b+a;这样就完成了a、b的交换，并且没有借助第三个变量，因为惯性思维，这种方法会很难被想到
 
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
 像UIKit这样大的框架上确保线程安全是一个重大的任务，会带来巨大的成本。UIKit不是线程安全的，假如在两个线程中设置了同一张背景图片，很有可能就会由于背景图片被释放两次，使得程序崩溃。或者某一个线程中遍历找寻某个subView，然而在另一个线程中删除了该subView，那么就会造成错乱。apple有对大部分的绘图方法和诸如UIColor等类改写成线程安全可用，可还是建议将UI操作保证在主线程中。事实上在子线程中如果要对其他UI 进行更新，必须等到该子线程运行结束，而对响应用户点击的Button的UI更新则是及时的，不管他是在主线程还是在子线程中做的更新，意义都不大了，因为子线程中对所有其他ui更新都要等到该子线程生命周期结束才进行。      在子线程中是不能进行UI 更新的，我们看到的UI更新其实是子线程代码执行完毕了，又自动进入到了主线程，执行了子线程中的UI更新的函数栈，这中间的时间非常的短，就让大家误以为分线程可以更新UI。如果子线程一直在运行，则子线程中的UI更新的函数栈 主线程无法获知，即无法更新。只有极少数的UI能直接进行UI更新，因为开辟线程时会获取当前环境，如点击某个按钮，这个按钮响应的方法是开辟一个子线程，在子线程中对该按钮进行UI 更新是能及时的，如上面的换背景图，但这没有任何意义。在子线程刷新UI，一旦出错，会造成我们无法解决的困难！

 */
