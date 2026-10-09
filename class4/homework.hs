-- Week 4 — Homework (optional, but strongly recommended)
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
-- Use list comprehensions wherever you can. ★ = harder, ★★ = challenge.

import Data.Char (toUpper, isDigit, isAlpha)

------------------------------------------------------------------------
-- Part A. Tuples
------------------------------------------------------------------------

-- A1. Swap the numbers in every pair.
swapAll :: [(Int, Int)] -> [(Int, Int)]
swapAll ps = [(b, a) | (a, b) <- ps]
-- main = print (swapAll [(1,2),(3,4)])  -- [(2,1),(4,3)]

-- A2. The sum of every pair.
pairSums :: [(Int, Int)] -> [Int]
pairSums ps = [ a + b | (a, b) <- ps]
-- main = print (pairSums [(1,2),(3,4),(5,5)])  -- [3,7,10]

-- A3. Extend every pair to a triple: (x, y, x + y).
withSum :: [(Int, Int)] -> [(Int, Int, Int)]
withSum ps = [(a, b, a+b) | (a, b) <- ps]
-- main = print (withSum [(1,2),(2,3)])  -- [(1,2,3),(2,3,5)]

-- A4. Add up the first parts and the second parts separately.   [(1,1),(2,2),(3,3)] -> (6,6)
sumTuples :: [(Int, Int)] -> (Int, Int)
sumTuples ps = (sum [a | (a, _) <- ps], sum [b | (_, b) <- ps])
-- main = print (sumTuples [(1,1),(2,2),(3,3)])  -- (6,6)
-- main = print (sumTuples [])                   -- (0,0)

-- A5. Look up the grade of a student in a (name, grade) table. Return -1 if the name is not there.
lookupGrade :: String -> [(String, Int)] -> Int
lookupGrade name table = undefined
-- main = print (lookupGrade "Bob" [("Anna",5),("Bob",3)])  -- 3
-- main = print (lookupGrade "Zoe" [("Anna",5)])            -- -1

------------------------------------------------------------------------
-- Part B. List comprehensions
------------------------------------------------------------------------

-- B1. The multiples of k from k up to n.
multiplesOf :: Int -> Int -> [Int]
multiplesOf k n = undefined
-- main = print (multiplesOf 3 10)  -- [3,6,9]
-- main = print (multiplesOf 5 4)   -- []

-- B2. Remove every occurrence of a character from a text.
removeChar :: Char -> String -> String
removeChar ch s = undefined
-- main = print (removeChar 'l' "hello world")  -- "heo word"

-- B3. Keep only the digits of a text. (isDigit is imported from Data.Char.)
onlyDigits :: String -> String
onlyDigits s = undefined
-- main = print (onlyDigits "tel: +36 1 234-5678")  -- "3612345678"

-- B4. Write every word in capital letters.
--     Hint: a comprehension INSIDE a comprehension. The inner one shouts one word.
capitalizeAll :: [String] -> [String]
capitalizeAll ws = undefined
-- main = print (capitalizeAll ["hello","big","world"])  -- ["HELLO","BIG","WORLD"]

-- B5. The multiplication table from 1 to n, as a list of rows.
multTable :: Int -> [[Int]]
multTable n = undefined
-- main = print (multTable 3)  -- [[1,2,3],[2,4,6],[3,6,9]]

-- B6. All quarter hours of a day as (hour, minute) pairs: (0,0), (0,15), (0,30), (0,45), (1,0), ...
quarters :: [(Int, Int)]
quarters = undefined
-- main = print (take 5 quarters)  -- [(0,0),(0,15),(0,30),(0,45),(1,0)]
-- main = print (length quarters)  -- 96

-- B7. The positions (starting from 0) where x occurs in the list.
positionsOf :: Int -> [Int] -> [Int]
positionsOf x xs = undefined
-- main = print (positionsOf 3 [3,1,3,3,2])  -- [0,2,3]
-- main = print (positionsOf 9 [1,2])        -- []

-- B8. Is n a prime? Then: all primes up to n.
isPrime :: Int -> Bool
isPrime n = undefined
-- main = print (isPrime 7)  -- True
-- main = print (isPrime 1)  -- False

primesUpTo :: Int -> [Int]
primesUpTo n = undefined
-- main = print (primesUpTo 30)  -- [2,3,5,7,11,13,17,19,23,29]

-- B9. The perfect numbers up to n (a number equal to the sum of its divisors smaller than itself).
perfectNumbers :: Int -> [Int]
perfectNumbers n = undefined
-- main = print (perfectNumbers 500)  -- [6,28,496]

-- B10. The "staircase" list: 1 once, 2 twice, 3 three times, ..., n n times.
--      Hint: two generators. The second one only decides HOW MANY times.
staircase :: Int -> [Int]
staircase n = undefined
-- main = print (staircase 4)  -- [1,2,2,3,3,3,4,4,4,4]

-- B11. A list of n Booleans alternating False, True, False, True, ...
alternating :: Int -> [Bool]
alternating n = undefined
-- main = print (alternating 5)  -- [False,True,False,True,False]

-- B12. ★ For every word: (number of vowels, number of consonants). Ignore everything that is not a letter.
vowelsConsonants :: [String] -> [(Int, Int)]
vowelsConsonants ws = undefined
-- main = print (vowelsConsonants ["Harry","ooo","pc","Web"])  -- [(1,4),(3,0),(0,2),(1,2)]
-- main = print (vowelsConsonants ["12345","he110","W0r1D"])   -- [(0,0),(1,1),(0,3)]

-- B13. ★ Capitalize the first letter of every word in a sentence.
--      Hint: words / unwords, and a small helper for one word.
capitalizeWords :: String -> String
capitalizeWords s = undefined
-- main = print (capitalizeWords "hello big world")  -- "Hello Big World"

-- B14. ★★ All (month, day) pairs of a 365-day year:
--      January 31, February 28, March 31, April 30, May 31, June 30,
--      July 31, August 31, September 30, October 31, November 30, December 31.
monthDays :: [(Int, Int)]
monthDays = undefined
-- main = print (length monthDays)  -- 365
-- main = print (monthDays !! 59)   -- (3,1)
-- main = print (last monthDays)    -- (12,31)

-- B15. ★★ Goldbach: all ways to write n as the sum of two primes p <= q.
goldbach :: Int -> [(Int, Int)]
goldbach n = undefined
-- main = print (goldbach 10)  -- [(3,7),(5,5)]
-- main = print (goldbach 28)  -- [(5,23),(11,17)]
