-- ============================================================================
-- 06. АЛГЕБРАИЧЕСКИЕ ТИПЫ  (свои data-типы, конструкторы, Maybe)
-- ============================================================================
-- ТРЕНАЖЁР. Решения лежат в ../solutions/06_algebraic_types.hs (открывай только после своей попытки)
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/06_algebraic_types.hs
--
-- Задачи из sample в этом файле:
--   endterm1 #8 combineColors
-- Из syllabus: algebraic types, Maybe, pattern matching по конструкторам.
--
-- ВНИМАНИЕ: на экзамене тип иногда нужно НАПИСАТЬ САМОМУ
-- ("Define an algebraic data type Color ..."). Здесь типы уже даны, чтобы
-- файл компилировался, но перед каждой задачей показано, как их пишут.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: тип-перечисление
--   data Direction = North | East | South | West deriving (Show, Eq)
--        ^имя типа   ^конструкторы через |   (все с БОЛЬШОЙ буквы)
--   deriving (Show) — можно печатать: print North  печатает  North
--   deriving (Eq)   — можно сравнивать: North == West  == False
--   Функция по конструкторам — одно уравнение на каждый случай:
--       isNorth North = True
--       isNorth _     = False          -- _ = "всё остальное"
data Direction = North | East | South | West deriving (Show, Eq)

-- A1. Поверни направо (по часовой стрелке): North -> East -> South -> West -> North.
turnRight :: Direction -> Direction
turnRight = undefined
-- main = print (turnRight North)  -- East
-- main = print (turnRight West)  -- North
-- main = print (map turnRight [North, East, South, West])  -- [East,South,West,North]


-- >>> ТЕОРИЯ: конструкторы с данными внутри
--   data Shape = Circle Double | Rect Double Double deriving (Show)
--   Circle 2.0    — круг радиуса 2.0
--   Rect 2.0 3.0  — прямоугольник 2 на 3
--   В образце достаём данные из конструктора:
--       perimeter (Circle r) = 2 * pi * r
--       perimeter (Rect a b) = 2 * (a + b)
--   pi — встроенное число 3.14159...
data Shape = Circle Double | Rect Double Double deriving (Show)

-- A2. Площадь фигуры (круг: pi * r * r, прямоугольник: a * b).
area :: Shape -> Double
area = undefined
-- main = print (area (Rect 2 3))  -- 6.0
-- main = print (area (Circle 1))  -- 3.141592653589793
-- main = print (sum (map area [Rect 1 1, Rect 2 2]))  -- 5.0


-- >>> ТЕОРИЯ: Maybe — "значение или ничего"
--   data Maybe a = Nothing | Just a        (уже встроен в Haskell)
--   Just 5    — есть значение 5
--   Nothing   — значения нет (вместо error)
--   Пример:
--       safeLast []  = Nothing
--       safeLast xs  = Just (last xs)
--
-- A3. Первый элемент списка, если он есть.
safeHead :: [Int] -> Maybe Int
safeHead = undefined
-- main = print (safeHead [7, 8, 9])  -- Just 7
-- main = print (safeHead [])  -- Nothing


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: Maybe + guards
--   safeDiv a b | b == 0    = Nothing
--               | otherwise = Just (a `div` b)
--   Скобки вокруг (a `div` b) обязательны: Just берёт ОДИН аргумент.
--
-- B1. Целочисленное деление, которое не падает на 0.
safeDiv :: Int -> Int -> Maybe Int
safeDiv = undefined
-- main = print (safeDiv 10 3)  -- Just 3
-- main = print (safeDiv 1 0)  -- Nothing


-- >>> ТЕОРИЯ: функция от ДВУХ конструкторов
--   Можно перечислить пары:
--       beats Rock Scissors = True
--       beats Paper Rock    = True
--       ...
--   Одинаковые значения — через guard (нужен deriving Eq):
--       f a b | a == b = ...
--   Сначала проверь одинаковые, потом "a побеждает b", потом иначе.
data Move = Rock | Paper | Scissors deriving (Show, Eq)

data Result = Win | Lose | Draw deriving (Show, Eq)

-- B2. Камень-ножницы-бумага: результат для ПЕРВОГО игрока.
--   Камень бьёт ножницы, ножницы бьют бумагу, бумага бьёт камень.
play :: Move -> Move -> Result
play = undefined
-- main = print (play Rock Scissors)  -- Win
-- main = print (play Rock Paper)  -- Lose
-- main = print (play Paper Paper)  -- Draw
-- main = print (play Scissors Paper)  -- Win


-- >>> ТЕОРИЯ: разбор Maybe в рекурсии
--   Список Maybe-значений разбираем по образцам:
--       f []             = ...
--       f (Nothing : xs) = ...           -- пропускаем
--       f (Just x : xs)  = ...           -- используем x
--
-- B3. Сумма всех Just-значений (Nothing пропускаем).
sumJust :: [Maybe Int] -> Int
sumJust = undefined
-- main = print (sumJust [Just 1, Nothing, Just 5])  -- 6
-- main = print (sumJust [Nothing])  -- 0


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: как в B2 + error
--   Тип на экзамене пишешь сам:
--       data Color = Red | Blue | Yellow | Purple | Orange | Green
--           deriving (Show, Eq)
--   Порядок уравнений:
--     1) одинаковые цвета -> тот же цвет        (guard  a == b)
--     2) все пары из условия, В ОБЕ СТОРОНЫ (Red Blue и Blue Red)
--     3) всё остальное -> error "Unsupported combo"
--   Пары удобно писать отдельными уравнениями помощника в where или так:
--       combineColors Red Blue = Purple
--       combineColors Blue Red = Purple
--       ...
--   но тогда случай "a == b" должен стоять ПЕРВЫМ (через guard в отдельном уравнении):
--       combineColors a b | a == b = a
--       combineColors Red Blue = Purple ...
data Color = Red | Blue | Yellow | Purple | Orange | Green deriving (Show, Eq)

-- C1 (endterm1 #8). Write a function combineColors that takes two colors and
--   returns the resulting derived color:
--     Red + Blue (or vice-versa) = Purple
--     Red + Yellow (or vice-versa) = Orange
--     Blue + Yellow (or vice-versa) = Green
--   If the two colors are the same, return the same color.
--   If the combination is unsupported, raise an error "Unsupported combo".
combineColors :: Color -> Color -> Color
combineColors = undefined
-- main = print (combineColors Red Blue)  -- Purple
-- main = print (combineColors Blue Red)  -- Purple
-- main = print (combineColors Yellow Red)  -- Orange
-- main = print (combineColors Blue Blue)  -- Blue
-- main = print (combineColors Red Green)  -- error: Unsupported combo


-- >>> ТЕОРИЯ: конструкторы с Double
--   Цельсий из Фаренгейта:  (f - 32) * 5 / 9
--   Для Celsius просто возвращаем число из конструктора.
data Temp = Celsius Double | Fahrenheit Double deriving (Show)

-- C2 (exam-like). Convert a temperature to Celsius.
toCelsius :: Temp -> Double
toCelsius = undefined
-- main = print (toCelsius (Celsius 21.5))  -- 21.5
-- main = print (toCelsius (Fahrenheit 212))  -- 100.0
-- main = print (map toCelsius [Fahrenheit 50, Celsius 0])  -- [10.0,0.0]


-- >>> ТЕОРИЯ: рекурсия с накопителем (аккумулятором)
--   Идём по списку и помним "текущий баланс":
--       go bal []             = bal
--       go bal (Deposit x : ts) = go (bal + x) ts
--       go bal (Withdraw x : ts)
--         | x > bal   = error "Not enough money"
--         | otherwise = go (bal - x) ts
--   balance ts = go 0 ts
data Transaction = Deposit Int | Withdraw Int deriving (Show)

-- C3 (exam-like). Start with 0 money and apply the transactions in order.
--   If a withdrawal is bigger than the current balance, raise an error
--   "Not enough money". Return the final balance.
balance :: [Transaction] -> Int
balance = undefined
-- main = print (balance [Deposit 100, Withdraw 30, Deposit 5])  -- 75
-- main = print (balance [])  -- 0
-- main = print (balance [Deposit 10, Withdraw 20])  -- error: Not enough money


-- >>> ТЕОРИЯ: Maybe Double
--   Для пустого списка — Nothing, иначе Just (среднее).
--   Среднее Int-списка: fromIntegral (sum xs) / fromIntegral (length xs)
--
-- C4 (exam-like). Average of a list, Nothing for an empty list.
safeAverage :: [Int] -> Maybe Double
safeAverage = undefined
-- main = print (safeAverage [1, 2, 3, 4])  -- Just 2.5
-- main = print (safeAverage [])  -- Nothing


-- >>> ТЕОРИЯ: поиск в списке пар -> Maybe
--   Список пар (ключ, значение) — как маленький словарь.
--       find k []            = Nothing
--       find k ((key, v) : rest)
--         | k == key  = Just v
--         | otherwise = find k rest
--   (во встроенном Haskell это функция lookup — но напиши сам)
--
-- C5 (exam-like). Find the price of a product in a price list.
findPrice :: String -> [(String, Double)] -> Maybe Double
findPrice = undefined
-- main = print (findPrice "milk" [("bread", 1.5), ("milk", 0.99)])  -- Just 0.99
-- main = print (findPrice "tea" [("bread", 1.5)])  -- Nothing


-- >>> ТЕОРИЯ: case — разбор Maybe внутри выражения
--   case выражение of
--     Nothing -> ...
--     Just v  -> ...
--   Пример:  showPrice k ps = case findPrice k ps of
--                               Nothing -> "no price"
--                               Just p  -> show p
--   Для списка покупок: если хоть одной цены нет — весь ответ Nothing.
--       totalPrice [] _ = Just 0
--       totalPrice (k : ks) ps = case findPrice k ps of
--           Nothing -> Nothing
--           Just p  -> case totalPrice ks ps of
--                        Nothing -> Nothing
--                        Just s  -> Just (p + s)
--
-- C6 (exam-like). Total price of a shopping list. If any product has no
--   price, the answer is Nothing.
totalPrice :: [String] -> [(String, Double)] -> Maybe Double
totalPrice = undefined
-- main = print (totalPrice ["milk", "bread"] [("bread", 1.5), ("milk", 1.0)])  -- Just 2.5
-- main = print (totalPrice ["milk", "tea"] [("bread", 1.5), ("milk", 1.0)])  -- Nothing
-- main = print (totalPrice [] [])  -- Just 0.0
