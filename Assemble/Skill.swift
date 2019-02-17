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
这道题属于基础语法题，可以网上搜到答案。不过真有不少同学不知道weak在对象释放后会置为nil。__block关键字的理解稍微难点，因为在arc和mrc下含义（对retain count的影响）完全不同。理解了这几个关键字就能应付使用block时引入retain cycle的风险了。这题还在内存管理的范畴之内。

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
能答出UIView是CALayer的delegate就及格了，能说出UIView主要处理事件，CALayer负责绘制就更好，再聊下二者在使用过程中对动画流畅性影响的注意点就superb。UI流畅性是个大话题，推荐看下这两篇文章。中餐，西餐。

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

http的post和get啥区别？（区别挺多的，麻烦多说点）
这个可以说很多。不希望听到的答案有

两个差不多，随便用一个。
post比get安全（其实两个都不安全）
能说下两个http格式有什么不同，各自应用的场景就合格了。更多可以阅读下这个答案。


 

*/
