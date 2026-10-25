main :: IO ()
main = print 0

-- 1. Keep the tails of a list.
-- e.g. [[1, 2, 3], [3, 4], [5, 7, 8, 9]] -> [[2, 3], [4], [7, 8, 9]] 

tails :: [[Int]] -> [[Int]]
tails x = map tail x

--main = print(tails [[1, 2, 3], [3, 4], [5, 7, 8, 9]]) -- [[2, 3], [4], [7, 8, 9]] 



-- 2. Check if the numbers of a list are multiple of 10.

ismult10 :: [Int] -> [Bool]
ismult10 x = map (\x -> x `rem` 10 == 0) x 

--main = print(ismult10 [1..20])
--[False,False,False,False,False,False,False,False,False,True,False,False,False,False,False,False,False,False,False,True]



-- 3. Collect in a list the last digits of the numbers of a list.

lastdigits :: [Int] -> [Int]
lastdigits x = map (\x -> x `rem` 10) x

--main = print(lastdigits [1..35])
-- [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5]



-- 4. Reverse every sublist of a list.

revsub :: [[Int]] ->  [[Int]]
revsub x = map (\x -> reverse x) x

--main = print(revsub [[1,2,3],[5,6],[],[7,8,9,10]]) -- [[3,2,1],[6,5],[],[10,9,8,7]]



-- 5. Keep the last elements of the sublists of a list in one list 
-- (assume the sublists are not empty).
-- E.g. [[1,2,3],[5,6],[1],[7,8,9,10]] -> [3,6,1,10]

lasts :: [[Int]] -> [Int]
lasts x = undefined

--main = print(lasts [[1,2,3],[5,6],[1],[7,8,9,10]]) -- [3,6,1,10]



-- 6. Compute the product of the elements of a list using foldr.

prodf :: [Int] -> Int
prodf x = undefined

prodf2 :: [Int] -> Int
prodf2 x = product x

--main = print(prodf [1,5,2,4]) -- 40
--main = print(prodf2 [1,5,2,4]) -- 40



-- 7. Compute 1*1 + 2*2 + ... + n*n  for n positive using map and foldr.
-- creates the [1..5] list
-- then maps x*x to every element from the list [1,4,9,16,25]
-- then sums up using foldr 55

sumsqr :: Int -> Int
sumsqr n = foldr (+) 0 (map (^2)[1..n])

--main = print(sumsqr 5) -- 55
--main = print(sumsqr 0) -- 0 -- the list is [1..0] which is empty, then foldr has as result 0
--main = print(sumsqr (-4)) -- 0 -- same here



-- 8. Using notempty, eliminate the empty lists from a list of lists. 
-- [[1,2,3],[],[3,4,5],[2,2],[],[],[]] -> [[1,2,3], [3,4,5], [2,2]]

notempty :: [Int] -> Bool
notempty x = not (x == [])

f8 :: [[Int]] -> [[Int]]
f8 x = filter notempty x

--main = print(f8 [[1,2,3],[],[3,4,5],[2,2],[],[],[]]) -- [[1,2,3],[3,4,5],[2,2]]


-- using lambda expression
f82 :: [[Int]] -> [[Int]]
f82 x = filter (\x -> x /= []) x

--main = print(f82 [[1,2,3],[],[3,4,5],[2,2],[],[],[]]) -- [[1,2,3],[3,4,5],[2,2]]



-- 9. Compute the sum of the sublists using foldr [[1,2,3], [3,4,5], [2,2]] -> [6, 12, 4]

f9 :: [[Int]] -> [Int]
f9 x = undefined

--f9 x = map (foldr (+) 0) x  -- partial parameterization !!!
--f9 x = map sum x

--main = print(f9 [[1,2,3], [3,4,5], [2,2]]) -- [6,12,4]



-- 10. Insert x as second element in every sublist of a list.
-- if the sublist was empty then x will be the only element in the new sublist. 
-- [[1,2], [3,4,5], [6,5,9,7], [], [8]] 10 -> [[1,10,2], [3,10,4,5], [6,10,5,9,7], [10], [8,10]]

insAux :: Int -> [Int]  -> [Int]
insAux e [] = [e]
insAux e (x:xs) = x:e:xs

insertAtTwo :: [[Int]] -> Int -> [[Int]]
insertAtTwo lists number = undefined

--main = print(insertAtTwo [[1,2], [3,4,5], [6,5,9,7], [], [8]] 10)
-- [[1,10,2],[3,10,4,5],[6,10,5,9,7],[10],[8,10]]



-- 11. Given a list of lists, for each list, extract the first, middle and last element.

extract3 :: [[Int]] -> [[Int]]
extract3 x = undefined

--main = print(extract3 [[1..9], [2..6], [3..11], [1..10]]) -- [[1,5,9],[2,4,6],[3,7,11],[1,6,10]]
--main = print(extract3 []) --[]



-- 12. Write a function that checks if each elements in the list appear even times.
-- E.g. checkEven [1,1,2,2,2,2,3,5,3,5] = True  

checkAux :: [Int] -> Int -> Bool
checkAux list number = undefined 

checkEven :: [Int] -> Bool
checkEven list = undefined

--main = print(checkEven [1,1,2,2,2,2,3,5,3,5]) -- True
--main = print(checkEven [1,1,2,2,1]) -- False
--main = print(checkEven []) -- True