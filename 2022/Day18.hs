-- Day 18: Boiling Boulders
-- 3D surface area calculation
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

type Pos3D = (Int, Int, Int)

input :: [Pos3D]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 18
    return [parsePos line | line <- lines]
  where
    parsePos line = (x, y, z)
      where
        [x, y, z] = map read $ splitOn ',' line
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

neighbors :: Pos3D -> [Pos3D]
neighbors (x, y, z) = 
    [(x+1,y,z), (x-1,y,z), (x,y+1,z), (x,y-1,z), (x,y,z+1), (x,y,z-1)]

part1 :: Int
part1 = sum [length $ filter (`S.notMember` cubes) $ neighbors pos | pos <- input]
  where
    cubes = S.fromList input

part2 :: Int
part2 = length [n | pos <- input, n <- neighbors pos, isExterior n]
  where
    cubes = S.fromList input
    (minX, maxX) = (minimum [x | (x,_,_) <- input] - 1, maximum [x | (x,_,_) <- input] + 1)
    (minY, maxY) = (minimum [y | (_,y,_) <- input] - 1, maximum [y | (_,y,_) <- input] + 1)
    (minZ, maxZ) = (minimum [z | (_,_,z) <- input] - 1, maximum [z | (_,_,z) <- input] + 1)
    
    isExterior pos = bfs (S.singleton (minX, minY, minZ)) S.empty
      where
        bfs queue visited
            | S.null queue = False
            | pos `S.member` visited = True
            | otherwise = bfs newQueue newVisited
          where
            curr = S.findMin queue
            rest = S.delete curr queue
            newVisited = S.insert curr visited
            validNeighbors = filter (\(x,y,z) -> x >= minX && x <= maxX && 
                                                  y >= minY && y <= maxY && 
                                                  z >= minZ && z <= maxZ &&
                                                  (x,y,z) `S.notMember` cubes &&
                                                  (x,y,z) `S.notMember` visited) $ neighbors curr
            newQueue = foldr S.insert rest validNeighbors
