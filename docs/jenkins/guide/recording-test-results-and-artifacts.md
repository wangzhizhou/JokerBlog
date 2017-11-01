虽然测试是一个好的持续分发管道的重要组成部分，但大部分人都不愿意在几千行的控制台输出中寻找测试失败的相关信息。为了让事情变得更加容易，只要你测试器可以输出测试结果文件，`Jenkins`就可以记录并汇总测试结果。`Jenkins`通常会和`junit`步骤打包在一起，但如果你的测试器不能输出`JUnit`风格的XML报告，`Jenkins`也有可以处理常用测试报告格式的其它插件供使用。

为了收集测试结果，我们在管道中使用`post`区。

```
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh './gradlew check'
            }
        }
    }
    post {
        always {
            junit 'build/reports/**/*.xml'
        }
    }
}
```

`always`指明`Jenkins`一直跟踪并获取测试结果，基于这些测试结果计算趋势图和生成报告。一个测试失败的管道会被标记为`UNSTABLE`状态，在`web UI`中以黄色标识，这和一个`FAILED`状态的管道不同，后者用红色标识。


当管道中有测试失败时，通常获取构建过程中生成的信息进行分析比较有用。`Jenkins`支持存储这些构建过程中生成的东西。

这个收集可以使用`archive`步骤来进行，下面是一个文件获取的示例:
```
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }
        stage('Test') {
            steps {
                sh './gradlew check'
            }
        }
    }

    post {
        always {
            archive 'build/libs/**/*.jar'
            junit 'build/reports/**/*.xml'
        }
    }
}
```

记录测试和构建过程中生成的东西在`Jenkins`中可以很容易的在界面中反映一些信息给团队成员。下一节中，我们将要讨论怎么通知团队成员管道中发生了什么事。


