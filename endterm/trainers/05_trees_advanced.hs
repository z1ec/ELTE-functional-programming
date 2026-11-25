-- ============================================================================
-- 05. ДЕРЕВЬЯ: ПОСЛОЖНЕЕ  (дети узла, глубина, дерево выражений, дерево поиска)
-- ============================================================================
-- ТРЕНАЖЁР. Решения лежат в ../solutions/05_trees_advanced.hs (открывай только после своей попытки)
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/05_trees_advanced.hs
--   * Сначала пройди 04_trees_basic.hs — здесь используется тот же рецепт.
--
-- Задачи из sample в этом файле:
--   endterm1 #7 evaluate (дерево выражения -> строка)
--   endterm2 #7 changeTree, #8 Eq для дерева поиска (BST)
--   endterm4 #5 trim
-- Из syllabus: дерево поиска (BST): вставка, поиск, сортировка деревом.

data Tree a = Node a (Tree a) (Tree a) | Leaf deriving (Show)

-- Рецепт (повторение):
--     f Leaf         = ответ для пустого дерева
--     f (Node x l r) = собрать из  x,  f l,  f r

--          0
--        /   \
--       1     2
--      / \   / \
--     3   4 5   6
tree1 :: Tree Int
tree1 = Node 0 (Node 1 (Node 3 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 2 (Node 5 Leaf Leaf) (Node 6 Leaf Leaf))

--       4
--        \
--         2
--        / \
--       1   3
tree3 :: Tree Int
tree3 = Node 4 Leaf (Node 2 (Node 1 Leaf Leaf) (Node 3 Leaf Leaf))

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: значение корня, а у Leaf — 0
--   Не рекурсия, а просто два случая:
--       valueOf Leaf         = 0
--       valueOf (Node x _ _) = x
--   Это помощник, чтобы смотреть на значения ДЕТЕЙ узла (нужно в C1).
--
-- A1. Значение в корне (у пустого дерева — 0).
valueOf :: Tree Int -> Int
valueOf = undefined
-- main = print (valueOf tree1)  -- 0
-- main = print (valueOf (Node 7 Leaf Leaf))  -- 7
-- main = print (valueOf Leaf)  -- 0


-- >>> ТЕОРИЯ: образец, который смотрит на детей
--   Узел без детей выглядит так:  Node x Leaf Leaf
--   Такое уравнение ставим ПЕРЕД общим случаем:
--       leaves Leaf              = []
--       leaves (Node x Leaf Leaf) = [x]
--       leaves (Node _ l r)      = leaves l ++ leaves r
--
-- A2. Значения узлов, у которых нет детей (слева направо).
leaves :: Tree a -> [a]
leaves = undefined
-- main = print (leaves tree1)  -- [3,4,5,6]
-- main = print (leaves tree3)  -- [1,3]


-- >>> ТЕОРИЯ: дерево выражения
--   Выражение 1 + 2 * 3 можно хранить деревом:
--          Add                 Add (Num 1) (Mul (Num 2) (Num 3))
--         /   \
--       Num1  Mul
--             /  \
--          Num2  Num3
--   Считаем тем же рецептом, только у каждого конструктора своё уравнение:
--       calc (Num n)   = n
--       calc (Add a b) = calc a + calc b
--       calc (Mul a b) = ...
data Expr = Num Int | Add Expr Expr | Mul Expr Expr deriving (Show)

-- A3. Посчитай значение выражения.
calc :: Expr -> Int
calc = undefined
-- main = print (calc (Add (Num 1) (Mul (Num 2) (Num 3))))  -- 7
-- main = print (calc (Mul (Add (Num 1) (Num 2)) (Num 4)))  -- 12
-- main = print (calc (Num 5))  -- 5


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: параметр-счётчик уровня
--   Корень — уровень 1, его дети — уровень 2 и т.д.
--   Идея: спускаясь вниз, УМЕНЬШАЕМ номер нужного уровня.
--       atLevel _ Leaf         = []
--       atLevel 1 (Node x _ _) = [x]                 -- дошли до нужного уровня
--       atLevel n (Node _ l r) = atLevel (n-1) l ++ atLevel (n-1) r
--
-- B1. Значения на уровне n (слева направо).
atLevel :: Int -> Tree a -> [a]
atLevel = undefined
-- main = print (atLevel 1 tree1)  -- [0]
-- main = print (atLevel 3 tree1)  -- [3,4,5,6]
-- main = print (atLevel 3 tree3)  -- [1,3]
-- main = print (atLevel 5 tree1)  -- []


-- >>> ТЕОРИЯ: дерево поиска (BST)
--   В BST для каждого узла x: всё слева МЕНЬШЕ x, всё справа БОЛЬШЕ x.
--          5
--         / \        inorder даёт числа ПО ВОЗРАСТАНИЮ: [2,5,8]
--        2   8
--   Вставка: сравниваем с корнем и идём в нужную сторону,
--   а в пустом месте создаём новый узел:
--       bstInsert v Leaf = Node v Leaf Leaf
--       bstInsert v (Node x l r)
--         | v < x     = Node x (bstInsert v l) r
--         | v > x     = Node x l (bstInsert v r)
--         | otherwise = Node x l r                 -- такое число уже есть
--
-- B2. Вставь число в дерево поиска.
bstInsert :: Int -> Tree Int -> Tree Int
bstInsert = undefined
-- main = print (bstInsert 3 (Node 5 Leaf Leaf))  -- Node 5 (Node 3 Leaf Leaf) Leaf
-- main = print (bstInsert 7 (Node 5 (Node 3 Leaf Leaf) Leaf))  -- Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)
-- main = print (bstInsert 5 (Node 5 Leaf Leaf))  -- Node 5 Leaf Leaf


-- >>> ТЕОРИЯ: поиск в BST
--   Тот же выбор стороны, что в B2, но ответ — Bool.
--   В пустом дереве числа нет: False. Совпало с корнем: True.
--   Иначе идём ТОЛЬКО в одну сторону (поэтому поиск быстрый).
--
-- B3. Есть ли число в дереве поиска?
bstMember :: Int -> Tree Int -> Bool
bstMember = undefined
-- main = print (bstMember 7 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)))  -- True
-- main = print (bstMember 4 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)))  -- False
-- main = print (bstMember 1 Leaf)  -- False


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: смотрим на значения детей
--   Сумма детей узла (Node x l r):   valueOf l + valueOf r    (A1, Leaf = 0)
--   Если она < 0, значение узла заменяем на -1, иначе оставляем x.
--   Потом так же обрабатываем поддеревья:
--       changeTree Leaf = Leaf
--       changeTree (Node x l r)
--         | valueOf l + valueOf r < 0 = Node (-1) (changeTree l) (changeTree r)
--         | otherwise                 = Node x    (changeTree l) (changeTree r)
--   (Детей сравниваем по ИСХОДНЫМ значениям — тесты это допускают.)
--
-- C1 (endterm2 #7). For each node, calculate the sum of its direct children
--   (left and right). If the sum is negative, set the node's value to -1.
--   Otherwise, leave the value unchanged. Leaves' value is considered 0.
changeTree :: Tree Int -> Tree Int
changeTree = undefined
-- main = print (changeTree Leaf)  -- Leaf
-- main = print (changeTree (Node 3 Leaf Leaf))  -- Node 3 Leaf Leaf
-- main = print (changeTree (Node 10 (Node (-5) Leaf Leaf) (Node (-6) Leaf Leaf)))  -- Node (-1) (Node (-5) Leaf Leaf) (Node (-6) Leaf Leaf)
-- main = print (changeTree (Node 5 (Node 10 (Node 1 Leaf Leaf) (Node (-1) Leaf Leaf)) (Node 3 Leaf (Node (-8) Leaf Leaf))))  -- Node 5 (Node 10 (Node 1 Leaf Leaf) (Node (-1) Leaf Leaf)) (Node (-1) Leaf (Node (-8) Leaf Leaf))


-- >>> ТЕОРИЯ: обрезать по глубине — счётчик, как в B1
--   Помощник с параметром "сколько уровней ещё можно оставить":
--       cut 0 _            = Leaf                   -- больше нельзя: обрезаем
--       cut _ Leaf         = Leaf
--       cut k (Node x l r) = Node x (cut (k-1) l) (cut (k-1) r)
--   trim t = cut 3 t
--   (помощника пиши в where или отдельной функцией)
--
-- C2 (endterm4 #5). Keep the height of trees under 3: take a tree of integers
--   and trim out the branches that grow beyond the depth of 3.
--   (Leaf does not count as a branch.)
--   Before:      j            After:      j
--               / \                      / \
--              b   l                    b   l
--             /   / \                  /   / \
--            d   e   c                d   e   c
--               / \
--              m   f   ...
trim :: Tree Integer -> Tree Integer
trim = undefined
-- main = print (trim (Node 1 (Node 2 (Node 4 Leaf Leaf) (Node 5 (Node 7 Leaf Leaf) Leaf)) (Node 3 (Node 6 (Node 8 (Node 9 Leaf Leaf) Leaf) Leaf) Leaf)))  -- Node 1 (Node 2 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf)) (Node 3 (Node 6 Leaf Leaf) Leaf)
-- main = print (trim (Node 1 (Node 2 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf)) (Node 3 (Node 6 Leaf Leaf) Leaf)))  -- Node 1 (Node 2 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf)) (Node 3 (Node 6 Leaf Leaf) Leaf)
-- main = print (trim (Node 1 (Node 2 Leaf Leaf) (Node 3 Leaf Leaf)))  -- Node 1 (Node 2 Leaf Leaf) (Node 3 Leaf Leaf)
-- main = print (trim (Node 1 Leaf Leaf))  -- Node 1 Leaf Leaf
-- main = print (trim Leaf)  -- Leaf


-- >>> ТЕОРИЯ: дерево выражения -> строка
--   Как calc из A3, только вместо + склеиваем строки через ++:
--       showExpr (Num n)   = show n                 -- show 5 == "5"
--       showExpr (Add a b) = "(" ++ showExpr a ++ "+" ++ showExpr b ++ ")"
--   Каждая операция в своих скобках, пробелов нет.
--
-- C3 (exam-like). Convert an Expr into a string with parentheses.
showExpr :: Expr -> String
showExpr = undefined
-- main = print (showExpr (Add (Num 1) (Mul (Num 2) (Num 3))))  -- "(1+(2*3))"
-- main = print (showExpr (Num 42))  -- "42"


-- >>> ТЕОРИЯ: то же самое, но оператор лежит В УЗЛЕ строкой
--   data ExpressionTree a = Operand a | Operator a (ExpressionTree a) (ExpressionTree a)
--     Operand "10"                      — лист-число (уже строка!)
--     Operator "+" левое правое         — операция
--   Значит:
--       evaluate (Operand x)      = x                 -- show НЕ нужен, это уже String
--       evaluate (Operator op a b) = "(" ++ evaluate a ++ op ++ evaluate b ++ ")"
--   В условии на экзамене строки с пробелами, а в тестах без пробелов —
--   делай по тестам.
data ExpressionTree a = Operand a | Operator a (ExpressionTree a) (ExpressionTree a) deriving (Show)

-- C4 (endterm1 #7). Write an "evaluate" function which takes an ExpressionTree
--   and returns a string representation of the arithmetic expression in infix
--   notation, with parentheses to denote the order of operations.
evaluate :: ExpressionTree String -> String
evaluate = undefined
-- main = print (evaluate (Operator "+" (Operator "*" (Operand "10") (Operand "9")) (Operator "*" (Operator "-" (Operand "3") (Operand "4")) (Operand "5"))))  -- "((10*9)+((3-4)*5))"
-- main = print (evaluate (Operator "+" (Operand "10") (Operand "20")))  -- "(10+20)"
-- main = print (evaluate (Operator "*" (Operator "+" (Operand "1") (Operand "2")) (Operator "-" (Operand "4") (Operand "3"))))  -- "((1+2)*(4-3))"
-- main = print (evaluate (Operand "2"))  -- "2"


-- >>> ТЕОРИЯ: сортировка деревом
--   1) вставляем все числа по очереди в пустое дерево (B2)
--   2) inorder BST даёт их по возрастанию
--   Построить дерево из списка рекурсией:
--       build []     = Leaf
--       build (x:xs) = bstInsert x (build xs)
--   inorder (напиши сам или в where):
--       toList Leaf = []
--       toList (Node x l r) = toList l ++ [x] ++ toList r
--   (повторы пропадают — bstInsert их не вставляет)
--
-- C5 (syllabus: sort). Sort a list using a binary search tree.
treeSort :: [Int] -> [Int]
treeSort = undefined
-- main = print (treeSort [5, 2, 8, 1, 9, 3])  -- [1,2,3,5,8,9]
-- main = print (treeSort [3, 3, 1])  -- [1,3]
-- main = print (treeSort [])  -- []


-- >>> ТЕОРИЯ: свой Eq для дерева (подробнее про instance — в 08_eq_instances.hs)
--   instance Eq a => Eq (Tree a) where
--     t1 == t2 = ...
--   "Eq a =>" значит: значения внутри тоже можно сравнивать.
--   Два BST с ОДИНАКОВЫМИ значениями могут иметь разную форму,
--   но inorder у обоих даст один и тот же отсортированный список.
--   Значит:  t1 == t2 = inorder t1 == inorder t2
--   (inorder напиши в where, как toList в C5)
--
-- C6 (endterm2 #8). Implement the Eq instance for an integer Binary Search Tree.
--   Two binary search trees are equal if they have exactly the same node values.
instance Eq a => Eq (Tree a) where
  t1 == t2 = undefined

tree00, tree11, tree22, tree33 :: Tree Int
tree00 = Node 10 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)) (Node 15 (Node 12 (Node 11 Leaf Leaf) Leaf) (Node 20 Leaf Leaf))
tree11 = Node 10 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)) (Node 15 (Node 12 Leaf Leaf) (Node 20 Leaf Leaf))
tree22 = Node 10 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)) (Node 15 (Node 12 Leaf Leaf) (Node 20 Leaf Leaf))
tree33 = Node 10 (Node 5 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)) (Node 12 (Node 11 Leaf Leaf) (Node 15 Leaf (Node 20 Leaf Leaf)))

-- main = print (tree11 == tree22)  -- True
-- main = print (tree00 == tree33)  -- True
-- main = print (tree11 == tree33)  -- False
