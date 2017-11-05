由于`post`区是在一个管道执行完成后被调用的，所以我们可以在这个位置添加一些通知或其它步骤来执行管道结束后需要执行的相关任务。

```
pipeline {
    agent any
    stages {
        stage('No-op') {
            steps {
                sh 'ls'
            }
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo 'I succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
```
有很多种方式可以发送通知，下面是一些发送通知的代码段，用来说明和管道相关的通知如何发送到`email`、`Hipchat room`、 `Slack channel`


# E-mail

```
post {
    failure {
        mail to: 'team@example.com',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
    }
}
```

# Hipchat

```
post {
    failure {
        hipchatSend message: "Attention @here ${env.JOB_NAME} #${env.BUILD_NUMBER} has failed.",
                    color: 'RED'
    }
}
```

# Slack Channel

```
post {
    success {
        slackSend channel: '#ops-room',
                  color: 'good',
                  message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
    }
}
```

既然我们已经可以在管道发生：失败、不稳定或者成功事件时通知团队，我们就可以进行最后一步`布署`，从而完成持续分发的整个过程。

