-- Week 1 — In-class tasks
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

------------------------------------------------------------------------
-- Task 1
-- A family goes to the cinema. An adult ticket costs 2500 Ft, a child ticket 1500 Ft,
-- and every child also gets a bag of popcorn for 1200 Ft.
-- How much does the family pay for `adults` adults and `children` children?
------------------------------------------------------------------------

cinemaCost :: Int -> Int -> Int
cinemaCost adults children = (adults * 2500) + (children * 1500) + (children * 1200)

-- main = print (cinemaCost 1 0)  -- 2500
-- main = print (cinemaCost 2 1)  -- 7700
-- main = print (cinemaCost 2 2)  -- 10400

------------------------------------------------------------------------
-- Task 2
-- The ticket price at a museum depends on the visitor's age:
--   under 6            -> free (0)
--   from 6 to 17       -> 1500
--   65 or older        -> 1200
--   everybody else     -> 2500
------------------------------------------------------------------------

ticketPrice :: Int -> Int
ticketPrice age
    | age < 4 = 0
    | age < 19 = 1500
    | age < 65 = 2500
    | otherwise = 1200

-- main = print (ticketPrice 3)   -- 0

-- main = print (ticketPrice 6)   -- 1500
-- main = print (ticketPrice 17)  -- 1500

-- main = print (ticketPrice 18)  -- 2500
-- main = print (ticketPrice 64)  -- 2500

-- main = print (ticketPrice 65)  -- 1200

------------------------------------------------------------------------
-- Task 3 (bonus)
-- Given three numbers, return the middle one
-- (the one that is neither the smallest nor the biggest).
------------------------------------------------------------------------

middle :: Int -> Int -> Int -> Int
middle a b c = a + b + c - maximum [a, b , c] - minimum [a, b, c]

-- main = print (middle 1 5 3)  -- 3
-- main = print (middle 9 2 4)  -- 4
-- main = print (middle 7 7 1)  -- 7
-- main = print (middle 5 5 5)  -- 5
