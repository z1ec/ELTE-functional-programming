-- Week 10 — Demo: trees
--
-- Replace every `undefined` with your solution.
--
-- How to test:
--   runghc  Remove the "-- " in front of ONE "main = print ..." line, save the file,
--           and run   runghc demo.hs   in the terminal.
--           The value after the last "--" on that line is the expected output.
--           Only one main can be active at a time.
--   GHCi    Run   ghci demo.hs   and type any expression, e.g. the part inside print ( ).
--           After editing the file, type  :r  to reload it.

------------------------------------------------------------------------
-- Part 0: a list as our own data type
------------------------------------------------------------------------

-- A list is empty, or one element in front of a (shorter) list. The type has ITSELF inside.
data List a = Empty | Cons a (List a)
  deriving (Show)

myList :: List Int
myList = Cons 1 (Cons 2 (Cons 3 Empty))

-- The number of elements of our list.
-- The same recipe as week 3: one equation for Empty, one for Cons (with recursion on the rest).
lengthL :: List a -> Int
lengthL Empty = 0
lengthL (Cons _ rest) = 1 + lengthL rest

-- main = print (lengthL myList)  -- 3

------------------------------------------------------------------------
-- Part 1: a binary tree. A node has a value and TWO subtrees.
------------------------------------------------------------------------

data Tree a = Node a (Tree a) (Tree a)
            | Leaf
            deriving (Show)

--          5
--        /   \
--       3     8
--      / \     \
--     1   4     9
t1 :: Tree Int
t1 = Node 5 (Node 3 (Node 1 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 8 Leaf (Node 9 Leaf Leaf))

t2 :: Tree String
t2 = Node "root" (Node "left" Leaf Leaf) Leaf

-- THE RECIPE for (almost) every tree function:
--   f Leaf         = the answer for the empty tree
--   f (Node x l r) = combine  x,  f l  and  f r

-- How many values are in the tree?
size :: Tree a -> Int
size Leaf = 0
size (Node _ l r) = 1 + size l + size r

-- main = print (size t1)    -- 6
-- main = print (size t2)    -- 2
-- main = print (size Leaf)  -- 0

-- The sum of all values in the tree.
sumTree :: Tree Int -> Int
sumTree Leaf = 0
sumTree (Node x l r) = x + sumTree l + sumTree r

-- main = print (sumTree t1)  -- 30

-- The number of levels. The root is on level 1, so a single node has height 1.
height :: Tree a -> Int
height Leaf = 0
height (Node _ l r) = 1 + max (height l) (height r)

-- main = print (height t1)                    -- 3
-- main = print (height (Node 'x' Leaf Leaf))  -- 1

-- All values as a list: left subtree, then the value, then the right subtree ("in-order").
inorder :: Tree a -> [a]
inorder Leaf = []
inorder (Node x l r) = inorder l ++ [x] ++ inorder r

-- main = print (inorder t1)  -- [1,3,4,5,8,9]
-- main = print (inorder t2)  -- ["left","root"]

-- The value first, then the subtrees ("pre-order").
preorder :: Tree a -> [a]
preorder Leaf = []
preorder (Node x l r) = [x] ++ preorder l ++ preorder r

-- main = print (preorder t1)  -- [5,3,1,4,8,9]

-- The leftmost value: go left while you can. The empty tree has none: error "Empty tree".
leftmost :: Tree a -> a
leftmost Leaf = error "Empty tree"
leftmost (Node x Leaf _) = x
leftmost (Node _ l _) = leftmost l

-- main = print (leftmost t1)  -- 1
-- main = print (leftmost t2)  -- "left"

-- Is the value y somewhere in the tree?
contains :: Int -> Tree Int -> Bool
contains _ Leaf = False
contains y (Node x l r) = x == y || contains y l || contains y r

-- main = print (contains 4 t1)  -- True
-- main = print (contains 7 t1)  -- False

-- The same tree, with f applied to every value (like map for lists).
mapTree :: (a -> b) -> Tree a -> Tree b
mapTree _ Leaf = Leaf
mapTree f (Node x l r) = Node (f x) (mapTree f l) (mapTree f r)

-- main = print (mapTree (* 10) t1)            -- Node 50 (Node 30 (Node 10 Leaf Leaf) (Node 40 Leaf Leaf)) (Node 80 Leaf (Node 90 Leaf Leaf))
-- main = print (inorder (mapTree (* 10) t1))  -- [10,30,40,50,80,90]
-- main = print (mapTree length t2)            -- Node 4 (Node 4 Leaf Leaf) Leaf

-- The mirror image: left and right swapped at every node.
mirror :: Tree a -> Tree a
mirror Leaf = Leaf
mirror (Node x l r) = Node x (mirror r) (mirror l)

-- main = print (mirror t1)            -- Node 5 (Node 8 (Node 9 Leaf Leaf) Leaf) (Node 3 (Node 4 Leaf Leaf) (Node 1 Leaf Leaf))
-- main = print (inorder (mirror t1))  -- [9,8,5,4,3,1]

-- The sum of the values and the number of values, as a pair (sum, size), in ONE walk through the tree.
-- Take both results of the subtrees apart in a where.
sumAndSize :: Tree Int -> (Int, Int)
sumAndSize Leaf = (0, 0)
sumAndSize (Node x l r) = (x + sl + sr, 1 + nl + nr)
  where
    (sl, nl) = sumAndSize l
    (sr, nr) = sumAndSize r

-- main = print (sumAndSize t1)    -- (30,6)
-- main = print (sumAndSize Leaf)  -- (0,0)

------------------------------------------------------------------------
-- Part 2: a level parameter, looking at the children, "Leaf counts as 0"
------------------------------------------------------------------------

-- 2.1 The values on level k, from left to right. The root is on level 1.
-- From the subtree's point of view the level is one less.
atLevel :: Int -> Tree a -> [a]
atLevel _ Leaf = []
atLevel k (Node x l r)
  | k == 1 = [x]
  | otherwise = atLevel (k - 1) l ++ atLevel (k - 1) r

-- main = print (atLevel 2 t1)  -- [3,8]
-- main = print (atLevel 3 t1)  -- [1,4,9]
-- main = print (atLevel 9 t1)  -- []

-- 2.2 The values in the nodes with no children (both subtrees are Leaf), from left to right.
-- The patterns are tried from the top, so the most special one comes first.
leaves :: Tree a -> [a]
leaves Leaf = []
leaves (Node x Leaf Leaf) = [x]
leaves (Node _ l r) = leaves l ++ leaves r

-- main = print (leaves t1)  -- [1,4,9]
-- main = print (leaves t2)  -- ["left"]

-- 2.3 The value at the top of a tree; for the empty tree 0. A helper for tasks that say "Leaf counts as 0".
valueOf :: Tree Int -> Int
valueOf Leaf = 0
valueOf (Node x _ _) = x

-- Every value becomes the sum of the values of its two children (Leaf counts as 0). The shape stays the same.
childSums :: Tree Int -> Tree Int
childSums Leaf = Leaf
childSums (Node _ l r) = Node (valueOf l + valueOf r) (childSums l) (childSums r)

-- main = print (childSums t1)             -- Node 11 (Node 5 (Node 0 Leaf Leaf) (Node 0 Leaf Leaf)) (Node 9 Leaf (Node 0 Leaf Leaf))
-- main = print (preorder (childSums t1))  -- [11,5,0,0,9,0]
