import Data.List (nub, permutations)
import qualified Data.Map.Strict as M
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 9

parse :: String -> ((String,String), Int)
parse line =
  let ws = words line
  in ((ws!!0, ws!!2), read (ws!!4))

dists :: M.Map (String,String) Int
dists = M.fromList $ concatMap (\((a,b),d) -> [((a,b),d),((b,a),d)]) $ map parse input

cities :: [String]
cities = nub $ concatMap (\((a,b),_) -> [a,b]) $ map parse input

route :: [String] -> Int
route cs = sum [dists M.! (a,b) | (a,b) <- zip cs (tail cs)]

part1 :: Int
part1 = minimum $ map route $ permutations cities

part2 :: Int
part2 = maximum $ map route $ permutations cities
