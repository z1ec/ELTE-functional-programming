-- ============================================================================
-- 03. ДЕЛИТЕЛИ, ПРОСТЫЕ ЧИСЛА, gcd
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/03_primes_divisors.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 03_primes_divisors.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 03_primes_divisors.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm2 #2 (это A4!), midterm1 #10, midterm3 #10, midterm6 #7
--   (isPrime ещё нужен в 09: midterm5 #10)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- d делит n  <=>  n `mod` d == 0
--
-- Все делители — генератор списка:
--     [d | d <- [1..n], n `mod` d == 0]          -- 12 -> [1,2,3,4,6,12]
-- Собственные делители (без самого n):
--     [d | d <- [1..n-1], n `mod` d == 0]        -- 12 -> [1,2,3,4,6]
--
-- Простое число: > 1 и нет делителей кроме 1 и себя.
--     isPrime n = n > 1 && null [d | d <- [2..n-1], n `mod` d == 0]
--   Быстрее — проверять только d, у которых d*d <= n:
--     isPrime n = n > 1 && all (\d -> n `mod` d /= 0) (takeWhile (\d -> d * d <= n) [2..])
--   null xs  — True, если список пустой
--   all p xs — True, если p верно для всех;  any p xs — хотя бы для одного
--
-- Простые до n:   [p | p <- [2..n], isPrime p]
--
-- gcd a b — наибольший общий делитель (встроен в Prelude):
--     gcd 12 18 == 6       gcd 8 15 == 1   (взаимно простые = coprime)
--
-- Индексы (подробно в тренажёре 07):  zip [0..] "abc" == [(0,'a'),(1,'b'),(2,'c')]
--     элементы на нечётных позициях:  [x | (i, x) <- zip [0..] xs, odd i]
--
-- Произведение пустого списка: product [] == 1  (а sum [] == 0)

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: делимость, генератор с условием
--   "d делит n" значит "остаток 0":   12 `mod` 3 == 0 (делит),   12 `mod` 5 == 2 (не делит)
--   Генератор с условием перебирает все d и оставляет подходящие:
--       [d | d <- [1..10], d `mod` 3 == 0] == [3,6,9]     -- числа, которые делятся на 3
--   Здесь наоборот: нужны d, НА КОТОРЫЕ делится n, то есть условие  n `mod` d == 0.
--
-- A1. Все делители n (от 1 до n).
divisors :: Int -> [Int]
divisors n = [d | d <- [1..n], n `mod` d == 0]
-- main = print (divisors 12)  -- [1,2,3,4,6,12]
-- main = print (divisors 7)  -- [1,7]

-- >>> ТЕОРИЯ: используй A1
--   length (divisors n).   Делители 12: [1,2,3,4,6,12], их 6.
--
-- A2. Количество делителей.
countDivisors :: Int -> Int
countDivisors n = length (divisors n)
-- main = print (countDivisors 12)  -- 6
-- main = print (countDivisors 1)  -- 1

-- >>> ТЕОРИЯ: диапазон без последнего
--   Как A1, но перебирать [1..n - 1].  При n = 1: [1..0] == [], делителей нет.
--
-- A3. Собственные делители (все, кроме самого n).
properDivisors :: Int -> [Int]
properDivisors n = [d | d <- [1..n - 1], n `mod` d == 0]
-- main = print (properDivisors 12)  -- [1,2,3,4,6]
-- main = print (properDivisors 1)  -- []

-- >>> ТЕОРИЯ: null, all, &&, takeWhile
--   Простое число: n > 1 И нет делителей от 2 до n-1.
--   null xs — True, если список пустой:   null [] == True,   null [3] == False
--   ВАРИАНТ 1 (простой, на экзамене хватит):
--       n > 1 && null [d | d <- [2..n - 1], n `mod` d == 0]
--   all p xs — True, если p верно для КАЖДОГО элемента:   all even [2,4] == True
--   ВАРИАНТ 2 (быстрее): достаточно проверять d, пока d * d <= n
--   (если бы у 37 был делитель больше 6, то был бы и парный делитель меньше 6):
--       n > 1 && all (\d -> n `mod` d /= 0) (takeWhile (\d -> d * d <= n) [2..])
--   [2..] — бесконечный список, takeWhile его обрежет.
--
-- A4. [это и есть midterm2 #2]
-- Write a function, that checks if a given integer is prime.
-- A prime number is only divisible by 1 and itself.
isPrime :: Int -> Bool
isPrime n = n > 1 && all (\d -> n `mod` d /= 0) (takeWhile (\d -> d * d <= n) [2..])
-- main = print (isPrime 5)  -- True
-- main = print (isPrime 4)  -- False
-- main = print (isPrime 13)  -- True
-- main = print (isPrime 1)  -- False
-- main = print (isPrime 2)  -- True

-- >>> ТЕОРИЯ: несколько условий в генераторе
--   Общий делитель делит и a, и b.
--   Условия в генераторе пишутся через запятую, и должны выполняться ВСЕ:
--       [d | d <- [1..a], a `mod` d == 0, b `mod` d == 0]
--   (или перебирать d из divisors a и проверять только b)
--
-- A5. Общие делители двух чисел.
commonDivisors :: Int -> Int -> [Int]
commonDivisors a b = [d | d <- divisors a, b `mod` d == 0]
-- main = print (commonDivisors 12 18)  -- [1,2,3,6]
-- main = print (commonDivisors 7 10)  -- [1]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: своя функция как условие
--   В генератор можно подставить любую функцию, которая возвращает Bool:
--       [x | x <- [1..10], even x]
--       [p | p <- [2..n], isPrime p]
--
-- B1. Все простые числа от 2 до n.
primesUpTo :: Int -> [Int]
primesUpTo n = [p | p <- [2..n], isPrime p]
-- main = print (primesUpTo 20)  -- [2,3,5,7,11,13,17,19]
-- main = print (primesUpTo 1)  -- []

-- >>> ТЕОРИЯ: пары в ответе, несколько условий
--   Ответ — пары:  [(p, p + 2) | p <- ..., условие1, условие2]
--   Обе части должны быть простыми, и p + 2 <= n, поэтому p перебирай в [2..n - 2].
--
-- B2. Пары простых-близнецов (p, p+2), где p+2 <= n.
twinPrimes :: Int -> [(Int, Int)]
twinPrimes n = [(p, p + 2) | p <- [2..n - 2], isPrime p, isPrime (p + 2)]
-- main = print (twinPrimes 20)  -- [(3,5),(5,7),(11,13),(17,19)]
-- main = print (twinPrimes 4)  -- []

-- >>> ТЕОРИЯ: head, where
--   head xs — первый элемент (на [] падает!):   head [3,5,7] == 3
--   Наименьший делитель больше 1 (он всегда простой):
--       head [d | d <- [2..n], n `mod` d == 0]
--   where задаёт вспомогательные имена внизу функции:
--       f n = p * 10
--         where p = n + 1
--   ИДЕЯ:  60: наименьший делитель 2, ответ  2 : (разложение 30)
--          30 -> 2 : (разложение 15);  15 -> 3 : (разложение 5);  5 -> 5 : (разложение 1);  1 -> []
--   ПЛАН: n < 2 -> [];   иначе  p : primeFactors (n `div` p),  где p — наименьший делитель.
--
-- B3. Разложение на простые множители (рекурсия).
primeFactors :: Int -> [Int]
primeFactors n
  | n < 2     = []
  | otherwise = p : primeFactors (n `div` p)
  where p = head [d | d <- [2..n], n `mod` d == 0]
-- main = print (primeFactors 60)  -- [2,2,3,5]
-- main = print (primeFactors 13)  -- [13]

-- >>> ТЕОРИЯ: gcd
--   gcd a b — наибольший общий делитель (функция встроена):
--       gcd 12 18 == 6       gcd 8 15 == 1
--   Взаимно простые значит "gcd равен 1".
--
-- B4. Взаимно просты ли два числа (gcd = 1)?
isCoprime :: Int -> Int -> Bool
isCoprime a b = gcd a b == 1
-- main = print (isCoprime 8 15)  -- True
-- main = print (isCoprime 6 9)  -- False

-- >>> ТЕОРИЯ: в условии можно вызывать функции
--   [x | x <- [1..n], sum (properDivisors x) > x]
--   12: 1+2+3+4+6 = 16 > 12, значит 12 избыточное.
--
-- B5. Избыточные числа до n: сумма собственных делителей БОЛЬШЕ самого числа.
abundantNumbers :: Int -> [Int]
abundantNumbers n = [x | x <- [1..n], sum (properDivisors x) > x]
-- main = print (abundantNumbers 30)  -- [12,18,20,24,30]

-- >>> ТЕОРИЯ: "первый подходящий" = head от генератора
--   Генератор перебирает по порядку, а head берёт первое найденное:
--       head [x | x <- [1..], x * x > 50] == 8
--   Пары (p, n - p): p от 2 до n `div` 2 (чтобы p <= q), оба числа простые.
--
-- B6. Гольдбах: первая пара простых (p, q), p <= q, p + q == n (n чётное > 2).
goldbach :: Int -> (Int, Int)
goldbach n = head [(p, n - p) | p <- [2..n `div` 2], isPrime p, isPrime (n - p)]
-- main = print (goldbach 28)  -- (5,23)
-- main = print (goldbach 10)  -- (3,7)

-- >>> ТЕОРИЯ: индексы через zip [0..]
--   zip склеивает два списка в пары:   zip [1,2,3] "abc" == [(1,'a'),(2,'b'),(3,'c')]
--   zip [0..] xs нумерует элементы с 0:
--       zip [0..] [7,8,9] == [(0,7),(1,8),(2,9)]
--   В генераторе пару сразу разбираем на номер i и элемент x:
--       [x | (i, x) <- zip [0..] xs, even i]        -- элементы на чётных позициях
--   Добавь второе условие isPrime x и возьми sum.
--
-- B7. Сумма простых чисел, стоящих на ЧЁТНЫХ позициях (индексы с 0).
sumPrimesAtEven :: [Int] -> Int
sumPrimesAtEven xs = sum [x | (i, x) <- zip [0..] xs, even i, isPrime x]
-- main = print (sumPrimesAtEven [2, 3, 5, 7, 9])  -- 7
-- main = print (sumPrimesAtEven [])  -- 0

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: это B5, только == вместо >
--   Совершенное число: сумма собственных делителей равна самому числу.  6 = 1+2+3.
--
-- C1. [midterm1 #10]
-- Write a function, which generates all perfect numbers up to a given integer n.
-- A perfect number is equal to the sum of its proper divisors.
-- (e.g., 6 is perfect because 1 + 2 + 3 = 6).
perfectNumbers :: Int -> [Int]
perfectNumbers n = [x | x <- [1..n], sum (properDivisors x) == x]
-- main = print (perfectNumbers 30)  -- [6,28]
-- main = print (perfectNumbers 500)  -- [6,28,496]

-- >>> ТЕОРИЯ к C2: два генератора
--   Два генератора — это вложенный перебор: для каждого p перебираются все q:
--       [(p, q) | p <- [1,2], q <- [p + 10, p + 20]] == [(1,11),(1,21),(2,12),(2,22)]
--   Средний элемент тройки — p+2 или p+4, значит  q <- [p + 2, p + 4].
--   Условия: p, q и p + 6 простые. Все три числа <= n, значит p <= n - 6.
--   Проверь: в primeTriplets 20 тройки (17,19,23) быть НЕ должно.
--
-- C2. [midterm3 #10]
-- A prime triplet consists of three numbers that are either
-- (p, p+2, p+6) or (p, p+4, p+6), where p is a prime number,
-- and p+2, p+4, and p+6 are also prime numbers.
-- Write a function that takes a positive integer n and returns a
-- list of tuples of prime triplets for all p less than or equal to n.
-- ВНИМАНИЕ: по тестам видно, что на самом деле ВСЕ ТРИ числа должны быть <= n
-- (иначе для 20 вышла бы ещё (17,19,23), а для 100 — (97,101,103)).
primeTriplets :: Int -> [(Int, Int, Int)]
primeTriplets n =
  [(p, q, p + 6) | p <- [2..n - 6], q <- [p + 2, p + 4], isPrime p, isPrime q, isPrime (p + 6)]
-- main = print (primeTriplets 20)  -- [(5,7,11),(7,11,13),(11,13,17),(13,17,19)]
-- main = print (primeTriplets 50)  -- [(5,7,11),(7,11,13),(11,13,17),(13,17,19),(17,19,23),(37,41,43),(41,43,47)]
-- main = print (primeTriplets 100)  -- [(5,7,11),(7,11,13),(11,13,17),(13,17,19),(17,19,23),(37,41,43),(41,43,47),(67,71,73)]

-- >>> ТЕОРИЯ к C3: это B7, но odd и product
--   product [] == 1, поэтому если ничего не нашлось, ответ 1 (как в тестах).
--
-- C3. [midterm6 #7]
-- Given a list of integers, return the product of all prime numbers found at odd indices.
-- [2, 3, 5, 7, 11] -> 21 (only 3 and 7 are at odd indices and prime, 3 * 7 = 21)
t3 :: [Int] -> Int
t3 xs = product [x | (i, x) <- zip [0..] xs, odd i, isPrime x]
-- main = print (t3 [2, 3, 5, 7, 11])  -- 21
-- main = print (t3 [2, 3, 5, 7, 11, 13])  -- 273
-- main = print (t3 [4, 6, 8, 10, 12])  -- 1
-- main = print (t3 [2, 2, 3, 4, 5, 6, 7, 8, 11])  -- 2
-- main = print (t3 [])  -- 1
