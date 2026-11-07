import Data.Char (isUpper)

{- Progress Task 6 — Variant B -}

{- Your Neptun code:   G9ZVX2       -}

{-
    In a sentence, some words start with a capital letter.
    What is the total number of letters in those words?

    Write the function capitalLetters. Use a fold (no recursion needed).
    (words splits the sentence into words; isUpper is imported for you.)

    Example:  capitalLetters "Anna met Bob in Budapest"  =  15
              ("Anna" 4 + "Bob" 3 + "Budapest" 8)

    How to test: remove the "-- " in front of ONE "main = print ..." line below and run
        runghc PT6_B.hs
    The value after the last "--" on that line is the expected output.
    (You can also load the file in GHCi and type the expression.)

    When you are done: in Teams, open the assignment "PT 6", attach THIS file and press "Turn in".
-}

capitalLetters :: String -> Int
capitalLetters s = foldl (\acc x -> if (isUpper (head x)) then (acc + length x) else acc) (0) (words s) 

-- main = print (capitalLetters "Anna met Bob in Budapest")  -- 15
-- main = print (capitalLetters "no capitals here")          -- 0
-- main = print (capitalLetters "Hello")                     -- 5
-- main = print (capitalLetters "")                          -- 0
