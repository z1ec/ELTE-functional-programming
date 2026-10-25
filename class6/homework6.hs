-- Week 6 — Homework
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

import Data.List (sort)

-- 1. Are all numbers positive?
allPositive :: [Int] -> Bool
allPositive xs = foldr (\x acc -> x > 0 && acc) True xs
-- main = print (allPositive [1,2,3])   -- True
-- main = print (allPositive [1,-2,3])  -- False
-- main = print (allPositive [])        -- True

-- 2. Join a list of lists into one list, without the built-in concat.
myConcat :: [[Int]] -> [Int]
myConcat xss = foldr (++) [] xss
-- main = print (myConcat [[1,2],[],[3]])  -- [1,2,3]
-- main = print (myConcat [])              -- []

-- 3. The product of the numbers, skipping the zeros.
productOfNonZero :: [Int] -> Int
productOfNonZero xs = product (filter (/= 0) xs)
-- main = print (productOfNonZero [2,0,3,0,4])  -- 24
-- main = print (productOfNonZero [0,0])        -- 1

-- 4. Double the even numbers, keep the odd ones.
doubleEvens :: [Int] -> [Int]
doubleEvens xs = map (\x -> if even x then x * 2 else x) xs
-- main = print (doubleEvens [1,2,3,4])  -- [1,4,3,8]
-- main = print (doubleEvens [])         -- []

-- 5. The biggest element of a non-empty list, without the built-in maximum.
myMaximum :: [Int] -> Int
myMaximum xs = foldr1 max xs
-- main = print (myMaximum [3,8,1,9,2])  -- 9
-- main = print (myMaximum [-5,-2,-7])   -- -2

-- 6. A number written in base b, given as a list of digits, back to a number:  base 2, [1,0,1] -> 5.
fromBase :: Int -> [Int] -> Int
fromBase b ds = foldl (\acc d -> acc * b + d) 0 ds
-- main = print (fromBase 2 [1,0,1])   -- 5
-- main = print (fromBase 8 [1,7])     -- 15
-- main = print (fromBase 10 [4,0,2])  -- 402

-- 7. The LAST even number of the list, or -1 if there is none.
lastEven :: [Int] -> Int
lastEven xs = foldl (\acc x -> if even x then x else acc) (-1) xs
-- main = print (lastEven [2,3,8,5])  -- 8
-- main = print (lastEven [1,3])      -- -1

-- 8. Reverse the order of the words in a sentence.
reverseWords :: String -> String
reverseWords s = unwords (foldl (\acc w -> w : acc) [] (words s))
-- main = print (reverseWords "one two three")  -- "three two one"

-- 9. The smallest value seen so far, at every position.
runningMin :: [Int] -> [Int]
runningMin xs = scanl1 min xs
-- main = print (runningMin [5,3,4,1,2])  -- [5,3,3,1,1]

-- 10. The factorials 0!, 1!, 2!, ..., n!.
factorials :: Int -> [Int]
factorials n = scanl (*) 1 [1..n]
-- main = print (factorials 4)  -- [1,1,2,6,24]
-- main = print (factorials 0)  -- [1]

-- 11. A shop starts with some items and sells some every day. How many are left after each day?
--     The first element of the result is the starting stock.
stockLeft :: Int -> [Int] -> [Int]
stockLeft start sales = scanl (-) start sales
-- main = print (stockLeft 100 [20,30,10])  -- [100,80,50,40]

-- 12. For every position: the sum from there to the END of the list.
sumsToEnd :: [Int] -> [Int]
sumsToEnd xs = scanr (+) 0 xs
-- main = print (sumsToEnd [1,2,3])  -- [6,5,3]
-- main = print (sumsToEnd [])       -- []

-- 13. Sort the list, then cut it into the lower half and the upper half
--     (for an odd length, the upper half gets the extra element).
sortedHalves :: [Int] -> ([Int], [Int])
sortedHalves xs = splitAt (div (length xs) 2) (sort xs)
-- main = print (sortedHalves [5,1,4,2,3])  -- ([1,2],[3,4,5])
-- main = print (sortedHalves [])           -- ([],[])
