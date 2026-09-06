-- Day 5: If You Give A Seed A Fertilizer
-- Part 1: Find lowest location for given seeds
-- Part 2: Seeds are ranges, find lowest location

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2023 5

type Range = (Integer, Integer, Integer)  -- (destStart, sourceStart, length)

-- Parse input into seeds and maps
parseInput :: String -> ([Integer], [[Range]])
parseInput str = (seeds, maps)
  where
    sections = splitOn "\n\n" str
    seeds = map read $ words $ drop 7 $ head sections
    maps = map parseMap $ tail sections
    
    parseMap section = map parseLine $ tail $ lines section
    parseLine line = (dest, source, len)
      where
        [dest, source, len] = map read $ words line
    
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Apply a single map to a value
applyMap :: [Range] -> Integer -> Integer
applyMap ranges val = case [dest + (val - source) | (dest, source, len) <- ranges,
                                                     val >= source, val < source + len] of
    (x:_) -> x
    [] -> val

-- Apply all maps to get final location
applyAllMaps :: [[Range]] -> Integer -> Integer
applyAllMaps maps seed = foldl (flip applyMap) seed maps

part1 :: Integer
part1 = minimum $ map (applyAllMaps maps) seeds
  where
    (seeds, maps) = parseInput input

part2 :: Integer
part2 = minimum [applyAllMaps maps seed | 
                 (start, len) <- seedRanges, 
                 seed <- [start..start + len - 1]]
  where
    (seedList, maps) = parseInput input
    seedRanges = [(seedList !! i, seedList !! (i + 1)) | i <- [0, 2..length seedList - 2]]
