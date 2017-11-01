一个最基本的持续分发管道至少包含三个阶段，它们在`Jenkinsfile`中被定义为：`构建`、`测试`和`布署`这一节，我们主要关注布署阶段，但这个阶段是需要稳定的构建和测试阶段的支持才能进行的。

```
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

# 把阶段作为布署环境

一个常用的模式就是通过扩展阶段的数量来创建额外的布署环境，比如："阶段"和"产品"，下面有一个代码段：
	
```
stage('Deploy - Staging') {
    steps {
        sh './deploy staging'
        sh './run-smoke-tests'
    }
}
stage('Deploy - Production') {
    steps {
        sh './deploy production'
    }
}
```
在这个例子中，我们假设`冒烟测试`通过脚本`./run-smoke-tests`来运行，从而测试产品质量是否合格。这种从代码到产品自动布署的管道可以被看作是持续分发的实现。这是一种理想状态。有时候，持续分发在实际中是不能完全实现的，不管怎样，这个不完整的过程仍然可以带来很大的好处。在这种不能完整实现持续分发的时候，`Jenkins`可以提供用户交互来处理各种情况。

# 向用户提供交互来处理问题

在不同阶段转换过程中，有时候需要用户交互来干预，例如：需要用户来判断应用是否已经足够好并可用于生产环境中。`Jenkins`可以使用`input`步骤来获取用户输入。在下面的示例中，`Sanity check`阶段如果没有用户怕输入，就会阻断整个管道的进度，直到用户处理完才能继续执行。

```
pipeline {
    agent any
    stages {
        /* "Build" and "Test" stages omitted */

        stage('Deploy - Staging') {
            steps {
                sh './deploy staging'
                sh './run-smoke-tests'
            }
        }

        stage('Sanity check') {
            steps {
                input "Does the staging environment look ok?"
            }
        }

        stage('Deploy - Production') {
            steps {
                sh './deploy production'
            }
        }
    }
}
```

# 结语

这份导览旨在引导你使用`Jenkins`的基本功能和管道。因为`Jenkins`非常有扩展性，所以它通过修改和配置可以处理其它各类的自动化问题。想要了解更多关于`Jenkins`的使用，参考[`Jenkins 使用手册`](https://jenkins.io/user-handbook.pdf)或者[`Jenkins`博客](https://jenkins.io/node/)。




