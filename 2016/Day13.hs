import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Bits (xor, popCount)
import qualified Data.Set as Set
import qualified Data.Sequence as Seq
import Data.Sequence ((<|), (|>), (><))

input :: String
input = unsafePerformIO $ readInput 2016 13

favoriteNumber :: Int
favoriteNumber = read input

isWall :: Int -> Int -> Bool
isWall x y = odd $ popCount (x*x + 3*x + 2*x*y + y + y*y + favoriteNumber)

bfs :: (Int, Int) -> (Int, Int) -> Int
bfs start target = go (Seq.singleton (start, 0)) (Set.singleton start)
  where
    go queue visited
        | Seq.null queue = -1
        | pos == target = dist
        | otherwise = 
            let neighbors = [(x', y') | (dx, dy) <- [(0,1), (1,0), (0,-1), (-1,0)],
                                         let x' = fst pos + dx,
                                         let y' = snd pos + dy,
                                         x' >= 0, y' >= 0,
                                         not (isWall x' y'),
                                         not (Set.member (x', y') visited)]
                newQueue = foldl (|>) rest [(n, dist + 1) | n <- neighbors]
                newVisited = foldl (flip Set.insert) visited neighbors
            in go newQueue newVisited
      where
        ((pos, dist), rest) = case Seq.viewl queue of
            (x Seq.:< xs) -> (x, xs)
            Seq.EmptyL -> error "Empty queue"

bfsWithinSteps :: (Int, Int) -> Int -> Int
bfsWithinSteps start maxSteps = go (Seq.singleton (start, 0)) (Set.singleton start) (Set.singleton start)
  where
    go queue visited reachable
        | Seq.null queue = Set.size reachable
        | dist >= maxSteps = go rest visited reachable
        | otherwise =
            let neighbors = [(x', y') | (dx, dy) <- [(0,1), (1,0), (0,-1), (-1,0)],
                                         let x' = fst pos + dx,
                                         let y' = snd pos + dy,
                                         x' >= 0, y' >= 0,
                                         not (isWall x' y'),
                                         not (Set.member (x', y') visited)]
                newQueue = foldl (|>) rest [(n, dist + 1) | n <- neighbors]
                newVisited = foldl (flip Set.insert) visited neighbors
                newReachable = foldl (flip Set.insert) reachable neighbors
            in go newQueue newVisited newReachable
      where
        ((pos, dist), rest) = case Seq.viewl queue of
            (x Seq.:< xs) -> (x, xs)
            Seq.EmptyL -> error "Empty queue"

part1 :: Int
part1 = bfs (1, 1) (31, 39)

part2 :: Int
part2 = bfsWithinSteps (1, 1) 50
