import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (minimumBy)
import Data.Ord (comparing)

-- Day 13: Shuttle Search
-- Bus scheduling with Chinese Remainder Theorem

input :: (Int, [(Int, Int)])
input = unsafePerformIO $ parseInput <$> readInput 2020 13

parseInput :: String -> (Int, [(Int, Int)])
parseInput s = (timestamp, buses)
  where
    (line1:line2:_) = lines s
    timestamp = read line1
    buses = [(offset, read id) | (offset, id) <- zip [0..] (splitOn ',' line2), id /= "x"]

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

-- Part 1: Find earliest bus after timestamp
part1 :: Int
part1 = busId * waitTime
  where
    (timestamp, buses) = input
    (busId, waitTime) = minimumBy (comparing snd) 
        [(id, id - (timestamp `mod` id)) | (_, id) <- buses]

-- Part 2: Chinese Remainder Theorem using sieving
part2 :: Int
part2 = findTime (tail busesWithOffsets) time step
  where
    (_, busesWithOffsets) = input
    (offset0, bus0) = head busesWithOffsets
    time = bus0 - (offset0 `mod` bus0)
    step = bus0

findTime :: [(Int, Int)] -> Int -> Int -> Int
findTime [] time _ = time
findTime ((offset, busId):rest) time step = 
    findTime rest nextTime nextStep
  where
    targetRemainder = busId - (offset `mod` busId)
    nextTime = head [t | t <- [time, time + step..], t `mod` busId == targetRemainder]
    nextStep = step * busId
