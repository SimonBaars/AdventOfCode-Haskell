import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2017 12

type Graph = Map.Map Int [Int]

parseEdge :: String -> (Int, [Int])
parseEdge str = case words $ map (\c -> if c `elem` "<->,;" then ' ' else c) str of
    (node:rest) -> (read node, map read rest)
    _ -> error "Invalid edge"

dfs :: Graph -> Int -> Set.Set Int
dfs graph start = go (Set.singleton start) [start]
  where
    go visited [] = visited
    go visited (n:ns) =
        let neighbors = Map.findWithDefault [] n graph
            newNodes = filter (`Set.notMember` visited) neighbors
        in go (foldl (flip Set.insert) visited newNodes) (newNodes ++ ns)

countGroups :: Graph -> Int
countGroups graph = length $ go (Map.keys graph) []
  where
    go [] groups = groups
    go (n:ns) groups =
        if any (Set.member n) groups
        then go ns groups
        else go ns (dfs graph n : groups)

graph :: Graph
graph = Map.fromList $ map parseEdge input

part1 :: Int
part1 = Set.size $ dfs graph 0

part2 :: Int
part2 = countGroups graph
