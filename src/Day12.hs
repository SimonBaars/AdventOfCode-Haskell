module Day12 (part1, part2) where

import qualified Data.Map as Map
import qualified Data.Set as Set

type Grid = Map.Map (Int, Int) Char

parse :: String -> ((Int, Int), (Int, Int), Grid)
parse s =
  let ls = lines s
      cells = [((i, j), c) | (i, row) <- zip [0 ..] ls, (j, c) <- zip [0 ..] row]
      g = Map.fromList cells
      start = head [p | (p, 'S') <- cells]
      end = head [p | (p, 'E') <- cells]
      g' =
        Map.insert start 'a' $
          Map.insert end 'z' g
   in (start, end, g')

neigh :: (Int, Int) -> [(Int, Int)]
neigh (i, j) = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]

canStep :: Grid -> (Int, Int) -> (Int, Int) -> Bool
canStep g from to =
  case (Map.lookup from g, Map.lookup to g) of
    (Just a, Just b) -> fromEnum b - fromEnum a <= 1
    _ -> False

bfs :: Grid -> [(Int, Int)] -> (Int, Int) -> Maybe Int
bfs g starts goal = go (Set.fromList starts) Set.empty 0
  where
    go frontier seen d
      | goal `Set.member` frontier = Just d
      | Set.null frontier = Nothing
      | otherwise =
          let seen' = Set.union seen frontier
              next =
                Set.fromList
                  [ n
                    | p <- Set.toList frontier,
                      n <- neigh p,
                      canStep g p n,
                      Set.notMember n seen'
                  ]
           in go next seen' (d + 1)

part1 :: String -> Int
part1 s =
  let (start, end, g) = parse s
   in case bfs g [start] end of
        Nothing -> error "Day12: no path"
        Just x -> x

part2 :: String -> Int
part2 s =
  let (_, end, g) = parse s
      starts = Map.keys $ Map.filter (== 'a') g
   in case bfs g starts end of
        Nothing -> error "Day12: no path"
        Just x -> x
