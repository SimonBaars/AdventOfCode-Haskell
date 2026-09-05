import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (permutations)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2015 13

parseHappiness :: String -> ((String, String), Int)
parseHappiness line = ((person1, person2), happiness)
  where
    ws = words line
    person1 = head ws
    person2 = init $ last ws
    sign = if ws !! 2 == "gain" then 1 else -1
    happiness = sign * read (ws !! 3)

happiness :: Map.Map (String, String) Int -> [String] -> Int
happiness hmap seating = sum [hmap Map.! (a, b) + hmap Map.! (b, a) | (a, b) <- zip seating (tail seating ++ [head seating])]

part1 :: Int
part1 = maximum [happiness hmap perm | perm <- permutations people]
  where
    hmap = Map.fromList $ map parseHappiness input
    people = foldr (\line acc -> let p = head $ words line in if p `notElem` acc then p:acc else acc) [] input

part2 :: Int
part2 = maximum [happiness hmap' perm | perm <- permutations ("Me":people)]
  where
    hmap = Map.fromList $ map parseHappiness input
    people = foldr (\line acc -> let p = head $ words line in if p `notElem` acc then p:acc else acc) [] input
    hmap' = Map.union hmap $ Map.fromList [((p, "Me"), 0) | p <- "Me":people] ++ [((a"Me", p), 0) | p <- "Me":people]
