# 编译OC运行时

- objc开源库地址:<https://opensource.apple.com/source/objc4/>

目录最新版本是`objc4-723`:<https://opensource.apple.com/tarballs/objc4/objc4-723.tar.gz>

另外需要下载的文件有:

```
https://opensource.apple.com/tarballs/Libc/Libc-825.40.1.tar.gz
https://opensource.apple.com/tarballs/dyld/dyld-421.1.tar.gz
https://opensource.apple.com/tarballs/libauto/libauto-187.tar.gz
https://opensource.apple.com/tarballs/libclosure/libclosure-67.tar.gz
https://opensource.apple.com/tarballs/libdispatch/libdispatch-913.30.4.tar.gz
https://opensource.apple.com/tarballs/libpthread/libpthread-301.30.1.tar.gz
https://opensource.apple.com/tarballs/xnu/xnu-4570.41.2.tar.gz
https://opensource.apple.com/tarballs/libplatform/libplatform-161.20.1.tar.gz
https://opensource.apple.com/tarballs/launchd/launchd-842.92.1.tar.gz
```

## /Users/JokerAtBaoFeng/Desktop/objc4-723/runtime/objc-os.h:94:13: 'sys/reason.h' file not found

这个文件路径在`xnu-4570.41.2/bsd/sys/reason.h`


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:102:13: 'mach-o/dyld_priv.h' file not found

这个文件路径在`dyld-519.2.2/include/mach-o/dyld_priv.h`


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:104:13: 'os/lock_private.h' file not found

这个文件路径在`libplatform-161.20.1/private/os/lock_private.h` 另外还需要保留文件`base_private.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/os/lock_private.h:439:10: 'pthread/tsd_private.h' file not found

这个文件路径在`libpthread-301.30.1/private/tsd_private.h` 另外还需要保留文件`tsd_private.h`,外层目录需要从`private`改为`pthread`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/pthread/tsd_private.h:52:10: 'System/machine/cpu_capabilities.h' file not found

这个文件路径在`xnu-4570.41.2/osfmk/machine/cpu_capabilities.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/pthread/tsd_private.h:56:10: 'os/tsd.h' file not found

这个文件路径在`xnu-4570.41.2/libsyscall/os/tsd.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/pthread/tsd_private.h:57:10: 'pthread/spinlock_private.h' file not found

这个文件路径在`libpthread-301.30.1/private/spinlock_private.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:107:13: 'System/pthread_machdep.h' file not found

这个文件路径在应该在Libc中，但是较新版本的Libc里面没有这个文件，所以需要找老版本，这里在路径`Libc-825.40.1/pthreads/pthread_machdep.h`中找到了

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:250:13: 'CrashReporterClient.h' file not found

这个文件的路径在`Libc-825.40.1/include/CrashReporterClient.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/CrashReporterClient.h:40:15: 'CrashReporterClient.h' file not found

```
#ifndef _LIBC_CRASHREPORTERCLIENT_H
#define _LIBC_CRASHREPORTERCLIENT_H

#ifdef LIBC_NO_LIBCRASHREPORTERCLIENT

/* Fake the CrashReporterClient API */
#define CRGetCrashLogMessage() 0
#define CRSetCrashLogMessage(x) /* nothing */

#else /* !LIBC_NO_LIBCRASHREPORTERCLIENT */

/* Include the real CrashReporterClient.h */
#include_next <CrashReporterClient.h>

#endif /* !LIBC_NO_LIBCRASHREPORTERCLIENT */

#endif /* _LIBC_CRASHREPORTERCLIENT_H */

```

`Build Settings->Preprocessor Macros`，加入：**`LIBC_NO_LIBCRASHREPORTERCLIENT`**

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:984:10: 'pthread/workqueue_private.h' file not found

这个文件的路径在`libpthread-301.30.1/private/workqueue_private.h`


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/pthread/workqueue_private.h:34:10: 'pthread/qos_private.h' file not found

这个文件的路径在`libpthread-301.30.1/private/qos_private.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/pthread/qos_private.h:29:10: 'sys/qos_private.h' file not found

这个文件的路径在`libpthread-301.30.1/sys/qos_private.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-private.h:324:10: 'objc-shared-cache.h' file not found

这个文件的路径在`dyld-519.2.2/include/objc-shared-cache.h`

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/include/System/pthread_machdep.h:214:13: Typedef redefinition with different types ('int' vs 'volatile OSSpinLock' (aka 'volatile int'))

注释代得定义代码：

```
//typedef int pthread_lock_t;
```


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-os.h:735:19: Use of undeclared identifier '_PTHREAD_PRIORITY_FLAGS_MASK'

在`objc-os.h`中添加头文件包含: `#include <pthread/qos_private.h>`



## Static declaration of '_pthread_has_direct_tsd' follows non-static declaration

注释`pthread_machdep.`中的方法

```
//__inline__ static int
//_pthread_has_direct_tsd(void)
//{
//#if TARGET_IPHONE_SIMULATOR
//    /* Simulator will use the host implementation, so bypass the macro that is in the target code */
//    return 0;
//#elif defined(__ppc__)
//    int *caps = (int *)_COMM_PAGE_CPU_CAPABILITIES;
//    if (*caps & kFastThreadLocalStorage) {
//        return 1;
//    } else {
//        return 0;
//    }
//#else
//    return 1;
//#endif
//}
```

## Static declaration of '_pthread_setspecific_direct' follows non-static declaration

注释`pthread_machdep.`中的方法

```
/* To be used with static constant keys only */
//__inline__ static int
//_pthread_setspecific_direct(unsigned long slot, void * val)
//{
//#if defined(__i386__)
//#if defined(__PIC__)
//    __asm__("movl %1,%%gs:%0" : "=m" (*(void **)(slot * sizeof(void *))) : "rn" (val));
//#else
//    __asm__("movl %1,%%gs:%0" : "=m" (*(void **)(slot * sizeof(void *))) : "ri" (val));
//#endif
//#elif defined(__x86_64__)
//    /* PIC is free and cannot be disabled, even with: gcc -mdynamic-no-pic ... */
//    __asm__("movq %1,%%gs:%0" : "=m" (*(void **)(slot * sizeof(void *))) : "rn" (val));
//#elif (defined(__arm__) && (defined(_ARM_ARCH_6) || defined(_ARM_ARCH_5))) 
//    void **__pthread_tsd;
//#if defined(__arm__) && defined(_ARM_ARCH_6)
//    uintptr_t __pthread_tpid;
//    __asm__("mrc p15, 0, %0, c13, c0, 3" : "=r" (__pthread_tpid));
//    __pthread_tsd = (void**)(__pthread_tpid & ~0x3ul);
//#elif defined(__arm__) && defined(_ARM_ARCH_5)
//    register uintptr_t __pthread_tpid asm ("r9");
//    __pthread_tsd = (void**)__pthread_tpid;
//#endif
//    __pthread_tsd[slot] = val;
//#else
//#error no _pthread_setspecific_direct implementation for this arch
//#endif
//    return 0;
//}
```


## Static declaration of '_pthread_getspecific_direct' follows non-static declaration

注释`pthread_machdep.`中的方法

```
//__inline__ static void *
//_pthread_getspecific_direct(unsigned long slot)
//{
//    void *ret;
//#if defined(__i386__) || defined(__x86_64__)
//    __asm__("mov %%gs:%1, %0" : "=r" (ret) : "m" (*(void **)(slot * sizeof(void *))));
//#elif (defined(__arm__) && (defined(_ARM_ARCH_6) || defined(_ARM_ARCH_5))) 
//    void **__pthread_tsd;
//#if defined(__arm__) && defined(_ARM_ARCH_6)
//    uintptr_t __pthread_tpid;
//    __asm__("mrc p15, 0, %0, c13, c0, 3" : "=r" (__pthread_tpid));
//    __pthread_tsd = (void**)(__pthread_tpid & ~0x3ul);
//#elif defined(__arm__) && defined(_ARM_ARCH_5)
//    register uintptr_t __pthread_tpid asm ("r9");
//    __pthread_tsd = (void**)__pthread_tpid;
//#endif
//    ret = __pthread_tsd[slot];
//#else
//#error no _pthread_getspecific_direct implementation for this arch
//#endif
//    return ret;
//}
```


## Non-constant-expression cannot be narrowed from type 'uintptr_t' (aka 'unsigned long') to 'uint32_t' (aka 'unsigned int') in initializer list

按编译提示修复

```
static_cast<uint32_t>(mts)
```


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-errors.mm:77:10: '_simple.h' file not found

这个文件在路径`Libc-825.40.1/gen/_simple.h`


## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-runtime-new.mm:2350:46: Use of undeclared identifier 'DYLD_MACOSX_VERSION_10_11'

需要使用dyld-421.1版本中的dyld_priv.h文件，并添加
```
#define DYLD_MACOSX_VERSION_10_13       0x000A0D00
```

## /Users/JokerAtBaoFeng/Desktop/objc-runtime/objc4-723/runtime/objc-block-trampolines.mm:36:10: 'Block_private.h' file not found

这个文件的路径在：`libclosure-67/Block_private.h`

## ld: can't open order file: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/AppleInternal/OrderFiles/libobjc.order

`Build Settings->Linking->Order File`，把`Debug`和`Release`下的

```
$(SDKROOT)/AppleInternal/OrderFiles/libobjc.order
```

改成

```
libobjc.order
```

## clang: error: linker command failed with exit code 1 (use -v to see invocation)

只需要去`Build Settings -> Linking -> Other Linker Flags`里删掉"`-lCrashReporterClient`" （Debug 和 Release 都有的哦，需要删两个哦）

# 这样终于编译成功了




