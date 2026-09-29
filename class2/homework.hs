-- Week 2 — Homework (optional, but strongly recommended)
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
-- Tasks 1–9 are typical exam level. ★ = harder, ★★ = challenge.
-- Use the recipe: base case, step ("pretend the smaller call already works"), progress.

-- 1. Sum of the odd numbers from 1 up to n (0 if n <= 0).
sumOdd :: Int -> Int
sumOdd n
    | n <= 0 = 0
    | odd n = n + sumOdd(n-2)
    | otherwise = sumOdd(n-1)
    
    
-- main = print (sumOdd 10)  -- 25
-- main = print (sumOdd 9)   -- 25
-- main = print (sumOdd 1)   -- 1
-- main = print (sumOdd 0)   -- 0

-- 2. n^n + (n-1)^(n-1) + ... + 1^1  (0 if n <= 0). You may use ^.
sumPowers :: Int -> Int
sumPowers n
    | n <= 0 = 0
    | otherwise = n^n + sumPowers(n-1)
-- main = print (sumPowers 5)  -- 3413
-- main = print (sumPowers 1)  -- 1
-- main = print (sumPowers 0)  -- 0

-- 3. Sum of the multiples of k that are between 1 and n (k is positive).
sumMultiples :: Int -> Int -> Int
sumMultiples k n
    | n <= 0        = 0
    | n `mod` k == 0 = n + sumMultiples k (n - 1)
    | otherwise     = sumMultiples k (n - 1)
-- -- main = print (sumMultiples 3 10)  -- 18
-- -- main = print (sumMultiples 5 25)  -- 75
-- -- main = print (sumMultiples 5 4)   -- 0

-- -- 4. The biggest digit of a non-negative number.
maxDigit :: Int -> Int
maxDigit n
    | n < 10 = n
    | otherwise = max(n `mod` 10) (maxDigit(n `div` 10))
-- main = print (maxDigit 38291)  -- 9
-- main = print (maxDigit 1111)   -- 1
-- main = print (maxDigit 0)      -- 0

-- -- 5. Are all digits of a non-negative number odd?
allDigitsOdd :: Int -> Bool
allDigitsOdd n
    | n < 10 = odd n
    | otherwise = odd  (n `mod` 10) && allDigitsOdd (n `div` 10)
-- -- main = print (allDigitsOdd 1357)  -- True
-- -- main = print (allDigitsOdd 1352)  -- False
-- -- main = print (allDigitsOdd 2)     -- False

-- -- 6. Given a positive number and the String "Odd" or "Even", return the sum of
-- --    the odd digits (for "Odd") or the sum of the even digits (for "Even").
-- --    Strings can be compared with ==, e.g.  kind == "Odd"
digitSummation :: Int -> String -> Int
digitSummation n kind
    | n < 10 = if func n then n else 0
    | otherwise = (if func (n `mod` 10) then (n `mod` 10) else 0) + digitSummation (n `div` 10) kind
     where 
        func n = if kind == "Odd" then odd n else even n 
-- -- main = print (digitSummation 123046 "Odd")   -- 4
-- -- main = print (digitSummation 123046 "Even")  -- 12
-- -- main = print (digitSummation 745209 "Even")  -- 6
-- -- main = print (digitSummation 745209 "Odd")   -- 21
-- -- main = print (digitSummation 353 "Even")     -- 0

-- -- 7. A football ticket code is a positive number. The ticket is "VIP" if the code
-- --    is even AND the sum of its digits is odd. Otherwise it is "Normal".
ticketType :: Int -> String
ticketType code
    | even code && odd (digitSum code) = "VIP"
    | otherwise = "Normal"
    where
        digitSum n
            | n < 10 = n
            | otherwise = (n `mod` 10) + digitSum (n `div` 10)
-- -- main = print (ticketType 123456)  -- "VIP"
-- -- main = print (ticketType 224388)  -- "VIP"
-- -- main = print (ticketType 118822)  -- "Normal"
-- -- main = print (ticketType 123457)  -- "Normal"

-- -- 8. Add two non-negative numbers, then count how many digits of the sum are
-- --    multiples of 3 (0, 3, 6 and 9 all count).
-- --    430 + 561 = 991 -> 9 and 9 are multiples of 3, 1 is not -> 2
multipleOf3Digits :: Int -> Int -> Int
multipleOf3Digits x y = count1 (x + y)
    where
        count1 i
            | i < 10 = if i `mod` 3 == 0 then 1 else 0
            | otherwise = count1 (i `mod` 10) + count1 (i `div` 10)

-- -- main = print (multipleOf3Digits 430 561)  -- 2
-- -- main = print (multipleOf3Digits 438 561)  -- 3
-- -- main = print (multipleOf3Digits 96999 0)  -- 5
-- -- main = print (multipleOf3Digits 30 0)     -- 2

-- -- 9. A number is perfect if it equals the sum of its divisors smaller than itself.
-- --    6 = 1 + 2 + 3,  28 = 1 + 2 + 4 + 7 + 14.
-- --    First write sumDivisors (ALL divisors, including n), then use it in isPerfect.
-- --    Hint: look at countDivisors from the class demo.
sumDivisors :: Int -> Int
sumDivisors n = sumDivisorsHelp n n - n

sumDivisorsHelp :: Int -> Int -> Int
sumDivisorsHelp 1 _ = 1
sumDivisorsHelp d n = (if n `mod` d == 0 then d else 0) + sumDivisorsHelp (d - 1) n

-- -- main = print (sumDivisors 12)  -- 28
-- -- main = print (sumDivisors 7)   -- 8

isPerfect :: Int -> Bool
isPerfect n = if sumDivisors n == n then True else False
-- -- main = print (isPerfect 6)   -- True
-- -- main = print (isPerfect 28)  -- True
-- -- main = print (isPerfect 12)  -- False

-- -- 10. ★ Collatz: if n is even, go to n `div` 2, if odd, go to 3*n + 1.
-- --     How many steps does it take to reach 1?
-- --     6 -> 3 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1   is 8 steps.
collatzSteps :: Int -> Int
collatzSteps n = helpFunc 0 n

helpFunc :: Int -> Int -> Int
helpFunc count n
    | n <= 1 = count
    | otherwise = if even n then helpFunc (count + 1) (n `div` 2) else helpFunc (count + 1) (3 * n + 1)
-- -- main = print (collatzSteps 1)   -- 0
-- -- main = print (collatzSteps 6)   -- 8
-- -- main = print (collatzSteps 27)  -- 111

-- -- 11. ★ Reverse the digits of a non-negative number.
-- --     Hint: you may use countDigits from the class and ^.
reverseNumber :: Int -> Int
reverseNumber n = go n 0
    where
        go 0 acc = acc
        go m acc = go (m `div` 10) (acc * 10 + m `mod` 10)
-- -- main = print (reverseNumber 1234)  -- 4321
-- -- main = print (reverseNumber 1200)  -- 21
-- -- main = print (reverseNumber 7)     -- 7

-- -- 12. ★ Write a non-negative number in binary, as an Int made of 0 and 1 digits.
-- --     10 = 8 + 2 -> 1010
toBinary :: Int -> Int
toBinary n
    | n == 0 = 0
    | otherwise = n `mod` 2 + 10 * toBinary (n `div` 2)
-- -- main = print (toBinary 10)  -- 1010
-- -- main = print (toBinary 5)   -- 101
-- -- main = print (toBinary 1)   -- 1
-- -- main = print (toBinary 0)   -- 0

-- -- 13. ★ Greatest common divisor of two positive numbers, using only subtraction:
-- --     subtract the smaller number from the bigger one until they are equal.
myGcd :: Int -> Int -> Int
myGcd a b
    | a == b    = a
    | a > b     = myGcd (a - b) b
    | otherwise = myGcd a (b - a)
-- -- main = print (myGcd 24 36)  -- 12
-- -- main = print (myGcd 7 13)   -- 1
-- -- main = print (myGcd 5 5)    -- 5

-- -- 14. ★★ Fibonacci numbers: fib 1 = 1, fib 2 = 1, and every next one is the sum of the previous two.
-- --     Then: the sum of the ODD numbers among fib 1 .. fib n.
-- --     1 1 2 3 5 8 13 21 34 55  ->  1+1+3+5+13+21+55 = 99
fib :: Int -> Int
fib n
    | n <= 2 = 1
    | otherwise = fib (n - 1) + fib (n - 2)
-- main = print (fib 1)   -- 1
-- main = print (fib 10)  -- 55

oddFibSum :: Int -> Int
oddFibSum n
    | n <= 0 = 0
    | odd (fib n) = fib n + oddFibSum (n - 1)
    | otherwise = oddFibSum (n - 1)
-- -- main = print (oddFibSum 10)  -- 99
-- -- main = print (oddFibSum 0)   -- 0
-- -- main = print (oddFibSum 20)  -- 14328
