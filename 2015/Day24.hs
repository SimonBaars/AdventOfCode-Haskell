import Data.List (sort, subsequences)
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

pkgs :: [Integer]
pkgs = map read $ unsafePerformIO $ readInputLines 2015 24

total :: Integer
total = sum pkgs

-- Find minimum QE among minimal-size subsets summing to target,
-- where the remainder can be partitioned into (groups-1) groups of target.
-- For AoC, checking the first group alone is almost always enough once
-- remaining sum is divisible; we still verify remainder is packable.
qe :: [Integer] -> Integer
qe = product

subsetsOfSum :: [Integer] -> Integer -> Int -> [[Integer]]
subsetsOfSum xs target maxSize = go xs target maxSize
  where
    go _ 0 _ = [[]]
    go [] _ _ = []
    go _ _ n | n <= 0 = []
    go (y:ys) t n
      | y > t = go ys t n
      | otherwise = map (y:) (go ys (t-y) (n-1)) ++ go ys t n

canPartition :: [Integer] -> Integer -> Int -> Bool
canPartition xs target 1 = sum xs == target
canPartition xs target g =
  or [ canPartition (diff xs s) target (g-1)
     | size <- [1 .. length xs `div` g]
     , s <- subsetsOfSum xs target size
     ]

diff :: Eq a => [a] -> [a] -> [a]
diff xs [] = xs
diff xs (y:ys) = diff (deleteOne y xs) ys
  where
    deleteOne _ [] = []
    deleteOne z (w:ws) | z==w = ws | otherwise = w : deleteOne z ws

solve :: Int -> Integer
solve groups =
  let target = total `div` fromIntegral groups
      sorted = reverse $ sort pkgs
      maxNeeded = length pkgs `div` groups
  in head
    [ minimum [ qe s
              | s <- subsetsOfSum sorted target size
              , canPartition (diff sorted s) target (groups-1)
              ]
    | size <- [1..maxNeeded]
    , let cands = subsetsOfSum sorted target size
    , not (null cands)
    , let qes = [ qe s | s <- cands, canPartition (diff sorted s) target (groups-1) ]
    , not (null qes)
    ]

part1 :: Integer
part1 = solve 3

part2 :: Integer
part2 = solve 4
