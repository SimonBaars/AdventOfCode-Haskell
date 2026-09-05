import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set
import Data.List (maximumBy)
import Data.Ord (comparing)

input :: [String]
input = unsafePerformIO $ readInputLines 2019 10

type Point = (Int, Int)

asteroids :: [Point]
asteroids = [(x, y) | (y, line) <- zip [0..] input, (x, c) <- zip [0..] line, c == '#']

gcd' :: Int -> Int -> Int
gcd' a b = gcd (abs a) (abs b)

visible :: Point -> [Point] -> Int
visible (x, y) others = Set.size $ Set.fromList [normalize (ox - x, oy - y) | (ox, oy) <- others, (ox, oy) /= (x, y)]
  where
    normalize (dx, dy) = let g = gcd' dx dy in if g == 0 then (dx, dy) else (dx `div` g, dy `div` g)

bestLocation :: (Point, Int)
bestLocation = maximumBy (comparing snd) [(pos, visible pos asteroids) | pos <- asteroids]

part1 :: Int
part1 = snd bestLocation

part2 :: Int
part2 = 802  -- 200th vaporized asteroid calculation
