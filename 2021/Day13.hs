import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

type Point = (Int, Int)
data Fold = FoldX Int | FoldY Int deriving Show

input :: (Set.Set Point, [Fold])
input = unsafePerformIO $ parseInput <$> readInput 2021 13

parseInput :: String -> (Set.Set Point, [Fold])
parseInput s = (Set.fromList points, folds)
  where
    [pointsStr, foldsStr] = splitOn "\n\n" s
    points = [(read x, read y) | l <- lines pointsStr, let [x, y] = splitOn ',' l]
    folds = [parseFold l | l <- lines foldsStr]
    parseFold l = let [axis, val] = splitOn '=' $ last $ words l
                  in if axis == "x" then FoldX (read val) else FoldY (read val)

splitOn :: String -> String -> [String]
splitOn sep s = case breakStr sep s of
    (a, []) -> [a]
    (a, rest) -> a : splitOn sep (drop (length sep) rest)

breakStr :: String -> String -> (String, String)
breakStr sep s = go [] s
  where
    go acc [] = (reverse acc, [])
    go acc str | take (length sep) str == sep = (reverse acc, str)
               | otherwise = go (head str : acc) (tail str)

foldPaper :: Set.Set Point -> Fold -> Set.Set Point
foldPaper points (FoldX fx) = Set.map (\(x, y) -> (if x > fx then 2*fx - x else x, y)) points
foldPaper points (FoldY fy) = Set.map (\(x, y) -> (x, if y > fy then 2*fy - y else y)) points

part1 :: Int
part1 = Set.size $ foldPaper points (head folds)
  where (points, folds) = input

part2 :: Int
part2 = Set.size $ foldl foldPaper points folds
  where (points, folds) = input
