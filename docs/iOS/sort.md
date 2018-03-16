# 十大经典排序算法

- 排序: 使一串记录，按照其中的某个或某些关键字的大小，递增或递减的排列起来的操作
- 稳定: 如果a原本在b前面，而a=b, 排序后a仍然在b前面
- 不稳定: 如果a原本在b前面，而a=b, 排序后a可能在b后面
- 内排序: 所有排序操作都在内存中完成
- 外排序: 由于数据太大放在磁盘中，排序通过内存和磁盘的传输才能进行
- 时间复杂度: 算法执行所耗费的时间
- 空间复杂度: 运行完一个程序所需内存的大小

# 各类排序算法的总结

![sort10](/iOS/images/sort10.png)

- n: 数据规模
- k: "桶"的个数
- in-place: 占用常数内存，不占用额外存储
- out-place: 占用额外存储

# 分类

![sort_cat](/iOS/images/sort_cat.png)


# 具体算法

## 冒泡排序

- **描述:** 遍历整个序列，遍历过程中不断比较相邻两个元素，如果逆序就交换两元素的位置，一趟下来就把最大元素挪到了最后位置，然后把去掉最大元素的子序列再进行相同遍历操作，直到序列排序完成。

![bubble sort](/iOS/images/bubble_sort.gif)

```swift
import Foundation

func bubble_sort(_ array: inout [Int]) -> [Int] {
    
    let count = array.count
    for i in 0 ..< count - 1 {
        for j in 0 ..< count-1-i {
            if array[j] > array[j+1] {
                
                let temp = array[j]
                array[j] = array[j+1]
                array[j+1] = temp
            }
        }
    }
    return array
}
```
## 简单选择排序

- **描述:** 遍历序列，记录最小元素的下标或索引，每次遍历完将最小元素和序列第一个元素交换位置，再将最小元素排除后看成一个子序列重复遍历过程，直到序列有序。

![select sort](/iOS/images/select_sort.gif)

```swift
import Foundation

func select_sort(_ array: inout [Int]) -> [Int] {
    
    let count = array.count
    for i in 0 ..< count-1 {
        var minIndex = i
        for j in (i+1) ..< count {
            if array[j] < array[minIndex] {
                minIndex = j
            }
        }
        let temp = array[i]
        array[i] = array[minIndex]
        array[minIndex] = temp
    }
    return array
}
```

## 直接插入排序

- **描述:** (类比与扑克牌整牌)首先把第1个元素看成是一个有序序列，把后面最近一个元素插入这个有序序列，插入过程从有序序列的尾部元素开始，逐个向前比较，如果插入元素比最后一个元素大，那么有序序列就扩大为2个元素，如果插入元素比最后一个元素小，继续向前查找比较，直到找到一个比插入元素大的元素，并将该元素后面所有包含在有序序列中的元素依次向后挪一位给插入元素空出位置(如果要插入的元素比有序序列中的所有元素都小，就把整个有序序列往后挪一个位置)，并放入所插入的元素，从而扩大有序序列的个数，如引循环，直到整个原始序列有序。

![insert sort](/iOS/images/insert_sort.gif)

```swift
import Foundation

func insert_sort(_ array: inout [Int]) -> [Int] {
    
    let count = array.count
    
    for i in 1 ..< count {
        var insertIndex = i
        for j in (0 ... i-1).reversed() {
            if array[j] > array[i] {
                array[j+1] = array[j]
                insertIndex = j
            }
        }
        array[insertIndex] = array[i]
    }
    return array
}
```

## 希尔排序

第一个突破\\(O(n^2)\\)的排序算法，是简单插入排序的改进版，又叫作缩小增量排序。关键在于增量序列的选择，增量序列是递减的，最后的增量为1回归到整个序列。

- **描述:** 将整个待排序序列按增量序列多次分割成若干子序列进行直接插入排序，直到序列有序

- **算法演示:**

定义索引增量序列: `5`， `3`， `1`

待排序序列: 

[`83`, `1`, `67`, `0`, `84`, `56`, `9`, `94`, `22`, `84`]

- 索引增量为 `5`时，序列拆分为5个子序列，如下:


```
[83,               56               ]
[    1,                9            ]
[       67,               94        ]
[           0,                22    ]
[              84                 84]
```

子序列插入排序结果:

```
[56,               83               ]
[    1,                9            ]
[       67,               94        ]
[           0,                22    ]
[              84                 84]
```

第一轮结束序列为：

[`56`，`1`，`67`，`0`，`84`，`83`，`9`，`94`，`22`，`84`]


- 增量为 `3`时，再将上一步的结果序列拆分为3个子序列，如下:

[56，1，67，0，84，83，9，94，22，84]
```
[56,       0,       9,        84 ]
[   1,      84,       94         ]
[     67,    83,        22       ]
```

子序列插入排序结果:

```
[0,       9,       56,        84 ]
[   1,      84,       94         ]
[     22,    67,        83       ]
```

第二轮结束序列为：

[`0`，`1`，`22`，`9`，`84`，`67`，`56`，`94`，`83`，`84`]

- 增量为 `1`时，再将上一步的结果序列拆分为1个子序列，如下:



子序列插入排序结果:

```
[0，1，9，22，56，67，83，84，84，94]
```

排序完成：

[`0`，`1`，`9`，`22`，`56`，`67`，`83`，`84`，`84`，`94`]

```
import Foundation

func shell_sort(_ array: inout [Int]) -> [Int] {
    
    let count = array.count
    
    var gaps = [1]
    while(gaps.last! < count / 3) {
        gaps.append(gaps.last! * 3)
    }
    
    for gap in gaps.reversed() {
        for i in 0 ..< gap {
            for j in stride(from: i + gap, to: count, by: gap) {
                var insertIndex = j
                let temp = array[j]
                while(insertIndex>=gap &&  temp < array[insertIndex - gap]){
                    array[insertIndex] = array[insertIndex - gap]
                    insertIndex = insertIndex - gap
                }
                array[insertIndex] = temp
            }
        }
    }
    
    return array
}
```

## 归并排序

和选择排序一样，不过表现更好，需要额外空间，归并操作上的一种有效排序方法，是一种稳定的排序方法，采
用分治的思想，将子序列分别进行归并排序，再将有序的子序列合并为有序序列，完成排序任务

- **描述:** 把待排序序列分成两个长度为\\(n/2\\)的子序列，对两个子序列分别进行归并排序，再将两个有序的子序列合并
成最终的有序序列，关键是归并操作的实现

![merge sort](/iOS/images/merge_sort.gif)

```swift
import Foundation

func merge_sort(_ array: inout [Int]) -> [Int] {
    
    let count = array.count
    
    guard count >= 2 else {
        return array
    }
    
    let mid = count / 2
    var left =  Array(array[0 ..< mid])
    var right = Array(array[mid ..< count])
    
    return merge(left: merge_sort(&left), right: merge_sort(&right))
}

func merge(left: [Int], right: [Int]) -> [Int] {
    
    var array = [Int]()
    
    var leftIndex = 0;
    var rightIndex = 0;
    
    while leftIndex < left.count && rightIndex < right.count {
        
        if left[leftIndex] < right[rightIndex] {
            array.append(left[leftIndex])
            leftIndex = leftIndex + 1
        } else {
            array.append(right[rightIndex])
            rightIndex = rightIndex + 1
        }
        
    }
    
    while leftIndex < left.count {
        array.append(left[leftIndex])
        leftIndex = leftIndex + 1
    }
    
    while rightIndex < right.count {
        array.append(right[rightIndex])
        rightIndex = rightIndex + 1
    }
    
    return array
}

```

## 快速排序

将待排序序列按一个基准值分成两个子序列，其中一个子序列中的元素全部小于基准值，另一个子序列中的元素全部大于基准值，然后对两个子序列分别应用快速排序，这样递归的完成排序任务

- **描述:** 从待排序序列中挑一个元素作为基准值，将序列中所有元素比基准值大的放在前面，比基准值下的放在后面，基准值放在中间，进行基准值分区后，前后两部分子序列再分别进行快速排序，递归的完成排序任务,关键是分区函数的实现

![quick sort](/iOS/images/quick_sort.gif)

```swift
import Foundation

func quick_sort(_ array: inout [Int]) -> [Int] {
    
    quick_sort(&array, left: 0, right: array.count - 1)
    return array
}

func quick_sort(_ array: inout [Int], left: Int, right: Int) {
    
    if left < right {
        let partionIndex = partition(&array, left: left, right: right)
        quick_sort(&array, left: left, right: partionIndex - 1)
        quick_sort(&array, left: partionIndex + 1, right: right)
    }
}

func partition(_ array: inout [Int], left: Int, right:Int) -> Int {
    
    let pivot = left
    
    var index = pivot + 1
    
    for i in index ... right {
        
        if array[i] < array[pivot] {
            array.swapAt(i, index)
            index = index + 1
        }
    }
    
    array.swapAt(left, index - 1)
    return index - 1
}
```

