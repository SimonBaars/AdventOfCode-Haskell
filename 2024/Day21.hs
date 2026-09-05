-- Day 21: Keypad Conundrum
-- Part 1: Control robots controlling robots (2 directional keypads)
-- Part 2: 25 directional keypads

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2024 21

type Pos = (Int, Int)

-- Numeric keypad layout
numPad :: M.Map Char Pos
numPad = M.fromList [('7',(0,0)), ('8',(0,1)), ('9',(0,2)),
                     ('4',(1,0)), ('5',(1,1)), ('6',(1,2)),
                     ('1',(2,0)), ('2',(2,1)), ('3',(2,2)),
                                  ('0',(3,1)), ('A',(3,2))]

-- Directional keypad layout
dirPad :: M.Map Char Pos
dirPad = M.fromList [('^',(0,1)), ('A',(0,2)),
                     ('<',(1,0)), ('v',(1,1)), ('>',(1,2))]

-- Find shortest path between two keys
shortestPath :: M.Map Char Pos -> Char -> Char -> String
shortestPath keypad from to = vertical ++ horizontal ++ "A"
  where
    (r1, c1) = keypad M.! from
    (r2, c2) = keypad M.! to
    vertical = replicate (abs (r2 - r1)) (if r2 > r1 then 'v' else '^')
    horizontal = replicate (abs (c2 - c1)) (if c2 > c1 then '>' else '<')

-- Calculate complexity with n robots
complexity :: Int -> String -> Int
complexity robots code = numPart * minPresses
  where
    numPart = read $ filter (`elem` "0123456789") code
    
    -- Start from numeric keypad
    moves1 = concat [shortestPath numPad from to | (from, to) <- zip ('A':code) code]
    
    -- Apply directional keypads n times
    minPresses = length $ iterate applyDirPad moves1 !! robots
    
    applyDirPad moves = concat [shortestPath dirPad from to | (from, to) <- zip ('A':moves) moves]

part1 :: Int
part1 = sum [complexity 2 code | code <- input]

part2 :: Int
part2 = sum [complexity 25 code | code <- input]
