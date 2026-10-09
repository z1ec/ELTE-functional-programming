{- Progress Task 3 — Variant B -}

{- Your Neptun code:     G9ZVX2     -}

{-
    Write the function countRises that counts how many times an element of the list
    is BIGGER than the element right before it.

    Example:  countRises [1, 3, 2, 5, 6]  =  3
              (1 -> 3 rises, 3 -> 2 falls, 2 -> 5 rises, 5 -> 6 rises)

    How to test: remove the "-- " in front of ONE "main = print ..." line below and run
        runghc PT3_B.hs
    The value after the last "--" on that line is the expected output.
    (You can also load the file in GHCi and type the expression.)
-}

countRises :: [Int] -> Int
countRises xs = length [ b | (a, b) <- zip xs (drop 1 xs), b > a ]




countRises1 :: [Int] -> Int
countRises xs = lenght [x | x <- xs, head xs > x]


-- main = print (countRises [1,3,2,5,6])  -- 3
-- main = print (countRises [1,2,3,4])    -- 3
-- main = print (countRises [5,4,3])      -- 0
-- main = print (countRises [3,3,3])      -- 0
-- main = print (countRises [7])          -- 0
-- main = print (countRises [])           -- 0
