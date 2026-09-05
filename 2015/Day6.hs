import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Array as Array
import Text.Regex.Posix ((=~))

-- Day 6: Probably a Fire Hazard
-- Control 1000x1000 grid of lights

type Coord = (Int, Int)
type Grid = Array.Array Coord Int

input :: [String]
input = unsafePerformIO $ readInputLines 2015 6

parseInstruction :: String -> (String, Coord, Coord)
parseInstruction line = 
    let (_ :: String, _ :: String, _ :: String, coords :: [String]) = line =~ "([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)" :: (String, String, String, [String])
        [x1, y1, x2, y2] = map read coords
        cmd | "toggle" `elem` words line = "toggle"
            | "turn on" `elem` words line = "on"
            | otherwise = "off"
    in (cmd, (x1, y1), (x2, y2))

-- Part 1: Boolean lights
applyInstruction1 :: Grid -> (String, Coord, Coord) -> Grid
applyInstruction1 grid (cmd, (x1, y1), (x2, y2)) =
    grid Array.// [((x, y), newVal x y) | x <- [x1..x2], y <- [y1..y2]]
  where
    newVal x y = case cmd of
        "on" -> 1
        "off" -> 0
        "toggle" -> 1 - grid Array.! (x, y)

part1 :: Int
part1 = sum $ Array.elems finalGrid
  where
    instructions = map parseInstruction input
    initialGrid = Array.listArray ((0,0), (999,999)) (repeat 0)
    finalGrid = foldl applyInstruction1 initialGrid instructions

-- Part 2: Brightness levels
applyInstruction2 :: Grid -> (String, Coord, Coord) -> Grid
applyInstruction2 grid (cmd, (x1, y1), (x2, y2)) =
    grid Array.// [((x, y), max 0 (newVal x y)) | x <- [x1..x2], y <- [y1..y2]]
  where
    newVal x y = case cmd of
        "on" -> grid Array.! (x, y) + 1
        "off" -> grid Array.! (x, y) - 1
        "toggle" -> grid Array.! (x, y) + 2

part2 :: Int
part2 = sum $ Array.elems finalGrid
  where
    instructions = map parseInstruction input
    initialGrid = Array.listArray ((0,0), (999,999)) (repeat 0)
    finalGrid = foldl applyInstruction2 initialGrid instructions
