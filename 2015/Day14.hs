import Data.List (foldl', maximumBy)
import Data.Ord (comparing)
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data Reindeer = Reindeer { name :: String, speed :: Int, fly :: Int, rest :: Int }

input :: [Reindeer]
input = map parse $ unsafePerformIO $ readInputLines 2015 14
  where
    parse line =
      let ws = words line
      in Reindeer (ws!!0) (read (ws!!3)) (read (ws!!6)) (read (ws!!13))

distance :: Int -> Reindeer -> Int
distance t r =
  let cycleLen = fly r + rest r
      (full, rem') = t `divMod` cycleLen
  in full * speed r * fly r + speed r * min (fly r) rem'

part1 :: Int
part1 = maximum [distance 2503 r | r <- input]

part2 :: Int
part2 =
  let times = [1..2503]
      scores = foldl' award (zip input (repeat 0)) times
  in maximum $ map snd scores
  where
    award state t =
      let dists = [(r, distance t r) | (r,_) <- state]
          bestD = maximum $ map snd dists
      in [ (r, sc + if distance t r == bestD then 1 else 0) | (r,sc) <- state ]
