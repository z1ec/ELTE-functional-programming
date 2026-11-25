-- ============================================================================
-- 10. СОРТИРОВКА, СЛИЯНИЕ, ПОИСК
-- ============================================================================
-- ТРЕНАЖЁР. Решения лежат в ../solutions/10_sorting_merging.hs (открывай только после своей попытки)
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи экзаменационного уровня.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/10_sorting_merging.hs
--   * ВСТРОЕННЫЕ sort / sortOn НЕ используй — смысл в том, чтобы написать самому.
--
-- Из syllabus: "algorithms — search, sort, traverse", "sorting algorithms, merging".
-- (Сортировка деревом поиска — в 05_trees_advanced.hs, C5.)

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: вставка в отсортированный список
--   Идём по списку, пока элементы меньше x, и вставляем x перед первым большим:
--       insertS x []     = [x]
--       insertS x (y:ys)
--         | x <= y    = x : y : ys        -- место нашлось
--         | otherwise = y : insertS x ys  -- y остаётся, ищем дальше
--
-- A1. Вставь x в отсортированный список, чтобы он остался отсортированным.
insertS :: Int -> [Int] -> [Int]
insertS = undefined
-- main = print (insertS 4 [1, 3, 5, 7])  -- [1,3,4,5,7]
-- main = print (insertS 9 [1, 3])  -- [1,3,9]
-- main = print (insertS 0 [])  -- [0]


-- >>> ТЕОРИЯ: образец x:y:rest — два первых элемента
--   Список отсортирован, если каждый элемент <= следующего:
--       isSorted []           = True
--       isSorted [_]          = True
--       isSorted (x : y : rest) = x <= y && isSorted (y : rest)
--
-- A2. Отсортирован ли список по возрастанию?
isSorted :: [Int] -> Bool
isSorted = undefined
-- main = print (isSorted [1, 2, 2, 5])  -- True
-- main = print (isSorted [3, 1])  -- False
-- main = print (isSorted [])  -- True


-- >>> ТЕОРИЯ: слияние двух отсортированных списков
--   Сравниваем ПЕРВЫЕ элементы, меньший забираем в ответ:
--       merge [] ys = ys
--       merge xs [] = xs
--       merge (x:xs) (y:ys)
--         | x <= y    = x : merge xs (y:ys)
--         | otherwise = y : merge (x:xs) ys
--
-- A3. Слей два отсортированных списка в один отсортированный.
merge :: [Int] -> [Int] -> [Int]
merge = undefined
-- main = print (merge [1, 4, 6] [2, 3, 10])  -- [1,2,3,4,6,10]
-- main = print (merge [] [5])  -- [5]


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: сортировка вставками
--   Сортируем хвост, а потом вставляем в него голову (A1):
--       insertionSort []     = []
--       insertionSort (x:xs) = insertS x (insertionSort xs)
--   (или foldr insertS [] xs — то же самое)
--
-- B1. Сортировка вставками.
insertionSort :: [Int] -> [Int]
insertionSort = undefined
-- main = print (insertionSort [5, 2, 9, 1, 5])  -- [1,2,5,5,9]
-- main = print (insertionSort [])  -- []


-- >>> ТЕОРИЯ: быстрая сортировка (quicksort)
--   Берём первый элемент p (опорный). Меньшие — налево, остальные — направо,
--   каждую часть сортируем так же:
--       quickSort []     = []
--       quickSort (p:xs) = quickSort [x | x <- xs, x < p] ++ [p] ++ quickSort [x | x <- xs, x >= p]
--
-- B2. Быстрая сортировка.
quickSort :: [Int] -> [Int]
quickSort = undefined
-- main = print (quickSort [3, 6, 1, 8, 2, 9, 2])  -- [1,2,2,3,6,8,9]
-- main = print (quickSort [1])  -- [1]


-- >>> ТЕОРИЯ: сортировка слиянием (merge sort)
--   1) делим список пополам:  splitAt k xs == (первые k, остальные)
--          splitAt 2 [1,2,3,4,5] == ([1,2],[3,4,5])
--      половина:  k = length xs `div` 2
--   2) сортируем каждую половину (рекурсия)
--   3) сливаем через merge (A3)
--   Списки из 0 и 1 элемента уже отсортированы (иначе рекурсия не кончится!):
--       mergeSort []  = []
--       mergeSort [x] = [x]
--       mergeSort xs  = merge (mergeSort left) (mergeSort right)
--         where (left, right) = splitAt (length xs `div` 2) xs
--
-- B3. Сортировка слиянием.
mergeSort :: [Int] -> [Int]
mergeSort = undefined
-- main = print (mergeSort [38, 27, 43, 3, 9, 82, 10])  -- [3,9,10,27,38,43,82]
-- main = print (mergeSort [2, 1])  -- [1,2]


------------------------------------------------------------------------------
-- ЧАСТЬ C. ЭКЗАМЕНАЦИОННЫЙ УРОВЕНЬ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: сортировка ПО КЛЮЧУ
--   Quicksort из B2, но сравниваем не сами элементы, а их второе поле:
--       snd ("Ann", 90) == 90
--   [x | x <- xs, snd x < snd p]  и т.д.
--   По УБЫВАНИЮ: большие идут налево.
--
-- C1. Отсортируй пары (имя, баллы) по баллам по УБЫВАНИЮ.
--   При равных баллах порядок сохраняется как во входе.
sortByScoreDesc :: [(String, Int)] -> [(String, Int)]
sortByScoreDesc = undefined
-- main = print (sortByScoreDesc [("Ann", 70), ("Bob", 95), ("Cid", 80)])  -- [("Bob",95),("Cid",80),("Ann",70)]
-- main = print (sortByScoreDesc [("A", 5), ("B", 5), ("C", 9)])  -- [("C",9),("A",5),("B",5)]


-- >>> ТЕОРИЯ: слияние многих списков через foldr
--   foldr merge [] [l1, l2, l3]  ==  merge l1 (merge l2 (merge l3 []))
--
-- C2. Слей список отсортированных списков в один.
mergeAll :: [[Int]] -> [Int]
mergeAll = undefined
-- main = print (mergeAll [[1, 5], [2, 3, 9], [0]])  -- [0,1,2,3,5,9]
-- main = print (mergeAll [])  -- []


-- >>> ТЕОРИЯ: медиана
--   Сортируем. Если длина n нечётная — средний элемент.
--   Если чётная — среднее двух средних.
--   Достать элемент по номеру без !! :  head (drop k xs)
--       drop 2 [10,20,30,40] == [30,40],   head [30,40] == 30
--   fromIntegral — чтобы получить Double.
--
-- C3. Медиана непустого списка.
median :: [Int] -> Double
median = undefined
-- main = print (median [5, 1, 3])  -- 3.0
-- main = print (median [4, 1, 3, 2])  -- 2.5


-- >>> ТЕОРИЯ: бинарный поиск по отсортированному списку
--   Смотрим на средний элемент m:
--     x == m -> нашли;  x < m -> ищем в левой половине;  иначе — в правой.
--   Половины через splitAt (как в B3):
--       (left, m : right) = splitAt (length xs `div` 2) xs
--   Пустой список — не нашли.
--
-- C4. Есть ли x в отсортированном списке? (бинарный поиск)
binarySearch :: Int -> [Int] -> Bool
binarySearch = undefined
-- main = print (binarySearch 7 [1, 3, 5, 7, 9, 11])  -- True
-- main = print (binarySearch 4 [1, 3, 5, 7, 9, 11])  -- False
-- main = print (binarySearch 1 [])  -- False


-- >>> ТЕОРИЯ: всё вместе
--   Отсортируй по убыванию (можно reverse (mergeSort xs)), убери повторы
--   у соседей и возьми первые k. Повторы у соседей:
--       dedup (x : y : rest) | x == y    = dedup (y : rest)
--                            | otherwise = x : dedup (y : rest)
--       dedup xs = xs
--
-- C5. k самых больших РАЗНЫХ чисел, по убыванию.
topK :: Int -> [Int] -> [Int]
topK = undefined
-- main = print (topK 3 [5, 1, 9, 9, 7, 5, 3])  -- [9,7,5]
-- main = print (topK 5 [2, 2])  -- [2]
