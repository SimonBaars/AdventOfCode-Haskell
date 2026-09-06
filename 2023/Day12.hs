-- Day 12: Hot Springs
-- Part 1: Count valid arrangements of springs
-- Part 2: Unfold and count (×5)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M
import Data.List (intercalate)

input :: [(String, [Int])]
input = unsafePerformIO $ do
    lines <- readInputLines 2023 12
    return [parseLine line | line <- lines]
  where
    parseLine line = (springs, groups)
      where
        [springs, groupsStr] = words line
        groups = map read $ splitOn ',' groupsStr
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Count valid arrangements using memoization
countArrangements :: String -> [Int] -> Integer
countArrangements springs groups = go M.empty springs groups 0
  where
    go memo [] [] 0 = 1
    go memo [] [] _ = 0
    go memo [] (g:gs) curr
        | curr == g = go memo [] gs 0
        | otherwise = 0
    go memo (s:ss) gs curr
        | M.member (s:ss, gs, curr) memo = memo M.! (s:ss, gs, curr)
        | otherwise = result
      where
        result = case (s, gs, curr) of
            ('.', [], 0) -> go newMemo ss [] 0
            ('.', [], _) -> 0
            ('.', g:rest, c)
                | c == 0 -> go newMemo ss gs 0
                | c == g -> go newMemo ss rest 0
                | otherwise -> 0
            ('#', [], _) -> 0
            ('#', g:rest, c)
                | c < g -> go newMemo ss gs (c + 1)
                | otherwise -> 0
            ('?', _, _) -> go newMemo ('.':ss) gs curr + go newMemo ('#':ss) gs curr
            _ -> 0
        newMemo = M.insert (s:ss, gs, curr) result memo

-- Unfold the input for part 2
unfold :: (String, [Int]) -> (String, [Int])
unfold (springs, groups) = (intercalate "?" $ replicate 5 springs, concat $ replicate 5 groups)

part1 :: Integer
part1 = sum [countArrangements springs groups | (springs, groups) <- input]

part2 :: Integer
part2 = sum [countArrangements springs groups | (springs, groups) <- map unfold input]
