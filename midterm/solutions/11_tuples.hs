-- ============================================================================
-- 11. КОРТЕЖИ: ПАРЫ, ТРОЙКИ, "ЗАПИСИ"  (fst, snd, unzip, образцы)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/11_tuples.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 11_tuples.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 11_tuples.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #5, midterm1 #9, midterm2 #9, midterm3 #7, midterm4 #4, midterm4 #7, midterm5 #6

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Пара:   (1, "a") :: (Int, String)      fst (1, "a") == 1     snd (1, "a") == "a"
-- Тройка: ("Ann", "HR", 3000) :: (String, String, Int)
--   fst/snd работают ТОЛЬКО для пар! Для троек — образец:
--     name3 (n, _, _) = n
--
-- Разбор кортежа образцом — в аргументе, в лямбде, в генераторе:
--     sumPair (a, b) = a + b
--     map (\(a, b) -> a + b) ps
--     [a + b | (a, b) <- ps]
--     [n | (n, d, s) <- emps, s >= 3000]
--
-- Собрать кортеж в ответе:
--     [(abs (a - b), (a, b)) | (a, b) <- ps]     -- вложенный кортеж тоже можно
--
-- Список пар -> пара списков:
--     unzip [(1,'a'),(2,'b')] == ([1,2],"ab")      unzip3 — для троек
--   или руками: ([a | (a, _) <- ps], [b | (_, b) <- ps])
--
-- Поиск по ключу:
--     lookup 2 [(1,"one"),(2,"two")] == Just "two"
--     lookup 9 [...]                 == Nothing
--     case lookup k ps of
--       Just v  -> v
--       Nothing -> 0
--
-- Int -> Double:  fromIntegral
--     fromIntegral (100 :: Int) * 1.05  -- иначе ошибка типов Int * Double
--
-- Функция, данная в условии (getTaxRate), — просто вызывай её внутри map/генератора.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: кортеж и разбор образцом
--   (1, "x") — пара. Элементы могут быть разных типов: (Int, String).
--   В аргументе пару можно сразу разобрать:
--       first (a, b) = a
--
-- A1. Поменять местами элементы пары.
swapPair :: (a, b) -> (b, a)
swapPair (a, b) = (b, a)
-- main = print (swapPair (1, "x"))  -- ("x",1)

-- >>> ТЕОРИЯ: то же самое
--   sumPair (a, b) = ...
--
-- A2. Сумма пары.
sumPair :: (Int, Int) -> Int
sumPair (a, b) = a + b
-- main = print (sumPair (3, 4))  -- 7

-- >>> ТЕОРИЯ: fst, snd
--   fst (1,'a') == 1,   snd (1,'a') == 'a'   — только для ПАР.
--       map fst [(1,'a'),(2,'b')] == [1,2]
--
-- A3. Первые элементы всех пар.
firsts :: [(a, b)] -> [a]
firsts ps = map fst ps
-- main = print (firsts [(1,'a'),(2,'b')])  -- [1,2]

-- >>> ТЕОРИЯ: тройки
--   Для троек fst/snd НЕ работают, только образец:
--       age3 (_, a, _) = a          -- _ значит "это поле не нужно"
--
-- A4. Имя из тройки (имя, возраст, зарплата).
name3 :: (String, Int, Int) -> String
name3 (n, _, _) = n
-- main = print (name3 ("Ann", 30, 500))  -- "Ann"

-- >>> ТЕОРИЯ: разбор пары в генераторе
--   [выражение | (a, b) <- ps] — каждая пара сразу разбирается на a и b.
--   max a b — большее из двух.
--
-- A5. Максимум каждой пары.
maxOfPairs :: [(Int, Int)] -> [Int]
maxOfPairs ps = [max a b | (a, b) <- ps]
-- main = print (maxOfPairs [(1,5),(7,2)])  -- [5,7]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: собрать пару в ответе
--   Ответ — пара из двух независимых вычислений:   (sum (map fst ps), ...)
--   sum [] == 0, так что пустой список работает сам.
--
-- B1. Сложить первые элементы и вторые элементы отдельно.
sumTuples :: [(Int, Int)] -> (Int, Int)
sumTuples ps = (sum (map fst ps), sum (map snd ps))
-- main = print (sumTuples [(1,1),(2,2),(3,3)])  -- (6,6)
-- main = print (sumTuples [])  -- (0,0)

-- >>> ТЕОРИЯ: пара -> тройка
--   [(a, b, a * b) | (a, b) <- ps]
--
-- B2. Каждую пару (a, b) превратить в тройку (a, b, a*b).
addProduct :: [(Int, Int)] -> [(Int, Int, Int)]
addProduct ps = [(a, b, a * b) | (a, b) <- ps]
-- main = print (addProduct [(2,3),(4,5)])  -- [(2,3,6),(4,5,20)]

-- >>> ТЕОРИЯ: фильтр по одному полю, ответ — другое поле
--   [n | (n, age) <- ps, age >= 18]
--
-- B3. Имена тех, кому 18 или больше.
adults :: [(String, Int)] -> [String]
adults ps = [n | (n, age) <- ps, age >= 18]
-- main = print (adults [("Ann",17),("Bob",18),("Cid",40)])  -- ["Bob","Cid"]

-- >>> ТЕОРИЯ: пара списков
--   Два генератора с противоположными условиями, собранные в пару:
--       ([... | ..., a < 18], [... | ..., a >= 18])
--
-- B4. Разделить на (младше 18, остальные) — пара списков имён.
splitByAge :: [(String, Int)] -> ([String], [String])
splitByAge ps = ([n | (n, a) <- ps, a < 18], [n | (n, a) <- ps, a >= 18])
-- main = print (splitByAge [("Ann",17),("Bob",18),("Cid",5)])  -- (["Ann","Cid"],["Bob"])

-- >>> ТЕОРИЯ: генератор по тройкам
--   [q * p | (_, q, p) <- items], потом sum.
--
-- B5. Тройки (товар, количество, цена за штуку) -> общая стоимость.
totalCost :: [(String, Int, Int)] -> Int
totalCost items = sum [q * p | (_, q, p) <- items]
-- main = print (totalCost [("pen",3,10),("book",1,50)])  -- 80

-- >>> ТЕОРИЯ: lookup, Maybe, case
--   lookup ключ пары ищет первую пару с таким ключом:
--       lookup "b" [("a",1),("b",2)] == Just 2
--       lookup "z" [("a",1)]         == Nothing
--   Maybe — это "значение или ничего". Разбираем его через case:
--       case lookup k ps of
--         Just v  -> v
--         Nothing -> 0
--
-- B6. Значение по ключу или 0, если ключа нет (lookup).
lookupOr0 :: String -> [(String, Int)] -> Int
lookupOr0 k ps = case lookup k ps of
  Just v  -> v
  Nothing -> 0
-- main = print (lookupOr0 "b" [("a",1),("b",2)])  -- 2
-- main = print (lookupOr0 "z" [("a",1)])  -- 0

-- >>> ТЕОРИЯ: fromIntegral — Int в Double
--   Int и Double нельзя складывать и умножать напрямую:
--       (100 :: Int) * 1.5        -- ОШИБКА типов
--       fromIntegral p * 1.5      -- ok: fromIntegral превращает Int в Double
--   Цена с налогом:  fromIntegral p * (1 + rate)
--
-- B7. Цены в Int, к каждой добавить налог (Double). Вернуть сумму.
-- Подсказка: fromIntegral.
withTax :: [Int] -> Double -> Double
withTax prices rate = sum [fromIntegral p * (1 + rate) | p <- prices]
-- main = print (withTax [100, 200] 0.5)  -- 450.0

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: A2 для всех пар
--   sum [a + b | (a, b) <- ps]
--
-- C1. [midterm1 #5]
-- Write a function that takes a list of tuples of integers
-- and returns the sum of all the elements in all the tuples.
sumPairs :: [(Int, Int)] -> Int
sumPairs ps = sum [a + b | (a, b) <- ps]
-- main = print (sumPairs [(1, 2), (3, 4), (5, 6)])  -- 21
-- main = print (sumPairs [(7, 8)])  -- 15
-- main = print (sumPairs [])  -- 0
-- main = print (sumPairs [(1, -2), (-3, 0), (5, -6)])  -- -5

-- >>> ТЕОРИЯ к C2: пара внутри пары
--   В ответе может быть пара внутри пары:  (abs (a - b), (a, b))
--
-- C2. [midterm4 #4]
-- Write a function that takes a list of tuples (Int, Int) and returns a list of tuples
-- where each tuple contains the absolute value of the difference of the two elements
-- as the first element, and the original tuple as the second element.
tupleDifferences :: [(Int, Int)] -> [(Int, (Int, Int))]
tupleDifferences ps = [(abs (a - b), (a, b)) | (a, b) <- ps]
-- main = print (tupleDifferences [(3,5),(10,2),(4,4)])  -- [(2,(3,5)),(8,(10,2)),(0,(4,4))]
-- main = print (tupleDifferences [(2,4),(-10,2),(4,-4),(0,0)])  -- [(2,(2,4)),(12,(-10,2)),(8,(4,-4)),(0,(0,0))]
-- main = print (tupleDifferences [(3,5),(15,15),(-4,-9),(88,-99)])  -- [(2,(3,5)),(0,(15,15)),(5,(-4,-9)),(187,(88,-99))]

-- >>> ТЕОРИЯ к C3: как B1, но списки, а не суммы
--   ([a | (a, _) <- ps], [b | (_, b) <- ps])
--
-- C3. [midterm3 #7]
-- Write a function that takes a list of tuples and returns a single tuple that
-- contains two lists: one for the first elements and one for the second elements.
-- (В sample для [] написано [], но тип ответа — пара, так что это ([],[]).)
mergeTuples :: [(a, b)] -> ([a], [b])
mergeTuples ps = ([a | (a, _) <- ps], [b | (_, b) <- ps])
-- main = print (mergeTuples [(1, "apple"), (2, "banana"), (3, "cherry")])  -- ([1,2,3],["apple","banana","cherry"])
-- main = print (mergeTuples [(10, "x"), (20, "y")])  -- ([10,20],["x","y"])
-- main = print (mergeTuples ([] :: [(Int, String)]))  -- ([],[])

-- >>> ТЕОРИЯ к C4: unzip
--   unzip [(1,'a'),(2,'b')] == ([1,2],"ab") — ровно то, что нужно (как C3).
--
-- C4. [midterm4 #7]
-- Write a function that takes a list of (name, age) tuples and returns a pair of
-- lists: one containing all the names and another containing all the ages.
-- Подсказка: одной встроенной функцией.
extractNamesAndAges :: [(String, Int)] -> ([String], [Int])
extractNamesAndAges ps = unzip ps
-- main = print (extractNamesAndAges [("Alice", 30), ("Bob", 25), ("Charlie", 35)])  -- (["Alice","Bob","Charlie"],[30,25,35])
-- main = print (extractNamesAndAges [("John", 40), ("Doe", 28)])  -- (["John","Doe"],[40,28])
-- main = print (extractNamesAndAges [])  -- ([],[])

-- >>> ТЕОРИЯ к C5: фильтр по сумме пары
--   [(a, b) | (a, b) <- ps, a + b > n]
--
-- C5. [midterm2 #9]
-- Write a function that takes an integer and a list of tuples, and returns only the
-- tuples where the sum of elements is greater than the given integer.
-- (В sample первые три теста не сходятся с условием — у них знак сравнения
--  перепутан. Здесь тесты по УСЛОВИЮ: сумма строго больше.)
filterTupleSum :: Int -> [(Int, Int)] -> [(Int, Int)]
filterTupleSum n ps = [(a, b) | (a, b) <- ps, a + b > n]
-- main = print (filterTupleSum 4 [(2, 3), (1, 4), (5, 0), (2, 2)])  -- [(2,3),(1,4),(5,0)]
-- main = print (filterTupleSum 10 [(2, 3), (1, 4), (5, 0), (2, 2)])  -- []
-- main = print (filterTupleSum (-1) [(2, -3), (0, -1), (1, 1), (-1, 0)])  -- [(1,1)]
-- main = print (filterTupleSum 7 [])  -- []

-- >>> ТЕОРИЯ к C6: тройки + два условия + пара списков
--   Как B4, но у каждого генератора ДВА условия:
--       зарплата >= 3000   и   отдел == "Engineering"   (во втором списке /=)
--
-- C6. [midterm5 #6]
-- Employee records (name, department, salary).
--   - Filter out employees who earn below 3000, regardless of their department.
--   - The first list: names of employees in the "Engineering" department.
--   - The second list: names of employees in all other departments.
categorizeEmployees :: [(String, String, Int)] -> ([String], [String])
categorizeEmployees emps =
  ( [n | (n, d, s) <- emps, s >= 3000, d == "Engineering"]
  , [n | (n, d, s) <- emps, s >= 3000, d /= "Engineering"] )
-- main = print (categorizeEmployees [("Alice", "Engineering", 3200), ("Bob", "Marketing", 2800), ("Charlie", "Engineering", 4000), ("David", "Sales", 5000)])  -- (["Alice","Charlie"],["David"])
-- main = print (categorizeEmployees [("Eve", "Engineering", 2000), ("Frank", "Marketing", 2500), ("Grace", "Engineering", 1800)])  -- ([],[])
-- main = print (categorizeEmployees [("Henry", "Engineering", 3500), ("Ivy", "Engineering", 4000)])  -- (["Henry","Ivy"],[])
-- main = print (categorizeEmployees [("Jack", "Sales", 4500), ("Kara", "Marketing", 3100)])  -- ([],["Jack","Kara"])
-- main = print (categorizeEmployees [("Leo", "Engineering", 3000), ("Mia", "HR", 2999), ("Nina", "Engineering", 3100), ("Oscar", "Sales", 3000)])  -- (["Leo","Nina"],["Oscar"])

-- >>> ТЕОРИЯ к C7: данная функция + fromIntegral + where
--   Стоимость товара:  fromIntegral p * (1 + getTaxRate c)
--   Сумма по всем — генератор + sum (получится Double).
--   Деньги — Int, их тоже переводим:   total <= fromIntegral money
--   total удобно вынести в where.
--
-- C7. [midterm1 #9]
-- Shopping list: each item is (price :: Int, category :: String). canAfford returns
-- True if the total cost (after tax) does not exceed the available money.
-- Use getTaxRate:  food 5%, electronics 15%, clothing 10%, other 8%.
-- (дано)
getTaxRate :: String -> Double
getTaxRate "food" = 0.05
getTaxRate "electronics" = 0.15
getTaxRate "clothing" = 0.10
getTaxRate _ = 0.08

canAfford :: [(Int, String)] -> Int -> Bool
canAfford items money = total <= fromIntegral money
  where total = sum [fromIntegral p * (1 + getTaxRate c) | (p, c) <- items]
-- main = print (canAfford [(100, "food"), (200, "electronics"), (50, "clothing")] 400)  -- True
-- main = print (canAfford [(100, "food"), (200, "electronics"), (50, "clothing")] 300)  -- False
-- main = print (canAfford [(100, "food"), (80, "clothing")] 200)  -- True
-- main = print (canAfford [(100, "food"), (200, "electronics"), (400, "furniture")] 760)  -- False
