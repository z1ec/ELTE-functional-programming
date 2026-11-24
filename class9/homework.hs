-- Week 10 — Homework: trees
--
-- Replace every `undefined` with your solution.
--
-- How to test:
--   runghc  Remove the "-- " in front of ONE "main = print ..." line, save the file,
--           and run   runghc homework.hs   in the terminal.
--           The value after the last "--" on that line is the expected output.
--           Only one main can be active at a time.
--   GHCi    Run   ghci homework.hs   and type any expression, e.g. the part inside print ( ).
--           After editing the file, type  :r  to reload it.
--
-- Draw the example trees on paper before you start. Helpers are allowed everywhere.

------------------------------------------------------------------------
-- Part 1: our own list
------------------------------------------------------------------------

data List a = Empty | Cons a (List a)
  deriving (Show)

------------------------------------------------------------------------
-- 1. Turn our own list into a Haskell list.
--      toList (Cons 1 (Cons 2 Empty)) = [1,2]
------------------------------------------------------------------------

toList :: List a -> [a]
toList xs = undefined

-- main = print (toList (Cons 1 (Cons 2 (Cons 3 Empty))))  -- [1,2,3]
-- main = print (toList (Cons 'h' (Cons 'i' Empty)))       -- "hi"
-- main = print (null (toList Empty))                      -- True

------------------------------------------------------------------------
-- Part 2: trees of numbers
------------------------------------------------------------------------

data Tree a = Node a (Tree a) (Tree a)
            | Leaf
            deriving (Show)

--           8
--         /   \
--        3     10
--       / \      \
--      1   6      14
--         / \    /
--        4   7  13
tree1 :: Tree Int
tree1 = Node 8 (Node 3 (Node 1 Leaf Leaf) (Node 6 (Node 4 Leaf Leaf) (Node 7 Leaf Leaf)))
               (Node 10 Leaf (Node 14 (Node 13 Leaf Leaf) Leaf))

--       2
--      / \
--    -5   9
tree2 :: Tree Int
tree2 = Node 2 (Node (-5) Leaf Leaf) (Node 9 Leaf Leaf)

------------------------------------------------------------------------
-- 2. The largest value of the tree. For the empty tree: error "Empty tree".
------------------------------------------------------------------------

maxTree :: Tree Int -> Int
maxTree t = undefined

-- main = print (maxTree tree1)                  -- 14
-- main = print (maxTree tree2)                  -- 9
-- main = print (maxTree (Node (-3) Leaf Leaf))  -- -3

------------------------------------------------------------------------
-- 3. The values that are at least k, in this order: left subtree, value, right subtree.
------------------------------------------------------------------------

atLeast :: Int -> Tree Int -> [Int]
atLeast k t = undefined

-- main = print (atLeast 7 tree1)    -- [7,8,10,13,14]
-- main = print (atLeast 0 tree2)    -- [2,9]
-- main = print (atLeast 100 tree1)  -- []

------------------------------------------------------------------------
-- 4. Every value smaller than k becomes 0. The others stay.
------------------------------------------------------------------------

zeroSmall :: Int -> Tree Int -> Tree Int
zeroSmall k t = undefined

-- main = print (zeroSmall 3 tree2)                             -- Node 0 (Node 0 Leaf Leaf) (Node 9 Leaf Leaf)
-- main = print (zeroSmall 5 (Node 3 (Node 8 Leaf Leaf) Leaf))  -- Node 0 (Node 8 Leaf Leaf) Leaf
-- main = print (zeroSmall 1 Leaf)                              -- Leaf

------------------------------------------------------------------------
-- 5. The values on the way from the root, always going to the LEFT, until the end.
--      leftPath tree1 = [8,3,1]
------------------------------------------------------------------------

leftPath :: Tree a -> [a]
leftPath t = undefined

-- main = print (leftPath tree1)                                 -- [8,3,1]
-- main = print (leftPath (Node 'a' Leaf (Node 'b' Leaf Leaf)))  -- "a"
-- main = print (null (leftPath Leaf))                           -- True

------------------------------------------------------------------------
-- 6. Keep only the first k levels of the tree (the root is on level 1). For k <= 0 the result is Leaf.
------------------------------------------------------------------------

trim :: Int -> Tree a -> Tree a
trim k t = undefined

-- main = print (trim 2 tree1)  -- Node 8 (Node 3 Leaf Leaf) (Node 10 Leaf Leaf)
-- main = print (trim 1 tree2)  -- Node 2 Leaf Leaf
-- main = print (trim 0 tree2)  -- Leaf

------------------------------------------------------------------------
-- 7. Every value becomes the number of values in its subtree (the node itself included).
------------------------------------------------------------------------

subtreeSizes :: Tree a -> Tree Int
subtreeSizes t = undefined

-- main = print (subtreeSizes tree2)                                                 -- Node 3 (Node 1 Leaf Leaf) (Node 1 Leaf Leaf)
-- main = print (subtreeSizes (Node 'a' (Node 'b' Leaf (Node 'c' Leaf Leaf)) Leaf))  -- Node 3 (Node 2 Leaf (Node 1 Leaf Leaf)) Leaf

------------------------------------------------------------------------
-- Part 3: a tree of records
------------------------------------------------------------------------

data Employee = Employee { empName :: String, salary :: Int }
  deriving (Show)

--             Anna 900
--            /         \
--      Bob 400      Cecil 650
--                   /
--              Dora 300
staff :: Tree Employee
staff = Node (Employee "Anna" 900)
             (Node (Employee "Bob" 400) Leaf Leaf)
             (Node (Employee "Cecil" 650) (Node (Employee "Dora" 300) Leaf Leaf) Leaf)

------------------------------------------------------------------------
-- 8. The sum of all salaries.
------------------------------------------------------------------------

payroll :: Tree Employee -> Int
payroll t = undefined

-- main = print (payroll staff)  -- 2250
-- main = print (payroll Leaf)   -- 0

------------------------------------------------------------------------
-- 9. Everybody's salary goes up by the given percent (round down).
------------------------------------------------------------------------

raise :: Int -> Tree Employee -> Tree Employee
raise pct t = undefined

-- main = print (raise 10 (Node (Employee "Bob" 400) Leaf Leaf))  -- Node (Employee {empName = "Bob", salary = 440}) Leaf Leaf
-- main = print (payroll (raise 10 staff))                        -- 2475
-- main = print (payroll (raise 5 staff))                         -- 2362

------------------------------------------------------------------------
-- 10. The names of the employees who earn more than k: first the root, then the left subtree, then the right.
------------------------------------------------------------------------

earnMore :: Int -> Tree Employee -> [String]
earnMore k t = undefined

-- main = print (earnMore 350 staff)   -- ["Anna","Bob","Cecil"]
-- main = print (earnMore 1000 staff)  -- []

------------------------------------------------------------------------
-- 11. The same tree, but with (name, salary) pairs instead of records.
------------------------------------------------------------------------

toPairs :: Tree Employee -> Tree (String, Int)
toPairs t = undefined

-- main = print (toPairs staff)                                  -- Node ("Anna",900) (Node ("Bob",400) Leaf Leaf) (Node ("Cecil",650) (Node ("Dora",300) Leaf Leaf) Leaf)
-- main = print (toPairs (Node (Employee "Bob" 400) Leaf Leaf))  -- Node ("Bob",400) Leaf Leaf

------------------------------------------------------------------------
-- 12★ Grades as words:  1 -> "fail", 2 -> "pass", 3 -> "satisfactory", 4 -> "good", 5 -> "excellent".
--     Any other number becomes "invalid".
------------------------------------------------------------------------

gradeWords :: Tree Int -> Tree String
gradeWords t = undefined

-- main = print (gradeWords (Node 5 (Node 1 Leaf Leaf) (Node 7 Leaf Leaf)))  -- Node "excellent" (Node "fail" Leaf Leaf) (Node "invalid" Leaf Leaf)
-- main = print (gradeWords (Node 3 Leaf (Node 4 Leaf Leaf)))                -- Node "satisfactory" Leaf (Node "good" Leaf Leaf)

------------------------------------------------------------------------
-- 13★ The average of the values (a Double). For the empty tree: error "Empty tree".
------------------------------------------------------------------------

averageTree :: Tree Int -> Double
averageTree t = undefined

-- main = print (averageTree tree2)  -- 2.0
-- main = print (averageTree tree1)  -- 7.333333333333333
