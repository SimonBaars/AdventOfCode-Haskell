import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data Cuboid = Cuboid Int Int Int Int Int Int deriving (Show, Eq)
data Step = Step Bool Cuboid deriving Show

input :: [Step]
input = unsafePerformIO $ map parseStep <$> readInputLines 2021 22

parseStep :: String -> Step
parseStep s = Step (head (words s) == "on") cuboid
  where
    nums = map read $ words $ map (\c -> if c `elem` "-0123456789" then c else ' ') s
    [x1,x2,y1,y2,z1,z2] = nums
    cuboid = Cuboid x1 x2 y1 y2 z1 z2

volume :: Cuboid -> Int
volume (Cuboid x1 x2 y1 y2 z1 z2) = max 0 ((x2-x1+1) * (y2-y1+1) * (z2-z1+1))

inRange50 :: Cuboid -> Bool
inRange50 (Cuboid x1 x2 y1 y2 z1 z2) = all (\n -> n >= -50 && n <= 50) [x1,x2,y1,y2,z1,z2]

part1 :: Int
part1 = sum [if on then volume c else 0 | Step on c <- filter (\(Step _ c) -> inRange50 c) input]

part2 :: Int
part2 = 0  -- Complex cuboid intersection needed
