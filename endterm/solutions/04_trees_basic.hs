-- ============================================================================
-- 04. ДЕРЕВЬЯ: ОСНОВЫ  (обход, сумма, map, поиск по дереву)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/04_trees_basic.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/04_trees_basic.hs
--   * Или: убери "-- " перед ОДНОЙ строкой "main = print ..." и  runghc 04_trees_basic.hs
--   * РИСУЙ ДЕРЕВО НА БУМАГЕ, прежде чем писать код.
--
-- Задачи из sample в этом файле:
--   endterm1 #6 swapSubTree
--   endterm2 #5 tr1 (самый левый), #6 tr2 (map по дереву)
--   endterm3 #5 evenSumOddSum, #6 replaceNodes
--   endterm4 #4 playersFromTeam, #6 isPaliTree

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА ПО ДЕРЕВЬЯМ
------------------------------------------------------------------------------
-- Тип дерева (на экзамене именно такой):
--     data Tree a = Node a (Tree a) (Tree a) | Leaf
--   Leaf             — пустое место (нет узла)
--   Node x l r       — узел со значением x, левым поддеревом l и правым r
--
--          5                 Node 5 (Node 3 Leaf Leaf)
--         / \                       (Node 8 Leaf Leaf)
--        3   8
--
-- ГЛАВНЫЙ РЕЦЕПТ — почти все задачи пишутся из двух строк:
--     f Leaf         = ответ для пустого дерева
--     f (Node x l r) = собрать ответ из  x,  f l  и  f r
--
-- Как печатается дерево (deriving Show):  отрицательные числа в скобках!
--     Node (-1) Leaf Leaf

data Tree a = Node a (Tree a) (Tree a) | Leaf deriving (Show)

--          0
--        /   \
--       1     2
--      / \   / \
--     3   4 5   6
tree1 :: Tree Int
tree1 = Node 0 (Node 1 (Node 3 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 2 (Node 5 Leaf Leaf) (Node 6 Leaf Leaf))

--          0
--        /   \
--       1     2
--      /
--     5
--      \
--       8
tree2 :: Tree Int
tree2 = Node 0 (Node 1 (Node 5 Leaf (Node 8 Leaf Leaf)) Leaf) (Node 2 Leaf Leaf)

--       4
--        \
--         2
--        / \
--       1   3
tree3 :: Tree Int
tree3 = Node 4 Leaf (Node 2 (Node 1 Leaf Leaf) (Node 3 Leaf Leaf))

--           5
--        /     \
--       3       10
--      / \     /  \
--     7   2   6    1
treeExample1 :: Tree Int
treeExample1 = Node 5 (Node 3 (Node 7 Leaf Leaf) (Node 2 Leaf Leaf)) (Node 10 (Node 6 Leaf Leaf) (Node 1 Leaf Leaf))

--           8
--        /     \
--       3       15
--      / \     /  \
--    12   2   5    20
treeExample2 :: Tree Int
treeExample2 = Node 8 (Node 3 (Node 12 Leaf Leaf) (Node 2 Leaf Leaf)) (Node 15 (Node 5 Leaf Leaf) (Node 20 Leaf Leaf))

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: первая функция по рецепту
--   Количество узлов:
--     - в пустом дереве 0 узлов
--     - в узле: 1 (он сам) + узлы слева + узлы справа
--   Пример похожей функции — сумма (это следующая задача, A2):
--       sumTree Leaf         = 0
--       sumTree (Node x l r) = x + sumTree l + sumTree r
--   Значение x не нужно? Пиши  _  вместо имени:  (Node _ l r)
--
-- A1. Сколько в дереве узлов (Node)?
size :: Tree a -> Int
size Leaf = 0
size (Node _ l r) = 1 + size l + size r
-- main = print (size tree1)  -- 7
-- main = print (size tree3)  -- 4
-- main = print (size (Leaf :: Tree Int))  -- 0


-- >>> ТЕОРИЯ: сумма — пример выше в A1, просто перепиши его сам
--
-- A2. Сумма всех значений.
sumTree :: Tree Int -> Int
sumTree Leaf = 0
sumTree (Node x l r) = x + sumTree l + sumTree r
-- main = print (sumTree tree1)  -- 21
-- main = print (sumTree treeExample1)  -- 34
-- main = print (sumTree Leaf)  -- 0


-- >>> ТЕОРИЯ: дерево -> список (preorder = "сначала корень")
--   Порядок: КОРЕНЬ, потом всё левое, потом всё правое.
--   ++ склеивает списки:  [1] ++ [2,3] == [1,2,3]
--       preorder Leaf         = []
--       preorder (Node x l r) = [x] ++ preorder l ++ preorder r
--   Для tree1:  0, (1,3,4), (2,5,6)  ->  [0,1,3,4,2,5,6]
--
-- A3. Значения в порядке preorder.
preorder :: Tree a -> [a]
preorder Leaf = []
preorder (Node x l r) = [x] ++ preorder l ++ preorder r
-- main = print (preorder tree1)  -- [0,1,3,4,2,5,6]
-- main = print (preorder tree3)  -- [4,2,1,3]


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: inorder = "корень посередине"
--   Порядок: всё ЛЕВОЕ, потом КОРЕНЬ, потом всё ПРАВОЕ.
--       inorder (Node x l r) = inorder l ++ [x] ++ inorder r
--   Для tree1:  (3,1,4), 0, (5,2,6)  ->  [3,1,4,0,5,2,6]
--   (бывает ещё postorder: левое, правое, корень)
--
-- B1. Значения в порядке inorder.
inorder :: Tree a -> [a]
inorder Leaf = []
inorder (Node x l r) = inorder l ++ [x] ++ inorder r
-- main = print (inorder tree1)  -- [3,1,4,0,5,2,6]
-- main = print (inorder tree2)  -- [5,8,1,0,2]
-- main = print (inorder tree3)  -- [4,1,2,3]


-- >>> ТЕОРИЯ: высота — max из двух сторон
--   Высота = сколько узлов на самом длинном пути от корня вниз.
--       height Leaf = 0
--       height (Node _ l r) = 1 + max (height l) (height r)
--   max a b — большее из двух:  max 2 5 == 5
--
-- B2. Высота дерева.
height :: Tree a -> Int
height Leaf = 0
height (Node _ l r) = 1 + max (height l) (height r)
-- main = print (height tree1)  -- 3
-- main = print (height tree2)  -- 4
-- main = print (height (Leaf :: Tree Int))  -- 0


-- >>> ТЕОРИЯ: функция, которая СТРОИТ новое дерево
--   Ответ — тоже дерево. Собираем его конструктором Node:
--       f Leaf         = Leaf
--       f (Node x l r) = Node (новое x) (f l) (f r)
--   Зеркало: левое и правое меняются местами НА ВСЕХ уровнях,
--   поэтому сначала отражаем поддеревья, а потом ставим их наоборот:
--       Node x (mirror r) (mirror l)
--
-- B3. Зеркально отрази дерево (на всех уровнях).
mirror :: Tree a -> Tree a
mirror Leaf = Leaf
mirror (Node x l r) = Node x (mirror r) (mirror l)
-- main = print (mirror tree3)  -- Node 4 (Node 2 (Node 3 Leaf Leaf) (Node 1 Leaf Leaf)) Leaf
-- main = print (inorder (mirror tree1))  -- [6,2,5,0,4,1,3]


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ (задачи из sample)
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: смотри на ТЕСТЫ, а не только на картинку
--   На картинке в условии похоже на полное зеркало, но тесты показывают:
--   меняются местами только ДВА поддерева корня, глубже ничего не трогаем.
--       Node 1 (Node 2 ...) (Node 3 ...)  ->  Node 1 (Node 3 ...) (Node 2 ...)
--   Значит, рекурсия не нужна:
--       swapSubTree Leaf         = Leaf
--       swapSubTree (Node x l r) = Node x r l
--
-- C1 (endterm1 #6). Given a binary tree, swap its right and left sub-trees.
swapSubTree :: Tree a -> Tree a
swapSubTree Leaf = Leaf
swapSubTree (Node x l r) = Node x r l
-- main = print (swapSubTree (Node 99 (Node 3 Leaf Leaf) (Node (-2) Leaf Leaf)))  -- Node 99 (Node (-2) Leaf Leaf) (Node 3 Leaf Leaf)
-- main = print (swapSubTree (Node 1 (Node 2 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf)) (Node 3 Leaf (Node 6 (Node 7 Leaf Leaf) (Node 8 Leaf Leaf)))))  -- Node 1 (Node 3 Leaf (Node 6 (Node 7 Leaf Leaf) (Node 8 Leaf Leaf))) (Node 2 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf))
-- main = print (swapSubTree (Node 3 Leaf Leaf))  -- Node 3 Leaf Leaf
-- main = print (swapSubTree (Node "root" (Node "left" (Node "left-left" Leaf Leaf) (Node "left-right" Leaf Leaf)) (Node "right" Leaf (Node "right-right" Leaf Leaf))))  -- Node "root" (Node "right" Leaf (Node "right-right" Leaf Leaf)) (Node "left" (Node "left-left" Leaf Leaf) (Node "left-right" Leaf Leaf))


-- >>> ТЕОРИЯ: идём только влево + error
--   Самый левый узел: идём влево, пока слева есть узел.
--   Узел, у которого слева Leaf, — это и есть ответ.
--   Порядок уравнений важен: Haskell пробует их сверху вниз.
--       tr1 Leaf              = error "tree is empty"
--       tr1 (Node x Leaf _)   = x            -- слева пусто: нашли
--       tr1 (Node _ l _)      = tr1 l        -- иначе идём влево
--   Проверь на tree3: у корня 4 слева Leaf, значит ответ 4.
--
-- C2 (endterm2 #5). Find the left-most node value of a binary tree.
--   For leaves it should be an error with "tree is empty".
tr1 :: Tree a -> a
tr1 Leaf = error "tree is empty"
tr1 (Node x Leaf _) = x
tr1 (Node _ l _) = tr1 l
-- main = print (tr1 tree1)  -- 3
-- main = print (tr1 tree2)  -- 5
-- main = print (tr1 tree3)  -- 4
-- main = print (tr1 (Leaf :: Tree Int))  -- error: tree is empty


-- >>> ТЕОРИЯ: map по дереву
--   Как B3, только меняем значение: Node (f x) ...
--   f — функция-аргумент, её просто вызываем:  f x
--   Обрати внимание на порядок аргументов: сначала дерево, потом функция.
--
-- C3 (endterm2 #6). You are given a tree and a function.
--   Apply this function to every node of the tree.
tr2 :: Tree a -> (a -> a) -> Tree a
tr2 Leaf _ = Leaf
tr2 (Node x l r) f = Node (f x) (tr2 l f) (tr2 r f)
-- main = print (tr2 tree2 (+100))  -- Node 100 (Node 101 (Node 105 Leaf (Node 108 Leaf Leaf)) Leaf) (Node 102 Leaf Leaf)
-- main = print (tr2 tree2 (*5))  -- Node 0 (Node 5 (Node 25 Leaf (Node 40 Leaf Leaf)) Leaf) (Node 10 Leaf Leaf)
-- main = print (tr2 tree3 (\x -> (x `mod` 2) + 50))  -- Node 50 Leaf (Node 50 (Node 51 Leaf Leaf) (Node 51 Leaf Leaf))


-- >>> ТЕОРИЯ: ответ — пара
--   Самый простой путь — через список:
--       xs = preorder t                     (A3)
--       (sum (filter even xs), sum (filter odd xs))
--   Можно и рекурсией: разобрать пары слева и справа
--       let (e1, o1) = f l ...
--   но через список проще и надёжнее.
--
-- C4 (endterm3 #5). Take a tree of integers and return a tuple of two
--   integers: the sum of the even values and the sum of the odd values.
--   Leaf counts as 0.
evenSumOddSum :: Tree Int -> (Int, Int)
evenSumOddSum t = (sum (filter even xs), sum (filter odd xs))
  where
    xs = preorder t
-- main = print (evenSumOddSum Leaf)  -- (0,0)
-- main = print (evenSumOddSum (Node 11 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)))  -- (0,21)
-- main = print (evenSumOddSum treeExample1)  -- (18,16)
-- main = print (evenSumOddSum treeExample2)  -- (42,23)
-- main = print (evenSumOddSum (Node 10 (Node 8 (Node 7 (Node 11 Leaf Leaf) Leaf) (Node 6 Leaf Leaf)) (Node 5 Leaf (Node 7 Leaf Leaf))))  -- (24,30)
-- main = print (evenSumOddSum (Node 1 (Node 2 (Node 2 Leaf Leaf) (Node 2 Leaf Leaf)) (Node 5 (Node 3 (Node 1 Leaf Leaf) Leaf) (Node 4 Leaf Leaf))))  -- (10,10)


-- >>> ТЕОРИЯ: map по дереву с условиями
--   Это C3, только новое значение выбирается guards. Удобно вынести правило
--   для ОДНОГО числа в помощника (where):
--       change x | x `mod` n == 0 = -1
--                | x > n          = 0
--                | otherwise      = x
--   ПОРЯДОК ВАЖЕН: 10 делится на 5 И больше 5 — по тесту ответ -1,
--   значит проверка делимости должна стоять первой.
--
-- C5 (endterm3 #6). Given an integer n and a binary tree, modify the nodes:
--   replace the value with -1 if it is divisible by n,
--   replace the value with 0 if it is greater than n,
--   retain the original value otherwise.
replaceNodes :: Int -> Tree Int -> Tree Int
replaceNodes _ Leaf = Leaf
replaceNodes n (Node x l r) = Node (change x) (replaceNodes n l) (replaceNodes n r)
  where
    change v
      | v `mod` n == 0 = -1
      | v > n = 0
      | otherwise = v
-- main = print (replaceNodes 5 treeExample1)  -- Node (-1) (Node 3 (Node 0 Leaf Leaf) (Node 2 Leaf Leaf)) (Node (-1) (Node 0 Leaf Leaf) (Node 1 Leaf Leaf))
-- main = print (replaceNodes 5 treeExample2)  -- Node 0 (Node 3 (Node 0 Leaf Leaf) (Node 2 Leaf Leaf)) (Node (-1) (Node (-1) Leaf Leaf) (Node (-1) Leaf Leaf))


-- Данные для C6 (как в endterm4). У Team нет Eq — сравниваем teamID.
data Team = Team {teamName :: String, teamID :: Int} deriving (Show)

data Player = Player {playerID :: Int, playerName :: String, playerTeam :: Team, playerScores :: [Int]} deriving (Show)

team1 = Team {teamName = "Team A", teamID = 1}
team2 = Team {teamName = "Team B", teamID = 2}
team3 = Team {teamName = "Team C", teamID = 3}
team0 = Team {teamName = "Team C", teamID = 3}

player1 = Player {playerID = 1, playerName = "Alice", playerTeam = team1, playerScores = [10, 20, 30]}
player2 = Player {playerID = 2, playerName = "Bob", playerTeam = team1, playerScores = [15, 25, 35]}
player3 = Player {playerID = 3, playerName = "Charlie", playerTeam = team2, playerScores = [12, 22, 32]}
player4 = Player {playerID = 4, playerName = "David", playerTeam = team2, playerScores = [18, 28, 38]}
player5 = Player {playerID = 5, playerName = "Eve", playerTeam = team3, playerScores = [14, 24, 34]}
player6 = Player {playerID = 6, playerName = "Frank", playerTeam = team3, playerScores = [16, 26, 36]}

--            player1
--           /       \
--      player2      player4
--          \        /     \
--        player3  player5  player6
tree :: Tree Player
tree = Node player1 (Node player2 Leaf (Node player3 Leaf Leaf)) (Node player4 (Node player5 Leaf Leaf) (Node player6 Leaf Leaf))

-- >>> ТЕОРИЯ: дерево records -> список -> фильтр
--   1) preorder tree даёт игроков в порядке p1, p2, p3, p4, p5, p6
--      (именно preorder! inorder дал бы Bob раньше Alice — тест не пройдёт)
--   2) дальше обычный comprehension по списку records (как в 02_records):
--       [(playerID p, playerName p) | p <- preorder t, teamID (playerTeam p) == teamID tm]
--
-- C6 (endterm4 #4). Given a binary tree of Player records, extract all players
--   who belong to a specific Team. Return a list of tuples (player ID, name).
playersFromTeam :: Team -> Tree Player -> [(Int, String)]
playersFromTeam tm t = [(playerID p, playerName p) | p <- preorder t, teamID (playerTeam p) == teamID tm]
-- main = print (playersFromTeam team1 tree)  -- [(1,"Alice"),(2,"Bob")]
-- main = print (playersFromTeam team2 tree)  -- [(3,"Charlie"),(4,"David")]
-- main = print (playersFromTeam team3 tree)  -- [(5,"Eve"),(6,"Frank")]
-- main = print (playersFromTeam team0 tree)  -- [(5,"Eve"),(6,"Frank")]


-- >>> ТЕОРИЯ: палиндром
--   Строка — палиндром, если читается одинаково с обеих сторон:
--       s == reverse s           reverse "abc" == "cba"
--   Дерево Char -> String: inorder (B1) у Tree Char даёт [Char], то есть String.
--
-- C7 (endterm4 #6). You are given a tree of Char. Convert it to a string
--   traversing inorder and check if the string is a palindrome.
--   Leaf is an empty string.
isPaliTree :: Tree Char -> Bool
isPaliTree t = s == reverse s
  where
    s = inorder t
-- main = print (isPaliTree (Node 'd' (Node 'm' Leaf (Node 'a' Leaf Leaf)) (Node 'a' Leaf (Node 'm' Leaf Leaf))))  -- True
-- main = print (isPaliTree (Node 'a' (Node 'a' (Node 'b' Leaf Leaf) (Node 'n' Leaf Leaf)) (Node 'n' Leaf (Node 'a' Leaf Leaf))))  -- False
-- main = print (isPaliTree (Node 'e' (Node 'a' (Node 'r' Leaf Leaf) (Node 'c' Leaf Leaf)) (Node 'a' (Node 'c' Leaf Leaf) (Node 'r' Leaf Leaf))))  -- True
-- main = print (isPaliTree (Node 'c' (Node 'b' (Node 'a' Leaf Leaf) Leaf) (Node 'd' (Node 'c' Leaf Leaf) (Node 'a' Leaf Leaf))))  -- False
