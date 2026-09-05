-- Day 16: The Floor Will Be Lava
-- Part 1: Count energized tiles from beam at top-left
-- Part 2: Find maximum energized tiles from any edge

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2023 16

type Pos = (Int, Int)
type Dir = (Int, Int)  -- (row delta, col delta)
type Beam = (Pos, Dir)

-- Get next positions and directions after hitting a tile
nextBeams :: [String] -> Beam -> [Beam]
nextBeams grid ((r, c), (dr, dc))
    | r < 0 || r >= rows || c < 0 || c >= cols = []
    | otherwise = map (\(dr', dc') -> ((r + dr', c + dc'), (dr', dc'))) dirs
  where
    rows = length grid
    cols = length (head grid)
    tile = grid !! r !! c
    
    dirs = case (tile, (dr, dc)) of
        ('.', _) -> [(dr, dc)]
        ('|', (0, _)) -> [(-1, 0), (1, 0)]  -- Horizontal beam hits |
        ('|', _) -> [(dr, dc)]
        ('-', (_, 0)) -> [(0, -1), (0, 1)]  -- Vertical beam hits -
        ('-', _) -> [(dr, dc)]
        ('/', (0, 1)) -> [(-1, 0)]   -- Right -> Up
        ('/', (0, -1)) -> [(1, 0)]   -- Left -> Down
        ('/', (1, 0)) -> [(0, -1)]   -- Down -> Left
        ('/', (-1, 0)) -> [(0, 1)]   -- Up -> Right
        ('\\', (0, 1)) -> [(1, 0)]   -- Right -> Down
        ('\\', (0, -1)) -> [(-1, 0)] -- Left -> Up
        ('\\', (1, 0)) -> [(0, 1)]   -- Down -> Right
        ('\\', (-1, 0)) -> [(0, -1)] -- Up -> Left
        _ -> []

-- Simulate beam and count energized tiles
simulate :: [String] -> Beam -> Int
simulate grid start = S.size $ S.map fst visited
  where
    visited = go S.empty [start]
    
    go seen [] = seen
    go seen (beam:rest)
        | beam `S.member` seen = go seen rest
        | otherwise = go (S.insert beam seen) (nextBeams grid beam ++ rest)

part1 :: Int
part1 = simulate input ((0, 0), (0, 1))

part2 :: Int
part2 = maximum $ map (simulate input) startBeams
  where
    rows = length input
    cols = length (head input)
    startBeams = 
        [((0, c), (1, 0)) | c <- [0..cols-1]] ++       -- Top edge going down
        [((rows-1, c), (-1, 0)) | c <- [0..cols-1]] ++ -- Bottom edge going up
        [((r, 0), (0, 1)) | r <- [0..rows-1]] ++       -- Left edge going right
        [((r, cols-1), (0, -1)) | r <- [0..rows-1]]    -- Right edge going left
