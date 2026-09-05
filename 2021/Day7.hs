import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: [Int]
input = unsafePerformIO $ map read . splitOn ',' <$> readInput 2021 7

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

part1 :: Int
part1 = minimum [sum [abs (p - target) | p <- input] | target <- [minimum input .. maximum input]]

part2 :: Int
part2 = minimum [sum [triangular (abs (p - target)) | p <- input] | target <- [minimum input .. maximum input]]
  where
    triangular n = n * (n + 1) `div` 2
