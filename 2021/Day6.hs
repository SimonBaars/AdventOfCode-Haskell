import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [Int]
input = unsafePerformIO $ map read . splitOn ',' <$> readInput 2021 6

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

simulate :: Int -> [Int] -> Int
simulate days fish = sum $ Map.elems $ iterate step initialState !! days
  where
    initialState = foldr (\f m -> Map.insertWith (+) f 1 m) (Map.fromList [(i, 0) | i <- [0..8]]) fish
    step state = Map.fromList [(i, count i) | i <- [0..8]]
      where
        count 8 = Map.findWithDefault 0 0 state
        count 6 = Map.findWithDefault 0 7 state + Map.findWithDefault 0 0 state
        count n = Map.findWithDefault 0 (n+1) state

part1 :: Int
part1 = simulate 80 input

part2 :: Int
part2 = simulate 256 input
