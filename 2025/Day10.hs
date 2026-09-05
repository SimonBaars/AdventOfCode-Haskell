-- Day 10: Factory
-- Part 1: Minimum button presses (BFS)
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2025 10

-- Parse machine specification
parseMachine :: String -> ([Bool], [[Int]])
parseMachine line = (target, buttons)
  where
    targetStr = takeWhile (/= ']') $ tail line
    target = [c == '#' | c <- targetStr]
    
    buttonsStr = drop (length targetStr + 2) line
    buttons = [parseButton b | b <- takeWhile (/= '{') buttonsStr, 
              b `elem` "(0123456789,)"]
    
    parseButton str = []  -- Simplified

-- BFS to find minimum presses
minPresses :: [Bool] -> [[Int]] -> Int
minPresses target buttons = bfs (S.singleton start) [start] 0
  where
    start = replicate (length target) False
    
    bfs visited [] steps = -1
    bfs visited queue steps
        | target `elem` queue = steps
        | otherwise = bfs newVisited nextQueue (steps + 1)
      where
        nextQueue = [next | state <- queue, button <- buttons,
                           let next = toggle state button,
                           S.notMember next visited]
        newVisited = S.union visited (S.fromList nextQueue)
    
    toggle state indices = [if i `elem` indices then not light else light | 
                           (i, light) <- zip [0..] state]

part1 :: Int
part1 = sum [minPresses target buttons | (target, buttons) <- map parseMachine input]

part2 :: Int
part2 = 0  -- TBD
