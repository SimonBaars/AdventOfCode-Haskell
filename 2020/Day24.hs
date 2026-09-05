import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

-- Day 24: Lobby Layout
-- Hexagonal tile flipping

type Coord = (Int, Int)  -- Axial coordinates for hex grid

input :: [[String]]
input = unsafePerformIO $ map parsePath <$> readInputLines 2020 24

parsePath :: String -> [String]
parsePath [] = []
parsePath ('e':rest) = "e" : parsePath rest
parsePath ('s':'e':rest) = "se" : parsePath rest
parsePath ('s':'w':rest) = "sw" : parsePath rest
parsePath ('w':rest) = "w" : parsePath rest
parsePath ('n':'e':rest) = "ne" : parsePath rest
parsePath ('n':'w':rest) = "nw" : parsePath rest
parsePath _ = error "Invalid direction"

-- Move in hex grid (axial coordinates)
move :: Coord -> String -> Coord
move (q, r) "e"  = (q+1, r)
move (q, r) "se" = (q, r+1)
move (q, r) "sw" = (q-1, r+1)
move (q, r) "w"  = (q-1, r)
move (q, r) "nw" = (q, r-1)
move (q, r) "ne" = (q+1, r-1)
move _ _ = error "Invalid direction"

-- Follow path from origin
followPath :: [String] -> Coord
followPath = foldl move (0, 0)

-- Part 1: Count black tiles after initial flips
part1 :: Int
part1 = Set.size initialBlack
  where
    initialBlack = foldl flipTile Set.empty (map followPath input)
    flipTile tiles coord = if coord `Set.member` tiles
                          then Set.delete coord tiles
                          else Set.insert coord tiles

-- Part 2: Simulate 100 days of flipping
part2 :: Int
part2 = Set.size $ iterate step initialBlack !! 100
  where
    initialBlack = foldl flipTile Set.empty (map followPath input)
    flipTile tiles coord = if coord `Set.member` tiles
                          then Set.delete coord tiles
                          else Set.insert coord tiles

neighbors :: Coord -> [Coord]
neighbors coord = [move coord dir | dir <- ["e", "se", "sw", "w", "nw", "ne"]]

step :: Set.Set Coord -> Set.Set Coord
step black = Set.fromList [coord | coord <- candidates, shouldBeBlack coord]
  where
    candidates = Set.toList black ++ concatMap neighbors (Set.toList black)
    shouldBeBlack coord = 
        let blackNeighbors = length $ filter (`Set.member` black) (neighbors coord)
            isBlack = coord `Set.member` black
        in if isBlack
           then blackNeighbors == 1 || blackNeighbors == 2
           else blackNeighbors == 2
