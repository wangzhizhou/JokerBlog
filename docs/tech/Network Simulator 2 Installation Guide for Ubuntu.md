# Network Simulator 2 Installation Guide for Ubuntu


You can checkout my **[repo](https://github.com/wangzhizhou2014GitHub/Network-Simulator-Installation-Guideline-For-Ubuntu)** for this document, and get related files.

```
sudo apt-get install git-core
git clone https://github.com/wangzhizhou2014GitHub/Network-Simulator-Installation-Guideline-For-Ubuntu
```

### This Installation of Network Simulator 2 on the Ubuntu 16.04 Live CD UDisk

After you intall your Ubuntu System, you should use command: 
**`sudo apt-get update`**  to update your system software repos sites.
Then you can use **apt-get** command to install the software that you want on your system.

Firstly, you should download the **ns2 all-in-one file package** from it's offical website **[NS2-Network simulator](http://www.isi.edu/nsnam/ns/)**, and the link
of download file is: **[NS 2.35 released Nov 4 2011](http://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz/download)**.

	You can use the web browser or download tools such as XunLei.

After that, you should get a file named: **`ns-allinone-2.35.tar.gz`**.
You can use the command line to decompress the downloaded file:

```
tar zxvf ns-allinone-2.35.tar.gz 
```

Now, you get a directory which contain the Network Simulator 2 source files, then you should compile these files manually.

Enter the uncompressed directory with command line: 
**`cd ns-allinone-2.35/`** and run the compile script: **`sudo ./install`**, you will find there are some error exist: 
	
```
/ns-allinone-2.35/tk8.5.10/unix/../generic/tk.h:76:23: fatal error: X11/Xlib.h: No such file or directory, this is because your system
has no X11 dev-lib, so we should install them firstly
```

You can use command to search related libs should be installed: 

```
sudo apt-cache search x11-dev
libx11-dev - X11 client-side library (development headers)
libxkbcommon-x11-dev - library to create keymaps with the XKB X11 protocol - development files
```

so, we should install the **libx11-dev(headers)** and **libxkbcommon-x11-dev** as follow:

```
sudo apt-get install libx11-dev libxkbcommon-x11-dev
```
Then you run the **`sudo ./install`** command again. 

And You may find there appear another configuration fails as follow:

``` 
can't find X includes
otcl-1.14 configuration failed! Exiting ...
Please check http://www.isi.edu/nsnam/ns/ns-problems.html
for common problems and bug fixes.
```

You should install another software to suppress this fail: 

```
sudo apt-get install libxt-dev
```

Again, run **`sudo run ./intall`**.


Ops~, you run into the third problem when compile the source file:

```
linkstate/ls.h:137:25: error: ‘erase’ was not declared in this scope, and no declarations were found by argument-dependent lookup at the point of instantiation [-fpermissive]
  void eraseAll() { erase(baseMap::begin(), baseMap::end()); }
 
linkstate/ls.h:137:25: note: declarations in dependent base ‘std::map<int, LsIdSeq, std::less<int>, std::allocator<std::pair<const int, LsIdSeq> > >’ are not found by unqualified lookup
linkstate/ls.h:137:25: note: use ‘this->erase’ instead
Makefile:93: recipe for target 'linkstate/ls.o' failed
make: *** [linkstate/ls.o] Error 1
Ns make failed!
See http://www.isi.edu/nsnam/ns/ns-problems.html for problems
```

After search on the internet a while, I find the solution. We should change a file located in the ns2 directory: **`ns-allinone-2.35/ns-2.35/linkstate/ls.h`**, in the **line 137**, we should change the line frome

```
void eraseAll() { erase(baseMap::begin(), baseMap::end()); } 
```
to

```
void eraseAll() { this->erase(baseMap::begin(), baseMap::end()); }
```

>You can use vim or other plain text editor to do this task. 

After that, run the command **`sudo ./install`** again under the directory : **`ns-allinone-2.35/`**.

This time, we compile the NS2 source file successfully! You can get these message on the screen to demostrate the compile process is completed:

```
Please put /home/ubuntu/Downloads/ns-allinone-2.35/bin:/home/ubuntu/Downloads/ns-allinone-2.35/tcl8.5.10/unix:/home/ubuntu/Downloads/ns-allinone-2.35/tk8.5.10/unix
into your PATH environment; so that you'll be able to run itm/tclsh/wish/xgraph.

IMPORTANT NOTICES:

(1) You MUST put /home/ubuntu/Downloads/ns-allinone-2.35/otcl-1.14, /home/ubuntu/Downloads/ns-allinone-2.35/lib, 
    into your LD_LIBRARY_PATH environment variable.
    If it complains about X libraries, add path to your X libraries 
    into LD_LIBRARY_PATH.
    If you are using csh, you can set it like:
		setenv LD_LIBRARY_PATH <paths>
    If you are using sh, you can set it like:
		export LD_LIBRARY_PATH=<paths>

(2) You MUST put /home/ubuntu/Downloads/ns-allinone-2.35/tcl8.5.10/library into your TCL_LIBRARY environmental
    variable. Otherwise ns/nam will complain during startup.


After these steps, you can now run the ns validation suite with
cd ns-2.35; ./validate

For trouble shooting, please first read ns problems page 
http://www.isi.edu/nsnam/ns/ns-problems.html. Also search the ns mailing list archive
for related posts.
```
As above message said, we should add some environment variables into the end of your user configure file: **`.bashrc`**, which is under the directory: **`~/.bashrc`**

```
export NS2_HOME=/home/ubuntu/Downloads/ns-allinone-2.35
export PATH=$PATH:$NS2_HOME/bin:$NS2_HOME/tcl8.5.10/unix:$NS2_HOME/tk8.5.10/unix
export LD_LIBRARY_PATH=$NS2_HOME/otcl-1.14:$NS_HOME/lib
export TCL_LIBRARY=$NS2_HOME/tcl8.5.10/library
```

And you should use the command to make the change take effect: 

```
source ~/.bashrc 
```

Then you can validate the NS2 as the compile successful message said, buy run **`./invalidate`** in the **`ns-allinone-2.35/ns-2.35`** directory.

> This step may take a long time, because there are so many test examples should been passed. Of course, you can skip this validate step to continue.

After run these test examples, those failed examples will been listed out in bash as follow:

```
validate overall report: some tests failed:
     ./test-all-tcp ./test-all-testReno ./test-all-newreno ./test-all-sack ./test-all-tcpOptions ./test-all-tcpReset ./test-all-testReno-full ./test-all-testReno-bayfull ./test-all-sack-full ./test-all-tcp-init-win ./test-all-tcpVariants ./test-all-LimTransmit ./test-all-aimd ./test-all-rfc793edu ./test-all-rfc2581 ./test-all-rbp ./test-all-frto ./test-all-ecn ./test-all-ecn-ack ./test-all-ecn-full ./test-all-quickstart ./test-all-manual-routing ./test-all-red ./test-all-adaptive-red ./test-all-red-pd ./test-all-rio ./test-all-vq ./test-all-rem ./test-all-gk ./test-all-pi ./test-all-cbq ./test-all-schedule ./test-all-links ./test-all-oddBehaviors
to re-run a specific test, cd tcl/test; ./test-all-TEST-NAME
```

### Add MPTCP module into the NS2

In this project, there is a patch file named **`mptcp.patch-for-ns2.35-20130810`**, you should copy the **`mptcp.patch-for-ns2.35-20130810`** under directory: **`ns-allinone-2.35/ns-2.35/`**, then change directory into **`/ns-allinone-2.35/ns-2.35/`** and apply this patch file with command:

```
patch -p1 < mptcp.patch-for-ns2.35-20130810
```
the bash ouput as follow, demostrate we added the mptcp source file into directory **`/ns-allinone-2.35/ns-2.35/tcp/`**:

```
patch -p1 < mptcp.patch-for-ns2.35-20130810 
patching file Makefile.in
patching file tcp/mptcp.cc
patching file tcp/mptcp-full.cc
patching file tcp/mptcp-full.h
patching file tcp/mptcp.h
patching file tcp/tcp.h
patching file trace/trace.cc
```

Then, you run configure command as follow:

```
sudo ./configure --with-tcl-ver=8.5
```

Lastly, you should make the ns-2.35 with command:

```
sudo make
```

the last output of command is as follow:

```
for i in indep-utils/cmu-scen-gen/setdest indep-utils/webtrace-conv/dec indep-utils/webtrace-conv/epa indep-utils/webtrace-conv/nlanr indep-utils/webtrace-conv/ucb; do ( cd $i; make all; ) done
make[1]: Entering directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/setdest'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/cmu-scen-gen/setdest'
make[1]: Entering directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/dec'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/dec'
make[1]: Entering directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/epa'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/epa'
make[1]: Entering directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/nlanr'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/nlanr'
make[1]: Entering directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/ucb'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/ubuntu/Downloads/ns-allinone-2.35/ns-2.35/indep-utils/webtrace-conv/ucb'
```

This means there is not fatal errors occurred. Then you can think your MPTCP installed successfully!


#### And we can run a mptcp sample script file to valide this installation. 
This project contained a test tcl script file **`mptcp-sample.tcl`**, you can run with ns command as follow:

```
ns mptcp-sample.tcl
```

After run this script as above, there will be a xgraph plot pop out, that demonstrate the addition of **MPTCP** is successful.

### Configuration of Eclipse Debug Environment

Firstly, if you want debug ns2, you should make it support debug. Change directory into: **`/ns-allinone-2.35/ns-2.35/`**,and using vim open the **Makefile**, change the **56 line** from

```
CCOPT   =  -Wall -Wno-write-strings
```
to

```
CCOPT   =  -g -Wall -Wno-write-strings
```

save and exit the Makefile, then run: 

```
sudo make
```
to recompile the ns2. Now the ns2 can support debug.


Then, you should Download the Eclipse IDE for C/C++ Developers on the Web Site: [http://www.eclipse.org/downloads/](http://www.eclipse.org/downloads/)

Because eclipse don't need to install, after we decompress the tar.gz file, we can use is directly under it's directory. But if we want use it anywhere in our ubuntu file system, we should add the eclipse binary path to the environment variable **PATH** to tell our system where to locate elipse and startup it.

Use command decompress *.tar.gz file: 

```
tar zxvf eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz
```

Then there will be a directory named : **`eclipse`** under current directory, we add one line in the ~/.bashrc file as we done early:

```
export PATH=$PATH:/home/ubuntu/Downloads/eclipse
```
and use: **`source ~/.bashrc`** to make the change take effect.


##### Ok, you can run eclipse anywhere in your file system.

If you run eclipse in bash, you will find that, there is a problem said that eclipse need the **java run environment** to startup, because this 
software is developed by java. we should do more thing to make it work:

You can download the **JRE** from website: [http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html)

> Make sure download the correct edition JRE corresponding to your system. 
> 
> Linux 64 Edition for my condition.

use command: 
`tar zxvf jre-8u91-linux-x64.tar.gz `decompress the file and move the decompressed directory under directory: **`eclipse/`**, and rename it to `**jre**`, now you can start eclipse without error about JRE.
 
From there, we start configure the debug environment of ns2 with Eclipse

Because there are so many issues should been care, and I recommend you to learn from this blog: [http://blog.sina.com.cn/s/blog_5d2054d90100za8e.html](http://blog.sina.com.cn/s/blog_5d2054d90100za8e.html), there are detail description, but images can also demostrate the operation about eclipse. Enjoy It!




### The process is on Ubuntu 14.04 (simple record the hack process, mostly same as Ubuntu 16.04)

You should first update ubuntu to get the latest software with command :

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install g++
```

After install Ubuntu14.04, I downloaded the **ns-allinone2.35** from it's offical website and use the `tar zxvf ns-allinone2.35.tar.gz` decompress the file.

Then I use the vim to edit the file **`ns-allinone2.35/ns-2.35/linkstate/ls.h`**, change the **line 137**, added a `this` pointer.

Use the command: `sudo ./install` to compile the ns2, but there are some error, there are hints say that there is no X11.h header file.

> If you upgrade you ubuntu firstly, you may not encount this error. But who know it.
 
So, I should install relate program with command:

```
sudo apt-get install libx11-dev
sudo apt-get install libxkbcommon-x11-deud 
sudo apt-get install libghc-x11-dev
```

After apply the patch file **mptcp.patch-for-ns2.35-20130810** under `/ns-allinone-2.35/ns-2.35/`, then use command:`sudo ./configure --with-tcl-ver=8.5` to configure the project, after that, use command: `sudo make` the make the project, then change directory to the parent directory of ns-2.35 and run the command: sudo ./install to complete!

**Written By Joker, 2016-05-07, copy left**


