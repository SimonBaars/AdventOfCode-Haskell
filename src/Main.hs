module Main (main) where

import AOC.Input (getInput, year)
import System.Environment (getArgs)

import qualified Day01
import qualified Day02
import qualified Day03
import qualified Day04
import qualified Day05
import qualified Day06
import qualified Day07
import qualified Day08
import qualified Day09
import qualified Day10
import qualified Day11
import qualified Day12
import qualified Day13
import qualified Day14
import qualified Day15
import qualified Day16
import qualified Day17
import qualified Day18
import qualified Day19
import qualified Day20
import qualified Day21
import qualified Day22
import qualified Day23
import qualified Day24
import qualified Day25

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> mapM_ runDay [1 .. 25]
    [d] -> runDay (read d)
    [d, p] -> runPart (read d) (read p)
    _ -> fail "Usage: aoc2022 [day [part]]"

runDay :: Int -> IO ()
runDay d = runPart d 1 >> runPart d 2

runPart :: Int -> Int -> IO ()
runPart day part = do
  raw <- getInput day
  putStrLn $ "Year " ++ show year ++ " Day " ++ pad day ++ " Part " ++ show part ++ ": " ++ solve day part raw
  where
    pad n | n < 10 = '0' : show n
          | otherwise = show n

solve :: Int -> Int -> String -> String
solve 1 1 = show . Day01.part1
solve 1 2 = show . Day01.part2
solve 2 1 = show . Day02.part1
solve 2 2 = show . Day02.part2
solve 3 1 = show . Day03.part1
solve 3 2 = show . Day03.part2
solve 4 1 = show . Day04.part1
solve 4 2 = show . Day04.part2
solve 5 1 = Day05.part1
solve 5 2 = Day05.part2
solve 6 1 = show . Day06.part1
solve 6 2 = show . Day06.part2
solve 7 1 = show . Day07.part1
solve 7 2 = show . Day07.part2
solve 8 1 = show . Day08.part1
solve 8 2 = show . Day08.part2
solve 9 1 = show . Day09.part1
solve 9 2 = show . Day09.part2
solve 10 1 = show . Day10.part1
solve 10 2 = Day10.part2
solve 11 1 = show . Day11.part1
solve 11 2 = show . Day11.part2
solve 12 1 = show . Day12.part1
solve 12 2 = show . Day12.part2
solve 13 1 = show . Day13.part1
solve 13 2 = show . Day13.part2
solve 14 1 = show . Day14.part1
solve 14 2 = show . Day14.part2
solve 15 1 = show . Day15.part1
solve 15 2 = show . Day15.part2
solve 16 1 = show . Day16.part1
solve 16 2 = show . Day16.part2
solve 17 1 = show . Day17.part1
solve 17 2 = show . Day17.part2
solve 18 1 = show . Day18.part1
solve 18 2 = show . Day18.part2
solve 19 1 = show . Day19.part1
solve 19 2 = show . Day19.part2
solve 20 1 = show . Day20.part1
solve 20 2 = show . Day20.part2
solve 21 1 = show . Day21.part1
solve 21 2 = show . Day21.part2
solve 22 1 = show . Day22.part1
solve 22 2 = show . Day22.part2
solve 23 1 = show . Day23.part1
solve 23 2 = show . Day23.part2
solve 24 1 = show . Day24.part1
solve 24 2 = show . Day24.part2
solve 25 1 = Day25.part1
solve 25 2 = Day25.part2
solve d p = error $ "No solution for day " ++ show d ++ " part " ++ show p
