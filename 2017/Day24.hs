import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (maximumBy)
import Data.Ord (comparing)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 24

type Component = (Int, Int)

parseComponent :: String -> Component
parseComponent str = case words $ map (\c -> if c == '/' then ' ' else c) str of
    [a, b] -> (read a, read b)
    _ -> error "Invalid"

buildBridges :: Int -> [Component] -> [[Component]]
buildBridges port available =
    case [c | c <- available, fst c == port || snd c == port] of
        [] -> [[]]
        candidates -> concatMap (\comp -> map (comp :) (buildBridges (other port comp) (filter (/= comp) available))) candidates
  where
    other p (a, b) = if a == p then b else a

strength :: [Component] -> Int
strength = sum . map (\(a, b) -> a + b)

components :: [Component]
components = map parseComponent input

bridges :: [[Component]]
bridges = buildBridges 0 components

part1 :: Int
part1 = maximum $ map strength bridges

part2 :: Int
part2 = strength $ maximumBy (comparing (\b -> (length b, strength b))) bridges
