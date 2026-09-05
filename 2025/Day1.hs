-- Day 1: Secret Entrance
-- Part 1: Count times dial stops at 0
-- Part 2: Count times dial passes through 0

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [(Char, Int)]
input = unsafePerformIO $ do
    lines <- readInputLines 2025 1
    return [parseRotation line | line <- lines]
  where
    parseRotation line = (head line, read $ tail line)

-- Part 1: Count stops at 0
part1 :: Int
part1 = length [() | (pos, _) <- positions, pos == 0]
  where
    positions = scanl rotate (50, 0) input
    rotate (pos, _) (dir, amount) = (newPos, 0)
      where
        newPos = (if dir == 'L' then pos - amount else pos + amount) `mod` 100

-- Part 2: Count all times passing through 0
part2 :: Int
part2 = snd $ foldl countZeros (50, 0) input
  where
    countZeros (pos, count) (dir, amount) = (finalPos, count + crossings)
      where
        multiplier = if dir == 'L' then -1 else 1
        finalPos = (pos + multiplier * amount) `mod` 100
        
        -- Count zero crossings
        full = amount `div` 100
        leftover = amount `mod` 100
        newPos = pos + multiplier * leftover
        
        crossings = full + 
                   (if newPos < 0 && pos /= 0 then 1
                    else if newPos >= 100 then 1
                    else if newPos `mod` 100 == 0 then 1
                    else 0)
