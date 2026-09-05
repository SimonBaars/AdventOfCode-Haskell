import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose)
import qualified Data.Set as Set

-- Day 4: Giant Squid - Bingo

type Board = [[Int]]

input :: ([Int], [Board])
input = unsafePerformIO $ parseInput <$> readInput 2021 4

parseInput :: String -> ([Int], [Board])
parseInput s = (numbers, boards)
  where
    ls = lines s
    numbers = map read $ words $ map (\c -> if c == ',' then ' ' else c) $ head ls
    boards = parseBoards $ drop 2 ls

parseBoards :: [String] -> [Board]
parseBoards [] = []
parseBoards ls = case takeWhile (not . null) ls of
    [] -> parseBoards (dropWhile null ls)
    boardLines -> map (map read . words) boardLines : parseBoards (drop (length boardLines) ls)

hasWon :: Board -> Set.Set Int -> Bool
hasWon board marked = any (all (`Set.member` marked)) board || 
                      any (all (`Set.member` marked)) (transpose board)

score :: Board -> Set.Set Int -> Int -> Int
score board marked lastNum = sum [n | row <- board, n <- row, not $ Set.member n marked] * lastNum

-- Find all winning boards in order
playBingo :: [Int] -> [Board] -> [(Board, Set.Set Int, Int)]
playBingo numbers boards = go numbers boards Set.empty Set.empty []
  where
    go [] _ _ _ winners = reverse winners
    go (n:ns) bs marked wonIndices winners = 
        let marked' = Set.insert n marked
            newWinners = [(i, b) | (i, b) <- zip [0..] bs, 
                          i `Set.notMember` wonIndices,
                          hasWon b marked']
            wonIndices' = Set.union wonIndices (Set.fromList $ map fst newWinners)
            winners' = [(b, marked', n) | (_, b) <- newWinners] ++ winners
        in go ns bs marked' wonIndices' winners'

part1 :: Int
part1 = score board marked lastNum
  where
    (numbers, boards) = input
    results = playBingo numbers boards
    (board, marked, lastNum) = head results

part2 :: Int
part2 = score board marked lastNum
  where
    (numbers, boards) = input
    results = playBingo numbers boards
    (board, marked, lastNum) = last results
