
Red： 写产品代码前，先写失败的测试用例， 导入`XCTest`，并创建一个继承自`XCTestCase`的类放置所有的测试用例。每一条测试用例使用类中的一个成员方法表示，方法的名称必须以`test`开头，后面跟要测试的方法名称，再用下划线分割方法和具体环境意义标识。

Green: 修正代码，使上一步失败的测试用例运行通过

Refactor: 整理测试代码和业务代码，保持整洁和不重复

Repeat: 循环上面的三步，让所有的测试用例运行通过。

编译失败也属于测试失败。

`setUp`和`tearDown`中要对称的设置环境值， 因为每个测试用例都需要有自己的运行环境，所以设置正确与否直接决定各测试用例之前是否不相互关联。

`XCTest`不仅可以在`Playground`中使用，也可以在项目工程中使用

在Xcode上，应用本身不是一个框架，但在测试它时，可以在Xcode中使用`import`导入应用模块。

因为测试用例的函数名称显示在测试导航栏和测试日志中，最好的情况就是通过函数名称可以直接看出问题
出现在哪里。所以对测试用例的函数命名也有一定的规则: 

1. 必须以`test`开头
2. `test`后面跟上要测试的对像名称
3. 下划线后面跟上测试的时机或者状态
4. 最后跟上测试用例要保证的结果是什么样子的

`XCTest`来源于`XUnit`, 后者又来源于`SUnit`, 它是一种运行单元测试的架构, `X`表示可以适配各种编程语言. 例如`JUnit`/`OCUnit`/. `setUp`和`tearDown`为每一个单元测试用例的运行提供环境设置和恢复功能. `XCTest`中的同一个测试类的状态是保持的. 所以使用`setUp`和`tearDown`方法运行每一个测试用例显示的很重要.

`@testable import moduleName`可以测试没有暴露在模块外使用的类型和方法, 只在测试组件上生效,在一般的应用或框架上不生效

`TDD`是一种流程, 它是在写应用逻辑代码之前先写测试代码, 使用测试代码保证重构有效性. 每一个测试用命在第一次运行时都应该失败. 编译失败也算作是测试失败. 一个测试用例中只使用一个断言语句.

所有的测试用例最终都可以归结于断言: `XCTAssertTrue`, 但是`XCTest`还提供了一些其它的断言方法来简化过程:

- `XCTAssertEqual`/`XCTAssertNotEqual`
- `XCTAssertTrue`/`XCTAssertFalse`
- `XCTAssertNil`/`XCTAssertNotNil`
- `XCTAssertLessThan`/`XCTAssertGreaterThan`/`XCTAssertLessThanOrEqual`/`XCTAssertGreaterThanOrEqual`
- `XCTAssertThrowsError`/`XCTAssertNoThrow`

一个测试用例方法如果没有断言, 也被认为是测试通过, 即例它的内部什么也没有作. 可以给断言方法第二个参数赋值字符串, 用来说明断言失败时的原因.

单元测试不涉及UI部分, 只是用来测试逻辑问题, UI可以写专门的UI测试. `MVVM`或者`VIPER`之类的应用程序架构可以使写单元测试更加方便.

TDD测试中不包括UI测试, 代码覆盖率高并不能表示代码就能正常工作, 但是要果覆盖率低的话, 说明代码的测试没有做好.

`Edit Schema`里可以设置代码覆盖率显示和使用主应用进行测试.

进行测试用例调试时,可以打开测试`失败断点`

`XCTestExpectation`用来测试异步代码. 可以是`Callback`/`Observer`/`Notification`

因为调试异步测试用例时, 等待有个超时设置, 所以调试断言停留的时间也会被算入超时时长内, 这块需要留意.

`expectedFulfillmentCount`设置期望条件被完成的次数. 对于测试通知来说, 可能会用到.
`isInverted`属性用于设置期望是否按相反的逻辑判断.

测试异步过程：

- `XCTKVOExpectation`/`XCTNSPredicateExpectation`/`XCTNSNotificationExpectation`

第三方测试框架：`Quick+Nimble`，可以链式的书写测试用例。如果是响应式编程，使用了`RxSwift`，还可以使用`RxBlocking`和`TxTest`框加架来编写测试用例。


依赖注入和`Mock`