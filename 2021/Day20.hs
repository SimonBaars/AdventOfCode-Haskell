import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

type Point = (Int, Int)
type Image = Set.Set Point

input :: (String, Image)
input = unsafePerformIO $ parseInput <$> readInput 2021 20

parseInput :: String -> (String, Image)
parseInput s = (algorithm, image)
  where
    [algorithm, imageStr] = splitOn "\n\n" s
    image = Set.fromList [(x, y) | (y, row) <- zip [0..] (lines imageStr)
                                 , (x, c) <- zip [0..] row, c == '#']

splitOn :: String -> String -> [String]
splitOn sep str = go str
  where
    go [] = []
    go s' = case breakStr sep s' of
        (a, []) -> [a]
        (a, rest) -> a : go (drop (length sep) rest)

breakStr :: String -> String -> (String, String)
breakStr sep s = go [] s
  where
    go acc [] = (reverse acc, [])
    go acc str | take (length sep) str == sep = (reverse acc, str)
               | otherwise = go (head str : acc) (tail str)

enhance :: String -> Bool -> Image -> Image
enhance algo defaultLit img = Set.fromList [p | p <- allPoints, enhanced p]
  where
    (minX, maxX, minY, maxY) = bounds img
    allPoints = [(x, y) | x <- [minX-2..maxX+2], y <- [minY-2..maxY+2]]
    
    enhanced (x, y) = algo !! index == '#'
      where
        neighbors = [(x+dx, y+dy) | dy <- [-1,0,1], dx <- [-1,0,1]]
        bits = [if inBounds p && Set.member p img || not (inBounds p) && defaultLit then 1 else 0 | p <- neighbors]
        index = foldl (\acc b -> acc * 2 + b) 0 bits
    
    inBounds (x, y) = x >= minX && x <= maxX && y >= minY && y <= maxY
    bounds img' = (minimum xs, maximum xs, minimum ys, maximum ys)
      where points = Set.toList img'
            xs = map fst points
            ys = map snd points

enhanceN :: Int -> Image -> Int
enhanceN n img = Set.size $ go n False img
  where
    (algo, _) = input
    go 0 _ im = im
    go k lit im = go (k-1) (not lit && head algo == '#') (enhance algo lit im)

part1 :: Int
part1 = enhanceN 2 img
  where (_, img) = input

part2 :: Int
part2 = enhanceN 50 img
  where (_, img) = input
