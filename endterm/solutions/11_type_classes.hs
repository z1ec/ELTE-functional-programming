-- ============================================================================
-- 11. КЛАССЫ ТИПОВ  (deriving, свой class, instance Ord, ограничения)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/11_type_classes.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи экзаменационного уровня.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/11_type_classes.hs
--
-- Из syllabus: "classes, instances". Show и Eq подробно — в 07 и 08,
-- здесь: что такое класс вообще, deriving Ord/Enum/Bounded, свой class,
-- instance Ord, функции с ограничением (Ord a => ...).

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА
------------------------------------------------------------------------------
--   Класс — это набор функций, которые тип ОБЕЩАЕТ уметь.
--       class Eq a where (==) :: a -> a -> Bool       -- уже есть в Haskell
--   instance — "мой тип умеет это вот так":
--       instance Eq Color where ...
--   Стандартные классы:
--       Show (show)  Eq (==, /=)  Ord (<, <=, compare, max, min)
--       Enum ([a..b], succ)  Bounded (minBound, maxBound)  Num (+, *, ...)
--   Ограничение в типе функции:  biggest :: Ord a => [a] -> a
--       "работает для ЛЮБОГО типа a, который умеет сравниваться"

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: deriving Ord, Enum, Bounded
--   data Size = Small | Medium | Large deriving (Show, Eq, Ord, Enum, Bounded)
--   Ord     — порядок как в объявлении:  Small < Medium < Large
--             значит работают maximum, minimum, sort
--   Enum    — диапазоны:   [Small ..] == [Small,Medium,Large]
--   Bounded — minBound :: Size == Small,  maxBound :: Size == Large
data Size = Small | Medium | Large deriving (Show, Eq, Ord, Enum, Bounded)

-- A1. Самый большой размер в непустом списке.
biggest :: [Size] -> Size
biggest xs = maximum xs
-- main = print (biggest [Medium, Small, Large, Small])  -- Large
-- main = print (Small < Large)  -- True


-- >>> ТЕОРИЯ: все значения типа
--   [minBound .. maxBound] — все значения по порядку (нужны Enum и Bounded).
--   Тип подскажет сигнатура функции.
--
-- A2. Все размеры, которые БОЛЬШЕ данного.
biggerThan :: Size -> [Size]
biggerThan s = [x | x <- [minBound .. maxBound], x > s]
-- main = print (biggerThan Small)  -- [Medium,Large]
-- main = print (biggerThan Large)  -- []


-- >>> ТЕОРИЯ: свой класс
--   class Describable a where
--     describe :: a -> String
--   Теперь для каждого типа пишем instance:
--       instance Describable Size where
--         describe Small = "S"
--         ...
class Describable a where
  describe :: a -> String

-- A3. Bool описывается как "yes" / "no".
instance Describable Bool where
  describe True = "yes"
  describe False = "no"
-- main = print (describe True)  -- "yes"
-- main = print (map describe [False, True])  -- ["no","yes"]


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: класс с несколькими функциями и разными типами
--   Один класс — разные реализации для разных типов:
--       instance HasArea Square where area (Square a) = a * a
--       instance HasArea Circle where area (Circle r) = pi * r * r
--   Функция для ЛЮБОГО типа класса:
--       bigger :: HasArea a => a -> a -> Bool
class HasArea a where
  area :: a -> Double
  name :: a -> String

data Square = Square Double

data Circle = Circle Double

instance HasArea Square where
  area (Square a) = a * a
  name _ = "square"

-- B1. instance для Circle: площадь pi*r*r, имя "circle".
instance HasArea Circle where
  area (Circle r) = pi * r * r
  name _ = "circle"
-- main = print (area (Circle 1))  -- 3.141592653589793
-- main = print (name (Circle 5))  -- "circle"


-- >>> ТЕОРИЯ: функция с ограничением класса
--   report :: HasArea a => a -> String
--   Внутри можно вызывать area и name, потому что a — из класса HasArea.
--   Double -> String: show.
--
-- B2. Строка вида "square: 4.0"
report :: HasArea a => a -> String
report x = name x ++ ": " ++ show (area x)
-- main = print (report (Square 2))  -- "square: 4.0"
-- main = print (report (Circle 0))  -- "circle: 0.0"


-- >>> ТЕОРИЯ: свой instance Ord
--   Нужен Eq (instance или deriving) и функция compare:
--       compare a b = LT | EQ | GT        (меньше / равно / больше)
--   Удобно сравнить ключи стандартным compare:
--       instance Ord Card where
--         compare (Card a _) (Card b _) = compare a b
--   После этого работают <, >, max, maximum, sort для твоего типа.
data Card = Card Int String deriving (Show, Eq)

-- B3. Карты сравниваются ТОЛЬКО по числу (масть не важна).
instance Ord Card where
  compare (Card a _) (Card b _) = compare a b
-- main = print (Card 3 "hearts" < Card 10 "spades")  -- True
-- main = print (maximum [Card 2 "a", Card 9 "b", Card 5 "c"])  -- Card 9 "b"


------------------------------------------------------------------------------
-- ЧАСТЬ C. ЭКЗАМЕНАЦИОННЫЙ УРОВЕНЬ
------------------------------------------------------------------------------

data Player = Player {playerName :: String, playerScores :: [Int]} deriving (Show)

p1 = Player "Alice" [10, 20, 30]
p2 = Player "Bob" [15, 25, 35]
p3 = Player "Cid" [40, 20]

-- >>> ТЕОРИЯ: Eq и Ord для record по вычисленному значению
--   Сначала Eq (Ord требует Eq):
--       a == b = total a == total b
--   Потом Ord:
--       compare a b = compare (total a) (total b)
--   total — сумма очков:  sum (playerScores p)
--
-- C1. Игроки равны / сравниваются по сумме очков.
instance Eq Player where
  a == b = sum (playerScores a) == sum (playerScores b)

instance Ord Player where
  compare a b = compare (sum (playerScores a)) (sum (playerScores b))
-- main = print (p1 == p3)  -- True
-- main = print (p2 > p1)  -- True
-- main = print (playerName (maximum [p1, p2, p3]))  -- "Bob"


-- >>> ТЕОРИЯ: обобщённая функция с Ord a =>
--   Работает для Int, Char, Size, Card, Player — для всего, где есть Ord.
--   Наибольший элемент и сколько раз он встречается:
--       m = maximum xs
--       (m, length (filter (== m) xs))
--
-- C2. Максимум и сколько раз он встречается (список не пустой).
maxCount :: Ord a => [a] -> (a, Int)
maxCount xs = (m, length (filter (== m) xs))
  where
    m = maximum xs
-- main = print (maxCount [3, 7, 1, 7])  -- (7,2)
-- main = print (maxCount "banana")  -- ('n',2)
-- main = print (maxCount [Small, Large, Large, Large])  -- (Large,3)


-- >>> ТЕОРИЯ: instance с ограничением для списка
--   Если умеем описывать элемент, умеем описать и список:
--       instance Describable a => Describable [a] where
--         describe xs = ...  (вызываем describe для каждого элемента)
--   Склеить список строк через запятую: помощник или foldr.
--       join []     = ""
--       join [s]    = s
--       join (s:ss) = s ++ "," ++ join ss
instance Describable a => Describable [a] where
  describe xs = "[" ++ join (map describe xs) ++ "]"
    where
      join [] = ""
      join [s] = s
      join (s : ss) = s ++ "," ++ join ss

-- C3. Описание списка:  [yes,no]
-- main = print (describe [True, False])  -- "[yes,no]"
-- main = print (describe ([] :: [Bool]))  -- "[]"
-- main = print (describe [[True], [False, False]])  -- "[[yes],[no,no]]"


-- >>> ТЕОРИЯ: instance Num — свои + и *
--   class Num требует: (+), (*), abs, signum, fromInteger, negate (или (-)).
--   Вектор складываем покоординатно:
--       (V2 a b) + (V2 c d) = V2 (a + c) (b + d)
--   fromInteger n = V2 (fromInteger n) (fromInteger n)  -- число -> вектор
--   После этого можно писать  v1 + v2,  sum [v1, v2, v3]  (sum начинает с 0!)
data V2 = V2 Int Int deriving (Show, Eq)

-- C4. Сделай V2 числом (всё покоординатно).
instance Num V2 where
  (V2 a b) + (V2 c d) = V2 (a + c) (b + d)
  (V2 a b) * (V2 c d) = V2 (a * c) (b * d)
  abs (V2 a b) = V2 (abs a) (abs b)
  signum (V2 a b) = V2 (signum a) (signum b)
  fromInteger n = V2 (fromInteger n) (fromInteger n)
  negate (V2 a b) = V2 (negate a) (negate b)
-- main = print (V2 1 2 + V2 10 20)  -- V2 11 22
-- main = print (sum [V2 1 1, V2 2 2, V2 3 3])  -- V2 6 6
-- main = print (V2 1 (-2) - V2 5 5)  -- V2 (-4) (-7)
