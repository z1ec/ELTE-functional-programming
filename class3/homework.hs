-- Week 3 — Homework (optional, but strongly recommended)
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
-- Part A needs only ranges and built-in list tools (no recursion).
-- Part B is recursion on lists: think  []  and  (x : xs).
-- ★ = harder, ★★ = challenge.

------------------------------------------------------------------------
-- Part A. Ranges and built-in tools
------------------------------------------------------------------------

-- A1. The last two elements of a list (fewer if the list is shorter).
lastTwo :: [Int] -> [Int]
lastTwo xs = drop (length xs - 2) xs
-- main = print (lastTwo [1,2,3,4,5])  -- [4,5]
-- main = print (lastTwo [7])          -- [7]
-- main = print (lastTwo [])           -- []

-- A2. The factorial of n (1 * 2 * ... * n), with a range and one built-in tool. No recursion!
factorial :: Int -> Int
factorial n = product [1..n]
-- main = print (factorial 5)  -- 120
-- main = print (factorial 0)  -- 1

-- A3. Swap the first and the last element. (The list has at least 2 elements.)
-- swapEnds :: [Int] -> [Int]
-- swapEnds xs = [last xs] ++ init (tail xs) ++ [head xs] -- commented due to compiler warning every time i reloads it
-- main = print (swapEnds [1,2,3,4])  -- [4,2,3,1]
-- main = print (swapEnds [1,2])      -- [2,1]

-- A4. How many words are in a sentence?
countWords :: String -> Int
countWords s = length (words s)
-- main = print (countWords "hello big   world")  -- 3
-- main = print (countWords "   ")                -- 0

-- A5. The multiples of k from k up to n (k is positive). Use a range with a step.
multiplesUpTo :: Int -> Int -> [Int]
multiplesUpTo k n = [k, k + k .. n]
-- main = print (multiplesUpTo 3 10)  -- [3,6,9]
-- main = print (multiplesUpTo 5 25)  -- [5,10,15,20,25]
-- main = print (multiplesUpTo 5 4)   -- []

-- A6. Insert x into the middle of the list (for an odd length, left of the middle element).
insertMiddle :: Int -> [Int] -> [Int]
insertMiddle x xs = take (length xs `div` 2) xs ++ [x] ++ drop (length xs `div` 2) xs
-- main = print (insertMiddle 0 [1,2,3,4])  -- [1,2,0,3,4]
-- main = print (insertMiddle 0 [1,2,3])    -- [1,0,2,3]
-- main = print (insertMiddle 0 [])         -- [0]

-- A7. Repeat a word n times, separated by spaces.
repeatWord :: Int -> String -> String
repeatWord n w
    | n <= 0    = ""
    | n == 1    = w
    | otherwise = w ++ " " ++ repeatWord (n - 1) w
-- i have figured out that "unwords replicate int string" easier after i wrote this

-- main = print (repeatWord 3 "ha")  -- "ha ha ha"
-- main = print (repeatWord 0 "ha")  -- ""

-- A8. A list always has exactly 3 elements: reverse their order.
--     Hint: a pattern can describe a list of a fixed length:  f [a, b, c] = ...
reorder :: [String] -> [String]
reorder [a, b, c] = [c, b, a]
-- main = print (reorder ["tail","body","head"])  -- ["head","body","tail"]

------------------------------------------------------------------------
-- Part B. Recursion on lists
------------------------------------------------------------------------

-- B1. Product of a list (without the built-in product). The product of [] is 1.
myProduct :: [Int] -> Int
myProduct [] = 1
myProduct (x:xs) = x * myProduct xs
-- main = print (myProduct [1,5,2,4])  -- 40
-- main = print (myProduct [])         -- 1

-- B2. Are ALL numbers even? (For [] the answer is True: there is no odd number in it.)
allEven :: [Int] -> Bool
allEven [] = True
allEven (x:xs) = even x && allEven xs
-- main = print (allEven [2,4,6])  -- True
-- main = print (allEven [2,3,4])  -- False
-- main = print (allEven [])       -- True

-- B3. Is there at least one negative number?
anyNegative :: [Int] -> Bool
anyNegative [] = False
anyNegative (x:xs) = (x < 0) || anyNegative xs
-- main = print (anyNegative [1,-2,3])  -- True
-- main = print (anyNegative [1,2])     -- False
-- main = print (anyNegative [])        -- False

-- B4. Square every element.
squareAll :: [Int] -> [Int]
squareAll [] = []
squareAll (x:xs) = x * x : squareAll xs
-- main = print (squareAll [1,2,-3])  -- [1,4,9]
-- main = print (squareAll [])        -- []

-- B5. Keep only the odd numbers.
onlyOdd :: [Int] -> [Int]
onlyOdd [] = []
onlyOdd (x:xs) = if odd x then x : onlyOdd xs else onlyOdd xs
-- main = print (onlyOdd [1,2,3,4,5])  -- [1,3,5]
-- main = print (onlyOdd [2,4])        -- []

-- B6. Triple the negative numbers at the start of the list, and stop at the first number that is not negative.
tripleUntilPositive :: [Int] -> [Int]
tripleUntilPositive [] = []
tripleUntilPositive (x:xs)
    | x < 0 = x * 3 : tripleUntilPositive xs
    | otherwise = []
-- main = print (tripleUntilPositive [-1,-3,-5,-5,2,-4,-5])  -- [-3,-9,-15,-15]
-- main = print (tripleUntilPositive [1,-2])                 -- []

-- B7. Turn a list of names into initials:  ["Sam", "Harris"] -> "S.H."
initials :: [String] -> String
initials [] = ""
initials ([]:ns) = initials ns
initials ((c:_):ns) = c : '.' : initials ns
-- main = print (initials ["Sam","Harris"])                   -- "S.H."
-- main = print (initials ["Howard","Phillips","Lovecraft"])  -- "H.P.L."

-- B8. For every sublist, make a two-element list: [how many even numbers, their sum].
--     Hint: write two small recursive helpers first, one for each number.
countSumEvens :: [[Int]] -> [[Int]]
countSumEvens [] = []
countSumEvens (xs:xss) = [countEvens xs, sumEvens xs] : countSumEvens xss

countEvens :: [Int] -> Int
countEvens [] = 0
countEvens (x:xs) = if even x then 1 + countEvens xs else countEvens xs

sumEvens :: [Int] -> Int
sumEvens [] = 0
sumEvens (x:xs)
    | even x = x + sumEvens xs
    | otherwise = sumEvens xs
-- main = print (countSumEvens [[1,2,3,4],[90,2,4,4],[]])  -- [[2,6],[4,100],[0,0]]
-- main = print (countSumEvens [[1,3,5,6]])                -- [[1,6]]

-- B9. Is there a pair of neighbours whose sum is exactly target?
consecutiveSum :: Int -> [Int] -> Bool
consecutiveSum target (x:y:rest)
    | x + y == target = True
    | otherwise = consecutiveSum target (y : rest)
consecutiveSum _ _ = False
-- main = print (consecutiveSum 5 [1,2,3,4])   -- True
-- main = print (consecutiveSum 10 [1,2,3,4])  -- False
-- main = print (consecutiveSum 7 [3,4,1,6])   -- True

-- B10. Write your own take, drop and reverse.
myTake :: Int -> [Int] -> [Int]
myTake _ [] = []
myTake n (x:xs)
    | n <= 0 = []
    | otherwise = x : myTake (n - 1) xs
-- main = print (myTake 2 [1,2,3,4,5])  -- [1,2]
-- main = print (myTake 7 [1,2])        -- [1,2]
-- main = print (myTake 0 [1,2])        -- []

myDrop :: Int -> [Int] -> [Int]
myDrop _ [] = []
myDrop n (x:xs)
    | n <= 0 = x : xs
    | otherwise = myDrop (n - 1) xs
-- main = print (myDrop 2 [1,2,3,4,5])  -- [3,4,5]
-- main = print (myDrop 5 [1,2,3])      -- []
-- main = print (myDrop 0 [1,2])        -- [1,2]

myReverse :: [Int] -> [Int]
myReverse xs = go xs []
  where
    go [] acc = acc
    go (y:ys) acc = go ys (y : acc)
-- main = print (myReverse [1,2,3])  -- [3,2,1]
-- main = print (myReverse [])       -- []

-- B11. ★ The biggest element of a non-empty list (without the built-in maximum).
--      Hint: a helper with an extra argument, "the biggest so far", makes this easy.
myMaximum :: [Int] -> Int
myMaximum (x:xs) = biggest x xs

biggest :: Int -> [Int] -> Int
biggest best [] = best
biggest best (y:ys)
    | y > best = biggest y ys
    | otherwise = biggest best ys
-- main = print (myMaximum [3,8,1,9,2])  -- 9
-- main = print (myMaximum [-5,-2,-7])   -- -2

-- B12. ★ Interleave two lists: first of the first, first of the second, second of the first, ...
--      When one list runs out, the rest of the other one follows.
interleave :: [Int] -> [Int] -> [Int]
interleave [] ys = ys
interleave (x:xs) ys = x : interleave ys xs
-- swapping the arguments every step is what makes them take turns
-- main = print (interleave [1,2,3] [10,20])  -- [1,10,2,20,3]
-- main = print (interleave [] [5,6])         -- [5,6]

-- B13. ★★ Merge two sorted lists into one sorted list.
merge :: [Int] -> [Int] -> [Int]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
    | x <= y = x : merge xs (y : ys)
    | otherwise = y : merge (x : xs) ys
-- main = print (merge [1,4,6] [2,3,7,8])  -- [1,2,3,4,6,7,8]
-- main = print (merge [] [1])             -- [1]
