一个管道可以由多个步骤组成，这样它就可以让你完成像构建、测试和布署应用的任务。`Jenkins`可以用比较容易的方式帮助你建立一个多步骤的管道来模拟各种类型的自动化流程。

一个步骤就像一条命令一样执行一个动作。一个步骤执行成功就继续执行下一个步骤，管道中只要有一个步骤执行失败，整个管道就执行失败。

管道执行成功的必要条件就是，管道包含的每一个步骤都执行成功。

# Linux/BSD/MacOS下的多步骤管道

```
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                '''
            }
        }
    }
}
```
# Windows下的多步骤管道

```
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat 'set'
            }
        }
    }
}
```

# 具有处理超时、重试和其它机制功能的步骤

下面管道定义了一个最多可以重试3次的步骤，和一个超时时间为3分钟的步骤。
```
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                retry(3) {
                    sh './flakey-deploy.sh'
                }

                timeout(time: 3, unit: 'MINUTES') {
                    sh './health-check.sh'
                }
            }
        }
    }
}
```

这些具有特殊功能的步骤包裹在其它步骤的外面发挥其作用，当然它们也可以嵌套使用。来看一个嵌套使用的例子：
```
pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(5) {
                        sh './flakey-deploy.sh'
                    }
                }
            }
        }
    }
}
```

# 当管道执行完成时做什么

你可能需要在管道执行完成后，基于执行结果做一些清理工作，这些工作被放在`post`区中执行。

```
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'echo "Fail!"; exit 1'
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
```







