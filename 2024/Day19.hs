-- Day 19: Linen Layout
-- Part 1: Count possible designs
-- Part 2: Count all ways to make designs

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: String
input = unsafePerformIO $ readInput 2024 19

-- Parse towels and designs
parseInput :: String -> ([String], [String])
parseInput str = (towels, designs)
  where
    [towelsStr, designsStr] = splitOn "\n\n" str
    towels = splitOn ", " towelsStr
    designs = lines designsStr
    
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Count ways to make a design (memoized)
countWays :: [String] -> String -> Integer
countWays towels design = go M.empty design
  where
    go memo "" = 1
    go memo str
        | M.member str memo = memo M.! str
        | otherwise = result
      where
        result = sum [go newMemo (drop (length t) str) | 
                     t <- towels, take (length t) str == t]
        newMemo = M.insert str result memo

part1 :: Int
part1 = length [d | d <- designs, countWays towels d > 0]
  where
    (towels, designs) = parseInput input

part2 :: Integer
part2 = sum [countWays towels d | d <- designs]
  where
    (towels, designs) = parseInput input
