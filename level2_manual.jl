# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
const PI = 3.14159 
PI = 3.14
# println(PI)
# const PI - константа, т.е. значение переменной меняться не должно
# Однако при попытке изменить значение, интерпретатор предупреждает, что нельзя менять значение константы

# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1
b = 2.0
c = a + b
# переменная с - float64, потому что при сложении возвращается значение с большим диапазоном

# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo"
# переменная а теперь является строкой. Тип переменной определяется текущим значением.

# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1
g = "hi"
# g явно указывает тип, поэтому присвоение ей строки невозможен - это ограничение биндинга в julia.

function greet()
    g = "hello"
    println(g)
end
greet()
# в методе g - локальная переменная, ее тип не объявлен явно, значит, ограничений у нее нет.

# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v
v[1] = 3
v = "hello"
z
# присвоение значений новому имени - меняет только биндинг имени, а мутация значений меняет объект. Т.е. v="hello" - меняет только биндинг имени, а v[1]=3 - меняет сам объект, т.к. после этого z = [3,2,3]  

# Написать тип, параметризованный другим типом
struct Point{T}
    x::T
    y::T
end
p1 = Point{Int}(1, 2)
p2 = Point{Float64}(1.5, 2.7)

#=
Написать функцию для двух аругментов, не указывая их тип,
и вторую функцию от двух аргментов с конкретными типами,
дать пример запуска
=#
my_add(x, y) = x + y
my_add_int(x::Int, y::Int) = x + y
println(my_add(3, 4.5))
println(my_add_int(3, 4))

#=
Абстрактный тип - ключевое слово?
Примитивный тип - ключевое слово?
Композитный тип - ключевое слово?
=#
# Абстрактный тип - abstract type
# Примитивный тип - primitive type
# Композитный тип - struct / mutable struct

#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#
abstract type Shape end
struct Circle <: Shape
    radius::Float64
end
struct Rectangle <: Shape
    width::Float64
    height::Float64
end

describe(s::Shape) = println("Метод для всех фигур: $s")
describe(c::Circle) = println("Override метод для круга $(c.radius)")

c = Circle(5.0)
r = Rectangle(3.0, 4.0)
describe(c)  # вызывается метод для Circle
describe(r)  # вызывается общий метод для Shape (любой фигуры унаследованной от Shape)


#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

# Пример обычной функции
function greet_person(name)
    return "Привет, $name!"
end

# Пример лямбда-функции (аннонимной функции)
square = x -> x^2

# Пример функции с переменным количеством аргументов
function sum_all_numbers(args...)
    return sum(args)
end

# Пример функции с именованными аргументами
function create_person(name; age=18, city="Санкт-Петербург")
    return "Имя: $name, Возраст: $age, Город: $city"
end

# Функции с переменным кол-вом именованных аргументов
function print_kwargs(; kwargs...)
    for (key, value) in kwargs
        println("$key = $value")
    end
end

#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#
function create_person(name, age, city)
    return ("Имя: $name, Возраст: $age, Город: $city")
end
person_info = ("Дима", 30, "Санкт-Петербург")
println(create_person(person_info...))  

function get_table(x)
    return x,2*x, 3*x, 4*x, 5*x
end
result = get_table(3) 
result[1] = 4



#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
- через loop fusion и
- с помощью reduce
=#
arr = [1, 2, 3, 4, 5]
product_fusion = prod(arr)
product_reduce = reduce(*, arr)

#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
с помощью точки (broadcast)
c помощью map
c помощью list comprehension
указать, чем это лучше явного цикла?
=#
double(x) = x * 2
numbers = [1, 2, 3, 4, 5]

result_broadcast = double.(numbers)
result_map = map(double, numbers)
result_comp = [double(x) for x in numbers]
# Это лучше явного цикла, потому что: код более читаемый, меньше шансов на ошибку, и в случае broadcast - может быть оптимизирован компилятором для лучшей производительности.

# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
row = [1 2 3]
col = [10, 20, 30]
result_mat = row * col  # скалярное произведение: 1*10 + 2*20 + 3*30 = 140

# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
data = [1, -2, 2, 3, 4, -5, 0]
result_filtered = [x for x in data if x > 0 && x % 2 == 0]

# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
# ---
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))
numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
numbers_sorted = sort(numbers)
number = findfirst(n -> !(n in numbers_sorted), 0:9)
# number - первое число от 0 до 9, которое НЕ встречается среди имён на "A"

# Упростить этот код обработки:
numbers = unique(parse(Int, split(x, "_")[end])
                 for x in names if startswith(x, "A"))

number = findfirst(n -> !(n in numbers), 0:9)


#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#

#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#
struct LazyArray <: AbstractArray{Int, 1}
    length::Int
end

Base.size(arr::LazyArray) = (arr.length,)
Base.getindex(arr::LazyArray, i::Int) = (i - 1)^2
Base.setindex!(arr::LazyArray, v, i) = error("This obj is immutable")

lazy_arr = LazyArray(5)

#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#
abstract type AbstractCommand end
apply!(cmd::AbstractCommand, target::Vector) = error("Not implemented for type $(typeof(cmd))")

struct SortCmd <: AbstractCommand
end

function apply!(cmd::SortCmd, target::Vector)
    sort!(target)
    return target
end

struct ChangeAtCmd <: AbstractCommand
    i::Int
    val::Any
end

function apply!(cmd::ChangeAtCmd, target::Vector)
    target[cmd.i] = cmd.val
    return target
end

# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
sort_cmd = v -> sort!(v)
change_at_cmd = (i, val) -> (v -> (v[i] = val))


#===========================================================================================
5. Тесты: как проверять функции?
=#

# Написать тест для функции
using Test

function sum(a, b)
    return a + b
end

@test sum(2, 3) == 5
@test sum(-1, 1) == 0
@test sum(0, 0) == 0


#===========================================================================================
6. Дебаг: как отладить функцию по шагам?
=#

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова
=#
function buggy_sum(arr)
    s = 0
    for i in 1:length(arr)
        s += arr[i+1] 
    end
    return s
end

using Debugger
@enter buggy_sum([1, 2, 3])


#===========================================================================================
7. Профилировщик: как оценить производительность функции?
=#

#=
Оценить производительность функции с помощью макроса @profview,
и добавить в этот репозиторий файл со скриншотом flamechart'а
=#
function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

using Profile, ProfileView
Profile.clear() 
@time generate_data(1_000_000);
ProfileView.view() 

# Переписать функцию выше так, чтобы она выполнялась быстрее:
function generate_data(len::Int)
     vec = Vector{Float64}(undef, len)
    for k in 1:len
        vec[k] = randn()
    end
    sort!(vec)                      
    mean_val = sum(vec) / len
    return vec .^ 3 .- mean_val
end

# using Profile, ProfileView
# Profile.clear() 
# @time generate_data(1_000_000);
# ProfileView.view() 


#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#

#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#
function first_diff(x::Vector)
    n = length(x)
    y = zeros(n)
    for i in 2:n
        y[i] = x[i] - x[i-1]
    end
    return y
end

x = [1, 3, 6, 10]
y = first_diff(x)  # y = [0, 2, 3, 4]

#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#
function first_diff!(y::Vector, x::Vector)
    n = length(x)
    y[1] = 0
    for i in 2:n
        y[i] = x[i] - x[i-1]
    end
    return y
end

x = [1, 3, 6, 10]
y = zeros(length(x))
first_diff!(y, x)  # y = [0, 2, 3, 4]

#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#
arr = [1, 2, 3, 4, 5]
push!(arr, 6)        # в конец
pushfirst!(arr, 0)   # в начало
insert!(arr, 4, 100) # в середину


#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
module Foo
    export say_hello

    say_hello() = println("Hello from Foo!")
    say_goodbye() = println("Goodbye from Foo!")
end

# using .Foo
# import .Foo
# Foo.say_hello()
# Foo.say_goodbye()


#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
# Environment - изолированное окружение с набором пакетов и их версий
# Задать: Pkg.activate("env")
# Поменять: Pkg.activate() - вернуться к глобальному окружению

# Что такое пакет (package), как добавить новый пакет?
# Пакет - библиотека Julia с Project.toml и src/ с кодом
# Добавить: Pkg.add("PackageName")

# Как начать разрабатывать чужой пакет?
# Pkg.develop("PackageName") - клонирует пакет в ~/.julia/dev/

#=
Как создать свой пакет?
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)
=#
# using PkgTemplates
# Template().generate("MyPackage")


#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#

# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
using JLD2
data = Dict("a" => 1, "b" => [1,2,3])
save("data.jld2", "data", data)
loaded = load("data.jld2", "data")

# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
using CSV, DataFrames
df = DataFrame(A=1:3, B=4:6)
CSV.write("data.csv", df)
loaded_df = CSV.read("data.csv", DataFrame)


#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?
=#
# julia --project
# julia --project=/path/env

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl
б) из текста команды? (см. флаг -e)
=#
# а) julia script.jl
# б) julia -e "println(2+2)"

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
