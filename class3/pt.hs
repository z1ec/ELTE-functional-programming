{- Progress Task 2 — Variant B -}

{- Your Neptun code:          -}

{-
    Write the function evenDigitProduct that multiplies the EVEN digits
    of a positive number together.

      - If the number has no even digits at all, the result is 1.
      - Remember that 0 is an even digit too.

    Example:  evenDigitProduct 1234  =  2 * 4  =  8

    How to test: remove the "-- " in front of ONE "main = print ..." line below and run
        runghc PT2_B.hs
    The value after the last "--" on that line is the expected output.
    (You can also load the file in GHCi and type the expression.)
-}

evenDigitProduct :: Int -> Int
evenDigitProduct n
    |


isEvenIn :: Int -> Bool
isEvenIn n
    | n < 10 = if even n then 1 else 0
    | otherwise = 



-- main = print (evenDigitProduct 1234)  -- 8
-- main = print (evenDigitProduct 135)   -- 1
-- main = print (evenDigitProduct 8)     -- 8
-- main = print (evenDigitProduct 222)   -- 8
-- main = print (evenDigitProduct 2046)  -- 0
