# 编译OC运行时

- objc开源库地址:<https://opensource.apple.com/source/objc4/>

目录最新版本是`objc4-723`:<https://opensource.apple.com/tarballs/objc4/objc4-723.tar.gz>

另外需要下载的文件有:

```
https://opensource.apple.com/tarballs/Libc/Libc-825.40.1.tar.gz
https://opensource.apple.com/tarballs/dyld/dyld-519.2.2.tar.gz
https://opensource.apple.com/tarballs/libauto/libauto-187.tar.gz
https://opensource.apple.com/tarballs/libclosure/libclosure-67.tar.gz
https://opensource.apple.com/tarballs/libdispatch/libdispatch-913.30.4.tar.gz
https://opensource.apple.com/tarballs/libpthread/libpthread-301.30.1.tar.gz
https://opensource.apple.com/tarballs/xnu/xnu-4570.41.2.tar.gz
https://opensource.apple.com/tarballs/libplatform/libplatform-161.20.1.tar.gz
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

