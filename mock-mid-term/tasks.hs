-- Mock midterm A: 90-minute programming exam
-- 10 independent tasks, 10 points each (100 total).
-- NAME AND NEPTUN CODE:     Vladimir Fomin G9ZVX2
--
-- Work independently. Any tool from weeks 1–6 is allowed unless a task says otherwise.
-- Do not change the type signatures. You may write your own helpers.
-- Start with the tasks you are sure about; they need not be solved in order.
-- The signatures are commented out in the student file, as in the exam samples.
-- Uncomment a signature when starting that task, then write its definition below it.
-- Keep the file loading: comment out an unfinished definition, or use = undefined.
--
-- Testing: uncomment ONE "main = print (...)" line, save, then run  runghc tasks.hs
-- The value after the last "--" is the expected result. Only one main may be active.
-- Alternatively use  ghci tasks.hs  and reload after changes with  :r
-- All lists are finite. Unless a task says otherwise, preserve the input order.

------------------------------------------------------------------------
-- 1. (10 points) Remove a digit
-- Remove every occurrence of digit d from the decimal representation of n.
-- Keep the remaining digits in their original order and return the resulting number.
-- Leading zeroes disappear; if no digits remain, return 0. Assume 0 <= d <= 9.
-- For negative n: error "Negative number".
------------------------------------------------------------------------

removeDigit :: Integer -> Integer -> Integer
removeDigit num n
    | num < 0 = error "Negative number"
    | num == 0 = 0
    | otherwise = if (num `mod` 10) == n then removeDigit (num `div` 10) n else (num `mod` 10) + (removeDigit (num `div` 10) n) * 10

-- main = print (removeDigit 507050 5)  -- 700
-- main = print (removeDigit 10203 0)   -- 123
-- main = print (removeDigit 444 4)     -- 0
-- main = print (removeDigit 1200 1)    -- 200
-- main = print (removeDigit 123 9)     -- 123
-- main = print (removeDigit 0 0)       -- 0
-- Error check in GHCi: removeDigit (-12) 1  raises "Negative number".

------------------------------------------------------------------------
-- 2. (10 points) Matching pairs
-- Pair the first element of xs with the first of ys, the second with the second, etc.
-- Stop when the shorter list ends. Keep only pairs whose absolute difference is k.
-- If the same ordered pair occurs more than once, keep only its FIRST occurrence.
-- (a,b) and (b,a) are different pairs. Assume k >= 0.
------------------------------------------------------------------------

matchingPairs :: Int -> [Int] -> [Int] -> [(Int, Int)]
matchingPairs k xs ys = [ (x, y) | (i, (x, y)) <- zip [0..] (zip xs ys), abs (x - y) == k, not (elem (x, y) (take i (zip xs ys))) ]


-- main = print (matchingPairs 3 [2,1,4,2,5] [5,3,1,5,2])  -- [(2,5),(4,1),(5,2)]
-- main = print (matchingPairs 1 [3,1,3,2] [2,2,2,3])      -- [(3,2),(1,2),(2,3)]
-- main = print (matchingPairs 0 [2,2,1] [2,2,1])          -- [(2,2),(1,1)]
-- main = print (matchingPairs 2 [1,4,7] [3])              -- [(1,3)]
-- main = print (matchingPairs 3 [] [1,2])                 -- []
-- main = print (matchingPairs 2 [1,2] [1,2])              -- []

------------------------------------------------------------------------
-- 3. (10 points) Local peaks
-- Return the zero-based indices of elements STRICTLY greater than both immediate neighbours.
-- The first and last elements cannot be peaks. Examine every possible position.
------------------------------------------------------------------------

localPeaks :: [Int] -> [Int]
localPeaks xs = [ i | (i, (x, y, z)) <- zip [1..] (zip3 xs (drop 1 xs) (drop 2 xs)), y > x && y > z]


-- main = print (localPeaks [1,4,2,5,3])  -- [1,3]
-- main = print (localPeaks [1,3,3,1])    -- []
-- main = print (localPeaks [9,1,9])      -- []
-- main = print (localPeaks [-5,-1,-3])   -- [1]
-- main = print (localPeaks [1,2])        -- []
-- main = print (localPeaks [])           -- []

------------------------------------------------------------------------
-- 4. (10 points) Expand markers
-- Read a String from left to right. A '#' followed by a character is replaced by
-- TWO copies of that following character; consume both original characters.
-- Copy all other characters unchanged. A final '#' with no following character stays '#'.
-- Characters produced by a replacement are output literally; do not process them again.
------------------------------------------------------------------------

expandMarkers :: String -> String
expandMarkers s
    | s == "" = ""
    | s == "#" = "#"
    | otherwise = if head s == '#' then drop 1 (take 2 s) ++ drop 1 (take 2 s) ++ expandMarkers (drop 2 s) else take 1 s ++ expandMarkers (drop 1 s)

-- main = print (expandMarkers "a#bc")        -- "abbc"
-- main = print (expandMarkers "##a")         -- "##a"
-- main = print (expandMarkers "#a#b#")       -- "aabb#"
-- main = print (expandMarkers "###x")        -- "##xx"
-- main = print (expandMarkers "plain text")  -- "plain text"
-- main = print (expandMarkers "#")           -- "#"
-- main = print (expandMarkers "")            -- ""

------------------------------------------------------------------------
-- 5. (10 points) Best adjusted average
-- Each student has a name and a list of scores. First ignore scores outside 0..100 inclusive.
-- A student with no valid scores is not considered. If a student has at least TWO valid scores,
-- discard ONE occurrence of their lowest valid score before calculating their average.
-- With exactly one valid score, use that score as the average.
-- Return the name with the highest adjusted average; on a tie, return the FIRST name in the input.
-- If no student can be considered: error "No valid scores".
------------------------------------------------------------------------

--bestAdjusted :: [(String, [Int])] -> String

-- main = print (bestAdjusted [("Ada",[40,80,90]),("Ben",[84]),("Cy",[-1,101])])  -- "Ada"
-- main = print (bestAdjusted [("First",[80,90]),("Second",[90])])                -- "First"
-- main = print (bestAdjusted [("A",[20,20,100]),("B",[70])])                     -- "B"
-- main = print (bestAdjusted [("A",[70,80,81]),("B",[80])])                      -- "A"
-- main = print (bestAdjusted [("Skip",[]),("Only",[-1,0,101])])                  -- "Only"
-- main = print (bestAdjusted [("A",[100,100,0]),("B",[99])])                     -- "A"
-- Error checks in GHCi: bestAdjusted []  and  bestAdjusted [("A",[-1,101])]
-- both raise "No valid scores".

------------------------------------------------------------------------
-- 6. (10 points) Factor triples
-- Given positive n, return every triple (a,b,c) of positive integers with a <= b <= c
-- and a*b*c == n. Each triple appears once. List smaller a first; for equal a, smaller b first.
-- Equal factors are allowed.
------------------------------------------------------------------------

--factorTriples :: Int -> [(Int, Int, Int)]

-- main = print (factorTriples 12)  -- [(1,1,12),(1,2,6),(1,3,4),(2,2,3)]
-- main = print (factorTriples 8)   -- [(1,1,8),(1,2,4),(2,2,2)]
-- main = print (factorTriples 1)   -- [(1,1,1)]
-- main = print (factorTriples 7)   -- [(1,1,7)]
-- main = print (factorTriples 16)  -- [(1,1,16),(1,2,8),(1,4,4),(2,2,4)]

------------------------------------------------------------------------
-- 7. (10 points) Cycle through functions
-- Apply the first function to the first element, the second function to the second element, etc.
-- After the last function, start again at the first function. Return one result per input element.
-- If the function list is empty: error "No functions", even if the element list is also empty.
-- With a nonempty function list and no elements, return [].
------------------------------------------------------------------------

--applyCyclic :: [a -> a] -> [a] -> [a]

-- main = print (applyCyclic [(+1),(*10)] [1,2,3,4,5])          -- [2,20,4,40,6]
-- main = print (applyCyclic [negate] [2,-3,0])                 -- [-2,3,0]
-- main = print (applyCyclic [not,id] [True,True,False,False])  -- [False,True,True,False]
-- main = print (applyCyclic [(+1),(*10),negate] [4,5])         -- [5,50]
-- main = print (applyCyclic [(+1)] ([] :: [Int]))              -- []
-- Error checks in GHCi: applyCyclic [] [1]  and  applyCyclic [] ([] :: [Int])
-- both raise "No functions".

------------------------------------------------------------------------
-- 8. (10 points) Distances between rows
-- Take corresponding rows of two lists of rows. For each row pair, return the sum
-- of the absolute differences between corresponding numbers.
-- At both levels, stop at the end of the shorter list. A pair with an empty row gives 0.
-- Use higher-order functions.
------------------------------------------------------------------------

--rowDistances :: [[Int]] -> [[Int]] -> [Int]

-- main = print (rowDistances [[1,4],[2,8,10],[],[99]] [[3,1],[5,2],[7]])  -- [5,9,0]
-- main = print (rowDistances [[-2,3]] [[1,-1]])                           -- [7]
-- main = print (rowDistances [[1,2,100]] [[1,2]])                         -- [0]
-- main = print (rowDistances [[],[1]] [[8],[]])                           -- [0,0]
-- main = print (rowDistances [] [[1,2]])                                  -- []
-- main = print (rowDistances [[1],[2]] [])                                -- []

------------------------------------------------------------------------
-- 9. (10 points) Payments that fit
-- A non-negative starting balance and a list of non-negative payment amounts are given.
-- Process payments in order. If a payment is at most the current balance, pay it and subtract it.
-- Otherwise reject it, leave the balance unchanged, and CONTINUE with the next payment.
-- Return (final balance, zero-based indices of rejected payments), with indices in input order.
------------------------------------------------------------------------

--payments :: Int -> [Int] -> (Int, [Int])

-- main = print (payments 10 [4,8,3,3,1])  -- (0,[1,4])
-- main = print (payments 5 [5,0,1])       -- (0,[2])
-- main = print (payments 3 [4,1,5,2])     -- (0,[0,2])
-- main = print (payments 0 [0,2,0])       -- (0,[1])
-- main = print (payments 7 [])            -- (7,[])
-- main = print (payments 10 [2,3])        -- (5,[])

------------------------------------------------------------------------
-- 10. (10 points) Longest increasing segment
-- Return the longest contiguous segment in which each element is STRICTLY greater than the previous one.
-- On a tie, return the segment that starts earliest. An empty input gives [].
-- Elements may not be skipped or reordered. The increase need not be exactly 1.
------------------------------------------------------------------------

--longestClimb :: [Int] -> [Int]

-- main = print (longestClimb [1,4,2,3,7,0,5])  -- [2,3,7]
-- main = print (longestClimb [1,3,0,2])        -- [1,3]
-- main = print (longestClimb [1,2,2,3,4])      -- [2,3,4]
-- main = print (longestClimb [9,7,5])          -- [9]
-- main = print (longestClimb [3,3,3])          -- [3]
-- main = print (longestClimb [-3,-1,0,2])      -- [-3,-1,0,2]
-- main = print (longestClimb [7])              -- [7]
-- main = print (longestClimb [])               -- []
