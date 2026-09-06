-- Day 3: Mull It Over
-- Part 1: Sum valid mul(X,Y) instructions
-- Part 2: Respect do() and don't() toggles

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Text.Regex.TDFA ((=~), getAllTextMatches)

input :: String
input = unsafePerformIO $ readInput 2024 3

-- Parse mul(X,Y) and return X * Y
parseMul :: String -> Int
parseMul s = x * y
  where
    nums = s =~ "[0-9]+" :: [[String]]
    [x, y] = map (read . head) nums

part1 :: Int
part1 = sum $ map parseMul muls
  where
    muls = getAllTextMatches $ input =~ "mul\\([0-9]+,[0-9]+\\)" :: [String]

part2 :: Int
part2 = go True 0 instructions
  where
    instructions = getAllTextMatches $ input =~ "(mul\\([0-9]+,[0-9]+\\)|do\\(\\)|don't\\(\\))" :: [String]
    
    go _ acc [] = acc
    go enabled acc (inst:rest)
        | inst == "do()" = go True acc rest
        | inst == "don't()" = go False acc rest
        | enabled = go enabled (acc + parseMul inst) rest
        | otherwise = go enabled acc rest
