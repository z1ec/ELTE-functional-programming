-- Week 2 — In-class tasks
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

-- From the demo, you may use it:
sumDigits :: Int -> Int
sumDigits n
  | n < 10    = n
  | otherwise = n `mod` 10 + sumDigits (n `div` 10)

------------------------------------------------------------------------
-- Task 1
-- Multiply the digits of a non-negative number.
------------------------------------------------------------------------

productDigits :: Int -> Int
productDigits n
    | n < 10 = n
    | otherwise = (n `mod` 10) * productDigits (n `div` 10)

-- main = print (productDigits 123)   -- 6
-- main = print (productDigits 2222)  -- 16
-- main = print (productDigits 503)   -- 0
-- main = print (productDigits 7)     -- 7

------------------------------------------------------------------------
-- Task 2
-- How many times does the digit d appear in the positive number n?
------------------------------------------------------------------------

countDigit :: Int -> Int -> Int
countDigit d n = undefined

-- main = print (countDigit 3 12333)  -- 3
-- main = print (countDigit 9 123)    -- 0
-- main = print (countDigit 0 100)    -- 2
-- main = print (countDigit 1 1)      -- 1

------------------------------------------------------------------------
-- Task 3 (bonus)
-- The digital root of a number: sum its digits, then sum the digits of the result,
-- and so on, until only one digit is left.
--   9875 -> 9+8+7+5 = 29 -> 2+9 = 11 -> 1+1 = 2
------------------------------------------------------------------------

digitalRoot :: Int -> Int
digitalRoot n = undefined

-- main = print (digitalRoot 9875)  -- 2
-- main = print (digitalRoot 99)    -- 9
-- main = print (digitalRoot 7)     -- 7
