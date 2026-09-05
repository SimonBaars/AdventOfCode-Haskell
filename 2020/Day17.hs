import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

-- Day 17: Conway Cubes
-- 3D and 4D Game of Life simulation

type Coord3 = (Int, Int, Int)
type Coord4 = (Int, Int, Int, Int)

input :: [[Char]]
input = unsafePerformIO $ readInputLines 2020 17

-- Part 1: 3D simulation
part1 :: Int
part1 = Set.size $ iterate step3d initialState3d !! 6

initialState3d :: Set.Set Coord3
initialState3d = Set.fromList [(x, y, 0) | (y, row) <- zip [0..] input,
                                            (x, c) <- zip [0..] row,
                                            c == '#']

step3d :: Set.Set Coord3 -> Set.Set Coord3
step3d state = Set.fromList [coord | coord <- candidates, shouldBeActive3d coord state]
  where
    candidates = Set.toList $ Set.unions [neighbors3d coord | coord <- Set.toList state]

neighbors3d :: Coord3 -> Set.Set Coord3
neighbors3d (x, y, z) = Set.fromList [(x+dx, y+dy, z+dz) | 
                                       dx <- [-1..1], dy <- [-1..1], dz <- [-1..1],
                                       (dx, dy, dz) /= (0, 0, 0)]

shouldBeActive3d :: Coord3 -> Set.Set Coord3 -> Bool
shouldBeActive3d coord state = 
    let activeNeighbors = Set.size $ Set.intersection (neighbors3d coord) state
        isActive = Set.member coord state
    in if isActive then activeNeighbors == 2 || activeNeighbors == 3
                   else activeNeighbors == 3

-- Part 2: 4D simulation
part2 :: Int
part2 = Set.size $ iterate step4d initialState4d !! 6

initialState4d :: Set.Set Coord4
initialState4d = Set.fromList [(x, y, 0, 0) | (y, row) <- zip [0..] input,
                                               (x, c) <- zip [0..] row,
                                               c == '#']

step4d :: Set.Set Coord4 -> Set.Set Coord4
step4d state = Set.fromList [coord | coord <- candidates, shouldBeActive4d coord state]
  where
    candidates = Set.toList $ Set.unions [neighbors4d coord | coord <- Set.toList state]

neighbors4d :: Coord4 -> Set.Set Coord4
neighbors4d (x, y, z, w) = Set.fromList [(x+dx, y+dy, z+dz, w+dw) | 
                                          dx <- [-1..1], dy <- [-1..1], 
                                          dz <- [-1..1], dw <- [-1..1],
                                          (dx, dy, dz, dw) /= (0, 0, 0, 0)]

shouldBeActive4d :: Coord4 -> Set.Set Coord4 -> Bool
shouldBeActive4d coord state = 
    let activeNeighbors = Set.size $ Set.intersection (neighbors4d coord) state
        isActive = Set.member coord state
    in if isActive then activeNeighbors == 2 || activeNeighbors == 3
                   else activeNeighbors == 3
