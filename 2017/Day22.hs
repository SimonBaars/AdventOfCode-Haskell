import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 22

type Pos = (Int, Int)

parseGrid :: [String] -> Map.Map Pos Int
parseGrid ls = Map.fromList
  [((x - mid, y - mid), 2) | (y, line) <- zip [0..] ls, (x, c) <- zip [0..] line, c == '#']
  where mid = length ls `div` 2

data Dir = U | R | D | L deriving (Show, Eq)

turnLeft, turnRight, turnAround :: Dir -> Dir
turnLeft U = L; turnLeft L = D; turnLeft D = R; turnLeft R = U
turnRight U = R; turnRight R = D; turnRight D = L; turnRight L = U
turnAround U = D; turnAround D = U; turnAround L = R; turnAround R = L

move :: Pos -> Dir -> Pos
move (x, y) U = (x, y - 1)
move (x, y) R = (x + 1, y)
move (x, y) D = (x, y + 1)
move (x, y) L = (x - 1, y)

-- Part1: Clean/Infected only (False/True mapped as 0/2 conceptually)
simulate1 :: Int -> Map.Map Pos Bool -> Int
simulate1 n g0 = go n g0 (0,0) U 0
  where
    go 0 _ _ _ inf = inf
    go k g pos dir inf =
      let infected = Map.findWithDefault False pos g
          dir' = if infected then turnRight dir else turnLeft dir
          g' = Map.insert pos (not infected) g
          inf' = if not infected then inf + 1 else inf
      in go (k-1) g' (move pos dir') dir' inf'

-- Part2: 0 clean, 1 weakened, 2 infected, 3 flagged
simulate2 :: Int -> Map.Map Pos Int -> Int
simulate2 n g0 = go n g0 (0,0) U 0
  where
    go 0 _ _ _ inf = inf
    go k g pos dir inf =
      let st = Map.findWithDefault 0 pos g
          dir' = case st of
                   0 -> turnLeft dir
                   1 -> dir
                   2 -> turnRight dir
                   _ -> turnAround dir
          st' = (st + 1) `mod` 4
          g' = if st' == 0 then Map.delete pos g else Map.insert pos st' g
          inf' = if st' == 2 then inf + 1 else inf
      in go (k-1) g' (move pos dir') dir' inf'

boolGrid :: Map.Map Pos Bool
boolGrid = Map.map (const True) (parseGrid input)

intGrid :: Map.Map Pos Int
intGrid = parseGrid input

part1 :: Int
part1 = simulate1 10000 boolGrid

part2 :: Int
part2 = simulate2 10000000 intGrid
