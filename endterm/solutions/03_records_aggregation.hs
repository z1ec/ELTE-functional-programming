-- ============================================================================
-- 03. RECORDS: МАКСИМУМ, ГРУППЫ, "ЛУЧШИЙ В КОМАНДЕ"  (большие задачи на 20–30 баллов)
-- ============================================================================
-- РЕШЕНИЯ. Сначала реши сам в ../trainers/03_records_aggregation.hs
--
-- Как работать:
--   * Замени каждый `undefined` своим решением. Иди по порядку: A -> B -> C.
--     A = разминка (совсем просто), B = средние, C = задачи как на экзамене.
--   * Перед КАЖДОЙ задачей есть блок ">>> ТЕОРИЯ" — там всё, что нужно для неё.
--   * Проверить все тесты файла (из папки endterm):
--         python3 check.py trainers/03_records_aggregation.hs
--   * Или: убери "-- " перед ОДНОЙ строкой "main = print ..." и  runghc 03_records_aggregation.hs
--   * В части C вызывай свои функции из A и B — экзаменационная задача
--     как раз так и разбита на маленькие шаги (a, b, c, ...).
--
-- Задачи из sample в этом файле:
--   endterm3 #4 topScorersInTeam (30 баллов), endterm4 #3 topTeam (20 баллов)

import Data.List (nub)

------------------------------------------------------------------------------
-- ДАННЫЕ
------------------------------------------------------------------------------
-- (что такое record и как читать поля — см. 02_records.hs)
-- У Team НЕТ deriving Eq, поэтому команды сравниваем по номеру:
--     teamID (playerTeam p) == teamID t

data Team = Team {teamName :: String, teamID :: Int} deriving (Show)

data Player = Player {playerID :: Int, playerName :: String, playerTeam :: Team, playerScores :: [Int]} deriving (Show)

team1 = Team {teamName = "Team A", teamID = 1}
team2 = Team {teamName = "Team B", teamID = 2}
team3 = Team {teamName = "Team C", teamID = 3}
team0 = Team {teamName = "Team D", teamID = 0}

player1 = Player {playerID = 1, playerName = "Alice", playerTeam = team1, playerScores = [10, 20, 30]}
player2 = Player {playerID = 2, playerName = "Bob", playerTeam = team1, playerScores = [15, 25, 35]}
player3 = Player {playerID = 3, playerName = "Charlie", playerTeam = team2, playerScores = [12, 22, 32]}
player4 = Player {playerID = 4, playerName = "David", playerTeam = team2, playerScores = [18, 28, 38]}
player5 = Player {playerID = 5, playerName = "Eve", playerTeam = team3, playerScores = [14, 24, 34]}
player6 = Player {playerID = 6, playerName = "Frank", playerTeam = team3, playerScores = [16, 26, 36]}
player7 = Player {playerID = 7, playerName = "John", playerTeam = team2, playerScores = [12, 22, 32]}
player8 = Player {playerID = 8, playerName = "Peter", playerTeam = team2, playerScores = [10, 5, 5]}

players = [player1, player2, player3, player4, player5, player6]
allPlayers = [player1, player2, player3, player4, player5, player6, player7, player8]

-- Суммы очков (пригодятся для проверки в голове):
--   Alice 60, Bob 75 | Charlie 66, David 84, John 66, Peter 20 | Eve 72, Frank 78

------------------------------------------------------------------------------
-- ЧАСТЬ A. РАЗМИНКА
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: сумма поля-списка
--   playerScores p — это список [Int]. sum его складывает:
--       sum (playerScores player1) == 10 + 20 + 30 == 60
--
-- A1 (endterm3 #4e). Total score of a player.
totalScore :: Player -> Int
totalScore p = sum (playerScores p)
-- main = print (totalScore player1)  -- 60
-- main = print (totalScore player8)  -- 20


-- >>> ТЕОРИЯ: фильтр по команде
--   Команда игрока:  playerTeam p          её номер:  teamID (playerTeam p)
--   Оставить игроков команды t:
--       [p | p <- ps, teamID (playerTeam p) == teamID t]
--
-- A2 (endterm3 #4a). Players belonging to the given team.
playersOf :: Team -> [Player] -> [Player]
playersOf t ps = [p | p <- ps, teamID (playerTeam p) == teamID t]
-- main = print (map playerName (playersOf team2 allPlayers))  -- ["Charlie","David","John","Peter"]
-- main = print (map playerName (playersOf team0 allPlayers))  -- []


-- >>> ТЕОРИЯ: максимум, когда список может быть пустым
--   maximum [3,9,2] == 9.   НО  maximum []  — ошибка (программа падает)!
--   Поэтому пустой список — отдельным уравнением:
--       maxTotal [] = 0
--       maxTotal ps = maximum (map totalScore ps)
--   map totalScore ps — список сумм всех игроков.
--
-- A3 (endterm3 #4c). The maximum total score from a list of players (0 for []).
maxTotal :: [Player] -> Int
maxTotal [] = 0
maxTotal ps = maximum (map totalScore ps)
-- main = print (maxTotal allPlayers)  -- 84
-- main = print (maxTotal [player1, player2])  -- 75
-- main = print (maxTotal [])  -- 0


------------------------------------------------------------------------------
-- ЧАСТЬ B. ПОСЛОЖНЕЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: выбрать всех с нужной суммой
--   [p | p <- ps, totalScore p == k]
--   Если таких несколько — в ответ попадут ВСЕ (так и нужно на экзамене:
--   "find the players with the highest score" — игроков может быть двое).
--
-- B1 (endterm3 #4d). Players whose total score equals k.
withTotal :: Int -> [Player] -> [Player]
withTotal k ps = [p | p <- ps, totalScore p == k]
-- main = print (map playerName (withTotal 66 allPlayers))  -- ["Charlie","John"]
-- main = print (map playerName (withTotal 1 allPlayers))  -- []


-- >>> ТЕОРИЯ: nub — убрать повторы
--   import Data.List (nub)     -- уже написано вверху файла
--   nub [1,1,2,1,3] == [1,2,3]        (порядок первых появлений сохраняется)
--   Номера команд всех игроков:  map teamID (map playerTeam ps)  -> [1,1,2,2,3,3]
--   Потом nub.
--
-- B2. Номера всех команд, без повторов, в порядке появления.
teamIds :: [Player] -> [Int]
teamIds ps = nub (map teamID (map playerTeam ps))
-- main = print (teamIds allPlayers)  -- [1,2,3]
-- main = print (teamIds [player5, player1, player6])  -- [3,1]
-- main = print (teamIds [])  -- []


-- >>> ТЕОРИЯ: сумма по группе
--   Сумма всех игроков команды с номером tid:
--       sum [totalScore p | p <- ps, teamID (playerTeam p) == tid]
--
-- B3. Суммарные очки команды с номером tid.
teamTotal :: Int -> [Player] -> Int
teamTotal tid ps = sum [totalScore p | p <- ps, teamID (playerTeam p) == tid]
-- main = print (teamTotal 1 players)  -- 135
-- main = print (teamTotal 2 allPlayers)  -- 236
-- main = print (teamTotal 9 allPlayers)  -- 0


------------------------------------------------------------------------------
-- ЧАСТЬ C. КАК НА ЭКЗАМЕНЕ
------------------------------------------------------------------------------

-- >>> ТЕОРИЯ: собираем из шагов A и B
--   1) teamPlayers = playersOf t ps          (A2)
--   2) best        = maxTotal teamPlayers    (A3)
--   3) ответ       = withTotal best teamPlayers   (B1)
--   Через where:
--       f t ps = withTotal best teamPlayers
--         where teamPlayers = playersOf t ps
--               best        = maxTotal teamPlayers
--   Если в команде никого нет, teamPlayers = [] и ответ сам получится [].
--
-- C1 (endterm3 #4, 30p). Find the Player with the Highest Score in a Team.
--   Take a Team and a list of Player records, and find the players with the
--   highest total score in that team. If there are no players in the given
--   team return empty list.
--   a. Filter players belonging to the given team.          (A2)
--   b. Find the highest total score among players.          (A3)
--   c. Calculate the maximum score from a list of players.  (A3)
--   d. Select players with the highest score.               (B1)
--   e. Calculate the total score of a player.               (A1)
--   f. Put together, finding players with top scores.       (здесь)
topScorersInTeam :: Team -> [Player] -> [Player]
topScorersInTeam t ps = withTotal best teamPlayers
  where
    teamPlayers = playersOf t ps
    best = maxTotal teamPlayers
-- main = print (topScorersInTeam team1 [player1, player2, player3, player4, player5, player6])  -- [Player {playerID = 2, playerName = "Bob", playerTeam = Team {teamName = "Team A", teamID = 1}, playerScores = [15,25,35]}]
-- main = print (topScorersInTeam team2 [player1, player2, player3, player4, player5, player6])  -- [Player {playerID = 4, playerName = "David", playerTeam = Team {teamName = "Team B", teamID = 2}, playerScores = [18,28,38]}]
-- main = print (topScorersInTeam team3 [player1, player2, player3, player4, player5, player6])  -- [Player {playerID = 6, playerName = "Frank", playerTeam = Team {teamName = "Team C", teamID = 3}, playerScores = [16,26,36]}]
-- main = print (topScorersInTeam team0 [])  -- []
-- main = print (map playerName (topScorersInTeam team2 [player3, player7, player8]))  -- ["Charlie","John"]


-- >>> ТЕОРИЯ: максимум по ПАРАМ (сумма, номер)
--   Кортежи сравниваются по первому элементу, при равенстве — по второму:
--       maximum [(135,1), (150,2), (150,3)] == (150,3)
--   Значит: строим пары (сумма команды, номер команды) для всех команд
--       [(teamTotal tid ps, tid) | tid <- teamIds ps]
--   берём maximum и достаём номер: snd (пара)   (snd (150,3) == 3)
--   Внимание: в тесте у Team B и Team C одинаково по 150, ожидается 3 —
--   ровно это и даёт maximum по парам.
--   Пустой список — ошибка:  topTeam [] = error "No Team!"
--
-- C2 (endterm4 #3, 20p). Given a list of players, find the team with the top
--   total score. Return the id of the top team.
topTeam :: [Player] -> Int
topTeam [] = error "No Team!"
topTeam ps = snd (maximum [(teamTotal tid ps, tid) | tid <- teamIds ps])
-- main = print (topTeam [player1, player2, player3, player4, player5, player6])  -- 3
-- main = print (topTeam [player1, player2, player3, player4])  -- 2
-- main = print (topTeam [player1])  -- 1
-- main = print (topTeam [])  -- error: No Team!


-- >>> ТЕОРИЯ: имя команды по номеру + среднее
--   Чтобы получить ИМЯ команды по номеру tid, возьми первого её игрока:
--       teamName (playerTeam (head (filter ... ps)))
--   head список — первый элемент (список тут точно не пустой).
--   Среднее Double: fromIntegral (сумма) / fromIntegral (количество).
--   Можно завести имена прямо в comprehension через let:
--       [ (имя, среднее) | tid <- teamIds ps
--                        , let tps = [p | p <- ps, teamID (playerTeam p) == tid]
--                        , let ... ]
--
-- C3 (exam-like). For each team (in order of first appearance) return its
--   name and the average total score of its players.
teamAverages :: [Player] -> [(String, Double)]
teamAverages ps =
  [ (teamName (playerTeam (head tps)), fromIntegral (sum (map totalScore tps)) / fromIntegral (length tps))
  | tid <- teamIds ps,
    let tps = [p | p <- ps, teamID (playerTeam p) == tid]
  ]
-- main = print (teamAverages players)  -- [("Team A",67.5),("Team B",75.0),("Team C",75.0)]
-- main = print (teamAverages [player8, player4])  -- [("Team B",52.0)]
-- main = print (teamAverages [])  -- []


-- >>> ТЕОРИЯ: для каждой команды — лучший игрок
--   Для каждого tid из teamIds:
--     1) игроки команды
--     2) лучшие из них (как в C1)
--     3) берём ПЕРВОГО лучшего (head) и делаем пару (tid, его имя)
--   Можно повторно использовать C1, если сделать Team из номера... но проще
--   сразу:  withTotal (maxTotal tps) tps
--
-- C4 (exam-like). For each team (in order of first appearance) return the
--   pair (team id, name of its best player). If several players share the top
--   score, take the first one of them.
bestPerTeam :: [Player] -> [(Int, String)]
bestPerTeam ps =
  [ (tid, playerName (head (withTotal (maxTotal tps) tps)))
  | tid <- teamIds ps,
    let tps = [p | p <- ps, teamID (playerTeam p) == tid]
  ]
-- main = print (bestPerTeam allPlayers)  -- [(1,"Bob"),(2,"David"),(3,"Frank")]
-- main = print (bestPerTeam [player7, player3, player1])  -- [(2,"John"),(1,"Alice")]
