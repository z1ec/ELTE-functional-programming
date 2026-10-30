-- ============================================================================
-- 07. ZIP, ZIPWITH И ИНДЕКСЫ  (zip [0..], матрицы)
-- ============================================================================
-- Тренажёр. Решения: ../solutions/07_zip_indices.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 07_zip_indices.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 07_zip_indices.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #4, midterm1 #6, midterm2 #7, midterm4 #2, midterm4 #6
--   (ещё на индексы: midterm4 #8 — в 05, midterm6 #7 — в 03)

import Data.List (nub)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- zip склеивает два списка в пары (по длине КОРОТКОГО):
--     zip [1,2,3] "ab"           == [(1,'a'),(2,'b')]
--     zip3 [1,2] "ab" [True,False] == [(1,'a',True),(2,'b',False)]
--     unzip [(1,'a'),(2,'b')]    == ([1,2],"ab")
--
-- zipWith — то же, но сразу применяет функцию:
--     zipWith (+) [1,2,3] [10,20,30] == [11,22,33]
--     zipWith (\a b -> a * b) [1,2] [3,4] == [3,8]
--
-- ИНДЕКСЫ — главный приём: zip с бесконечным [0..]
--     zip [0..] "abc" == [(0,'a'),(1,'b'),(2,'c')]
--     [x | (i, x) <- zip [0..] xs, odd i]            -- элементы на нечётных позициях
--     [i | (i, x) <- zip [0..] xs, x == 0]           -- индексы нулей
--     [if x == 0 then i else x | (i, x) <- zip [0..] xs]  -- заменить по условию
--     zipWith f [0..] xs                             -- f получает (индекс, элемент)
--
--   xs !! i — элемент по индексу (медленно и падает за границей; лучше zip [0..])
--
-- Матрица = список строк [[Int]].
--     zipWith (zipWith (+)) m1 m2   -- поэлементная сумма двух матриц
--     sum (map sum m)               -- сумма всех элементов
--     concat m                      -- развернуть в один список
--
-- Пары "на одинаковых позициях" двух списков — тоже zip:
--     [(a, b) | (a, b) <- zip xs ys, a > b]

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: zip и [0..]
--   zip склеивает два списка поэлементно в пары, длина — по КОРОТКОМУ списку:
--       zip [1,2,3] "ab" == [(1,'a'),(2,'b')]
--   [0..] — бесконечный список 0,1,2,...; в zip он обрежется по длине xs:
--       zip [0..] "abc" == [(0,'a'),(1,'b'),(2,'c')]
--
-- A1. Пронумеровать элементы с 0.
withIndex :: [a] -> [(Int, a)]
withIndex = undefined
-- main = print (withIndex "abc")  -- [(0,'a'),(1,'b'),(2,'c')]

-- >>> ТЕОРИЯ: zipWith
--   zipWith f xs ys — как zip, но вместо пары сразу вычисляется f x y:
--       zipWith (*) [1,2,3] [4,5,6] == [4,10,18]
--       zipWith max [1,9] [5,2]     == [5,9]
--   Тоже обрезается по короткому списку.
--
-- A2. Сложить два списка поэлементно.
addLists :: [Int] -> [Int] -> [Int]
addLists = undefined
-- main = print (addLists [1,2,3] [10,20,30])  -- [11,22,33]
-- main = print (addLists [1,2,3] [10])  -- [11]

-- >>> ТЕОРИЯ: zipWith + sum
--   1*4 + 2*5 + 3*6: перемножить попарно (zipWith (*)) и сложить (sum).
--
-- A3. Скалярное произведение.
dotProduct :: [Int] -> [Int] -> Int
dotProduct = undefined
-- main = print (dotProduct [1,2,3] [4,5,6])  -- 32

-- >>> ТЕОРИЯ: фильтр по индексу в генераторе
--   Пару (номер, элемент) разбираем прямо в генераторе:
--       [x | (i, x) <- zip [0..] xs, even i]
--   i — номер, x — сам элемент. Условие ставим на i, в ответ кладём x.
--
-- A4. Элементы на чётных позициях (0, 2, 4, ...).
evenIndexed :: [a] -> [a]
evenIndexed = undefined
-- main = print (evenIndexed [10,20,30,40,50])  -- [10,30,50]

-- >>> ТЕОРИЯ: в ответ кладём индекс
--   Тот же генератор, но в ответе i, а условие на x:
--       [i | (i, x) <- zip [0..] xs, x == n]
--
-- A5. Все позиции, на которых стоит число n.
positionsOf :: Int -> [Int] -> [Int]
positionsOf = undefined
-- main = print (positionsOf 3 [3,1,3,2])  -- [0,2]
-- main = print (positionsOf 9 [3,1])  -- []

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: A4 + odd + sum
--   Позиции 1, 3, 5, ... — это odd i.
--
-- B1. Сумма элементов на нечётных позициях.
sumOddIndices :: [Int] -> Int
sumOddIndices = undefined
-- main = print (sumOddIndices [1,2,3,4])  -- 6

-- >>> ТЕОРИЯ: zipWith с [0..]
--   zipWith (*) [0..] xs умножает каждый элемент на его номер.
--   ([0..] бесконечный, но zipWith обрежет его по xs.)
--
-- B2. Каждый элемент умножить на его индекс.
indexMultiply :: [Int] -> [Int]
indexMultiply = undefined
-- main = print (indexMultiply [5,5,5])  -- [0,5,10]

-- >>> ТЕОРИЯ: zipWith на двух уровнях
--   Матрица — список строк. Сначала идём по парам строк, потом внутри пары — по парам чисел:
--       zipWith (zipWith (+)) m1 m2
--   Внешний zipWith берёт пары строк, а (zipWith (+)) складывает две строки.
--
-- B3. Сложить две матрицы.
addMatrices :: [[Int]] -> [[Int]] -> [[Int]]
addMatrices = undefined
-- main = print (addMatrices [[1,2],[3,4]] [[10,20],[30,40]])  -- [[11,22],[33,44]]

-- >>> ТЕОРИЯ: генератор по zip двух списков
--   [() | (a, b) <- zip xs ys, a == b]  кладёт по одному () на каждое совпадение,
--   потом length.  (() — "пустое значение"; нам важно только количество.)
--   Или так:  length (filter (\(a, b) -> a == b) (zip xs ys))
--
-- B4. На скольких позициях списки совпадают.
countSamePositions :: String -> String -> Int
countSamePositions = undefined
-- main = print (countSamePositions "abcd" "abxd")  -- 3

-- >>> ТЕОРИЯ: if внутри выражения генератора
--   [if i == k then v else x | (i, x) <- zip [0..] xs]
--   На позиции k подставляем v, на остальных оставляем x.
--   Если k за границей списка, совпадений нет, и список не изменится.
--
-- B5. Заменить элемент на позиции k.
replaceAt :: Int -> a -> [a] -> [a]
replaceAt = undefined
-- main = print (replaceAt 1 'X' "abc")  -- "aXc"
-- main = print (replaceAt 5 'X' "abc")  -- "abc"

-- >>> ТЕОРИЯ: то же, что B5, но условие на x
--   [if x < 0 then i else x | (i, x) <- zip [0..] xs]
--   Это прямая подготовка к C2.
--
-- B6. Отрицательные числа заменить их индексом.
negToIndex :: [Int] -> [Int]
negToIndex = undefined
-- main = print (negToIndex [-1,5,-3])  -- [0,5,2]

-- >>> ТЕОРИЯ: пары с одинаковых позиций + фильтр
--   [(a, b) | (a, b) <- zip xs ys, a > b]
--
-- B7. Пары с одинаковых позиций, где первый элемент больше второго.
biggerPairs :: [Int] -> [Int] -> [(Int, Int)]
biggerPairs = undefined
-- main = print (biggerPairs [5,1,7] [3,4,7])  -- [(5,3)]

-- >>> ТЕОРИЯ: !! — элемент по индексу
--   xs !! i — элемент на позиции i (с 0):  [7,8,9] !! 1 == 8   (за границей — падает)
--   Диагональ: из строки номер i берём элемент номер i:
--       [row !! i | (i, row) <- zip [0..] m]     и потом sum.
--
-- B8. Сумма диагонали квадратной матрицы.
diagonalSum :: [[Int]] -> Int
diagonalSum = undefined
-- main = print (diagonalSum [[1,2,3],[4,5,6],[7,8,9]])  -- 15

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: ответ — пара
--   Каждую часть пары считаем отдельно:  (сумма1, сумма2)
--   Можно использовать свои функции:  (sumOddIndices xs, sum (evenIndexed ys))
--
-- C1. [midterm1 #6]
-- Given two lists of integers, calculate the sum of the elements at odd indices
-- in the first list and the sum of the elements at even indices in the second list.
-- Return these sums as a tuple.  [1,2,3,4] [5,6,7,8] -> (2+4, 5+7) = (6,12)
indexSums :: [Int] -> [Int] -> (Int, Int)
indexSums = undefined
-- main = print (indexSums [1, 2, 3, 4] [5, 6, 7, 8])  -- (6,12)
-- main = print (indexSums [3,5,6,7,8] [9,7,4,2,5])  -- (12,18)

-- >>> ТЕОРИЯ к C2: это B6 с условием x == 0
--
-- C2. [midterm4 #2]
-- Write a function that takes a list and replaces all the zeroes
-- with their respective positions within that list.
-- [0, 10, 0, 0, 0] -> [0,10,2,3,4]
zeroes2Index :: [Int] -> [Int]
zeroes2Index = undefined
-- main = print (zeroes2Index [0, 10, 0, 0, 0])  -- [0,10,2,3,4]
-- main = print (zeroes2Index [0, 1, 2, 5, 2, 6, 0])  -- [0,1,2,5,2,6,6]
-- main = print (zeroes2Index [0, 0, 0, 0, 0])  -- [0,1,2,3,4]
-- main = print (zeroes2Index [5, 0, 7, 0, 1, 2, 0, 3])  -- [5,1,7,3,1,2,6,3]

-- >>> ТЕОРИЯ к C3: f с двумя аргументами + zipWith
--   f принимает номер и элемент двумя аргументами:  f i x.
--   zipWith f [0..] xs вызовет f 0 x0, f 1 x1, ...
--
-- C3. [midterm4 #6]
-- Write a function that takes a function and a list, and applies
-- the function to each element along with its index in the list.
mapWithIndex :: (Int -> a -> b) -> [a] -> [b]
mapWithIndex = undefined
-- main = print (mapWithIndex (\i x -> show i ++ ":" ++ x) ["a", "b", "c"])  -- ["0:a","1:b","2:c"]
-- main = print (mapWithIndex (\i x -> i + 1) [5, 10, 15])  -- [1,2,3]
-- main = print (mapWithIndex (\i x -> (i, x)) [True, False])  -- [(0,True),(1,False)]
-- main = print (mapWithIndex (\i x -> x + i) [10, 20, 30])  -- [10,21,32]

-- >>> ТЕОРИЯ к C4: B3 + лямбда + сумма всей матрицы
--   Вместо (+) — лямбда (\a b -> (a - b) ^ 2); получится матрица квадратов разностей.
--   Сумма всей матрицы:  sum (map sum m)   (суммы строк, потом сумма сумм).
--
-- C4. [midterm1 #4]
-- Write a function which takes 2 matrices (list of lists) of the same size,
-- and outputs the sum of the squared differences of corresponding elements.
-- [[1,2],[4,5]] [[2,3],[5,6]] -> (2-1)^2 + (3-2)^2 + (5-4)^2 + (6-5)^2 = 4
ssd :: [[Int]] -> [[Int]] -> Int
ssd = undefined
-- main = print (ssd [[1, 2], [4, 5]] [[2, 3], [5, 6]])  -- 4
-- main = print (ssd [[0, 0], [0, 0]] [[0, 0], [0, 0]])  -- 0
-- main = print (ssd [[1, 1], [1, 1]] [[2, 2], [2, 2]])  -- 4
-- main = print (ssd [[-1, -2], [-3, -4]] [[1, 2], [3, 4]])  -- 120

-- >>> ТЕОРИЯ к C5: zip + фильтр + nub + "оставить последнее"
--   abs — модуль:  abs (2 - 5) == 3
--   Пары:  [(a, b) | (a, b) <- zip xs ys, abs (a - b) == n]
--   nub (из Data.List) убирает повторы, но оставляет ПЕРВОЕ вхождение.
--   Тест хочет ПОСЛЕДНЕЕ: перевернуть, nub, перевернуть обратно:
--       reverse (nub (reverse pairs))
--
-- C5. [midterm2 #7]
-- Given two equally long lists and a number n, zip the elements of the two lists
-- together, but only if their absolute difference is equal to n.
-- Make sure to remove the duplicates from the resulting list.
-- [2,1,4,2] [5,3,1,5] 3 -> pairs [(2,5),(4,1),(2,5)] -> [(4,1),(2,5)]
-- ВНИМАНИЕ: nub оставляет ПЕРВОЕ вхождение и дал бы [(2,5),(4,1)].
-- Тест ждёт, что остаётся ПОСЛЕДНЕЕ -> reverse (nub (reverse ...)).
absDiff :: [Int] -> [Int] -> Int -> [(Int, Int)]
absDiff = undefined
-- main = print (absDiff [1..5] [5..10] 4)  -- [(1,5),(2,6),(3,7),(4,8),(5,9)]
-- main = print (absDiff [] [] 2)  -- []
-- main = print (absDiff [2,1,4,2] [5, 3, 1, 5] 3)  -- [(4,1),(2,5)]
-- main = print (absDiff [3,2,4] [5,5,5] 2)  -- [(3,5)]
