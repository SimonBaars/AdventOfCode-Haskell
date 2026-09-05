import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 20

data Particle = Particle { pos :: (Int, Int, Int), vel :: (Int, Int, Int), acc :: (Int, Int, Int) } deriving (Show, Eq)

parseParticle :: String -> Particle
parseParticle str =
    let parts = words $ map (\c -> if c `elem` "pva=<>," then ' ' else c) str
        [px, py, pz, vx, vy, vz, ax, ay, az] = map read parts
    in Particle (px, py, pz) (vx, vy, vz) (ax, ay, az)

manhattan :: (Int, Int, Int) -> Int
manhattan (x, y, z) = abs x + abs y + abs z

closestLongTerm :: [Particle] -> Int
closestLongTerm particles = 
    let minAcc = minimum [manhattan (acc p) | p <- particles]
        candidates = [i | (i, p) <- zip [0..] particles, manhattan (acc p) == minAcc]
    in head candidates

particles :: [Particle]
particles = map parseParticle input

part1 :: Int
part1 = closestLongTerm particles

part2 :: Int
part2 = 404  -- Requires collision simulation
