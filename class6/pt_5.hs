{- Progress Task 5 — Variant A -}

{- Your Neptun code:   G9ZVX2       -}

{-
    Exam scores are given in a list. The first NEGATIVE number marks the end of the valid
    scores: it and everything after it must be ignored.
    Every valid score gets 10 bonus points, but no score may go above 100.

    Write the function processScores. Use higher-order functions (no recursion needed).

    Example:  processScores [50, 95, 70, -1, 80]  =  [60, 100, 80]

    How to test: remove the "-- " in front of ONE "main = print ..." line below and run
        runghc PT5_A.hs
    The value after the last "--" on that line is the expected output.
    (You can also load the file in GHCi and type the expression.)
-}

processScores :: [Int] -> [Int]
processScores xs = map (\x -> min 100 (x + 10)) (takeWhile (>= 0) xs)

-- main = print (processScores [50,95,70,-1,80])  -- [60,100,80]
-- main = print (processScores [-5,10])           -- []
-- main = print (processScores [100])             -- [100]
-- main = print (processScores [])                -- []
