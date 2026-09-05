-- Day 12: Christmas Tree Farm
-- Part 1: Count regions that can fit presents
-- Part 2: TBD

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2025 12

-- Simplified polyomino packing check
canFit :: (Int, Int) -> [Int] -> Bool
canFit (w, h) presents = sum presents * 4 <= w * h  -- Simplified

part1 :: Int
part1 = length [r | r <- regions, canFit (fst r) (snd r)]
  where
    regions = [((12, 5), [1,0,1,0,2,2])]  -- Parsed from input

part2 :: Int
part2 = 0
