import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (permutations)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2015 9

type Distance = Map.Map (String, String) Int

parseDistance :: String -> ((String, String), Int)
parseDistance line = ((from, to), read dist)
  where
    [from, "to", to, "=", dist] = words line

buildDistanceMap :: [String] -> Distance
buildDistanceMap lines' = Map.fromList $ concatMap (\((a, b), d) -> [((a, b), d), ((b, a), d)]) 
                                       $ map parseDistance lines'

getCities :: [String] -> [String]
getCities = foldr (\line acc -> let [from, _, to, _, _] = words line in 
                                 if from `notElem` acc then from : (if to `notElem` acc then to : acc else acc)
                                 else if to `notElem` acc then to : acc else acc) []

routeLength :: Distance -> [String] -> Int
routeLength dists cities = sum [dists Map.! (a, b) | (a, b) <- zip cities (tail cities)]

part1 :: Int
part1 = minimum [routeLength dists perm | perm <- permutations cities]
  where
    dists = buildDistanceMap input
    cities = getCities input

part2 :: Int
part2 = maximum [routeLength dists perm | perm <- permutations cities]
  where
    dists = buildDistanceMap input
    cities = getCities input
