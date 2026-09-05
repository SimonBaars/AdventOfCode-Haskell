import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.List (sort)

input :: String
input = unsafePerformIO $ readInput 2019 6

type OrbitMap = Map.Map String String

parseOrbit :: String -> (String, String)
parseOrbit str = let [a, b] = words $ map (\c -> if c == ')' then ' ' else c) str in (b, a)

pathToCOM :: OrbitMap -> String -> [String]
pathToCOM orbits obj
    | obj == "COM" = ["COM"]
    | otherwise = obj : pathToCOM orbits (orbits Map.! obj)

orbits :: OrbitMap
orbits = Map.fromList $ map parseOrbit $ lines input

part1 :: Int
part1 = sum [length (pathToCOM orbits obj) - 1 | obj <- Map.keys orbits]

part2 :: Int
part2 = let youPath = pathToCOM orbits "YOU"
            sanPath = pathToCOM orbits "SAN"
            common = head [obj | obj <- youPath, obj `elem` sanPath]
        in length (takeWhile (/= common) youPath) + length (takeWhile (/= common) sanPath) - 2
