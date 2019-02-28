# 安装最新JDK

根据不同平台安装最新JDK: [下载JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

配置环境JDK变量:

- Linux: `~/.bashrc`中添加下面的环境变量配置
- MacOS: `~/.bash_profile`中添加下面的环境变量配置

```
export JAVA_HOME=<JDK Dir>
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:JAVA_HOME/lib/dt.jar:JAVA_HOME/lib/tools.jar
```

保存后，使环境变量配置生效

```
source ~/.bashrc   # Linux
```

# Kotlin 安装脚本(Unix/Linux), 并测试是否安装成功

```
# !/usr/bin/env bash
# 参考: https://kotlinlang.org/docs/tutorials/command-line.html
# 最求: JDK安装最新版

sudo apt-get install -y zip
curl -s https://get.sdkman.io | bash
source ~/.sdkman/bin/sdkman-init.sh
sdk install kotlin
source ~/.bashrc
echo "fun main(args: Array<String>) { println(\"Hello, World!\") }" > hello.kt
kotlinc hello.kt -include-runtime -d hello.jar
java -jar hello.jar
```


