-- Day 13: Claw Contraption
-- Part 1: Find minimum tokens to win prizes (linear algebra)
-- Part 2: Add 10000000000000 to prize coordinates

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2024 13

data Machine = Machine { aBtn :: (Integer, Integer),
                        bBtn :: (Integer, Integer),
                        prize :: (Integer, Integer) } deriving Show

-- Parse machines
parseMachines :: String -> [Machine]
parseMachines str = [parseMachine m | m <- splitOn "\n\n" str]
  where
    parseMachine m = Machine (ax, ay) (bx, by) (px, py)
      where
        [lineA, lineB, lineP] = lines m
        ax = read $ takeWhile (/= ',') $ drop 12 lineA
        ay = read $ drop 3 $ dropWhile (/= 'Y') lineA
        bx = read $ takeWhile (/= ',') $ drop 12 lineB
        by = read $ drop 3 $ dropWhile (/= 'Y') lineB
        px = read $ takeWhile (/= ',') $ drop 9 lineP
        py = read $ drop 3 $ dropWhile (/= 'Y') lineP
    
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str = go [] str
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Solve using linear algebra (Cramer's rule)
solveMachine :: Machine -> Integer -> Maybe Integer
solveMachine (Machine (ax, ay) (bx, by) (px, py)) offset = 
    if det == 0 || a < 0 || b < 0 || a * ax + b * bx /= px' || a * ay + b * by /= py'
    then Nothing
    else Just (3 * a + b)
  where
    px' = px + offset
    py' = py + offset
    det = ax * by - ay * bx
    a = (px' * by - py' * bx) `div` det
    b = (ax * py' - ay * px') `div` det

part1 :: Integer
part1 = sum [cost | m <- parseMachines input, Just cost <- [solveMachine m 0]]

part2 :: Integer
part2 = sum [cost | m <- parseMachines input, 
             Just cost <- [solveMachine m 10000000000000]]
