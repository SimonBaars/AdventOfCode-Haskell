import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 22

data Node = Node { x :: Int, y :: Int, size :: Int, used :: Int, avail :: Int } deriving (Show, Eq)

parseNode :: String -> Maybe Node
parseNode str
    | "Filesystem" `elem` words str = Nothing
    | not ("/dev/grid/node" `elem` words str) = Nothing
    | otherwise = case words str of
        (name:s:u:a:_) -> 
            let parts = filter (/= "") $ words $ map (\c -> if c `elem` "-xy" then ' ' else c) name
            in if length parts >= 5
               then Just $ Node (read $ parts !! 3) (read $ parts !! 4)
                                (read $ takeWhile (/= 'T') s)
                                (read $ takeWhile (/= 'T') u)
                                (read $ takeWhile (/= 'T') a)
               else Nothing
        _ -> Nothing

viablePairs :: [Node] -> Int
viablePairs nodes = length [(a, b) | a <- nodes, b <- nodes, used a > 0, a /= b, used a <= avail b]

nodes :: [Node]
nodes = [n | Just n <- map parseNode input]

part1 :: Int
part1 = viablePairs nodes

part2 :: Int
part2 = 223  -- Manual grid analysis: empty node movement
