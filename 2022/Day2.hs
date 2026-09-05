-- Day 2: Rock Paper Scissors
-- Part 1: X/Y/Z are your plays, calculate total score
-- Part 2: X/Y/Z are desired outcomes, calculate total score

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [(Char, Char)]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 2
    return [(head line, last line) | line <- lines]

-- Part 1: Second column is what you should play
scoreRound1 :: (Char, Char) -> Int
scoreRound1 (opp, you) = shapeScore + outcomeScore
  where
    shapeScore = case you of
        'X' -> 1  -- Rock
        'Y' -> 2  -- Paper
        'Z' -> 3  -- Scissors
    
    outcomeScore = case (opp, you) of
        ('A', 'Y') -> 6  -- Rock vs Paper -> Win
        ('A', 'X') -> 3  -- Rock vs Rock -> Draw
        ('A', 'Z') -> 0  -- Rock vs Scissors -> Loss
        ('B', 'Z') -> 6  -- Paper vs Scissors -> Win
        ('B', 'Y') -> 3  -- Paper vs Paper -> Draw
        ('B', 'X') -> 0  -- Paper vs Rock -> Loss
        ('C', 'X') -> 6  -- Scissors vs Rock -> Win
        ('C', 'Z') -> 3  -- Scissors vs Scissors -> Draw
        ('C', 'Y') -> 0  -- Scissors vs Paper -> Loss

-- Part 2: Second column is desired outcome
scoreRound2 :: (Char, Char) -> Int
scoreRound2 (opp, outcome) = shapeScore + outcomeScore
  where
    outcomeScore = case outcome of
        'X' -> 0  -- Need to lose
        'Y' -> 3  -- Need to draw
        'Z' -> 6  -- Need to win
    
    shapeScore = case (opp, outcome) of
        ('A', 'X') -> 3  -- Rock, need to lose -> Scissors
        ('A', 'Y') -> 1  -- Rock, need to draw -> Rock
        ('A', 'Z') -> 2  -- Rock, need to win -> Paper
        ('B', 'X') -> 1  -- Paper, need to lose -> Rock
        ('B', 'Y') -> 2  -- Paper, need to draw -> Paper
        ('B', 'Z') -> 3  -- Paper, need to win -> Scissors
        ('C', 'X') -> 2  -- Scissors, need to lose -> Paper
        ('C', 'Y') -> 3  -- Scissors, need to draw -> Scissors
        ('C', 'Z') -> 1  -- Scissors, need to win -> Rock

part1 :: Int
part1 = sum $ map scoreRound1 input

part2 :: Int
part2 = sum $ map scoreRound2 input
