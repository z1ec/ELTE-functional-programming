-- ============================================================================
-- 06. РЕКУРСИЯ ПО СПИСКАМ И ОБРАЗЦЫ  (x:xs, x:y:rest, span, group)
-- ============================================================================
-- Тренажёр. Решения: ../solutions/06_list_recursion.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 06_list_recursion.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 06_list_recursion.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #3, midterm4 #3, midterm5 #1, midterm5 #3, midterm6 #3

import Data.List (group, inits, tails)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Образцы (patterns) для списков — проверяются СВЕРХУ ВНИЗ:
--     f []         = ...   -- пустой
--     f [x]        = ...   -- ровно один элемент
--     f (x:xs)     = ...   -- голова x и хвост xs
--     f (x:y:rest) = ...   -- минимум два элемента
--     f (a:b:c:rest) = ... -- минимум три
--   Поэтому более КОНКРЕТНЫЕ образцы пиши ВЫШЕ общих.
--
-- Образец + условие (guard):
--     f (c:a:b:rest) | c == 'K' = ...
--     f (c:rest)                = c : f rest
--
-- "Продолжить обработку с результата": кладём результат шага обратно на вход
--     f ('X':c:rest) = f (c:rest)        -- c ещё раз пройдёт через f
--   против "результат уже готов":
--     f ('X':c:rest) = c : f rest        -- c больше не обрабатывается
--
-- Строим ответ через (:) и рекурсию:
--     myMap f []     = []
--     myMap f (x:xs) = f x : myMap f xs
--
-- span / break / takeWhile / dropWhile:
--     takeWhile (== 1) [1,1,2,1] == [1,1]
--     dropWhile (== 1) [1,1,2,1] == [2,1]
--     span (== 1) [1,1,2,1]      == ([1,1],[2,1])    -- оба сразу
--     break (== ',') "ab,cd"     == ("ab",",cd")     -- до первого совпадения
--
-- Готовые из Data.List:
--     group [1,1,2,3,3] == [[1,1],[2],[3,3]]
--     inits [1,2,3]     == [[],[1],[1,2],[1,2,3]]
--     tails [1,2,3]     == [[1,2,3],[2,3],[3],[]]
--   На экзамене часто можно использовать их, но полезно уметь и руками.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: образцы [] и (x:xs)
--   Любой список — либо пустой [], либо "голова : хвост" (x:xs):
--       [1,2,3] == 1 : [2,3]       ->  x = 1,  xs = [2,3]
--   Функция по спискам — почти всегда две строки:
--       f []     = <ответ для пустого>
--       f (x:xs) = <что-то с x> и рекурсивно f xs
--   ПРИМЕР, сумма:
--       mySum []     = 0
--       mySum (x:xs) = x + mySum xs
--   Для длины сам x не нужен (каждый элемент просто даёт +1), поэтому пиши _ :
--       myLength (_:xs) = ...
--
-- A1. Длина списка рекурсией (без length).
myLength :: [a] -> Int
myLength = undefined
-- main = print (myLength "hello")  -- 5
-- main = print (myLength [])  -- 0

-- >>> ТЕОРИЯ: образец [x] — ровно один элемент
--   [x] — список из ОДНОГО элемента. Порядок строк важен:
--       myLast []     = error ...
--       myLast [x]    = x            -- остался один, он и последний
--       myLast (_:xs) = myLast xs    -- иначе выкидываем первый
--   Если поставить (_:xs) выше [x], до строки [x] дело не дойдёт.
--
-- A2. Последний элемент. Для пустого — error "empty list".
myLast :: [a] -> a
myLast = undefined
-- main = print (myLast [1,2,3])  -- 3
-- main = print (myLast "")  -- error: empty list

-- >>> ТЕОРИЯ: образец (x:_:rest) — "минимум два элемента"
--   (x:y:rest): x первый, y второй, rest остальное:   [1,2,3,4] -> x=1, y=2, rest=[3,4]
--   Если второй не нужен, пиши _ :  (x:_:rest).
--   Взять первый, пропустить второй, продолжить с rest:
--       everyOther (x:_:rest) = x : everyOther rest
--   Если остались 0 или 1 элемент, вернуть как есть: вторая строка  everyOther xs = xs.
--
-- A3. Элементы на позициях 0, 2, 4, ... (образец x:_:rest).
everyOther :: [a] -> [a]
everyOther = undefined
-- main = print (everyOther [1..7])  -- [1,3,5,7]
-- main = print (everyOther "abcd")  -- "ac"

-- >>> ТЕОРИЯ: то же, что A3, но берём оба
--   (x:y:rest) -> y : x : (рекурсия по rest).       y : x : r  ==  [y, x] ++ r
--
-- A4. Поменять местами соседей попарно.
swapPairs :: [a] -> [a]
swapPairs = undefined
-- main = print (swapPairs [1,2,3,4,5])  -- [2,1,4,3,5]

-- >>> ТЕОРИЯ: функция-аргумент + guards в рекурсии
--   p — функция типа a -> Bool, её вызывают как обычно:  p x
--   Шаг: если p x, оставить x и продолжить; иначе СТОП (вернуть []).
--       myTakeWhile p (x:xs)
--         | p x       = x : ...
--         | otherwise = []
--
-- A5. Свой takeWhile.
myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile = undefined
-- main = print (myTakeWhile even [2,4,5,6])  -- [2,4]

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: сравнение соседей через (x:y:rest) и возврат y обратно
--   Смотрим на первые два:
--     x == y  ->  x лишний, продолжаем с (y:rest)      -- y ещё нужно сравнить со следующим!
--     иначе   ->  x : (продолжаем с (y:rest))
--   ВАЖНО: в рекурсию передаём (y:rest), а не rest, иначе y пропустит проверку.
--   Если остался 0 или 1 элемент, вернуть как есть.
--
-- B1. Убрать подряд идущие повторы (оставить по одному).
compress :: [Int] -> [Int]
compress = undefined
-- main = print (compress [1,1,2,3,3,1])  -- [1,2,3,1]
-- main = print (compress [])  -- []

-- >>> ТЕОРИЯ: span, разбор пары в where
--   span p xs режет список на пару (начало, где p верно; остаток):
--       span (== 'a') "aaabcc" == ("aaa","bcc")
--       span even [2,4,5,6]    == ([2,4],[5,6])
--   Пару можно разобрать в where:
--       where (same, others) = span (== c) rest
--   ПЛАН: первый символ c; same — такие же символы сразу за ним;
--         ответ  (c, 1 + length same) : runLength others
--
-- B2. Кодирование длин серий через span.
runLength :: String -> [(Char, Int)]
runLength = undefined
-- main = print (runLength "aaabcc")  -- [('a',3),('b',1),('c',2)]

-- >>> ТЕОРИЯ: рекурсия, которая возвращает список списков
--   В строке  suffixes (x:xs) = ...  весь список — это (x:xs).
--   suffixes (x:xs) = (весь список) : suffixes xs;    suffixes [] = []
--
-- B3. Все непустые суффиксы рекурсией.
suffixes :: [a] -> [[a]]
suffixes = undefined
-- main = print (suffixes [1,2,3])  -- [[1,2,3],[2,3],[3]]

-- >>> ТЕОРИЯ: образец с конкретным символом
--   В образце можно писать конкретные значения:  f ('X':c:rest) = ...
--   (сработает, только если первый символ 'X' и после него есть ещё символ)
--   Строки пробуются сверху вниз:
--       dupAfterX ('X':c:rest) = c : c : dupAfterX rest   -- обработали, идём ДАЛЬШЕ
--       dupAfterX (c:rest)     = c : dupAfterX rest       -- обычный символ
--       dupAfterX []           = []
--   "XXa": первые 'X','X' дают "XX", дальше "a", итого "XXa".
--
-- B4. 'X' и следующий за ним символ c заменить на c c (удвоить c).
-- Удвоенные символы больше НЕ обрабатываются. 'X' в конце остаётся.
dupAfterX :: String -> String
dupAfterX = undefined
-- main = print (dupAfterX "aXbc")  -- "abbc"
-- main = print (dupAfterX "XXa")  -- "XXa"
-- main = print (dupAfterX "abX")  -- "abX"

-- >>> ТЕОРИЯ: "продолжить обработку с результата"
--   Разница с B4: результат кладём ОБРАТНО на вход рекурсии:
--       collapseX ('X':c:rest) = collapseX (c:rest)    -- c ещё раз пройдёт проверку
--   "XXa":  'X','X',"a"  ->  collapseX "Xa"  ->  'X','a',""  ->  collapseX "a"  ->  "a"
--   Это главная идея для C3 и C4!
--
-- B5. 'X' и следующий символ c заменить на c, и ПРОДОЛЖИТЬ обработку с c
-- (то есть c сам может оказаться 'X'). 'X' в конце остаётся.
collapseX :: String -> String
collapseX = undefined
-- main = print (collapseX "aXb")  -- "ab"
-- main = print (collapseX "XXa")  -- "a"
-- main = print (collapseX "aX")  -- "aX"

-- >>> ТЕОРИЯ: break и case
--   break p xs — как span, но режет на ПЕРВОМ элементе, где p верно:
--       break (== ',') "ab,cd" == ("ab",",cd")
--       break (== ',') "abc"   == ("abc","")
--   case разбирает значение по образцам прямо внутри выражения:
--       case break (== ',') s of
--         (part, [])       -> ...     -- разделителей больше нет
--         (part, _ : rest) -> ...     -- _ — сам разделитель, rest — то, что после него
--   ПЛАН: нет разделителя -> [part];   есть -> part : splitOn d rest
--
-- B6. Разбить строку по разделителю (через break).
splitOn :: Char -> String -> [String]
splitOn = undefined
-- main = print (splitOn ',' "a,b,,c")  -- ["a","b","","c"]
-- main = print (splitOn ',' "abc")  -- ["abc"]

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: take и генератор по длинам
--   take k xs — первые k элементов:   take 2 [1,2,3] == [1,2]
--   Префиксы длины 1, 2, ..., length xs:   [take k xs | k <- [1..length xs]]
--   (Ещё вариант: inits [1,2,3] == [[],[1],[1,2],[1,2,3]], и убрать первый [] через tail.)
--
-- C1. [midterm1 #3]
-- Write a function prefixes that takes a list and returns
-- a list of all prefixes of the original list.  [1,2,3] -> [[1],[1,2],[1,2,3]]
-- (В sample для "abc" написано [["a"],...] — на самом деле это ["a","ab","abc"].)
-- Подсказка: tail (inits xs)  или  [take k xs | k <- [1..length xs]].
prefixes :: [a] -> [[a]]
prefixes = undefined
-- main = print (prefixes [1, 2, 3])  -- [[1],[1,2],[1,2,3]]
-- main = print (prefixes "abc")  -- ["a","ab","abc"]
-- main = print (prefixes [42, 43])  -- [[42],[42,43]]
-- main = print (prefixes [5])  -- [[5]]

-- >>> ТЕОРИЯ к C2: это B2, только в ответ кладём саму группу
--   Первый x; same = span (== x) от хвоста; группа = x : same; дальше рекурсия по остатку.
--   [1,2,2,3]:  x=1, same=[] -> группа [1];  потом [2,2,3]: x=2, same=[2] -> группа [2,2];  ...
--
-- C2. [midterm4 #3] = [midterm5 #1]
-- Write a function that groups consecutive duplicate elements together.
-- [1,2,2,3,3,3,4] -> [[1],[2,2],[3,3,3],[4]]
-- Сделай руками через span (group из Data.List делает то же самое).
-- (В midterm4 последний тест в sample ошибочный: [1,1,2,2,3,4,3,4] даёт
--  [[1,1],[2,2],[3],[4],[3],[4]], а не [[1,1],[2,2],[3,3],[4,4]].)
groupConsecutive :: [Int] -> [[Int]]
groupConsecutive = undefined
-- main = print (groupConsecutive [1, 2, 2, 3, 3, 3, 4])  -- [[1],[2,2],[3,3,3],[4]]
-- main = print (groupConsecutive [5, 5, 5, 5])  -- [[5,5,5,5]]
-- main = print (groupConsecutive [1, 2, 3, 4])  -- [[1],[2],[3],[4]]
-- main = print (groupConsecutive [1, 1, 2, 2, 3, 4, 3, 4])  -- [[1,1],[2,2],[3],[4],[3],[4]]
-- main = print (groupConsecutive [1,1,2,3,3,3,4,5,5])  -- [[1,1],[2],[3,3,3],[4],[5,5]]
-- main = print (groupConsecutive [10,10,10,20,30,30])  -- [[10,10,10],[20],[30,30]]
-- main = print (groupConsecutive [])  -- []

-- >>> ТЕОРИЯ к C3: это B5, только после K съедаем ДВА символа
--   Образец "минимум 3 символа" плюс guard на K/k:
--       computeK (k:a:_:rest) | k `elem` "Kk" = computeK (a:rest)
--   a кладём обратно на вход (как в B5): вдруг это тоже K.
--   Остальные строки — как в B4/B5: обычный символ и [].
--   Если guard не прошёл (первый символ не K), Haskell переходит к следующей строке.
--
-- C3. [midterm5 #3]
-- 'K' and 'k' are special characters in the string: whenever there are two more
-- characters after them, replace the three by the first character after 'K'/'k';
-- if more special letters, use them to continue processing the string.
-- "Kab" = "a",  "KKa" = "K",  "KKguKabc" -> "KuKabc" -> "uabc"
-- If there is only one character or no character after 'K', 'K' stays there.
-- Подсказка: это B5, только съедаем ДВА символа после K.
computeK :: String -> String
computeK = undefined
-- main = print (computeK "Kg")  -- "Kg"
-- main = print (computeK "Kfg")  -- "f"
-- main = print (computeK "Kfgksa")  -- "fs"
-- main = print (computeK "sfguKfg")  -- "sfguf"
-- main = print (computeK "KKguKabc")  -- "uabc"
-- main = print (computeK "KukacosKalma")  -- "uacosama"

-- >>> ТЕОРИЯ к C4: как C3, только 4 символа и формула
--   Образец (s:a:b:c:rest), где s — 'S' или 's'. Вместо "Sabc" получается "acbc",
--   и обработка продолжается с результата:  computeS (a:c:b:c:rest)
--   "Sfgu":  a='f', b='g', c='u'  ->  "fugu"
--
-- C4. [midterm6 #3]
-- 'S' and 's' are special: whenever there are three more characters after 'S'/'s',
-- replace them using this formula: "Sabc" = "acbc".
-- If more special letters follow each other, use them to continue processing.
-- If the number of characters after 'S'/'s' is less than 3, no changes applied.
computeS :: String -> String
computeS = undefined
-- main = print (computeS "Sgu")  -- "Sgu"
-- main = print (computeS "Sfgu")  -- "fugu"
-- main = print (computeS "cSguka")  -- "cgkuka"
-- main = print (computeS "SSguSab")  -- "uuguSab"
-- main = print (computeS "sfguSfguxyzSfguSfgu")  -- "fugufuguxyzfugufugu"
