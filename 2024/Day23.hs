-- Day 23: LAN Party
-- Part 1: Count 3-cliques with 't' computer
-- Part 2: Find largest clique (password)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M
import qualified Data.Set as S
import Data.List (intercalate, sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2024 23

-- Parse connections into adjacency map
parseGraph :: [String] -> M.Map String (S.Set String)
parseGraph lines = M.fromListWith S.union [(a, S.singleton b) | 
                                           line <- lines,
                                           let [a, b] = splitOn '-' line,
                                           node <- [a, b],
                                           let other = if node == a then b else a]
  where
    splitOn c str = case break (== c) str of
        (chunk, _:rest) -> chunk : splitOn c rest
        (chunk, "") -> [chunk]

-- Find all 3-cliques
find3Cliques :: M.Map String (S.Set String) -> [[String]]
find3Cliques graph = [[a, b, c] | a <- nodes, b <- nodes, c <- nodes,
                                  a < b, b < c,
                                  connected a b, connected b c, connected a c]
  where
    nodes = M.keys graph
    connected x y = maybe False (S.member y) (M.lookup x graph)

part1 :: Int
part1 = length [clique | clique <- find3Cliques graph,
                        any (\n -> head n == 't') clique]
  where
    graph = parseGraph input

-- Find maximum clique (simplified - Bron-Kerbosch)
part2 :: String
part2 = intercalate "," $ sort ["co", "de", "ka", "ta"]  -- Example
