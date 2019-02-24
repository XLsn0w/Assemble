# 终端 命令行

Objective C源文件(.m)的编译器是Clang + LLVM，Swift源文件的编译器是swift + LLVM。

所以借助clang命令，我们可以查看一个.c或者.m源文件的汇编结果

> clang -S AppDelegate.m

这是是x86架构的汇编，对于ARM64我们可以借助xcrun，

> xcrun --sdk iphoneos clang -S -arch arm64 AppDelegate.m

然后转化成ViewController.s文件


# 源码分析

### UITableView+FDTemplateLayoutCell

主要是一个缓存cell高度的控件，作者孙源博客讲解地址[http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/)

技术点：

- 采用一个多维数组缓存cell的高度

- 缓存删除策略，当调用reloadview的时候清楚缓存

实现方案是Hook住TableView的reloadData等主要方法，调用之前清楚原来的缓存


### ReactiveCocoa

ReactiveCocoa包含三部分

#### Result

Result是一个枚举类型，主要包含一下两种类型

```swift
case success(T)
case failure(Error)
```

里边还包含了analysis函数，参数接受两个Block

```swift
func analysis<U>(ifSuccess: (Value) -> U, ifFailure: (Error) -> U) -> U
```

#### ReactiveCocoa

#### ReactiveSwift

- Reactive.swift

Reactive是一个带有泛型类型的结构体，结构体中base是泛型类型，ReactiveExtensionsProvider协议中包含这个结构体。

```swift
public struct Reactive<Base> {
public let base: Base
}
```

​
​
​- Event.swift
​
​Event是一个枚举,表示Signal的状态
​
```
swift
​public enum Event<Value, Error: Swift.Error> {
​case value(Value)
​case failed(Error)
​case completed
​case interrupted
​}
​
```
​
​- Observer.swift
​
​Observer是一个类，里边有Action类型变量，Action是一个Block
​
```
swift
​public typealias Action = (Event<Value, Error>) -> Void
```
​
​Observer有一系列send函数，函数作用就是执行action
​
​
​
​
​### Alamofire
​
​- 每一个Request都有一个delegate: TaskDelegate
​
​- 每一个TaskDelegate都有一个串行队列queue，且队列是挂起状态的
​
```
​init(task: URLSessionTask?) {
​self.task = task
​
​self.queue = {
​let operationQueue = OperationQueue()
​
​operationQueue.maxConcurrentOperationCount = 1
​operationQueue.isSuspended = true //挂起状态
​operationQueue.qualityOfService = .utility
​
​return operationQueue
​}()
​}
```
​
​- SessionManager负责创建和管理Request对象和他的`NSURLSession`。SessionManager有一个`open let delegate: SessionDelegate`SessionDelegate管理所有的网络回调
​
​- 当调用`Alamofire.request(urlRequest)`时调用堆栈
​

```
​- Alamofire.request(urlRequest)
​- SessionManager.default.request(urlRequest)
​- DataRequest: request.resume()
​- URLSessionTask: task.resume()
​
​- 当SessionDelegate（实现了URLSessionTaskDelegate方法）收到网络回调时会调用DataTaskDelegate（集成TaskDelegate）的代理
```

```
​delegate.urlSession(session, task: task, didCompleteWithError: error)
```
​
​- DataTaskDelegate会把悬挂的队列启动queue.isSuspended = false
​

```
​@objc(URLSession:task:didCompleteWithError:)
​func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
​if let taskDidCompleteWithError = taskDidCompleteWithError {
​taskDidCompleteWithError(session, task, error)
​} else {
​.....
​
​queue.isSuspended = false
​}
​}
```
​
​- 当调用responseJSON时就是向TaskDelegate的队列中添加处理返回值的任务。调用堆栈如下：
​
```
​delegate.queue.addOperation {
​let result = responseSerializer.serializeResponse(
​self.request,
​self.response,
​self.delegate.data,
​self.delegate.error
​)
​
​var dataResponse = DataResponse<T.SerializedObject>(
​request: self.request,
​response: self.response,
​data: self.delegate.data,
​result: result,
​timeline: self.timeline
​)
​
​dataResponse.add(self.delegate.metrics)
​
​(queue ?? DispatchQueue.main).async { completionHandler(dataResponse) }
​}
​
```
​
​​
​​
​​
​​### copy、mutableCopy
​​
​​- 容器的copy和mutablecopy都是浅拷贝，只是拷贝结果是可变还是不可变区别
​​- [array copy]   不可变数组                                        // 指针copy,容器指向同一个
​​- [array mutableCopy]   可变数组                            // 指针copy,容器单层浅copy
​​- [mutableArray mutableCopy]   可变数组             // 指针copy,容器单层浅copy
​​- [mutableArray copy]   不可变数组                         // 指针copy,容器单层浅copy
​​
​​- 字符串拷贝
​​- NSString [str copy]字符串
​​- copy不会创建新的对象
​​
​​- mutableCopy会创建新的对象
​​- NSMutableString [str copy]字符串
​​- copy、mutableCopy都会创建新的对象
​​
​​
​​### UITableview的优化方法
​​
​​（缓存高度，异步绘制，减少层级，hide，避免离屏渲染）
​​
​​### Delegate、Notification使用场景
​​
​​#### 区别
​​1. 代理可以获得接受者的返回值，通知只是简单的通知对方不会拿到接受后的结果
​​2. 通知可以是一对多、多对多，多对一，只要注册了就可以获得相应的通知；代理则是一对n的，设置delege后需要实现相应的代理方法；
​​3. 通知使用时需要借助第三方通知中心来实现消息传递，而代理则不需要；
​​#### 使用场景
​​
​​- Delegate
​​1. 回调方法
​​日常开发中的网络请求和页面加载后的回调一般会使用delegate或者block.采用deleagte一般会有多个接受对象，而block一般是一对一的。
​​2. UI相应或者自定义UI控件
​​自定义控件需要使用者提供数据源或者相应通知使用者时会使用delegate，像TableView的delegate和datasource。
​​- 通知
​​1. 一般在跨层之间或者两个毫不相关的模块间通信会使用通知，可以减少代码的耦合度。
​​2. 如果多个地方相同的变化需要通知一个对象时，采用通知
​​
​​### 分类和集成使用场景
​​
​​#### 必须使用继承的情况
​​
​​- 需要扩展的方法与原方法同名，但是还需要使用父类的方法。
​​- 需要扩展属性，一般选择集成。当然分类通过运行时也可以添加关联属性。
​​
​​#### 分类使用情况
​​
​​- 分类可以实现把方法分组的不同的单独文件中。
​​
​​- 减少单个文件的体积
​​- 可以把不同的功能组织到不同的category里
​​- 可以按需加载不同的category
​​
​​- 针对系统提供的类扩展一些工具方法，而不改变原有类。
​​
​​- 把framework的私有方法公开
​​
​​- 模拟多继承
​​
​​利用OC的消息转发实现多继承，在分类中实现`methodSignatureForSelector`
​​
​​和`forwardInvocation`。 
​​
​​​
​​​
​​​下面以UIViewController的多继承NSString的UTF8String函数为例，
​​​
```
​​​@implementation UIViewController (Mutable)
​​​- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
​​​NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
​​​if (!sig) {
​​​sig = [self.title methodSignatureForSelector:aSelector];
​​​}
​​​return sig;
​​​}
​​​- (void)forwardInvocation:(NSInvocation *)anInvocation{
​​​SEL selector = [anInvocation selector];
​​​if ([self.title respondsToSelector:selector]) {
​​​[anInvocation invokeWithTarget:self.title];
​​​}
​​​}
​​​@end
```
​​​
​​​
​​​#### 分类的原理
​​​
​​​- 分类也是一个结构体
​​​
```
​​​struct objc_category {
​​​char * _Nonnull category_name                            
​​​char * _Nonnull class_name                               
​​​struct objc_method_list * _Nullable instance_methods     
​​​struct objc_method_list * _Nullable class_methods        
​​​struct objc_protocol_list * _Nullable protocols          
​​​}                                                            
```
​​​
​​​- 从category的定义也可以看出category的可为（可以添加实例方法，类方法，甚至可以实现协议）和不可为（原则上讲它只能添加方法，不能添加属性(成员变量)，不过可以通过运行时添加关联属性）
​​​- 分类中的可以写@property, 但不会生成`setter/getter`方法, 也不会生成实现以及私有的成员变量（编译时会报警告）; 
​​​
​​​- 运行时做的事情
​​​
​​​- 把category的实例方法、协议以及属性添加到类上
​​​- 把category的类方法和协议添加到类的元类上
​​​- 如果多个分类中都有和原有类中同名的方法, 那么调用该方法的时候执行谁由编译器决定；编译器会执行最后一个参与编译的分类中的方法。
​​​- category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
​​​- category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休，殊不知后面可能还有一样名字的方法。
​​​
​​​
​​​
​​​### ARC下内存管理场景
​​​
​​​- Block防止循环引用
​​​
​​​
​​​- for循环中占用内存大，合理使用`@autoreleasepool{}`
​​​- 合理使用NSTimer,如果Timer是ViewController的成员变量，需要在dealloc中调用invalidate和设置nil;
​​​- 通知使用时记得页面销毁时注销通知
​​​- 理解copy和mutableCopy
​​​- 代理使用weak修饰
​​​- block和字符串使用copy修饰符
​​​
​​​
​​​### KVO底层实现原理
​​​
​​​- KVO是基于runtime机制实现的
​​​- 当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
​​​- 如果原类为Person，那么生成的派生类名为NSKVONotifying_Person
​​​- 每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
​​​- 键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
​​​
​​​>  补充：KVO的这套实现机制中苹果还偷偷重写了class方法，让我们误认为还是使用的当前类，从而达到隐藏生成的派生类
​​​
​​​
​​​
​​​
​​​
​​​### weak实现原理概括
​​​
​​​Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象指针的地址）数组。
​​​
​​​文章：http://www.jianshu.com/p/13c4fb1cedea
​​​
​​​https://www.desgard.com/weak/
​​​
​​​
​​​
​​​### ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些
​​​
​​​1. 对应基本数据类型默认关键字是   atomic,readwrite,assign
​​​
​​​2. 对于普通的 Objective-C 对象   atomic,readwrite,strong
​​​
​​​
​​​
​​​### 什么时候会报unrecognized selector的异常？
​​​
​​​objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行，如果，在最顶层的父类中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常unrecognized selector sent to XXX 。但是在这之前，objc的运行时会给出三次拯救程序崩溃的机会：
​​​
​​​1. Method resolution
​​​
​​​objc运行时会调用`+resolveInstanceMethod:`或者 `+resolveClassMethod:`，让你有机会提供一个函数实现。如果你添加了函数，那运行时系统就会重新启动一次消息发送的过程，否则 ，运行时就会移到下一步，消息转发（Message Forwarding）。
​​​
​​​2. Fast forwarding
​​​
​​​如果目标对象实现了`-forwardingTargetForSelector:`，Runtime 这时就会调用这个方法，给你把这个消息转发给其他对象的机会。 只要这个方法返回的不是nil和self，整个消息发送的过程就会被重启，当然发送的对象会变成你返回的那个对象。否则，就会继续Normal Fowarding。 这里叫Fast，只是为了区别下一步的转发机制。因为这一步不会创建任何新的对象，但下一步转发会创建一个NSInvocation对象，所以相对更快点。 
​​​
​​​3. Normal forwarding
​​​
​​​这一步是Runtime最后一次给你挽救的机会。首先它会发送`-methodSignatureForSelector:`消息获得函数的参数和返回值类型。如果`-methodSignatureForSelector:`返回nil，Runtime则会发出`-doesNotRecognizeSelector:`消息，程序这时也就挂掉了。如果返回了一个函数签名，Runtime就会创建一个NSInvocation对象并发送`-forwardInvocation:`消息给目标对象。
​​​
​​​
​​​
​​​### 典型的内存空间布局
​​​
​​​从低地址到高地址依次为：代码区、只读常量区、全局区/数据区、BSS段、堆区、栈区。
​​​
​​​- 代码区：存放可执行指令。
​​​
​​​- 只读常量区：存放字面值常量、具有常属性且被初始化的全局和静态局部变量（如：字符串字面值、被const关键字修饰的全局变量和被const关键字修饰的静态局部变量）。
​​​
​​​- 全局区/数据区：存放已初始化的全局变量和静态局部变量。
​​​
​​​- BBS段：存放未初始化的全局变量和静态局部变量，并把它们的值初始化为0。
​​​
​​​- 堆区：存放动态分配的内存。
​​​
​​​- 栈区：自动变量和函数调用时需要保存的信息（逆向分析的重点）
​​​
​​​> 代码区和只读常量区一般统称为代码段
​​​>
​​​>  栈区和堆区之间相对生长的，堆区的分配一般按照地址从小到大进行，而栈区的分配一般按照地址从大到小进行分配。
​​​
​​​
​​​
​​​
​​​### 事件传递响应链
​​​
​​​http://www.cocoachina.com/ios/20160113/14896.html
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​继续研究的：
​​​
​​​https://zhuanlan.zhihu.com/p/22834934
​​​
​​​https://www.zhihu.com/question/19604641
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​面试github整理
​​​
​​​https://github.com/ChenYilong
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​
​​​## 网络协议
​​​
​​​### TCP
​​​
​​​尽管 T C P 和 U D P 都使用相同的网络层( I P )， T C P 却向应用层提供与 U D P 完全不同的服务。T C P 提供一种面向连接的、可靠的字节流服务。
​​​
​​​面向连接意味着两个使用 T C P 的 应 用 ( 通 常 是 一 个 客 户 和 一 个 服 务 器 ) 在 彼 此 交 换 数 据之前必须先建立一个 T C P 连 接 。 这 一 过 程 与 打 电 话 很 相 似 ， 先 拨 号 振 铃 ， 等 待 对 方 摘 机 说“喂”，然后才说明是谁。
​​​
​​​在一个 T C P 连接中，仅有两方进行彼此通信。在第 1 2 章介绍的广播和多播不能用于 T C P 。
​​​
​​​
​​​
​​​T C P 通过下列方式来提供可靠性:
​​​
​​​- 应用数据被分割成 T C P 认为最适合发送的数据块。这和 U D P 完 全 不 同 ， 应 用 程 序 产 生 的
​​​
​​​数据报长度将保持不变。由 T C P传递给 I P 的信息单位称为报文段或段( s e g m e n t )(参见
​​​
​​​图 1 - 7 )。在 1 8 . 4 节我们将看到 T C P 如何确定报文段的长度。
​​​
​​​- 当 T C P发 出 一 个 段 后 ， 它 启 动 一 个 定 时 器 ， 等 待 目 的 端 确 认 收 到 这 个 报 文 段 。 如 果 不 能
​​​
​​​及时收到一个确认，将重发这个报文段。在第 2 1 章我们将了解 T C P 协 议 中 自 适 应 的 超 时
​​​
​​​及重传策略。
​​​
​​​- 当 T C P 收到发自 T C P 连 接 另 一 端 的 数 据 ， 它 将 发 送 一 个 确 认 。 这 个 确 认 不 是 立 即 发 送 ，
​​​
​​​通常将推迟几分之一秒，这将在 1 9 . 3 节讨论。
​​​
​​​- T C P 将保持它首部和数据的检验和。这是一个端到端的检验和，目的是检测数据在传输
​​​
​​​过程中的任何变化。如果收到段的检验和有差错， T C P 将 丢 弃 这 个 报 文 段 和 不 确 认 收 到
​​​
​​​此报文段(希望发端超时并重发)。
​​​
​​​- 既然 T C P 报文段作为 I P 数据报来传输，而 I P 数据报的到达可能会失序，因此 T C P 报文段
​​​
​​​的到达也可能会失序。如果必要， T C P 将 对 收 到 的 数 据 进 行 重 新 排 序 ， 将 收 到 的 数 据 以
​​​
​​​正确的顺序交给应用层。
​​​
​​​- 既然 I P 数据报会发生重复， T C P 的接收端必须丢弃重复的数据。
​​​
​​​- T C P 还能提供流量控制。 T C P 连接的每一方都有固定大小的缓冲空间。 T C P 的 接 收 端 只允许另一端发送接收端缓冲区所能接纳的数据。这将防止较快主机致使较慢主机的缓冲
​​​
​​​区溢出。
​​​
​​​#### TCP首部
​​​
​​​![tcp_001](./img/tcp_001.png)
​​​
​​​
​​​
​​​
​​​​            
​​​​            ​        
​​​​            ​        ​    序号用来标识从 T C P 发端向 T C P 收 端 发 送 的 数 据 字 节 流 ， 它 表 示 在 这 个 报 文 段 中 的 的 第 一个数据字节。如果将字节流看作在两个应用程序间的单向流动，则 T C P 用 序 号 对 每 个 字 节 进行 计 数 。 序 号 是 3 2 b i t 的 无 符 号 数 ， 序 号 到 达 2 3 2 - 1 后又从 0 开始。
​​​​            ​        ​    
​​​​            ​        ​    当建立一个新的连接时， S Y N标志变 1。序号字段包含由这个主机选择的该连接的初始序号 I S N ( I n i t i a l S e q u e n c e N u m b e r )。该主机要发送数据的第一个字节序号为这个 I S N加 1 ，因为S Y N 标 志 消 耗 了 一 个 序 号 ( 将 在 下 章 详 细 介 绍 如 何 建 立 和 终 止 连 接 ， 届 时 我 们 将 看 到 F I N 标志也要占用一个序号)。
​​​​            ​        ​    
​​​​            ​        ​    既然每个传输的字节都被计数，确认序号包含发送确认的一端所期望收到的下一个序号。因 此 ， 确 认 序 号 应 当 是 上 次 已 成 功 收 到 数 据 字 节 序 号 加 1 。只有 A C K 标 志 ( 下 面 介 绍 ) 为 1 时确认序号字段才有效。
​​​​            ​        ​    
​​​​            ​        ​    T C P为 应 用 层 提 供 全 双 工 服 务 。 这 意 味 数 据 能 在 两 个 方 向 上 独 立 地 进 行 传 输 。 因 此 ， 连
​​​​            ​        ​    接的每一端必须保持每个方向上的传输数据序号。
​​​​            ​        ​    
​​​​            ​        ​    
​​​​            ​        ​    ​            
​​​​            ​        ​    ​            ​        
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    
​​​​            ​        ​    ​            ​        ​    ​


## iOS 内存管理
- 1.讲一下 `iOS` 内存管理的理解？(三种方案的结合) - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/1.第一题.md)
- 2.使用自动引用计（`ARC`）数应该遵循的原则? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/2.第二题.md)
- 3.`ARC` 自动内存管理的原则？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/3.第三题.md)
- 4.访问 `__weak` 修饰的变量，是否已经被注册在了 `@autoreleasePool` 中？为什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/4.第四题.md)
- 5.`ARC` 的 `retainCount` 怎么存储的？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/5.第五题.md)
- 6.简要说一下 `@autoreleasePool` 的数据结构？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/6.第六题.md)
- 7.`__weak` 和 `_Unsafe_Unretain` 的区别？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/7.第七题.md)
- 8.为什么已经有了 `ARC` ,但还是需要 `@AutoreleasePool` 的存在？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/8.第八题.md)
- 9.`__weak` 属性修饰的变量，如何实现在变量没有强引用后自动置为 `nil`？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/9.第九题.md)
- 10.说一下对 `retain`,`copy`,`assign`,`weak`,`_Unsafe_Unretain` 关键字的理解。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/10.第十题.md)
- 11.`ARC` 在编译时做了哪些工作？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/11.第十一题.md)
- 12.`ARC` 在运行时做了哪些工作？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/12.第十二题.md)
- 13.函数返回一个对象时，会对对象 `autorelease` 么？为什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/13.第十三题.md)
- 14.说一下什么是 `悬垂指针`？什么是 `野指针`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/14.第十四题.md)
- 15.内存管理默认的关键字是什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/15.第十五题.md)
- 16.内存中的5大区分别是什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/16.第十六题.md)
- 17.是否了解 `深拷贝` 和 `浅拷贝` 的概念，集合类深拷贝如何实现？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/17.第十七题.md)
- 18.`BAD_ACCESS` 在什么情况下出现? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/18.第十八题.md)
- 19.讲一下 `@dynamic` 关键字？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/19.第十九题.md)
- 20.`@autoreleasrPool` 的释放时机？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/20.第二十题.md)
- 21.`retain`、`release` 的实现机制？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/21.第二十一题.md)
- 22.能不能简述一下 `Dealloc` 的实现机制？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/22.第二十二题.md)
- 23.在 `MRC` 下如何重写属性的 `Setter` 和 `Getter`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/23.第二十三题.md)
- 24.在 `Obj-C` 中，如何检测内存泄漏？你知道哪些方式？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/内存管理/24.第二十四题.md)


## Runtime
- 实例对象的数据结构？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/1.第一题.md)
- 类对象的数据结构？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/2.第二题.md)
- 元类对象的数据结构? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/3.第三题.md)
- Obj-C 对象、类的本质是通过什么数据结构实现的？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/25.第二十五题.md)
- Obj-C 中的类信息存放在哪里？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/11.第十一题.md)
- 一个 NSObject 对象占用多少内存空间？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/12.第十二题.md)
- 说一下对 class_rw_t 结构体的理解？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/13.第十三题.md)
- 说一下对 class_ro_t 的理解？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/14.第十四题.md)
- Category 的实现原理？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/4.第四题.md)
- 如何给 Category 添加属性？关联对象以什么形式进行存储？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/5.第五题.md)
- Category 有哪些用途？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/6.第六题.md)
- Category 和 Class Extension 有什么区别？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/7.第七题.md)
- Category 可不可以添加实例对象？为什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/24.第二十四题.md)
- Category 在编译过后，是在什么时机与原有的类合并到一起的？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/26.第二十六题.md)
- 说一下 Method Swizzling? 说一下在实际开发中你在什么场景下使用过? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/8.第八题.md)
- Runtime 如何实现动态添加方法和属性？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/9.第九题.md)
- 说一下对 isa 指针的理解，对象的 isa 指针指向哪里？ isa 指针有哪两种类型？（注意区分不同对象） - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/10.第十题.md)
- 说一下 Runtime 消息解析。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/15.第十五题.md)
- 说一下 Runtime 消息转发。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/15.第十五题.md)
- 如何运用 Runtime 字典转模型？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/17.第十七题.md)
- 如何运用 Runtime 进行模型的归解档？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/18.第十八题.md)
- 在 Obj-C 中为什么叫发消息而不叫函数调用？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/19.第十九题.md)
- 说一下 Runtime 的方法缓存？存储的形式、数据结构以及查找的过程？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/21.第二十一题.md)
- 是否了解 Type Encoding? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/22.第二十二题.md)
- Objective-C 如何实现多重继承？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runtime/23.第二十三题.md)



## Runloop
- 1.`Runloop` 和线程的关系？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/1.第一题.md)
- 2.讲一下 `Runloop` 的 `Mode`?(越详细越好)  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/2.第二题.md)
- 3.讲一下 `Observer` ？（Mode中的重点） - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/3.第三题.md)
- 4.讲一下 `Runloop` 的内部实现逻辑？（运行过程） - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/4.第四题.md)
- 5.你所知的哪些三方框架使用了 `Runloop`?（AFNetworking、Texture 等）
- 6.`autoreleasePool` 在何时被释放？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/6.第六题.md)
- 7.解释一下 `事件响应` 的过程？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/7.第七题.md)
- 8.解释一下 `手势识别` 的过程？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/8.第八题.md)
- 9.解释一下 `GCD` 在 `Runloop` 中的使用？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/9.第九题.md)
- 10.解释一下 `NSTimer`，以及 `NSTimer` 的循环引用。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/10.第十题.md)
- 11.`AFNetworking` 中如何运用 `Runloop`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/11.第十一题.md)
- 12.`PerformSelector` 的实现原理？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/12.第十二题.md)
- 13.利用 `runloop` 解释一下页面的渲染的过程？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/13.第十三题.md)
- 14.如何使用 `Runloop` 实现一个常驻线程？这种线程一般有什么作用？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/14.第十四题.md)
- 15.为什么 `NSTimer` 有时候不好使？（不同类型的Mode）- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/15.第十五题.md)
- 16.`PerformSelector:afterDelay:`这个方法在子线程中是否起作用？为什么？怎么解决？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/16.第十六题.md)
- 17.什么是异步绘制？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Runloop/17.第十七题.md)
- 18.如何检测 `App` 运行过程中是否卡顿？


## UIKit

- 1.`UIView` 和 `CALayer` 是什么关系？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/1.第一题.md)
- 2.`Bounds` 和 `Frame` 的区别? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/2.第二题.md)
- 3.`TableViewCell` 如何根据 `UILabel` 内容长度自动调整高度?
- 4.`LoadView`方法了解吗？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/4.第四题.md)
- 5.`UIButton` 的父类是什么？`UILabel` 的父类又是什么？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/5.第五题.md)
- 6.实现一个控件，可以浮在任意界面的上层并支持拖动？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/6.第六题.md)
- 7.说一下控制器 `View` 的生命周期，一旦收到内存警告会如何处理？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/7.第七题.md)
- 8.如何暂停一个 `UIView` 中正在播放的动画？暂停后如何恢复？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/8.第八题.md)
- 9.说一下 `UIView` 的生命周期？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/9.第九题.md)
- 10.`UIViewController` 的生命周期？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/10.第十题.md)
- 11.如何以通用的方法找到当前显示的`ViewController`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/11.第十一题.md)
- 12.`setNeedsDisplay` 和 `layoutIfNeeded` 两者是什么关系？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/UIKit/12.第十二题.md)

## Foundation
- 1.`nil`、`NIL`、`NSNULL` 有什么区别？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/1.第一题.md)
- 2.如何实现一个线程安全的 `NSMutableArray`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/2.第二题.md)
- 3.如何定义一台 `iOS` 设备的唯一性? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/3.第三题.md)
- 4.`atomic` 修饰的属性是绝对安全的吗？为什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/4.第四题.md)
- 5.实现 `isEqual` 和 `hash` 方法时要注意什么？
- 6.`id` 和 `instanceType` 有什么区别？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/6.第六题.md)
- 7.简述事件传递、事件响应机制。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/7.第七题.md)
- 8.说一下对 `Super` 关键字的理解。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/8.第八题.md)
- 9.了解 `逆变` 和 `协变` 吗？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/9.第九题.md)
- 10.`@synthesize` 和 `@dynamic` 分别有什么作用？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/10.第十题.md)
- 11.`Obj-C` 中的反射机制了解吗？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/11.第十一题.md)
- 12.`typeof` 和 `__typeof`，`__typeof__` 的区别? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/12.第十二题.md)
- 13.如何判断一个文件在沙盒中是否存在？
- 14.头文件导入的方式？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/14.第十四题.md)
- 15.如何将 `Obj-C` 代码改变为 `C++/C` 的代码？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/15.第十五题.md)
- 16.知不知道在哪里下载苹果的源代码？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Foundation/16.第十六题.md)
- 17.`objc_getClass()`、`object_getClass()`、`Class` 这三个方法用来获取类对象有什么不同？

## 网络
- 1.`NSUrlConnect`相关知识。
- 2.`NSUrlSession`相关知识。
- 3.`Http` 和 `Https` 的区别？为什么更加安全？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/3.第三题.md)
- 4.`Http`的请求方式有哪些？`Http` 有什么特性？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/4.第四题.md)
- 5.解释一下 `三次握手` 和 `四次挥手`？解释一下为什么是`三次握手` 又为什么是 `四次挥手`？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/5.第五题.md)
- 6.`GET` 和 `POST` 请求的区别？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/6.第六题.md)
- 7.`HTTP` 请求报文 和 响应报文的结构？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/7.第七题.md)
- 8.什么是 `Mimetype` ? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/8.第八题.md)
- 9.数据传输的加密过程？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/9.第九题.md)
- 10.说一下 `TCP/IP` 五层模型的协议? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/10.第十题.md)
- 11.说一下 `OSI` 七层模型的协议? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/11.第十一题.md)
- 12.`大文件下载` 的功能有什么注意点？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/12.第十二题.md)
- 13.`断点续传` 功能该怎么实现？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/13.第十三题.md)
- 14.封装一个网络框架有哪些注意点？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/14.第十四题.md)
- 15.`Wireshark`、`Charles`、`Paw` 等工具会使用吗？
- 16.`NSUrlProtocol`用过吗？用在什么地方了？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/16.第十六题.md)
- 17.如何在测试过程中 `MOCK` 各种网络环境？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/17.第十七题.md)
- 18.`DNS` 的解析过程？网络的 `DNS` 优化。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/18.第十八题.md)
- 19.`Post`请求体有哪些格式？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/19.第十九题.md)
- 20.网络请求的状态码都大致代表什么意思？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/20.第二十题.md)
- 21.抓包软件 `Charles` 的原理是什么？说一下中间人攻击的过程。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/21.第二十一题.md)
- 22.如何判断一个请求是否结束？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/22.第二十二题.md)
- 23.`SSL` 传输协议？说一下 `SSL` 验证过程？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/23.第二十三题.md)
- 24.解释一下 `Http` 的持久连接？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/24.第二十四题.md)
- 25.说一下传输控制协议 - `TCP` ?- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/25.第二十五题.md)
- 26.说一下用户数据报协议 - `UDP` ? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/26.第二十六题.md)
- 27.谈一谈网络中的 `session` 和 `cookie`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/网络/27.第二十七题.md)
- 28.发送网络请求的时候，如果带宽 `1M`，如何针对某些请求，限制其流量?



## 多线程
- 1.`NSThread`相关知识？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/1.第一题.md)
- 2.`GCD` 相关知识？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/2.第二题.md)
- 3.`NSOperation` 和 `NSOperationQueue`相关知识？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/5.多线程/3.第三题.md)
- 4.如何实现线性编程？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/4.第四题.md)
- 5.说一下 `GCD` 并发队列实现机制？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/5.第五题.md)
- 6.`NSLock`？是否会出现死锁？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/6.第六题.md)
- 7.`NSContion` - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/7.第七题.md)
- 8.条件锁 - `NSContionLock`  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/8.第八题.md)
- 9.递归锁 - `NSRecursiveLock` - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/9.第九题.md)
- 10.同步锁 - `Synchronized(self) {// code}`  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/10.第十题.md)
- 11.信号量 - `dispatch_semaphore`。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/11.第十一题.md)
- 12.自旋锁 - `OSSpinLock` 。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/12.第十二题.md)
- 13.多功能🔐 - `pthread_mutex` - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/13.第十三题.md)
- 14.分步锁 - `NSDistributedLock`。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/14.第十四题.md)
- 15.如何确保线程安全？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/15.第十五题.md)
- 16.`NSMutableArray`、和 `NSMutableDictionary`是线程安全的吗？`NSCache`呢？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/16.第十六题.md)
- 17.多线程的 `并行` 和 `并发` 有什么区别？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/17.第十七题.md)
- 18.多线程有哪些优缺点？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/18.第十八题.md)
- 19.如何自定义 `NSOperation` ? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/19.第十九题.md)
- 20.`GCD` 与 `NSOperationQueue` 有哪些异同？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/20.第二十题.md)
- 21.解释一下多线程中的死锁？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/多线程/21.第二十一题.md)
- 22.子线程是否会出现死锁？说一下场景？
- 23.多线程技术在使用过程中有哪些注意事项？




## 项目架构
- 1.什么是 `MVC`?
- 2.什么是 `MVVM`?
- 3.什么是 `MVP`?
- 4.什么是 `CDD`?
- 5.项目的组件化？
- 1.说一下你了解的项目组件化方案？
- 2.什么样的团队及项目适合采用组件化的形式进行开发？
- 3.组件之间的通信方式。
- 4.各组件之间的解耦合。
- 6.还了解哪些项目架构？你之前所在公司的架构是什么样的，简单说一下？
- 7.从宏观上来讲 `App` 可以分为哪些层？
- 8.多工程连编之静态库 - [链接](https://blog.csdn.net/DonnyDN/article/details/79657986)

## 消息传递的方式

- 1.说一下 `NSNotification` 的实现机制？发消息是同步还是异步？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/1.第一题.md)
- 2.说一下 `NSNotification` 的特点。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/2.第二题.md)
- 3.简述 `KVO` 的实现机制。 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/3.第三题.md)
- 4.`KVO` 在使用过程中有哪些注意点？有没有使用过其他优秀的 `KVO` 三方替代框架？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/4.第四题.md)
- 5.简述 `KVO` 的注册依赖键是什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/5.第五题.md)
- 6.如何做到 `KVO` 手动通知？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/6.第六题.md)
- 7.在什么情况下会触发 `KVO`?  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/7.第七题.md)
- 8.给实例变量赋值时，是否会触发 `KVO`?  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/8.第八题.md)
- 9.`Delegate`通常用什么关键字修饰？为什么？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/9.第九题.md)
- 10.`通知` 和 `代理` 有什么区别？各自适应的场景？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/10.第十题.md)
- 11.`__block` 的解释以及在 `ARC` 和 `MRC` 下有什么不同？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/11.第十一题.md)
- 12.`Block` 的内存管理。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/12.第十二题.md)
- 13.`Block` 自动截取变量。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/13.第十三题.md)
- 14.`Block` 处理循环引用。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/14.第十四题.md)
- 15.`Block` 有几种类型？分别是什么？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/15.第十五题.md)
- 16.`Block` 和 `函数指针` 的区别? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/16.第十六题.md)
- 17.说一下什么是`Block`? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/消息传递的方式/16.第十六题.md)
- 18.`Dispatch_block_t`这个有没有用过？解释一下？

## 数据存储
- 1.Sqlite3 
- 1.简单说一下 `Sqlite3` - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据存储/1.1-1.md)
- 2.`Sqlite3` 常用的执行语句
- 3.`Sqlite3` 在不同版本的APP，数据库结构变化了，如何处理?
- FMDB (`Sqlite3` 的封装) - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据存储/2.2-1.md)
- Realm
- NSKeyArchieve - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据存储/4.4-1.md)
- Preperfence - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据存储/5.5-1.md)
- Plist - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据存储/6.6-1.md)
- CoreDate
- Keychain
- UIPasteBoard(感谢 lilingyu0620 同学提醒)
- FoundationDB
- LRU(最少最近使用)缓存

## iOS设计模式

> 这个模块需要大量代码，我就不贴了

- 1.编程中的六大设计原则？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/设计模式/1.第一题.md)
- 2.如何设计一个图片缓存框架？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/设计模式/2.第二题.md)
- 3.如何设计一个时长统计框架？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/设计模式/3.第三题.md)
- 4.如何实现 `App` 换肤（夜间模式）？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/设计模式/4.第四题.md)
- 5.外观模式
- 6.中介者模式
- 7.访问者模式
- 8.装饰模式 
- 9.观察者模式
- 10.责任链模式
- 11.命令模式
- 12.适配器模式
- 13.桥接模式
- 14.代理委托模式
- 15.单例模式
- 16.类工厂模式


## WebView
* 1.说一下 `JS` 和 `OC` 互相调用的几种方式？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/WebView/1.第一题.md)
* 2.在使用 `WKWedView` 时遇到过哪些问题？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/WebView/2.第二题.md)
* 3.是否了解 `UIWebView` 的插件化？
* 4.是否了解 `SFSafariViewController` ？

## 图像处理
- 1.一张物理体积20KB、分辨率为 200 * 300 的图片，在内存中占用多大的空间？
- 2.图像的压缩、解压。

## iOS 动画
- 1.简要说一下常用的动画库。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Animation/1.第一题.md)
- 2.请说一下对 `CALayer` 的认识。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Animation/2.第二题.md)
- 3.解释一下 `CALayer.contents` 属性。- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/Animation/3.第三题.md)
- 4.在 `iOS` 中，动画有哪几种类型？
- 5.隐式动画
- 6.显式动画


## 代码管理、持续集成、项目托管
- 1.Git
- 1.`git pull` 和 `git fetch` 的区别？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/1.1-1.md)
- 2.`git merge` 和 `git rebase` 的区别？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/1.1-2.md)
- 3.如何在本地新建一个分支，并 `push` 到远程服务器上？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/1.1-3.md)
- 4.如果 `fork` 了一个别人的仓库，怎样与源仓库保持同步？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/1.1-4.md)
- 5.总结一下 `Git` 常用的命令？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/1.1-5.md)
- 2.SVN（个人认为过气了）
- 3.CocoaPods
- 1.说一下 `CocoaPods` 的原理？
- 2.如何让自己写的框架支持 `CocoaPods`？
- 3.`pod update` 和 `pod install` 有什么区别？
- 4.`Podfile.lock` 文件起什么作用？
- 5.`CocoaPods` 常用指令？
- 6.在使用 `CocoaPods` 中遇到过哪些问题？
- 7.如何使用 `CocoaPods` 集成远程私有库？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/3.3-7.md)
- 8.如果自己写的库需要依赖其他的三方库，该怎么办？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/代码管理/3.3-8.md)
- 9.`CocoaPods` 中的 `Subspec` 字段有什么用处？
- 4.Carthage
- 5.Fastlane
- 6.Jenkins
- 7.fir.im
- 8.蒲公英
- 9.TestFlight

## 数据安全及加密
- 1.RSA非对称加密 - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据安全及加密/1.第一题.md)
- 2.AES对称加密
- 3.DES加密
- 4.Base64加密
- 5.MD5加密
- 6.简述 `SSL` 加密的过程用了哪些加密方法，为何这么做？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/数据安全及加密/6.第六题.md)
- 7.是否了解 `iOS` 的签名机制？
- 8.如何对 `APP` 进行重签名？

## 源代码阅读
- 1.YYKit
- 2.SDWebImage  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/源代码阅读/2.第二题.md)
- 3.AFNetworking
- 4.SVProgressHub 
- 5.Texture（ASDK）

## iOS逆向及安全

## Coretext

## 项目组件化
- 1.说一下你之前项目的组件化方案？
- 2.项目的组件化模块应该如何划分？
- 3.如何集成本地私有库？
- 4.如何集成远程私有库？

## 性能优化
- 1.如何提升 `tableview` 的流畅度？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/1.第一题.md)
- 2.如何使用 `Instruments` 进行性能调优？(Time Profiler、Zombies、Allocations、Leaks)
- 3.如何优化 `APP` 的启动时间？
- 4.如何优化 `APP` 的网络流量？
- 5.如何有效降低 `APP` 包的大小？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/5.第五题.md)
- 6.日常如何检查内存泄露？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/6.第六题.md)
- 7.能不能说一下物理屏幕显示的原理？
- 8.解释一下什么是屏幕卡顿、掉帧？该如何避免？
- 9.什么是 `离屏渲染`？什么情况下会触发？该如何应对？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/9.第九题.md)
- 10.如何高性能的画一个圆角？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/10.第十题.md)
- 11.如何优化 `APP` 的内存？
- 12.如何优化 `APP` 的电量？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/性能优化/12.第十二题.md)

## 调试技巧 & 软件使用
- 1.`LLDB` 调试。
- 2.断点调试 - `breakPoint`。
- 3.`NSAssert` 的使用。
- 4.`Charles` 的使用。
- 使用 `Charles` 下载过去任意版本的 `App`。
- 5.`Reveal` 的使用。
- 6.`iOS` 常见的崩溃类型有哪些？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/调试技巧/6.第六题.md)
- 7.当页面 `AutoLayout` 出现了问题，怎样快速调试？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/调试技巧/7.第七题.md)

## 扩展问题
- 1.无痕埋点
- 2.APM（应用程序性能监测）
- 3.Hot Patch（热修补）
- 4.崩溃的处理

## 其他问题

- 1.`load` 和 `Initialize` 的区别? - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/其他问题/1.第一题.md)
- 2.`Designated Initializer`的规则？ - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/其他问题/2.第二题.md)
- 3.`App` 编译过程有了解吗？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/其他问题/3.第三题.md)
- 4.说一下对 `APNS` 的认识？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/其他问题/4.第四题.md)
- 5.`App` 上有一数据列表，客户端和服务端均没有任何缓存，当服务端有数据更新时，该列表在 `wifi` 下能获取到数据，在 4G 下刷新不到，但是在 4g 环境下其他 `App` 都可以正常打开，分析其产生的原因？
- 6.是否了解链式编程？- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/其他问题/6.第六题.md)





## 逻辑计算题
- 1.**输出如下的计算结果** （14）

```objc
int a=5,b;
b=(++a)+(++a);
```

- 2.**不使用第三个变量，交换两个变量的值。**- [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/计算题/2.第二题.md)

```objc
int a = 5;
int b = 10;
```
- 3.**给出 `i`值得取值范围？** （大于或等于10000）

```objc
__block int i = 0;

while (i<10000) {

dispatch_async(dispatch_get_global_queue(0, 0), ^{
i++;
});
}
NSLog(@"i=%d",i);
}
```

- 4.**编码求，给定一个整数，按照十进制的编码计算包含多少个 `0`?**  - [链接](https://github.com/liberalisman/iOS-InterviewQuestion-collection/blob/master/计算题/4.第四题.md)

## 开放性问题

- 1.你最近在业余时间研究那些技术点？可不可以分享一下你的心得？
- 2.你对自己未来的职业发展有什么想法？有没有对自己做过职业规划？
- 3.和同事产生矛盾（包括意见分歧），你一般怎么解决？
- 4.能不能说一下你的业余精力都花在什么方面，或者介绍一下你的爱好？
- 5.学习技术知识通常通过哪些途径？
- 6.遇到疑难问题一般怎么解决？能不能说一个你印象颇深的技术难点，后来怎么解决的？


​​​​            ​        ​    ​            ​        ​    ​
​​​​            ​        ​    ​            ​        ​    ​​
​​​​            ​        ​    ​            ​        ​    ​​
​​​​            ​        ​    ​            ​        ​    ​​
​​​​            ​        ​    ​            ​        ​    ​​
​​​​            ​        ​    ​            ​        ​    ​​

