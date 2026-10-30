-- ============================================================================
-- 09. ПРИНАДЛЕЖНОСТЬ, ПОВТОРЫ, ПОДСЧЁТ  (elem, nub, filter, count)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/09_membership_counting.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 09_membership_counting.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 09_membership_counting.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #2, midterm3 #9, midterm5 #9, midterm5 #10, midterm6 #8

import Data.List (nub)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Есть ли элемент:
--     3 `elem` [1,2,3]    == True
--     5 `notElem` [1,2,3] == True
--
-- Пересечение / разность через генератор (порядок и повторы из ПЕРВОГО списка):
--     [x | x <- xs, x `elem` ys]       -- есть в обоих
--     [x | x <- xs, x `notElem` ys]    -- есть в xs, нет в ys
--   или filter:  filter (`notElem` ys) xs
--
-- Убрать повторы:  nub [1,1,2,3,2] == [1,2,3]   (import Data.List)
--
-- Сколько раз x встречается в xs:
--     length (filter (== x) xs)
--
-- В Data.List есть готовые intersect, union, (\\), delete — но:
--     [1,1,2] \\ [1] == [1,2]   -- (\\) убирает только ОДНО вхождение!
--   Поэтому для "убрать все такие" надёжнее filter + notElem.
--
-- all / any:
--     all even [2,4]      == True
--     any (> 3) [1,2]     == False
--     all p []            == True     (пустой список — "всё верно")
--
-- Ошибка для пустых входов — первый guard:
--     f xs ys | null xs || null ys = error "Empty list!"
--             | otherwise          = ...

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: рекурсия с ||
--   || — логическое "или".
--       x == y || myElem y xs      -- "первый равен y ИЛИ y есть в хвосте"
--   В пустом списке ничего нет -> False.   (Встроенный аналог — elem.)
--
-- A1. Свой elem рекурсией.
myElem :: Int -> [Int] -> Bool
myElem _ [] = False
myElem y (x:xs) = x == y || myElem y xs
-- main = print (myElem 3 [1,2,3])  -- True
-- main = print (myElem 5 [])  -- False

-- >>> ТЕОРИЯ: length (filter (== x) xs)
--   filter (== 2) [1,2,2,3] == [2,2],  потом length -> 2.
--
-- A2. Сколько раз x встречается в списке.
countOcc :: Int -> [Int] -> Int
countOcc x xs = length (filter (== x) xs)
-- main = print (countOcc 2 [1,2,2,3,2])  -- 3
-- main = print (countOcc 7 [1,2])  -- 0

-- >>> ТЕОРИЯ: рекурсия с удалением повторов
--   Берём первый x, оставляем его, а из хвоста выкидываем ВСЕ x, и повторяем:
--       unique (x:xs) = x : unique (filter (/= x) xs)
--   [1,2,1,3,2] -> 1 : unique [2,3,2] -> 1 : 2 : unique [3] -> [1,2,3]
--
-- A3. Свой nub (оставить первое вхождение каждого) — рекурсией.
unique :: [Int] -> [Int]
unique [] = []
unique (x:xs) = x : unique (filter (/= x) xs)
-- main = print (unique [1,2,1,3,2])  -- [1,2,3]

-- >>> ТЕОРИЯ: filter (/= x)
--   /= значит "не равно":   filter (/= 2) [1,2,3,2] == [1,3]
--
-- A4. Удалить ВСЕ вхождения x.
removeAll :: Int -> [Int] -> [Int]
removeAll x xs = filter (/= x) xs
-- main = print (removeAll 2 [1,2,3,2])  -- [1,3]

-- >>> ТЕОРИЯ: all и секция с elem
--   all p xs — p верно для каждого элемента.
--   (`elem` ys) — функция "есть ли x в ys?":   (`elem` [1,2]) 2 == True
--       all (`elem` ys) xs
--   (или лямбдой:  all (\x -> x `elem` ys) xs)
--
-- A5. Все ли элементы первого списка есть во втором?
allIn :: [Int] -> [Int] -> Bool
allIn xs ys = all (`elem` ys) xs
-- main = print (allIn [1,2] [2,1,3])  -- True
-- main = print (allIn [1,4] [2,1,3])  -- False

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: nub
--   nub (из Data.List) убирает повторы и оставляет первое вхождение:
--       nub [1,2,2,3,1] == [1,2,3]
--   Объединение = склеить (++) и убрать повторы.
--
-- B1. Объединение без повторов (сначала элементы первого списка).
unionList :: [Int] -> [Int] -> [Int]
unionList xs ys = nub (xs ++ ys)
-- main = print (unionList [1,2,2] [2,3])  -- [1,2,3]

-- >>> ТЕОРИЯ: условие через countOcc
--   [x | x <- xs, countOcc x xs == 1] — в условии можно считать по всему списку xs.
--
-- B2. Элементы, которые встречаются ровно один раз.
onlyOnce :: [Int] -> [Int]
onlyOnce xs = [x | x <- xs, countOcc x xs == 1]
-- main = print (onlyOnce [1,2,2,3,4,4])  -- [1,3]

-- >>> ТЕОРИЯ: перебор уникальных + подсчёт
--   Перебираем x из nub xs (каждое значение по одному разу)
--   и кладём пару (x, сколько раз x встречается в xs).
--
-- B3. Частоты: (элемент, сколько раз) — в порядке первого появления.
frequencies :: [Int] -> [(Int, Int)]
frequencies xs = [(x, countOcc x xs) | x <- nub xs]
-- main = print (frequencies [1,2,1,3])  -- [(1,2),(2,1),(3,1)]

-- >>> ТЕОРИЯ: maximum на парах
--   Пары сравниваются сначала по первому элементу, при равенстве — по второму:
--       maximum [(2,1),(3,3),(3,2)] == (3,3)
--   Поэтому кладём (сколько раз, число) — ключ ПЕРВЫМ — и берём snd от максимума.
--
-- B4. Самый частый элемент (список непустой; при равенстве — больший).
mostFrequent :: [Int] -> Int
mostFrequent xs = snd (maximum [(countOcc x xs, x) | x <- nub xs])
-- main = print (mostFrequent [1,3,3,2,3,1])  -- 3

-- >>> ТЕОРИЯ: две разности через ++
--   (есть в xs, но нет в ys) ++ (есть в ys, но нет в xs).   notElem — "нет в списке".
--
-- B5. Симметрическая разность: элементы, которые есть ровно в одном из списков.
symmetricDiff :: [Int] -> [Int] -> [Int]
symmetricDiff xs ys = [x | x <- xs, x `notElem` ys] ++ [y | y <- ys, y `notElem` xs]
-- main = print (symmetricDiff [1,2,3] [2,3,4])  -- [1,4]

-- >>> ТЕОРИЯ: all с лямбдой по парам
--   Лямбда может разобрать пару:   all (\(c, k) -> <условие с c и k>) ps
--   Условие: сколько раз c встречается в строке == k.
--
-- B6. Для каждой пары (c, k): символ c встречается в строке ровно k раз?
checkCounts :: [(Char, Int)] -> String -> Bool
checkCounts ps s = all (\(c, k) -> length (filter (== c) s) == k) ps
-- main = print (checkCounts [('a',2),('b',1)] "abac")  -- True
-- main = print (checkCounts [('a',1)] "abac")  -- False

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: пересечение + nub
--   [x | x <- xs, x `elem` ys] — есть в обоих (с повторами из xs), потом nub.
--
-- C1. [midterm1 #2]
-- Write a function that takes two lists of integers and returns a list of integers
-- that appear in both lists, ensuring each element appears only once in the result.
commonElements :: [Int] -> [Int] -> [Int]
commonElements xs ys = nub [x | x <- xs, x `elem` ys]
-- main = print (commonElements [1, 2, 3, 4, 5] [3, 4, 5, 6, 7])  -- [3,4,5]
-- main = print (commonElements [10, 20, 30] [30, 40, 10, 50])  -- [10,30]
-- main = print (commonElements [1, 1, 2, 3] [2, 2, 3, 4])  -- [2,3]

-- >>> ТЕОРИЯ к C2: разность
--   [x | x <- xs, x `notElem` ys].  Повторы из xs сохраняются, так и надо.
--
-- C2. [midterm3 #9]
-- Given two lists of integers, return a list containing only the elements
-- that are present in the first list but not in the second list.
difference :: [Int] -> [Int] -> [Int]
difference xs ys = [x | x <- xs, x `notElem` ys]
-- main = print (difference [1, 2, 3, 4] [3, 4, 5, 6])  -- [1,2]
-- main = print (difference [] [1, 2, 3])  -- []
-- main = print (difference [1, 2, 3] [])  -- [1,2,3]
-- main = print (difference [7, 8, 9] [1, 2, 3])  -- [7,8,9]
-- main = print (difference [5, 6, 7, 8] [6, 7, 9])  -- [5,8]

-- >>> ТЕОРИЯ к C3: negate, abs, секция с notElem
--   negate x == -x.  "Сделать отрицательным" = negate (abs x):   5 -> -5,  -2 -> -2,  0 -> 0
--   makeNegative: из ys убрать все значения, которые есть в makeNeg xs:
--       filter (`notElem` makeNeg xs) ys
--
-- C3. [midterm6 #8]
-- makeNeg: make all numbers of the list negative (0 stays 0).
makeNeg :: [Int] -> [Int]
makeNeg xs = map (\x -> negate (abs x)) xs
-- main = print (makeNeg [0])  -- [0]
-- main = print (makeNeg [1,2,3])  -- [-1,-2,-3]
-- main = print (makeNeg [1,-2,4,5,-3,-5])  -- [-1,-2,-4,-5,-3,-5]

-- makeNegative: make all numbers of the FIRST list negative,
-- then eliminate these values from the SECOND list.
makeNegative :: [Int] -> [Int] -> [Int]
makeNegative xs ys = filter (`notElem` makeNeg xs) ys
-- main = print (makeNegative [0] [0])  -- []
-- main = print (makeNegative [] [])  -- []
-- main = print (makeNegative [1,2,3] [-1,3,2,-3,20,1])  -- [3,2,20,1]
-- main = print (makeNegative [1,-2,4,5,-3,-5] [1,2,3,-1,-2,3,-10,5,8,-6,-4,4])  -- [1,2,3,3,-10,5,8,-6,4]
-- main = print (makeNegative [1..5] [1..5])  -- [1,2,3,4,5]

-- >>> ТЕОРИЯ к C4: map с подсчётом по всему списку
--   map (\x -> countOcc x xs) xs — для каждого элемента считаем по ВСЕМУ списку xs.
--
-- C4. [midterm5 #9]
-- Write a function that takes a list of integers and returns a new list
-- where each element is replaced with the number of times it occurs in the list.
replaceWithOccurrence :: [Int] -> [Int]
replaceWithOccurrence xs = map (\x -> countOcc x xs) xs
-- main = print (replaceWithOccurrence [1, 2, 2, 3, 4, 4, 5])  -- [1,2,2,1,2,2,1]
-- main = print (replaceWithOccurrence [1, 1, 1])  -- [3,3,3]
-- main = print (replaceWithOccurrence [])  -- []
-- main = print (replaceWithOccurrence [5, 6, 5, 6, 7, 8])  -- [2,2,2,2,1,1]

-- >>> ТЕОРИЯ к C5: error для пустых + all по парам
--   Первый guard:  null ts || null xs  ->  error "Empty list!"
--   Дальше всё как в B6:   all (\(a, k) -> isPrime k && countOcc a xs == k) ts
--   Сначала допиши isPrime ниже (как в тренажёре 03, A4).
--
-- C5. [midterm5 #10]
-- Given a list of tuples and a list of integers, check if every tuple has the
-- property: the first element of the tuple appears in the list of integers exactly
-- as many times as the second element's value, AND the second element is prime.
-- Error "Empty list!" in case the lists are empty.
-- [(6,2),(3,3),(9,2)] [6,6,3,3,3,3,9,9] -> False  (3 appears 4 times, not 3)
-- isPrime — как в тренажёре 03 (там это A4).
isPrime :: Int -> Bool
isPrime n = n > 1 && all (\d -> n `mod` d /= 0) (takeWhile (\d -> d * d <= n) [2..])
-- main = print (isPrime 7)  -- True

tupleCheck :: [(Int, Int)] -> [Int] -> Bool
tupleCheck ts xs
  | null ts || null xs = error "Empty list!"
  | otherwise          = all (\(a, k) -> isPrime k && countOcc a xs == k) ts
-- main = print (tupleCheck [] [])  -- error: Empty list!
-- main = print (tupleCheck [(2, 3), (4, 5), (1, 2)] [2,2,2,4,4,4,4,4,1,1])  -- True
-- main = print (tupleCheck [(6, 2), (3, 4), (9, 2)] [6,6,3,3,3,3,9,9])  -- False
-- main = print (tupleCheck [(6, 2), (3, 3), (9, 2)] [6,6,3,3,3,3,9,9])  -- False
