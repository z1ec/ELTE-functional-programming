-- ============================================================================
-- 02. РЕКУРСИЯ ПО ЧИСЛАМ И ПОСЛЕДОВАТЕЛЬНОСТИ  (ranges, iterate, takeWhile)
-- ============================================================================
-- Тренажёр. Решения: ../solutions/02_recursion_sequences.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 02_recursion_sequences.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 02_recursion_sequences.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm2 #11, midterm3 #2, midterm3 #4, midterm5 #4, midterm5 #7, midterm6 #1, midterm6 #4

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Рекурсия = базовый случай + шаг, который приближает к базе:
--     fact 0 = 1
--     fact n = n * fact (n - 1)
-- Несколько базовых случаев (как у Фибоначчи):
--     fib 0 = 0
--     fib 1 = 1
--     fib n = fib (n - 1) + fib (n - 2)
-- Проверка аргумента — guard ПЕРЕД рекурсией:
--     f n | n < 0     = error "invalid argument"
--         | n == 0    = ...
--         | otherwise = ...
--
-- Диапазоны (ranges):
--     [1..5]        == [1,2,3,4,5]
--     [1,3..10]     == [1,3,5,7,9]       -- шаг задаётся вторым элементом
--     [10,8..1]     == [10,8,6,4,2]      -- убывающий
--     [5..1]        == []                -- без шага вниз не идёт!
--
-- Генератор с условием (list comprehension):
--     [x * x | x <- [1..10], even x]  == [4,16,36,64,100]
--
-- Бесконечные списки + обрезка:
--     iterate (*2) 1                   == [1,2,4,8,16,...]   (бесконечный!)
--     take 4 (iterate (+3) 1)          == [1,4,7,10]
--     takeWhile (< 20) (iterate (*2) 1) == [1,2,4,8,16]
--     replicate 3 'x'                  == "xxx"
--
-- Быстрые числа Фибоначчи (без экспоненциальной рекурсии) — пары (a, b):
--     iterate (\(a, b) -> (b, a + b)) (0, 1) == [(0,1),(1,1),(1,2),(2,3),(3,5),...]
--     map fst (...)                          == [0,1,1,2,3,5,...]
--
-- Числа -> строка:
--     show 42                           == "42"
--     concatMap (\x -> show x ++ " ") [1,2,3] == "1 2 3 "
--     unwords (map show [1,2,3])        == "1 2 3"     (без пробела в конце!)

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: сопоставление с образцом (pattern matching) и рекурсия
--   Функцию можно задать несколькими строками — для разных входов.
--   Haskell пробует строки СВЕРХУ ВНИЗ и берёт первую подходящую:
--       isZero 0 = True        -- если аргумент ровно 0
--       isZero n = False       -- иначе (n — любое число)
--   Рекурсия: ответ для n выражается через ответ для n - 1:
--       5! = 5 * 4!,   4! = 4 * 3!,   ...,   0! = 1
--   0! = 1 — это база: без неё рекурсия никогда не остановится.
--   Как считается factorial 3:
--       3 * factorial 2 = 3 * (2 * factorial 1) = 3 * (2 * (1 * factorial 0)) = 3*2*1*1 = 6
--   ПЛАН: строка для 0, строка для n.
--
-- A1. Факториал рекурсией.
factorial :: Int -> Int
factorial = undefined
-- main = print (factorial 5)  -- 120
-- main = print (factorial 0)  -- 1

-- >>> ТЕОРИЯ: та же схема, что в A1
--   sumTo 3 = 3 + sumTo 2 = 3 + (2 + sumTo 1) = 3 + 2 + (1 + sumTo 0) = 6
--   База для суммы — 0 (а для произведения была 1).
--
-- A2. Сумма 1 + 2 + ... + n рекурсией (без sum).
sumTo :: Int -> Int
sumTo = undefined
-- main = print (sumTo 10)  -- 55
-- main = print (sumTo 0)  -- 0

-- >>> ТЕОРИЯ: рекурсия по одному из двух аргументов, _
--   power a n: n уменьшаем, а a передаём дальше без изменений:
--       power 2 3 = 2 * power 2 2 = 2 * 2 * power 2 1 = 2 * 2 * 2 * power 2 0 = 8
--   База: a^0 = 1 для любого a. Если аргумент не нужен, вместо имени пишут _ :
--       power _ 0 = 1
--
-- A3. Степень a^n рекурсией (без ^).
power :: Int -> Int -> Int
power = undefined
-- main = print (power 2 10)  -- 1024
-- main = print (power 5 0)  -- 1

-- >>> ТЕОРИЯ: диапазоны (ranges)
--   [1..5] == [1,2,3,4,5]
--   [a..b] — от a до b включительно; если a > b, получится пустой список.
--   С шагом: напиши ДВА первых элемента, шаг — их разность:
--       [1,3..10] == [1,3,5,7,9]        [0,5..20] == [0,5,10,15,20]
--   В конец можно не попасть: список просто остановится, не перейдя его.
--   Чётные, начиная с 2:  [2,4..n]
--
-- A4. Все чётные числа от 1 до n — через range с шагом.
evensUpTo :: Int -> [Int]
evensUpTo = undefined
-- main = print (evensUpTo 10)  -- [2,4,6,8,10]
-- main = print (evensUpTo 1)  -- []

-- >>> ТЕОРИЯ: убывающий диапазон
--   [5..1] == []  — без шага Haskell идёт только вверх!
--   Вниз — с отрицательным шагом:  [10,8..1] == [10,8,6,4,2]
--   Обратный отсчёт по 1: первый n, второй n - 1, конец 1:  [n, n - 1 .. 1]
--   При n = 0 получится [0, -1 .. 1] == [] — то, что нужно.
--
-- A5. Обратный отсчёт n, n-1, ..., 1.
countdown :: Int -> [Int]
countdown = undefined
-- main = print (countdown 5)  -- [5,4,3,2,1]
-- main = print (countdown 0)  -- []

-- >>> ТЕОРИЯ: генератор списка (list comprehension)
--   [ВЫРАЖЕНИЕ | x <- СПИСОК] читается "для каждого x из СПИСКА положи ВЫРАЖЕНИЕ":
--       [x + 1 | x <- [1,2,3]]   == [2,3,4]
--       [x * 10 | x <- [1..4]]   == [10,20,30,40]
--   Это то же самое, что map, только запись другая.
--
-- A6. Квадраты чисел от 1 до n — list comprehension.
squaresUpTo :: Int -> [Int]
squaresUpTo = undefined
-- main = print (squaresUpTo 5)  -- [1,4,9,16,25]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: две базы
--   fib 0 = 0, fib 1 = 1, а дальше каждое число — сумма двух предыдущих:
--       0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 ...
--   Рекурсия с ДВУМЯ вызовами:  fib n = fib (n - 1) + fib (n - 2)
--   Поэтому нужны ДВЕ базовые строки (для 0 и для 1), иначе fib 1 вызовет fib (-1).
--   Минус такого способа: для больших n очень медленно
--   (fib 30 считает одни и те же значения миллионы раз).
--
-- B1. n-е число Фибоначчи (fib 0 = 0, fib 1 = 1) — обычной рекурсией.
fib :: Int -> Int
fib = undefined
-- main = print (fib 10)  -- 55
-- main = print (fib 1)  -- 1

-- >>> ТЕОРИЯ: iterate, take, пары, fst, лямбда с образцом
--   iterate f x = [x, f x, f (f x), ...] — БЕСКОНЕЧНЫЙ список:
--       iterate (* 2) 1 == [1,2,4,8,16,...]
--   take n xs — первые n элементов:  take 3 (iterate (* 2) 1) == [1,2,4]
--   Бесконечного списка бояться не надо: Haskell ленивый и считает только то, что взяли.
--   Пара (a, b) — два значения вместе:  fst (a, b) == a,   snd (a, b) == b
--   Лямбда может сразу разобрать пару:  \(a, b) -> (b, a + b)
--   ИДЕЯ: храним два соседних числа Фибоначчи и сдвигаемся на шаг:
--       (0,1) -> (1,1) -> (1,2) -> (2,3) -> (3,5) -> ...
--       iterate (\(a, b) -> (b, a + b)) (0, 1) == [(0,1),(1,1),(1,2),(2,3),...]
--   Первые элементы пар — это и есть 0,1,1,2,3,...  ->  map fst (...)
--   ПЛАН: take n (map fst (iterate ... ...))
--
-- B2. Первые n чисел Фибоначчи — БЫСТРО, через iterate по парам.
fibs :: Int -> [Int]
fibs = undefined
-- main = print (fibs 8)  -- [0,1,1,2,3,5,8,13]
-- main = print (fibs 0)  -- []

-- >>> ТЕОРИЯ: guards + рекурсия + error
--   Когда несколько баз и проверка аргумента вместе, удобнее guards:
--       f n
--         | n < 0     = error "..."
--         | n == 0    = ...
--         | n == 1    = ...
--         | otherwise = ... f (n - 1) ... f (n - 2) ...
--   Последовательность Пелля: 0, 1, 2, 5, 12, 29   (2*12 + 5 = 29)
--   Это прямая подготовка к C1 (jacobsthal).
--
-- B3. Числа Пелля: P(0) = 0, P(1) = 1, P(n) = 2 * P(n-1) + P(n-2).
-- Для отрицательного n — error "invalid argument".
pell :: Int -> Int
pell = undefined
-- main = print (pell 5)  -- 29
-- main = print (pell 0)  -- 0
-- main = print (pell (-1))  -- error: invalid argument

-- >>> ТЕОРИЯ: takeWhile
--   takeWhile p xs берёт элементы С НАЧАЛА, пока p верно; на первом "нет" — стоп:
--       takeWhile (< 10) [1,5,9,12,3]       == [1,5,9]     -- 3 уже не попадёт!
--       takeWhile (<= 20) (iterate (+ 7) 0) == [0,7,14]
--   take — "сколько штук взять", takeWhile — "брать, пока выполняется условие".
--   ПЛАН: степени двойки = iterate (* 2) 1, обрезать по (<= n).
--
-- B4. Все степени двойки, не превосходящие n (iterate + takeWhile).
powersOf2Upto :: Int -> [Int]
powersOf2Upto = undefined
-- main = print (powersOf2Upto 100)  -- [1,2,4,8,16,32,64]
-- main = print (powersOf2Upto 64)  -- [1,2,4,8,16,32,64]

-- >>> ТЕОРИЯ: построение списка через (:)
--   x : xs кладёт x в НАЧАЛО списка xs:   1 : [2,3] == [1,2,3]
--   Рекурсия, которая строит список:  "текущее значение : остальное рекурсивно".
--   Для Коллатца база — 1 -> [1]. Иначе  n : collatz (следующее),
--   а следующее выбираем guard'ом: even n -> n `div` 2, иначе 3 * n + 1.
--
-- B5. Последовательность Коллатца: чётное -> n/2, нечётное -> 3n+1, стоп на 1.
collatz :: Int -> [Int]
collatz = undefined
-- main = print (collatz 6)  -- [6,3,10,5,16,8,4,2,1]
-- main = print (collatz 1)  -- [1]

-- >>> ТЕОРИЯ: show, ++ для строк, concatMap
--   show 42 == "42";  строки склеиваются через ++ :   "42" ++ " " == "42 "
--   concatMap f xs: применить f к каждому элементу (получатся строки) и склеить их:
--       concatMap (\x -> show x ++ "!") [1,2] == "1!2!"
--   (это то же самое, что concat (map f xs))
--   Пустой список даст "" автоматически.
--
-- B6. Склеить числа в строку, после КАЖДОГО числа пробел.
joinNumbers :: [Int] -> String
joinNumbers = undefined
-- main = print (joinNumbers [1,2,3])  -- "1 2 3 "
-- main = print (joinNumbers [])  -- ""

-- >>> ТЕОРИЯ: генератор с условием
--   [ВЫРАЖЕНИЕ | x <- СПИСОК, УСЛОВИЕ] — берутся только x, для которых УСЛОВИЕ True:
--       [x | x <- [1..10], even x]     == [2,4,6,8,10]
--       [x * x | x <- [1..5], x > 2]   == [9,16,25]
--   Потом sum. При n = 0 диапазон [1..0] пустой, и sum [] = 0.
--
-- B7. Сумма квадратов нечётных чисел от 1 до n.
sumOddSquares :: Int -> Int
sumOddSquares = undefined
-- main = print (sumOddSquares 5)  -- 35
-- main = print (sumOddSquares 0)  -- 0

-- >>> ТЕОРИЯ: iterate + takeWhile с аргументами
--   iterate (+ step) start == [start, start+step, start+2*step, ...]
--   takeWhile (<= end) обрезает, когда перевалили за end.
--   Если start > end, то уже первый элемент не проходит, и получится [].
--
-- B8. Числа от start до end (включительно) с шагом step. start > end -> [].
rangeStep :: Int -> Int -> Int -> [Int]
rangeStep = undefined
-- main = print (rangeStep 1 10 3)  -- [1,4,7,10]
-- main = print (rangeStep 5 1 2)  -- []

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: это B3 с другой формулой
--   a(n) = a(n-1) + 2 * a(n-2):   0, 1, 1, 3, 5, 11, ...     jacobsthal 4 == 5
--   "Check if n is valid": отрицательный n -> error "invalid argument"
--   (текст ошибки взят из теста sample).
--
-- C1. [midterm3 #2]
-- Find the n-th value of the Jacobsthal number sequence.
-- a(n) = a(n − 1) + (2 * a(n − 2)) for n >= 2, with a(0) = 0, a(1) = 1.
-- Check if n is valid.
jacobsthal :: Int -> Int
jacobsthal = undefined
-- main = print (jacobsthal 4)  -- 5
-- main = print (jacobsthal 16)  -- 21845
-- main = print (jacobsthal 0)  -- 0
-- main = print (jacobsthal 1)  -- 1
-- main = print (jacobsthal (-4))  -- error: invalid argument

-- >>> ТЕОРИЯ к C2: take + iterate
--   Нужно n первых членов, каждый следующий = предыдущий + d.
--   iterate (+ d) a даёт бесконечную прогрессию, take n берёт нужное количество.
--   d может быть отрицательным: (+ d) с d = -10 работает.
--
-- C2. [midterm3 #4]
-- Write a function which takes `a` as a first term, `d` as a common difference,
-- and `n` as the number of terms in the arithmetic sequence,
-- and returns the arithmetic sequence.  a=1, d=2, n=5 -> [1,3,5,7,9]
arithmeticSequence :: Int -> Int -> Int -> [Int]
arithmeticSequence = undefined
-- main = print (arithmeticSequence 1 2 5)  -- [1,3,5,7,9]
-- main = print (arithmeticSequence 2 3 4)  -- [2,5,8,11]
-- main = print (arithmeticSequence 0 (-10) 20)  -- [0,-10,-20,-30,-40,-50,-60,-70,-80,-90,-100,-110,-120,-130,-140,-150,-160,-170,-180,-190]

-- >>> ТЕОРИЯ к C3: образец по Bool + генератор с условием
--   Можно сделать две строки, для True и для False:
--       f a b True  = ...
--       f a b False = ...
--   (или  if flag then ... else ...)
--   Внутри — генератор как в B7:  [x ^ 2 | x <- [start..end], even x]
--   Если start > end, [start..end] пустой, и ответ [] получится сам.
--
-- C3. [midterm2 #11]
-- Write a function that takes three parameters: two integers, start and end,
-- and a Boolean value. If value is True, return the squares of even integers
-- in [start..end]. If value is False, return the cubes of odd integers.
-- Return an empty list if start is greater than end.
generateFiltered :: Int -> Int -> Bool -> [Int]
generateFiltered = undefined
-- main = print (generateFiltered 1 10 True)  -- [4,16,36,64,100]
-- main = print (generateFiltered 1 10 False)  -- [1,27,125,343,729]
-- main = print (generateFiltered (-4) 4 True)  -- [16,4,0,4,16]
-- main = print (generateFiltered (-4) 4 False)  -- [-27,-1,1,27]
-- main = print (generateFiltered 5 1 True)  -- []

-- >>> ТЕОРИЯ к C4: два генератора и разность
--   (сумма квадратов чётных) - (сумма квадратов нечётных): два  sum [...]  через минус,
--   каждый как в B7.
--   5:  (4 + 16) - (1 + 9 + 25) = 20 - 35 = -15
--
-- C4. [midterm6 #1]
-- Write a function that takes an integer n and sum the squares of even numbers
-- and subtract the sum of squares of odd numbers, in the range of 1 to n.
-- 5 -> 2^2 + 4^2 - 1^2 - 3^2 - 5^2 = -15
-- (В описании sample написано "10" и "220" — это опечатки, верные ответы в тестах.)
sumAlternatingSquares :: Int -> Int
sumAlternatingSquares = undefined
-- main = print (sumAlternatingSquares 5)  -- -15
-- main = print (sumAlternatingSquares 10)  -- 55
-- main = print (sumAlternatingSquares 7)  -- -28

-- >>> ТЕОРИЯ к C5: B8 + B6
--   Числа:  takeWhile (<= end) (iterate (+ inc) start)
--   Строка: каждое число плюс пробел, всё склеить — это joinNumbers из B6.
--   generateSumString 11 10 5: чисел нет, ответ "".
--
-- C5. [midterm6 #4]
-- Write a function that takes a starting number, an ending, and an increment.
-- It generates a string with numbers starting from the initial value, adding the
-- increment repeatedly until the next number would be greater than the ending number.
-- start = 1, end = 10, increment = 2  ->  "1 3 5 7 9 "
generateSumString :: Int -> Int -> Int -> String
generateSumString = undefined
-- main = print (generateSumString 1 10 2)  -- "1 3 5 7 9 "
-- main = print (generateSumString 0 15 5)  -- "0 5 10 15 "
-- main = print (generateSumString 10 10 2)  -- "10 "
-- main = print (generateSumString 11 10 5)  -- ""

-- >>> ТЕОРИЯ к C6: то же, что C5, но умножение
--   iterate (* step) start:  1, 2, 4, 8, 16, ...   и обрезать по (<= end).
--
-- C6. [midterm5 #4]  (в sample называется тоже generateSumString)
-- Same, but MULTIPLY by step repeatedly until the next number would be
-- greater than the ending number.  start = 1, end = 10, step = 2 -> "1 2 4 8 "
generateMulString :: Int -> Int -> Int -> String
generateMulString = undefined
-- main = print (generateMulString 2 12 2)  -- "2 4 8 "
-- main = print (generateMulString 1 10 2)  -- "1 2 4 8 "
-- main = print (generateMulString 1 15 5)  -- "1 5 "
-- main = print (generateMulString 10 10 2)  -- "10 "
-- main = print (generateMulString 11 10 5)  -- ""

-- >>> ТЕОРИЯ к C7: суммы чисел Фибоначчи
--   "Up to that value inclusive": для 3 это fib 0 + fib 1 + fib 2 + fib 3 = 0+1+1+2 = 4.
--   То есть первые (n + 1) чисел Фибоначчи:  fibs (n + 1) из B2, потом sum.
--   t2 — просто map fibSum по списку.
--   Почему не fib из B1: на t2 [20,30] медленный fib будет считать очень долго.
--
-- C7. [midterm5 #7]
-- Given a list of integers, return a list where each integer is replaced with
-- the sum of Fibonacci numbers up to that integer's value inclusive.
-- [3,4] -> [4,7]:  up to 3 is 0+1+1+2 = 4,  up to 4 is 0+1+1+2+3 = 7
-- (fib — из B1. Для t2 [20,30] обычный fib медленный — используй fibs из B2.)
fibSum :: Int -> Int
fibSum = undefined
-- main = print (fibSum 3)  -- 4
-- main = print (fibSum 0)  -- 0

t2 :: [Int] -> [Int]
t2 = undefined
-- main = print (t2 [3, 4])  -- [4,7]
-- main = print (t2 [6, 8])  -- [20,54]
-- main = print (t2 [5,6,7,0])  -- [12,20,33,0]
-- main = print (t2 [20,30])  -- [17710,2178308]
-- main = print (t2 [])  -- []
