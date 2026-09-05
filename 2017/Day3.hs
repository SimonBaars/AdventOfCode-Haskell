import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map

input :: String
input = unsafePerformIO $ readInput 2017 3

target :: Int
target = read $ filter (/= '\n') input

spiralPositions :: [(Int, Int)]
spiralPositions = (0,0) : concatMap ring [1..]
  where
    ring r =
         [( r,  y) | y <- [1-r .. r]]
      ++ [( x,  r) | x <- [r-1, r-2 .. (-r)]]
      ++ [(-r,  y) | y <- [r-1, r-2 .. (-r)]]
      ++ [( x, -r) | x <- [1-r .. r]]

manhattan :: (Int, Int) -> Int
manhattan (x, y) = abs x + abs y

part1 :: Int
part1 = manhattan (spiralPositions !! (target - 1))

spiralSums :: [Int]
spiralSums = go (Map.singleton (0,0) 1) (drop 1 spiralPositions)
  where
    go _ [] = []
    go m ((x,y):rest) =
      let val = sum [ Map.findWithDefault 0 (x+dx,y+dy) m
                    | dx <- [-1..1], dy <- [-1..1], (dx,dy) /= (0,0) ]
      in val : go (Map.insert (x,y) val m) rest

part2 :: Int
part2 = head $ dropWhile (<= target) spiralSums
