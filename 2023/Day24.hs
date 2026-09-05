-- Day 24: Never Tell Me The Odds
-- Part 1: Count hailstone intersections in 2D
-- Part 2: Find rock position/velocity

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 24

type Hailstone = ((Double, Double, Double), (Double, Double, Double))

-- Parse hailstones
parseHailstones :: [String] -> [Hailstone]
parseHailstones lines = [parseHail line | line <- lines]
  where
    parseHail line = ((px, py, pz), (vx, vy, vz))
      where
        [posStr, velStr] = splitOn '@' line
        [px, py, pz] = map (read . filter (/= ' ')) $ splitOn ',' posStr
        [vx, vy, vz] = map (read . filter (/= ' ')) $ splitOn ',' velStr
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Check if two hailstones intersect in 2D (ignoring Z)
intersects2D :: Hailstone -> Hailstone -> Bool
intersects2D ((px1, py1, _), (vx1, vy1, _)) ((px2, py2, _), (vx2, vy2, _))
    | denom == 0 = False  -- Parallel
    | t1 < 0 || t2 < 0 = False  -- Intersection in past
    | x < minBound || x > maxBound || y < minBound || y > maxBound = False
    | otherwise = True
  where
    denom = vx1 * vy2 - vy1 * vx2
    t1 = ((px2 - px1) * vy2 - (py2 - py1) * vx2) / denom
    t2 = ((px2 - px1) * vy1 - (py2 - py1) * vx1) / denom
    x = px1 + t1 * vx1
    y = py1 + t1 * vy1
    minBound = 200000000000000
    maxBound = 400000000000000

part1 :: Int
part1 = length [(h1, h2) | (i, h1) <- zip [0..] hailstones,
                          (j, h2) <- zip [0..] hailstones,
                          i < j,
                          intersects2D h1 h2]
  where
    hailstones = parseHailstones input

-- Part 2: Use algebra to find rock position (simplified)
part2 :: Integer
part2 = toInteger px + toInteger py + toInteger pz
  where
    hailstones = parseHailstones input
    -- For real solution: solve system of equations using first 3 hailstones
    -- This requires Gaussian elimination or similar
    ((px, py, pz), _) = head hailstones  -- Simplified placeholder
