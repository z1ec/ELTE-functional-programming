-- Week 1 — Homework (optional, but strongly recommended)
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
-- Tasks marked ★ are harder. They prepare you for next week.

------------------------------------------------------------------------
-- Part A. Types
------------------------------------------------------------------------

-- A1. These three functions have no type signatures. Write the missing
--     signature above each one. Decide the types from the description first.
--     Then you may compare your answer with what  :t  says in GHCi.

-- Halve a real number.
halvex ::   Double -> Double
halvex x = x / 2
-- main = print (halve 5)  -- 2.5

-- Is a person of the given age (in whole years) an adult?
isAdult :: Int -> Bool
isAdult age = age >= 18
-- main = print (isAdult 20)  -- True
-- main = print (isAdult 17)  -- False

-- Put a first name and a last name together.
fullName :: String -> String -> String
fullName firstName lastName = firstName ++ " " ++ lastName
-- main = print (fullName "Ada" "Lovelace")  -- "Ada Lovelace"

-- A2. The two functions below do not compile. Remove the "-- " in front of the
--     signature and the definition, load the file, read the error message, and fix it.
--     Do not change the type signatures!

-- What percentage of `whole` is `part`?
percent :: Double -> Double -> Double                                               -- The problem was with types of input data
percent part whole = part / whole * 100
-- main = print (percent 1 4)  -- 25.0

-- Describe an age as text.
ageText :: Int -> String                                                               -- method ++ cant be used with different types
ageText age = "Age: " ++ show age
-- main = print (ageText 19)  -- "Age: 19"

------------------------------------------------------------------------
-- Part B. Functions and guards
------------------------------------------------------------------------

-- 1. Cube of a number.
cube :: Int -> Int
cube x = x * x * x
-- main = print (cube 3)     -- 27
-- main = print (cube (-2))  -- -8

-- 2. Is a number odd? Do NOT use the built-in odd or even functions.
isOdd :: Int -> Bool
isOdd n
    | mod n 2 == 0 = False
    | otherwise = True
-- main = print (isOdd 7)   -- True
-- main = print (isOdd 10)  -- False

-- 3. Grandma buys apples (500 Ft/kg), olives (800 Ft/kg) and potatoes (150.5 Ft/kg).
--    Given the kilograms of each, compute the total price.
fruitCost :: Double -> Double -> Double -> Double
fruitCost apples olives potatoes = apples * 500 + olives * 800 + potatoes * 150.5
-- main = print (fruitCost 5 7 10)  -- 9605.0
-- main = print (fruitCost 0 0 2)   -- 301.0

-- 4. Average of three whole numbers, as a Double.
--    Hint: `fromIntegral` converts an Int into a Double: fromIntegral (a + b + c) / 3
average3 :: Int -> Int -> Int -> Double
average3 a b c = (fromIntegral a + fromIntegral b + fromIntegral c) / 3
-- main = print (average3 1 2 3)  -- 2.0
-- main = print (average3 1 2 6)  -- 3.0
-- main = print (average3 1 1 2)  -- 1.3333333333333333

-- 5. Given two positive numbers, is one of them divisible by the other?
divAny :: Int -> Int -> Bool
divAny a b
    | mod a b == 0 = True
    | mod b a == 0 = True
    | otherwise = False
-- main = print (divAny 44 11)   -- True
-- main = print (divAny 11 44)   -- True
-- main = print (divAny 44 110)  -- False

-- 6. If both numbers are odd, return their product.
--    If both are even, return their sum. Otherwise return 0.
oddEven :: Int -> Int -> Int
oddEven a b
    | mod a b == 0 = a * b
    | otherwise = a + b
-- main = print (oddEven 7 7)       -- 49
-- main = print (oddEven 6 6)       -- 12
-- main = print (oddEven 474 8983)  -- 0

-- 7. Turn a digit 0..5 into an English word. For anything else return "Unknown".
digitToWord :: Int -> String
digitToWord n
    | n == 0 = "Zero"
    | n == 1 = "One"
    | n == 2 = "Two"
    | n == 3 = "Three"
    | n == 4 = "Four"
    | n == 5 = "Five"
    | otherwise = "Unknown"

-- main = print (digitToWord 0)     -- "Zero"
-- main = print (digitToWord 3)     -- "Three"
-- main = print (digitToWord 8)     -- "Unknown"
-- main = print (digitToWord (-1))  -- "Unknown"

-- 8. Are three numbers in non-decreasing order?
isSorted3 :: Int -> Int -> Int -> Bool
isSorted3 a b c = if a <= b && b <= c
    then True
    else False
-- main = print (isSorted3 1 2 3)  -- True
-- main = print (isSorted3 1 1 1)  -- True
-- main = print (isSorted3 3 2 1)  -- False
-- main = print (isSorted3 1 3 2)  -- False

-- 9. Is the year a leap year?
--    A year is a leap year if it is divisible by 4 but not by 100,
--    or if it is divisible by 400.
isLeapYear :: Int -> Bool
isLeapYear y
    | mod y 400 == 0 = True
    | mod y 4 == 0 && mod y 100 /= 0 = True
    | otherwise = False
-- main = print (isLeapYear 1996)  -- True
-- main = print (isLeapYear 2000)  -- True
-- main = print (isLeapYear 1900)  -- False
-- main = print (isLeapYear 1997)  -- False

-- 10. Convert a number of days into years, weeks and days (a year is 365 days).
--     Use `show` to turn numbers into Strings.
daysToText :: Int -> String
daysToText d = show(div d 365) ++ " years " ++ show(div (mod d 365) 7) ++ " weeks " ++ show(mod (mod d 365) 7) ++ " days"

-- main = print (daysToText 375)   -- "1 years 1 weeks 3 days"
-- main = print (daysToText 365)   -- "1 years 0 weeks 0 days"
-- main = print (daysToText 1050)  -- "2 years 45 weeks 5 days"

-- 11. What kind of triangle do the side lengths a, b, c form?
--     "Not a triangle" if any side is not shorter than the sum of the other two,
--     "Equilateral" if all sides are equal,
--     "Isosceles" if exactly two sides are equal,
--     "Scalene" otherwise.
--     Think carefully about the ORDER of your guards.

triangleKind :: Int -> Int -> Int -> String
triangleKind a b c
    | a >= b + c || b >= a + c || c >= a + b = "Not a triangle"
    | a == b && b == c = "Equilateral"
    | a == b || b == c || a == c = "Isosceles"
    | otherwise = "Scalene"

-- main = print (triangleKind 3 3 3)   -- "Equilateral"
-- main = print (triangleKind 3 3 5)   -- "Isosceles"
-- main = print (triangleKind 3 4 5)   -- "Scalene"
-- main = print (triangleKind 1 2 3)   -- "Not a triangle"
-- main = print (triangleKind 1 1 10)  -- "Not a triangle"

-- 12. ★ Sum of the digits of a three-digit number (100..999). No recursion needed.
--     Hint: which digit do you get with `mod` 10? What does `div` 10 do?

sumDigits3 :: Int -> Int
sumDigits3 n = mod n 10 + mod (div n 10) 10 + div n 100

-- main = print (sumDigits3 123)  -- 6
-- main = print (sumDigits3 909)  -- 18
-- main = print (sumDigits3 100)  -- 1

-- 13. ★ Reverse a three-digit number (100..999).

reverse3 :: Int -> Int
reverse3 n = mod n 10 * 100 + mod (div n 10) 10 * 10 + div n 100

-- main = print (reverse3 123)  -- 321
-- main = print (reverse3 120)  -- 21
-- main = print (reverse3 505)  -- 505
