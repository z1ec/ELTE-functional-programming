-- Week 10 — In-class tasks: trees
--
-- Replace every `undefined` with your solution.
--
-- How to test:
--   runghc  Remove the "-- " in front of ONE "main = print ..." line, save the file,
--           and run   runghc tasks.hs   in the terminal.
--           The value after the last "--" on that line is the expected output.
--           Only one main can be active at a time.
--   GHCi    Run   ghci tasks.hs   and type any expression, e.g. the part inside print ( ).
--           After editing the file, type  :r  to reload it.
--
-- Today's tools: the tree recipe, a level parameter, patterns that look at the children, valueOf.
--   f Leaf         = the answer for the empty tree
--   f (Node x l r) = combine  x,  f l  and  f r
-- Draw the tree on paper first!

data Tree a = Node a (Tree a) (Tree a)
            | Leaf
            deriving (Show)

--          6
--        /   \
--       2     7
--      / \   / \
--    -1   4 3   10
ta :: Tree Int
ta = Node 6 (Node 2 (Node (-1) Leaf Leaf) (Node 4 Leaf Leaf)) (Node 7 (Node 3 Leaf Leaf) (Node 10 Leaf Leaf))

--          'h'
--         /   \
--       'a'   's'
--        \
--        'k'
tb :: Tree Char
tb = Node 'h' (Node 'a' Leaf (Node 'k' Leaf Leaf)) (Node 's' Leaf Leaf)

------------------------------------------------------------------------
-- Given (from the demo)
------------------------------------------------------------------------

preorder :: Tree a -> [a]
preorder Leaf         = []
preorder (Node x l r) = [x] ++ preorder l ++ preorder r

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree _ Leaf         = Leaf
mapTree f (Node x l r) = Node (f x) (mapTree f l) (mapTree f r)

valueOf :: Tree Int -> Int
valueOf Leaf         = 0
valueOf (Node x _ _) = x

------------------------------------------------------------------------
-- Task 1
-- The product of all values. The product of the empty tree is 1.
------------------------------------------------------------------------

productTree :: Tree Int -> Int
productTree t = undefined

-- main = print (productTree (Node 2 (Node 3 Leaf Leaf) (Node 4 Leaf Leaf)))  -- 24
-- main = print (productTree ta)                                              -- -10080
-- main = print (productTree Leaf)                                            -- 1

------------------------------------------------------------------------
-- Task 2
-- The rightmost value. For the empty tree: error "Empty tree".
------------------------------------------------------------------------

rightmost :: Tree a -> a
rightmost t = undefined

-- main = print (rightmost ta)  -- 10
-- main = print (rightmost tb)  -- 's'

------------------------------------------------------------------------
-- Task 3
-- How many values are greater than k?
------------------------------------------------------------------------

countGreater :: Int -> Tree Int -> Int
countGreater k t = undefined

-- main = print (countGreater 3 ta)    -- 4
-- main = print (countGreater 100 ta)  -- 0
-- main = print (countGreater 0 Leaf)  -- 0

------------------------------------------------------------------------
-- Task 4
-- Swap the left and right subtree, but ONLY at the nodes whose value is even.
------------------------------------------------------------------------

mirrorEven :: Tree Int -> Tree Int
mirrorEven t = undefined

-- main = print (mirrorEven (Node 2 (Node 1 Leaf Leaf) (Node 3 Leaf Leaf)))  -- Node 2 (Node 3 Leaf Leaf) (Node 1 Leaf Leaf)
-- main = print (mirrorEven (Node 1 (Node 2 Leaf Leaf) (Node 3 Leaf Leaf)))  -- Node 1 (Node 2 Leaf Leaf) (Node 3 Leaf Leaf)
-- main = print (preorder (mirrorEven ta))                                   -- [6,7,3,10,2,4,-1]

------------------------------------------------------------------------
-- Task 5
-- How many nodes are on level k? (The root is on level 1.)
------------------------------------------------------------------------

countAtLevel :: Int -> Tree a -> Int
countAtLevel k t = undefined

-- main = print (countAtLevel 3 ta)  -- 4
-- main = print (countAtLevel 3 tb)  -- 1
-- main = print (countAtLevel 7 ta)  -- 0

------------------------------------------------------------------------
-- Task 6
-- The values of the nodes that have exactly ONE child (one subtree is Leaf, the other is not).
------------------------------------------------------------------------

oneChild :: Tree a -> [a]
oneChild t = undefined

-- main = print (oneChild tb)                                -- "a"
-- main = print (oneChild ta)                                -- []
-- main = print (oneChild (Node 1 (Node 2 Leaf Leaf) Leaf))  -- [1]
-- main = print (null (oneChild (Node 'a' Leaf Leaf)))       -- True

------------------------------------------------------------------------
-- Task 7
-- If the sum of the two children's values is NEGATIVE, the node's value becomes -1.
-- Otherwise the value stays. (Leaf counts as 0.)
------------------------------------------------------------------------

markNegative :: Tree Int -> Tree Int
markNegative t = undefined

-- main = print (markNegative (Node 10 (Node (-5) Leaf Leaf) (Node (-3) Leaf Leaf)))                          -- Node (-1) (Node (-5) Leaf Leaf) (Node (-3) Leaf Leaf)
-- main = print (preorder (markNegative (Node 4 (Node 2 (Node (-9) Leaf Leaf) Leaf) (Node (-3) Leaf Leaf))))  -- [-1,-1,-9,-3]

------------------------------------------------------------------------
-- Task 8★
-- (the sum of the even values, the sum of the odd values). The empty tree: (0, 0).
------------------------------------------------------------------------

evenOddSums :: Tree Int -> (Int, Int)
evenOddSums t = undefined

-- main = print (evenOddSums ta)                                               -- (22,9)
-- main = print (evenOddSums (Node 11 (Node 3 Leaf Leaf) (Node 7 Leaf Leaf)))  -- (0,21)
-- main = print (evenOddSums Leaf)                                             -- (0,0)

------------------------------------------------------------------------
-- Task 9★
-- Replace the values by these rules:  negative -> 0,  more than 5 -> 5,  otherwise it stays.
------------------------------------------------------------------------

clamp :: Tree Int -> Tree Int
clamp t = undefined

-- main = print (clamp ta)             -- Node 5 (Node 2 (Node 0 Leaf Leaf) (Node 4 Leaf Leaf)) (Node 5 (Node 3 Leaf Leaf) (Node 5 Leaf Leaf))
-- main = print (preorder (clamp ta))  -- [5,2,0,4,5,3,5]
