# Подготовка к midterm: тренажёры

- `samples/`: 6 sample-мидтермов (67 задач).
- `trainers/`: 12 тренажёров, по одному на каждый тип задач. Решаешь здесь.
- `solutions/`: те же файлы с решениями. Открывай только после своей попытки.
- `check.py`: прогоняет все тесты файла.

## Как устроен каждый тренажёр

| Часть | Что внутри |
|---|---|
| **0. Общая шпаргалка** | обзор всех приёмов этого типа задач |
| **>>> ТЕОРИЯ** перед каждой задачей | всё, что нужно именно для неё: новые функции с примерами, план решения, часто похожий разобранный пример |
| **A. Разминка** | 5–7 простых функций, по одной идее на задачу |
| **B. Посложнее** | 6–8 задач, которые собирают идеи из A и готовят к экзамену |
| **C. Задачи из sample** | реальные задачи из `samples/` с исходными условиями (на английском) и тестами |

Замени `undefined` своим решением. В части C можно вызывать свои функции из A и B.

## Как проверять

```sh
python3 check.py trainers/01_digits.hs     # все тесты одного файла
python3 check.py trainers/*.hs             # всё сразу
```

Скрипт выводит, сколько тестов прошло, сколько задач ещё не решено (`undefined`), и для каждого упавшего теста пишет номер строки, что получилось и что ожидалось.

Можно проверять и как на экзамене: убери `-- ` перед одной строкой `main = print ...` и запусти `runghc trainers/01_digits.hs`. Ещё вариант: `ghci trainers/01_digits.hs`, после правок `:r`.

## Карта: задача из sample → тренажёр

| # | Тренажёр | Задачи из sample |
|---|---|---|
| 01 | `01_digits`: цифры числа, div/mod, двоичная запись | m1#1 countOdds, m2#1 sumOfSquaresOfDigits, m2#4 isAllOnes, m3#1 sumOfDigitsPower, m3#3 transformList, m4#1 changeNumber |
| 02 | `02_recursion_sequences`: рекурсия, ranges, iterate/takeWhile | m2#11 generateFiltered, m3#2 jacobsthal, m3#4 arithmeticSequence, m5#4 generateSumString (×), m5#7 fib-суммы, m6#1 sumAlternatingSquares, m6#4 generateSumString (+) |
| 03 | `03_primes_divisors`: делители, простые, gcd | m1#10 perfectNumbers, m2#2 isPrime, m3#10 primeTriplets, m6#7 t3 |
| 04 | `04_comprehension_pairs`: генераторы пар и троек | m1#7 divisiblePairs, m1#12 extendBLib, m2#10 findPairs, m2#12 newGuess, m5#2 f3, m6#2 f4 |
| 05 | `05_strings_chars`: строки, Data.Char | m2#6 f1, m3#5 countVowels, m4#8 sortMyString, m4#9 f5, m5#8 keeper |
| 06 | `06_list_recursion`: образцы x:y:rest, span, group | m1#3 prefixes, m4#3 / m5#1 groupConsecutive, m5#3 computeK, m6#3 computeS |
| 07 | `07_zip_indices`: zip, zipWith, индексы, матрицы | m1#4 ssd, m1#6 indexSums, m2#7 absDiff, m4#2 zeroes2Index, m4#6 mapWithIndex |
| 08 | `08_neighbours`: соседи, окна, серии | m1#8 countNegativePositivePairs, m2#3 countOddGap, m6#6 t1 |
| 09 | `09_membership_counting`: elem, nub, подсчёт | m1#2 commonElements, m3#9 difference, m5#9 replaceWithOccurrence, m5#10 tupleCheck, m6#8 makeNegative |
| 10 | `10_hof_lists_of_lists`: map/filter/fold, [[Int]] | m1#11 cntSums, m2#5 selectiveMap, m3#8 f2, m3#11 multiplyWithMin, m4#5 squareOdds, m4#10 keepMorePositives |
| 11 | `11_tuples`: пары, тройки, unzip, fromIntegral | m1#5 sumPairs, m1#9 canAfford, m2#9 filterTupleSum, m3#7 mergeTuples, m4#4 tupleDifferences, m4#7 extractNamesAndAges, m5#6 categorizeEmployees |
| 12 | `12_doubles_aggregation`: Double, среднее, медиана, min/max по ключу | m2#8 averageScores, m3#6 var, m3#12 analyzePrices, m4#11 earliestBus, m4#12 analyzeScores, m5#5 gradeAvg, m6#5 distanceCalc, m6#9 employees |

## Ошибки в самих sample-файлах

Ниже места, где ожидаемый ответ в sample не совпадает с условием. В тренажёрах тесты уже исправлены, а рядом с задачей есть пометка.

- **m4#1 changeNumber 45347 4**: в sample написано `-4547`, правильно `4547`.
- **m4#3 groupConsecutive [1,1,2,2,3,4,3,4]**: правильно `[[1,1],[2,2],[3],[4],[3],[4]]`.
- **m1#3 prefixes "abc"**: правильно `["a","ab","abc"]`.
- **m3#10 primeTriplets**: судя по тестам, все три числа должны быть ≤ n, а не только p.
- **m5#2 f3**: в тестах c доходит до n включительно, хотя в условии сказано «less than n».
- **m2#7 absDiff**: из дубликатов остаётся последнее вхождение, а `nub` оставляет первое.
- **m2#9 filterTupleSum**: первые три теста в sample противоречат условию (там сравнение «меньше»).
- **m3#6 var**: третий ответ ≈ `13.888893`, а не `3.888893`.
- **m3#7 mergeTuples []**: правильно `([],[])`.
- **m3#12 analyzePrices**: правильно `1224.98`, а не `1225.98`.
- **m4#12 analyzeScores**: пустой вход даёт `(0.0,0)`, а вход из одних невалидных оценок даёт `(NaN,0)`.
- **m6#1 sumAlternatingSquares**: числа в описании неверные, правильные ответы стоят в тестах.
- **m6#5 distanceCalc**: в тестах встречается то «to point», то «to our point». Взят вариант из условия.
- **m6#9 newPay**: ответ `127.2` — это сумма прибавок, а не новый фонд зарплат.
