-- Day 2: Cube Conundrum
-- Part 1: Find possible games with 12 red, 13 green, 14 blue
-- Part 2: Find minimum cubes needed for each game

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 2

data Game = Game { gameId :: Int, rounds :: [(Int, Int, Int)] } deriving Show

parseGame :: String -> Game
parseGame line = Game gid rounds'
  where
    [gameStr, roundsStr] = splitOn ':' line
    gid = read $ drop 5 gameStr
    rounds' = map parseRound $ splitOn ';' roundsStr
    
    parseRound r = foldl addColor (0, 0, 0) $ map parseColor $ splitOn ',' r
    
    parseColor s = (color, count)
      where
        ws = words s
        count = read $ head ws
        color = ws !! 1
    
    addColor (r, g, b) ("red", n) = (r + n, g, b)
    addColor (r, g, b) ("green", n) = (r, g + n, b)
    addColor (r, g, b) ("blue", n) = (r, g, b + n)
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

isPossible :: Game -> Bool
isPossible game = all (\(r, g, b) -> r <= 12 && g <= 13 && b <= 14) (rounds game)

minCubes :: Game -> (Int, Int, Int)
minCubes game = (maxRed, maxGreen, maxBlue)
  where
    maxRed = maximum [r | (r, _, _) <- rounds game]
    maxGreen = maximum [g | (_, g, _) <- rounds game]
    maxBlue = maximum [b | (_, _, b) <- rounds game]

power :: (Int, Int, Int) -> Int
power (r, g, b) = r * g * b

part1 :: Int
part1 = sum [gameId g | g <- games, isPossible g]
  where
    games = map parseGame input

part2 :: Int
part2 = sum $ map (power . minCubes) games
  where
    games = map parseGame input
