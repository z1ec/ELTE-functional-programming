-- ============================================================================
-- 05. СТРОКИ И СИМВОЛЫ  (String = [Char], Data.Char)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/05_strings_chars.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: 0 -> A -> B -> C.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для этой задачи.
--   * runghc: убери "-- " перед ОДНОЙ строкой "main = print ...", сохрани и запусти
--             runghc 05_strings_chars.hs
--     Ожидаемый ответ записан после последнего "--" в строке теста.
--     "error: текст" значит, что программа должна упасть с  error "текст".
--   * ghci:   ghci 05_strings_chars.hs, потом пиши выражение, после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из частей A и B.
--
-- Задачи из sample в этом файле:
--   midterm2 #6, midterm3 #5, midterm4 #8, midterm4 #9, midterm5 #8

import Data.Char (toUpper, toLower, isDigit, isAlpha, isSpace, digitToInt)

------------------------------------------------------------------------------
-- ЧАСТЬ 0. ОБЩАЯ ШПАРГАЛКА  (разбор по задачам — в блоках ">>> ТЕОРИЯ" ниже)
------------------------------------------------------------------------------
-- String — это просто список символов:  "abc" == ['a','b','c']
-- Значит работают ВСЕ функции списков: map, filter, length, reverse, ++, concatMap...
--
-- Data.Char (import Data.Char):
--     toUpper 'a' == 'A'      toLower 'Q' == 'q'
--     isDigit '7' == True     isAlpha 'x' == True    isSpace ' ' == True
--     isUpper 'A' == True     digitToInt '7' == 7
--
-- Принадлежность символа набору:
--     c `elem` "aeiou"       -- гласная (маленькая)
--     toLower c `elem` "aeiou" -- гласная без учёта регистра
--
-- Типичные схемы:
--     map f s                             -- заменить каждый символ
--     filter p s                          -- выкинуть ненужные символы
--     length (filter p s)                 -- посчитать символы
--     map (\c -> if p c then 'O' else c) s  -- заменить только некоторые
--
-- Слова:
--     words "hi  there you" == ["hi","there","you"]
--     unwords ["a","b"]     == "a b"
--     concatMap (\w -> w ++ " ") ["a","b"] == "a b "   -- пробел после КАЖДОГО
--
-- Символ vs строка:  'O' — Char,  "O" — String (список из одного Char).
--   В map результат должен быть Char:  map (\c -> 'O') ...
--
-- Позиции символов (подробнее в 07):
--     [c | (i, c) <- zip [0..] s, even i]   -- символы на чётных позициях
--
-- print vs putStrLn: print "hi" печатает "hi" С кавычками (это show),
--                    putStrLn "hi" — без кавычек. В тестах везде print.

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: строка = список Char, map, toUpper
--   "abc" — это то же самое, что ['a','b','c']. Одинарные кавычки — символ (Char).
--   toUpper 'a' == 'A'   (из Data.Char)
--   map применяет функцию к каждому символу:   map toLower "HeLLo" == "hello"
--
-- A1. Все буквы в верхний регистр.
shout :: String -> String
shout s = map toUpper s
-- main = print (shout "hello")  -- "HELLO"

-- >>> ТЕОРИЯ: elem, toLower
--   c `elem` "aeiou" — есть ли символ c в строке "aeiou".
--   Чтобы регистр не мешал, сначала переведи в маленькую:  toLower c `elem` "aeiou"
--   ('E' -> 'e' -> есть в "aeiou" -> True)
--
-- A2. Гласная ли буква (a, e, i, o, u), без учёта регистра.
isVowel :: Char -> Bool
isVowel c = toLower c `elem` "aeiou"
-- main = print (isVowel 'a')  -- True
-- main = print (isVowel 'E')  -- True
-- main = print (isVowel 'x')  -- False

-- >>> ТЕОРИЯ: filter по символам
--   filter (/= ' ') s оставляет всё, что НЕ пробел   (/= значит "не равно"):
--       filter (/= 'a') "banana" == "bnn"
--
-- A3. Удалить все пробелы.
removeSpaces :: String -> String
removeSpaces s = filter (/= ' ') s
-- main = print (removeSpaces "a b  c")  -- "abc"

-- >>> ТЕОРИЯ: посчитать = length (filter ...)
--   (== c) значит "равно c", и c может быть аргументом:
--       length (filter (== 'a') "banana") == 3
--
-- A4. Сколько раз символ встречается в строке.
countChar :: Char -> String -> Int
countChar c s = length (filter (== c) s)
-- main = print (countChar 'l' "hello")  -- 2
-- main = print (countChar 'z' "hello")  -- 0

-- >>> ТЕОРИЯ: isDigit
--   isDigit '7' == True,   isDigit 'a' == False
--   filter isDigit s оставляет только цифры.
--
-- A5. Оставить только цифры.
onlyDigits :: String -> String
onlyDigits s = filter isDigit s
-- main = print (onlyDigits "a1b22c3")  -- "1223"

-- >>> ТЕОРИЯ: образец (c:rest) для строк, оператор (:)
--   Образец (c:rest): c — первый символ, rest — всё остальное:
--       "haskell"  ->  c = 'h',  rest = "askell"
--   Пустая строка под (c:rest) не подходит, для неё нужна отдельная строка:
--       firstUp []       = []
--       firstUp (c:rest) = ... : rest
--   (:) кладёт ОДИН элемент в начало списка:   'H' : "askell" == "Haskell"
--   ++ склеивает ДВА списка:                   "Ha" ++ "skell" == "Haskell"
--
-- A6. Первая буква заглавная, остальное без изменений.
capitalize :: String -> String
capitalize []       = []
capitalize (c:rest) = toUpper c : rest
-- main = print (capitalize "haskell")  -- "Haskell"
-- main = print (capitalize "")  -- ""

------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: map с лямбдой и if
--   Лямбда — функция без имени:  \c -> ...
--       map (\c -> if c == 'a' then 'o' else c) "banana" == "bonono"
--   У if обе ветки должны быть одного типа (здесь обе Char).
--
-- B1. Заменить каждый символ a на символ b.
replaceChar :: Char -> Char -> String -> String
replaceChar a b s = map (\c -> if c == a then b else c) s
-- main = print (replaceChar 'a' 'o' "banana")  -- "bonono"

-- >>> ТЕОРИЯ: words
--   words разбивает строку по пробелам на список слов:
--       words "I love Haskell" == ["I","love","Haskell"]
--   Потом map length.
--
-- B2. Длины слов.
wordLengths :: String -> [Int]
wordLengths s = map length (words s)
-- main = print (wordLengths "I love Haskell")  -- [1,4,7]

-- >>> ТЕОРИЯ: words -> map -> unwords
--   unwords делает обратное: склеивает слова через пробел:
--       unwords ["a","b","c"] == "a b c"
--   ПЛАН: разбить на слова -> к каждому capitalize (A6) -> склеить.
--
-- B3. Каждое слово с заглавной буквы.
capitalizeWords :: String -> String
capitalizeWords s = unwords (map capitalize (words s))
-- main = print (capitalizeWords "functional programming is fun")  -- "Functional Programming Is Fun"

-- >>> ТЕОРИЯ: B1 + своё условие
--   Вместо c == 'a' — isVowel c (A2), вместо 'o' — '*'.
--
-- B4. Каждую гласную (любого регистра) заменить на '*'.
censor :: String -> String
censor s = map (\c -> if isVowel c then '*' else c) s
-- main = print (censor "Hello World")  -- "H*ll* W*rld"

-- >>> ТЕОРИЯ: локальная функция с guards в where
--   Когда вариантов больше двух, удобнее отдельная функция с guards:
--       mark s = map conv s
--         where conv c | c == '!'  = '.'
--                      | isSpace c = '_'
--                      | otherwise = c
--       mark "Hi Bo!" == "Hi_Bo."
--   isAlpha c — буква ли c.  Guards проверяются сверху вниз, порядок важен.
--
-- B5. Цифру заменить на '#', букву на 'a', остальное не трогать.
classify :: String -> String
classify s = map conv s
  where conv c | isDigit c = '#'
               | isAlpha c = 'a'
               | otherwise = c
-- main = print (classify "R2-D2!")  -- "a#-a#!"

-- >>> ТЕОРИЯ: filter по списку строк
--   Здесь элементы — слова (String). Условие "в слове есть c":  c `elem` w
--       filter (\w -> 'a' `elem` w) ["cat","dog"] == ["cat"]
--
-- B6. Оставить только слова, в которых есть символ c.
wordsContaining :: Char -> [String] -> [String]
wordsContaining c ws = filter (\w -> c `elem` w) ws
-- main = print (wordsContaining 'a' ["cat","dog","bat"])  -- ["cat","bat"]

-- >>> ТЕОРИЯ: цепочка filter -> map -> sum
--   digitToInt '7' == 7
--   "a1b2c3"  -> filter isDigit -> "123"  -> map digitToInt -> [1,2,3]  -> sum -> 6
--
-- B7. Сумма всех цифр, встречающихся в строке.
sumDigitsInString :: String -> Int
sumDigitsInString s = sum (map digitToInt (filter isDigit s))
-- main = print (sumDigitsInString "a1b2c3")  -- 6
-- main = print (sumDigitsInString "abc")  -- 0

-- >>> ТЕОРИЯ: concatMap для строк
--   concatMap f ws применяет f к каждому слову и склеивает результаты:
--       concatMap (\w -> w ++ "?") ["a","b"] == "a?b?"
--
-- B8. Каждое слово + "!" после него, всё склеить (без пробелов).
exclaimAll :: [String] -> String
exclaimAll ws = concatMap (\w -> w ++ "!") ws
-- main = print (exclaimAll ["hi","yo"])  -- "hi!yo!"

------------------------------------------------------------------------------
-- ЧАСТЬ C. ЗАДАЧИ ИЗ SAMPLE-МИДТЕРМОВ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ к C1: это B4
--   Гласные (любого регистра) -> 'O'. Это символ 'O', а не строка "O".
--
-- C1. [midterm2 #6]
-- Write a function that takes a string and changes every vowel to O.
f1 :: String -> String
f1 s = map (\c -> if isVowel c then 'O' else c) s
-- main = print (f1 "Apple is my favourite electronics company")  -- "OpplO Os my fOvOOrOtO OlOctrOnOcs cOmpOny"
-- main = print (f1 "cad!ng luiks se giad")  -- "cOd!ng lOOks sO gOOd"

-- >>> ТЕОРИЯ к C2: это A4, только условие isVowel
--   length (filter isVowel s)
--
-- C2. [midterm3 #5]
-- Write a function, that counts the number of vowels (a, e, i, o, u) in a given string.
-- The function should be case insensitive.
countVowels :: String -> Int
countVowels s = length (filter isVowel s)
-- main = print (countVowels "Hello World")  -- 3
-- main = print (countVowels "Functional")  -- 4
-- main = print (countVowels "Haskell")  -- 2
-- main = print (countVowels "xyz")  -- 0

-- >>> ТЕОРИЯ к C3: B5 + B8 + "." в конце
--   1) символ -> 'O' / 'l' / как есть: локальная conv с guards, как в B5.
--      Сначала проверяй гласную, потом isAlpha (гласные ведь тоже буквы!).
--   2) каждое слово:  map conv w ++ " "
--   3) склеить всё (concatMap) и в конце ++ "."
--   ["Hi","how"]  ->  "lO " ++ "lOl " ++ "."  ==  "lO lOl ."
--
-- C3. [midterm4 #9]
-- Write a function that takes a list of strings and returns a single string.
-- Every vowel should be changed to "O" (uppercase o) and every consonant should be
-- changed to "l" (lowercase L), special characters are unchanged,
-- a space should be added after every substring and a "." at the end.
-- ["Hi", "how", "are", "you"] -> "lO lOl OlO lOO ."
f5 :: [String] -> String
f5 ws = concatMap (\w -> map conv w ++ " ") ws ++ "."
  where conv c | isVowel c = 'O'
               | isAlpha c = 'l'
               | otherwise = c
-- main = print (f5 ["Hi", "how", "are", "you"])  -- "lO lOl OlO lOO ."
-- main = print (f5 ["functional", "Programming", "is", "nice", "&", "very", "fun", "$$ :)"])  -- "lOlllOOlOl llOllOllOll Ol lOlO & lOll lOl $$ :) ."

-- >>> ТЕОРИЯ к C4: guards по аргументу k + error
--   Три случая — три guard'а:
--       | isVowel k            -> оставить слова, где ЕСТЬ k
--       | k `elem` ['1'..'9']  -> error "Number passed in"      (['1'..'9'] == "123456789")
--       | otherwise            -> оставить слова, где НЕТ k     (notElem)
--   Порядок важен: гласная проверяется первой.
--
-- C4. [midterm5 #8]
-- Given a list of strings and a character k:
-- If k is a vowel, omit all strings that do not contain k.
-- If k is a digit between 1 and 9, throw an error.
-- If k is neither a vowel nor a digit, omit all strings containing k.
-- All strings and characters given are in lowercase.
keeper :: [String] -> Char -> [String]
keeper ws k
  | isVowel k          = filter (\w -> k `elem` w) ws
  | k `elem` ['1'..'9'] = error "Number passed in"
  | otherwise          = filter (\w -> k `notElem` w) ws
-- main = print (keeper ["hello", "world", "!"] 'e')  -- ["hello"]
-- main = print (keeper [] 'c')  -- []
-- main = print (keeper ["123321", "great", "arnold", "armstrong"] 'g')  -- ["123321","arnold"]
-- main = print (keeper ["house", "haskell", "hiking", "holiday"] '3')  -- error: Number passed in

-- >>> ТЕОРИЯ к C5: индексы символов
--   zip [0..] s нумерует символы:   zip [0..] "abc" == [(0,'a'),(1,'b'),(2,'c')]
--   Символы на чётных позициях:     [c | (i, c) <- zip [0..] s, even i]
--   Ответ: чётные ++ " " ++ нечётные.
--
-- C5. [midterm4 #8]
-- Given a string s, return another string such that even-indexed and odd-indexed
-- characters of s are grouped and the groups are space-separated.
-- Even-indexed group comes first, then a space, then the odd-indexed part.
-- "meirdmt" => "midt erm"   (indices 0246 | 135)
sortMyString :: String -> String
sortMyString s = [c | (i, c) <- zip [0..] s, even i] ++ " " ++ [c | (i, c) <- zip [0..] s, odd i]
-- main = print (sortMyString "01234567")  -- "0246 1357"
-- main = print (sortMyString "caonrsrweecrt!")  -- "correct answer!"
-- main = print (sortMyString "meirdmt")  -- "midt erm"
-- main = print (sortMyString "FPurnocgtriaomnianlg")  -- "Functional Programing"
