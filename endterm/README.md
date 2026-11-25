# Подготовка к endterm: тренажёры

- `samples/` — 4 sample-эндтерма (из `endterm_samples.zip`).
- `trainers/` — 11 тренажёров, по одному на тему. Решаешь здесь.
- `solutions/` — те же файлы с решениями. Открывай только после своей попытки.
- `check.py` — прогоняет все тесты файла.
- `theory_quiz.md` — вопросы к теоретическому квизу (10 баллов на экзамене) с ответами.

## Как устроен каждый тренажёр

| Часть | Что внутри |
|---|---|
| **>>> ТЕОРИЯ** перед каждой задачей | всё, что нужно именно для этой задачи: новые функции с примерами и план решения |
| **A. Разминка** | 3 совсем простые задачи, по одной идее на каждую |
| **B. Посложнее** | 3 задачи среднего уровня, готовят к C |
| **C. Как на экзамене** | задачи из `samples/` с исходными условиями (на английском) и тестами, а также новые задачи того же уровня |

Замени `undefined` своим решением. В части C можно вызывать свои функции из A и B.

## Как проверять

```sh
cd endterm
python3 check.py trainers/01_parallel_comprehension.hs   # один файл
python3 check.py trainers/*.hs                           # всё сразу
```

Скрипт показывает, сколько тестов прошло и сколько задач ещё не решено (`undefined`). Для каждого упавшего теста он пишет номер строки, что получилось и что ожидалось.

Можно проверять и как на экзамене: убери `-- ` перед одной строкой `main = print ...` и запусти `runghc trainers/01_parallel_comprehension.hs`. Ещё вариант — `ghci trainers/01_parallel_comprehension.hs`, после правок `:r`.

## Карта: тема → задачи из sample

| # | Тренажёр | Задачи из sample |
|---|---|---|
| 01 | `01_parallel_comprehension`: `[.. \| x <- xs \| y <- ys]` | e1#1 mulAdA, e1#2 elementWise, e1#3 processTuples, e2#1 applyFunction, e2#2 gen2, e3#1 dotProd, e3#2 lightStates, e4#1 gen1, e4#2 shiftPoints |
| 02 | `02_records`: поля, фильтр, record update | e1#4 renameUniversity, e1#5 outstandingStudents, e2#3 rec1, e2#4 studentsAvg + averageGradeForUniversity, e3#3 failingStudents |
| 03 | `03_records_aggregation`: максимум, группы по команде | e3#4 topScorersInTeam (30p), e4#3 topTeam (20p) |
| 04 | `04_trees_basic`: рецепт для дерева, обходы, map | e1#6 swapSubTree, e2#5 tr1, e2#6 tr2, e3#5 evenSumOddSum, e3#6 replaceNodes, e4#4 playersFromTeam, e4#6 isPaliTree |
| 05 | `05_trees_advanced`: дети узла, глубина, выражения, BST | e1#7 evaluate, e2#7 changeTree, e2#8 Eq для BST, e4#5 trim |
| 06 | `06_algebraic_types`: свои типы, Maybe | e1#8 combineColors |
| 07 | `07_show_instances`: свой `show` | e1#9 Show Player/Team, e2#9 Sport, e3#7 Student, e4#7 BTree, e4#8 Player |
| 08 | `08_eq_instances`: своё `==` | e1#10 Player, e3#8 Product/Customer, e4#9 Player/Team |
| 09 | `09_hof_fold_infinite`: map/filter/fold, iterate, ленивость | из syllabus |
| 10 | `10_sorting_merging`: insertion/quick/merge sort, слияние, поиск | из syllabus |
| 11 | `11_type_classes`: deriving Ord/Enum, свой class, instance Ord/Num | из syllabus |

Типичный экзамен: задачи 1–2 на параллельные генераторы (01), 1–2 на records (02, 03), 2–3 на деревья (04, 05), 2–3 на instance Show/Eq (07, 08), иногда задача на свой тип (06).

## Что странного в самих sample-файлах

Тесты в тренажёрах написаны так, чтобы совпадать с sample. Где условие расходится с тестами, рядом с задачей есть пометка.

- **e1#2 elementWise.** «Division if defined» на деле означает, что нули из второго списка выкидываются, а потом списки идут параллельно. Ровно это делает `[x / y | x <- xs | y <- ys, y /= 0]`.
- **e1#6 swapSubTree.** Картинка похожа на полное зеркало, но тесты меняют местами только два поддерева корня.
- **e1#7 evaluate.** В условии строки с пробелами, в тестах без пробелов. Сделано по тестам.
- **e1#9 Show Player/Team и e4#8 Show Player** задают разные форматы для одного типа. В одном файле может быть только один instance, поэтому в тренажёре 07 тип для e1#9 называется `Member`.
- **e1#10 и e4#9 Eq Player** — разные правила равенства. В тренажёре 08 тип для e1#10 называется `Athlete`.
- **e4#3 topTeam.** У Team B и Team C одинаково по 150, а ожидается 3. Так получается, если брать `maximum` по парам `(сумма, id)`.
- **e4#4 playersFromTeam.** Порядок ответа соответствует preorder (корень, левое, правое).
- **e4#8 Show Player.** Первый тест и условие расходятся в запятых и точке. Взят формат второго теста: `I am John from Team B, my average score is 22.0 which is quite good`.
- **e2#7 changeTree.** Не сказано, смотреть на исходные или уже изменённые значения детей. Тесты проходят с исходными.
