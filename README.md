# 终端 命令行

Objective C源文件(.m)的编译器是Clang + LLVM，Swift源文件的编译器是swift + LLVM。

所以借助clang命令，我们可以查看一个.c或者.m源文件的汇编结果

clang -S Demo.m

这是是x86架构的汇编，对于ARM64我们可以借助xcrun，

xcrun --sdk iphoneos clang -S -arch arm64 Demo.m
