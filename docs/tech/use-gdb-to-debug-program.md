用了几天GDB，觉得挺好用的，特别是写示例程序的时候，由于源文件也不是很复杂，调试工作还是使用轻量级的GDB来的方便、直接，同时GDB还可以远程调试，功能上也是很强大的。

下面整理一下使用GDB调试过程中经常使用的一些命令和组合键：

* `gdb insert_sort`	使用GDB调试程序`insert_sort`
* `break 16`	在程序的第16行设置断点
*  `tbreak 16` 在程序第16行设置一个临时断点，中止一次后失效
* `clear 16` 	清除程序第16行设置的断点
* `delete 1`	删除第一个断点
* `disable 1 2 5` 使断点1，2，5不起作用
* `enable  1 2 5` 使断点1，2，5起作用 
* `enable once 1 2` 使能断点1，2起作用一次，之后disable
* `info break`	查看所有断点信息
* `ctrl-P`和`ctrl-N`	前后浏览代码或编辑
* `ENTER`	重复执行上次调试命令
* `next`	调试下一句代码(Step Over)
* `next 3` 向下走三句(Step Over)
* `define`	可以定义相关的宏命令，使输入命令更加自由和个性
* `run 12 5 6` 运行到断点12、5、6时暂停执行
* `list`	多个源文件调试时显示不同的代码区域
* `step`	步入调试（Step Into)
* `continue` 继续执行
* `continue 3` 继续执行，并忽略三次断点
* `commands 3 `给断点关联相关的命令，一行一条命令，以end结束，添加一条slient命令可以屏掉断点停止时自动产生的相关信息输出
* `define` 定义GDB宏命令，以end结束定义, 参数以$号开始
* `show user` 列出所有用户自定义的宏命令
* `until` 继续执行，直到一个循环完成
* `until swap` 继续执行，直到swap函数被执行
* `finish` 继续执行，直到函数返回
* `tbreak 16` 16行设置临时断点，临时断点只会进入一次
* `until`和`finish`用来创建条件断点
* `watch i` 观察变量i,只要它的值发生了改变，就会停止运行
* `print j`	程序到断点暂停时，打印变量值
* `watch z`	变量z的值改变时，暂停执行程序
* `watch (z>28)` 设置条件判断的监视断点
* `frame 1`	查看前一个调用栈信息
* `frame 0`	查看当前调用栈
* `up` 	调用栈上一级
* `down`	调用栈下一级
* `backtrace`		查看整个调用栈信息
* `help`		查看GDB帮助信息

GDB还提供了`TUI`模式，可以在命令行中提供`GUI`类似的显示。

* `gdb -tui insert_sort`	以TUI模式启动GDB
* `ctrl-X-A`	命令行时`非TUI`和`TUI`模式相互转换

知道了一些基本命令，就以一个实际调试例子巩固一下。

# 一个调试实例

下面一个示例程序`insert_sort.c`，使用以下命令编译：

```
gcc -g -Wall -o insert_sort insert_sort.c
```

编译后生成了二进制执行文件:`insert_sort`，这里必须使用`-g`参数告诉编译器保存符号表(代码行号和变量内存地址相关的列表)，如果没有这个符号表，就不能在调试的时候使用诸如：`在30行中断`和`打印变量x的值`这类的操作。

现在的编译器也是很智能的，一般在编译阶段也能检查出一些错误来，就像下面这样：

```
insert_sort.c:29:10: warning: using the result of an assignment as a condition without parentheses
      [-Wparentheses]
        if(num_y=0)
           ~~~~~^~
insert_sort.c:29:10: note: place parentheses around the assignment to silence this warning
        if(num_y=0)
                ^
           (      )
insert_sort.c:29:10: note: use '==' to turn this assignment into an equality comparison
        if(num_y=0)
                ^
                ==
1 warning generated.
```

下面是有问题的程序源代码：

{% highlight cpp linenos %}

/* filename: insert_sort.c */

#include <stdio.h>
#include <stdlib.h>

int x[10],y[10],num_inputs,num_y=0;

void print_results()
{
	int i;
	for(i=0;i<num_inputs;i++)
	{
		printf("%d\n",y[i]);
	}
}

void scoot_over(int jj)
{
	int k ;
	for(k=num_y-1;k>jj;k++)
	{
		y[k]=y[k-1];
	}
}

void insert(int new_y)
{
	int j;
	if(num_y=0)
	{
		y[0]=new_y;
		return ;
	}
	
	for(j=0;j<num_y;j++)
	{
		if(new_y < y[j])
		{
			scoot_over(j);
			y[j]=new_y;
			return;
		}
	}
}

void process_data()
{
	for(num_y=0;num_y<num_inputs;num_y++)
	{
		insert(x[num_y]);
	}
}

void get_args(int ac, char **av)
{
	int i;
	num_inputs = ac - 1;	
	for(i=0; i<num_inputs; i++)
	{
		x[i] = atoi(av[i+1]);
	}
}

int main(int argc, char **argv)
{
	get_args(argc,argv);
	process_data();
	print_results();
	return 0;
}
{% endhighlight %}


我们先运行一下：

```
./insert_sort 12 5
```

发现程序陷入了死循环。使用Ctrl-C中断程序运行。这是第一个需要解决的bug。

# Debug #1 - 程序死循环

使用GDB TUI模式进行调试(可以使用`ctrl-X-A`在命令行和TUI模式间相互转换)：

```
gdb insert_sort -tui
```

按`Enter`进入GDB TUI调试环境后，使用带有参数`12 5`的运行(run)命令启动程序，会发现程序一直运行，并进入死循环

```
run 12 5
```

这时我们使用命令`Ctrl+C`来中止调试程序的运行(此时并不会退出GDB调试环境，由于暂停时程序运行的位置不确定，所以你试验时的情况和我稍有些不同，不过不会影响),我们发现程序停留在函数`process_data()`中的for循环中，些时`num_y=1`，我们使用了GDB的`print`命令来查看变量值。初步断定死循环发生的位置后，就要进一步寻找出现的原因，进而Debug

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │43              }                                                          │   │44      }                                                                  │   │45                                                                         │   │46      void process_data()                                                │   │47      {                                                                  │  >│48              for(num_y=0;num_y<num_inputs;num_y++)                      │   │49              {                                                          │   │50                      insert(x[num_y]);                                  │   │51              }                                                          │   │52      }                                                                  │   │53                                                                         │   │54      void get_args(int ac, char **av)                                   │   │55      {                                                                  │   └───────────────────────────────────────────────────────────────────────────┘native process 18485 In: process_data                        L48   PC: 0x400684 Type "apropos word" to search for commands related to "word"...Reading symbols from insert_sort...done.(gdb) run 12 5Starting program: /home/parallels/Documents/debug/insert_sort 12 5^CProgram received signal SIGINT, Interrupt.0x0000000000400684 in process_data () at ins.c:48(gdb) print num_y$1 = 0 
```

我们使用`next`命令单步调试，`next`命令不会进入函数内部，这是一种先粗后细的调试方式，单步调试了几次，发现每次执行完`insert(x[num_y]);`这一句后，`num_y`都会变成`0`，从而导致`for`循环不能结束。由是我们使用`step`命令在调试到`insert(x[num_y]);`时，进入函数内部调试，由于`num_y`是个全局变量，在`insert`函数内部第一行时错误的把`==`用成了`=`赋值，导致第次函数执行完后，`num_y`都被置为了0

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │24      }                                                                  │   │25                                                                         │   │26      void insert(int new_y)                                             │   │27      {                                                                  │   │28              int j;                                                     │  >│29              if(num_y=0)                                                │   │30              {                                                          │   │31                      y[0]=new_y;                                        │   │32                      return ;                                           │   │33              }                                                          │   │34                                                                         │   │35              for(j=0;j<num_y;j++)                                       │   │36              {                                                          │   └───────────────────────────────────────────────────────────────────────────┘native process 18485 In: insert                              L29   PC: 0x4005f0 (gdb) next(gdb) stepinsert (new_y=5) at ins.c:29(gdb) 
```

发现原因后， 我们另开一个控制台修改源码并重新编译，为的是不退出当前的GDB调试环境，可以保留调试中设置过的断点等信息，这里我们还没有设置过断点。

在另一个控制台中重新编译并运行后，发现死循环解除了，但是排序结果不正确：

```
parallels@ubuntu:~/Documents/debug$ gcc -g -Wall -o insert_sort ins.c
parallels@ubuntu:~/Documents/debug$ ./insert_sort 12 550```

# Debug #2 - 程序逻辑错误

我们发现`12`没有被正确的插入到第二个位置，于是我们回到GDB调试环境所在的控制台，在`insert`函数中设置断点后，使用`run`命令重新开始一次调试，`run`默认为使用上一次使用的参数`12 5`

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │24      }                                                                  │   │25                                                                         │   │26      void insert(int new_y)                                             │   │27      {                                                                  │   │28              int j;                                                     │B+>│29              if(num_y==0)                                               │   │30              {                                                          │   │31                      y[0]=new_y;                                        │   │32                      return ;                                           │   │33              }                                                          │   │34                                                                         │   │35              for(j=0;j<num_y;j++)                                       │   │36              {                                                          │   └───────────────────────────────────────────────────────────────────────────┘native process 25009 In: insert                              L29   PC: 0x4005f0 [Inferior 1 (process 24275) exited normally](gdb) break insertBreakpoint 1 at 0x4005f0: insert. (4 locations)(gdb) runStarting program: /home/parallels/Documents/debug/insert_sort 12 5Breakpoint 1, insert (new_y=12) at ins.c:29(gdb) (gdb) ```

我们看到程序在断点处停止运行了，再次使用单步调试整个数组的插入过程，对于第一个数字`12`,第一次会被插入排序结果数组的第一个位置，第二个数字`5`在被插入时会先与当前排序结果数组的每个元素进行比较，如果比较小，会把排序结果数组的每一个数据向后移动一个位置，为这个较小的数据腾出一个位置来放入。

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │33              }                                                          │   │34                                                                         │   │35              for(j=0;j<num_y;j++)                                       │   │36              {                                                          │   │37                      if(new_y < y[j])                                   │   │38                      {                                                  │   │39                              scoot_over(j);                             │   │40                              y[j]=new_y;                                │  >│41                              return;                                    │   │42                      }                                                  │   │43              }                                                          │   │44      }                                                                  │   │45                                                                         │   └───────────────────────────────────────────────────────────────────────────┘native process 25009 In: insert                              L41   PC: 0x400638 (gdb) print y$5 = {12, 0, 0, 0, 0, 0, 0, 0, 0, 0}(gdb) n(gdb) print y$6 = {5, 0, 0, 0, 0, 0, 0, 0, 0, 0}(gdb)  ```

在这个插入排序的过程中，发现在数字`5`被插入后，之前的数字`12`没有被正确的后移一位，所以问题就定位 在函数`scoot_over`中了，因为它的功能和我们期望的不一致。我们再设置断点到`scoot_over`函数中，并清除之前的断点，因为问题是出现在数字`5`与数字`12`比较后的`scoot_over`调用时，所以我们可以把断点设置为条件断点，也就是`num_y`为`1`时：

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │15      }                                                                  │   │16                                                                         │   │17      void scoot_over(int jj)                                            │   │18      {                                                                  │   │19              int k ;                                                    │B+>│20              for(k=num_y-1;k>jj;k++)                                    │   │21              {                                                          │   │22                      y[k]=y[k-1];                                       │   │23              }                                                          │   │24      }                                                                  │   │25                                                                         │   │26      void insert(int new_y)                                             │   │27      {                                                                  │   └───────────────────────────────────────────────────────────────────────────┘native process 28018 In: scoot_over                          L20   PC: 0x4005ad (gdb) clear 29Deleted breakpoint 1
(gdb) break scoot_over if num_y==1Breakpoint 2 at 0x4005ad: file ins.c, line 20.(gdb) i bNum     Type           Disp Enb Address            What2       breakpoint     keep y   0x00000000004005ad in scoot_over at ins.c:20        stop only if num_y==1(gdb) c   Continuing.Breakpoint 2, scoot_over (jj=0) at ins.c:20(gdb) p num_y$7 = 1```

这时我们运行到断点处停止下来，使用单步调试，发现`scoot_over`函数中的for循环一次都没有执行。此时`num_y`为1，所以`k`为0，而`jj`也是0，所以没有进入循环中，所以`k`的初始值赋值不正确，应该修改为`k=num_y`

再次在另一个控制台修改源程序，编译运行，发现产生了段错误，这是由于内存地址访问不当引起的：

```
parallels@ubuntu:~/Documents/debug$ gcc -g -Wall -o insert_sort ins.c
parallels@ubuntu:~/Documents/debug$ ./insert_sort 12 5Segmentation fault (core dumped)```


# Debug #3 - 程序段错误


这时就体现出开两个控制台的好处了，回到GDB环境后，清除之前的断点，并再次运行, GDB会在段错误的位置停下来：

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │17      void scoot_over(int jj)                                            │   │18      {                                                                  │   │19              int k ;                                                    │   │20              for(k=num_y;k>jj;k++)                                      │   │21              {                                                          │  >│22                      y[k]=y[k-1];                                       │   │23              }                                                          │   │24      }                                                                  │   │25                                                                         │   │26      void insert(int new_y)                                             │   │27      {                                                                  │   │28              int j;                                                     │   │29              if(num_y==0)                                               │   └───────────────────────────────────────────────────────────────────────────┘native process 30018 In: scoot_over                          L22   PC: 0x4005cc 
(gdb) clear 20Deleted breakpoint 2(gdb) runThe program being debugged has been started already.Start it from the beginning? (y or n) yStarting program: /home/parallels/Documents/debug/insert_sort 12 5Program received signal SIGSEGV, Segmentation fault.0x00000000004005cc in scoot_over (jj=0) at ins.c:22(gdb) print k$8 = 976```

此时我们将数组索引值打印出来，发现它远远大于排序结果数组的边界`10`, 这是由于for循环的变量k自加引起的错误，我们将其修改为自减。再次编译运行：

```parallels@ubuntu:~/Documents/debug$ gcc -g -Wall -o insert_sort ins.cparallels@ubuntu:~/Documents/debug$ ./insert_sort 12 5512```

发现排序两个数字正确了，我们试着排下多个数据。

```
parallels@ubuntu:~/Documents/debug$ ./insert_sort 12 5 19 22 6 11561200
```

# Debug #4 - 程序遗漏情况

发现排序结果对于数字`19 22`有问题，我们重新调试插入数据19和22时的过程，设置断点，并单步跟踪，发现，它们大于排序结果中的所有数据时，需要被插入到最后的位置，但事实上程序没有考虑到这种情况。

```
   ┌──ins.c────────────────────────────────────────────────────────────────────┐   │29              if(num_y==0)                                               │   │30              {                                                          │   │31                      y[0]=new_y;                                        │   │32                      return ;                                           │   │33              }                                                          │   │34                                                                         │  >│35              for(j=0;j<num_y;j++)                                       │   │36              {                                                          │B+ │37                      if(new_y < y[j])                                   │   │38                      {                                                  │   │39                              scoot_over(j);                             │   │40                              y[j]=new_y;                                │   │41                              return;                                    │   │42                      }                                                  │   │43              }                                                          │   │44      }                                                                  │   │45                                                                         │   │46      void process_data()                                                │   │47      {                                                                  │   └───────────────────────────────────────────────────────────────────────────┘native process 32621 In: insert                              L35   PC: 0x400637 (gdb) break 37 if new_y == 19Breakpoint 1 at 0x40060b: file ins.c, line 37.(gdb) run 12 5 19 22 6 1Starting program: /home/parallels/Documents/debug/insert_sort 12 5 19 22 6 1Breakpoint 1, insert (new_y=19) at ins.c:37(gdb) print y  $1 = {5, 12, 0, 0, 0, 0, 0, 0, 0, 0}(gdb) n(gdb) ```


所以我们需要在第`43`行后面补充这种情况：`y[j]=new_y;`

重新编译并运行：

```parallels@ubuntu:~/Documents/debug$ gcc -g -Wall -o insert_sort ins.cparallels@ubuntu:~/Documents/debug$ ./insert_sort 12 5 19 22 6 1156121922```

这次发现结果正确，但还需要进一步的测试一下。整个过整就是这个样子，调试是一门艺术而不是科学，通常很难描述这整个过程，所以有疏漏的地方，请多包涵。

