-- Day 8: Haunted Wasteland
-- Part 1: Count steps from AAA to ZZZ
-- Part 2: Count steps for all **A nodes to reach **Z (LCM)

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: String
input = unsafePerformIO $ readInput 2023 8

type Network = M.Map String (String, String)

parseInput :: String -> (String, Network)
parseInput str = (instructions, network)
  where
    (instLine:_:nodeLines) = lines str
    instructions = instLine
    network = M.fromList [parseNode line | line <- nodeLines]
    
    parseNode line = (node, (left, right))
      where
        node = take 3 line
        left = take 3 $ drop 7 line
        right = take 3 $ drop 12 line

navigate :: String -> Network -> String -> Int
navigate instructions network start = go 0 start (cycle instructions)
  where
    go steps curr (dir:rest)
        | last curr == 'Z' = steps
        | otherwise = go (steps + 1) next rest
      where
        (left, right) = network M.! curr
        next = if dir == 'L' then left else right

part1 :: Int
part1 = navigate instructions network "AAA"
  where
    (instructions, network) = parseInput input

part2 :: Integer
part2 = foldl lcm 1 [toInteger $ navigate instructions network start | start <- starts]
  where
    (instructions, network) = parseInput input
    starts = filter (\s -> last s == 'A') $ M.keys network
