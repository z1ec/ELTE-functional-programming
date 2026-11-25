-- ============================================================================
-- 07. INSTANCE SHOW  (своя печать для типа)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/07_show_instances.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/07_show_instances.hs
--
-- Задачи из sample в этом файле:
--   endterm1 #9 Show для Player и Team
--   endterm2 #9 Show для Sport
--   endterm3 #7 Show для Student
--   endterm4 #7 BTree + Show, #8 Show для Player
-- В одном файле у типа может быть только ОДИН instance Show. Поэтому для
-- задачи endterm1 #9 тип игрока здесь называется Member (на экзамене — Player).

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА
------------------------------------------------------------------------------
--   print x  на самом деле печатает  show x.
--   deriving (Show) — Haskell сам пишет show. Если нужен СВОЙ формат,
--   deriving (Show) НЕ пишем, а пишем instance:
--
--       data Point = Point Int Int                 -- без deriving Show!
--       instance Show Point where
--         show (Point x y) = "<" ++ show x ++ "," ++ show y ++ ">"
--
--       print (Point 1 2)    печатает   <1,2>
--
--   show внутри — это show для Int / String / списка и т.д.:
--       show 5       == "5"
--       show 2.5     == "2.5"
--       show "Bob"   == "\"Bob\""     -- С КАВЫЧКАМИ!  печатается как "Bob"
--       show [1,2]   == "[1,2]"
--   Строку БЕЗ кавычек вставляй как есть:  "Name: " ++ name
--   Строку С кавычками:                    "Name: " ++ show name
--   Смотри на тест, нужны ли кавычки!
--
--   Список печатается сам:  print [p1, p2]  ->  [<show p1>,<show p2>]
--   (запятая без пробела)

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: show для перечисления
--   Одно уравнение на каждый конструктор:
--       instance Show Light where
--         show Red   = "STOP"
--         show Green = "GO"
--   Обрати внимание на отступ (2 пробела) под "instance ... where".
data Weekday = Mon | Tue | Wed

-- A1. Печатай полное имя дня: Monday, Tuesday, Wednesday.
instance Show Weekday where
  show Mon = "Monday"
  show Tue = "Tuesday"
  show Wed = "Wednesday"
-- main = print Mon  -- Monday
-- main = print [Tue, Wed]  -- [Tuesday,Wednesday]


-- >>> ТЕОРИЯ: show для конструктора с числами
--   Числа превращаем в строку через show и склеиваем через ++:
--       show (Point x y) = "(" ++ show x ++ ";" ++ show y ++ ")"
data Point = Point Int Int

-- A2. Печатай точку как (x;y).
instance Show Point where
  show (Point x y) = "(" ++ show x ++ ";" ++ show y ++ ")"
-- main = print (Point 1 2)  -- (1;2)
-- main = print (Point (-3) 0)  -- (-3;0)


-- >>> ТЕОРИЯ: show для record
--   У record можно читать поля функциями:
--       show b = title b ++ ", " ++ show (pages b) ++ " pages"
--   или разобрать образцом:  show (Book t p) = ...
--   title — String, его вставляем БЕЗ show (в тесте нет кавычек).
data Book = Book {title :: String, pages :: Int}

-- A3. Печатай книгу как:  Dune, 412 pages
instance Show Book where
  show b = title b ++ ", " ++ show (pages b) ++ " pages"
-- main = print (Book "Dune" 412)  -- Dune, 412 pages
-- main = print [Book "A" 1, Book "B" 2]  -- [A, 1 pages,B, 2 pages]


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: тип с параметром — нужен "Show a =>"
--   data Box a = Box a       -- в коробке может лежать что угодно
--   Чтобы напечатать содержимое, его тип тоже должен уметь show:
--       instance Show a => Show (Box a) where
--         show (Box x) = "Box<" ++ show x ++ ">"
--   (Box a) в скобках — обязательно.
data Box a = Box a

-- B1. Печатай коробку как  Box<содержимое>
instance Show a => Show (Box a) where
  show (Box x) = "Box<" ++ show x ++ ">"
-- main = print (Box 5)  -- Box<5>
-- main = print (Box "hi")  -- Box<"hi">
-- main = print (Box [True])  -- Box<[True]>


-- >>> ТЕОРИЯ: if внутри show
--   В show можно писать guards и if, как в любой функции:
--       show (Temp t) | t < 0     = "cold"
--                     | otherwise = "ok"
data Account = Account String Int

-- B2. Печатай счёт:  "Ann: 50"  , а если баланс отрицательный —  "Ann: 50 (debt!)"
--   с ПОЛОЖИТЕЛЬНЫМ числом (abs).
instance Show Account where
  show (Account name b)
    | b < 0 = name ++ ": " ++ show (abs b) ++ " (debt!)"
    | otherwise = name ++ ": " ++ show b
-- main = print (Account "Ann" 50)  -- Ann: 50
-- main = print (Account "Ben" (-20))  -- Ben: 20 (debt!)


-- >>> ТЕОРИЯ: show для РЕКУРСИВНОГО типа
--   Внутри show можно вызывать show для части того же типа — это рекурсия:
--       data MyList = Empty | Cons Int MyList
--       show Empty      = "[]"
--       show (Cons x r) = show x ++ " : " ++ show r
--   show r — это наш же show для MyList.
data MyList = Empty | Cons Int MyList

-- B3. Печатай  1 : 2 : []
instance Show MyList where
  show Empty = "[]"
  show (Cons x r) = show x ++ " : " ++ show r
-- main = print (Cons 1 (Cons 2 Empty))  -- 1 : 2 : []
-- main = print Empty  -- []


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: параметр + несколько конструкторов (как B1)
--   instance Show a => Show (Sport a) where
--     show (Football x) = "Football: " ++ show x
--     ...
--   Тест  Football "Played by 22"  печатает  Football: "Played by 22"
--   — с кавычками, потому что show строки даёт кавычки. Так и нужно.
data Sport a = Football a | Voleyball a | Basketball a

-- C1 (endterm2 #9). Custom Show for Sport in the form "Sport_Name: <data>".
instance Show a => Show (Sport a) where
  show (Football x) = "Football: " ++ show x
  show (Voleyball x) = "Voleyball: " ++ show x
  show (Basketball x) = "Basketball: " ++ show x
-- main = print (Football "Played by 22")  -- Football: "Played by 22"
-- main = print (Basketball 5)  -- Basketball: 5
-- main = print (Voleyball True)  -- Voleyball: True
-- main = print (Basketball [1,2,3,4])  -- Basketball: [1,2,3,4]


-- >>> ТЕОРИЯ: свой тип дерева + рекурсивный show (как B3)
--   На экзамене тип надо написать самому. Значение лежит МЕЖДУ поддеревьями,
--   а лист тоже хранит значение:
--       data BTree a = BLeaf a | BNode (BTree a) a (BTree a)
--   Формат:
--       BLeaf x       ->  Leaf: x
--       BNode l x r   ->  Node: (<show l>) -> x -> (<show r>)
--   Строки собираем через ++ и show.
data BTree a = BLeaf a | BNode (BTree a) a (BTree a)

-- C2 (endterm4 #7). Define BTree (BNode, BLeaf) and a custom Show instance:
--   a leaf prints as   Leaf: value
--   a node prints as   Node: (left subtree) -> value -> (right subtree)
instance Show a => Show (BTree a) where
  show (BLeaf x) = "Leaf: " ++ show x
  show (BNode l x r) = "Node: (" ++ show l ++ ") -> " ++ show x ++ " -> (" ++ show r ++ ")"

t1, t2 :: BTree Int
t1 = BNode (BNode (BLeaf 1) 2 (BLeaf 3)) 4 (BLeaf 5)
t2 = BNode (BNode (BLeaf 6) 20 (BLeaf 5)) 10 (BNode (BLeaf 1) 8 (BLeaf 2))

-- main = print t1  -- Node: (Node: (Leaf: 1) -> 2 -> (Leaf: 3)) -> 4 -> (Leaf: 5)
-- main = print (BNode (BLeaf 1) 10 (BLeaf 2))  -- Node: (Leaf: 1) -> 10 -> (Leaf: 2)
-- main = print t2  -- Node: (Node: (Leaf: 6) -> 20 -> (Leaf: 5)) -> 10 -> (Node: (Leaf: 1) -> 8 -> (Leaf: 2))
-- main = print (BLeaf 3)  -- Leaf: 3


-- Данные для C3–C6
data Univ = Univ {uniName :: String, uniID :: Int} deriving (Show)

data Student = Student {neptunID :: Int, studentName :: String, uni :: Univ, grades :: [Int]}

univ3 = Univ {uniName = "University C", uniID = 3}

-- >>> ТЕОРИЯ: show для record со средним (Double)
--   Среднее:  fromIntegral (sum gs) / fromIntegral (length gs)   — это Double,
--   show среднего даёт "86.0" или "92.66666666666667".
--   Удобно завести имена через where:
--       show s = base ++ extra
--         where avg   = ...
--               base  = "I am " ++ studentName s ++ " from " ++ uniName (uni s)
--                       ++ ". My average score is " ++ show avg ++ "."
--               extra = if avg > 90 then " I am a very good student." else ""
--   Имена вставляем БЕЗ show (в тестах нет кавычек).
--
-- C3 (endterm3 #7). Custom Show for Student, which prints:
--   "I am <studentName> from <uni>. My average score is <average of grades>."
--   If the average > 90, add the sentence: " I am a very good student."
instance Show Student where
  show s = base ++ extra
    where
      avg = fromIntegral (sum (grades s)) / fromIntegral (length (grades s)) :: Double
      base = "I am " ++ studentName s ++ " from " ++ uniName (uni s) ++ ". My average score is " ++ show avg ++ "."
      extra = if avg > 90 then " I am a very good student." else ""
-- main = print (Student {neptunID = 106, studentName = "Frank", uni = univ3, grades = [95, 99, 84]})  -- I am Frank from University C. My average score is 92.66666666666667. I am a very good student.
-- main = print (Student {neptunID = 106, studentName = "Bob", uni = univ3, grades = [85, 89, 84]})  -- I am Bob from University C. My average score is 86.0.


data Team = Team {teamName :: String, teamID :: Int}

data Player = Player {playerID :: Int, playerName :: String, playerTeam :: Team, playerScores :: [Int]}

team1 = Team {teamName = "Team A", teamID = 1}
team2 = Team {teamName = "Team B", teamID = 2}
team3 = Team {teamName = "Team C", teamID = 3}

player1 = Player {playerID = 1, playerName = "Alice", playerTeam = team1, playerScores = [10, 20, 30]}
player2 = Player {playerID = 2, playerName = "Bob", playerTeam = team1, playerScores = [15, 25, 35]}
player7 = Player {playerID = 7, playerName = "John", playerTeam = team2, playerScores = [12, 22, 32]}
player8 = Player {playerID = 8, playerName = "Peter", playerTeam = team2, playerScores = [10, 5, 5]}

-- >>> ТЕОРИЯ: то же, что C3, но со словом-оценкой
--   x = if avg < 20 then "bad" else "quite good"
--   Имя команды:  teamName (playerTeam p)
--   В sample первый тест и условие расходятся по запятым/точке;
--   здесь взят формат второго теста (ниже). Точки в конце НЕТ.
--
-- C4 (endterm4 #8). Custom Show for Player:
--   I am <playerName> from <team name>, my average score is <average> which is <x>
--   x = "bad" if average < 20, otherwise "quite good".
instance Show Player where
  show p = "I am " ++ playerName p ++ " from " ++ teamName (playerTeam p) ++ ", my average score is " ++ show avg ++ " which is " ++ x
    where
      avg = fromIntegral (sum (playerScores p)) / fromIntegral (length (playerScores p)) :: Double
      x = if avg < 20 then "bad" else "quite good"
-- main = print player1  -- I am Alice from Team A, my average score is 20.0 which is quite good
-- main = print [player7, player8]  -- [I am John from Team B, my average score is 22.0 which is quite good,I am Peter from Team B, my average score is 6.666666666666667 which is bad]


-- >>> ТЕОРИЯ: формат "как deriving", но свой
--   Нужно напечатать точь-в-точь:
--       playerTeam = Team {teamName = "Team A", teamID = 1}
--   Имя команды С кавычками — значит show (teamName t).
--   Кавычка внутри строки пишется как \"  :  "a\"b" печатается как a"b
--
-- C5 (endterm1 #9b). Show for Team in the format:
--   playerTeam = Team {teamName = <teamName value>, teamID = <teamID value>}
instance Show Team where
  show t = "playerTeam = Team {teamName = " ++ show (teamName t) ++ ", teamID = " ++ show (teamID t) ++ "}"
-- main = print team2  -- playerTeam = Team {teamName = "Team B", teamID = 2}
-- main = print [team1, team2, team3]  -- [playerTeam = Team {teamName = "Team A", teamID = 1},playerTeam = Team {teamName = "Team B", teamID = 2},playerTeam = Team {teamName = "Team C", teamID = 3}]


-- >>> ТЕОРИЯ: show внутри show
--   Команду печатаем ТВОИМ show из C5 и оборачиваем в кавычки:
--       "Team: \"" ++ show (memberTeam m) ++ "\""
--   Имя — show (кавычки нужны), очки — show списка.
--
-- C6 (endterm1 #9a; на экзамене тип называется Player). Show in the format:
--   Player {ID: <ID>, Name: <name>, Team: "<team>", Scores: [scores...]}
data Member = Member {memberID :: Int, memberName :: String, memberTeam :: Team, memberScores :: [Int]}

member1 = Member {memberID = 1, memberName = "Alice", memberTeam = team1, memberScores = [10, 20, 30]}
member2 = Member {memberID = 2, memberName = "Bob", memberTeam = team1, memberScores = [15, 25, 35]}
member5 = Member {memberID = 5, memberName = "Eve", memberTeam = team3, memberScores = [14, 24, 34]}

instance Show Member where
  show m = "Player {ID: " ++ show (memberID m) ++ ", Name: " ++ show (memberName m) ++ ", Team: \"" ++ show (memberTeam m) ++ "\", Scores: " ++ show (memberScores m) ++ "}"
-- main = print member5  -- Player {ID: 5, Name: "Eve", Team: "playerTeam = Team {teamName = "Team C", teamID = 3}", Scores: [14,24,34]}
-- main = print [member1, member2]  -- [Player {ID: 1, Name: "Alice", Team: "playerTeam = Team {teamName = "Team A", teamID = 1}", Scores: [10,20,30]},Player {ID: 2, Name: "Bob", Team: "playerTeam = Team {teamName = "Team A", teamID = 1}", Scores: [15,25,35]}]
