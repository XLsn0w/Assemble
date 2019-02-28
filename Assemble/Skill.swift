//
//  Skill.swift
//  Skill
//
//  Created by XLsn0w on 2019/2/17.
//  Copyright © 2019 TimeForest. All rights reserved.
//

/*

什么是arc？（arc是为了解决什么问题诞生的？）
现在有不少程序员是直接从arc上手的，从没接触过mrc，对arc的理解仅仅停留在apple帮助管理内存的层面。这个问题真正想了解的是对内存管理的理解，retain release虽然不用写了，但arc下还是会有内存泄漏野指针crash的bug存在。如果能从retain count这种内存管理策略的角度去阐述arc诞生的意义就算答对了。如果还能扯下其他类型的策略，比如java里的mark and sweep，那就加分点赞。

请解释以下keywords的区别： assign vs weak, __block vs __weak
这道题属于基础语法题，可以网上搜到答案。不过真有不少同学不知道weak在对象释放后会置为nil。
 __block关键字的理解稍微难点，因为在arc和mrc下含义（对retain count的影响）完全不同。
 理解了这几个关键字就能应付使用block时引入retain cycle的风险了。这题还在内存管理的范畴之内。

使用atomic一定是线程安全的吗？
看这题的问法不用想答案肯定是NO。有些人说不出所以然，有些人知道通过property的方式使用才能保证安全，还有人知道这个用来做多线程安全会有性能损耗，更有出色的候选人能谈atomic,synchronized,NSLock,pthread mutex,OSSpinLock的差别。好奇宝宝点我。

描述一个你遇到过的retain cycle例子。(别撒谎，你肯定遇到过)
说没遇到过的我很难相信你有过成熟项目的经历。这题答不出了会扣很多很多分。用过block，写过delegate的肯定都踩过坑。

+(void)load; +(void)initialize；有什么用处？
这题属于runtime范畴，我遇到过能说出对runtime的理解却不知道这两个方法的候选人。所以答不出来也没关系，这属于细节知识点，是加分项，能答出两个message各在什么阶段接收就可以了。

为什么其他语言里叫函数调用， objective c里则是给对象发消息（或者谈下对runtime的理解）
这题考查的是objective c这门语言的dynamic特性，需要对比c++这类传统静态方法调用才能理解。最好能说出一个对象收到message之后的完整的流程是如何的。对runtime有完整理解的候选人还能说出oc的对象模型。

什么是method swizzling?
说了解runtime但没听过method swizzling是骗人的。这题很容易搜到答案。定位一些疑难杂症bug，hack老项目实现，阅读第三方源码都有机会接触到这个概念。

UIView和CALayer是啥关系?
能答出UIView是CALayer的delegate就及格了，能说出UIView主要处理事件，CALayer负责绘制就更好，再聊下二者在使用过程中对动画流畅性影响的注意点。UI流畅性是个大话题，推荐看下这两篇文章。中餐，西餐。

如何高性能的给UIImageView加个圆角？（不准说layer.cornerRadius!）
这题讨论的最多，还有说美工切图就搞定的。答主在项目里做过圆角头像的处理，里面的坑还真不少。cornerRadius会导致offscreen drawing有性能问题，美工切图无法适用有背景图的场景，即使加上shouldRasterize也有cache实效问题。正确的做法是切换到工作线程利用CoreGraphic API生成一个offscreen UIImage，再切换到main thread赋值给UIImageView。这里还涉及到UIImageView复用，圆角头像cache缓存（不能每次都去绘制），新旧头像替换等等逻辑。还有其他的实现方式，但思路离不开工作线程与主线程切换。

使用drawRect有什么影响？（这个可深可浅，你至少得用过。。）
不少同学都用过drawRect或者看别人用过，但不知道这个api存在的含义。这不仅仅是另一种做UI的方式。drawRect会利用CPU生成offscreen bitmap，从而减轻GPU的绘制压力，用这种方式最UI可以将动画流畅性优化到极致，但缺点是绘制api复杂，offscreen cache增加内存开销。UI动画流畅性的优化主要平衡CPU和GPU的工作压力。推荐一篇文章：西餐

ASIHttpRequest或者SDWebImage里面给UIImageView加载图片的逻辑是什么样的？（把UIImageView放到UITableViewCell里面问更赞）
很多同学没有读源码的习惯，别人的轮子拿来只是用用却不知道真正的营养都在源代码里面。这两个经典的framework代码并不复杂，很值得一读。能对一个UIImageView怎么通过url展示一张图片有完整的理解。涉及到的知识点也非常多，UITableViewCell的复用，memory cache, disk cache, 多线程切换，甚至http协议本身都需要有一定的涉及。

麻烦你设计个简单的图片内存缓存器（移除策略是一定要说的）
内存缓存是个通用话题，每个平台都会涉及到。cache算法会影响到整个app的表现。候选人最好能谈下自己都了解哪些cache策略及各自的特点。常见的有FIFO,LRU,LRU-2,2Q等等。由于NSCache的缓存策略不透明，一些app开发者会选择自己做一套cache机制，其实并不难。

讲讲你用Instrument优化动画性能的经历吧（别问我什么是Instrument）
Apple的instrument为开发者提供了各种template去优化app性能和定位问题。很多公司都在赶feature，并没有充足的时间来做优化，导致不少开发者对instrument不怎么熟悉。但这里面其实涵盖了非常完整的计算机基础理论知识体系，memory，disk，network，thread，cpu，gpu等等，顺藤摸瓜去学习，是一笔巨大的知识财富。动画性能只是其中一个template，重点还是理解上面问题当中CPU GPU如何配合工作的知识。

loadView是干嘛用的？
不要就简单的告诉我没用过，至少问下我有什么用。。这里是apple给开发者自己设置custom view的位置。说UI熟悉的一定要知道。

viewWillLayoutSubView你总是知道的。。
controller layout触发的时候，开发者有机会去重新layout自己的各个subview。说UI熟悉的一定要知道。

GCD里面有哪几种Queue？你自己建立过串行queue吗？背后的线程模型是什么样的？
两种queue，串行和并行。main queue是串行，global queue是并行。有些开发者为了在工作线程串行的处理任务会自己建立一个serial queue。背后是苹果维护的线程池，各种queue要用线程都是这个池子里取的。GCD大家都用过，但很多关键的概念不少人都理解的模凌两可。串行，并行，同步，异步是GCD的核心概念。

用过coredata或者sqlite吗？读写是分线程的吗？遇到过死锁没？咋解决的？
没用过sqlite是说不过去的。用过CoreData的肯定有很多血泪史要说。多谢线程模型你肯定做过比较选择。死锁是啥肯定也是要知道的，没遇到过至少能举个简单的例子来说明。单个线程可以死锁（main thread里dispatch_sync到main queue），多个线程直接也可以死锁（A，B线程互相持有对方需要的资源且互相等待）。


 1.为什么代理要用weak？代理的delegate和dataSource有什么区别？block和代理的区别?
 A:为了避免循环引用。weak指明该对象并不负责保持delegate这个对象，delegate这个对象的销毁由外部控制。strong该对象强引用delegate，外界不能销毁delegate对象，会导致循环引用。DataSource是关于View的内容的东西包括属性，数据等等，而Delegate则是一些我们可以调用的方法，全是操作。block和代理都能解决对象间交互的问题，block更轻型，更简单，能够直接访问上下文，代码通常在同一个地方，这样读代码也连贯。缺点是容易引起循环引用。delegate更重一些，需要实现接口，它的方法分开来，很多时候需要存储一些临时数据，另外相关的代码需要分离到各处没有block好读，其优点就是它是用weak关键字修饰的，不会引起循环引用。
 2.属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？{#jump2}
 A:属性的本质是@property = ivar+getter+setter,也就是说@property系统会自动生成getter和setter方法。属性默认的关键字包括atomic，nonatomic，@synthesize，@dynamic，getter=getterName，setter=setterName，readwrite，readonly，assign，retain，copy。
 @dynamic：表示变量对应的属性访问器方法，是动态实现的，你需要在 NSObject 中继承而来的 +(BOOL) resolveInstanceMethod:(SEL) sel 方法中指定 动态实现的方法或者函数。
 @synthesize：如果没有实现setter和getter，编译器能够自动实现getter和setter方法。
 3.NSString为什么要用copy关键字，如果用strong会有什么问题？（注意：这里没有说用strong就一定不行。使用copy和strong是看情况而定的）
 A：针对于当把NSMutableString赋值给NSString的时候，才会有不同，用copy的话NSString的值不会发生变化，用strong则会发生变化，随着NSMutableString的值变化。如果是赋值是NSString对象，那么使用copy还是strong，结果都是一样的，因为NSString对象根本就不能改变自身的值，他是不可变的。
 4.如何令自己所写的对象具有拷贝功能?
 A:若想让自己写的对象具有拷贝功能，则需要实现NSCopying协议。如果自定义的对象分为可变版本和非可变版本，那么就要同时实现NSCopying和NSMutableCopying协议，不过一般没什么必要，实现NSCopying协议就够了。
 5.可变集合类 和 不可变集合类的 copy 和 mutablecopy有什么区别？如果是集合是内容复制的话，集合里面的元素也是内容复制么？
 A：对于不可变对象，copy操作是浅复制，mutableCopy是深复制。对于不可变对象，mutableCopy不仅仅是深复制，返回的对象类型还是不可变对象类型相应的可变对象的类型。内容复制也就是深拷贝，集合的深复制有两个方法，可以用initWithArray:copyItems:将第二个参数设置为YES即可进行深复制，如：NSDictionary *shallowCopyDict = [NSDictionary alloc]initWithDictionary:someDictionary copyItems:YES];如果用这个方法深复制，集合里的每个元素都会收到copyWithZone：消息。如果集合里的对象遵循NSCopying协议，那么对象就会深复制到新的集合。如果对象没有遵循NSCopying协议，而尝试用这种方法进行深复制则会出错。copyWithZone：这种拷贝方式只能提供一层内存拷贝，而非真正的深拷贝。第二种方法是将集合进行归档解档，如：NSArray *trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:oldArray]];
 6.为什么IBOutlet修饰的UIView也适用weak关键字？
 A:因为既然有外链那么视图在xib或者storyboard中肯定存在，视图已经对它有一个强引用了。
 7. nonatomic和atomic的区别？atomic是绝对的线程安全么？为什么？如果不是，那应该如何实现？
 A：nonatomic和atomic的区别在于两者自动生成getter和setter的方法不一样，如果你自己写getter和setter方法，那么（getter，setter，retain，copy，assign）只起提示作用，写不写都一样。
 对于atomic的属性，系统生成的getter和setter会保证get，set的操作完整性，不受其他线程影响。比如线程A的getter方法运行到一半，线程B调用了setter，那么线程A的getter还是能得到一个完整的对象。
 而nonatomic就没有这个保证了，所以速度要比atomic快。
 不过atomic可不能保证线程安全，如果线程A调用了getter，与此同时线程B和线程C都调了setter，那最后线程Aget到的值，三种都有可能：可能是B，C set之前原始的值，也可能是B set的值，也可能是C set的值。同时这个最终的值，也可能是B set的值，也可能是C set的值。要保证安全，可以使用线程锁。
 8.UICollectionView自定义layout如何实现？
 A:UICollectionViewLayoutAttributes，UICollectionViewFlowLayout。
 9.用StoryBoard开发界面有什么弊端？如何避免？
 A:难以维护，如果需要改动全局的一个字体，如果是代码的话就很好办，pch或头文件中改动就好了。如果是storyboard中就需要一个一个改动很麻烦。
 如果storyboard中scene太多，打开storyboard会比较慢。
 错误定位比较困难，好多错误提示模棱两可。
 10.进程和线程的区别？同步异步的区别？并行和并发的区别？
 A：进程是一个内存中运行的应用程序，比如在Windows系统中，一个运行的exe就是一个进程。
 线程是指进程中的一个执行流程。
 同步是顺序执行，执行完一个再执行下一个。需要等待，协调运行。
 异步就是彼此独立，在等待某事件的过程中继续做自己的事，不需要等待这些事件完成后再工作。
 并行和并发 是前者相当于三个人同时吃一个馒头，后者相当于一个人同时吃三个馒头。
 并发性（Concurrence）：指两个或两个以上的事件或活动在同一时间间隔内发生。并发的实质是一个物理CPU(也可以多个物理CPU) 在若干道程序之间多路复用，并发性是对有限物理资源强制行使多用户共享以提高效率。
 并行性（parallelism）指两个或两个以上事件或活动在同一时刻发生。在多道程序环境下，并行性使多个程序同一时刻可在不同CPU上同时执行。
 区别：(并发)一个处理器同时处理多个任务和（并行）多个处理器或者是多核的处理器同时处理多个不同的任务。
 11.线程间通信？
 A：NSThread、GCD、NSOperation。
 12.GCD的一些常用的函数？（group，barrier，信号量，线程同步）
 A：1.延迟执行任务函数：dispatch_after(.....)。
 2.一次性执行dispatch_once(...)。
 3.栅栏函数dispatch_barrier_async/dispatch_barrier_sync。
 4.队列组的使用dispatch_group_t。
 5.GCD定时器。
 13.如何使用队列来避免资源抢夺？
 A：dispatch_barrior_async    作用是在并行队列中，等待前面两个操作并行操作完成。
 14.数据持久化的几个方案（fmdb用没用过）
 A：Coredata，realm，fmdb。
 15.说一下AppDelegate的几个方法？从后台到前台调用了哪些方法？第一次启动调用了哪些方法？从前台到后台调用了哪些方法？
 A：
 1.当程序第一次运行并且将要显示窗口的时候执行，在该方法中我们完成的操作
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 2.程序进入后台的时候首先执行程序将要取消活跃该方法
 - (void)applicationWillResignActive:(UIApplication *)application
 
 3.该方法当应用程序进入后台的时候调用
 - (void)applicationDidEnterBackground:(UIApplication *)application
 
 4.当程序进入将要前台的时候调用
 - (void)applicationWillEnterForeground:(UIApplication *)application
 
 5.应用程序已经变得活跃（应用程序的运行状态）
 - (void)applicationDidBecomeActive:(UIApplication *)application
 
 6.当程序将要退出的时候调用，如果应用程序支持后台运行，该方法被applicationDidEnterBackground:替换
 - (void)applicationWillTerminate:(UIApplication *)application
 
 16.NSCache优于NSDictionary的几点？
 A：NSCache 是一个容器类，类似于NSDIctionary,通过key-value 形式存储和查询值，用于临时存储对象。
 注意一点它和NSDictionary区别就是，NSCache 中的key不必实现copy，NSDictionary中的key必须实现copy。
 NSCache中存储的对象也不必实现NSCoding协议，因为毕竟是临时存储，类似于内存缓存，程序退出后就被释放了。
 17.知不知道Designated Initializer（指定初始化函数）？使用它的时候有什么需要注意的问题？
 A：比如：
 - (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
 - (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
 
 18.实现description方法能取到什么效果？
 A：1.NSLog(@"%@", objectA);这会自动调用objectA的description方法来输出ObjectA的描述信息.
 2.description方法默认返回对象的描述信息(默认实现是返回类名和对象的内存地址)
 3.description方法是基类NSObject 所带的方法,因为其默认实现是返回类名和对象的内存地址, 这样的话,使用NSLog输出OC对象,意义就不是很大,因为我们并不关心对象的内存地址,比较关心的是对象内部的一些成变量的值。因此,会经常重写description方法,覆盖description方法的默认实现。
 19.objc使用什么机制管理对象内存？
 A：通过 retainCount 的机制来决定对象是否需要释放。 每次 runloop 的时候，都会检查对象的 retainCount，如果retainCount 为 0，说明该对象没有地方需要继续使用了，可以释放掉了。
 20.block的实质是什么？一共有几种block？都是什么情况下生成的？
 A：block对象就是一个结构体，里面有isa指针指向自己的类（global malloc stack），有desc结构体描述block的信息，__forwarding指向自己或堆上自己的地址，如果block对象截获变量，这些变量也会出现在block结构体中。最重要的block结构体有一个函数指针，指向block代码块。block结构体的构造函数的参数，包括函数指针，描述block的结构体，自动截获的变量（全局变量不用截获），引用到的__block变量。(__block对象也会转变成结构体)
 block代码块在编译的时候会生成一个函数，函数第一个参数是前面说到的block对象结构体指针。执行block，相当于执行block里面__forwarding里面的函数指针。
 21.static inline 是什么？
 A:static inline内联函数：使用它可以减少函数运行时间，提高程序运行速度。但内联函数里不能写循环，开关语句，而且最好不写过于冗长的函数。
 22.属性的默认关键字是什么？
 A:在声明property时，如果不指定关键字，编译器会为property生成默认的关键字。
 对应基本数据类型，默认关键字为atomic，assign，readwrite。
 对应对象类型，默认关键字为atomic，strong，readwrite。
 23.为什么在默认情况下无法修改被block捕获的变量？__block都做了什么？
 A：在block中访问的外部变量是复制过去的，写操作不对原变量生效。
 24.模拟一下循环引用的一个情况？block实现界面反向传值该怎么做？
 A：两个.h文件互相import了对方造成循环引用。block先声明（在要传值的controller里声明
 typedef void(^MyBlock)(NSString *name);//block的重命名
 @property (nonatomic,copy) MyBlock block;//block的声明），在准备接收值的页面里实现block，
 secondVC.block = ^void(NSString *name)
 {
 _label.text = name;
 };，谁要传值就在谁那里调用self.block(@"lalala");。
 25.iOS事件传递响应链是什么？
 A：当我们在使用微信等工具，点击扫一扫，就能打开二维码扫描视图。在我们点击屏幕的时候，iphone OS获取到了用户进行了“单击”这一行为，操作系统把包含这些点击事件的信息包装成UITouch和UIEvent形式的实例，然后找到当前运行的程序，逐级寻找能够响应这个事件的对象，直到没有响应者响应。这一寻找的过程，被称作事件的响应链。
 不同的响应者以链式方式寻找，AppDelegate->UIApplication->UIWindow->UIViewController->UIView->UIButton。
 26.利用kvo数据绑定，在mvvm模式中，数据绑定被用的很广泛，能够动态的根据数据改变刷新UI。
 27.多线程锁
 28.strong，weak，assign的区别
 29.类和结构体的区别
 30.怎么oc与swift混编？
 31.mrc与arc混编？
 32.http与tcp的区别？
 A：TCP连接:手机能够使用联网功能是因为手机底层实现了TCP/IP协议，可以使手机通过无线网络建立TCP连接。TCP协议可以对上层网络提供接口，使上层网络数据的传输建立在“无差别”的网络上。
 建立起一个TCP连接需要经过“三次握手”：
 第一次握手：客户端发送syn包（syn=j）到服务器，并进入SYN_SEND状态，等待服务器确认；
 第二次握手：服务器收到syn包，必须确认客户的SYN（ack=j+1），同时自己也发送一个SYN包（syn=k），即SYN+ACK包，此时服务器进入SYN_RECV状态；
 第三次握手：客户端收到服务器的SYN+ACK包，向服务器发送确认包ACK（ack=k+1），此包发送完毕，客户端和服务器进入ESTABLISHED状态，完成三次握手。
 握手过程中传送的包里不包含数据，三次握手完毕后，客户端和服务器才正式开始传送数据。理想状态下，TCP连接一旦建立，在通信双方中的任何一方主动关闭连接之前，TCP连接都将一直被保持下去。断开连接时服务器和客户端均可主动发起断开TCP连接的请求，断开过程需要经过“四次握手”。
 HTTP连接：HTTP协议即超文本传送协议，是Web联网的基础，也是手机联网常用的协议之一，HTTP协议是建立在TCP协议的一种应用。
 HTTP连接最显著的特点是客户端发送的每次请求都需要服务器回送响应，在请求结束后，会主动释放连接。从建立连接到关闭连接的过程称为“一次连接”。
 1.在HTTP 1.0中，客户端的每次请求都要求建立一次单独的连接，在处理完本次请求后，会自动释放连接。
 2.在HTTP 1.1中则可以在一次连接中处理多个请求，并且多个请求可以重叠进行，不需要等待一个请求结束后再发送下一个请求。
 由于HTTP在每次请求结束后都会主动释放连接，因此HTTP连接是一种短连接，要保持客户端程序的在线状态，需要不断地向服务器发起连接请求。通常的做法是即时不需要获得任何数据，客户端也保持每隔一段固定的时间向服务器发送一次“保持连接”的请求，服务器在收到该请求后对客户端进行回复，表明知道客户端“在线”。若服务器长时间无法收到客户端的请求，则认为客户端“下线”，若客户端长时间无法收到服务器的回复，则认为网络已经断开。
 33.进程间常用通信方式有哪些？
 A：1.URL Scheme
 2.Keychain
 3.UIPasteboard
 4.UIDocumentInteractionController
 5.Local socket
 6.AirDrop
 7.UIActivityViewController
 8.App Groups

*/
