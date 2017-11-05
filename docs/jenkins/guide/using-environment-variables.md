环境变量可以是对全局有效的，也可以只在`stage`的范围内有效。例如:

```
pipeline {
    agent any

    environment {
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }

    stages {
        stage('Build') {
            steps {
                sh 'printenv'
            }
        }
    }
}
```
 上面的这种环境变量定义方式用来指示脚本的执行过程时非常有用，它可以使`构建`和`测试`在`Jenkins`内部在不同的方式执行。
 
 环境变量另外一个用处是设置构建和测试脚本的资格验证。因为直接把资格验证的部分写入`Jenkinsfile`显然时不明智的。使用环境变量，就可以使管道安全快捷的访问到预先定义好的资格验证，甚至都不需要知道这个资格验证具体是怎么定义的。
 
 # 环境变量中定义资格验证
 
 如果你的`Jenkins`环境配置了资格验证机制，诸如`构建密钥`或者`API tokens`，这些都可以很方便的插入到环境变量中供管道使用。下面的代码段是一个密文类型资格验证的示例：
 
```
 environment {
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
}
```
 和第一个例子一样，这些变量既可以全局有效，也可以只能某个阶段(stage)生效。
 
 第二种比较常见的验证机制是`用户名/密码`验证，也可以使用环境变量指令，但是与直接设置变量有些区别。
 
```
 environment {
   SAUCE_ACCESS = credentials('sauce-lab-dev')
}
```
这实际上设置了三个环境变量：

- `SAUCE_ACCESS` 包含 <username>:<password>
- `SAUCE_ACCESS_USR` 包含用户名
- `SAUCE_ACCESS_PSW` 包含密码

`credentials`只在声明性的管道中有效。在使用脚本的管道，参见`withCredentials`步骤

目前，我们主要关注的是创建我们指定配置和执行步骤的管道。在接下来的章节中，我们将会处理持续分发另一个重要方面：界面反馈和信息。
 


	

