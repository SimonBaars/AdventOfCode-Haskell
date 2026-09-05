import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: ((Int, Int), (Int, Int))
input = unsafePerformIO $ parseInput <$> readInput 2021 17

parseInput :: String -> ((Int, Int), (Int, Int))
parseInput s = ((x1, x2), (y1, y2))
  where
    nums = words $ map (\c -> if c `elem` "0123456789-" then c else ' ') s
    [x1, x2, y1, y2] = map read $ filter (not . null) nums

simulate :: (Int, Int) -> ((Int, Int), (Int, Int)) -> Maybe Int
simulate (vx, vy) ((x1, x2), (y1, y2)) = go 0 0 vx vy 0
  where
    go x y vx' vy' maxY
        | x > x2 || y < y1 = Nothing
        | x >= x1 && x <= x2 && y >= y1 && y <= y2 = Just maxY
        | otherwise = go (x + vx') (y + vy') (max 0 (vx' - 1)) (vy' - 1) (max maxY (y + vy'))

allTrajectories :: ((Int, Int), (Int, Int)) -> [(Int, Int, Int)]
allTrajectories target@((_, x2), (y1, _)) = 
    [(vx, vy, h) | vx <- [1..x2], vy <- [y1..500], Just h <- [simulate (vx, vy) target]]

part1 :: Int
part1 = maximum [h | (_, _, h) <- allTrajectories input]

part2 :: Int
part2 = length $ allTrajectories input
