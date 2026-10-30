-- ============================================================================
-- 01. ЦИФРЫ ЧИСЛА  (div / mod / show)
-- ============================================================================
-- Тренажёр. Решения: ../solutions/01_digits.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 01_digits.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 01_digits.hs, потом пиши выражение (например  countOdds 1234),
--             после правок в файле — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm1 #1, midterm2 #1, midterm2 #4, midterm3 #1, midterm3 #3, midterm4 #1

import Data.Char (digitToInt)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- Последняя цифра и "число без последней цифры":
--     1234 `mod` 10  == 4
--     1234 `div` 10  == 123
--
-- ОСТОРОЖНО с отрицательными: div/mod округляют вниз
--     (-7) `div` 2 == -4      (-7) `mod` 2 == 1      (-56) `mod` 10 == 4  (!)
-- Поэтому перед разбором цифр бери  abs n.
--
-- Рекурсивная схема "пройти по всем цифрам":
--     f 0 = <база>
--     f n = <что-то с (n `mod` 10)>  `op`  f (n `div` 10)
--   пример — сумма цифр:
--     sumD 0 = 0
--     sumD n = n `mod` 10 + sumD (n `div` 10)
--
-- Получить СПИСОК цифр — и дальше работать обычными map/filter/sum:
--   (1) рекурсией:  digits n | n < 10    = [n]
--                            | otherwise = digits (n `div` 10) ++ [n `mod` 10]
--   (2) через show (проще всего!):
--         show 1234                    == "1234"
--         map digitToInt (show 1234)   == [1,2,3,4]      -- import Data.Char
--
-- Обратно: список цифр -> число
--     foldl (\acc d -> acc * 10 + d) 0 [5,7,2]  == 572
--     (0*10+5 = 5,  5*10+7 = 57,  57*10+2 = 572)
--
-- Другая система счисления — тот же приём, только 2 вместо 10:
--     6 `mod` 2 = 0, 3 `mod` 2 = 1, 1 `mod` 2 = 1   -> 6 = 110 (читаем снизу вверх)
--
-- Ошибка вместо ответа (тип функции при этом не меняется!):
--     f n | n < 0     = error "Negative number error"
--         | otherwise = ...
--
-- Полезное: even, odd, (^) — степень, sum, product, length, filter, map.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: как записать функцию, mod, abs
--   Функция:   имя аргумент = выражение
--       double x = x * 2              -- double 5 == 10
--   `mod` — остаток от деления. Обратные кавычки превращают функцию в оператор:
--       1234 `mod` 10 == 4            -- то же самое, что  mod 1234 10
--   Остаток от деления на 10 = последняя цифра.
--   ЛОВУШКА: для отрицательных mod считает "не по-школьному":
--       (-56) `mod` 10 == 4           -- а не 6!
--   Поэтому сначала убираем знак: abs (-56) == 56.
--   Вызов функции связывает сильнее операторов:
--       abs n `mod` 10   означает   (abs n) `mod` 10
--
-- A1. Последняя цифра числа (знак игнорируем).
lastDigit :: Int -> Int
lastDigit n = abs n `mod` 10
-- main = print (lastDigit 1234)  -- 4
-- main = print (lastDigit 7)  -- 7
-- main = print (lastDigit (-56))  -- 6

-- >>> ТЕОРИЯ: div
--   `div` — целочисленное деление, дробная часть отбрасывается:
--       1234 `div` 10 == 123       7 `div` 10 == 0       17 `div` 5 == 3
--   Деление на 10 "отрезает" последнюю цифру.
--   (Обычное / для Int не работает: это деление для Double.)
--
-- A2. Число без последней цифры.
dropLastDigit :: Int -> Int
dropLastDigit n = n `div` 10
-- main = print (dropLastDigit 1234)  -- 123
-- main = print (dropLastDigit 7)  -- 0

-- >>> ТЕОРИЯ: guards (|), рекурсия, списки, ++, negate
--   Guards — это "если ... то ..." построчно. Проверяются СВЕРХУ ВНИЗ:
--       sign n
--         | n < 0     = -1
--         | n == 0    = 0
--         | otherwise = 1            -- otherwise = "во всех остальных случаях"
--   Рекурсия — функция вызывает саму себя на МЕНЬШЕМ аргументе,
--   пока не дойдёт до базового случая, где ответ известен сразу.
--   Списки:  [1,2,3];   [n] — список из одного элемента n.
--       [1,2] ++ [3] == [1,2,3]      -- ++ склеивает ДВА СПИСКА,
--                                    -- поэтому [n `mod` 10], а не n `mod` 10
--   Как раскрывается digits 1234:
--       digits 1234 = digits 123 ++ [4]
--                   = (digits 12 ++ [3]) ++ [4]
--                   = ((digits 1 ++ [2]) ++ [3]) ++ [4]
--                   = [1] ++ [2] ++ [3] ++ [4]     -- digits 1 = [1]: число < 10 — одна цифра
--   negate меняет знак: negate (-56) == 56.
--   ПЛАН (три guard'а):
--       n < 0      -> digits (negate n)                 -- проверь digits (-56) == [5,6]
--       n < 10     -> [n]
--       otherwise  -> digits (n без последней цифры) ++ [последняя цифра]
--
-- A3. Список цифр числа РЕКУРСИЕЙ через div/mod (знак игнорируем). digits 0 == [0].
digits :: Int -> [Int]
digits n
    | abs n < 10 = [n]
    | otherwise = digits (abs n `div` 10) ++ [abs n `mod` 10]
-- main = print (digits 1234)  -- [1,2,3,4]
-- main = print (digits 0)  -- [0]
-- main = print (digits (-56))  -- [5,6]

-- >>> ТЕОРИЯ: show, map, digitToInt
--   show превращает значение в строку:  show 1234 == "1234"
--   Строка — это список символов: "1234" == ['1','2','3','4']
--   digitToInt (из Data.Char, уже импортирован наверху) превращает символ-цифру в число:
--       digitToInt '7' == 7
--   map f xs применяет f к КАЖДОМУ элементу списка:
--       map (* 2) [1,2,3]          == [2,4,6]
--       map digitToInt ['4','2']   == [4,2]
--   Знак: show (-905) == "-905", а digitToInt '-' упадёт. Поэтому  show (abs n).
--
-- A4. То же самое, но через show и digitToInt.
digitsShow :: Int -> [Int]
digitsShow n = map digitToInt (show (abs n))
-- main = print (digitsShow 1234)  -- [1,2,3,4]
-- main = print (digitsShow (-905))  -- [9,0,5]

-- >>> ТЕОРИЯ: sum и повторное использование своих функций
--   sum [1,2,3] == 6,   sum [] == 0
--   Ты уже написал digits, и его можно вызывать в других функциях.
--   Почти все задачи дальше устроены так: digits n, а потом обработать список.
--       sumDigits n = sum (digits n)
--   Можно и рекурсией без списка (но тогда не забудь abs для отрицательных):
--       sumD 0 = 0
--       sumD n = n `mod` 10 + sumD (n `div` 10)
--
-- A5. Сумма цифр.
sumDigits :: Int -> Int
sumDigits n
    | n < 10 = n
    | otherwise = abs n `mod` 10 + (sumDigits ((abs n) `div` 10))
-- main = print (sumDigits 1234)  -- 10
-- main = print (sumDigits 0)  -- 0

-- >>> ТЕОРИЯ: length
--   length [7,8,9] == 3        length "abc" == 3
--   Варианты:  length (digits n)   или   length (show (abs n))
--   digits 0 == [0], значит у 0 одна цифра.
--
-- A6. Количество цифр.
countDigits :: Int -> Int
countDigits = length . show . abs
-- main = print (countDigits 12345)  -- 5
-- main = print (countDigits 0)  -- 1

-- >>> ТЕОРИЯ: foldl — проход по списку с накопителем
--   foldl f start xs: накопитель acc сначала равен start, потом элементы списка
--   по очереди, СЛЕВА НАПРАВО, "скармливаются" функции f:
--       новый acc = f старый_acc x
--   То есть  foldl f 0 [5,7,2] = f (f (f 0 5) 7) 2.
--   f обычно пишут лямбдой:  \acc x -> ...
--   (\ читается "лямбда" — это функция без имени: (\x -> x + 1) 5 == 6)
--   ПРИМЕР 1, сумма:  foldl (\acc x -> acc + x) 0 [1,2,3]
--       acc = 0  ->  0+1 = 1  ->  1+2 = 3  ->  3+3 = 6           ответ 6
--   ПРИМЕР 2, число из цифр [5,7,2]: на каждом шаге "сдвигаем влево и дописываем цифру":
--       acc = 0  ->  0*10+5 = 5  ->  5*10+7 = 57  ->  57*10+2 = 572
--   Пустой список: foldl сразу возвращает start, то есть 0, как и просит задача.
--
-- A7. Из списка цифр обратно в число. Пустой список -> 0.
fromDigits :: [Int] -> Int
fromDigits n = foldl (\acc i -> acc * 10 + i) 0 n
-- main = print (fromDigits [5,7])  -- 57
-- main = print (fromDigits [1,0,0])  -- 100
-- main = print (fromDigits [])  -- 0

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: product
--   product [2,3,4] == 24,   product [] == 1
--   Ровно как sumDigits, только product вместо sum.
--   Если пишешь рекурсией, база для произведения — 1, а не 0!
--   Проверь 105: цифра 0 должна дать 0.
--
-- B1. Произведение цифр.
productDigits :: Int -> Int
productDigits x
    | x < 10 = x
    | otherwise = (x `mod` 10) * productDigits (x `div` 10)
-- main = print (productDigits 234)  -- 24
-- main = print (productDigits 105)  -- 0

-- >>> ТЕОРИЯ: filter, even/odd, вложенные вызовы
--   even x — True, если x чётное:  even 4 == True,  even 7 == False
--   odd x  — наоборот:             odd 7 == True
--   filter p xs оставляет ТОЛЬКО те элементы, для которых p x == True:
--       filter even [1,2,3,4]  == [2,4]
--       filter (> 2) [1,5,2,7] == [5,7]          -- (> 2) значит "больше двух"
--   Функции можно вкладывать:  f (g x) — сначала g, потом f к результату.
--   ПОХОЖИЙ ПРИМЕР — сколько цифр больше 5:
--       countBig n = length (filter (> 5) (digits n))
--       countBig 1789:  digits -> [1,7,8,9] -> filter -> [7,8,9] -> length -> 3
--   ПЛАН для B2: цифры -> оставить чётные -> посчитать.
--
-- B2. Сколько чётных цифр.
countEvenDigits :: Int -> Int
countEvenDigits n = length (filter even (digits n))
-- main = print (countEvenDigits 24680)  -- 5
-- main = print (countEvenDigits 135)  -- 0

-- >>> ТЕОРИЯ: reverse, цепочка своих функций
--   reverse [1,2,3] == [3,2,1]
--   ПЛАН: digits -> reverse -> fromDigits (A7).
--       1230 -> [1,2,3,0] -> [0,3,2,1] -> 321
--   Ведущий ноль исчезает сам: fromDigits [0,3,2,1] == 321.
--
-- B3. Перевернуть число.
reverseNumber :: Int -> Int
reverseNumber = fromDigits1 . reverse . digits

fromDigits1 :: [Int] -> Int
fromDigits1 x = foldl (\acc x -> acc * 10 + x) 0 x
-- main = print (reverseNumber 1230)  -- 321
-- main = print (reverseNumber 5)  -- 5

-- >>> ТЕОРИЯ: сравнение списков, Bool без if
--   Списки можно сравнивать целиком:  [1,2,1] == reverse [1,2,1]   даёт True
--   Если ответ Bool, верни само сравнение, if не нужен:
--       isZero n = n == 0        -- а НЕ  if n == 0 then True else False
--   Палиндром: список цифр равен себе перевёрнутому.
--
-- B4. Палиндром ли число?
isPalindromeNumber :: Int -> Bool
isPalindromeNumber xs = (digits xs == reverse (digits xs))
-- main = print (isPalindromeNumber 12321)  -- True
-- main = print (isPalindromeNumber 123)  -- False

-- >>> ТЕОРИЯ: цепочка digits -> filter -> fromDigits
--   Это B2, только в конце вместо length — fromDigits.
--   ПОХОЖИЙ ПРИМЕР — убрать нули:
--       noZeros n = fromDigits (filter (/= 0) (digits n))     -- (/= 0) значит "не равно 0"
--       noZeros 1020 == 12
--   fromDigits [] == 0, поэтому случай "ничего не осталось" работает сам.
--
-- B5. Оставить в числе только чётные цифры. Если не осталось ни одной -> 0.
keepEvenDigits :: Int -> Int
keepEvenDigits n = fromDigits3(filter even (digits3 n))

digits3 :: Int -> [Int]
digits3 n
    | n < 10 = [n]
    | otherwise = digits (n `div` 10) ++ [n `mod` 10]

fromDigits3 :: [Int] -> Int
fromDigits3 n = foldl (\acc x -> acc * 10 + x) 0 n
-- main = print (keepEvenDigits 123456)  -- 246
-- main = print (keepEvenDigits 135)  -- 0

-- >>> ТЕОРИЯ: двоичная запись
--   Как digits (A3), только основание 2 вместо 10:
--       последняя двоичная цифра = n `mod` 2
--       отрезать её              = n `div` 2
--   6:  6 mod 2 = 0, 6 div 2 = 3;   3 mod 2 = 1, 3 div 2 = 1;   1 < 2 -> [1]
--       toBinary 6 = toBinary 3 ++ [0] = (toBinary 1 ++ [1]) ++ [0] = [1,1,0]
--   База: n < 2 -> [n]. Тогда toBinary 0 == [0] и toBinary 1 == [1].
--
-- B6. Двоичная запись числа списком (старший бит первым). toBinary 0 == [0].
toBinary :: Int -> [Int]
toBinary n
    | n == 1 = [1]
    | otherwise = toBinary (n `div` 2) ++ [n `mod` 2]
-- main = print (toBinary 6)  -- [1,1,0]
-- main = print (toBinary 1)  -- [1]
-- main = print (toBinary 55)  -- [1,1,0,1,1,1]

-- >>> ТЕОРИЯ: error
--   error "текст" останавливает программу с сообщением. Его можно подставить ВМЕСТО
--   значения любого типа, поэтому тип функции остаётся Int -> Int:
--       safeDiv a b
--         | b == 0    = error "Division by zero!"
--         | otherwise = a `div` b
--   Сначала guard с ошибкой, потом обычный случай (можно вызвать sumDigits).
--
-- B7. Сумма цифр, но для отрицательного числа — ошибка "Negative!".
safeSumDigits :: Int -> Int
safeSumDigits n
    | n < 0 = error "Negative!"
    | n == 0 = 0
    | otherwise = n `mod` 10 + safeSumDigits (n `div` 10)
-- main = print (safeSumDigits 99)  -- 18
-- main = print (safeSumDigits (-1))  -- error: Negative!

-- >>> ТЕОРИЯ: комбинируем готовые функции
--   Ничего нового: сумма цифр минус произведение цифр, обе функции у тебя уже есть.
--   89: сумма 17, произведение 72, ответ 17 - 72 = -55.
--   Эта функция пригодится в C5.
--
-- B8. Сумма цифр минус произведение цифр.
sumMinusProduct :: Int -> Int
sumMinusProduct n = sumNums n - mulNums n

mulNums :: Int -> Int
mulNums n
    | abs n < 10 = n
    | otherwise = abs n `mod` 10 * mulNums (abs n `div` 10)


sumNums :: Int -> Int
sumNums n
    | abs n < 10 = n
    | otherwise = abs n `mod` 10 + sumNums (abs n `div` 10)
-- main = print (sumMinusProduct 22)  -- 0
-- main = print (sumMinusProduct 41)  -- 1
-- main = print (sumMinusProduct 89)  -- -55

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: error + filter odd + length
--   Это B7 (ошибка) плюс B2 (подсчёт по условию), только odd вместо even.
--   Текст ошибки должен совпадать с условием ДОСЛОВНО: "Negative number error".
--   Крайний случай: countOdds 0 — цифры [0], нечётных нет, ответ 0.
--
-- C1. [midterm1 #1]
-- Write a function that takes a non-negative integer and returns
-- the number of odd digits in that integer.
-- If the input is negative, return an error message
-- as a string "Negative number error".
-- Подсказка: guard на n < 0 с error, дальше  length (filter odd (digits n)).
countOdds :: Int -> Int
countOdds n
    | n < 0 = error "Negative number error"
    | otherwise = length (filter odd (digits4 n))

digits4 :: Int -> [Int]
digits4 n
    | n < 10 = [n]
    | otherwise = digits4 (n `div` 10) ++ [n `mod` 10]
-- main = print (countOdds 1234)  -- 2
-- main = print (countOdds 0)  -- 0
-- main = print (countOdds 987654321)  -- 5
-- main = print (countOdds (-5678))  -- error: Negative number error

-- >>> ТЕОРИЯ к C2: map, чтобы сделать что-то с каждой цифрой
--   (^) — степень:  3 ^ 2 == 9.   (^ 2) — "возвести в квадрат" (секция оператора):
--       map (^ 2) [1,2,3] == [1,4,9]
--   Лямбдой то же самое:  map (\d -> d * d) [1,2,3]
--   ПЛАН: digits (он уже убирает знак) -> квадраты -> sum.
--
-- C2. [midterm2 #1]
-- Write a function sumOfSquaresOfDigits that takes an integer
-- and returns the sum of the squares of its digits.
-- In case of negatives, ignore the sign.
sumOfSquaresOfDigits :: Int -> Int
sumOfSquaresOfDigits xs = foldl (\acc x -> acc + x ^ 2) 0 (digits5 xs)

digits5 :: Int -> [Int]
digits5 n 
    | abs n < 10 = [n]
    | otherwise = digits5 (abs n `div` 10) ++ [abs n `mod` 10]
-- main = print (sumOfSquaresOfDigits 123)  -- 14
-- main = print (sumOfSquaresOfDigits 405)  -- 41
-- main = print (sumOfSquaresOfDigits (-56))  -- 61
-- main = print (sumOfSquaresOfDigits 0)  -- 0
-- main = print (sumOfSquaresOfDigits 999)  -- 243

-- >>> ТЕОРИЯ к C3: два аргумента + ответ Bool
--   Функция двух аргументов:  f n p = ...      вызов: f 153 3
--   Степень из аргумента:  map (^ p) [1,5,3] == [1,125,27]   при p = 3
--   Ответ — сравнение  (сумма степеней) == n,  как в B4, без if.
--
-- C3. [midterm3 #1]
-- Write a function sumOfDigitsPower that takes two integers n and p and returns
-- True if the sum of the digits of n raised to the power p equals n.
-- Otherwise, return False.
-- sumOfDigitsPower 153 3 -- True  (1^3 + 5^3 + 3^3 = 1+125+27 = 153)
sumOfDigitsPower :: Int -> Int -> Bool
sumOfDigitsPower n p = (foldl (\acc x -> acc + x ^ p) 0 (digits6 n)) == (n)

digits6 :: Int -> [Int]
digits6 n
    | abs n < 10 = [n]
    | otherwise = digits6 (abs n `div` 10) ++ [abs n `mod` 10]
-- main = print (sumOfDigitsPower 89 3)  -- False
-- main = print (sumOfDigitsPower 153 3)  -- True
-- main = print (sumOfDigitsPower 123 2)  -- False
-- main = print (sumOfDigitsPower 9474 4)  -- True

-- >>> ТЕОРИЯ к C4: filter с порогом из аргумента
--   (>= d) значит "больше или равно d", и d может быть аргументом функции:
--       filter (>= 5) [4,5,7,2] == [5,7]
--   "Удалить цифры меньше d" — то же самое, что "оставить >= d".
--   ПЛАН: digits -> filter -> fromDigits (как B5).
--
-- C4. [midterm4 #1]
-- Given a positive integer and a digit, write a function that removes all digits
-- in the number that are smaller than the given digit.
-- Example: For the number 4572 and the digit 5, the result is 57.
-- (В sample у первого теста опечатка "-4547" — правильно 4547.)
-- Подсказка: digits -> filter -> fromDigits.
changeNumber :: Int -> Int -> Int
changeNumber n p = toDigits7 (filter (\x -> x >= p) (digits7 n))

digits7 :: Int -> [Int]
digits7 n
    | abs n < 10 = [n]
    | otherwise = digits7 (abs n `div` 10) ++ [abs n `mod` 10]

toDigits7 :: [Int] -> Int
toDigits7 xs = foldl (\acc i -> acc * 10 + i) 0 xs
-- main = print (changeNumber 45347 4)  -- 4547
-- main = print (changeNumber 4572 5)  -- 57
-- main = print (changeNumber 523189 3)  -- 5389

-- >>> ТЕОРИЯ к C5: лямбда в filter, map своей функцией
--   "Не делится на 5":  x `mod` 5 /= 0        (/= значит "не равно")
--   filter ждёт функцию-условие, пишем её лямбдой:
--       filter (\x -> x `mod` 5 /= 0) [10,22,35,41] == [22,41]
--   Потом map твоей функцией из B8:
--       map sumMinusProduct [22,41] == [0,1]
--   Итого:  map ... (filter ... xs)
--
-- C5. [midterm3 #3]
-- Given a list of integers:
-- Remove all numbers that are divisible by 5.
-- For the remaining numbers, replace each number with the difference between
-- the sum of its digits and the product of its digits.
-- [10, 22, 35, 41, 55] -> [22, 41] -> [2+2 - 2*2, 4+1 - 4*1] = [0, 1]
transformList :: [Int] -> [Int]
transformList list = map (\x -> sumOfDig x - (multOfDig x)) (part list)

multOfDig :: Int -> Int
multOfDig x
    | abs x < 10 = abs x
    | otherwise = abs x `mod` 10 * multOfDig (abs x `div` 10)

sumOfDig :: Int -> Int
sumOfDig x
    | abs x < 10 = abs x
    | otherwise = abs x `mod` 10 + sumOfDig (abs x `div` 10)

part :: [Int] -> [Int]
part xs = filter (\x -> x `mod` 5 /= 0) xs
-- main = print (transformList [10, 22, 35, 41, 55])  -- [0,1]
-- main = print (transformList [15, 23, 35, 45, 67])  -- [-1,-29]
-- main = print (transformList [12, 30, 47, 55, 89])  -- [1,-17,-55]

-- >>> ТЕОРИЯ к C6: all, &&
--   all p xs — True, если p верно для ВСЕХ элементов:
--       all (== 1) [1,1,1] == True        all (== 1) [1,0,1] == False
--   && — логическое "и". Нужно  n > 0 && ...,  потому что 0 = [0] — это не "все единицы".
--   ПЛАН: toBinary (B6) -> все ли цифры равны 1.
--       7 = [1,1,1] -> True;   55 = [1,1,0,1,1,1] -> False
--
-- C6. [midterm2 #4]
-- Write a function which takes an Integer and returns True if the number is
-- all ones in binary representation, False otherwise.
-- 7 = 111 -> True,  55 = 110111 -> False
isAllOnes :: Int -> Bool
isAllOnes number = (length (decToBin number)) == (length (filter (\x -> x == 1) (decToBin number)))

decToBin :: Int -> [Int]
decToBin number
    | number <= 1 = [1]
    | otherwise = decToBin (number `div` 2) ++ [number `mod` 2]
-- main = print (isAllOnes 7)  -- True
-- main = print (isAllOnes 55)  -- False
-- main = print (isAllOnes 15)  -- True
-- main = print (isAllOnes 127)  -- True
-- main = print (isAllOnes 1)  -- True
