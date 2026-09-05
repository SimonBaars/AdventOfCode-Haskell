import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map

-- Day 15: Rambunctious Recitation
-- Van Eck sequence memory game

input :: [Int]
input = unsafePerformIO $ map read . splitOn ',' <$> readInput 2020 15

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

-- Play the memory game until turn n
playGame :: Int -> [Int] -> Int
playGame target starting = go lastNum startTurn lastSeen
  where
    startTurn = length starting
    lastNum = last starting
    lastSeen = Map.fromList $ zip (init starting) [1..]
    
    go num turn seen
        | turn == target = num
        | otherwise = case Map.lookup num seen of
            Nothing -> go 0 (turn + 1) (Map.insert num turn seen)
            Just prevTurn -> go (turn - prevTurn) (turn + 1) (Map.insert num turn seen)

part1 :: Int
part1 = playGame 2020 input

part2 :: Int
part2 = playGame 30000000 input
