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

updateParticle :: Particle -> Particle
updateParticle p = 
    let (vx, vy, vz) = vel p
        (ax, ay, az) = acc p
        newVel = (vx + ax, vy + ay, vz + az)
        (px, py, pz) = pos p
        (nvx, nvy, nvz) = newVel
        newPos = (px + nvx, py + nvy, pz + nvz)
    in p { pos = newPos, vel = newVel }

simulateCollisions :: [Particle] -> Int -> [Particle]
simulateCollisions ps 0 = ps
simulateCollisions ps n =
    let updated = map updateParticle ps
        positions = map pos updated
        duplicates = [p | p <- positions, length (filter (== p) positions) > 1]
        remaining = filter (\p -> pos p `notElem` duplicates) updated
    in simulateCollisions remaining (n - 1)

part2 :: Int
part2 = length $ simulateCollisions particles 100
