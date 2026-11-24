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
toList Empty = []
toList (Cons x xs) = x : toList xs

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
maxTree Leaf = error "Empty tree"
maxTree (Node x Leaf Leaf) = x
maxTree (Node x l Leaf) = max x (maxTree l)
maxTree (Node x Leaf r) = max x (maxTree r)
maxTree (Node x l r) = max x (max (maxTree l) (maxTree r))

-- main = print (maxTree tree1)                  -- 14
-- main = print (maxTree tree2)                  -- 9
-- main = print (maxTree (Node (-3) Leaf Leaf))  -- -3

------------------------------------------------------------------------
-- 3. The values that are at least k, in this order: left subtree, value, right subtree.
------------------------------------------------------------------------

atLeast :: Int -> Tree Int -> [Int]
atLeast _ Leaf = []
atLeast k (Node x l r)
  | x >= k    = atLeast k l ++ [x] ++ atLeast k r
  | otherwise = atLeast k l ++ atLeast k r

-- main = print (atLeast 7 tree1)    -- [7,8,10,13,14]
-- main = print (atLeast 0 tree2)    -- [2,9]
-- main = print (atLeast 100 tree1)  -- []

------------------------------------------------------------------------
-- 4. Every value smaller than k becomes 0. The others stay.
------------------------------------------------------------------------

zeroSmall :: Int -> Tree Int -> Tree Int
zeroSmall _ Leaf = Leaf
zeroSmall k (Node x l r) = if x < k then (Node 0 (zeroSmall k l) (zeroSmall k r)) else (Node x (zeroSmall k l) (zeroSmall k r))

-- main = print (zeroSmall 3 tree2)                             -- Node 0 (Node 0 Leaf Leaf) (Node 9 Leaf Leaf)
-- main = print (zeroSmall 5 (Node 3 (Node 8 Leaf Leaf) Leaf))  -- Node 0 (Node 8 Leaf Leaf) Leaf
-- main = print (zeroSmall 1 Leaf)                              -- Leaf

------------------------------------------------------------------------
-- 5. The values on the way from the root, always going to the LEFT, until the end.
--      leftPath tree1 = [8,3,1]
------------------------------------------------------------------------

leftPath :: Tree a -> [a]
leftPath Leaf = []
leftPath (Node x l r) = [x] ++ leftPath l

-- main = print (leftPath tree1)                                 -- [8,3,1]
-- main = print (leftPath (Node 'a' Leaf (Node 'b' Leaf Leaf)))  -- "a"
-- main = print (null (leftPath Leaf))                           -- True

------------------------------------------------------------------------
-- 6. Keep only the first k levels of the tree (the root is on level 1). For k <= 0 the result is Leaf.
------------------------------------------------------------------------

trim :: Int -> Tree a -> Tree a
trim _ Leaf = Leaf
trim k (Node x l r)
  | k <= 0    = Leaf
  | otherwise = Node x (trim (k - 1) l) (trim (k - 1) r)

-- main = print (trim 2 tree1)  -- Node 8 (Node 3 Leaf Leaf) (Node 10 Leaf Leaf)
-- main = print (trim 1 tree2)  -- Node 2 Leaf Leaf
-- main = print (trim 0 tree2)  -- Leaf

------------------------------------------------------------------------
-- 7. Every value becomes the number of values in its subtree (the node itself included).
------------------------------------------------------------------------

size :: Tree a -> Int
size Leaf         = 0
size (Node _ l r) = 1 + size l + size r

subtreeSizes :: Tree a -> Tree Int
subtreeSizes Leaf         = Leaf
subtreeSizes (Node _ l r) = Node (1 + size l + size r) (subtreeSizes l) (subtreeSizes r)

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
payroll Leaf = 0
payroll (Node x l r) = salary x + (payroll l) + (payroll r)

-- main = print (payroll staff)  -- 2250
-- main = print (payroll Leaf)   -- 0

------------------------------------------------------------------------
-- 9. Everybody's salary goes up by the given percent (round down).
------------------------------------------------------------------------

increaseSalary :: Int -> Employee -> Employee
increaseSalary p (Employee n s) = Employee n (s + (s * p) `div` 100)

raise :: Int -> Tree Employee -> Tree Employee
raise _ Leaf = Leaf
raise pct (Node e l r) = Node (increaseSalary pct e) (raise pct l) (raise pct r)

-- main = print (raise 10 (Node (Employee "Bob" 400) Leaf Leaf))  -- Node (Employee {empName = "Bob", salary = 440}) Leaf Leaf
-- main = print (payroll (raise 10 staff))                        -- 2475
-- main = print (payroll (raise 5 staff))                         -- 2362

------------------------------------------------------------------------
-- 10. The names of the employees who earn more than k: first the root, then the left subtree, then the right.
------------------------------------------------------------------------

earnMore :: Int -> Tree Employee -> [String]
earnMore _ Leaf = []
earnMore k (Node e l r)
  | salary e > k = empName e : (earnMore k l ++ earnMore k r)
  | otherwise    = earnMore k l ++ earnMore k r

-- main = print (earnMore 350 staff)   -- ["Anna","Bob","Cecil"]
-- main = print (earnMore 1000 staff)  -- []

------------------------------------------------------------------------
-- 11. The same tree, but with (name, salary) pairs instead of records.
------------------------------------------------------------------------

toPairs :: Tree Employee -> Tree (String, Int)
toPairs Leaf = Leaf
toPairs (Node e l r) = Node (empName e, salary e) (toPairs l) (toPairs r)

-- main = print (toPairs staff)                                  -- Node ("Anna",900) (Node ("Bob",400) Leaf Leaf) (Node ("Cecil",650) (Node ("Dora",300) Leaf Leaf) Leaf)
-- main = print (toPairs (Node (Employee "Bob" 400) Leaf Leaf))  -- Node ("Bob",400) Leaf Leaf

------------------------------------------------------------------------
-- 12★ Grades as words:  1 -> "fail", 2 -> "pass", 3 -> "satisfactory", 4 -> "good", 5 -> "excellent".
--     Any other number becomes "invalid".
------------------------------------------------------------------------

gradeWords :: Tree Int -> Tree String
gradeWords Leaf = Leaf
gradeWords (Node g l r)
  | g == 1 = Node "fail" (gradeWords l) (gradeWords r)
  | g == 2 = Node "pass" (gradeWords l) (gradeWords r)
  | g == 3 = Node "satisfactory" (gradeWords l) (gradeWords r)
  | g == 4 = Node "good" (gradeWords l) (gradeWords r)
  | g == 5 = Node "excellent" (gradeWords l) (gradeWords r)
  | otherwise = Node "invalid" (gradeWords l) (gradeWords r)

-- main = print (gradeWords (Node 5 (Node 1 Leaf Leaf) (Node 7 Leaf Leaf)))  -- Node "excellent" (Node "fail" Leaf Leaf) (Node "invalid" Leaf Leaf)
-- main = print (gradeWords (Node 3 Leaf (Node 4 Leaf Leaf)))                -- Node "satisfactory" Leaf (Node "good" Leaf Leaf)

------------------------------------------------------------------------
-- 13★ The average of the values (a Double). For the empty tree: error "Empty tree".
------------------------------------------------------------------------

sumTree :: Tree Int -> Int
sumTree Leaf = 0
sumTree (Node x l r) = x + (sumTree l) + (sumTree r)

averageTree :: Tree Int -> Double
averageTree Leaf = error "Empty tree"
averageTree t = fromIntegral (sumTree t) / fromIntegral (size t)

-- main = print (averageTree tree2)  -- 2.0
-- main = print (averageTree tree1)  -- 7.333333333333333
