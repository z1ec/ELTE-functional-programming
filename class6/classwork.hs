-- Week 6 — Folds, scans, the last tools, and midterm review
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

import Data.List (sort)

------------------------------------------------------------------------
-- Part 1. foldr: combine a whole list into one value
------------------------------------------------------------------------

-- 1.1 Sum and product.
mySum :: [Int] -> Int
mySum xs = foldr (+) 0 xs
-- main = print (c)  -- 6

myProduct :: [Int] -> Int
myProduct xs = foldr (*) 1 xs
-- main = print (myProduct [1,2,3,4])  -- 24

-- 1.2 Are all of them True?
allTrue :: [Bool] -> Bool
allTrue bs = foldr (&&) True bs
-- main = print (allTrue [True,True])   -- True
-- main = print (allTrue [True,False])  -- False

-- 1.3 Length with a lambda: the lambda gets the ELEMENT and the RESULT FOR THE REST.
myLength :: [Int] -> Int
myLength xs = foldr (\x acc -> acc + 1) 0 xs
-- main = print (myLength [5,5,5])  -- 3

-- 1.4 How many elements satisfy a test?
countIf :: (Int -> Bool) -> [Int] -> Int
countIf p xs = foldr (\x acc -> (if p x then 1 else 0) + acc) 0 xs
-- main = print (countIf even [1,2,3,4])  -- 2
-- main = print (countIf (> 10) [1,2])    -- 0

-- 1.5 foldr can build lists too: map, written as a fold. (optional)
myMap :: (Int -> Int) -> [Int] -> [Int]
myMap f xs = foldr (\x acc -> f x : acc) [] xs
-- main = print (myMap (*2) [1,2,3])  -- [2,4,6]

------------------------------------------------------------------------
-- Part 2. foldl: walk from the left, updating an accumulator
------------------------------------------------------------------------

-- 2.1 Digits to a number:  [1,2,3] -> 123.   (Week 2 took numbers apart; this puts them together.)
digitsToNumber :: [Int] -> Int
digitsToNumber ds = foldl (\acc x -> acc * 10 + x) 0 ds
-- main = print (digitsToNumber [1,2,3])  -- 123
-- main = print (digitsToNumber [])       -- 0

-- 2.2 Reverse: put every element in FRONT of the accumulator.
myReverse :: [Int] -> [Int]
myReverse xs = foldl (\acc x -> x : acc) [] xs
-- main = print (myReverse [1,2,3])  -- [3,2,1]

-- 2.3 The longest word (the first one if there is a tie).
longestWord :: [String] -> String
longestWord ws = foldl (\acc x -> if length acc < length x then x else acc) "" ws
-- main = print (longestWord ["hi","hello","hey","world"])  -- "hello"
-- main = print (longestWord [])                            -- ""

-- In GHCi, predict first:
--   foldr (-) 0 [1,2,3]
--   foldl (-) 0 [1,2,3]

-- 2.4 foldl1 / foldr1: no start value. foldl1 starts with the FIRST element, foldr1 with the LAST one.
--     Use them when there is no natural start value. On an empty list they crash.
-- In GHCi, predict first:
--   foldl1 (-) [10,3,2]
--   foldr1 (-) [10,3,2]
--   foldl1 max []

-- The biggest element of a non-empty list: what start value would work for foldl? None does for every list.
biggest :: [Int] -> Int
biggest xs = foldl1 max xs
-- main = print (biggest [3,8,1,9,2])  -- 9
-- main = print (biggest [-5,-2,-7])   -- -2

-- Join words with single spaces between them (a non-empty list of words).
sentence :: [String] -> String
sentence ws = foldl1 (\acc w -> acc ++ " " ++ w) ws
-- main = print (sentence ["functional","programming","rocks"])  -- "functional programming rocks"
-- main = print (sentence ["one"])                               -- "one"

------------------------------------------------------------------------
-- Part 3. Scans: a fold that shows every step
------------------------------------------------------------------------
-- In GHCi:
--   scanl (+) 0 [1,2,3,4]
--   scanl1 (+) [1,2,3,4]
--   scanr (+) 0 [1,2,3]
--   scanr1 (+) [1,2,3]
--   scanl1 max [3,1,4,1,5]

-- 3.1 A bank account: the balance after every transaction.
runningTotal :: [Int] -> [Int]
runningTotal xs = scanl1 (+) xs
-- main = print (runningTotal [100,-30,50])  -- [100,70,120]

-- 3.2 The record so far at every point (the highest value seen until then).
records :: [Int] -> [Int]
records xs = scanl1 max xs
-- main = print (records [3,1,4,1,5])  -- [3,3,4,4,5]

-- 3.3 scanl with a start value: the balance of an account that starts with some money.
balances :: Int -> [Int] -> [Int]
balances start xs = scanl (+) start xs
-- main = print (balances 100 [20,-50,10])  -- [100,120,70,80]

-- 3.4 scanr: before each payment, how much is still left to pay in total? (optional)
leftToPay :: [Int] -> [Int]
leftToPay xs = scanr (+) 0 xs
-- main = print (leftToPay [10,20,30])  -- [60,50,30,0]

------------------------------------------------------------------------
-- Part 4. The last tools
------------------------------------------------------------------------
-- In GHCi:
--   splitAt 2 [1,2,3,4,5]
--   sort [3,1,2]

-- 4.1 Cut a list into two halves (the second half gets the extra element).
splitHalf :: [Int] -> ([Int], [Int])
splitHalf xs = splitAt (div (length xs) 2) xs
-- main = print (splitHalf [1,2,3,4,5])  -- ([1,2],[3,4,5])

-- 4.2 The median: the middle element of the sorted list.
median :: [Int] -> Int
median xs = (sort xs) !! div (length xs) 2
-- main = print (median [5,1,4,2,3])  -- 3

------------------------------------------------------------------------
-- Part 5. Review: ONE task, four tools
-- The sum of the squares of the even numbers.
------------------------------------------------------------------------

-- 5.1 Recursion (week 3)
sumSqEvenRec :: [Int] -> Int
sumSqEvenRec [] = 0
sumSqEvenRec (x:xs) = (if even x then x * x else 0) + sumSqEvenRec xs
-- main = print (sumSqEvenRec [1 .. 6])  -- 56

-- 5.2 List comprehension (week 4)
sumSqEvenComp :: [Int] -> Int
sumSqEvenComp xs = sum [ x * x | x <- xs, even x]
-- main = print (sumSqEvenComp [1 .. 6])  -- 56

-- 5.3 map and filter (week 5)
-- sumSqEvenHof :: [Int] -> Int
-- sumSqEvenHof xs
--   | null xs = error "Wrong"
--   | sum . map (^2) $ filter even n
-- main = print (sumSqEvenHof [1 .. 6])  -- 56

-- 5.4 A fold (today)
-- sumSqEvenFold :: [Int] -> Int
-- sumSqEvenFold xs = foldr (\x acc -> (if even x then x * x else 0) + acc) 0 xs
-- main = print (sumSqEvenFold [1 .. 6])  -- 56

add :: Int -> Int -> Int
add a b = a + b

add5 :: Int -> Int
add5 = add 5


-- [(*2), (^2), (-5)]
test2 n fns = map ($ n) fns
