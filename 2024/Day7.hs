-- Day 7: Bridge Repair
-- Part 1: Find equations solvable with + and *
-- Part 2: Add concatenation operator ||

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [(Integer, [Integer])]
input = unsafePerformIO $ do
    lines <- readInputLines 2024 7
    return [parseLine line | line <- lines]
  where
    parseLine line = (target, nums)
      where
        [targetStr, numsStr] = splitOn ':' line
        target = read targetStr
        nums = map read $ words numsStr
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Check if equation can be solved
canSolve :: Bool -> Integer -> [Integer] -> Bool
canSolve withConcat target (first:rest) = go first rest
  where
    go acc [] = acc == target
    go acc (n:ns)
        | acc > target = False
        | otherwise = go (acc + n) ns || 
                     go (acc * n) ns || 
                     (withConcat && go (concat' acc n) ns)
    
    concat' a b = read (show a ++ show b)

part1 :: Integer
part1 = sum [target | (target, nums) <- input, canSolve False target nums]

part2 :: Integer
part2 = sum [target | (target, nums) <- input, canSolve True target nums]
