-- ============================================================================
-- 02. RECORDS  (data с именованными полями: чтение, фильтр, изменение)
-- ============================================================================
-- ТРЕНАЖЁР. Решения лежат в ../solutions/02_records.hs (открывай только после своей попытки)
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/02_records.hs
--   * Или как на экзамене: убери "-- " перед ОДНОЙ строкой "main = print ...",
--     сохрани и запусти   runghc 02_records.hs
--   * ghci 02_records.hs, потом пиши выражение; после правок — :r
--   * В части C можно (и нужно) вызывать свои функции из A и B.
--
-- Задачи из sample в этом файле:
--   endterm1 #4 renameUniversity, #5 outstandingStudents
--   endterm2 #3 rec1, #4 studentsAvg + averageGradeForUniversity
--   endterm3 #3 failingStudents

------------------------------------------------------------------------------
-- ДАННЫЕ (такие же, как на экзамене)
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: что такое record
--   data Car = Car {brand :: String, year :: Int, price :: Int} deriving (Show)
--          ^тип  ^конструктор  ^поля с типами
--   Каждое поле автоматически становится ФУНКЦИЕЙ, которая достаёт значение:
--       brand :: Car -> String          brand car1 == "Toyota"
--       year  :: Car -> Int             year car1  == 2015
--   deriving (Show) — чтобы можно было печатать через print.
--   deriving (Eq)   — чтобы можно было сравнивать через ==.
--   Создать значение:
--       car1 = Car {brand = "Toyota", year = 2015, price = 8000}
--       car1 = Car "Toyota" 2015 8000            -- то же самое, по порядку полей

data Car = Car {brand :: String, year :: Int, price :: Int} deriving (Show)

car1 = Car {brand = "Toyota", year = 2015, price = 8000}
car2 = Car {brand = "BMW", year = 2020, price = 25000}
car3 = Car {brand = "Lada", year = 1999, price = 1500}

data Univ = Univ {uniName :: String, uniID :: Int} deriving (Show, Eq)

data Student = Student {neptunID :: Int, studentName :: String, uni :: Univ, grades :: [Int]} deriving (Show)

univ1 = Univ {uniName = "University A", uniID = 1}
univ2 = Univ {uniName = "University B", uniID = 2}
univ3 = Univ {uniName = "University C", uniID = 3}

student1 = Student {neptunID = 101, studentName = "Alice", uni = univ1, grades = [85, 90, 78]}
student2 = Student {neptunID = 102, studentName = "Bob", uni = univ1, grades = [88, 92, 80]}
student3 = Student {neptunID = 103, studentName = "Charlie", uni = univ2, grades = [75, 85, 82]}
student4 = Student {neptunID = 104, studentName = "David", uni = univ2, grades = [90, 87, 91]}
student5 = Student {neptunID = 105, studentName = "Eve", uni = univ3, grades = [80, 83, 88]}
student6 = Student {neptunID = 106, studentName = "Frank", uni = univ3, grades = [85, 89, 84]}
student7 = Student {neptunID = 103, studentName = "Charlie1", uni = univ2, grades = [75, 59, 82]}
student8 = Student {neptunID = 105, studentName = "Eve1", uni = univ3, grades = [80, 9, 8]}

students = [student1, student2, student3, student4, student5, student6]

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: читаем поле
--   Поле — это функция:  year car1 == 2015
--   Пример:  isNew c = year c >= 2020       -- isNew car2 == True
--
-- A1. Возраст машины в году now.   carAge 2026 car1 == 11
carAge :: Int -> Car -> Int
carAge = undefined
-- main = print (carAge 2026 car1)  -- 11
-- main = print (carAge 2026 car3)  -- 27


-- >>> ТЕОРИЯ: изменить поле (record update)
--   Данные в Haskell не меняются "на месте". Делаем КОПИЮ с новым значением поля:
--       c { price = 100 }          -- копия c, у которой price = 100
--       c { price = price c - 1 }  -- старая цена минус 1
--   Остальные поля копируются без изменений.
--   Пример:  makeOld c = c { year = 1990 }
--
-- A2. Уменьши цену машины на d.
discount :: Int -> Car -> Car
discount = undefined
-- main = print (discount 500 car1)  -- Car {brand = "Toyota", year = 2015, price = 7500}
-- main = print (discount 0 car3)  -- Car {brand = "Lada", year = 1999, price = 1500}


-- >>> ТЕОРИЯ: map по списку records
--   map применяет функцию к каждому элементу:
--       map brand [car1, car2]  == ["Toyota","BMW"]
--   Поле — это обычная функция, поэтому его можно прямо отдать в map.
--   То же через comprehension:  [brand c | c <- [car1, car2]]
--
-- A3. Имена всех студентов.
studentNames :: [Student] -> [String]
studentNames = undefined
-- main = print (studentNames [student1, student3])  -- ["Alice","Charlie"]
-- main = print (studentNames [])  -- []


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: поле внутри поля + фильтр
--   uni s — это Univ студента, а uniID (uni s) — номер его университета:
--       uniID (uni student3) == 2
--   Фильтр через comprehension:
--       [c | c <- cars, price c < 10000]       -- дешёвые машины
--   Сравнивать университеты можно целиком (у Univ есть deriving Eq):
--       uni s == u
--   или по номеру (так надёжнее, если у типа нет Eq):
--       uniID (uni s) == uniID u
--
-- B1. Студенты, которые учатся в университете u.
--   (в тесте берём map studentName, чтобы ответ был коротким)
studentsOf :: Univ -> [Student] -> [Student]
studentsOf = undefined
-- main = print (map studentName (studentsOf univ1 students))  -- ["Alice","Bob"]
-- main = print (map studentName (studentsOf univ3 students))  -- ["Eve","Frank"]
-- main = print (map studentName (studentsOf univ2 []))  -- []


-- >>> ТЕОРИЯ: есть ли в списке подходящий элемент
--   Способ 1:  any условие список
--       any (> 90) [85, 92, 80]   == True        any even [1,3] == False
--   Способ 2 (без any):  список подходящих не пустой
--       filter (> 90) [85, 92, 80] /= []          == True
--   (> 90) — это функция "больше 90?":  (> 90) 95 == True
--
-- B2. Есть ли у студента оценка БОЛЬШЕ k?
hasGradeAbove :: Int -> Student -> Bool
hasGradeAbove = undefined
-- main = print (hasGradeAbove 90 student2)  -- True
-- main = print (hasGradeAbove 90 student1)  -- False
-- main = print (hasGradeAbove 50 student8)  -- True


-- >>> ТЕОРИЯ: среднее значение (Int -> Double)
--   sum и length дают Int. Делить через / можно только дробные числа,
--   поэтому переводим их в Double функцией fromIntegral:
--       fromIntegral (sum xs) / fromIntegral (length xs)
--   Пустой список: деление 0/0 дало бы NaN, поэтому отдельный случай:
--       average [] = 0.0
--       average xs = ...
--
-- B3. Среднее списка оценок (для пустого — 0.0).
average :: [Int] -> Double
average = undefined
-- main = print (average [85, 90, 78])  -- 84.33333333333333
-- main = print (average [1, 2])  -- 1.5
-- main = print (average [])  -- 0.0


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ (задачи из sample)
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: это B2 + фильтр + map
--   План:
--     1) оставь студентов, у которых есть оценка > 90  (hasGradeAbove 90 s)
--     2) возьми их имена  (studentName s)
--   Одной строкой:  [studentName s | s <- ss, hasGradeAbove 90 s]
--
-- C1 (endterm1 #5). List all students who have at least one grade
--   greater than 90. Write the names of these students.
outstandingStudents :: [Student] -> [String]
outstandingStudents = undefined
-- main = print (outstandingStudents students)  -- ["Bob","David"]
-- main = print (outstandingStudents [student1, student3])  -- []


-- >>> ТЕОРИЯ: elem + guards + record update
--   elem x список — есть ли x в списке. Строка — это список символов:
--       elem 'c' "Alice" == True          elem 'x' "Alice" == False
--   Guards (условия через |):
--       f s | условие   = ответ1
--           | otherwise = ответ2        -- otherwise = "иначе"
--   Изменить поле — как в A2:   s { neptunID = neptunID s + 100 }
--
-- C2 (endterm2 #3). You are given a student, a character, and a number.
--   If the student's name contains the given character and the university's
--   id matches the given number, increase the student's neptunID by 100.
rec1 :: Student -> Char -> Int -> Student
rec1 = undefined
-- main = print (rec1 student1 'c' 1)  -- Student {neptunID = 201, studentName = "Alice", uni = Univ {uniName = "University A", uniID = 1}, grades = [85,90,78]}
-- main = print (rec1 student1 'x' 1)  -- Student {neptunID = 101, studentName = "Alice", uni = Univ {uniName = "University A", uniID = 1}, grades = [85,90,78]}
-- main = print (rec1 student2 'o' 2)  -- Student {neptunID = 102, studentName = "Bob", uni = Univ {uniName = "University A", uniID = 1}, grades = [88,92,80]}
-- main = print (rec1 student2 'o' 1)  -- Student {neptunID = 202, studentName = "Bob", uni = Univ {uniName = "University A", uniID = 1}, grades = [88,92,80]}


-- >>> ТЕОРИЯ: пары (имя, список) и проверка "список не пустой"
--   Для каждого студента считаем его плохие оценки:
--       [g | g <- grades s, g < 60]
--   и оставляем только тех, у кого этот список НЕ пустой.
--   В comprehension можно завести имя через let:
--       [(studentName s, bad) | s <- ss, let bad = [g | g <- grades s, g < 60], bad /= []]
--   Или сделать функцию-помощника:
--       badGrades s = [g | g <- grades s, g < 60]
--   и писать  [(studentName s, badGrades s) | s <- ss, badGrades s /= []]
--
-- C3 (endterm3 #3). Filter out the list of students who failed at least one
--   course. A student fails a course if the grade is lower than 60.
--   Return a list of student names and their failing scores.
failingStudents :: [Student] -> [(String, [Int])]
failingStudents = undefined
-- main = print (failingStudents [student1, student2, student7, student4, student8, student6])  -- [("Charlie1",[59]),("Eve1",[9,8])]
-- main = print (failingStudents [student1, student2, student3])  -- []
-- main = print (failingStudents [])  -- []


-- >>> ТЕОРИЯ: все оценки всех студентов в один список
--   map grades ss         даёт список списков:  [[85,90,78],[88,92,80]]
--   concat  склеивает его в один список:        [85,90,78,88,92,80]
--   (или comprehension:  [g | s <- ss, g <- grades s])
--   Потом среднее — функция average из B3 (для [] она уже даёт 0.0).
--
-- C4 (endterm2 #4, part 1). Given a list of students, determine their
--   average grade (average of ALL their grades together).
studentsAvg :: [Student] -> Double
studentsAvg = undefined
-- main = print (studentsAvg [])  -- 0.0
-- main = print (studentsAvg [student1])  -- 84.33333333333333
-- main = print (studentsAvg [student2, student4, student5])  -- 86.55555555555556


-- >>> ТЕОРИЯ: собираем из готовых частей
--   1) студенты этого университета — studentsOf из B1
--   2) их средняя — studentsAvg из C4 (для пустого списка уже 0.0)
--   3) ответ — пара (uniName u, средняя)
--
-- C5 (endterm2 #4, part 2). Given a university and a list of students,
--   filter out the students who are not enrolled at the given university.
--   Return a tuple: (name of the university, average grade of its students).
--   If no students are enrolled in the university, the average should be 0.0.
averageGradeForUniversity :: Univ -> [Student] -> (String, Double)
averageGradeForUniversity = undefined
-- main = print (averageGradeForUniversity univ1 [])  -- ("University A",0.0)
-- main = print (averageGradeForUniversity univ3 [student5])  -- ("University C",83.66666666666667)
-- main = print (averageGradeForUniversity univ1 [student5])  -- ("University A",0.0)
-- main = print (averageGradeForUniversity univ2 [student1, student2, student3, student4, student5, student6])  -- ("University B",85.0)


-- >>> ТЕОРИЯ: изменить поле ВНУТРИ вложенного record
--   Название университета лежит внутри студента:  uniName (uni s)
--   Шаг 1 — новый университет (копия старого с новым именем):
--       newU = (uni s) { uniName = name }
--   Шаг 2 — новый студент с этим университетом:
--       s { uni = newU }
--   Всё вместе для ОДНОГО студента:
--       change s | uniID (uni s) == uniID u = s { uni = (uni s) { uniName = name } }
--                | otherwise                = s
--   Для списка — map change ss  (change можно написать в where).
--
-- C6 (endterm1 #4). A university wants to update its name. Given a
--   university, a new name and a list of students, update the university name
--   for all students associated with that university.
renameUniversity :: Univ -> String -> [Student] -> [Student]
renameUniversity = undefined
-- main = print (renameUniversity univ3 "Corvinus" [student6])  -- [Student {neptunID = 106, studentName = "Frank", uni = Univ {uniName = "Corvinus", uniID = 3}, grades = [85,89,84]}]
-- main = print (renameUniversity univ1 "ELTE" [student1, student2, student3])  -- [Student {neptunID = 101, studentName = "Alice", uni = Univ {uniName = "ELTE", uniID = 1}, grades = [85,90,78]},Student {neptunID = 102, studentName = "Bob", uni = Univ {uniName = "ELTE", uniID = 1}, grades = [88,92,80]},Student {neptunID = 103, studentName = "Charlie", uni = Univ {uniName = "University B", uniID = 2}, grades = [75,85,82]}]
-- main = print (renameUniversity univ2 "BME" [student3, student4, student6, student5])  -- [Student {neptunID = 103, studentName = "Charlie", uni = Univ {uniName = "BME", uniID = 2}, grades = [75,85,82]},Student {neptunID = 104, studentName = "David", uni = Univ {uniName = "BME", uniID = 2}, grades = [90,87,91]},Student {neptunID = 106, studentName = "Frank", uni = Univ {uniName = "University C", uniID = 3}, grades = [85,89,84]},Student {neptunID = 105, studentName = "Eve", uni = Univ {uniName = "University C", uniID = 3}, grades = [80,83,88]}]
