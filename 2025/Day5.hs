-- Day 5: Cafeteria
-- Part 1: Count fresh ingredient IDs
-- Part 2: Count unique integers in ranges

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2025 5

-- Parse input
parseInput :: String -> ([(Integer, Integer)], [Integer])
parseInput str = (ranges, ids)
  where
    [rangesStr, idsStr] = splitOn "\n\n" str
    ranges = [parseRange r | r <- lines rangesStr]
    ids = map read $ lines idsStr
    
    parseRange line = (read start, read end)
      where
        [start, end] = splitOn '-' line
    
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Check if ID is fresh
isFresh :: [(Integer, Integer)] -> Integer -> Bool
isFresh ranges id = any (\(start, end) -> id >= start && id <= end) ranges

part1 :: Int
part1 = length [id | id <- ids, isFresh ranges id]
  where
    (ranges, ids) = parseInput input

-- Part 2: Count unique integers covered by ranges
part2 :: Int
part2 = length $ foldl addRange [] ranges
  where
    (ranges, _) = parseInput input
    addRange covered (start, end) = merge covered [(start, end)]
    
    merge [] new = new
    merge (r:rs) new
        | overlaps r (head new) = merge rs [combine r (head new)]
        | otherwise = r : merge rs new
    
    overlaps (s1, e1) (s2, e2) = s1 <= e2 && s2 <= e1
    combine (s1, e1) (s2, e2) = (min s1 s2, max e1 e2)
