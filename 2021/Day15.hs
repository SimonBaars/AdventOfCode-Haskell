import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array
import qualified Data.Set as Set
import qualified Data.Map as Map

type Grid = Array (Int, Int) Int

input :: Grid
input = unsafePerformIO $ parseGrid <$> readInputLines 2021 15

parseGrid :: [String] -> Grid
parseGrid ls = listArray ((0,0), (h-1,w-1)) [read [c] | row <- ls, c <- row]
  where h = length ls
        w = length (head ls)

neighbors4 :: (Int, Int) -> [(Int, Int)]
neighbors4 (x, y) = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]

dijkstra :: Grid -> Int
dijkstra grid = go (Set.singleton (0, (0, 0))) (Map.singleton (0, 0) 0)
  where
    (_, end) = bounds grid
    go queue distances
        | current == end = cost
        | otherwise = go queue'' distances'
      where
        ((cost, current), queue') = Set.deleteFindMin queue
        ns = [(n, grid ! n) | n <- neighbors4 current, inRange (bounds grid) n]
        betterNeighbors = [(n, cost + risk) | (n, risk) <- ns
                          , cost + risk < Map.findWithDefault maxBound n distances]
        distances' = foldr (\(n, c) -> Map.insert n c) distances betterNeighbors
        queue'' = foldr Set.insert queue' [(c, n) | (n, c) <- betterNeighbors]

part1 :: Int
part1 = dijkstra input

expandGrid :: Grid -> Grid
expandGrid g = listArray ((0, 0), (5*h-1, 5*w-1)) vals
  where
    ((0, 0), (h-1, w-1)) = bounds g
    vals = [wrap ((g ! (x `mod` h, y `mod` w)) + (x `div` h) + (y `div` w))
           | x <- [0..5*h-1], y <- [0..5*w-1]]
    wrap n = ((n - 1) `mod` 9) + 1

part2 :: Int
part2 = dijkstra (expandGrid input)
