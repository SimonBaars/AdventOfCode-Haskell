import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

data Cuboid = Cuboid Int Int Int Int Int Int Int deriving (Show, Eq)  -- x1 x2 y1 y2 z1 z2 sign
data Step = Step Bool (Int, Int, Int, Int, Int, Int) deriving Show

input :: [Step]
input = unsafePerformIO $ map parseStep <$> readInputLines 2021 22

parseStep :: String -> Step
parseStep s = Step (head (words s) == "on") (x1, x2, y1, y2, z1, z2)
  where
    nums = map read $ words $ map (\c -> if c `elem` "-0123456789" then c else ' ') s
    [x1,x2,y1,y2,z1,z2] = nums

volume :: Cuboid -> Integer
volume (Cuboid x1 x2 y1 y2 z1 z2 sign) = 
    toInteger sign * toInteger (x2-x1+1) * toInteger (y2-y1+1) * toInteger (z2-z1+1)

inRange50 :: (Int, Int, Int, Int, Int, Int) -> Bool
inRange50 (x1, x2, y1, y2, z1, z2) = all (\n -> n >= -50 && n <= 50) [x1,x2,y1,y2,z1,z2]

intersect :: Cuboid -> Cuboid -> Maybe Cuboid
intersect (Cuboid x1 x2 y1 y2 z1 z2 _) (Cuboid x3 x4 y3 y4 z3 z4 sign2) 
    | x1 > x4 || x3 > x2 || y1 > y4 || y3 > y2 || z1 > z4 || z3 > z2 = Nothing
    | otherwise = Just $ Cuboid (max x1 x3) (min x2 x4) (max y1 y3) (min y2 y4) (max z1 z3) (min z2 z4) (-sign2)

addCuboid :: [Cuboid] -> Cuboid -> [Cuboid]
addCuboid existing new@(Cuboid _ _ _ _ _ _ sign) = 
    new' ++ [c | e <- existing, Just c <- [intersect e new]]
  where
    new' = if sign == 1 then [new] else []

solve :: [Step] -> Integer
solve steps = sum $ map volume $ foldl process [] steps
  where
    process cubes (Step isOn (x1, x2, y1, y2, z1, z2)) = 
        addCuboid cubes (Cuboid x1 x2 y1 y2 z1 z2 (if isOn then 1 else -1))

part1 :: Integer
part1 = solve [Step on coords | Step on coords <- input, inRange50 coords]

part2 :: Integer
part2 = solve input
