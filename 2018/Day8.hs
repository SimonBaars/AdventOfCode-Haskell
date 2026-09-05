import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 8

parseTree :: [Int] -> (Int, [Int])
parseTree (numChildren:numMeta:rest) =
    let (childrenSum, afterChildren) = parseChildren numChildren rest
        metadata = take numMeta afterChildren
        remaining = drop numMeta afterChildren
    in (childrenSum + sum metadata, remaining)
  where
    parseChildren 0 nums = (0, nums)
    parseChildren n nums =
        let (childSum, after) = parseTree nums
            (restSum, final) = parseChildren (n - 1) after
        in (childSum + restSum, final)

numbers :: [Int]
numbers = map read $ words $ head input

part1 :: Int
part1 = fst $ parseTree numbers

part2 :: Int
part2 = 0  -- Complex node value calculation
