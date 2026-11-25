-- ============================================================================
-- 09. ФУНКЦИИ ВЫСШЕГО ПОРЯДКА, FOLD, БЕСКОНЕЧНЫЕ СПИСКИ, ЛЕНИВОСТЬ
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/09_hof_fold_infinite.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи экзаменационного уровня.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/09_hof_fold_infinite.hs
--
-- В sample-эндтермах этих задач нет отдельно, но они есть в syllabus
-- ("higher order functions, filters, map, iterate, fold", "infinite lists",
-- "lazy and eager evaluation") и часто встречаются в теоретическом квизе.
-- Плюс эти приёмы помогают решать задачи на records и деревья короче.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: функция как аргумент
--   Функция высшего порядка принимает (или возвращает) функцию.
--   map, filter — такие функции:  map (*2) [1,2] == [2,4]
--   Свою пишем так — аргумент-функция в типе стоит в скобках:
--       applyOnce :: (a -> a) -> a -> a
--       applyOnce f x = f x
--   Лямбда — функция без имени:   (\x -> x + 1)
--   Сечение оператора:            (+1),  (*2),  (`div` 2)
--
-- A1. Примени функцию к значению дважды.
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
-- main = print (applyTwice (+3) 10)  -- 16
-- main = print (applyTwice (\s -> s ++ "!") "hi")  -- "hi!!"
-- main = print (applyTwice tail [1, 2, 3, 4])  -- [3,4]


-- >>> ТЕОРИЯ: foldr — "свернуть список справа"
--   foldr f z [x1, x2, x3]  ==  f x1 (f x2 (f x3 z))
--   z — ответ для пустого списка, f — как присоединить элемент к ответу.
--   Сумма:      foldr (+) 0 [1,2,3]   ==  1 + (2 + (3 + 0)) == 6
--   Произведение: foldr (*) 1 xs
--   С лямбдой:  foldr (\x acc -> x + acc) 0 xs   (x — элемент, acc — ответ для хвоста)
--
-- A2. Произведение списка через foldr (для пустого — 1).
productFold :: [Int] -> Int
productFold xs = foldr (*) 1 xs
-- main = print (productFold [1, 2, 3, 4])  -- 24
-- main = print (productFold [])  -- 1


-- >>> ТЕОРИЯ: iterate + take
--   iterate f x  ==  [x, f x, f (f x), ...]   — БЕСКОНЕЧНЫЙ список
--   Работает, потому что Haskell ЛЕНИВЫЙ: считает только то, что попросили.
--       take 4 (iterate (*3) 1) == [1,3,9,27]
--
-- A3. Первые n степеней двойки: 1, 2, 4, 8, ...
powersOf2 :: Int -> [Int]
powersOf2 n = take n (iterate (* 2) 1)
-- main = print (powersOf2 5)  -- [1,2,4,8,16]
-- main = print (powersOf2 0)  -- []


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: foldr со своей лямбдой
--   Посчитать элементы, подходящие под условие p:
--       foldr (\x acc -> if p x then acc + 1 else acc) 0 xs
--   Сравни с  length (filter p xs)  — ответ тот же.
--
-- B1. Сколько элементов удовлетворяют условию? (через foldr)
countIf :: (a -> Bool) -> [a] -> Int
countIf p xs = foldr (\x acc -> if p x then acc + 1 else acc) 0 xs
-- main = print (countIf even [1, 2, 3, 4, 6])  -- 3
-- main = print (countIf (== 'a') "banana")  -- 3
-- main = print (countIf odd [])  -- 0


-- >>> ТЕОРИЯ: takeWhile на бесконечном списке
--   takeWhile p xs — берёт элементы, ПОКА условие верно, и останавливается:
--       takeWhile (< 10) [1,4..]  == [1,4,7]
--   Шаг Коллатца:  чётное n -> n `div` 2,   нечётное n -> 3*n + 1
--   Последовательность: iterate step n, обрезаем до первой 1,
--   а саму 1 добавляем в конец:  takeWhile (/= 1) (...) ++ [1]
--
-- B2. Последовательность Коллатца от n до 1 (n >= 1).
collatz :: Int -> [Int]
collatz n = takeWhile (/= 1) (iterate step n) ++ [1]
  where
    step k = if even k then k `div` 2 else 3 * k + 1
-- main = print (collatz 6)  -- [6,3,10,5,16,8,4,2,1]
-- main = print (collatz 1)  -- [1]


-- >>> ТЕОРИЯ: бесконечный список, который ссылается сам на себя
--   fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
--   zipWith f xs ys — как zip, но сразу применяет f к паре:
--       zipWith (+) [1,2] [10,20] == [11,22]
--   Ленивость: каждый следующий элемент считается из двух предыдущих,
--   и только когда его попросят (take n).
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- B3. Первые n чисел Фибоначчи, которые ЧЁТНЫЕ.
evenFibs :: Int -> [Integer]
evenFibs n = take n (filter even fibs)
-- main = print (evenFibs 5)  -- [0,2,8,34,144]
-- main = print (take 10 fibs)  -- [0,1,1,2,3,5,8,13,21,34]


------------------------------------------------------------------------------
-- ЧАСТЬ C. ЭКЗАМЕНАЦИОННЫЙ УРОВЕНЬ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: свой filter через foldr
--   Элемент x присоединяем к ответу хвоста (acc), только если p x:
--       foldr (\x acc -> if p x then x : acc else acc) [] xs
--   x : acc — положить x в начало списка.
--
-- C1. Напиши filter через foldr.
myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p xs = foldr (\x acc -> if p x then x : acc else acc) [] xs
-- main = print (myFilter even [1 .. 10])  -- [2,4,6,8,10]
-- main = print (myFilter (/= ' ') "a b c")  -- "abc"


-- >>> ТЕОРИЯ: foldl — "свернуть слева"
--   foldl f z [x1, x2, x3]  ==  f (f (f z x1) x2) x3
--   ВНИМАНИЕ: у лямбды для foldl сначала acc, потом элемент:  (\acc x -> ...)
--   Перевернуть список: каждый новый элемент кладём в НАЧАЛО накопленного:
--       foldl (\acc x -> x : acc) [] [1,2,3]
--       []  ->  [1]  ->  [2,1]  ->  [3,2,1]
--
-- C2. reverse через foldl.
myReverse :: [a] -> [a]
myReverse xs = foldl (\acc x -> x : acc) [] xs
-- main = print (myReverse [1, 2, 3])  -- [3,2,1]
-- main = print (myReverse "abc")  -- "cba"


-- >>> ТЕОРИЯ: foldl с числом-аккумулятором
--   Цифры -> число:  acc * 10 + d
--       foldl (\acc d -> acc * 10 + d) 0 [5,7,2]
--       0 -> 5 -> 57 -> 572
--
-- C3. Собери число из списка цифр.
fromDigits :: [Int] -> Int
fromDigits ds = foldl (\acc d -> acc * 10 + d) 0 ds
-- main = print (fromDigits [5, 7, 2])  -- 572
-- main = print (fromDigits [])  -- 0


-- >>> ТЕОРИЯ: композиция функций  (.)
--   (f . g) x  ==  f (g x)       — "сначала g, потом f"
--   Конвейер читается СПРАВА НАЛЕВО:
--       (sum . map (*2) . filter odd) [1,2,3]  ==  sum (map (*2) (filter odd [1,2,3])) == 8
--   Можно определить функцию без аргумента ("point-free"):
--       f = sum . map (*2) . filter odd
--
-- C4. Сумма квадратов нечётных чисел — одной цепочкой через (.)
sumOddSquares :: [Int] -> Int
sumOddSquares = sum . map (^ 2) . filter odd
-- main = print (sumOddSquares [1, 2, 3, 4, 5])  -- 35
-- main = print (sumOddSquares [])  -- 0


-- >>> ТЕОРИЯ: ленивость + head
--   head (filter p [1..]) — первое натуральное число, для которого p верно.
--   Бесконечный список НЕ строится целиком: filter отдаёт первый подходящий,
--   head его берёт, и вычисление останавливается.
--
-- C5. Первое натуральное число > 0, которое делится на ВСЕ числа из списка.
firstDivisibleByAll :: [Int] -> Int
firstDivisibleByAll ds = head (filter (\n -> all (\d -> n `mod` d == 0) ds) [1 ..])
-- main = print (firstDivisibleByAll [2, 3, 4])  -- 12
-- main = print (firstDivisibleByAll [7])  -- 7
-- main = print (firstDivisibleByAll [])  -- 1


-- >>> ТЕОРИЯ: решето Эратосфена — бесконечный список простых
--   sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
--   primes = sieve [2..]
--   Берём первое число (оно простое), выкидываем его кратные, повторяем.
--   Пустого случая нет: список бесконечный.
primes :: [Int]
primes = sieve [2 ..]
  where
    sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

-- C6. Сумма первых n простых чисел.
sumPrimes :: Int -> Int
sumPrimes n = sum (take n primes)
-- main = print (take 8 primes)  -- [2,3,5,7,11,13,17,19]
-- main = print (sumPrimes 5)  -- 28


-- >>> ТЕОРИЯ: scanl — все промежуточные результаты foldl
--   scanl (+) 0 [1,2,3]  == [0,1,3,6]      (первый элемент — стартовое значение)
--   tail убирает этот стартовый 0:  [1,3,6]
--
-- C7. Накопленные суммы.
runningSums :: [Int] -> [Int]
runningSums xs = tail (scanl (+) 0 xs)
-- main = print (runningSums [1, 2, 3, 4])  -- [1,3,6,10]
-- main = print (runningSums [])  -- []
