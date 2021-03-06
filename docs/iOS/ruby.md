# Ruby语言入门

## 打印

```ruby
print "Hello world"
puts "A line"
puts "Joker is \"A Man\""
puts "print a newline \n\n"
```

## 变量

```ruby
name = "I am Joker"
age = 29

puts ("My name is: " + name)
puts ("My age is: " + age)
puts name
```

## 数据类型

```ruby
name = "String Data Type"
age = 75
ratio = -3.5
isOld = true
isNew = false
no_value = nil
```

## 类型方法

```ruby
name = "joker"
puts name.upcase()
puts name.downcase()
puts name[0]
puts name[0,3] # 开区间，左闭右开
puts name.index("j")

trim_string = "    Hello, this is a non trim string    "
puts trim_string.strip()
puts trim_string.length()
puts trim_string.include? "Hello"

puts "string".upcase()
```

## 数学和数字

```ruby
puts 5
puts 3.141592653697932384626
puts -3.14
puts 5 + 9
puts 5 * 9
puts 5 / 9
puts 2**3
puts 10 % 3

num = 20
puts ("my fav num " + num.to_s)
puts num.abs()

f = 20.87
puts f.round()
puts f.ceil()
puts f.floor()
puts Math.sqrt(f)
puts Math.log(f)
puts 1.0 + 7
puts 10 / 7
```

## 用户输入

```ruby
puts "enter you name: "
input = gets # container a newline character
puts ("Hello " + name + ", you are cool!")
input = gets.chomp() # dont container a newline character
puts ("Hello " + name + ", you are cool!")
```

## 写一个计算器

```ruby
puts "Enter a number: "
num1 = gets.chomp()
puts "Enter another number: "
num2 = gets.chomp()
puts (num1.to_i + num2.to_i)
puts (num1.to_f + num2.to_f)
```

## 处理用户输入

```ruby
puts "Enter a color: "
color = gets.chomp()
puts "Enter a plural noun: "
plural_noun = gets.chomp()
puts "Enter a celebrity: "
celebrity = gets.chomp()

puts ("Roses are " + color)
puts (plural_noun + " are blue")
puts ("I love " + celebrity)
```

## 数组

```ruby
friends = Array["joker", "Alice", "Oscar", 1, false]
puts friends
puts friends[1]
puts friends[-2]
puts friends [0,2]
friends[0] = "wangzhizhou"

friends = Array.new
friends[0] = "Joker"
puts friends
puts friends.length()
puts friends.include? "Joker"
puts friends.reverse()
puts friends.sort() # 不能在不同类型间比较排序
```

## 哈希表

```ruby
map = {
    "key" => "value",
    "new" => "old",
    "boolean" => false,
    "color" => 1,
    :anotherKey => "key another"
}

puts map
puts map["key"]
puts map[:anotherKey]
```

## 方法

```ruby
def sayhi(name = "joker", age = -1)
    puts ("Hello " + name + ", you are " + age.to_s)
end

sayhi
```

## 返回语句

```ruby
def cube(num)
    num * num * num  # 最后一行的值默认为返回值，也可以加return显式指定
end

puts cube(2)
```

```ruby
def cube(num)
    return num * num * num, 70  # 多个返回值以数组方式返回
end

puts cube(3)[1]
```

## If语句

```ruby
ismale = true
istall = true

# 逻辑关键词 or and !
if ismale and istall
    puts "You are a tall male"
elsif ismale and !istall
    puts "You are a short male"
elsif !ismale and istall
    puts "You are not male but are tall"
else
    puts "You are not male and not tall"
end
```

```ruby
# 比较运算 ==、>、>=、<、<=、！=
def max(num1, num2, num3)
    if num1 >= num2 and num1 >= num3
        return num1
    elsif num2 >= num1 and num2 >= num3
        return num2
    else
        return num3
    end
end

puts max(1,2,3)

```

## Case表达式

```ruby
def get_day_name(day)
    day_name = ""

    case day
    when "mon"
        day_name = "Monday"
    when "tue"
        day_name = "Tuesday"
    else
        day_name = "Invalid Arg"
    end

    return day_name

end

puts get_day_name("mon")
```

## while 循环

```ruby
index = 1
while index <= 5
    puts index
    index += 1
end
```

## For 循环

```ruby
friends = ["Kevin", "Karen", "Oscar", "Angela", "Andy"]

for friend in friends
    puts friend
end

friends.each do |friend|
    puts friend
end

for index in 1..5
    puts friends[index]
end

6.times do |index|
    puts index
end
```

## 注释

```ruby

# 行间注释
puts "Comments are fun" # 行内注释

=begin
多行注释
=end
```

## 读文件

```txt
Joker
Alice
WangZhizhou
WangYuMin
```

```ruby
File.open("file.txt", "r") do |file|
    puts file.read().include? "Jim"
    puts file.readline() # 读一行内容
    puts file.readline() # 读下一行内容
    puts file.readchar() # 读一个字符
    puts file.readchar() # 读下一个字符

    for line in file.readlines()
        puts line
    end
end

content = File.open("file.txt", "r")
puts content.read

```

## 写文件

```ruby
File.open("file.txt", "a") do |file|
    file.write("\nOscar, Accounting")
end
```

## 错误处理

```ruby
begin
    lucky_number["dog"]
    num = 10 / 0
rescue ZeroDivisionError
    puts "Division by zero error"
rescue TypeError => e
    puts e
end
```

## 类和对象

```ruby
class Book
    attr_accessor :title, :author, :pages
end

book1 = Book.new()
book1.title = "Harry Potter"
book1.author = "JK Rowling"
book1.pages = 40

puts book1.title
puts book1.pages
puts book1.author

book2 = Book.new()
book2.title = "Lord of the rings"
book2.author = "Tolkein"
book2.pages = 500

puts book2.author
```

## 类初始化方法

```ruby
class Book
    attr_accessor :title, :author, :pages
    def initialize(title, author, pages)
        @title = title
        @author = author
        @pages = pages
    end
end

book1 = Book.new("Harry Potter", "JK Rowling", 40)

puts book1.title
puts book1.pages
puts book1.author
```

## 对象方法

```ruby
class Student
    attr_accessor :name, :major, :gpa
    def initialize(name, major, gpa)
        @name = name
        @major = major
        @gpa = gpa
    end

    def has_honors()
        if @gpa >= 2.5
            return true
        end
        return false
    end
end

student1 = Student.new("Jim", "Business", 2.6)
student2 = Student.new("JOker", "Developer", 3)
puts student1.has_honors
```

## 继承

```ruby
class Object
    def method()
        puts "super class method called!"
    end
end

class Chef <  Object
end

obj = Object.new()
obj.method

chef = Chef.new()
chef.method
```

## 模块

```ruby
module Tools

    def sayhi(name)
        puts "Hello #{name}"
    end

    def saybye(name)
        puts "bye #{name}"
    end
end

include Tools

Tools.sayhi("joker")
Tools.saybye("joker")
```

```ruby
require_relative "/relative/path/to/module.rb"
include Tools

Tools.sayhi("joker")
Tools.saybye("joker")
```

## 交互式ruby(irb)

```bash
$ irb -v
```

## 开发环境隔离

使用`[RVM](http://rvm.io)`