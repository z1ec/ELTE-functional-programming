-- ============================================================================
-- 04. ГЕНЕРАТОРЫ СПИСКОВ: ПАРЫ, ТРОЙКИ, ПЕРЕБОР
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/04_comprehension_pairs.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 04_comprehension_pairs.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--   * ghci:   ghci 04_comprehension_pairs.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #7, midterm1 #12, midterm2 #10, midterm2 #12, midterm5 #2, midterm6 #2

import Data.List (nub, tails)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Генератор:  [ВЫРАЖЕНИЕ | x <- СПИСОК, УСЛОВИЕ, ...]
--
-- Два генератора = вложенные циклы (правый крутится быстрее):
--     [(x, y) | x <- [1,2], y <- "ab"] == [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
--
-- Зависимый генератор — чтобы не было дублей (3,4,5) и (4,3,5):
--     [(a, b) | a <- [1..n], b <- [a..n], ...]        -- b начинается с a
--   Порядок генераторов = порядок ответа! Если в ответе тройки отсортированы
--   по c, то первым генератором должен идти c:
--     [(a, b, c) | c <- [1..n], b <- [1..c], a <- [1..b], a*a + b*b == c*c]
--
-- Пары элементов СПИСКА "каждый с каждым последующим" (i < j) — через tails:
--     tails [1,2,3] == [[1,2,3],[2,3],[3],[]]
--     [(x, y) | (x:rest) <- tails [1,2,3], y <- rest] == [(1,2),(1,3),(2,3)]
--   (образец (x:rest) просто пропускает пустой хвост [])
--   Или через индексы:
--     [(x, y) | (i, x) <- zip [0..] xs, (j, y) <- zip [0..] xs, i < j]
--
-- let внутри генератора:
--     [(x, s) | x <- [1..5], let s = x * x, s > 10] == [(4,16),(5,25)]
--
-- Убрать дубликаты: nub [1,2,1,3,2] == [1,2,3]   (import Data.List; оставляет ПЕРВОЕ)
--
-- Условие внутри выражения:
--     [if even x then 'e' else 'o' | x <- [1,2,3]] == "oeo"
--
-- Функция, данная в условии (как birdsName), — просто вызывай её:
--     [(c, birdsName c) | c <- "BC"]

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: два генератора = все комбинации
--   [(x, y) | x <- [1,2], y <- "ab"] == [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
--   Это как два вложенных цикла: для каждого x перебираются ВСЕ y
--   (правый генератор крутится быстрее).
--   Если один из списков пустой, пар нет.
--
-- A1. Все пары (x, y): x из первого списка, y из второго.
allPairs :: [Int] -> [Int] -> [(Int, Int)]
allPairs xs ys = [(x, y) | x <- xs, y <- ys]
-- main = print (allPairs [1,2] [3,4])  -- [(1,3),(1,4),(2,3),(2,4)]
-- main = print (allPairs [] [3,4])  -- []

-- >>> ТЕОРИЯ: второй элемент можно вычислить, а не перебирать
--   Если a + b == n, то b = n - a. Значит хватит одного генератора:
--       [(a, n - a) | a <- [1..n], условие]
--   Условие a <= b, то есть a <= n - a (чтобы не было одновременно (1,5) и (5,1)).
--
-- A2. Все пары (a, b), 1 <= a <= b, a + b == n.
pairsSumTo :: Int -> [(Int, Int)]
pairsSumTo n = [(a, n - a) | a <- [1..n], a <= n - a]
-- main = print (pairsSumTo 6)  -- [(1,5),(2,4),(3,3)]
-- main = print (pairsSumTo 1)  -- []

-- >>> ТЕОРИЯ: условие, которое связывает два генератора
--   [(x, y) | x <- xs, y <- xs, x < y] — оба числа берутся из ОДНОГО списка,
--   остаются пары, где x < y.
--   Порядок ответа = порядок перебора: для [3,1,2] сначала x = 3 (пар нет), потом x = 1, ...
--
-- A3. Пары (x, y) из элементов списка, где x < y (по значению).
orderedPairs :: [Int] -> [(Int, Int)]
orderedPairs xs = [(x, y) | x <- xs, y <- xs, x < y]
-- main = print (orderedPairs [3,1,2])  -- [(1,3),(1,2),(2,3)]

-- >>> ТЕОРИЯ: tails и образец в генераторе
--   tails (из Data.List) даёт все "хвосты" списка:
--       tails [1,2,3] == [[1,2,3],[2,3],[3],[]]
--   В генераторе хвост можно разобрать образцом (x:rest): x первый, rest остальные:
--       [(x, rest) | (x:rest) <- tails [1,2,3]] == [(1,[2,3]),(2,[3]),(3,[])]
--   (пустой хвост [] под (x:rest) не подходит и просто пропускается)
--   Осталось для каждого x перебрать y из rest вторым генератором:  y <- rest.
--   Так получаются пары "элемент и каждый элемент ПОСЛЕ него" (по позиции, не по значению).
--
-- A4. Каждый элемент с каждым ПОСЛЕДУЮЩИМ (по позиции).
laterPairs :: [a] -> [(a, a)]
laterPairs xs = [(x, y) | (x:rest) <- tails xs, y <- rest]
-- main = print (laterPairs [1,2,3])  -- [(1,2),(1,3),(2,3)]
-- main = print (laterPairs "ab")  -- [('a','b')]

-- >>> ТЕОРИЯ: зависимый генератор, тройки
--   Второй генератор может использовать переменную первого:  b <- [a..n]
--       [(a, b) | a <- [1..3], b <- [a..3]] == [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
--   Так не бывает одновременно (1,2) и (2,1).
--   В ответе может быть и тройка:  (a, b, a * b).
--
-- A5. Таблица умножения n x n в виде троек (a, b, a*b), a <= b.
multTable :: Int -> [(Int, Int, Int)]
multTable n = [(a, b, a * b) | a <- [1..n], b <- [a..n]]
-- main = print (multTable 2)  -- [(1,1,1),(1,2,2),(2,2,4)]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: генератор по готовому списку пар
--   Можно перебирать пары, которые вернула твоя функция, сразу разбирая их:
--       [(x, y) | (x, y) <- laterPairs xs, x + y == t]
--
-- B1. Пары элементов (по позициям i < j), сумма которых равна t.
pairsWithSum :: [Int] -> Int -> [(Int, Int)]
pairsWithSum xs t = [(x, y) | (x, y) <- laterPairs xs, x + y == t]
-- main = print (pairsWithSum [1,2,3,4,5] 6)  -- [(1,5),(2,4)]
-- main = print (pairsWithSum [1,1] 3)  -- []

-- >>> ТЕОРИЯ: три числа, третье вычисляется; let
--   a <- [1..n], b <- [a..n], третье c = n - a - b; условие c >= b (чтобы a <= b <= c).
--   В ответ кладём  (a, b, n - a - b).
--   Через let в генераторе можно дать имя промежуточному значению:
--       [(a, b, c) | a <- [1..n], b <- [a..n], let c = n - a - b, c >= b]
--
-- B2. Тройки 1 <= a <= b <= c, a + b + c == n.
triplesSum :: Int -> [(Int, Int, Int)]
triplesSum n = [(a, b, n - a - b) | a <- [1..n], b <- [a..n], n - a - b >= b]
-- main = print (triplesSum 6)  -- [(1,1,4),(1,2,3),(2,2,2)]

-- >>> ТЕОРИЯ: nub
--   nub (из Data.List) убирает повторы и оставляет ПЕРВОЕ вхождение:
--       nub [1,5,3,5,1] == [1,5,3]
--   Перебирай x и y из nub xs, условие y - x == d.
--
-- B3. Уникальные пары (x, y) значений списка, где y - x == d.
-- Сначала nub, потом перебор.
diffPairs :: [Int] -> Int -> [(Int, Int)]
diffPairs xs d = [(x, y) | x <- nub xs, y <- nub xs, y - x == d]
-- main = print (diffPairs [1,5,3,4,2,5] 2)  -- [(1,3),(3,5),(2,4)]

-- >>> ТЕОРИЯ: перебор с условием-уравнением
--   a <- [1..n], b <- [a..n], условие  a * a + b * b == n.
--
-- B4. Все пары (a, b), a <= b, a^2 + b^2 == n.
sumOfTwoSquares :: Int -> [(Int, Int)]
sumOfTwoSquares n = [(a, b) | a <- [1..n], b <- [a..n], a * a + b * b == n]
-- main = print (sumOfTwoSquares 50)  -- [(1,7),(5,5)]
-- main = print (sumOfTwoSquares 3)  -- []

-- >>> ТЕОРИЯ: генератор по строке, notElem
--   Строка — это список символов, поэтому по ней тоже можно перебирать:  c <- "abe"
--   c `elem` "aeiou"    — c есть в строке;     c `notElem` "aeiou" — c нет в строке.
--   Можно чередовать: генератор, условие на него, потом второй генератор:
--       [(c, n) | c <- s, <условие на c>, n <- ns]
--
-- B5. Для каждой СОГЛАСНОЙ буквы строки — пары с каждым числом из списка.
consonantCodes :: String -> [Int] -> [(Char, Int)]
consonantCodes s ns = [(c, n) | c <- s, c `notElem` "aeiou", n <- ns]
-- main = print (consonantCodes "abe" [1,2])  -- [('b',1),('b',2)]

-- Дана функция-словарь и список известных кодов:
-- (дано)
colorName :: Char -> String
colorName 'R' = "Red"
colorName 'G' = "Green"
colorName 'B' = "Blue"
colorName _   = error "unknown color"

-- (дано)
knownColors :: [Char]
knownColors = "RGB"

-- >>> ТЕОРИЯ: if внутри выражения; данная функция
--   if условие then значение1 else значение2 — это ВЫРАЖЕНИЕ, else обязателен:
--       [if even x then "even" else "odd" | x <- [1,2]] == ["odd","even"]
--   Данная функция colorName падает на неизвестных символах. Поэтому сначала проверка
--   c `elem` knownColors, и только при True вызов colorName c.
--
-- B6. Для каждого символа строки — пара (символ, название цвета),
-- а для неизвестного символа — (символ, "???"). Вызывать colorName для
-- неизвестного символа НЕЛЬЗЯ (будет error) — сначала проверь elem.
describeColors :: String -> [(Char, String)]
describeColors s = [(c, if c `elem` knownColors then colorName c else "???") | c <- s]
-- main = print (describeColors "RB")  -- [('R',"Red"),('B',"Blue")]
-- main = print (describeColors "GX")  -- [('G',"Green"),('X',"???")]

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: пары по позициям + "или" + выбор порядка в паре
--   || — логическое "или".   a делится на b:  a `mod` b == 0.
--   Перебираем пары (x, y), где y стоит после x (laterPairs из A4).
--   Оставляем пару, если x делится на y ИЛИ y делится на x.
--   В ответ ставим ДЕЛИМОЕ первым:   if x `mod` y == 0 then (x, y) else (y, x)
--   [2,3,4,6]: пара (2,4) — 4 делится на 2 — в ответ (4,2).
--
-- C1. [midterm1 #7]
-- Write a function that, given a list of integers, returns all pairs of numbers (a, b)
-- from the list where a is divisible by b. Each pair should be unique, meaning that
-- (a, b) is considered the same as (b, a) and should only appear once.
-- Подсказка: перебирай пары по позициям (x раньше y) и ставь делимое первым.
divisiblePairs :: [Int] -> [(Int, Int)]
divisiblePairs xs =
  [if x `mod` y == 0 then (x, y) else (y, x) | (x, y) <- laterPairs xs, x `mod` y == 0 || y `mod` x == 0]
-- main = print (divisiblePairs [2, 3, 4, 6])  -- [(4,2),(6,2),(6,3)]
-- main = print (divisiblePairs [10, 5, 2, 1])  -- [(10,5),(10,2),(10,1),(5,1),(2,1)]
-- main = print (divisiblePairs [12, 3, 4, 6])  -- [(12,3),(12,4),(12,6),(6,3)]

-- >>> ТЕОРИЯ к C2: два генератора с условиями + nub
--   Условие можно ставить сразу после "своего" генератора:
--       [(x, y) | x <- xs, x < n, y <- xs, y >= n, even (x + y)]
--   "unique pairs" — значит nub вокруг всего результата.
--
-- C2. [midterm2 #10]
-- Given a list of integers and a target number n, find all unique pairs of integers
-- within the list where the first element is less than n, the second element is
-- greater than or equal to n, and the sum of the two elements is even.
findPairs :: [Int] -> Int -> [(Int, Int)]
findPairs xs n = nub [(x, y) | x <- xs, x < n, y <- xs, y >= n, even (x + y)]
-- main = print (findPairs [1, 3, 5, 8, 10, 12, 13, 14, 16, 18] 10)  -- [(1,13),(3,13),(5,13),(8,10),(8,12),(8,14),(8,16),(8,18)]
-- main = print (findPairs [2, 4, 6, 7, 9, 11, 13, 15 ,16, 17] 9)  -- [(2,16),(4,16),(6,16),(7,9),(7,11),(7,13),(7,15),(7,17)]

-- >>> ТЕОРИЯ к C3: порядок генераторов = порядок ответа
--   В тесте ответ отсортирован по c, потом по b, поэтому первым генератором идёт c:
--       c <- [1..n], b <- [1..c], a <- [1..b]      (так a <= b <= c и нет дублей)
--   Условие:  a*a + b*b == c*c.
--   Если первым поставить a, тройки будут верные, но в другом порядке, и тест не совпадёт.
--
-- C3. [midterm5 #2]
-- Given a positive n, generate a list of all Pythagorean triples (a,b,c)
-- consisting of numbers between 1 and n. No duplicates, a < b < c.
-- (В условии "less than n", но тест f3 30 содержит (18,24,30) — значит <= n.
--  Порядок в ответе — по c, потом по b: см. теорию.)
f3 :: Int -> [(Int, Int, Int)]
f3 n = [(a, b, c) | c <- [1..n], b <- [1..c], a <- [1..b], a * a + b * b == c * c]
-- main = print (f3 7)  -- [(3,4,5)]
-- main = print (f3 30)  -- [(3,4,5),(6,8,10),(5,12,13),(9,12,15),(8,15,17),(12,16,20),(15,20,25),(7,24,25),(10,24,26),(20,21,29),(18,24,30)]
-- main = print (f3 1)  -- []

-- >>> ТЕОРИЯ к C4: переиспользуй C3
--   Перебери тройки из f3 n и оставь те, где gcd a b == 1:
--       [(a, b, c) | (a, b, c) <- f3 n, <условие>]
--
-- C4. [midterm6 #2]
-- Same Pythagorean triples, but only co-prime ones (their greatest common divisor is 1).
f4 :: Int -> [(Int, Int, Int)]
f4 n = [(a, b, c) | (a, b, c) <- f3 n, gcd a b == 1]
-- main = print (f4 10)  -- [(3,4,5)]
-- main = print (f4 30)  -- [(3,4,5),(5,12,13),(8,15,17),(7,24,25),(20,21,29)]
-- main = print (f4 1)  -- []

-- Даны в midterm1 #12 и midterm2 #12:
-- (дано)
birdsName :: Char -> String
birdsName 'B' = "Bluebird"
birdsName 'C' = "Cardinal"
birdsName 'S' = "Starling"
birdsName 'K' = "Kestrel"
birdsName 'M' = "Mockingbird"
birdsName _ = error "You just discovered a new bird!"

-- (дано)
currentLib :: [Char]
currentLib = ['B','C','S','K','M']

-- (дано)
possibleBirds :: [String]
possibleBirds = ["Hummingbird","Dove","Dickcissel","Why Bird","Eagle","Lark"]

-- >>> ТЕОРИЯ к C5: это B6, только с птицами
--   Известный код -> (c, birdsName c);   неизвестный -> (c, "To be named!").
--   Проверка: c `elem` currentLib.
--
-- C5. [midterm1 #12]
-- Implement extendBLib which takes a String of letter codes and returns
-- (code, bird's name) for each code. Get the name with birdsName.
-- For an unknown letter code return (code, "To be named!").
extendBLib :: [Char] -> [(Char, String)]
extendBLib s = [(c, if c `elem` currentLib then birdsName c else "To be named!") | c <- s]
-- main = print (extendBLib "BCKMS")  -- [('B',"Bluebird"),('C',"Cardinal"),('K',"Kestrel"),('M',"Mockingbird"),('S',"Starling")]
-- main = print (extendBLib "BKMY")  -- [('B',"Bluebird"),('K',"Kestrel"),('M',"Mockingbird"),('Y',"To be named!")]
-- main = print (extendBLib "BSLKMY")  -- [('B',"Bluebird"),('S',"Starling"),('L',"To be named!"),('K',"Kestrel"),('M',"Mockingbird"),('Y',"To be named!")]

-- >>> ТЕОРИЯ к C6: это B5, только с птицами
--   Берём буквы, которых НЕТ в currentLib, и каждую соединяем со всеми именами из possibleBirds.
--
-- C6. [midterm2 #12]
-- Generate all new letter codes and their possible name pairs for the letters
-- that are not in currentLib (every new letter with every name of possibleBirds).
newGuess :: String -> [(Char, String)]
newGuess s = [(c, b) | c <- s, c `notElem` currentLib, b <- possibleBirds]
-- main = print (newGuess "BCKMS")  -- []
-- main = print (newGuess "BKMY")  -- [('Y',"Hummingbird"),('Y',"Dove"),('Y',"Dickcissel"),('Y',"Why Bird"),('Y',"Eagle"),('Y',"Lark")]
-- main = print (newGuess "BSLKMYE")  -- [('L',"Hummingbird"),('L',"Dove"),('L',"Dickcissel"),('L',"Why Bird"),('L',"Eagle"),('L',"Lark"),('Y',"Hummingbird"),('Y',"Dove"),('Y',"Dickcissel"),('Y',"Why Bird"),('Y',"Eagle"),('Y',"Lark"),('E',"Hummingbird"),('E',"Dove"),('E',"Dickcissel"),('E',"Why Bird"),('E',"Eagle"),('E',"Lark")]
