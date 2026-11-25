-- ============================================================================
-- 08. INSTANCE EQ  (своё "равно" для типа)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/08_eq_instances.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/08_eq_instances.hs
--
-- Задачи из sample в этом файле:
--   endterm1 #10 Eq для Player (сумма равна, команды разные)
--   endterm3 #8  Eq для Product и Customer
--   endterm4 #9  Eq для Player (сумма равна, команда та же) и для Team
--   (endterm2 #8 Eq для дерева поиска — в 05_trees_advanced.hs)
-- В одном файле у типа может быть только ОДИН instance Eq. Поэтому для
-- endterm1 #10 тип игрока называется Athlete (на экзамене — Player).

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА
------------------------------------------------------------------------------
--   deriving (Eq) — равны, если ВСЕ поля равны. Если правило другое,
--   deriving Eq НЕ пишем, а пишем instance:
--
--       data Point = Point Int Int
--       instance Eq Point where
--         (Point a b) == (Point c d) = a == c && b == d
--
--   Достаточно определить ==, а  /=  ("не равно") появится сам.
--   Слева от = стоят ДВА значения (как образцы или просто имена):
--         p1 == p2 = totalScore p1 == totalScore p2
--   Справа — обычное Bool-выражение. && = "и",  || = "или",  not = "не".

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: Eq для перечисления
--   Перечисляем равные пары, всё остальное — False:
--       Red   == Red   = True
--       Green == Green = True
--       _     == _     = False
data Light = Red | Yellow | Green

-- A1. Свет равен только сам себе.
instance Eq Light where
  Red == Red = True
  Yellow == Yellow = True
  Green == Green = True
  _ == _ = False
-- main = print (Red == Red)  -- True
-- main = print (Red == Green)  -- False
-- main = print (Yellow /= Green)  -- True


-- >>> ТЕОРИЯ: разбор конструктора с двух сторон
--   (Point a b) == (Point c d) = a == c && b == d
--   Слева от = скобки обязательны.
data Point = Point Int Int

-- A2. Точки равны, если равны обе координаты.
instance Eq Point where
  (Point a b) == (Point c d) = a == c && b == d
-- main = print (Point 1 2 == Point 1 2)  -- True
-- main = print (Point 1 2 == Point 2 1)  -- False


-- >>> ТЕОРИЯ: сравниваем не всё
--   Можно сравнивать только часть полей:
--       b1 == b2 = title b1 == title b2         -- pages не важен
data Book = Book {title :: String, pages :: Int}

-- A3. Книги равны, если совпадает название (страницы не важны).
instance Eq Book where
  b1 == b2 = title b1 == title b2
-- main = print (Book "Dune" 412 == Book "Dune" 500)  -- True
-- main = print (Book "Dune" 412 == Book "It" 412)  -- False


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: равенство по ВЫЧИСЛЕННОМУ значению
--   Дроби 1/2 и 2/4 равны. Проверка без деления: a/b == c/d  <=>  a*d == b*c
data Fraction = Fraction Int Int

-- B1. Дроби равны, если равны их значения.
instance Eq Fraction where
  (Fraction a b) == (Fraction c d) = a * d == b * c
-- main = print (Fraction 1 2 == Fraction 2 4)  -- True
-- main = print (Fraction 1 3 == Fraction 1 2)  -- False


-- >>> ТЕОРИЯ: сумма списка внутри record
--   w1 == w2 = sum (coins w1) == sum (coins w2)
--   Можно добавить второе условие через &&.
data Wallet = Wallet {owner :: String, coins :: [Int]}

-- B2. Кошельки равны, если у них ОДИН владелец и одинаковая сумма монет.
instance Eq Wallet where
  w1 == w2 = owner w1 == owner w2 && sum (coins w1) == sum (coins w2)
-- main = print (Wallet "Ann" [1, 2, 5] == Wallet "Ann" [5, 3])  -- True
-- main = print (Wallet "Ann" [1] == Wallet "Ben" [1])  -- False
-- main = print (Wallet "Ann" [1] == Wallet "Ann" [2])  -- False


-- >>> ТЕОРИЯ: сравнение СПИСКОВ своего типа
--   Списки можно сравнивать ==, если умеем сравнивать их элементы.
--   У Item есть deriving (Eq), поэтому  items o1 == items o2  уже работает.
--   (В C1 так же: Customer сравнивает списки Product, которым ТЫ сделал Eq.)
data Item = Item String Int deriving (Eq)

data Order = Order {orderId :: Int, items :: [Item]}

-- B3. Заказы равны, если у них одинаковые списки товаров (номер не важен).
instance Eq Order where
  o1 == o2 = items o1 == items o2
-- main = print (Order 1 [Item "pen" 2] == Order 2 [Item "pen" 2])  -- True
-- main = print (Order 1 [Item "pen" 2] == Order 1 [Item "pen" 3])  -- False


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ
------------------------------------------------------------------------------

data Product = Product {productName :: String, price :: Double, quantity :: Int}

data Customer = Customer {customerName :: String, contactEmail :: String, orderHistory :: [Product]}

product1 = Product "Laptop" 999.99 10
product2 = Product "Smartphone" 499.99 20
product3 = Product "Headphones" 199.99 50

customer1 = Customer "Alice" "alice@example.com" [product1, product2]
customer2 = Customer "Bob" "bob@example.com" [product2, product3]
customer3 = Customer "Alice" "alice@example.com" [product1, product2]

-- >>> ТЕОРИЯ: три поля через &&  (как B2)
--   p1 == p2 = productName p1 == productName p2 && price p1 == price p2 && ...
--
-- C1a (endterm3 #8). Two products are equal if they have the same name,
--   the same price, and the same quantity in stock.
instance Eq Product where
  p1 == p2 = productName p1 == productName p2 && price p1 == price p2 && quantity p1 == quantity p2
-- main = print (product1 == product2)  -- False
-- main = print (product1 == product1)  -- True


-- >>> ТЕОРИЯ: список Product внутри Customer (как B3)
--   orderHistory c1 == orderHistory c2  работает, потому что выше ТЫ
--   написал Eq для Product.
--
-- C1b (endterm3 #8). Two customers are equal if they have the same name,
--   the same contact email, and the same order history.
instance Eq Customer where
  c1 == c2 = customerName c1 == customerName c2 && contactEmail c1 == contactEmail c2 && orderHistory c1 == orderHistory c2
-- main = print (customer1 == customer2)  -- False
-- main = print (customer1 == customer3)  -- True


data Team = Team {teamName :: String, teamID :: Int}

data Player = Player {playerID :: Int, playerName :: String, playerTeam :: Team, playerScores :: [Int]}

team1 = Team {teamName = "Team A", teamID = 1}
team2 = Team {teamName = "Team B", teamID = 2}
team3 = Team {teamName = "Team C", teamID = 3}
team0 = Team {teamName = "Team C", teamID = 3}

player1 = Player {playerID = 1, playerName = "Alice", playerTeam = team1, playerScores = [10, 20, 30]}
player2 = Player {playerID = 2, playerName = "Bob", playerTeam = team1, playerScores = [15, 25, 35]}
player3 = Player {playerID = 3, playerName = "Charlie", playerTeam = team2, playerScores = [12, 22, 32]}
player7 = Player {playerID = 7, playerName = "John", playerTeam = team2, playerScores = [12, 22, 32]}

-- >>> ТЕОРИЯ: два поля одного record
--   t1 == t2 = teamID t1 == teamID t2 && teamName t1 == teamName t2
--
-- C2 (endterm4 #9, part 2). Two teams are equal if they have the same id and name.
instance Eq Team where
  t1 == t2 = teamID t1 == teamID t2 && teamName t1 == teamName t2
-- main = print (team3 == team0)  -- True
-- main = print (team1 == team2)  -- False


-- >>> ТЕОРИЯ: используем Eq из C2
--   Сумма:  sum (playerScores p)
--   Та же команда:  playerTeam p1 == playerTeam p2   — работает, потому что
--   ты уже написал Eq для Team (C2).
--
-- C3 (endterm4 #9, part 1). Two players are equal if they have the same total
--   score, and they are in the same team.
instance Eq Player where
  p1 == p2 = sum (playerScores p1) == sum (playerScores p2) && playerTeam p1 == playerTeam p2
-- main = print (player1 == player2)  -- False
-- main = print (player3 == player7)  -- True


-- >>> ТЕОРИЯ: "из РАЗНЫХ команд"
--   /= значит "не равно":  a /= b  ==  not (a == b)
--   athleteTeam a1 /= athleteTeam a2   — тоже работает благодаря Eq Team из C2.
--
-- C4 (endterm1 #10; на экзамене тип называется Player). Implement the Eq
--   instance: two players are equal if they have the same total score and
--   came from different teams.
data Athlete = Athlete {athleteID :: Int, athleteName :: String, athleteTeam :: Team, athleteScores :: [Int]}

athlete1 = Athlete {athleteID = 1, athleteName = "Alice", athleteTeam = team1, athleteScores = [10, 20, 30]}
athlete2 = Athlete {athleteID = 2, athleteName = "Bob", athleteTeam = team1, athleteScores = [15, 25, 35]}
athlete3 = Athlete {athleteID = 3, athleteName = "Charlie", athleteTeam = team2, athleteScores = [12, 22, 32]}
athlete4 = Athlete {athleteID = 4, athleteName = "David", athleteTeam = team2, athleteScores = [18, 28, 38]}
athlete7 = Athlete {athleteID = 6, athleteName = "Frank", athleteTeam = team3, athleteScores = [30, 20, 10]}

instance Eq Athlete where
  a1 == a2 = sum (athleteScores a1) == sum (athleteScores a2) && athleteTeam a1 /= athleteTeam a2
-- main = print (athlete1 == athlete2)  -- False
-- main = print (athlete1 == athlete7)  -- True
-- main = print (athlete1 == athlete3)  -- False
-- main = print (athlete1 == athlete4)  -- False
