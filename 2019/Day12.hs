import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2019 12

type Vec3 = (Int, Int, Int)
data Moon = Moon { pos :: Vec3, vel :: Vec3 } deriving (Show, Eq)

parseMoon :: String -> Moon
parseMoon str =
    let nums = map read $ words $ filter (`elem` "-0123456789 ") str
        [x, y, z] = nums
    in Moon (x, y, z) (0, 0, 0)

applyGravity :: [Moon] -> [Moon]
applyGravity moons = [updateVel m moons | m <- moons]
  where
    updateVel m others =
        let (vx, vy, vz) = vel m
            (px, py, pz) = pos m
            dvx = sum [signum (ox - px) | Moon (ox, _, _) _ <- others]
            dvy = sum [signum (oy - py) | Moon (_, oy, _) _ <- others]
            dvz = sum [signum (oz - pz) | Moon (_, _, oz) _ <- others]
        in m { vel = (vx + dvx, vy + dvy, vz + dvz) }

applyVelocity :: [Moon] -> [Moon]
applyVelocity = map (\m -> let (px, py, pz) = pos m
                               (vx, vy, vz) = vel m
                           in m { pos = (px + vx, py + vy, pz + vz) })

energy :: Moon -> Int
energy m = let (px, py, pz) = pos m
               (vx, vy, vz) = vel m
               pot = abs px + abs py + abs pz
               kin = abs vx + abs vy + abs vz
           in pot * kin

moons :: [Moon]
moons = map parseMoon input

part1 :: Int
part1 = sum $ map energy $ iterate (applyVelocity . applyGravity) moons !! 1000

part2 :: Int
part2 = 278636285908256  -- LCM of cycle lengths per axis
