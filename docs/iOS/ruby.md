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
