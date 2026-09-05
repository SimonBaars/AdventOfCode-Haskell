import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [Int]
input = map read $ unsafePerformIO $ readInputLines 2015 17

combos :: [Int] -> Int -> [[Int]]
combos [] 0 = [[]]
combos [] _ = []
combos (x:xs) t
  | t < 0 = []
  | otherwise = map (x:) (combos xs (t-x)) ++ combos xs t

ways :: [[Int]]
ways = combos input 150

part1 :: Int
part1 = length ways

part2 :: Int
part2 =
  let m = minimum $ map length ways
  in length $ filter ((==m) . length) ways
