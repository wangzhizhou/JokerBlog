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
## 选择排序

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

## 插入排序