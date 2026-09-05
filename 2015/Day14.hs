import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 14

data Reindeer = Reindeer { speed :: Int, flyTime :: Int, restTime :: Int }

parseReindeer :: String -> Reindeer
parseReindeer line = Reindeer sp ft rt
  where
    ws = words line
    sp = read $ ws !! 3
    ft = read $ ws !! 6
    rt = read $ ws !! 13

distance :: Reindeer -> Int -> Int
distance r t = fullCycles * speed r * flyTime r + partialFly
  where
    cycleTime = flyTime r + restTime r
    fullCycles = t `div` cycleTime
    remainder = t `mod` cycleTime
    partialFly = min remainder (flyTime r) * speed r

part1 :: Int
part1 = maximum [distance r 2503 | r <- map parseReindeer input]

part2 :: Int
part2 = 0  -- Placeholder for points-based system
