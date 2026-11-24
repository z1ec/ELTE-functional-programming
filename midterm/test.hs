import Data.Char (toUpper)
import Data.List (sort) 
import Data.Char (isLower, isUpper, toLower)
import Data.List 



quickSort :: [Int] -> [Int] 
quickSort [] = []
quickSort (p:rest) = quickSort [ x | x <- rest, x < p ] ++ [p] ++ quickSort [ x | x <- rest, x >= p]
    


map1 :: [Int] -> [Int]
map1 list = map (\x -> x + 1) list



foldl11 :: [Int] -> Int
foldl11 list = foldl (+) 0 list