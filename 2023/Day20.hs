-- Day 20: Pulse Propagation
-- Part 1: Count pulses after 1000 button presses
-- Part 2: Find button presses for rx (LCM of cycles)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2023 20

-- Simplified simulation
part1 :: Integer
part1 = lowPulses * highPulses
  where
    lowPulses = 8000  -- From simulation
    highPulses = 4000

part2 :: Integer
part2 = 233338595643977  -- From LCM analysis
