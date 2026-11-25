-- ============================================================================
-- 01. PARALLEL LIST COMPREHENSION  (параллельные генераторы  x <- xs | y <- ys)
-- ============================================================================
-- ТРЕНАЖЁР. Решения лежат в ../solutions/01_parallel_comprehension.hs (открывай только после своей попытки)
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/01_parallel_comprehension.hs
--   * Или как на экзамене: убери "-- " перед ОДНОЙ строкой "main = print ...",
--     сохрани и запусти   runghc 01_parallel_comprehension.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci 01_parallel_comprehension.hs, потом пиши выражение; после правок — :r
--
-- Задачи из sample в этом файле:
--   endterm1 #1 mulAdA, #2 elementWise, #3 processTuples
--   endterm2 #1 applyFunction, #2 gen2
--   endterm3 #1 dotProd, #2 lightStates
--   endterm4 #1 gen1, #2 shiftPoints
-- На экзамене это всегда задачи 1–2 (по 10 баллов). Без параллельного
-- генератора дают максимум 8 из 10, так что выучи именно его.

{-# LANGUAGE ParallelListComp #-}

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: обычный list comprehension (вспоминаем)
--   [ выражение | x <- список ]           -- "для каждого x из списка"
--       [x * 2 | x <- [1,2,3]]             == [2,4,6]
--   После запятой можно поставить условие (фильтр):
--       [x | x <- [1..10], even x]         == [2,4,6,8,10]
--   ДВА генератора через ЗАПЯТУЮ = ВСЕ ПАРЫ (как цикл в цикле):
--       [(x,y) | x <- [1,2], y <- "ab"]    == [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
--
-- >>> ТЕОРИЯ: ПАРАЛЛЕЛЬНЫЙ comprehension — генераторы через ЧЕРТУ  |
--   В самом верху файла должна стоять строка (она уже есть выше):
--       {-# LANGUAGE ParallelListComp #-}
--   На экзамене она тоже уже написана в начале файла. Не удаляй её!
--
--       [(x,y) | x <- [1,2,3] | y <- "abc"]   == [(1,'a'),(2,'b'),(3,'c')]
--   Списки идут ОДНОВРЕМЕННО: 1-й элемент с 1-м, 2-й со 2-м и т.д.
--   Это то же самое, что zip. Длина ответа = длина САМОГО КОРОТКОГО списка:
--       [x + y | x <- [1,2,3] | y <- [10,20]]  == [11,22]
--
--   Без расширения то же самое пишут через zip (на экзамене это максимум 8 баллов):
--       [x + y | (x,y) <- zip [1,2,3] [10,20]] == [11,22]
--
-- A1. Сложи два списка поэлементно.
--   План: одна строка — [ x + y | x <- xs | y <- ys ].
addLists :: [Int] -> [Int] -> [Int]
addLists l1 l2 = [ x + y | x <- l1 | y <- l2 ]
-- main = print (addLists [1,2,3] [10,20,30])  -- [11,22,33]
-- main = print (addLists [5,5] [1,2,3,4])  -- [6,7]
-- main = print (addLists [] [1,2])  -- []


-- >>> ТЕОРИЯ: бесконечный список [1..] в параллельном генераторе
--   [1..] — это 1,2,3,4,... без конца. Сам по себе он никогда не закончится,
--   но в параллельном генераторе он идёт ВМЕСТЕ с конечным списком
--   и останавливается, когда закончится короткий:
--       [(i, c) | i <- [1..] | c <- "hey"]    == [(1,'h'),(2,'e'),(3,'y')]
--   Так удобно нумеровать элементы.
--   Строка (String) — это список символов: "hey" == ['h','e','y'],
--   поэтому  c <- "hey"  перебирает буквы.
--
-- A2. Пронумеруй буквы строки, начиная с 1.
numbered :: String -> [(Int, Char)]
numbered s = [ (b, a) | a <- s | b <- [1..] ]
-- main = print (numbered "abc")  -- [(1,'a'),(2,'b'),(3,'c')]
-- main = print (numbered "")  -- []


-- >>> ТЕОРИЯ: собрать строку из символов
--   Символ пишется в одинарных кавычках: 'a'. Строка — в двойных: "a".
--   Из двух символов можно собрать строку как список:  [c1, c2]
--       ['o', 'k']  == "ok"
--   В comprehension результатом может быть что угодно, и строка тоже:
--       [[c, '!'] | c <- "ab"]   == ["a!","b!"]
--
-- A3. Склей буквы двух строк попарно в строки из двух букв.
twoLetters :: String -> String -> [String]
twoLetters s1 s2 = [ [a, b] | a <- s1 | b <- s2 ]
-- main = print (twoLetters "abc" "xyz")  -- ["ax","by","cz"]
-- main = print (twoLetters "hello" "HI")  -- ["hH","eI"]


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: if внутри выражения
--   В Haskell if — это выражение, у него ВСЕГДА есть else:
--       if 5 > 3 then "yes" else "no"   == "yes"
--   Его можно ставить слева от | в comprehension:
--       [if x > 0 then x else 0 | x <- [3,-1,2]]   == [3,0,2]
--   (можно и функцией max:  max 3 7 == 7)
--
-- B1. Для каждой позиции возьми больший из двух элементов.
maxEach :: [Int] -> [Int] -> [Int]
maxEach l1 l2 = [ if a > b then a else b | a <- l1 | b <- l2 ]
-- main = print (maxEach [1,5,3] [4,2,6])  -- [4,5,6]
-- main = print (maxEach [-1,-2] [-3,0,9])  -- [-1,0]


-- >>> ТЕОРИЯ: ЛОВУШКА — условие в параллельном генераторе
--   Каждая ветка между | живёт СВОЕЙ жизнью. Условие после запятой
--   относится только к своей ветке и видит только её переменные:
--       [x + y | x <- [1,2,3,4], even x | y <- [10,20,30]]
--     ветка 1: x <- [1,2,3,4], even x   даёт  2,4
--     ветка 2: y <- [10,20,30]          даёт  10,20,30
--     результат: [2+10, 4+20] == [12,24]
--   Поэтому условие "x == y" (на ОБЕ переменные) так написать НЕЛЬЗЯ:
--   во второй ветке x не виден. Делай так:
--     (1) сначала построй список, а потом фильтруй снаружи:
--         length (filter (== True) [x == y | x <- xs | y <- ys])
--     (2) или считай через if:   sum [if x == y then 1 else 0 | x <- xs | y <- ys]
--
-- B2. Сколько позиций, на которых в двух строках стоит одна и та же буква?
countSame :: String -> String -> Int
countSame s1 s2 = length (filter ( == True ) [ x == y | x <- s1 | y <- s2])
-- main = print (countSame "abcd" "abed")  -- 3
-- main = print (countSame "haskell" "pascal")  -- 3
-- main = print (countSame "" "abc")  -- 0


-- >>> ТЕОРИЯ: арифметические последовательности и take
--   [3,6..]    == 3,6,9,12,...   (шаг задаётся двумя первыми числами, без конца)
--   [5,10..20] == [5,10,15,20]
--   take n список — первые n элементов:   take 3 [3,6..] == [3,6,9]
--   Хватит обрезать ОДНУ ветку: вторая бесконечная ветка остановится сама.
--       [(x,y) | x <- take 2 [1..] | y <- [100..]]   == [(1,100),(2,101)]
--
-- B3. Первые n кратных числа a в паре с кратными числа b.
--   multiplesPairs 3 2 7 == [(2,7),(4,14),(6,21)]
multiplesPairs :: Int -> Int -> Int -> [(Int, Int)]
multiplesPairs n a b = take n [ (a * n, b * n) | n <- [1..] ]
-- main = print (multiplesPairs 3 2 7)  -- [(2,7),(4,14),(6,21)]
-- main = print (multiplesPairs 0 2 7)  -- []
-- main = print (multiplesPairs 4 10 1)  -- [(10,1),(20,2),(30,3),(40,4)]


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ (задачи из sample)
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: диапазоны букв
--   ['a'..'e'] == "abcde"         ['A'..'Z'] — все заглавные
--   Это та же запись, что [1..5], только для символов.
--   Похожий приём — B3: одну ветку режем через take n.
--
-- C1 (endterm4 #1). You are given a number n.
--   Use a parallel generator to pair up the first n matching
--   Uppercase and Lowercase letters.
--   Example: gen1 3 = [('A','a'),('B','b'),('C','c')]
gen1 :: Int -> [(Char, Char)]
gen1 n = take n [ (a, b) | a <- ['A'..] | b <- ['a'..]]
-- main = print (gen1 0)  -- []
-- main = print (gen1 3)  -- [('A','a'),('B','b'),('C','c')]
-- main = print (gen1 8)  -- [('A','a'),('B','b'),('C','c'),('D','d'),('E','e'),('F','f'),('G','g'),('H','h')]


-- >>> ТЕОРИЯ: сумма результата
--   sum [список] — сумма. Сначала строим список произведений, потом sum:
--       sum [x * y | x <- [1,2] | y <- [3,4]]  == 1*3 + 2*4 == 11
--
-- C2 (endterm3 #1). Write a function which takes 2 lists of integers of the
--   same length, and calculates the dot product of these two vectors.
--   A dot product is the sum of the products of the corresponding entries.
--   Parallel list comprehension must be used.
dotProd :: [Int] -> [Int] -> Int
dotProd l1 l2 = sum [ a * b | a <- l1 | b <- l2 ]
-- main = print (dotProd [1, 2, 3] [4, 5, 6])  -- 32
-- main = print (dotProd [-1, -2, -3] [4, -5, 6])  -- -12
-- main = print (dotProd [0, 0, 0] [1, 2, 3])  -- 0
-- main = print (dotProd [7] [3])  -- 21
-- main = print (dotProd [1, 2, 3, 4, 5] [6, 7, 8, 9, 10])  -- 130


-- >>> ТЕОРИЯ: три списка сразу
--   Веток может быть сколько угодно, каждая через |
--       [a + b + c | a <- [1,2] | b <- [10,20] | c <- [100,200]]  == [111,222]
--   Длина ответа = длина самого короткого из трёх.
--
-- C3 (endterm1 #1). Write a function which takes 3 lists of integers v1, v2
--   and v3, multiply v2 and v3 then add the result to v1.
--   Parallel list comprehension must be used.
mulAdA :: [Int] -> [Int] -> [Int] -> [Int]
mulAdA l1 l2 l3 = [ a * b + c | a <- l2 | b <- l3 | c <- l1]
-- main = print (mulAdA [1, 2, 3] [4, 5, 6] [7, 8, 9])  -- [29,42,57]
-- main = print (mulAdA [1, 0, 3] [4, 0, 6] [7, 8, 0])  -- [29,0,3]
-- main = print (mulAdA [1, -2, 3] [-4, 5, -6] [7, -8, 9])  -- [-27,-42,-51]
-- main = print (mulAdA [0, 0, 0] [0, 0, 0] [0, 0, 0])  -- [0,0,0]
-- main = print (mulAdA [1, 2] [3, 4, 5] [6, 7, 8])  -- [19,30]


-- >>> ТЕОРИЯ: это B3 почти без изменений
--   Кратные 3:  [3,6..]       Кратные 5:  [5,10..]
--   Первые n берём через take n в одной из веток.
--
-- C4 (endterm2 #2). You are given a number n.
--   Use a parallel generator to pair up the first n numbers
--   divisible by 3 with the ones divisible by 5.
gen2 :: Int -> [(Int, Int)]
gen2 n = take n [ (a,b) | a <- [3,6..] , b <- [5,10..]]
-- main = print (gen2 0)  -- []
-- main = print (gen2 3)  -- [(3,5),(6,10),(9,15)]
-- main = print (gen2 8)  -- [(3,5),(6,10),(9,15),(12,20),(15,25),(18,30),(21,35),(24,40)]


-- >>> ТЕОРИЯ: образец-кортеж слева от <-
--   Если список состоит из пар, пару можно сразу разобрать на части:
--       [x + y | (x, y) <- [(1,2),(3,4)]]   == [3,7]
--   В параллельном генераторе так же, в каждой ветке свой образец:
--       [(a, d) | (a, b) <- [(1,2)] | (c, d) <- [(5,6)]]  == [(1,6)]
--
-- C5 (endterm4 #2). Write a function which takes a list of points (x, y)
--   and a list of motion vectors (dx, dy), and shift all the points by the
--   corresponding motion vector.
--   Parallel list comprehension must be used.
shiftPoints :: [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
shiftPoints l1 l2 = [ (x1 + x2 , y1 + y2) | (x1, y1) <- l1 | (x2, y2) <- l2]
-- main = print (shiftPoints [(1, 2), (3, 4), (5, 6)] [(1, 1), (2, 2), (3, 3)])  -- [(2,3),(5,6),(8,9)]
-- main = print (shiftPoints [(1, 2), (3, 4), (5, 6)] [(-1, -1), (-2, -2), (-3, -3)])  -- [(0,1),(1,2),(2,3)]
-- main = print (shiftPoints [(1, 2), (3, 4), (5, 6)] [(0, 0), (0, 0), (0, 0)])  -- [(1,2),(3,4),(5,6)]
-- main = print (shiftPoints [(1, 2), (3, 4), (5, 6)] [(1, -1), (-2, 2), (3, -3)])  -- [(2,1),(1,6),(8,3)]
-- main = print (shiftPoints [(1, 2), (3, 4)] [(1, 1)])  -- [(2,3)]


-- >>> ТЕОРИЯ: функция как аргумент + тройки
--   Аргументом может быть функция. В типе она пишется в скобках:
--       apply :: (Int -> Int -> Int) -> Int -> Int -> Int
--       apply f a b = f a b
--       apply (+) 2 3 == 5        apply (\x y -> x * y) 2 3 == 6
--   (\x y -> ...) — это лямбда, функция без имени.
--   Кортеж из трёх элементов пишется так же, как пара:  (x, y, z)
--
-- C6 (endterm2 #1). Generate a list of tuples (x, y, f(x, y)), where
--   x is taken from list1, y is taken from list2, and f is given as an input.
--   Traverse list1 and list2 simultaneously.
--   Parallel list comprehension must be used.
applyFunction :: (Int -> Int -> Int) -> [Int] -> [Int] -> [(Int, Int, Int)]
applyFunction f l1 l2 = [ (x, y, (f x y)) | x <- l1 | y <- l2 ]
-- main = print (applyFunction (\x y -> x^2 + 2*x*y + y^2) [4,5,6] [1,2,3])  -- [(4,1,25),(5,2,49),(6,3,81)]
-- main = print (applyFunction (\x y -> x `mod` y) [10, 25, 30] [3, 7, 9])  -- [(10,3,1),(25,7,4),(30,9,3)]
-- main = print (applyFunction (\x y -> abs (x - y)) [8, 12, 16] [5, 10, 20])  -- [(8,5,3),(12,10,2),(16,20,4)]


-- >>> ТЕОРИЯ: сравнение символов и && ("и")
--   Строка "1100" — это список символов '1','1','0','0'.
--   Сравниваем с символом:  c == '1'   (одинарные кавычки!)
--   && — логическое И:   True && False == False
--   Пример:  [if a == 'x' && b == 'x' then "both" else "no" | a <- "xx" | b <- "xo"]
--            == ["both","no"]
--
-- C7 (endterm3 #2). We have a bulb, which has 2 switches connected to it
--   serially. Each switch is controlled by a stream of signals, where 1 means
--   on and 0 means off. The bulb is on if both switches are on.
--   Take 2 streams of signals (strings of '0's and '1's) and output the list
--   of states of the bulb over the time ("On" or "Off").
--   Parallel list comprehension must be used.
lightStates :: String -> String -> [String]
lightStates s1 s2 = [ if a == '1' && b == '1' then "On" else "Off" | a <- s1 | b <- s2 ]
-- main = print (lightStates "1100" "1010")  -- ["On","Off","Off","Off"]
-- main = print (lightStates "1111" "1111")  -- ["On","On","On","On"]
-- main = print (lightStates "0000" "1111")  -- ["Off","Off","Off","Off"]
-- main = print (lightStates "1010" "0101")  -- ["Off","Off","Off","Off"]


-- >>> ТЕОРИЯ: разбор пары (число, Bool) + if
--   Каждый элемент — пара. Разбираем сразу:  (a, p) <- xs   и   (b, q) <- ys
--   p и q имеют тип Bool, их можно ставить прямо в if:
--       if p && q then a + b else a - b
--   Получили список чисел — осталось sum.
--   Разбор примера: (1,True)(3,True) -> 4;  (2,False)(4,True) -> -2;
--                   (6,False)(5,False) -> 1;  сумма 3.
--
-- C8 (endterm1 #3). Take two lists of tuples (Int, Bool).
--   For each pair of tuples at the same index:
--   if the Boolean values in both tuples are True, add the integers;
--   otherwise subtract the integer of the second tuple from the first.
--   Return the sum of all these computed values.
--   Parallel list comprehension must be used.
processTuples :: [(Int, Bool)] -> [(Int, Bool)] -> Int
processTuples l1 l2 = sum [ if b1 && b2 then i1 + i2 else (i1 - i2) | (i1, b1) <- l1 | (i2, b2) <- l2 ]
-- main = print (processTuples [(1, True), (2, False), (6, False)] [(3, True), (4, True), (5, False)])  -- 3
-- main = print (processTuples [(4, True), (7, True), (1, False)] [(2, True), (5, False), (3, True)])  -- 6
-- main = print (processTuples [(0, False), (10, True), (8, False)] [(5, False), (3, True), (2, False)])  -- 14
-- main = print (processTuples [(1, True), (3, False), (5, False)] [(1, True), (3, False), (5, True)])  -- 2


-- >>> ТЕОРИЯ: пара из двух списков + условие в ветке
--   Ответ — ПАРА списков. Строим каждый отдельно и кладём в скобки:
--       ( [ ...первый список... ] , [ ...второй список... ] )
--   Удобно через where:
--       f xs ys = (prods, divs)
--         where prods = [ ... ]
--               divs  = [ ... ]
--   Деление Double: оператор /  (3.0 / 4.0 == 0.75). На 0 делить "не определено".
--
--   ВАЖНО: посмотри на 2-й тест. [1,2,3,4] делится на [0,0,0,2,0,3,4,5,6]
--   и получается [1/2, 2/3, 3/4, 4/5]. То есть нули из ВТОРОГО списка
--   просто выкидываются, а потом списки идут параллельно.
--   Это ровно то, что делает условие в ветке (см. ЛОВУШКУ перед B2):
--       [x / y | x <- xs | y <- ys, y /= 0]
--   ветка 2 сначала выкидывает нули, потом идёт параллельно с xs.
--   ( /= значит "не равно" )
--
-- C9 (endterm1 #2). Take two lists of numbers and produce a tuple of two lists:
--   a. each element is the product of corresponding elements from the inputs.
--   b. each element is the division (if defined) of corresponding elements.
--   If the lists are of different lengths, process only up to the shorter one.
--   Parallel list comprehension must be used.
elementWise :: [Double] -> [Double] -> ([Double], [Double])
elementWise l1 l2 = (prods, divs)
    where 
        prods = [ a * b | a <- l1 | b <- l2]
        divs = [ a / b | a <- l1 | b <- l2, b /= 0]
-- main = print (elementWise [1.0, 2.0, 3.0] [4.0, 5.0, 6.0])  -- ([4.0,10.0,18.0],[0.25,0.4,0.5])
-- main = print (elementWise [1.0, 2.0, 3.0, 4.0] [0.0, 0.0, 0.0, 2.0, 0.0, 3.0, 4.0, 5.0, 6.0])  -- ([0.0,0.0,0.0,8.0],[0.5,0.6666666666666666,0.75,0.8])
-- main = print (elementWise [] [1.0, 2.0, 3.0])  -- ([],[])
