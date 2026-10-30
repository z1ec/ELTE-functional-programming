-- ============================================================================
-- 12. DOUBLE, СРЕДНИЕ, МИН/МАКС ПО КЛЮЧУ, "ОТЧЁТЫ"  (fromIntegral, sort, minimumBy)
-- ============================================================================
-- Тренажёр. Решения: ../solutions/12_doubles_aggregation.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 12_doubles_aggregation.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 12_doubles_aggregation.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm2 #8, midterm3 #6, midterm3 #12, midterm4 #11, midterm4 #12,
--   midterm5 #5, midterm6 #5, midterm6 #9

import Data.List (sort, sortOn, minimumBy, maximumBy)
import Data.Ord (comparing)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Int и Double НЕ смешиваются сами:
--     length xs :: Int,  sum ds :: Double  ->  sum ds / length xs   -- ОШИБКА типов
--     sum ds / fromIntegral (length ds)                            -- ok
--   fromIntegral превращает Int (Integer) в любой числовой тип.
--   Деление: (/) — для Double, `div` — для Int.
--
-- Среднее:
--     avg xs = sum xs / fromIntegral (length xs)
--     avg [] == NaN   (0/0)  — в некоторых тестах sample это и ожидается!
--   Среднее целых:  fromIntegral (sum xs) / fromIntegral (length xs)
--
-- Double печатается "некрасиво" — это нормально:
--     0.1 + 0.2 == 0.30000000000000004
--   Ответы в sample часто "округлены человеком" — твой вывод может отличаться
--   в последних знаках. Float (не Double) печатает меньше знаков.
--
--     sqrt 16 == 4.0       x ** 0.5 — тоже корень       abs, (^) — степень
--
-- Минимум/максимум ПО КЛЮЧУ:
--   (1) кортежи сравниваются по первому элементу, потом по второму:
--         minimum [(3.2,"p1"),(2.0,"p2")] == (2.0,"p2")
--       => кладём ключ ПЕРВЫМ:  snd (minimum [(dist p, name) | ...])
--   (2) minimumBy / maximumBy с comparing  (import Data.List, Data.Ord):
--         maximumBy (comparing snd) [("a",3),("b",5)] == ("b",5)
--         minimumBy (comparing (\x -> abs (x - 10))) [3,8,15,11] == 11
--       при равенстве minimumBy берёт ПЕРВЫЙ, maximumBy — ПОСЛЕДНИЙ.
--
-- Сортировка:
--     sort [3,1,2] == [1,2,3]
--     sortOn snd [("a",3),("b",1)] == [("b",1),("a",3)]
--     sortOn negate xs  — по убыванию
--
-- Медиана: отсортировать; если длина нечётная — средний, иначе среднее двух средних.
--     xs !! (n `div` 2)  и  xs !! (n `div` 2 - 1)
--
-- Тройки (имя, возраст, зарплата) разбираем образцом: [s | (_, a, s) <- emps, a > 50]
--
-- Ошибка на пустом входе — первым guard'ом, ДО вызова minimum/maximum/head.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: деление Double и fromIntegral
--   / — деление для дробных:   7 / 2 == 3.5
--   length возвращает Int, а sum xs здесь Double, поэтому  sum xs / length xs  — ОШИБКА типов.
--   Нужно:   sum xs / fromIntegral (length xs)
--
-- A1. Среднее списка Double.
average :: [Double] -> Double
average = undefined
-- main = print (average [1,2,3,4])  -- 2.5

-- >>> ТЕОРИЯ: обе части в Double
--   sum xs — Int, length xs — Int. Обе через fromIntegral, потом /.
--
-- A2. Среднее списка Int (ответ Double).
averageInt :: [Int] -> Double
averageInt = undefined
-- main = print (averageInt [1,2])  -- 1.5

-- >>> ТЕОРИЯ: fromIntegral и /
--   fromIntegral n / 2
--
-- A3. Половина целого числа как Double.
half :: Int -> Double
half = undefined
-- main = print (half 3)  -- 1.5

-- >>> ТЕОРИЯ: sqrt
--   sqrt 25 == 5.0.    Гипотенуза = sqrt (a*a + b*b).
--
-- A4. Гипотенуза.
hypotenuse :: Double -> Double -> Double
hypotenuse = undefined
-- main = print (hypotenuse 3 4)  -- 5.0

-- >>> ТЕОРИЯ: сравнение пар
--   Пары сравниваются по первому элементу, а при равенстве — по второму:
--       (8,15) < (9,0)   == True        (8,5) < (8,15) == True
--   Поэтому время (часы, минуты) можно сравнивать напрямую:  minimum ts
--
-- A5. Самое раннее время (часы, минуты) из списка.
earliest :: [(Int, Int)] -> (Int, Int)
earliest = undefined
-- main = print (earliest [(10,30),(8,15),(9,0),(8,5)])  -- (8,5)

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: error + переиспользование
--   safeAverage [] = error "...";   иначе — average из A1.
--
-- B1. Среднее, но для пустого списка — error "empty list".
safeAverage :: [Double] -> Double
safeAverage = undefined
-- main = print (safeAverage [2,4])  -- 3.0
-- main = print (safeAverage [])  -- error: empty list

-- >>> ТЕОРИЯ: сравнение Int с Double
--   x — Int, среднее — Double, поэтому  fromIntegral x > averageInt xs
--
-- B2. Числа строго больше среднего.
aboveAverage :: [Int] -> [Int]
aboveAverage = undefined
-- main = print (aboveAverage [1,2,3,4,10])  -- [10]

-- >>> ТЕОРИЯ: maximumBy, comparing
--   maximumBy (comparing snd) ps — пара с наибольшим ВТОРЫМ элементом:
--       maximumBy (comparing snd) [("A",3),("B",5)] == ("B",5)
--   (maximumBy из Data.List, comparing из Data.Ord — уже импортированы наверху)
--   Потом fst — это имя.
--   Другой способ:  snd (maximum [(score, name) | (name, score) <- ps])
--
-- B3. Имя студента с максимальным баллом.
bestStudent :: [(String, Int)] -> String
bestStudent = undefined
-- main = print (bestStudent [("A",3),("B",5),("C",4)])  -- "B"

-- >>> ТЕОРИЯ: minimumBy с вычисленным ключом
--   comparing принимает любую функцию-ключ:
--       minimumBy (comparing (\x -> abs (x - t))) xs
--   — элемент с наименьшим расстоянием до t. При равенстве берётся первый.
--
-- B4. Число из списка, ближайшее к t (при равенстве — первое).
closestTo :: Int -> [Int] -> Int
closestTo = undefined
-- main = print (closestTo 10 [3,8,15,11])  -- 11
-- main = print (closestTo 10 [8,12])  -- 8

-- >>> ТЕОРИЯ: sort, !!, where с несколькими именами
--   sort [3,1,2] == [1,2,3]
--   s !! i — элемент на позиции i (с 0).
--   Нечётная длина n: середина  s !! (n `div` 2)                   [1,2,3]: s !! 1 = 2
--   Чётная: среднее  s !! (n `div` 2 - 1)  и  s !! (n `div` 2)      [1,2,3,4]: (2+3)/2
--   В where можно задать несколько имён:
--       where s = sort xs
--             n = length xs
--
-- B5. Медиана (список непустой).
median :: [Double] -> Double
median = undefined
-- main = print (median [3,1,2])  -- 2.0
-- main = print (median [4,1,3,2])  -- 2.5

-- >>> ТЕОРИЯ: тройка в ответе
--   (minimum xs, maximum xs, averageInt xs)
--
-- B6. (минимум, максимум, среднее) списка Int (список непустой).
stats :: [Int] -> (Int, Int, Double)
stats = undefined
-- main = print (stats [3,1,2])  -- (1,3,2.0)

-- >>> ТЕОРИЯ: sortOn
--   sortOn key xs сортирует по ключу (по возрастанию):
--       sortOn snd [("a",3),("b",1)] == [("b",1),("a",3)]
--   По убыванию — ключ со знаком минус:   sortOn (\(_, s) -> negate s) ps
--
-- B7. Отсортировать студентов по баллу ПО УБЫВАНИЮ.
rankStudents :: [(String, Int)] -> [(String, Int)]
rankStudents = undefined
-- main = print (rankStudents [("A",3),("B",5),("C",4)])  -- [("B",5),("C",4),("A",3)]

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: averageInt для каждой пары
--   [(n, averageInt ss) | (n, ss) <- ps]
--   Пустые оценки: 0/0 = NaN — именно это и ждёт тест.
--
-- C1. [midterm2 #8]
-- Write a function that takes a list of tuples, where each tuple contains a
-- student's name and a list of their scores. Return a list of tuples with each
-- student's name and their average score.
averageScores :: [(String, [Int])] -> [(String, Double)]
averageScores = undefined
-- main = print (averageScores [("Alice", [10, 20, 30]), ("Bob", [20, 30, 40])])  -- [("Alice",20.0),("Bob",30.0)]
-- main = print (averageScores [("Charlie", [100]), ("David", [50])])  -- [("Charlie",100.0),("David",50.0)]
-- main = print (averageScores [("Eve", []), ("Frank", [90, 80])])  -- [("Eve",NaN),("Frank",85.0)]
-- main = print (averageScores [("George", [10, 20, 30, 40]), ("Hannah", [5])])  -- [("George",25.0),("Hannah",5.0)]
-- main = print (averageScores [])  -- []

-- >>> ТЕОРИЯ к C2: where с отфильтрованным списком
--   valid — цены > 0;  ответ  (sum valid, length valid).
--   Если valid пустой, (0.0, 0) получится сам.
--
-- C2. [midterm3 #12]
-- List of (product name, price). Filter out products with price <= 0 (invalid).
-- Return (total price of valid products, count of valid products).
-- If there are no valid products, return (0.0, 0).
-- (В sample опечатка 1225.98 — на самом деле 999.99 + 25.0 + 199.99 = 1224.98.)
analyzePrices :: [(String, Double)] -> (Double, Int)
analyzePrices = undefined
-- main = print (analyzePrices [("Laptop", 999.99), ("Mouse", 25.0), ("Keyboard", -10.0), ("Monitor", 199.99)])  -- (1224.98,3)
-- main = print (analyzePrices [("Book", -5.0), ("Pen", 0.0)])  -- (0.0,0)
-- main = print (analyzePrices [("Phone", 699.99), ("Charger", 19.99), ("Case", 0.0)])  -- (719.98,2)
-- main = print (analyzePrices [])  -- (0.0,0)

-- >>> ТЕОРИЯ к C3: среднее + подсчёт выше среднего
--   [] -> (0.0, 0) отдельной строкой (так в тестах).
--   valid — оценки от 0 до 100;   avg = averageInt valid;
--   count — сколько valid строго больше avg  (fromIntegral v > avg).
--
-- C3. [midterm4 #12]
-- List of exam scores. Filter out scores below 0 or above 100 (invalid).
-- Calculate the average of the valid scores, count how many scored above it.
-- Return (average, count).
-- (Тесты sample противоречивы: все невалидные -> (NaN,0), но [] -> (0.0,0).
--  Значит пустой ВХОД — отдельный случай.)
analyzeScores :: [Int] -> (Double, Int)
analyzeScores = undefined
-- main = print (analyzeScores [85, 92, 100, 67, -10, 120, 75])  -- (83.8,3)
-- main = print (analyzeScores [-5, 150, 200])  -- (NaN,0)
-- main = print (analyzeScores [50, 70, 90])  -- (70.0,1)
-- main = print (analyzeScores [])  -- (0.0,0)

-- >>> ТЕОРИЯ к C4: формула + Float
--   Float — как Double, только точность меньше. Формула:
--       sum (map (^ 2) xs) / n - (sum xs / n) ^ 2,    где n = fromIntegral (length xs)
--   [] -> error "Empty list is not allowed!"
--
-- C4. [midterm3 #6]
-- Calculate the variance of a list of floats:
-- (sigma x^2) / n  -  (sigma x / n)^2.   Empty list -> error "Empty list is not allowed!"
-- (В sample для третьего теста опечатка 3.888893 — на самом деле ~13.89.)
var :: [Float] -> Float
var = undefined
-- main = print (var [1.0, 2.0, 3.0, 4.0])  -- 1.25
-- main = print (var [5.0, 5.0, 5.0, 5.0])  -- 0.0
-- main = print (var [6.0, 7.0, 3.0, 9.0, 10.0, 15.0])  -- 13.888893
-- main = print (var [-1.0, 0.0, 1.0])  -- 0.6666667
-- main = print (var [10.0])  -- 0.0
-- main = print (var [10.0, 20.0, 30.0, 40.0, 50.0])  -- 200.0
-- main = print (var [])  -- error: Empty list is not allowed!

-- >>> ТЕОРИЯ к C5: any, лучший по ключу
--   any p xs — хотя бы один элемент удовлетворяет p.
--   "У кого-то нет оценок":   any (\(_, gs) -> null gs) ps     (или any (null . snd) ps)
--   Ошибка, если null ps или такой студент есть.
--   Лучший:  snd (maximum [(getAvg gs, n) | (n, gs) <- ps])   — среднее первым (см. A5 и B3).
--
-- C5. [midterm5 #5]
-- Given a list of students with name and grades, return the student with the best
-- grade average. Error "Empty List!" if the list is empty or a student has no grades.
getAvg :: [Double] -> Double
getAvg = undefined
-- main = print (getAvg [4.7, 3.7, 4.5])  -- 4.3

gradeAvg :: [(String, [Double])] -> String
gradeAvg = undefined
-- main = print (gradeAvg [("Saul", [3.2, 4.3, 4.4, 2.3]), ("Goodman", [4.7, 3.7, 4.5])])  -- "Goodman"
-- main = print (gradeAvg [("Walter", [4.7, 3.7, 4.5]), ("Jesse", [1.2, 2.342, 1.1231]), ("Hank", [])])  -- error: Empty List!
-- main = print (gradeAvg [])  -- error: Empty List!

-- >>> ТЕОРИЯ к C6: расстояние + minimumBy + сборка строки
--   dist: разности координат — Int, а sqrt нужен Double:  sqrt (fromIntegral (...))
--   Ближайшая точка:  minimumBy (comparing (\(_, q) -> dist q p)) ps,  потом fst — имя.
--   Строка:  closest ++ " is the closest to point " ++ pName
--   [] -> error "Empty list!" первой строкой.
--
-- C6. [midterm6 #5]
-- Given a list of points ("pointname",(x,y)) and another point p, return the point
-- which is closest to p in a string containing the name of both.
-- Error "Empty list!" in case the list is empty.  dist = sqrt((x2-x1)^2+(y2-y1)^2)
-- (В sample тесты то с "to point", то с "to our point" — выбрали как в условии.)
dist :: (Int, Int) -> (Int, Int) -> Double
dist = undefined
-- main = print (dist (0, 0) (3, 4))  -- 5.0

distanceCalc :: [(String, (Int, Int))] -> (String, (Int, Int)) -> String
distanceCalc = undefined
-- main = print (distanceCalc [("p1", (0, 0))] ("p2", (4, 0)))  -- "p1 is the closest to point p2"
-- main = print (distanceCalc [("p1", (-1, -1)), ("p2", (2, 2)), ("p3", (-2, 4))] ("c1", (2, 0)))  -- "p2 is the closest to point c1"
-- main = print (distanceCalc [("p1", (2, -5)), ("p2", (3, -3)), ("p1", (1, 3))] ("k1", (0, 0)))  -- "p1 is the closest to point k1"
-- main = print (distanceCalc [] ("n1", (5, -2)))  -- error: Empty list!

-- >>> ТЕОРИЯ к C7: отфильтровать, проверить пустоту, minimum
--   times = [t | (d, t) <- buses, d == dest]   (в where)
--   null times -> error;  иначе minimum times (время-пары сравниваются правильно, см. A5).
--
-- C7. [midterm4 #11]
-- List of buses (destination, (hours, minutes)) and your destination.
-- Return the earliest arrival time to your destination.
-- If there is no bus there, error "No bus to the destination".
-- (Венгерские названия остановок в тестах упрощены до латиницы.)
earliestBus :: [(String, (Int, Int))] -> String -> (Int, Int)
earliestBus = undefined
-- main = print (earliestBus [("Keleti", (10, 30)), ("Deak", (8, 15)), ("Deak", (9, 30)), ("Deak", (8, 45)), ("Kalvin", (11, 0))] "Deak")  -- (8,15)
-- main = print (earliestBus [("Keleti", (10, 30)), ("Deak", (8, 15)), ("Keleti", (10, 0)), ("Deak", (9, 30)), ("Kalvin", (11, 0)), ("Keleti", (11, 45))] "Keleti")  -- (10,0)
-- main = print (earliestBus [("Keleti", (10, 30)), ("Deak", (8, 15)), ("Deak", (9, 30)), ("Kalvin", (11, 0))] "Kalvin")  -- (11,0)
-- main = print (earliestBus [("Szell", (6, 30)), ("Szell", (6, 15)), ("Szell", (7, 0)), ("Keleti", (8, 0))] "Szell")  -- (6,15)
-- main = print (earliestBus [("Keleti", (10, 30))] "Moon")  -- error: No bus to the destination

-- >>> ТЕОРИЯ к C8: тройки + median из B5
--   1) зарплаты как Double:  [fromIntegral s | (_, _, s) <- emps],  потом median
--   2) сумма прибавок 10%:   [fromIntegral s * 0.1 | (_, a, s) <- emps, a > 50],  потом sum
--   3) кто не получит прибавку: возраст <= 50
--   4) возраст < 30 и зарплата > 250
--
-- C8. [midterm6 #9]  (20 баллов, 4 части)
-- Employees (name, age, salary).
-- 1. Median salary (even number of employees -> average of the two middle ones).
-- 2. Salaries +10% for employees older than 50: the total INCREASE
--    (по тесту sample ответ 127.2 — это сумма прибавок, а не новый фонд зарплат).
-- 3. Names of those who can not get the salary increase.
-- 4. Names of employees younger than 30 who earn more than 250.
-- median — из B5.
medianSalary :: [(String, Int, Int)] -> Double
medianSalary = undefined
-- main = print (medianSalary [("John", 23, 200), ("Bob", 60, 700), ("Anna", 38, 427), ("Joe", 36, 289), ("Doe", 22, 384), ("Marie", 55, 572), ("Lucy", 37, 400)])  -- 400.0

newPay :: [(String, Int, Int)] -> Double
newPay = undefined
-- main = print (newPay [("John", 23, 200), ("Bob", 60, 700), ("Anna", 38, 427), ("Joe", 36, 289), ("Doe", 22, 384), ("Marie", 55, 572), ("Lucy", 37, 400)])  -- 127.2

namesNoinc :: [(String, Int, Int)] -> [String]
namesNoinc = undefined
-- main = print (namesNoinc [("John", 23, 200), ("Bob", 60, 700), ("Anna", 38, 427), ("Joe", 36, 289), ("Doe", 22, 384), ("Marie", 55, 572), ("Lucy", 37, 400)])  -- ["John","Anna","Joe","Doe","Lucy"]

namesYounger30 :: [(String, Int, Int)] -> [String]
namesYounger30 = undefined
-- main = print (namesYounger30 [("John", 23, 200), ("Bob", 60, 700), ("Anna", 38, 427), ("Joe", 36, 289), ("Doe", 22, 384), ("Marie", 55, 572), ("Lucy", 37, 400)])  -- ["Doe"]
