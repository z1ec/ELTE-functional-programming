-- Midterm assignment — Tic-Tac-Toe: analyse a game in progress

{- Your Neptun code:      G9ZVX2    -}

-- A board is a list of rows, n x n (n = 3, 5, 7, ...). 'X' and 'O' are marks, '-' is an empty cell.
-- The game is NOT finished yet. You also get the player who started.
-- Rules:
--   * Players take turns, so the starter has the same number of marks as the other player, or one more.
--   * A player wins with a full row, column or one of the two main diagonals.
-- Cells are named like in a spreadsheet: the letter is the column, the number is the row.
--   "A1" is the top-left cell, "C3" is the bottom-right cell of a 3 x 3 board.
--   Inside the program a cell is a pair (row, column), counted from 0: "B3" is (2, 1).
--
-- Scoring (100 points): the points of each task are in its title. All tests pass -> full points;
-- some tests pass -> a proportional part. If a task says "Use ..." and the solution does not, it gets
-- half of the points. Do not change the type signatures. Do not import anything.



boardA :: [String]
boardA = ["X-O",
          "-X-",
          "O--"]

boardB :: [String]
boardB = ["XX-",
          "-O-",
          "---"]

boardC :: [String]
boardC = ["X-X",
          "-O-",
          "X-O"]

boardD :: [String]
boardD = ["---",
          "-X-",
          "---"]

boardE :: [String]
boardE = ["OO-",
          "XX-",
          "X--"]

boardF :: [String]
boardF = ["X--",
          "O-X",
          "-O-"]

boardG :: [String]
boardG = ["XX-XX",
          "OOO--",
          "-----",
          "--O--",
          "-----"]

finished :: [String]
finished = ["XXX",
            "OO-",
            "---"]

full :: [String]
full = ["XOX",
        "XOO",
        "OXX"]

------------------------------------------------------------------------------------------------
-- 1. (6 points) How many times does a mark appear on the board?

countMark :: Char -> [String] -> Int
countMark c board = length (filter (== c) (concat board))

-- main = print (countMark 'X' boardC)  -- 3
-- main = print (countMark 'O' boardD)  -- 0
-- main = print (countMark 'O' [])      -- 0

------------------------------------------------------------------------------------------------
-- 2. (2 points) The other player.

other :: Char -> Char
other c
    | c == 'X' = 'O'
    | otherwise = 'X'

-- main = print (other 'X')  -- 'O'
-- main = print (other 'O')  -- 'X'

------------------------------------------------------------------------------------------------
-- 3. (4 points) Is the position possible? (first argument: the player who started)
--    The starter has the same number of marks as the other player, or exactly one more.

validPosition :: Char -> [String] -> Bool
validPosition c board = ((countMark c board) == (countMark (other c) board)) || ((countMark c board) == (countMark (other c) board) + 1)

-- main = print (validPosition 'X' boardC)               -- True
-- main = print (validPosition 'O' boardC)               -- False
-- main = print (validPosition 'X' ["XXX","---","---"])  -- False

------------------------------------------------------------------------------------------------
-- 4. (4 points) Whose turn is it? (first argument: the player who started; the position is valid)

toMove :: Char -> [String] -> Char
toMove c board = if (countMark c board == (countMark (other c) board)) then c else other c

-- main = print (toMove 'X' boardA)  -- 'X'
-- main = print (toMove 'X' boardB)  -- 'O'
-- main = print (toMove 'X' boardD)  -- 'O'

------------------------------------------------------------------------------------------------
-- 5. (7 points) The empty cells as (row, column) pairs, top row first, each row from left to right.
--    Use a list comprehension.

emptyCells :: [String] -> [(Int, Int)]
emptyCells board = [ (r, c) | (r, row) <- (zip [0..] board), (c, cell) <- (zip [0..] row), cell == '-' ]

-- main = print (emptyCells boardA)  -- [(0,1),(1,0),(1,2),(2,1),(2,2)]
-- main = print (emptyCells full)    -- []

------------------------------------------------------------------------------------------------
-- 6. (8 points) The columns of the board, from left to right.
--    Use recursion.

columns :: [String] -> [String]
columns board
    | board == [] = []
    | null (head board) = []
    | otherwise = map head board : columns (map tail board)



-- main = print (columns boardB)       -- ["X--","XO-","---"]
-- main = print (columns ["XO","-X"])  -- ["X-","OX"]

------------------------------------------------------------------------------------------------
-- 7. (6 points) The two diagonals: first top-left to bottom-right, then top-right to bottom-left.

diagonals :: [String] -> [String]
diagonals board = [firstDiagonal board, firstDiagonal (map reverse board)]

firstDiagonal :: [String] -> String
firstDiagonal [] = []
firstDiagonal (row : rows) = head row : firstDiagonal (map tail rows)

-- main = print (diagonals boardB)  -- ["XO-","-O-"]
-- main = print (diagonals boardG)  -- ["XO---","X----"]

------------------------------------------------------------------------------------------------
-- 8. (3 points) Every line a player can win with: the rows, then the columns, then the diagonals.

allLines :: [String] -> [String]
allLines board = board ++ columns board ++ diagonals board

-- main = print (allLines boardA)           -- ["X-O","-X-","O--","X-O","-X-","O--","XX-","OXO"]
-- main = print (length (allLines boardG))  -- 12

------------------------------------------------------------------------------------------------
-- 9. (5 points) Has this player won?
--    Use higher-order functions.

hasWon :: Char -> [String] -> Bool
hasWon c board = any (== replicate (length (head board)) c) (allLines board)

-- main = print (hasWon 'X' finished)  -- True
-- main = print (hasWon 'O' finished)  -- False
-- main = print (hasWon 'X' boardA)    -- False

------------------------------------------------------------------------------------------------
-- 10. (3 points) Is the game over? (somebody has won, or there is no empty cell)

gameOver :: [String] -> Bool
gameOver board = hasWon 'O' board || hasWon 'X' board || (emptyCells board == [])

-- main = print (gameOver finished)  -- True
-- main = print (gameOver full)      -- True
-- main = print (gameOver boardA)    -- False

------------------------------------------------------------------------------------------------
-- 11. (8 points) Put a mark on a cell (the cell is empty). The rest of the board does not change.

place :: Char -> (Int, Int) -> [String] -> [String]
place c (rowNumber, columnNumber) board = [ if index == rowNumber then (changeRow c columnNumber row) else row | (index, row) <- (zip [0..] board) ]

changeRow :: Char -> Int -> String -> String
changeRow c place row = [ if index == place then c else cell | (index, cell) <- zip [0..] row]

-- main = print (place 'X' (2,2) boardA)  -- ["X-O","-X-","O-X"]
-- main = print (place 'O' (0,1) boardD)  -- ["-O-","-X-","---"]

------------------------------------------------------------------------------------------------
-- 12. (8 points) The cells where this player wins with ONE move.
--     Top row first, each row from left to right.

winningMoves :: Char -> [String] -> [(Int, Int)]
winningMoves c board = [ cell | cell <- emptyCells board, hasWon c (place c cell board) ]

-- main = print (winningMoves 'X' boardA)  -- [(2,2)]
-- main = print (winningMoves 'X' boardC)  -- [(0,1),(1,0)]
-- main = print (winningMoves 'O' boardB)  -- []
-- main = print (winningMoves 'X' boardG)  -- [(0,2)]

------------------------------------------------------------------------------------------------
-- 13. (3 points) The name of a cell: (2,1) -> "B3".

cellName :: (Int, Int) -> String
cellName (rowNumber, columnNumber) = [ letter | (index, letter) <- zip [0..] ['A'..'Z'], index == columnNumber ] ++ show (rowNumber + 1)

-- main = print (cellName (0,0))  -- "A1"
-- main = print (cellName (2,1))  -- "B3"

------------------------------------------------------------------------------------------------
-- 14. (6 points) The names of several cells, separated by ", ".

cellList :: [(Int, Int)] -> String
cellList [] = ""
cellList [cell] = cellName cell
cellList (cell : cells) = cellName cell ++ ", " ++ cellList cells

-- main = print (cellList [(0,1),(1,0)])  -- "B1, A2"
-- main = print (cellList [(2,2)])        -- "C3"
-- main = print (cellList [])             -- ""

------------------------------------------------------------------------------------------------
-- 15. (7 points) Fork moves: the cells where a move gives this player TWO OR MORE winning moves
--     for the next turn. Top row first, each row from left to right.

forkMoves :: Char -> [String] -> [(Int, Int)]
forkMoves c board = [ cell | cell <- emptyCells board, length (winningMoves c (place c cell board)) >= 2 ]

-- main = print (forkMoves 'X' boardF)  -- [(0,2),(2,2)]
-- main = print (forkMoves 'O' boardD)  -- []

------------------------------------------------------------------------------------------------
-- 16. (20 points) Advice for the player to move (first argument: the player who started).
--     Check in this order and give the FIRST answer that fits:
--       the position is not valid           -> "Invalid position"
--       the game is over                    -> "Game over"


--       the player can win                  -> "X to move: win at C3".                     winningMoves /= [] = current player + string + cellList
--       the opponent can win in 1 cell      -> "O to move: must block C1"                  len winningMoves == 1 = current player + string + cellList
--       the opponent can win in more cells  -> "O to move: cannot stop X (B1, A2)".        same with previous but len() > 1
--       the player has fork moves           -> "X to move: fork at C1, C3"                 forkMoves /= [] = current player + string + cellList



--       otherwise                           -> "O to move: no threat"                      
--     Always list ALL the cells, top row first, each row from left to right.





-- validPosition -> bool
-- toMove -> char    --> player -> char
-- other -> char     --> opponent -> char
-- winningMoves -> (Int, Int)
-- forkMoves -> (Int, Int)
-- cellList -> String





advice :: Char -> [String] -> String
advice c board
    | not (validPosition c board) = "Invalid position"
    | gameOver board = "Game over"
    | winningMoves player board /= [] = [player] ++ " to move: win at " ++ cellList (winningMoves player board)
    | length (winningMoves opponent board) == 1 = [player] ++ " to move: must block " ++ cellList (winningMoves opponent board)
    | length (winningMoves opponent board) > 1 = [player] ++ " to move: cannot stop " ++ [opponent] ++ " (" ++ cellList (winningMoves opponent board) ++ ")"
    | forkMoves player board /= [] = [player] ++ " to move: fork at " ++ cellList (forkMoves player board)
    | otherwise = [player] ++ " to move: no threat"
        where
            player = toMove c board
            opponent = other player

-- main = print (advice 'X' boardA)    -- "X to move: win at C3"
-- main = print (advice 'X' boardB)    -- "O to move: must block C1"
-- main = print (advice 'X' boardC)    -- "O to move: cannot stop X (B1, A2)"
-- main = print (advice 'X' boardD)    -- "O to move: no threat"
-- main = print (advice 'X' boardE)    -- "O to move: win at C1"
-- main = print (advice 'X' boardF)    -- "X to move: fork at C1, C3"
-- main = print (advice 'X' boardG)    -- "X to move: win at C1"
-- main = print (advice 'O' boardB)    -- "Invalid position"
-- main = print (advice 'X' finished)  -- "Game over"
-- main = print (advice 'X' full)      -- "Game over"
