import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- Day 12: Rain Risk
-- Navigate a ship with directions and waypoints

data Action = N Int | S Int | E Int | W Int | L Int | R Int | F Int
    deriving (Show, Eq)

input :: [Action]
input = unsafePerformIO $ map parseAction <$> readInputLines 2020 12

parseAction :: String -> Action
parseAction (c:rest) = case c of
    'N' -> N (read rest)
    'S' -> S (read rest)
    'E' -> E (read rest)
    'W' -> W (read rest)
    'L' -> L (read rest)
    'R' -> R (read rest)
    'F' -> F (read rest)
    _ -> error $ "Invalid action: " ++ (c:rest)

-- Part 1: Ship moves with direction
type Position = (Int, Int)
type Direction = Int  -- 0=E, 1=S, 2=W, 3=N

part1 :: Int
part1 = manhattan (fst final)
  where
    final = foldl executeShip ((0, 0), 0) input
    manhattan (x, y) = abs x + abs y

executeShip :: (Position, Direction) -> Action -> (Position, Direction)
executeShip ((x, y), dir) action = case action of
    N n -> ((x, y + n), dir)
    S n -> ((x, y - n), dir)
    E n -> ((x + n, y), dir)
    W n -> ((x - n, y), dir)
    L n -> ((x, y), (dir - n `div` 90) `mod` 4)
    R n -> ((x, y), (dir + n `div` 90) `mod` 4)
    F n -> case dir of
        0 -> ((x + n, y), dir)  -- East
        1 -> ((x, y - n), dir)  -- South
        2 -> ((x - n, y), dir)  -- West
        3 -> ((x, y + n), dir)  -- North
        _ -> error "Invalid direction"

-- Part 2: Waypoint navigation
type Waypoint = (Int, Int)

part2 :: Int
part2 = manhattan (snd final)
  where
    final = foldl executeWaypoint ((10, 1), (0, 0)) input
    manhattan (x, y) = abs x + abs y

executeWaypoint :: (Waypoint, Position) -> Action -> (Waypoint, Position)
executeWaypoint ((wx, wy), (sx, sy)) action = case action of
    N n -> ((wx, wy + n), (sx, sy))
    S n -> ((wx, wy - n), (sx, sy))
    E n -> ((wx + n, wy), (sx, sy))
    W n -> ((wx - n, wy), (sx, sy))
    L n -> (rotateLeft n (wx, wy), (sx, sy))
    R n -> (rotateRight n (wx, wy), (sx, sy))
    F n -> ((wx, wy), (sx + n * wx, sy + n * wy))

rotateRight :: Int -> Waypoint -> Waypoint
rotateRight 90 (x, y) = (y, -x)
rotateRight 180 (x, y) = (-x, -y)
rotateRight 270 (x, y) = (-y, x)
rotateRight n (x, y) = rotateRight (n `mod` 360) (x, y)

rotateLeft :: Int -> Waypoint -> Waypoint
rotateLeft n wp = rotateRight (360 - n) wp
