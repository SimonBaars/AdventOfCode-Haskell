import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2018 3

data Claim = Claim { cid :: Int, x :: Int, y :: Int, w :: Int, h :: Int } deriving Show

parseClaim :: String -> Claim
parseClaim str =
    let parts = words $ map (\c -> if c `elem` "#@,:x" then ' ' else c) str
        [id', x', y', w', h'] = map read parts
    in Claim id' x' y' w' h'

allPoints :: Claim -> [(Int, Int)]
allPoints c = [(x' + dx, y' + dy) | dx <- [0..w c - 1], dy <- [0..h c - 1]]
  where (x', y') = (x c, y c)

claims :: [Claim]
claims = map parseClaim input

part1 :: Int
part1 = Set.size $ Set.fromList [p | p <- concat $ map allPoints claims, length [c | c <- claims, p `elem` allPoints c] > 1]

part2 :: Int
part2 = head [cid c | c <- claims, all (\p -> length [c' | c' <- claims, p `elem` allPoints c'] == 1) (allPoints c)]
