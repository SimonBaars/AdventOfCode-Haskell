-- Day 15: Warehouse Woes
-- Part 1: Simulate robot pushing boxes
-- Part 2: Wider warehouse (boxes are 2 wide)

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: String
input = unsafePerformIO $ readInput 2024 15

type Pos = (Int, Int)

-- Parse warehouse and moves
parseInput :: String -> ([String], String)
parseInput str = (lines gridStr, concat $ lines movesStr)
  where
    [gridStr, movesStr] = splitOn "\n\n" str
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Simulate robot movement
simulate :: [String] -> String -> Int
simulate grid moves = sum [100 * r + c | (r, c) <- S.toList boxes]
  where
    (robot, boxes, walls) = parseGrid grid
    (_, boxes') = foldl processMove (robot, boxes) moves
    
    parseGrid g = (robot, boxes, walls)
      where
        robot = head [(r, c) | r <- [0..length g - 1],
                              c <- [0..length (head g) - 1],
                              g !! r !! c == '@']
        boxes = S.fromList [(r, c) | r <- [0..length g - 1],
                                     c <- [0..length (head g) - 1],
                                     g !! r !! c == 'O']
        walls = S.fromList [(r, c) | r <- [0..length g - 1],
                                     c <- [0..length (head g) - 1],
                                     g !! r !! c == '#']
    
    processMove (pos, boxes) move = (pos', boxes')
      where
        dir = case move of
            '^' -> (-1, 0)
            'v' -> (1, 0)
            '<' -> (0, -1)
            '>' -> (0, 1)
        
        (pos', boxes') = tryMove pos boxes dir
    
    tryMove (r, c) boxes (dr, dc)
        | S.member next walls = ((r, c), boxes)
        | S.member next boxes = 
            if canPush then (next, S.insert pushTarget $ S.delete next boxes)
            else ((r, c), boxes)
        | otherwise = (next, boxes)
      where
        next = (r + dr, c + dc)
        pushTarget = (fst next + dr, snd next + dc)
        canPush = not (S.member pushTarget walls) && not (S.member pushTarget boxes)

part1 :: Int
part1 = simulate grid moves
  where
    (grid, moves) = parseInput input

part2 :: Int
part2 = 0  -- Simplified - requires wider grid logic
