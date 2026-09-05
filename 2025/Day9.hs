-- Day 9: Movie Theater
-- Part 1: Largest rectangle area with red tile corners
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [(Int, Int)]
input = unsafePerformIO $ do
    lines <- readInputLines 2025 9
    return [parseCoord line | line <- lines]
  where
    parseCoord line = (read x, read y)
      where
        [x, y] = splitOn ',' line
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Find maximum rectangle area
part1 :: Int
part1 = maximum [abs (x2 - x1) * abs (y2 - y1) | 
                (x1, y1) <- input, (x2, y2) <- input,
                (x1, y1) /= (x2, y2)]

part2 :: Int
part2 = 0  -- TBD
