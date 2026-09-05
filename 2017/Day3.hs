import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: String
input = unsafePerformIO $ readInput 2017 3

target :: Int
target = read $ filter (/= '\n') input

spiral :: [(Int, Int)]
spiral = (0, 0) : go (1, 0) 1 0 1
  where
    go (x, y) steps dir stepsLeft
        | stepsLeft == 0 = 
            let newDir = (dir + 1) `mod` 4
                newSteps = if newDir `mod` 2 == 0 then steps + 1 else steps
            in go (move (x, y) newDir) newSteps newDir (newSteps - 1)
        | otherwise = (x, y) : go (move (x, y) dir) steps dir (stepsLeft - 1)
    
    move (x, y) 0 = (x + 1, y)
    move (x, y) 1 = (x, y + 1)
    move (x, y) 2 = (x - 1, y)
    move (x, y) 3 = (x, y - 1)

manhattan :: (Int, Int) -> Int
manhattan (x, y) = abs x + abs y

spiralSums :: [Int]
spiralSums = go (Map.singleton (0, 0) 1) (tail spiral)
  where
    go _ [] = []
    go sums ((x, y):rest) = 
        let neighbors = [(x+dx, y+dy) | dx <- [-1..1], dy <- [-1..1], (dx, dy) /= (0, 0)]
            val = sum [Map.findWithDefault 0 pos sums | pos <- neighbors]
            newSums = Map.insert (x, y) val sums
        in val : go newSums rest

part1 :: Int
part1 = manhattan $ spiral !! (target - 1)

part2 :: Int
part2 = head $ dropWhile (<= target) spiralSums
