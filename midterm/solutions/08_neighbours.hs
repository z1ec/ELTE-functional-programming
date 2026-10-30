-- ============================================================================
-- 08. СОСЕДНИЕ ЭЛЕМЕНТЫ И ОКНА  (zip xs (tail xs), серии)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/08_neighbours.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 08_neighbours.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 08_neighbours.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #8, midterm2 #3, midterm6 #6

import Data.List (group)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Пары соседей:
--     zip xs (tail xs)        -- [1,2,3,4] -> [(1,2),(2,3),(3,4)]
--     zip xs (drop 1 xs)      -- то же, но безопасно и для []
-- Тройки подряд (окно 3):
--     zip3 xs (drop 1 xs) (drop 2 xs)   -- [1,2,3,4] -> [(1,2,3),(2,3,4)]
-- Элемент и элемент через k позиций:
--     zip xs (drop k xs)      -- k = 2: [1,2,3,4,5] -> [(1,3),(2,4),(3,5)]
--
-- Дальше — обычный генератор/фильтр по парам:
--     length [() | (a, b) <- zip xs (drop 1 xs), a < b]   -- сколько раз растёт
--     zipWith (-) (drop 1 xs) xs                           -- разности соседей
--     and (zipWith (<=) xs (drop 1 xs))                    -- отсортирован?
--
-- Рекурсией с образцом:
--     f (a:b:rest) = ... a ... b ... f (b:rest)   -- ВАЖНО: b возвращаем обратно!
--     f _          = ...                          -- 0 или 1 элемент
--
-- Самая длинная серия:
--   * group [1,1,2,2,2,3] == [[1,1],[2,2,2],[3]];  maximum (map length ...)
--   * scanl — "текущая длина серии" для каждого шага:
--       scanl (+) 0 [1,2,3] == [0,1,3,6]          -- промежуточные результаты foldl
--       scanl step 1 пары, где step len (a,b) = if <продолжается> then len+1 else 1
--     и потом maximum.
--   maximum [] падает! Пустой список обрабатывай отдельно.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: zip списка с самим собой со сдвигом
--   drop k xs выкидывает первые k элементов:  drop 1 [1,2,3,4] == [2,3,4]
--   zip [1,2,3,4] [2,3,4] == [(1,2),(2,3),(3,4)]  — каждая пара = два соседа!
--   (tail xs тоже убирает первый элемент, но на [] падает; drop 1 [] == [] безопасно)
--
-- A1. Все пары соседей.
adjacentPairs :: [a] -> [(a, a)]
adjacentPairs xs = zip xs (drop 1 xs)
-- main = print (adjacentPairs [1,2,3,4])  -- [(1,2),(2,3),(3,4)]
-- main = print (adjacentPairs "a")  -- []

-- >>> ТЕОРИЯ: zipWith со сдвигом
--   zipWith (-) (drop 1 xs) xs вычитает из каждого следующего предыдущий:
--       [4,9,16] минус [1,4,9]  ->  [3,5,7]
--   Порядок аргументов важен:  (-) b a = b - a.
--
-- A2. Разности соседей (следующий минус текущий).
differences :: [Int] -> [Int]
differences xs = zipWith (-) (drop 1 xs) xs
-- main = print (differences [1,4,9,16])  -- [3,5,7]

-- >>> ТЕОРИЯ: and
--   and [True, True] == True,   and [True, False] == False,   and [] == True
--   zipWith (<=) xs (drop 1 xs) — для каждой пары соседей: "не убывает?"
--   Отсортирован = все такие сравнения True.
--
-- A3. Отсортирован ли список по неубыванию?
isSorted :: [Int] -> Bool
isSorted xs = and (zipWith (<=) xs (drop 1 xs))
-- main = print (isSorted [1,2,2,5])  -- True
-- main = print (isSorted [3,1])  -- False
-- main = print (isSorted [])  -- True

-- >>> ТЕОРИЯ: подсчёт пар с условием
--   length [() | (a, b) <- adjacentPairs xs, b > a]
--   (или  length (filter (\(a, b) -> b > a) (adjacentPairs xs)))
--
-- A4. Сколько раз следующий элемент больше предыдущего.
countIncreases :: [Int] -> Int
countIncreases xs = length [() | (a, b) <- adjacentPairs xs, b > a]
-- main = print (countIncreases [1,3,2,4,5])  -- 3

-- >>> ТЕОРИЯ: zip3
--   zip3 склеивает ТРИ списка в тройки:
--       zip3 [1,2] "ab" [True,False] == [(1,'a',True),(2,'b',False)]
--   Окна по 3:  zip3 xs (drop 1 xs) (drop 2 xs)
--
-- A5. Все окна из трёх подряд.
triples :: [a] -> [(a, a, a)]
triples xs = zip3 xs (drop 1 xs) (drop 2 xs)
-- main = print (triples [1,2,3,4])  -- [(1,2,3),(2,3,4)]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: смена знака через произведение
--   Знаки разные  <=>  a * b < 0   (минус на плюс даёт минус).
--
-- B1. Сколько раз меняется знак между соседями (0 не встречается).
countSignChanges :: [Int] -> Int
countSignChanges xs = length [() | (a, b) <- adjacentPairs xs, a * b < 0]
-- main = print (countSignChanges [1,-2,-3,4,5,-6])  -- 3

-- >>> ТЕОРИЯ: генератор по тройкам
--   [b | (a, b, c) <- triples xs, b > a, b > c] — средний больше обоих соседей.
--
-- B2. Локальные максимумы: элементы, которые больше ОБОИХ соседей.
localMaxima :: [Int] -> [Int]
localMaxima xs = [b | (a, b, c) <- triples xs, b > a, b > c]
-- main = print (localMaxima [2,9,5,6,1])  -- [9,6]
-- main = print (localMaxima [1,2,3])  -- []

-- >>> ТЕОРИЯ: сдвиг на k
--   zip xs (drop k xs) — пары элементов, стоящих через k позиций.
--
-- B3. Пары (x, y), где y стоит на k позиций правее x.
gapPairs :: Int -> [a] -> [(a, a)]
gapPairs k xs = zip xs (drop k xs)
-- main = print (gapPairs 2 [1,2,3,4,5])  -- [(1,3),(2,4),(3,5)]

-- >>> ТЕОРИЯ: рекурсия с образцом (x:y:rest) — подсчёт
--   Смотрим на первые два элемента. В рекурсию возвращаем (y:rest),
--   потому что y может быть первым в следующей паре:
--       f (x:y:rest)
--         | <пара подходит> = 1 + f (y:rest)
--         | otherwise       = f (y:rest)
--       f _ = 0             -- 0 или 1 элемент: пар нет
--   Это та же задача, что решается через zip, только рекурсией. Полезно уметь оба способа.
--
-- B4. Сколько раз a стоит СРАЗУ перед b — рекурсией с образцом (x:y:rest).
countFollowedBy :: Int -> Int -> [Int] -> Int
countFollowedBy a b (x:y:rest)
  | x == a && y == b = 1 + countFollowedBy a b (y:rest)
  | otherwise        = countFollowedBy a b (y:rest)
countFollowedBy _ _ _ = 0
-- main = print (countFollowedBy 1 2 [1,2,1,3,1,2])  -- 2

-- >>> ТЕОРИЯ: group, maximum
--   group (из Data.List) разбивает на группы одинаковых, идущих ПОДРЯД:
--       group [1,1,2,2,2,3] == [[1,1],[2,2,2],[3]]
--   map length -> [2,3,1];   maximum -> 3.
--   maximum [] ПАДАЕТ, поэтому пустой список — отдельной строкой:  longestEqualRun [] = 0
--
-- B5. Длина самой длинной серии одинаковых подряд. Для [] -> 0.
longestEqualRun :: [Int] -> Int
longestEqualRun [] = 0
longestEqualRun xs = maximum (map length (group xs))
-- main = print (longestEqualRun [1,1,2,2,2,3])  -- 3
-- main = print (longestEqualRun [])  -- 0

-- >>> ТЕОРИЯ: maximum по генератору
--   maximum [a + b | (a, b) <- adjacentPairs xs]
--
-- B6. Максимальная сумма двух соседей (в списке минимум 2 элемента).
maxAdjacentSum :: [Int] -> Int
maxAdjacentSum xs = maximum [a + b | (a, b) <- adjacentPairs xs]
-- main = print (maxAdjacentSum [1,5,2,8,1])  -- 10

-- >>> ТЕОРИЯ: scanl — foldl, который показывает все шаги
--   foldl отдаёт только итог, а scanl — все промежуточные значения накопителя:
--       foldl (+) 0 [1,2,3] == 6
--       scanl (+) 0 [1,2,3] == [0,1,3,6]
--   Идея: накопитель — длина текущей серии. Идём по парам соседей:
--     серия продолжается (b > a) -> len + 1;   иначе начинаем заново -> 1
--       step len (a, b) = if b > a then len + 1 else 1
--   [1,3,5,2,4]: пары (1,3),(3,5),(5,2),(2,4)
--       scanl step 1 пары == [1,2,3,1,2]   ->   maximum = 3
--   Начальное значение 1 — серия из одного первого элемента. Пустой список — отдельно (0).
--
-- B7. Длина самой длинной СТРОГО ВОЗРАСТАЮЩЕЙ серии подряд (через scanl). [] -> 0.
longestIncreasing :: [Int] -> Int
longestIncreasing [] = 0
longestIncreasing xs = maximum (scanl step 1 (adjacentPairs xs))
  where step len (a, b) = if b > a then len + 1 else 1
-- main = print (longestIncreasing [1,3,5,2,4])  -- 3
-- main = print (longestIncreasing [5,4,3])  -- 1

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: A4 с двумя условиями
--   Пара (a, b) подходит, если a < 0 и b > 0.
--
-- C1. [midterm1 #8]
-- Write a function that takes a list of numbers and counts how many times
-- a negative number is followed directly by a positive number.
-- [-1, 2, -3, -4, 5, 6, -7, 8, -9] -> 3   (-1,2), (-4,5), (-7,8)
countNegativePositivePairs :: [Int] -> Int
countNegativePositivePairs xs = length [() | (a, b) <- adjacentPairs xs, a < 0, b > 0]
-- main = print (countNegativePositivePairs [])  -- 0
-- main = print (countNegativePositivePairs [-1, 2, -3, -4, 5, 6, -7, 8, -9])  -- 3
-- main = print (countNegativePositivePairs [1, -2, 3, -4, -5, 6])  -- 2
-- main = print (countNegativePositivePairs [-1, -2, -3, -4])  -- 0
-- main = print (countNegativePositivePairs [10, -5, -6, -7, -8, 9])  -- 1

-- >>> ТЕОРИЯ к C2: B3 с k = 2
--   Пары (a, c), где c через 2 позиции от a; условия a == n и odd c; посчитать.
--
-- C2. [midterm2 #3]
-- Given a list of integers and a specific integer, calculate how many times
-- that integer is followed in the list by an odd number, two positions away,
-- i.e. second neighbour to the right is odd.
-- [2,3,4,7,2,1,3,5] and 2 -> 1   (only the [2,1,3] part)
countOddGap :: [Int] -> Int -> Int
countOddGap xs n = length [() | (a, c) <- gapPairs 2 xs, a == n, odd c]
-- main = print (countOddGap [2, 3, 4, 7, 2, 1, 3, 5] 2)  -- 1
-- main = print (countOddGap [3,7,4,1,4,9,5,3,4,4,8,1] 4)  -- 2
-- main = print (countOddGap [1,2,3,4,5,6,4,8,8,2,3,1,2,3,3,3,3] 3)  -- 3

-- >>> ТЕОРИЯ к C3: это B7 с условием b == a + 1
--   "Increasing by one" — каждый следующий ровно на 1 больше предыдущего.
--
-- C3. [midterm6 #6]
-- Given a list of integers, return the length of the longest
-- increasing-by-one contiguous subsequence.
-- [1,2,2,3,4] -> 3   ([2,3,4])
-- Подсказка: это B7, только условие b == a + 1.
t1 :: [Int] -> Int
t1 [] = 0
t1 xs = maximum (scanl step 1 (adjacentPairs xs))
  where step len (a, b) = if b == a + 1 then len + 1 else 1
-- main = print (t1 [1, 2, 2, 3, 4])  -- 3
-- main = print (t1 [1..20])  -- 20
-- main = print (t1 [5, 4, 3, 2, 1])  -- 1
-- main = print (t1 [1,2,1,2,3,1,1,1,2,3,4,5,6])  -- 6
-- main = print (t1 [])  -- 0
