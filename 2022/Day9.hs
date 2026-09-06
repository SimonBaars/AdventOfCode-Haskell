-- Day 9: Rope Bridge
-- Part 1: Simulate 2-knot rope, count positions visited by tail
-- Part 2: Simulate 10-knot rope, count positions visited by tail

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

type Pos = (Int, Int)
type Move = (Char, Int)

input :: [Move]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 9
    return [parseMove line | line <- lines]
  where
    parseMove line = (head line, read $ drop 2 line)

-- Move a position in a direction
moveHead :: Pos -> Char -> Pos
moveHead (x, y) 'U' = (x, y + 1)
moveHead (x, y) 'D' = (x, y - 1)
moveHead (x, y) 'L' = (x - 1, y)
moveHead (x, y) 'R' = (x + 1, y)

-- Update tail position to follow head
updateTail :: Pos -> Pos -> Pos
updateTail (hx, hy) (tx, ty)
    | abs dx <= 1 && abs dy <= 1 = (tx, ty)  -- Already touching
    | otherwise = (tx + signum dx, ty + signum dy)
  where
    dx = hx - tx
    dy = hy - ty

-- Simulate rope with n knots
simulateRope :: Int -> [Move] -> Int
simulateRope n moves = S.size visited
  where
    initialRope = replicate n (0, 0)
    (_, visited) = foldl processMove (initialRope, S.singleton (0, 0)) allSteps
    
    allSteps = concatMap (\(dir, count) -> replicate count dir) moves
    
    processMove (rope, visited) dir =
        let newRope = updateRope rope dir
            newTail = last newRope
        in (newRope, S.insert newTail visited)
    
    updateRope rope dir = scanl updateTail (moveHead (head rope) dir) (tail rope)

part1 :: Int
part1 = simulateRope 2 input

part2 :: Int
part2 = simulateRope 10 input
