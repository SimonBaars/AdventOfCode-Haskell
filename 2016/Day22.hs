import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf)
import Data.Char (isDigit)
import qualified Data.Set as Set
import qualified Data.Sequence as Seq
import Data.Sequence ((|>))

input :: [String]
input = unsafePerformIO $ readInputLines 2016 22

data Node = Node { nx :: Int, ny :: Int, nsize :: Int, nused :: Int, navail :: Int } deriving (Show, Eq)

parseNode :: String -> Maybe Node
parseNode str
    | "/dev/grid/node" `isPrefixOf` (dropWhile (/= '/') str) || "/dev/grid/node" `elem` words str =
        case words str of
          (name:s:u:a:_) ->
            let coords = [read w | w <- splitName name, all isDigit w]
            in case coords of
                 (x:y:_) -> Just $ Node x y (readInt s) (readInt u) (readInt a)
                 _ -> Nothing
          _ -> Nothing
    | otherwise = Nothing
  where
    readInt = read . takeWhile isDigit
    splitName = words . map (\c -> if c == '-' || c == 'x' || c == 'y' then ' ' else c)

nodes :: [Node]
nodes = [n | Just n <- map parseNode input]

viablePairs :: [Node] -> Int
viablePairs ns = length [(a, b) | a <- ns, b <- ns, nused a > 0, a /= b, nused a <= navail b]

part1 :: Int
part1 = viablePairs nodes

-- Part 2: move empty around walls, then shuttle goal data home
part2 :: Int
part2 =
  let maxX = maximum (map nx nodes)
      empty = head [n | n <- nodes, nused n == 0]
      walls = Set.fromList [(nx n, ny n) | n <- nodes, nused n > nsize empty]
      start = (nx empty, ny empty)
      target = (maxX - 1, 0)
      dist = bfs start target walls maxX (maximum (map ny nodes))
  in dist + 1 + 5 * (maxX - 1)

bfs :: (Int,Int) -> (Int,Int) -> Set.Set (Int,Int) -> Int -> Int -> Int
bfs start target walls maxX maxY = go (Seq.singleton (start, 0)) (Set.singleton start)
  where
    go q seen
      | Seq.null q = error "no path"
      | pos == target = d
      | otherwise =
          let neigh = [(x',y') | (dx,dy) <- [(0,1),(1,0),(0,-1),(-1,0)],
                                 let x' = fst pos + dx; y' = snd pos + dy,
                                 x' >= 0, y' >= 0, x' <= maxX, y' <= maxY,
                                 not (Set.member (x',y') walls),
                                 not (Set.member (x',y') seen)]
              q' = foldl (|>) rest [(n, d+1) | n <- neigh]
              seen' = foldl (flip Set.insert) seen neigh
          in go q' seen'
      where
        ((pos,d), rest) = case Seq.viewl q of
          (x Seq.:< xs) -> (x, xs)
          Seq.EmptyL -> error "empty"
