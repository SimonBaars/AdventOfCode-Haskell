-- Day 10: Cathode-Ray Tube
-- Part 1: Sum of signal strengths at cycles 20, 60, 100, 140, 180, 220
-- Part 2: Draw CRT image (returns number of lit pixels for simplicity)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data Instr = Noop | AddX Int deriving Show

input :: [Instr]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 10
    return [parseInstr line | line <- lines]
  where
    parseInstr line
        | line == "noop" = Noop
        | otherwise = AddX (read $ drop 5 line)

-- Execute instructions and generate list of X register values at each cycle
execute :: [Instr] -> [Int]
execute instrs = scanl step 1 instrs
  where
    step x Noop = x
    step x (AddX v) = x + v

-- Expand instructions to cycles (addx takes 2 cycles)
expandCycles :: [Instr] -> [Int]
expandCycles instrs = 1 : go 1 instrs
  where
    go _ [] = []
    go x (Noop:rest) = x : go x rest
    go x (AddX v:rest) = x : x + v : go (x + v) rest

part1 :: Int
part1 = sum [cycle * (values !! (cycle - 1)) | cycle <- [20, 60, 100, 140, 180, 220]]
  where
    values = expandCycles input

part2 :: Int
part2 = length $ filter id $ zipWith isLit [0..] values
  where
    values = expandCycles input
    isLit cycle x = abs ((cycle `mod` 40) - x) <= 1
