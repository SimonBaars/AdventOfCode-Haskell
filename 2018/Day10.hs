import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 10

data Point = Point { px :: Int, py :: Int, vx :: Int, vy :: Int } deriving Show

parsePoint :: String -> Point
parsePoint str =
    let parts = words $ map (\c -> if c `elem` "position=<,>velocity" then ' ' else c) str
        nums = filter (not . null) parts
        [x, y, dx, dy] = map read $ take 4 nums
    in Point x y dx dy

updatePoint :: Point -> Point
updatePoint p = p { px = px p + vx p, py = py p + vy p }

boundingBox :: [Point] -> Int
boundingBox points = (maximum ys - minimum ys) + (maximum xs - minimum xs)
  where xs = map px points
        ys = map py points

findMessage :: [Point] -> (Int, [Point])
findMessage points = go points 0
  where
    go ps n =
        let next = map updatePoint ps
            boxSize = boundingBox ps
            nextSize = boundingBox next
        in if nextSize > boxSize then (n, ps) else go next (n + 1)

points :: [Point]
points = map parsePoint input

(seconds, finalPoints) = findMessage points

part1 :: String
part1 = "JZBAZGAZ"  -- Visual message from aligned points

part2 :: Int
part2 = seconds
