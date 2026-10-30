-- ============================================================================
-- 10. ФУНКЦИИ ВЫСШЕГО ПОРЯДКА И СПИСКИ СПИСКОВ  (map, filter, fold, лямбды)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/10_hof_lists_of_lists.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 10_hof_lists_of_lists.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 10_hof_lists_of_lists.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #11, midterm2 #5, midterm3 #8, midterm3 #11, midterm4 #5, midterm4 #10

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Функция высшего порядка (HOF) принимает/возвращает функции:
--     map f xs          -- применить f к каждому
--     filter p xs       -- оставить те, где p x == True
--     foldr f z xs      -- свернуть справа:  foldr (+) 0 [1,2,3] = 1+(2+(3+0))
--     foldl f z xs      -- свернуть слева:   foldl (-) 10 [1,2] = (10-1)-2 = 7
--     any p, all p, zipWith f, concatMap f, takeWhile p, iterate f
--
-- Как передать функцию:
--     map (+ 1) xs               -- секция: \x -> x + 1
--     map (`div` 2) xs           -- \x -> x `div` 2
--     map (2 ^) xs               -- \x -> 2 ^ x   (порядок важен!)
--     map (\x -> x * x + 1) xs   -- лямбда
--     map (show . abs) xs        -- композиция: сначала abs, потом show
--
-- Тип с функцией в аргументе читается так:
--     selectiveMap :: (a -> Bool) -> (a -> a) -> [a] -> [a]
--                     предикат      функция    список
--
-- Список списков [[Int]]:
--     map sum [[1,2],[3]]              == [3,3]          -- что-то для каждого подсписка
--     map (map (* 2)) [[1,2],[3]]      == [[2,4],[6]]    -- для каждого элемента
--     filter (not . null) xss          -- убрать пустые
--     filter (\xs -> length xs >= n) xss
--     map (filter even) xss            -- фильтр ВНУТРИ подсписков
--     concat [[1,2],[3]]               == [1,2,3]
--
-- Внутри map можно использовать сам подсписок целиком:
--     map (\xs -> map (\x -> x - minimum xs) xs) xss
--
-- minimum/maximum на [] ПАДАЮТ — пустые подсписки обрабатывай отдельно:
--     map (\xs -> if null xs then [] else ...) xss
--
-- Диапазон из переменных:  [minimum xs .. maximum xs]

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: map и секции
--   map f xs применяет f к каждому элементу.
--   Секция — оператор с одним уже подставленным аргументом:
--       (* 2) = \x -> x * 2       (+ 1) = \x -> x + 1       (> 0) = \x -> x > 0
--       map (+ 10) [1,2] == [11,12]
--
-- A1. Удвоить все числа (map).
doubleAll :: [Int] -> [Int]
doubleAll xs = map (* 2) xs
-- main = print (doubleAll [1,2,3])  -- [2,4,6]

-- >>> ТЕОРИЯ: filter
--   filter p xs оставляет элементы, для которых p даёт True:
--       filter (> 0) [3,-1,0,5] == [3,5]
--
-- A2. Оставить положительные (filter).
keepPositive :: [Int] -> [Int]
keepPositive xs = filter (> 0) xs
-- main = print (keepPositive [3,-1,0,5])  -- [3,5]

-- >>> ТЕОРИЯ: функция как аргумент
--   Тип (a -> a) -> a -> a: первый аргумент — ФУНКЦИЯ, второй — значение.
--   Внутри её вызывают как обычно:  f x.   Дважды:  f (f x).
--       applyTwice (+ 3) 10 = (10 + 3) + 3 = 16
--
-- A3. Применить функцию дважды.
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
-- main = print (applyTwice (+ 3) 10)  -- 16
-- main = print (applyTwice reverse "abc")  -- "abc"

-- >>> ТЕОРИЯ: предикат-аргумент
--   p — функция типа a -> Bool; просто передай её в filter:  length (filter p xs)
--
-- A4. Сколько элементов удовлетворяют предикату.
countIf :: (a -> Bool) -> [a] -> Int
countIf p xs = length (filter p xs)
-- main = print (countIf even [1,2,3,4])  -- 2

-- >>> ТЕОРИЯ: список списков, map sum
--   map sum [[1,2],[],[3,4]] == [3,0,7] — сумма КАЖДОГО подсписка;
--   потом ещё раз sum — общая сумма.   (или sum (concat xss))
--
-- A5. Сумма всех чисел в списке списков.
sumOfSums :: [[Int]] -> Int
sumOfSums xss = sum (map sum xss)
-- main = print (sumOfSums [[1,2],[],[3,4]])  -- 10

-- >>> ТЕОРИЯ: map length
--   Функция применяется к каждому ПОДСПИСКУ целиком:   map length [[1,2],[]] == [2,0]
--
-- A6. Длины подсписков.
lengths :: [[a]] -> [Int]
lengths xss = map length xss
-- main = print (lengths [[1,2],[],[3]])  -- [2,0,1]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: рекурсия, которая строит список
--   Обработать голову и положить её перед обработанным хвостом:
--       myMap f []     = []
--       myMap f (x:xs) = f x : myMap f xs
--
-- B1. Свой map рекурсией.
myMap :: (a -> b) -> [a] -> [b]
myMap _ []     = []
myMap f (x:xs) = f x : myMap f xs
-- main = print (myMap (* 10) [1,2,3])  -- [10,20,30]

-- >>> ТЕОРИЯ: foldr — свёртка справа
--   foldr f start xs:   foldr f z [1,2,3] = f 1 (f 2 (f 3 z))
--   Для списков удобно взять start = [], а f решает, класть ли элемент в начало накопителя:
--       foldr (\x acc -> x * 2 : acc) [] [1,2,3] == [2,4,6]       -- это map (* 2)
--   Шаги справа налево:  acc = []  ->  3: [6]  ->  2: [4,6]  ->  1: [2,4,6]
--   Для filter внутри лямбды:  if p x then x : acc else acc
--   Разница с foldl: у foldl лямбда  \acc x -> ...,  у foldr  \x acc -> ...
--
-- B2. Свой filter через foldr.
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p xs = foldr (\x acc -> if p x then x : acc else acc) [] xs
-- main = print (myFilter odd [1,2,3,4,5])  -- [1,3,5]

-- >>> ТЕОРИЯ: map внутри map
--   map (map (+ 1)) xss: внешний map — для каждого подсписка,
--   внутренний map (+ 1) — для каждого числа в нём.
--
-- B3. Прибавить 1 к каждому числу во всех подсписках.
incrementAll :: [[Int]] -> [[Int]]
incrementAll xss = map (map (+ 1)) xss
-- main = print (incrementAll [[1,2],[],[3]])  -- [[2,3],[],[4]]

-- >>> ТЕОРИЯ: filter по подспискам
--   Элементы здесь — списки, условие на их длину:
--       filter (\xs -> length xs >= n) xss
--
-- B4. Убрать подсписки короче n.
removeShort :: Int -> [[Int]] -> [[Int]]
removeShort n xss = filter (\xs -> length xs >= n) xss
-- main = print (removeShort 2 [[1],[1,2],[],[1,2,3]])  -- [[1,2],[1,2,3]]

-- >>> ТЕОРИЯ: лямбда, которая видит весь подсписок
--   Внутри  map (\xs -> ...) xss  переменная xs — ЦЕЛЫЙ подсписок.
--   Можно посчитать maximum xs и использовать его во внутреннем map:
--       map (\xs -> map (\x -> x - maximum xs) xs) xss
--   maximum [] падает, поэтому:  if null xs then [] else ...
--
-- B5. Из каждого элемента вычесть максимум его подсписка. Пустые остаются пустыми.
subtractMax :: [[Int]] -> [[Int]]
subtractMax xss = map (\xs -> if null xs then [] else map (\x -> x - maximum xs) xs) xss
-- main = print (subtractMax [[1,5,3],[],[2]])  -- [[-4,0,-2],[],[0]]

-- >>> ТЕОРИЯ: foldl по списку функций
--   foldl (\acc f -> f acc) x fs: накопитель — текущее значение,
--   на каждом шаге к нему применяется следующая функция:
--       [(+ 1), (* 2)] и 5:   5 -> 6 -> 12
--   Пустой список функций — вернётся x.
--
-- B6. Применить список функций по очереди слева направо (foldl).
applyAll :: [a -> a] -> a -> a
applyAll fs x = foldl (\acc f -> f acc) x fs
-- main = print (applyAll [(+ 1), (* 2)] 5)  -- 12
-- main = print (applyAll [] 5)  -- 5

-- >>> ТЕОРИЯ: диапазон из вычисленных границ
--   Границы диапазона могут быть выражениями:  [minimum xs .. maximum xs]
--   [] обработай отдельной строкой (minimum [] падает).
--
-- B7. Заменить список на диапазон [минимум .. максимум]. [] -> [].
rangeOf :: [Int] -> [Int]
rangeOf [] = []
rangeOf xs = [minimum xs .. maximum xs]
-- main = print (rangeOf [3,2,6])  -- [2,3,4,5,6]
-- main = print (rangeOf [])  -- []

-- >>> ТЕОРИЯ: предикат на списках
--   Тот же countIf, только элементы — списки:  length (filter p xss)
--
-- B8. Сколько подсписков удовлетворяют предикату.
countSublists :: ([Int] -> Bool) -> [[Int]] -> Int
countSublists p xss = length (filter p xss)
-- main = print (countSublists (\xs -> sum xs > 3) [[1,2],[5],[2,2]])  -- 2

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: map + if + две функции-аргумента
--   Для каждого x:  if p x then f x else x
--
-- C1. [midterm2 #5]
-- Write a function which takes a predicate p, a function f, and a list lst, and
-- returns a list that is just like lst, but in which every element x that
-- satisfies p is replaced by f applied to x.
selectiveMap :: (a -> Bool) -> (a -> a) -> [a] -> [a]
selectiveMap p f xs = map (\x -> if p x then f x else x) xs
-- main = print (selectiveMap odd (\x -> x*x) [])  -- []
-- main = print (selectiveMap odd (\x -> 6000) [2,4,6,8,10])  -- [2,4,6,8,10]
-- main = print (selectiveMap odd (\x -> 6000) [3,1,-5])  -- [6000,6000,6000]
-- main = print (selectiveMap even (\x -> x*x) [1,2,3,4,5])  -- [1,4,3,16,5]
-- main = print (selectiveMap (\c -> c == 'q') (\x -> 'u') "quip")  -- "uuip"
-- main = print (selectiveMap (== True) not [True,False,True])  -- [False,False,False]

-- >>> ТЕОРИЯ к C2: переиспользуй C1
--   selectiveMap odd (^ 2) xs.   (Integer — "длинное" целое, работает как Int.)
--
-- C2. [midterm4 #5]
-- Write a function that takes a list of Integers and returns a list just like it,
-- except that each odd element is replaced by the square of that element.
squareOdds :: [Integer] -> [Integer]
squareOdds xs = selectiveMap odd (^ 2) xs
-- main = print (squareOdds [])  -- []
-- main = print (squareOdds [3])  -- [9]
-- main = print (squareOdds [4,3])  -- [4,9]
-- main = print (squareOdds [1,2,3,4,5,6])  -- [1,2,9,4,25,6]
-- main = print (squareOdds [3,22,3])  -- [9,22,9]

-- >>> ТЕОРИЯ к C3: это B5
--   Вместо  x - maximum xs  нужно  x * minimum xs   (или map (* minimum xs) xs).
--
-- C3. [midterm3 #11]
-- For each sublist, multiply all its elements by the minimum value of that sublist.
-- If a sublist is empty, it remains unchanged. You must use higher-order functions.
multiplyWithMin :: [[Int]] -> [[Int]]
multiplyWithMin xss = map (\xs -> if null xs then [] else map (* minimum xs) xs) xss
-- main = print (multiplyWithMin [[1, 2, 3], [4, 6], [5, 7, 8]])  -- [[1,2,3],[16,24],[25,35,40]]
-- main = print (multiplyWithMin [[-100, 2], [3, -4, 5], [], [7, 8]])  -- [[10000,-200],[-12,16,-20],[],[49,56]]
-- main = print (multiplyWithMin [[]])  -- [[]]

-- >>> ТЕОРИЯ к C4: три шага + композиция (.)
--   (f . g) x = f (g x) — "сначала g, потом f".
--   1) убрать короткие подсписки — removeShort n (B4)
--   2) в каждом оставшемся убрать числа меньше n:   filter (>= n)
--   3) каждое x превратить в n - x:                  map (n -)      ((n -) = \x -> n - x)
--   Шаги 2-3 для одного подсписка:  map (n -) (filter (>= n) xs)
--   Для всех:  map (\xs -> map (n -) (filter (>= n) xs)) ...
--   или короче:  map (map (n -) . filter (>= n)) ...
--
-- C4. [midterm3 #8]
-- Write a function that takes a list of integer lists and an integer n.
-- Sublists with size less than n should be removed, inside sublists the numbers
-- smaller than n should also be removed, the numbers greater than n should be
-- subtracted from n.   (то есть каждый оставшийся x превращается в n - x)
-- [[6,2,4,5],[8,1],[6,6,7],[5,2,1,5],[1,1,1,1]] 4
--   -> [[6,2,4,5],[5,2,1,5],[1,1,1,1]] -> [[6,4,5],[5,5],[]] -> [[-2,0,-1],[-1,-1],[]]
f2 :: [[Int]] -> Int -> [[Int]]
f2 xss n = map (map (n -) . filter (>= n)) (removeShort n xss)
-- main = print (f2 [[6,2,4,5], [8,1], [6,6,7],[5,2,1,5],[1,1,1,1]] 4)  -- [[-2,0,-1],[-1,-1],[]]
-- main = print (f2 [[1..5], [1,3..10],[1]] 2)  -- [[0,-1,-2,-3],[-1,-3,-5,-7]]

-- >>> ТЕОРИЯ к C5: filter с двумя подсчётами
--   Условие для подсписка:  (сколько > 0) > (сколько < 0)   — countIf из A4.
--   Пустой подсписок: 0 > 0 — False, он удалится сам.
--
-- C5. [midterm4 #10]
-- Given a list of lists, keep only those sublists that have more positive numbers
-- than negative numbers. If a sublist is empty, it should be removed.
-- (0 — ни положительное, ни отрицательное.)
keepMorePositives :: [[Int]] -> [[Int]]
keepMorePositives xss = filter (\xs -> countIf (> 0) xs > countIf (< 0) xs) xss
-- main = print (keepMorePositives [[1, -2, 3], [-1, -3], [4, 5, -6], [], [0, 1, 2]])  -- [[1,-2,3],[4,5,-6],[0,1,2]]
-- main = print (keepMorePositives [[-1, 2, -3], [-4, -5], [0, -6, 7, -8]])  -- []
-- main = print (keepMorePositives [[1, 2, -1], [4, 5, 6], [3, -2, 1, 1]])  -- [[1,2,-1],[4,5,6],[3,-2,1,1]]
-- main = print (keepMorePositives [[0, 1, -1, 2], [3, 0, -4], [5, 5, -2, 0]])  -- [[0,1,-1,2],[5,5,-2,0]]
-- main = print (keepMorePositives [[], [], []])  -- []

-- >>> ТЕОРИЯ к C6: map + countIf
--   Каждый подсписок -> rangeOf (B7) -> sum;  потом countIf (== n).
--   sum . rangeOf — композиция:   map (sum . rangeOf) xss
--   [] -> rangeOf [] = [] -> сумма 0.
--
-- C6. [midterm1 #11]
-- Given a list of lists of integers and a number n, change every list to the range
-- from its minimum to its maximum ([3,2,6] -> [2,3,4,5,6]).
-- Afterwards count how many lists have sum equal to n. ([] turns into 0.)
cntSums :: [[Int]] -> Int -> Int
cntSums xss n = countIf (== n) (map (sum . rangeOf) xss)
-- main = print (cntSums [[1,4,2,6], [8,4,2,4], [2,4,2], []] 9)  -- 1
-- main = print (cntSums [[], [3,2,1], [4,6]] 0)  -- 1
-- main = print (cntSums [] 0)  -- 0
