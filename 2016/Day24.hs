import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (permutations)
import Data.Char (isDigit)
import qualified Data.Map as Map
import qualified Data.Set as Set
import qualified Data.Sequence as Seq
import Data.Sequence ((<|), (|>))

input :: [String]
input = unsafePerformIO $ readInputLines 2016 24

type Pos = (Int, Int)
type Grid = Map.Map Pos Char

parseGrid :: [String] -> (Grid, Map.Map Int Pos)
parseGrid lines = (grid, targets)
  where
    grid = Map.fromList [((x, y), c) | (y, line) <- zip [0..] lines, (x, c) <- zip [0..] line]
    targets = Map.fromList [(read [c], (x, y)) | ((x, y), c) <- Map.toList grid, isDigit c]

bfsDistance :: Grid -> Pos -> Pos -> Int
bfsDistance grid start end = go (Seq.singleton (start, 0)) (Set.singleton start)
  where
    go queue visited
        | Seq.null queue = -1
        | pos == end = dist
        | otherwise = 
            let neighbors = [(x', y') | (dx, dy) <- [(0,1), (1,0), (0,-1), (-1,0)],
                                         let (x, y) = pos,
                                         let x' = x + dx,
                                         let y' = y + dy,
                                         Map.findWithDefault '#' (x', y') grid /= '#',
                                         not (Set.member (x', y') visited)]
                newQueue = foldl (|>) rest [(n, dist + 1) | n <- neighbors]
                newVisited = foldl (flip Set.insert) visited neighbors
            in go newQueue newVisited
      where
        ((pos, dist), rest) = case Seq.viewl queue of
            (x Seq.:< xs) -> (x, xs)
            Seq.EmptyL -> error "Empty queue"

shortestPath :: Map.Map Int Pos -> Map.Map (Int, Int) Int -> Bool -> Int
shortestPath targets distances returnToStart =
    minimum [pathLength perm returnToStart | perm <- permutations nonZero]
  where
    nonZero = [i | i <- Map.keys targets, i /= 0]
    pathLength path ret = 
        let steps = zipWith (\a b -> distances Map.! (min a b, max a b)) (0:path) path
            final = if ret then [distances Map.! (min 0 (last path), max 0 (last path))] else []
        in sum steps + sum final

(grid, targets) = parseGrid input
distances = Map.fromList [((min i j, max i j), bfsDistance grid (targets Map.! i) (targets Map.! j))
                         | i <- Map.keys targets, j <- Map.keys targets, i < j]

part1 :: Int
part1 = shortestPath targets distances False

part2 :: Int
part2 = shortestPath targets distances True
