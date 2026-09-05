import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (maximumBy, sortBy)
import Data.Ord (comparing)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2018 9

playMarbles :: Int -> Int -> Int
playMarbles players lastMarble = maximum $ Map.elems $ go 0 [0] 1 (Map.fromList [(p, 0) | p <- [0..players-1]])
  where
    go _ _ marble scores | marble > lastMarble = scores
    go current circle marble scores
        | marble `mod` 23 == 0 =
            let removeIdx = (current - 7) `mod` length circle
                removed = circle !! removeIdx
                newCircle = take removeIdx circle ++ drop (removeIdx + 1) circle
                player = marble `mod` players
                newScores = Map.insertWith (+) player (marble + removed) scores
                newCurrent = removeIdx `mod` length newCircle
            in go newCurrent newCircle (marble + 1) newScores
        | otherwise =
            let insertIdx = ((current + 1) `mod` length circle) + 1
                newCircle = take insertIdx circle ++ [marble] ++ drop insertIdx circle
            in go insertIdx newCircle (marble + 1) scores

[players, lastMarble] = map read $ words $ filter (`elem` "0123456789 ") $ head input

part1 :: Int
part1 = playMarbles players lastMarble

part2 :: Int
part2 = playMarbles players (lastMarble * 100)
