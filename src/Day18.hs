module Day18 (part1, part2) where

import qualified Data.Set as Set

type Pt = (Int, Int, Int)

parse :: String -> Set.Set Pt
parse = Set.fromList . map parseLine . lines

parseLine :: String -> Pt
parseLine s =
  case break (== ',') s of
    (a, ',' : rest) ->
      case break (== ',') rest of
        (b, ',' : c) -> (read a, read b, read c)
        _ -> error "Day18: line"
    _ -> error "Day18: line"

neighbors :: Pt -> [Pt]
neighbors (x, y, z) =
  [ (x + 1, y, z),
    (x - 1, y, z),
    (x, y + 1, z),
    (x, y - 1, z),
    (x, y, z + 1),
    (x, y, z - 1)
  ]

exposedFaces :: Set.Set Pt -> Int
exposedFaces s =
  sum
    [ 1
      | p <- Set.toList s,
        n <- neighbors p,
        not (n `Set.member` s)
    ]

floodExterior :: Set.Set Pt -> Set.Set Pt
floodExterior cubes =
  let xs = map (\(x, _, _) -> x) $ Set.toList cubes
      ys = map (\(_, y, _) -> y) $ Set.toList cubes
      zs = map (\(_, _, z) -> z) $ Set.toList cubes
      minX = minimum xs - 1
      maxX = maximum xs + 1
      minY = minimum ys - 1
      maxY = maximum ys + 1
      minZ = minimum zs - 1
      maxZ = maximum zs + 1
      start = (minX, minY, minZ)
      inRange (x, y, z) =
        x >= minX && x <= maxX && y >= minY && y <= maxY && z >= minZ && z <= maxZ
      go seen [] = seen
      go seen (p : ps)
        | p `Set.member` seen = go seen ps
        | p `Set.member` cubes = go seen ps
        | not (inRange p) = go seen ps
        | otherwise =
            let seen' = Set.insert p seen
                nbrs = filter inRange $ neighbors p
             in go seen' (nbrs ++ ps)
   in go Set.empty [start]

surfaceTouchingExterior :: Set.Set Pt -> Set.Set Pt -> Int
surfaceTouchingExterior cubes exterior =
  sum
    [ 1
      | p <- Set.toList cubes,
        n <- neighbors p,
        n `Set.member` exterior
    ]

part1 :: String -> Int
part1 = exposedFaces . parse

part2 :: String -> Int
part2 s =
  let cubes = parse s
      exterior = floodExterior cubes
   in surfaceTouchingExterior cubes exterior
