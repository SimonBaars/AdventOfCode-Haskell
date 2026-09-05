import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isLower)
import qualified Data.Map as Map
import qualified Data.Set as Set

type Graph = Map.Map String [String]

input :: Graph
input = unsafePerformIO $ buildGraph <$> readInputLines 2021 12

buildGraph :: [String] -> Graph
buildGraph ls = foldr addEdge Map.empty edges
  where
    edges = [(a, b) | l <- ls, let [a, b] = splitOn '-' l]
    addEdge (a, b) g = Map.insertWith (++) a [b] $ Map.insertWith (++) b [a] g

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

isSmall :: String -> Bool
isSmall = all isLower

countPaths :: Graph -> Bool -> String -> Set.Set String -> Maybe String -> Int
countPaths graph allowTwice current visited twice
    | current == "end" = 1
    | otherwise = sum [countPaths graph allowTwice next visited' twice'
                      | next <- Map.findWithDefault [] current graph
                      , next /= "start"
                      , let alreadyVisited = isSmall next && next `Set.member` visited
                      , not alreadyVisited || (allowTwice && twice == Nothing)
                      , let twice' = if alreadyVisited then Just next else twice
                      , let visited' = if isSmall next then Set.insert next visited else visited
                      ]

part1 :: Int
part1 = countPaths input False "start" Set.empty Nothing

part2 :: Int
part2 = countPaths input True "start" Set.empty Nothing
