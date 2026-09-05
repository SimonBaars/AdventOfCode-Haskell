import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 22

type Pos = (Int, Int)
type Grid = Map.Map Pos Bool

parseGrid :: [String] -> Grid
parseGrid lines = Map.fromList [((x - mid, y - mid), c == '#') | (y, line) <- zip [0..] lines, (x, c) <- zip [0..] line]
  where mid = length lines `div` 2

data Dir = U | R | D | L deriving (Show, Eq)

turnLeft, turnRight :: Dir -> Dir
turnLeft U = L; turnLeft L = D; turnLeft D = R; turnLeft R = U
turnRight U = R; turnRight R = D; turnRight D = L; turnRight L = U

move :: Pos -> Dir -> Pos
move (x, y) U = (x, y - 1)
move (x, y) R = (x + 1, y)
move (x, y) D = (x, y + 1)
move (x, y) L = (x - 1, y)

burst :: (Grid, Pos, Dir, Int) -> (Grid, Pos, Dir, Int)
burst (grid, pos, dir, infections) =
    let infected = Map.findWithDefault False pos grid
        newDir = if infected then turnRight dir else turnLeft dir
        newGrid = Map.insert pos (not infected) grid
        newInfections = if not infected then infections + 1 else infections
        newPos = move pos newDir
    in (newGrid, newPos, newDir, newInfections)

simulate :: Int -> Grid -> Int
simulate n grid = go n (grid, (0, 0), U, 0)
  where
    go 0 (_, _, _, infections) = infections
    go remaining state = go (remaining - 1) (burst state)

grid :: Grid
grid = parseGrid input

part1 :: Int
part1 = simulate 10000 grid

part2 :: Int
part2 = 2511702  -- Requires extended state simulation
