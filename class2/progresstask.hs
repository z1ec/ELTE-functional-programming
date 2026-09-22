{- Progress Task 1 — Variant A -}

{- Your Neptun code:  G9ZVX2        -}

{-
    A parking garage charges for parking like this:

      - If the number of minutes is 0 or negative, the result is "Invalid".
      - If the car stayed at most 30 minutes, parking is free: the result is "Free".
      - Otherwise the driver pays 400 Ft for every STARTED hour.
        (60 minutes is 1 hour, 61 minutes counts as 2 hours.)
        The result is the price followed by " Ft", for example "800 Ft".

    Write the function parkingFee that takes the number of minutes and returns the result as a String.

    How to test: remove the "-- " in front of ONE "main = print ..." line below and run
        runghc PT1_A.hs
    The value after the last "--" on that line is the expected output.
    (You can also load the file in GHCi and type the expression.)
-}

parkingFee :: Int -> String
parkingFee minutes
  | minutes <= 0 = "Invalid"
  | minutes <= 30 = "Free"
  | otherwise = show (hours * 400) ++ " Ft"
  where
    hours = (minutes + 59) `div` 60

-- main = print (parkingFee 0)     -- "Invalid"
-- main = print (parkingFee (-5))  -- "Invalid"
-- main = print (parkingFee 15)    -- "Free"
-- main = print (parkingFee 30)    -- "Free"
-- main = print (parkingFee 31)    -- "400 Ft"
-- main = print (parkingFee 60)    -- "400 Ft"
-- main = print (parkingFee 61)    -- "800 Ft"
-- main = print (parkingFee 150)   -- "1200 Ft"
